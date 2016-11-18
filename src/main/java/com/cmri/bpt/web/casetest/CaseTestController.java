package com.cmri.bpt.web.casetest;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

//import org.androidpn.server.consdef.ConsDef;
import org.androidpn.server.service.NotificationService;
//import org.androidpn.server.service.UserNotFoundException;
//import org.androidpn.server.xmpp.push.NotificationManager;
//import org.androidpn.server.xmpp.session.ClientSession;
//import org.androidpn.server.xmpp.session.SessionManager;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import com.cmri.bpt.common.user.UserContext;
import com.cmri.bpt.common.user.UserContextHolder;
import com.cmri.bpt.common.util.CSVUtils;
import com.cmri.bpt.common.util.ExceptionUtil;
import com.cmri.bpt.common.util.JsonUtil;
import com.cmri.bpt.entity.auth.AppTokenSession;
import com.cmri.bpt.entity.po.BaseCaseParamPO;
import com.cmri.bpt.entity.po.SysParamPO;
import com.cmri.bpt.entity.po.UserCaseParamPO;
import com.cmri.bpt.entity.push.PushEnum;
import com.cmri.bpt.entity.testcase.TestcaseLog;
import com.cmri.bpt.entity.vo.actionVO;
import com.cmri.bpt.entity.vo.behaviorVO;
import com.cmri.bpt.entity.vo.caseConfigVO;
import com.cmri.bpt.entity.vo.paramVO;
import com.cmri.bpt.entity.vo.sendBehaviorVO;
import com.cmri.bpt.service.param.interfac.ICaseParamService;
import com.cmri.bpt.service.param.interfac.SysParamService;
import com.cmri.bpt.service.testcase.CaseTestService;
import com.cmri.bpt.service.testcase.TestcaseLogService;
import com.cmri.bpt.service.token.AppTokenSessionService;
import com.cmri.bpt.web.util.SysValueHolder;

@Controller
@RequestMapping("/webCaseTest")
public class CaseTestController {

	@Autowired
	private AppTokenSessionService apptokenserver;
	
	@Autowired
	private NotificationService notificationService;
	
	@Autowired
	private CaseTestService caseTestService;

	@Autowired
	private TestcaseLogService logService;

	@Autowired
	private ICaseParamService paramservice;

	@Autowired
	private SysParamService sysService;

	private static final Logger logger = Logger.getLogger("push." + CaseTestController.class);

	//private NotificationManager notificationManager;

	private static Random r = new Random();

