package com.cmri.bpt.web.restor.user;

import java.util.HashMap;
import java.util.Map;

import com.cmri.bpt.common.annotation.Param;
import com.cmri.bpt.common.annotation.Return;
import com.cmri.bpt.common.base.Result;
import com.cmri.bpt.common.base.Result.Type;
import com.cmri.bpt.common.http.HttpMethod;
import com.cmri.bpt.common.rest.RestMapping;
import com.cmri.bpt.common.rest.Restor;
import com.cmri.bpt.common.token.TokenSession;
import com.cmri.bpt.common.token.TokenSessionStore;
import com.cmri.bpt.common.user.UserContext;
import com.cmri.bpt.common.user.UserContextHolder;
import com.cmri.bpt.service.user.UserService;
import com.cmri.bpt.service.user.bo.User;
import com.cmri.bpt.web.restor.RestBase;
import com.cmri.bpt.web.restor.SpringBeanUtil;
import com.cmri.bpt.web.util.PhoneCrawlerHolder;
import com.cmri.bpt.web.util.PhoneNumberCrawler;

@Restor(category = "个人信息")
@RestMapping(value = "/v1/user", desc = "用户个人信息", method = HttpMethod.POST)
public class UserRestor extends RestBase {

	UserService userService = SpringBeanUtil.getBean(UserService.class);

	@RestMapping(value = "/login", desc = "用户登录")
	@Return(desc = "后续交互必要的用户基本信息(属性：token, UserId,SysId, phoneNumber, nickname, gender)", xType = Map.class)
	public Result<Map<String, Object>> login(@Param(name = "appId", desc = "appId，客户版：android = 1") Integer appId,
			@Param(name = "phoneNumber", desc = "用户手机号") String phoneNumber,
			@Param(name = "password", desc = "密码") String password, @Param(name = "xppId") String xppId) {

		Result<Map<String, Object>> result = Result.newOne();

		try {

			Result<User> userResult = this.userService.login(phoneNumber, password);
			//
			if (userResult.type != Type.warn) {

				User usr = userResult.data;

				result.message = "登录信息验证成功";
				//
				Integer userId = usr.getId();

				String token = updateUserToken(userId, appId, xppId);

				Integer sysId = getSysId(token);

				logger.debug("登录用户Id:" + userId + " 用户系统Id: " + sysId + " 登录用户token: " + token);

				result.data = getloginInfo(token, usr, sysId);

			} else {
				result.type = Type.warn;
				result.message = userResult.message;
			}
		} catch (Exception ex) {

			result.type = Type.warn;
			result.message = "登录失败：" + ex.getMessage();
		}

		return result;
	}

	@RestMapping(value = "/logout", desc = "用户登出（退出）")
	@Return(desc = "是否进行了必要退出（保证清除token session信息）")
	public Boolean logout() {

		UserContext userContext = this.getUserContext();
		String token = userContext.getToken();
		if (token != null) {

			this.clearUserContext();
			//
			TokenSessionStore tokenSessionStore = UserContextHolder.getTokenSessionStore();
			tokenSessionStore.removeTokenSession(token);

			return true;
		} else {
			return false;
		}
	}

	@RestMapping(value = "/ueLoc", desc = "终端坐标信息")
	public Boolean ueLoc(@Param(name = "lng") Double lng, @Param(name = "lat") Double lat) {

		this.checkAuthenticationWithFailureMessage(null);

		UserContext userContext = this.getUserContext();
		String token = userContext.getToken();

		logger.debug(token + " lng:" + lng + " lat:" + lat);

		updateUserToken(lat, lng, null, null);

		return true;
	}

	@RestMapping(value = "/ueInfo", desc = "终端信息")
	public Boolean ueInfo(@Param(name = "phoneType") String phoneType,
			@Param(name = "phoneNumber") String phoneNumber) {

		this.checkAuthenticationWithFailureMessage(null);

		UserContext userContext = this.getUserContext();
		String token = userContext.getToken();

		logger.debug(token + " phoneType:" + phoneType + " phoneNumber:" + phoneNumber);

		updateUserToken(null, null, phoneType, phoneNumber);

		return true;
	}

	@RestMapping(value = "/uePhone", desc = "终端信息")
	public Boolean uePhone(@Param(name = "ueId") String ueId, @Param(name = "phoneNumber") String phoneNumber) {

		this.checkAuthenticationWithFailureMessage(null);

		UserContext userContext = this.getUserContext();
		String token = userContext.getToken();

		TokenSessionStore tokenSessionStore = UserContextHolder.getTokenSessionStore();
		TokenSession ts = tokenSessionStore.getTokenSession(token);

		PhoneNumberCrawler crawler = PhoneCrawlerHolder.getPhoneCrawler(userContext.getUserId());
		if (crawler != null) {
			crawler.phoneHandle(Integer.valueOf(ueId), ts.getId(), phoneNumber);
		}

		return true;
	}

	/////////////////////////////
	// Help method
	/////////////////////////////

	private String updateUserToken(int userId, int appId, String xppId) {

		// 创建TokenSession
		TokenSessionStore tokenSessionStore = UserContextHolder.getTokenSessionStore();
		TokenSession tokenSession = tokenSessionStore.createTokenSession(userId, appId, xppId);
		String token = tokenSession.getToken();
		//
		UserContext userContext = this.getUserContext();
		userContext.setUserId(userId);
		userContext.setAppId(appId);
		userContext.setToken(token);

		return token;
	}

	private Integer getSysId(String token) {

		TokenSessionStore tokenSessionStore = UserContextHolder.getTokenSessionStore();
		TokenSession s = tokenSessionStore.getTokenSession(token);
		return s.getSysId();

	}

	private void updateUserToken(Double lat, Double lng, String phoneType, String phoneNumber) {

		// 创建TokenSession
		TokenSessionStore tokenSessionStore = UserContextHolder.getTokenSessionStore();
		UserContext userContext = this.getUserContext();
		tokenSessionStore.syncTokenSession(userContext.getToken());
		TokenSession tokenSession = tokenSessionStore.getTokenSession(userContext.getToken());

		if (lat != null)
			tokenSession.setLastLat(lat);

		if (lng != null)
			tokenSession.setLastLng(lng);

		if (phoneType != null && !phoneType.isEmpty())
			tokenSession.setPhoneType(phoneType);

		if (phoneNumber != null && !phoneNumber.isEmpty())
			tokenSession.setPhoneNumber(phoneNumber);

		tokenSessionStore.updateTokenSession(tokenSession);

	}

	private Map<String, Object> getloginInfo(String token, User user, Integer sysId) {
		Map<String, Object> loginInfo = new HashMap<String, Object>();
		loginInfo.put("token", token);
		loginInfo.put("userId", user.getId());
		loginInfo.put("sysId", sysId);
		loginInfo.put("phoneNumber", user.getPhoneNumber());
		loginInfo.put("nickname", user.getNickname());

		return loginInfo;
	}

}