package com.cmri.bpt.web.servlet;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import javax.websocket.CloseReason;
import javax.websocket.EndpointConfig;
import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

import org.androidpn.server.service.UserNotFoundException;
import org.androidpn.server.xmpp.session.ClientSession;
import org.androidpn.server.xmpp.session.SessionManager;
import org.apache.log4j.Logger;

import com.cmri.bpt.common.base.Result;
import com.cmri.bpt.common.entity.CaseUeVO;
import com.cmri.bpt.common.entity.SingleUeLogPO;
import com.cmri.bpt.common.msg.MsgRequestCode;
import com.cmri.bpt.common.util.ExceptionUtil;
import com.cmri.bpt.common.util.JsonUtil;
import com.cmri.bpt.entity.auth.AppTokenSession;
import com.cmri.bpt.entity.testcase.TestcaseLog;
import com.cmri.bpt.service.result.getsingleuelog.IGetSingleUeLogService;
import com.cmri.bpt.service.testcase.TestcaseLogService;
import com.cmri.bpt.service.token.AppTokenSessionService;
import com.cmri.bpt.service.ue.AppStatusService;
import com.cmri.bpt.service.ue.bo.AppStatus;
import com.cmri.bpt.web.restor.SpringBeanUtil;

@ServerEndpoint("/tools/ue/v1/loc/realtime")
public class UELocRealtimeServlet {

	static final Logger logger = Logger.getLogger("websocket." + UELocRealtimeServlet.class);

	static boolean init = false;

	private static Map<String, Session> sessions = new HashMap<String, Session>();

	public UELocRealtimeServlet() {

		if (!init) {
			RealtimeLocInfoHolder.startPush();
			init = true;
		}
	}

	public synchronized static void sendAll(String category, Object data) {

		Set<String> keys = sessions.keySet();
		String dataStr = JsonUtil.toJson(data);

		for (String k : keys) {

			Session s = sessions.get(k);

			if (s.isOpen()) {
				try {

					s.getBasicRemote().sendText(dataStr);

				} catch (Exception e) {

					logger.error("发送出错：" + e.getMessage());
				}
			}
		}

		logger.debug("推送的内容为:" + dataStr);
	}

	@OnMessage
	public void onMessage(Session session, String msg) {

	}

	@OnOpen
	public void onOpen(Session session, EndpointConfig config) {
		try {

			sessions.put(session.getId(), session);

			Result<?> result = Result.newOne();

			result.message = "您可以接收全部UE的实时位置了";

			session.getBasicRemote().sendText(JsonUtil.toJson(result));

		} catch (Exception e) {

			logger.error(e);
		}
	}

	@OnError
	public void onError(Session session, Throwable throwable) {

	}

	@OnClose
	public void onClose(Session session, CloseReason reason) {
		try {
			synchronized (sessions) {
				sessions.remove(session.getId());
			}

		} catch (Exception e) {

			logger.error(e);
		}
	}

	// Inner Class for RealTime
	static class RealtimeLocInfoHolder {

		// 快照同步时间间隔
		private static int checkInterval = 6 * 1000;
		// 是否已初始化
		private static boolean initialized = false;
		//

		private static LocInfoSyncThread snapshotSyncer;

		// 定期
		static class LocInfoSyncThread extends Thread {

			@Override
			public void run() {
				while (true) {

					try {
						Thread.sleep(checkInterval);
					} catch (InterruptedException e) {
						e.printStackTrace();
					}

					if (sessions.size() == 0)
						continue;

					try {

						Collection<LocInfoDTO> locInfoSnapshot = getTheRealInfo();

						Result<Collection<LocInfoDTO>> result = Result.newOne();

						result.code = MsgRequestCode.Ue.Ue_Loc_All;
						result.data = locInfoSnapshot;

						sendAll("", result);

					} catch (Exception ee) {
						logger.error(ee.getMessage());
						logger.error(ExceptionUtil.extractMsg(ee));
					}

				}
			}
		}

		public static void startPush() {

			if (!initialized) {
				initialized = true;

				snapshotSyncer = new LocInfoSyncThread();
				snapshotSyncer.start();
			}
		}