	/**
	 * 保存用户测试参数
	 * 
	 * @param mode
	 * @param paramlist
	 *            参数list
	 * @param request
	 * @param response
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/saveCaseParam", method = RequestMethod.POST)
	public String sendCase(Model mode, @RequestParam("paramlist") String paramlist, HttpServletRequest request,
			HttpServletResponse response) {
		String reStr = "FAILED";
		if (paramlist != null && !paramlist.equals("")) {
			UserContext ctx = UserContextHolder.getUserContext();
			Integer userId = ctx.getUserId();
			List<paramVO> paramVoList = new ArrayList<paramVO>();
			paramVoList = JsonUtil.Json2ObjectList2(paramlist, paramVO.class);
			paramservice.saveParamByUserId(userId, paramVoList);
			reStr = "SUCCESS";
		}
		return reStr;
	}

	@ResponseBody
	@RequestMapping(value = "/queryUserParam", method = RequestMethod.GET)
	public List<UserCaseParamPO> queryUserCase() {
		UserContext ctx = UserContextHolder.getUserContext();
		Integer userId = ctx.getUserId();
		return paramservice.selectUserCaseParam(userId);
	}

	/**
	 * 获取用户终端分组
	 * 
	 * @param mode
	 * @param request
	 * @param response
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/getGroupList", method = RequestMethod.POST)
	public String getGroupList(Model mode, HttpServletRequest request, HttpServletResponse response) {
		String reStr = null;
		UserContext ctx = UserContextHolder.getUserContext();
		Integer userId = ctx.getUserId();
		List<String> tags = null;
		if (userId != null) {
			tags = apptokenserver.queryTags(userId);
			reStr = JsonUtil.Object2Json(tags);
		}
		return reStr;
	}

	/**
	 * 下发case
	 * 
	 * @param mode
	 * @param request
	 * @param response
	 * @param behaviorList
	 * @param casetype
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/sendCaseWeb", method = RequestMethod.POST)
	public String sendCaseWeb(Model mode, HttpServletRequest request, HttpServletResponse response,
			@RequestParam("behaviorList") String behaviorList, @RequestParam("casetype") Integer casetype) {
		String reStr = "发送失败!";
		List<behaviorVO> behrVoList = new ArrayList<behaviorVO>();

		if (behaviorList == null || behaviorList.equals("")) {
			reStr = "Action为空,下发失败!";
			return reStr;
		}

		behrVoList = JsonUtil.Json2ObjectList2(behaviorList, behaviorVO.class);

		if (behrVoList.size() == 0) {
			reStr = "Action为空,下发失败!";
			return reStr;
		}

		//		List<AppTokenSession> aliveSession = getLiveSession();换成prc
		List<AppTokenSession> aliveSession = notificationService.getLiveSession(UserContextHolder.getUserContext().getUserId());
		
		if (aliveSession==null||aliveSession.size() == 0) {
			reStr = "当前UE不在线,发送失败!";
			return reStr;
		}

		String testcaseBeginTime = System.currentTimeMillis() + "";

		try {
				switch (casetype) {
						case 1:// 比例
							randomModel(behrVoList, aliveSession, testcaseBeginTime);
							reStr = "命令成功发送!";
							break;
						case 2:// 分组
			
							groupModel(behrVoList, aliveSession, testcaseBeginTime);
							reStr = "命令成功发送!";
							break;
						default:
							break;
				}
		} catch (Exception ee) {
			logger.error(ee.getMessage());
			logger.error(ExceptionUtil.getStackTraceAsString(ee));
		}

		return reStr;
	}

	/*private List<AppTokenSession> getLiveSession() {//迁移到rpc:NotificationService.getLiveSession(Integer  userId) 

		UserContext ctx = UserContextHolder.getUserContext();
		Integer userId = ctx.getUserId();

		List<AppTokenSession> allSessions = apptokenserver.queryByUserId(userId);

		SessionManager mgr = SessionManager.getInstance();

		List<AppTokenSession> aliveSession = new ArrayList<AppTokenSession>();
		
		for (AppTokenSession s : allSessions) {
			ClientSession cs = mgr.getSession(s.getXppId());
			if (cs != null) {
				if (cs.getPresence().isAvailable()) {
					aliveSession.add(s);
				}
			}
		}
		
		return aliveSession;
	}*/

	private void groupModel(List<behaviorVO> behrVoList, List<AppTokenSession> aliveSession, String testcaseBeginTime) {
		Integer userId = UserContextHolder.getUserContext().getUserId();
		SysParamPO sysParam = sysService.getByUserId(userId);
		if(sysParam==null)
		{
			sysParam = new SysParamPO();
		    sysParam.setDuration(1);
		}

		for (behaviorVO bvoitem : behrVoList) {
			List<AppTokenSession> groupSession = new ArrayList<AppTokenSession>();
			for (AppTokenSession s : aliveSession) {
				if (s.getTag() != null && s.getTag().equals(bvoitem.getGrouptag())) {
					
					groupSession.add(s);
				}
			}

			ActionContext actx = new ActionContext();
			actx.behavior = bvoitem;
			actx.tokenSession = groupSession;
			actx.timestamp = testcaseBeginTime;
			actx.seed = sysParam.getDuration();
			actx.userId = userId;

			if (bvoitem.getAction().getAction().startsWith("TelCaseUI")) {

				new TelCaseUIStrategy().execute(actx);

			} else if (bvoitem.getAction().getAction().startsWith("WeiXin")) // 处理微信单发
			{
				new WeixinStrategy().execute(actx);

			} else {
				new CommonStrategy().execute(actx);

			}

		}

	}

	private void randomModel(List<behaviorVO> behrVoList, List<AppTokenSession> aliveSession,
			String testcaseBeginTime) {

		
		UserContext uctx = UserContextHolder.getUserContext();
		Integer userId = uctx.getUserId();
		SysParamPO sysParam = sysService.getByUserId(userId);
		
		
		if(sysParam==null)
		{
			sysParam = new SysParamPO();
		    sysParam.setDuration(1);
		}

		int ueSize = aliveSession.size();

		for (behaviorVO bvoitem : behrVoList) {

			float ratio = bvoitem.getFloatRatio() / 100;
			int ueNum = (int) (ueSize * ratio);

			logger.debug("随机比例:" + ratio + " Ue个数" + ueNum + " 在线Ue:" + ueSize);

			List<AppTokenSession> randomSession = new ArrayList<AppTokenSession>();

			for (int i = 0; i < ueNum; i++) {

				AppTokenSession session = aliveSession.get(0);
				randomSession.add(session);
				aliveSession.remove(0);
			}

			ActionContext actx = new ActionContext();
			actx.behavior = bvoitem;
			actx.tokenSession = randomSession;
			actx.timestamp = testcaseBeginTime;
			actx.seed = sysParam.getDuration();
			actx.userId = userId;

			if (bvoitem.getAction().getAction().equals("TelCaseUI")) {

				new TelCaseUIStrategy().execute(actx);

			} else if (bvoitem.getAction().getAction().startsWith("WeiXin")) // 处理微信单发
			{
				new WeixinStrategy().execute(actx);

			} else {
				new CommonStrategy().execute(actx);

			}
		}

	}

