package com.cmri.bpt.web.ue;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.androidpn.server.service.NotificationService;
/*import org.androidpn.server.consdef.ConsDef;
import org.androidpn.server.xmpp.push.NotificationManager;
import org.androidpn.server.xmpp.session.ClientSession;
import org.androidpn.server.xmpp.session.SessionManager;*///侵入了androidpn的api，得重构
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.RequestContextHolder;
import org.xmpp.packet.IQ;

import com.cmri.bpt.common.token.TokenSessionStore;
import com.cmri.bpt.common.user.UserContext;
import com.cmri.bpt.common.user.UserContextHolder;
import com.cmri.bpt.common.util.CSVUtils;
import com.cmri.bpt.common.util.DeviceIdGenerator;
import com.cmri.bpt.entity.auth.AppTokenSession;
import com.cmri.bpt.entity.po.SysParamPO;
import com.cmri.bpt.entity.push.PushEnum;
import com.cmri.bpt.service.param.interfac.SysParamService;
import com.cmri.bpt.service.token.AppTokenSessionService;
import com.cmri.bpt.service.ue.AppStatusService;
import com.cmri.bpt.service.ue.bo.AppStatus;
import com.cmri.bpt.web.restor.SpringBeanUtil;
import com.cmri.bpt.web.util.CrawlListener;
import com.cmri.bpt.web.util.PhoneCrawlerHolder;
import com.cmri.bpt.web.util.PhoneNumberCrawler;

@Controller
public class UEController {

	static Logger logger = Logger.getLogger(UEController.class);
	private static final Logger userLogger = Logger.getLogger("user." + UEController.class);

	@Autowired
	AppTokenSessionService service;

	@Autowired
	SysParamService sysParamService;

	@Autowired
	AppStatusService statusS;
	
	@Autowired
	NotificationService notificationService;

//	private NotificationManager notificationManager;

	@RequestMapping(value = "/ue/tag", method = RequestMethod.GET)
	@ResponseBody
	public ResponseEntity<List<AppTokenSession>> query() {

		UserContext ctx = UserContextHolder.getUserContext();

		userLogger.debug("/ue/tag userId:" + ctx.getUserId());

		List<AppTokenSession> session = service.queryByUserId(ctx.getUserId());

		return new ResponseEntity<List<AppTokenSession>>(session, HttpStatus.OK);
	}

	@RequestMapping(value = "/ue/real", method = RequestMethod.GET)
	@ResponseBody
	public ResponseEntity<List<AppStatus>> realTime() {
		UserContext ctx = UserContextHolder.getUserContext();

		userLogger.debug("/ue/real userId:" + ctx.getUserId());

		List<AppStatus> status = statusS.query(ctx.getUserId());

		return new ResponseEntity<List<AppStatus>>(status, HttpStatus.OK);
	}

	@RequestMapping(value = "/ue/tag/update", method = RequestMethod.POST)
	@ResponseBody
	public ResponseEntity<Boolean> updateTag(@RequestBody Map map) {

		List<Integer> ids = (List<Integer>) map.get("ids");
		String tag = (String) map.get("tag");

		service.updateTagByIds(ids, tag);

		return new ResponseEntity<Boolean>(true, HttpStatus.OK);
	}

	@RequestMapping(value = "/ue/info/update", method = RequestMethod.POST)
	@ResponseBody
	public ResponseEntity<Boolean> updateInfo(@RequestBody Map map) {

		String info = (String) map.get("info");

		List<List<String>> result = CSVUtils.importCsv(info);

		UserContext ctx = UserContextHolder.getUserContext();
		Integer userId = ctx.getUserId();
		List<AppTokenSession> allSessions = service.queryByUserId(userId);
		TokenSessionStore storeService = SpringBeanUtil.getBean(TokenSessionStore.class);

		for (List<String> line : result) {

			for (AppTokenSession session : allSessions) {

				if (session.getXppId().substring(11).equals(line.get(0))) {

					session.setBox(line.get(1));

					session.setPhoneNumber(line.get(2));

					storeService.updateTokenSession(session);

				}

			}
		}

		return new ResponseEntity<Boolean>(true, HttpStatus.OK);
	}