		private static List<LocInfoDTO> getTheRealInfo() {

			List<LocInfoDTO> locList = new ArrayList<LocInfoDTO>();

			IGetSingleUeLogService ueLogService = SpringBeanUtil.getBean(IGetSingleUeLogService.class);
			AppStatusService statusService = SpringBeanUtil.getBean(AppStatusService.class);
			AppTokenSessionService tokenSession = SpringBeanUtil.getBean(AppTokenSessionService.class);
			TestcaseLogService tcLogService = SpringBeanUtil.getBean(TestcaseLogService.class);

			List<AppStatus> appStatusList = statusService.queryAll();
			if (appStatusList.size() <= 0)
				return locList;

			List<AppTokenSession> appTokenSessions = tokenSession.queryAll();
			if (appTokenSessions.size() <= 0)
				return locList;

			Map<Integer, AppTokenSession> tokenSessionMap = new HashMap<Integer, AppTokenSession>();
			for (AppTokenSession ts : appTokenSessions) {
				tokenSessionMap.put(ts.getId(), ts);
			}

			Map<Integer, AppStatus> statusMap = new HashMap<Integer, AppStatus>();
			Map<String, Integer> xpp_sessionId_Map = new HashMap<String, Integer>();
			Map<String, Boolean> aliveMap = new HashMap<String, Boolean>();

			String realPath = "";
			{// get the real path
				String path = tokenSession.getClass().getClassLoader().getResource("").getPath();
				String fullPath = "";
				try {
					fullPath = URLDecoder.decode(path, "UTF-8");

				} catch (UnsupportedEncodingException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}

				String pathArr[] = fullPath.split("/WEB-INF/classes/");
				realPath = pathArr[0];
			}

			List<CaseUeVO> ueVos = new ArrayList<CaseUeVO>();

			Collection<ClientSession> clientS = SessionManager.getInstance().getSessions();

			for (ClientSession s : clientS) {

				try {

					aliveMap.put(s.getUsername(), s.getPresence().isAvailable());

				} catch (UserNotFoundException e) {

					e.printStackTrace();
				}
			}

			for (AppStatus s : appStatusList) {

				Integer tokenSessionId = s.getAppSessionId();
				AppTokenSession ts = tokenSessionMap.get(tokenSessionId);
				if (ts == null)
					continue;

				if (aliveMap.get(ts.getXppId()) == null || !aliveMap.get(ts.getXppId()))
					continue;

				LocInfoDTO msg = new LocInfoDTO();
				msg.setUserId(ts.getUserId());
				msg.setSysId(ts.getSysId());
				msg.setUeId(ts.getId());
				msg.setPhoneType(ts.getPhoneType());
				msg.setLat(ts.getLastLat());
				msg.setLng(ts.getLastLng());
				msg.setTask("");
				msg.setRate("");
				msg.setTs(new Date());

				locList.add(msg);
			}

			if (locList.size() == 0)
				return locList;

			// 获取相应的速度信息,查找最近的任务日志信息
			List<TestcaseLog> tcLogs = tcLogService.queryAll();
			if (tcLogs.size() <= 0)
				return locList;

			Map<Integer, TestcaseLog> tcLogMap = new HashMap<Integer, TestcaseLog>();
			for (TestcaseLog tcl : tcLogs) {
				tcLogMap.put(tcl.getAppSessionId(), tcl);

			}

			for (AppStatus s : appStatusList) {

				Integer tokenSessionId = s.getAppSessionId();
				AppTokenSession ts = tokenSessionMap.get(tokenSessionId);

				TestcaseLog tcLog = tcLogMap.get(tokenSessionId);
				if (tcLog == null)
					continue;

				Integer userId = ts.getUserId();
				String xppId = ts.getXppId();

				if (aliveMap.get(xppId) == null || !aliveMap.get(xppId))
					continue;

				statusMap.put(s.getAppSessionId(), s);
				xpp_sessionId_Map.put(xppId, tokenSessionId);

				String tcName = tcLog.getTestcase();

				CaseUeVO caseueVo = new CaseUeVO();

				caseueVo.setCasename(tcName);
				caseueVo.setUser_id(userId);
				caseueVo.setUe_id(xppId);

				ueVos.add(caseueVo);

			}

			if (ueVos.size() == 0)
				return locList;

			logger.debug("日志获取路径: " + realPath + "/testcase");
			logger.debug("日志参数:" + JsonUtil.toJson(ueVos));

			List<SingleUeLogPO> ueLogs = ueLogService.GetSingleUeLog(ueVos, realPath + "/testcase");
			
			logger.debug("获取到的速率信息:"+JsonUtil.toJson(ueLogs));
			

			for (SingleUeLogPO ul : ueLogs) {

				Integer sessionId = xpp_sessionId_Map.get(ul.getUe_id());

				AppStatus as = statusMap.get(sessionId);

				String action = as.getTask();

				logger.debug("XppId:" + ul.getUe_id());
				logger.debug("AppStatus:" + JsonUtil.toJson(as));

				String rate = "";

				if (action.equals("WeiXinText")) {

					rate = String.valueOf("Latency: " + ul.getWeixin_text_delay() + " ms <br/>");
					rate += String.valueOf("Success: " + ul.getWeixin_text_success() + " <br/>");
					rate += String.valueOf("Failure: " + ul.getWeixin_text_fail() + " <br/>");
					rate += String.valueOf("Success Rate: " + ul.getWeixin_text_rate() * 100 + "% <br/>");
					
					action = "WeChat";
					

				} else if (action.equals("FTPDownload")) {

					rate = String.valueOf("DL: " + ul.getFtpdown_speed() + " Mbps <br/>");
					rate += String.valueOf("UL: " + ul.getFtpup_speed() + " Mbps <br/>");
					
					action="FTP";
					

				} else if (action.equals("WebBrowser")) {

					rate = String.valueOf("Latency: " + ul.getWeb_delay() + " ms <br/>");
					rate += String.valueOf("Success: " + ul.getWeb_success() + " <br/>");
					rate += String.valueOf("Failure: " + ul.getWeb_fail() + " <br/>");
					rate += String.valueOf("Success Rate: " + ul.getWeb_rate() * 100 + "% <br/>");
					
					action="Web";
					

				} else if (action.equals("TelCaseUI")) {
					rate = String.valueOf("DL: " + ul.getNetworkdown_speed() + " Mbps <br/>");
					rate += String.valueOf("UL: " + ul.getNetworkup_speed() + " Mbps <br/>");
					
					action="VoLTE";
					
				} else if (action.equals("Live")) {
					rate = String.valueOf("DL: " + ul.getNetworkdown_speed() + " Mbps <br/>");
					rate += String.valueOf("UL: " + ul.getNetworkup_speed() + " Mbps <br/>");
					
					
					action="Video";
				}

				for (LocInfoDTO loc : locList) {

					Integer _sessionId = xpp_sessionId_Map.get(ul.getUe_id());

					if (loc.getUeId().equals(_sessionId)) {
						loc.setTask(action);
						loc.setRate(rate);
						loc.setTs(new Date());
					}
				}

			}

			return locList;

		}

	}

}
