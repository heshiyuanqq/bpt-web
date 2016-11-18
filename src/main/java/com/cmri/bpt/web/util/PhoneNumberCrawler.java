package com.cmri.bpt.web.util;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

import org.androidpn.server.consdef.ConsDef;
import org.androidpn.server.xmpp.push.AbstractNotificationManager;
//import org.androidpn.server.xmpp.push.NotificationManager;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.xmpp.packet.IQ;

import com.cmri.bpt.common.token.TokenGenerator;
import com.cmri.bpt.common.token.TokenSession;
import com.cmri.bpt.common.token.TokenSessionEventListener;
import com.cmri.bpt.common.token.TokenSessionExpireStrategy;
import com.cmri.bpt.common.util.ExceptionUtil;
import com.cmri.bpt.entity.auth.AppTokenSession;
import com.cmri.bpt.entity.push.PushEnum;

public class PhoneNumberCrawler {
	private Lock lock = new ReentrantLock();
	private Logger push_logger = Logger.getLogger("push." + PhoneNumberCrawler.class);
	private Logger plogger = Logger.getLogger(PhoneNumberCrawler.class);
	private List<AppTokenSession> hasPhoneList;
	private List<AppTokenSession> noPhoneList;
	private List<AppTokenSession> noPhoneTryGetList;
	private List<AppTokenSession> noPhoneFailGetList;
	private Map<Integer, Integer> phoneRelation;
	protected List<CrawlListener> crawlListeners = new ArrayList<CrawlListener>();

	public void addCrawlEventListener(CrawlListener listener) {
		if (crawlListeners.indexOf(listener) == -1) {
			this.crawlListeners.add(listener);
		}
	}

	private Integer userId;
	private boolean alive = true;
	public boolean teminate = false;

	public boolean isAlive() {
		return alive;
	}

	enum SyncState {
		Init, Listening, Stop
	}

	private SyncState syncState = SyncState.Init;
	private int retryTimes = 0;

	public void phoneHandle(Integer originalId, Integer teminateId, String phone) {
			if (phone.startsWith("+86")){
				phone = phone.substring(3);
			}
			plogger.debug(teminateId + " get " + originalId + " " + phone);
			if (syncState == SyncState.Listening) {
					lock.lock();
					for (int i = 0; i < noPhoneList.size(); i++) {
							if (noPhoneList.get(i).getId().equals(originalId)
									&& phoneRelation.get(originalId) != null && phoneRelation.get(originalId).equals(teminateId)
							) {
									AppTokenSession aps = noPhoneList.get(i);
									aps.setPhoneNumber(phone);
									noPhoneTryGetList.remove(noPhoneList.get(i));
									noPhoneList.remove(i);
									hasPhoneList.add(aps);
									break;
							}
					}
					lock.unlock();
			}
	}

	public PhoneNumberCrawler(Integer userId, List<AppTokenSession> all) {
			this.userId = userId;
			hasPhoneList = new ArrayList<AppTokenSession>();
			noPhoneList = new ArrayList<AppTokenSession>();
			noPhoneTryGetList = new ArrayList<AppTokenSession>();
			noPhoneFailGetList = new ArrayList<AppTokenSession>();
			for (AppTokenSession s : all) {
					if (s.getPhoneNumber() != null && !s.getPhoneNumber().isEmpty()){
							hasPhoneList.add(s);
					}else{
							noPhoneList.add(s);
					}
			}
			phoneRelation = new HashMap<>();
	}

	public void crawl() {
			CrawlThread crawler = new CrawlThread();
			crawler.start();
	}

	class CrawlThread extends Thread {
		
		@Autowired
		private AbstractNotificationManager notificationManager;
		
		@Override
		public void run() {
			alive = true;
			retryTimes = 0;
			int j = 0;
			while (true && retryTimes < 3) {	
				if(teminate){
					alive=false;
					return;
				}
				phoneRelation.clear();
				plogger.debug(j++ + " retrytimes:" + retryTimes);
				if (noPhoneList.size() == 0) {
					if (noPhoneFailGetList.size() == 0)
						break;
					retryTimes++;
					noPhoneList.addAll(noPhoneFailGetList);
					noPhoneFailGetList.clear();
				}

				int unkonwSize = noPhoneList.size();
				int konwSize = hasPhoneList.size();
				if (konwSize == 0)
					break;
				int min = Math.min(unkonwSize, konwSize);
				// get min begin send
				{
					plogger.debug("进入下发流程……");
					//NotificationManager notificationManager = NotificationManager.getInstance();
					for (int i = 0; i < min; i++) {
						String orignalCall_template = "{'delayTime':5,'phone':%1}";
						String terminateCall_template = "{'delayTime':5,'ueId':%1}";
						orignalCall_template = orignalCall_template.replaceAll("%1",
								String.valueOf(hasPhoneList.get(i).getPhoneNumber()));
						terminateCall_template = terminateCall_template.replaceAll("%1",
								String.valueOf(noPhoneList.get(i).getId()));
						IQ terminateCall = notificationManager.createNotificationIQ(ConsDef.STR_PUSH_API_KEY,
								PushEnum.UeTerminatingCall, terminateCall_template, ConsDef.STR_PUSH_URL);
						IQ orignalCall = notificationManager.createNotificationIQ(ConsDef.STR_PUSH_API_KEY,
								PushEnum.UeOriginatingCall, orignalCall_template, ConsDef.STR_PUSH_URL);
						notificationManager.sendNotifcationToUser(noPhoneList.get(i).getXppId(), orignalCall);
						push_logger.debug(noPhoneList.get(i).getXppId() + " " + orignalCall_template);
						notificationManager.sendNotifcationToUser(hasPhoneList.get(i).getXppId(), terminateCall);
						push_logger.debug(hasPhoneList.get(i).getXppId() + " " + terminateCall_template);
						//记录拨叫关系
						phoneRelation.put(noPhoneList.get(i).getId(), hasPhoneList.get(i).getId());
						noPhoneTryGetList.add(noPhoneList.get(i));
					}
				}
				syncState = SyncState.Listening;
				try {
					Thread.sleep(120000);//参数由30秒修改为120秒 在现网环境下 主叫长时间不挂断 有可能导致错误
				} catch (InterruptedException e) {
					e.printStackTrace();
				}
				// after send
				syncState = SyncState.Stop;
				// get the fail list
				lock.lock();
				try {
					plogger.debug("进入更新流程……");
					for (AppTokenSession s : noPhoneTryGetList)
						noPhoneList.remove(s);
					noPhoneFailGetList.addAll(noPhoneTryGetList);
					noPhoneTryGetList.clear();
				} catch (Exception ee) {
				} finally {
					lock.unlock();
				}
			}
			try {
				plogger.debug("进入完成流程……");
				for (CrawlListener l : crawlListeners)
					l.onFinished(userId, hasPhoneList);
			} catch (Exception eee) {
				plogger.error(ExceptionUtil.getStackTraceAsString(eee));
			}
			alive = false;
		}
	}
}