	@RequestMapping(value = "/ueMgr/phonecrawlend", method = RequestMethod.POST)
	@ResponseBody
	public boolean crawlPhoneEnd() {

		UserContext ctx = UserContextHolder.getUserContext();
		Integer userId = ctx.getUserId();

		PhoneNumberCrawler crawler = PhoneCrawlerHolder.getPhoneCrawler(userId);

		if (crawler != null && crawler.isAlive()) {

			crawler.teminate = true;
		}

		return true;
	}

	@RequestMapping(value = "/ueMgr/phonecrawl", method = RequestMethod.POST)
	@ResponseBody
	public boolean crawlPhone() {
		Integer userId = UserContextHolder.getUserContext().getUserId();

		PhoneNumberCrawler crawler = PhoneCrawlerHolder.getPhoneCrawler(userId);

		if (crawler != null && crawler.isAlive()) {
			logger.debug("crawl 存活中……");
			return true;
		}

	/*	List<AppTokenSession> allSessions = service.queryByUserId(userId);
		SessionManager mgr = SessionManager.getInstance();
		List<AppTokenSession> liveSessions = new ArrayList<AppTokenSession>();
		for (AppTokenSession s : allSessions) {
			ClientSession cs = mgr.getSession(s.getXppId());
			if(cs!=null)
			{
				if(cs.getPresence().isAvailable())
				{
					liveSessions.add(s);
				}
			}
		}*///换成rpc:notificationService.getLiveSession(userId)
		List<AppTokenSession> liveSessions = notificationService.getLiveSession(userId);

		crawler = new PhoneNumberCrawler(userId, liveSessions);

		CrawlListener listener = new CrawlListener() {

			@Override
			public void onFinished(Integer user_id, List<AppTokenSession> session) {

				logger.debug("Crawl Finished");

				TokenSessionStore storeService = SpringBeanUtil.getBean(TokenSessionStore.class);
				List<AppTokenSession> allSessions = service.queryByUserId(user_id);

				for (AppTokenSession s : session) {
					for (AppTokenSession a : allSessions) {

						if (s.getId().equals(a.getId())) {

							logger.debug(s.getId() + " " + s.getPhoneNumber());
							a.setPhoneNumber(s.getPhoneNumber());
							storeService.updateTokenSession(a);

						}

					}

				}

			}
		};

		crawler.addCrawlEventListener(listener);

		PhoneCrawlerHolder.addPhoneCrawler(userId, crawler);

		crawler.crawl();

		return true;

	}

	@RequestMapping(value = "/ueMgr/flymode", method = RequestMethod.POST)
	@ResponseBody
	public boolean flymode(@RequestBody Map map) {
		boolean result = false;
		List<Integer> ids = (List<Integer>) map.get("ids");

		List<AppTokenSession> allSessions = service.queryByIds(ids);

	/*	if (notificationManager == null) {
			notificationManager = NotificationManager.getInstance();
		}*/

		if (allSessions != null && allSessions.size() > 0) {
				/*
				IQ notificationIQ = notificationManager.createNotificationIQ(ConsDef.STR_PUSH_API_KEY, PushEnum.FlyModeOfUe,
						"", ConsDef.STR_PUSH_URL);
	
				for (AppTokenSession sessionItem : allSessions) {
					notificationManager.sendNotifcationToUser(sessionItem.getXppId(), notificationIQ);
				}*///换成rpc notificationService.flymodeCmd(allSessions, "");
				notificationService.flymodeCmd(allSessions, "");

				result = true;
		}

		return result;

	}