	/*private void sendCmd(AppTokenSession tokenSession, String message) {换成了rpc:notificationService.sendCmd（）
		// 生成推送信息
		IQ notificationIQ = notificationManager.createNotificationIQ(ConsDef.STR_PUSH_API_KEY, PushEnum.SendCase,
				message, ConsDef.STR_PUSH_URL);
		
		// 向终端发起推送
		if (tokenSession != null) {

			notificationManager.sendNotifcationToUser(tokenSession.getXppId(), notificationIQ);

			logger.debug("向 " + tokenSession.getXppId() + " 分组:" + tokenSession.getTag() + " 推送：" + message);

		}
	}*/

	private void persistPushLog(AppTokenSession tokenSession, actionVO actionItem, caseConfigVO configVo) {
		TestcaseLog log = new TestcaseLog();
		log.setAppSessionId(tokenSession.getId());
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy年MM月dd日HH时mm分ss秒");
		String sDateTime = sdf.format(Long.parseLong(configVo.getTime()));
		log.setTestcase(configVo.getCasename() + "_" + sDateTime);
		log.setAction(actionItem.getAction());
		logService.persist(log);
	}

	/**
	 * 停止case
	 * 
	 * @param mode
	 * @param request
	 * @param response
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/stopCaseWeb", method = RequestMethod.POST)
	public String stopCaseWeb(Model mode, HttpServletRequest request, HttpServletResponse response) {
			String reStr = "发送失败!";
	
			Integer userId = UserContextHolder.getUserContext().getUserId();
			List<AppTokenSession> allSessions = apptokenserver.queryByUserId(userId);
			if (allSessions != null && allSessions.size() > 0) {
					/*IQ notificationIQ = notificationManager.createNotificationIQ(ConsDef.STR_PUSH_API_KEY, PushEnum.StopCase,
							PushEnum.StopCase_Msg, ConsDef.STR_PUSH_URL);
					for (AppTokenSession sessionItem : allSessions) {
						notificationManager.sendNotifcationToUser(sessionItem.getXppId(), notificationIQ);
					}*///换成了rpc：notificationService.stopCmd
					notificationService.stopCmd(allSessions, PushEnum.StopCase_Msg);
					reStr = "发送成功!";
			}
	
			return reStr;
	}

	private List<sendBehaviorVO> getCaseInfo(actionVO action) {
		List<sendBehaviorVO> sendBehrVoList = new ArrayList<sendBehaviorVO>();
		sendBehaviorVO sendBehrVo = new sendBehaviorVO();
		List<actionVO> behavior = new ArrayList<actionVO>();
		behavior.add(action);
		sendBehrVo.setBehavior(behavior);
		sendBehrVo.setIndex(0);
		sendBehrVoList.add(sendBehrVo);
		return sendBehrVoList;
	}

	private caseConfigVO getCaseConfig(Integer userid, String time) {
		caseConfigVO configvo = new caseConfigVO();
		configvo.setLogpath("/sdcard/testcase/");
		configvo.setCasename(userid + "bptmixcase");
		configvo.setTime(time);
		configvo.setClock("null");
		configvo.setDoubleroute("2");
		return configvo;
	}

	private Map getCaseParam(Integer userId, String action) {

		Map<String, String> paramMap = new HashMap<String, String>();
		List<BaseCaseParamPO> poList = paramservice.getBaseParamByAction(action);
		if (poList != null) {

			for (BaseCaseParamPO poItem : poList) {

				String paramName = poItem.getParamallname();
				String paramValue = paramservice.getParamValueByUserIdAndParamCode(userId, paramName);
				paramMap.put(paramName, paramValue);
			}

		}

		return paramMap;

	}

	private String buildMessage(List<sendBehaviorVO> bVos, caseConfigVO caseCVos, Map param) {
		return JsonUtil.Object2Json(bVos) + "###" + "[" + JsonUtil.Object2Json(param) + "]" + "###"
				+ JsonUtil.Object2Json(caseCVos);

	}

	// return
	// "[{\"WeiXin_Text_DestID\":\"Ma\",\"WeiXin_Text_RptTimes\":\"10\",\"WeiXin_Text_Content\":\"消息Test123\",\"WeiXin_Text_ParaFilePath\":\"/sdcard/testcase/WeiXinTextContent.txt\",\"WeiXin_Text_RptInterval\":\"0\"}]";

	private void exportCaseInfo(String timestamp, String fileName, List<String> data) {

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy年MM月dd日HH时mm分ss秒");
		String sDateTime = sdf.format(Long.parseLong(timestamp));
		String case_file_name = "bptmixcase_" + sDateTime;

		UserContext uctx = UserContextHolder.getUserContext();
		Integer userId = uctx.getUserId();

		String path = SysValueHolder.WebPath + "/testcase/" + userId + "/" + userId + case_file_name + "/" + fileName;

		File f = new File(path);

		if (!f.exists()) {
			
			f.getParentFile().mkdirs();

			try {
				
				f.createNewFile();
				FileOutputStream fos = new FileOutputStream(f);  
				fos.write(new byte[]{(byte)0xEF, (byte)0xBB, (byte)0xBF});  				
				fos.flush();
				fos.close();
				
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}

		CSVUtils.exportCsv(f, data, true);
	}

	// ---------------------------------------------------------
	// ---------------------------------------------------------
	// ---------------------------------------------------------
	// ---------------------------------------------------------
	// ---------------------------------------------------------
	// ---------------------------------------------------------
	// ---------------------------------------------------------
	
	private actionVO copy(actionVO action)
	{
		actionVO tmp = new actionVO();
		
		tmp.setAction(action.getAction());
        tmp.setDelay(action.getDelay());
        tmp.setDuration(action.getDuration());
        tmp.setStep(action.getStep());
        tmp.setTime(action.getTime());
        
        return tmp;
		
		
	}
	
	

	class TelCaseUIStrategy implements IActionExecStrategy {

		@Override
		public void execute(ActionContext ctx) {
			List<AppTokenSession> tokenSession = ctx.tokenSession;
			String phoneNumber = "";
			String phoneXppId = "";
			Integer sysId=0;
			
			Integer userId = ctx.userId;
		
			caseConfigVO configVo = getCaseConfig(userId, ctx.timestamp);

			String currentAction = ctx.behavior.getAction().getAction();

			List<String> phoneRelation = new ArrayList<String>();
			List<String> taskRecord = new ArrayList<String>();
			
			// the last one not call
			if (tokenSession.size() % 2 == 1) {
				tokenSession.remove(tokenSession.size() - 1);
			}

			for (int i = 0; i < tokenSession.size(); i++) {
				Map param = null;
				// 偶数的接听电话
				if (i % 2 == 0) {
					ctx.behavior.getAction().setAction("TelAnswerCase");

					phoneNumber = tokenSession.get(i).getPhoneNumber();

					phoneXppId = tokenSession.get(i).getXppId();
					
					sysId =  tokenSession.get(i).getSysId();

					param = getCaseParam(userId, "TelAnswerCase");
				} else { // 奇数拨打电话
					ctx.behavior.getAction().setAction("TelCaseUI");

					param = getCaseParam(userId, "TelCaseUI");

					param.put("Call_Send_DestID", phoneNumber);

					if (currentAction.equals("TelCaseUIL")) {
						param.put("Call_Send_HoldTime", "60000000");
					}

					StringBuilder sb = new StringBuilder();
					
					sb.append("TelCaseUI").append(",").append(ctx.tokenSession.get(i).getSysId()).append(",")
							.append(ctx.tokenSession.get(i).getXppId()).append(",").append("TelAnswerCase").append(",")
							.append(sysId).append(",").append(phoneXppId).append(",").append(phoneNumber);

					phoneRelation.add(sb.toString());
				}

				// 组内延时
				actionVO action = copy(ctx.behavior.getAction());
				action.setDelay(String.valueOf(Float.valueOf(action.getDelay()) + r.nextFloat() * ctx.seed));

				List<sendBehaviorVO> behaviorVOs = getCaseInfo(action);

				String sendMessage = buildMessage(behaviorVOs, configVo, param);

				//sendCmd(ctx.tokenSession.get(i), sendMessage);换成了远程调用
				notificationService.sendCmd(ctx.tokenSession.get(i), sendMessage);

				persistPushLog(ctx.tokenSession.get(i), ctx.behavior.getAction(), configVo);
				
				StringBuilder sb = new StringBuilder();
				sb.append(ctx.tokenSession.get(i).getSysId()).append(",").append(ctx.tokenSession.get(i).getXppId()).append(",").append(ctx.tokenSession.get(i).getTag())
						.append(",").append(action.getAction());
				taskRecord.add(sb.toString());
				
			}
			
			exportCaseInfo(ctx.timestamp, "taskrecord.csv", taskRecord);
			exportCaseInfo(ctx.timestamp, "callrelation.csv", phoneRelation);

			
		}

	}

	class WeixinStrategy implements IActionExecStrategy {

		@Override
		public void execute(ActionContext ctx) {

			
			Integer userId = ctx.userId;
			
			caseConfigVO configVo = getCaseConfig(userId, ctx.timestamp);

			Map param = getCaseParam(userId, ctx.behavior.getAction().getAction());

			boolean singleSend = false;
			String currentDestId = "";
			
			if (param.get("WeiXin_Text_DestID") != null && param.get("WeiXin_Text_DestID").equals("P2P")) {
				currentDestId = "WeiXin_Text_DestID";
				singleSend = true;
			} else if (param.get("WeiXin_Image_DestID") != null && param.get("WeiXin_Image_DestID").equals("P2P")) {
				currentDestId = "WeiXin_Image_DestID";
				singleSend = true;
			} else if (param.get("WeiXin_Video_DestID") != null && param.get("WeiXin_Video_DestID").equals("P2P")) {
				currentDestId = "WeiXin_Video_DestID";
				singleSend = true;
			} else if (param.get("WeiXin_Voice_DestID") != null && param.get("WeiXin_Voice_DestID").equals("P2P")) {
				currentDestId = "WeiXin_Voice_DestID";
				singleSend = true;
			}

			
			List<String> taskRecord = new ArrayList<String>();

			
			for (int i = 0; i < ctx.tokenSession.size(); i++) {

				if (singleSend) {

					String phone = "";
					if (i == 0) {
						phone = ctx.tokenSession.get(ctx.tokenSession.size() - 1).getPhoneNumber();
					} else {
						phone = ctx.tokenSession.get(i - 1).getPhoneNumber();
					}

					if (phone == null || phone.isEmpty())
						phone = "Ma";

					param.put(currentDestId, phone);

				}

				// 组内延时
				actionVO action = copy(ctx.behavior.getAction());
				action.setDelay(String.valueOf(Float.valueOf(action.getDelay()) + r.nextFloat() * ctx.seed));

				List<sendBehaviorVO> behaviorVOs = getCaseInfo(action);

				String sendMessage = buildMessage(behaviorVOs, configVo, param);
				//sendCmd(ctx.tokenSession.get(i), sendMessage);
				notificationService.sendCmd(ctx.tokenSession.get(i), sendMessage);
				persistPushLog(ctx.tokenSession.get(i), ctx.behavior.getAction(), configVo);
				
				
				StringBuilder sb = new StringBuilder();
				sb.append(ctx.tokenSession.get(i).getSysId()).append(",").append(ctx.tokenSession.get(i).getXppId()).append(",").append(ctx.tokenSession.get(i).getTag())
						.append(",").append(action.getAction());
				taskRecord.add(sb.toString());
				
			}
			
			exportCaseInfo(ctx.timestamp, "taskrecord.csv", taskRecord);


		}

	}

	class CommonStrategy implements IActionExecStrategy {

		@Override
		public void execute(ActionContext ctx) {

			
			Integer userId = ctx.userId;

			
			caseConfigVO configVo = getCaseConfig(userId, ctx.timestamp);

			Map param = getCaseParam(userId, ctx.behavior.getAction().getAction());

			List<String> taskRecord = new ArrayList<String>();

			
			for (int i = 0; i < ctx.tokenSession.size(); i++) {

				// 组内延时
				actionVO action = copy(ctx.behavior.getAction());
				action.setDelay(String.valueOf(Float.valueOf(action.getDelay()) + r.nextFloat() * ctx.seed));

				List<sendBehaviorVO> behaviorVOs = getCaseInfo(action);

				String sendMessage = buildMessage(behaviorVOs, configVo, param);

				//sendCmd(ctx.tokenSession.get(i), sendMessage);
				notificationService.sendCmd(ctx.tokenSession.get(i), sendMessage);
				persistPushLog(ctx.tokenSession.get(i), ctx.behavior.getAction(), configVo);
				
				StringBuilder sb = new StringBuilder();
				sb.append(ctx.tokenSession.get(i).getSysId()).append(",").append(ctx.tokenSession.get(i).getXppId()).append(",").append(ctx.tokenSession.get(i).getTag())
						.append(",").append(action.getAction());
				taskRecord.add(sb.toString());
				
			}
			
			exportCaseInfo(ctx.timestamp, "taskrecord.csv", taskRecord);

			

		}

	}

}