	@ResponseBody
	@RequestMapping(value = "/ueMgr/stopLog", method = RequestMethod.POST)
	public String stopLog(Model mode, HttpServletRequest request, HttpServletResponse response) {
		String reStr = "发送失败!";

		UserContext ctx = UserContextHolder.getUserContext();
		Integer userId = ctx.getUserId();
		List<AppTokenSession> allSessions = service.queryByUserId(userId);
/*
		if (notificationManager == null) {
			notificationManager = NotificationManager.getInstance();
		}
*/
		if (allSessions != null && allSessions.size() > 0) {
				/*
				IQ notificationIQ = notificationManager.createNotificationIQ(ConsDef.STR_PUSH_API_KEY, PushEnum.StopCaseLog,
						PushEnum.StopCaseLog_Msg, ConsDef.STR_PUSH_URL);
	
				for (AppTokenSession sessionItem : allSessions) {
					notificationManager.sendNotifcationToUser(sessionItem.getXppId(), notificationIQ);
				}
				*///换成rpc  notificationService. stopCaseLogCmd(List<AppTokenSession> tokenSessions,String message);
			   notificationService.stopCaseLogCmd(allSessions, PushEnum.StopCaseLog_Msg);
			   reStr = "发送成功!";
		}

		return reStr;
	}

	@ResponseBody
	@RequestMapping(value = "/ueMgr/receiveLog", method = RequestMethod.POST)
	public String receiveLog(@RequestParam("delay") String delay, @RequestParam("retry") String retry,
			@RequestParam("ids") String ids) {

		String reStr = "发送失败!";

		List<AppTokenSession> careSessions = getTokenSessionBySysId(ids);		
		
/*
		if (notificationManager == null) {
			notificationManager = NotificationManager.getInstance();
		}*/

		if (careSessions != null && careSessions.size() > 0) {

			int i = 0;
			Integer delayTime = Integer.valueOf(delay);
			Integer retryTime = Integer.valueOf(retry);

			for (AppTokenSession sessionItem : careSessions) {
				i++;
				String template = "{'delayTime':%0,'retryTime':%1}";
				template = template.replaceAll("%0", String.valueOf(delayTime * i)).replaceAll("%1",
						String.valueOf(retryTime));

			/*	IQ notificationIQ = notificationManager.createNotificationIQ(ConsDef.STR_PUSH_API_KEY,
						PushEnum.ReceiveCaseLog, template, ConsDef.STR_PUSH_URL);

				notificationManager.sendNotifcationToUser(sessionItem.getXppId(), notificationIQ);*///换成分rpc
				
				notificationService.receiveLogCmd(sessionItem, template);
			}

			reStr = "发送成功!";
		}

		return reStr;
	}

	

	@ResponseBody
	@RequestMapping(value = "/ueMgr/ueupdate", method = RequestMethod.POST)
	public String updateUE(@RequestParam("ftp") String ftp, @RequestParam("type") String type,
			@RequestParam("ids") String ids) {

		String reStr = "发送失败!";

		List<AppTokenSession> allSessions = getTokenSessionBySysId(ids);

		/*if (notificationManager == null) {
			notificationManager = NotificationManager.getInstance();
		}
*/
		if (allSessions != null && allSessions.size() > 0) {

			String msgTitle = "";
			if (type.equals("Agent")){
					msgTitle = PushEnum.AgentUpdate;
			}else if (type.equals("Jar")){
					msgTitle = PushEnum.JarUpdate;
			}

			for (AppTokenSession sessionItem : allSessions) {

				/*IQ notificationIQ = notificationManager.createNotificationIQ(ConsDef.STR_PUSH_API_KEY, msgTitle, ftp,
						ConsDef.STR_PUSH_URL);

				notificationManager.sendNotifcationToUser(sessionItem.getXppId(), notificationIQ);*///换成rpc
				
				notificationService.ueupdateCmd(sessionItem, msgTitle, ftp);
			}

			reStr = "发送成功!";
		}

		return reStr;
	}

	@ResponseBody
	@RequestMapping(value = "/ueMgr/syncTime", method = RequestMethod.POST)
	public String syncTime(@RequestParam("ftp") String ftp, @RequestParam("ids") String ids) {

		String reStr = "发送失败!";

	
		List<AppTokenSession> allSessions = getTokenSessionBySysId(ids);

	/*	if (notificationManager == null) {
			notificationManager = NotificationManager.getInstance();
		}*/

		String template = "{'ip':%0,'delayTime':%1}";
		template = template.replaceAll("%0", ftp).replaceAll("%1", String.valueOf(5));

		if (allSessions != null && allSessions.size() > 0) {

			for (AppTokenSession sessionItem : allSessions) {

				/*IQ notificationIQ = notificationManager.createNotificationIQ(ConsDef.STR_PUSH_API_KEY,
						PushEnum.UeSyncTime, template, ConsDef.STR_PUSH_URL);

				notificationManager.sendNotifcationToUser(sessionItem.getXppId(), notificationIQ);*///换成rpc
				
				notificationService.syncTimeCmd(sessionItem, template);
			}

			reStr = "发送成功!";
		}

		return reStr;
	}

	@ResponseBody
	@RequestMapping(value = "/ueMgr/storeCall", method = RequestMethod.POST)
	public String storeCall() {

		String reStr = "发送失败!";

		UserContext ctx = UserContextHolder.getUserContext();
		Integer userId = ctx.getUserId();
		List<AppTokenSession> allSessions = service.queryByUserId(userId);
/*
		if (notificationManager == null) {
			notificationManager = NotificationManager.getInstance();
		}*/

		if (allSessions != null && allSessions.size() > 0) {

			for (AppTokenSession sessionItem : allSessions) {

				if (sessionItem.getPhoneNumber() != null && !sessionItem.getPhoneNumber().isEmpty()) {

					String template = "{'imsi':%0,'phone':%1}";
					template = template.replaceAll("%0", sessionItem.getXppId().substring(11)).replaceAll("%1",
							sessionItem.getPhoneNumber());

				/*	IQ notificationIQ = notificationManager.createNotificationIQ(ConsDef.STR_PUSH_API_KEY,
							PushEnum.UeStoreCallNumber, template, ConsDef.STR_PUSH_URL);

					notificationManager.sendNotifcationToUser(sessionItem.getXppId(), notificationIQ);*///换成rpc
					
					notificationService.storeCallCmd(sessionItem, template);
				}

			}

			reStr = "发送成功!";
		}

		return reStr;
	}

	@ResponseBody
	@RequestMapping(value = "/ueMgr/expireCall", method = RequestMethod.POST)
	public String expireCall() {

		String reStr = "发送失败!";

		UserContext ctx = UserContextHolder.getUserContext();
		Integer userId = ctx.getUserId();
		List<AppTokenSession> allSessions = service.queryByUserId(userId);

	/*	if (notificationManager == null) {
			notificationManager = NotificationManager.getInstance();
		}*/

		TokenSessionStore storeService = SpringBeanUtil.getBean(TokenSessionStore.class);

		if (allSessions != null && allSessions.size() > 0) {

			for (AppTokenSession sessionItem : allSessions) {

				/*ClientSession clientSession = SessionManager.getInstance().getSession(sessionItem.getXppId());
				
				if (clientSession != null && clientSession.getPresence().isAvailable()) {

					IQ notificationIQ = notificationManager.createNotificationIQ(ConsDef.STR_PUSH_API_KEY,
							PushEnum.UeExpireCallNumber, "", ConsDef.STR_PUSH_URL);

					notificationManager.sendNotifcationToUser(sessionItem.getXppId(), notificationIQ);
				}*///换成rpc
				boolean flag = notificationService.expireCallCmd(sessionItem, "");
				if(flag){
						sessionItem.setPhoneNumber(null);
						storeService.updateTokenSession(sessionItem);
				}
			}

			reStr = "发送成功!";
		}

		return reStr;
	}

	@ResponseBody
	@RequestMapping(value = "/ueMgr/uecontrol", method = RequestMethod.POST)
	public String ueControl(@RequestParam("type") String type, @RequestParam("ids") String ids) {

		String reStr = "发送失败!";

		
		List<AppTokenSession> allSessions =getTokenSessionBySysId(ids);
/*
		if (notificationManager == null) {
			notificationManager = NotificationManager.getInstance();
		}
*/
		if (allSessions != null && allSessions.size() > 0) {

			String msgTitle = "";
			if (type.equals("shutdown")){
				msgTitle = PushEnum.ShutdownUe;
			}else if (type.equals("restart")){
				msgTitle = PushEnum.RestartUe;
			}else if (type.equals("openwifi")){
				msgTitle = PushEnum.UeWifiOn;
			}else if (type.equals("closewifi")){
				msgTitle = PushEnum.UeWifiOff;
			}

			for (AppTokenSession sessionItem : allSessions) {

			/*	IQ notificationIQ = notificationManager.createNotificationIQ(ConsDef.STR_PUSH_API_KEY, msgTitle, "",
						ConsDef.STR_PUSH_URL);

				notificationManager.sendNotifcationToUser(sessionItem.getXppId(), notificationIQ);*///换成rpc
				
				notificationService.uecontrolCmd(sessionItem, msgTitle, "");
			}

			reStr = "发送成功!";
		}

		return reStr;
	}

	@ResponseBody
	@RequestMapping(value = "/ueMgr/quit", method = RequestMethod.POST)
	public String quit(@RequestParam("ids") String ids) {

		UserContext ctx = UserContextHolder.getUserContext();
		Integer userId = ctx.getUserId();

		TokenSessionStore tokenSessionStore = UserContextHolder.getTokenSessionStore();

		List<AppTokenSession> allSessions = getTokenSessionBySysId(ids);

		if (allSessions != null && allSessions.size() > 0) {

			for (AppTokenSession sessionItem : allSessions) {
				tokenSessionStore.removeTokenSession(sessionItem.getToken());
			}
		}

		if (ids == null || ids.isEmpty() || ids.equals("null"))
			DeviceIdGenerator.reset(userId);

		return "删除成功";
	}

	@ResponseBody
	@RequestMapping(value = "/ueMgr/saveSysParam")
	public String saveSysParam(Model mode, HttpServletRequest request, HttpServletResponse response,
			@ModelAttribute SysParamPO sysParamPO) {
		UserContext ctx = UserContextHolder.getUserContext();
		sysParamPO.setUserId(ctx.getUserId());
		String reStr = "SUCCESS";
		try {
			sysParamService.saveOrUpdate(sysParamPO);
		} catch (Exception e) {
			reStr = "FAIL";
			e.printStackTrace();
		}
		return reStr;
	}

	@ResponseBody
	@RequestMapping(value = "/ueMgr/showSysParam")
	public ResponseEntity<SysParamPO> showSysParam(Model mode, HttpServletRequest request,
			HttpServletResponse response) {
		UserContext ctx = UserContextHolder.getUserContext();
		SysParamPO sysParamPO = sysParamService.getByUserId(ctx.getUserId());
		return new ResponseEntity<SysParamPO>(sysParamPO, HttpStatus.OK);
	}
	
	
	
	
	
	///----------------------help method------------
	
	private List<AppTokenSession> getTokenSessionBySysId(String ids) {
		
		UserContext ctx = UserContextHolder.getUserContext();
		Integer userId = ctx.getUserId();
		List<AppTokenSession> allSessions = service.queryByUserId(userId);
		
		List<AppTokenSession> careSessions =null;
		
		if(ids==null || ids.isEmpty() || ids.equals("null"))
		{
			careSessions = allSessions;
		}
		else
		{
			ids =ids.replace(" ", "");
			String[] idArr =   ids.split(",");		
			
			List<String> idList = new ArrayList<String>();
			
			for(String id : idArr)
			{
				if(id.contains("-"))
				{
					String[] tail = id.split("-");
					if(tail.length == 2)
					{
						int begin = Integer.parseInt(tail[0]);
						int end = Integer.parseInt(tail[1]);
						
						for (int i = begin; i <= end; i++) {
							idList.add(String.valueOf(i));
						}
					}
					
				}
				else
				{
					idList.add(id);
				}
			}
			
			careSessions = new ArrayList<AppTokenSession>();
			for(String id : idList)
			{
				for(AppTokenSession ap : allSessions)
				{
					if(ap.getSysId().toString().equals(id))
					{
						careSessions.add(ap);
					}
				}
			}			
		}
		return careSessions;
	}
	
	
	
	
	
	
	
	
	
	
	

}
