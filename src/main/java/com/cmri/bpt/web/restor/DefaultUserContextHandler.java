package com.cmri.bpt.web.restor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.cmri.bpt.common.exception.AuthenticationException;
import com.cmri.bpt.common.token.TokenSession;
import com.cmri.bpt.common.token.TokenSessionStore;
import com.cmri.bpt.common.user.UserContext;
import com.cmri.bpt.common.user.UserContextHandler;
import com.cmri.bpt.common.user.UserContextHolder;
import com.cmri.bpt.common.util.HttpUtil;

public class DefaultUserContextHandler implements UserContextHandler {

	private static final Log logger = LogFactory.getLog(DefaultUserContextHandler.class);

	public void handleHttpSessionUserContext(HttpServletRequest request) {
		String requestURI = request.getRequestURI();
		// System.out.println("RequestURL >> "+request.getRequestURL());
		// System.out.println("QueryString >> "+request.getQueryString());
		logger.info("RequestURI >> " + requestURI);
		// if (WebUtil.isStaticResourceURI(requestURI)) {
		// return;
		// }

		HttpSession session = request.getSession();
		// 拦截url中的token
		String token = request.getParameter(TokenSession.TOKEN_PARAM_NAME);
		if (token != null && token.trim().length() > 0) {
			// 可能是从REST环境打开(激活的)页面
			TokenSessionStore tokenSessionStore = UserContextHolder.getTokenSessionStore();
			TokenSession tokenSession = tokenSessionStore.getTokenSession(token);
			if (tokenSession != null) {
				// 已通过REST登陆
				tokenSessionStore.touchTokenSession(token);
				//
				Integer userId = tokenSession.getUserId();
				//UserSessionManager.setUserId(request, userId);

				// 设置登陆上下文
				UserContext userContext = new UserContext();
				userContext.setUserId(userId);
				userContext.setHttpSession(session);
				userContext.setAppId(tokenSession.getAppId());
				userContext.setDerivedToken(token);
				String ip = HttpUtil.getIpAddrByRequest(request);
				userContext.setClientIp(ip);
				// 设置上下文
				UserContextHolder.setUserContext(userContext);
				userContext = UserContextHolder.loadUserInfoIntoContext();
				//
				session.setAttribute(UserContextHolder.SESSION_KEY_USER_CONTEXT, userContext);
				//
				return;
			}
		}

		UserContext userContext = (UserContext) session.getAttribute(UserContextHolder.SESSION_KEY_USER_CONTEXT);
		if (userContext != null) {
			token = userContext.getDerivedToken();
			if (token != null) {
				// 是通过REST激活的
				TokenSessionStore tokenSessionStore = UserContextHolder.getTokenSessionStore();
				if (tokenSessionStore.getTokenSession(token) != null) {
					// token仍然有效
					tokenSessionStore.touchTokenSession(token);
					//
					UserContextHolder.setUserContext(userContext);
				} else {
					// ...... token已经失效
					logger.error("==============调用session.invalid()方法");
					UserContextHolder.clearUserContext();
				}
			} else {
				// 常规认证
				UserContextHolder.setUserContext(userContext);
			}
		}
		userContext = UserContextHolder.getUserContext();
		userContext.setHttpSession(session);
		String ip = HttpUtil.getIpAddrByRequest(request);
		userContext.setClientIp(ip);
		//
		UserContextHolder.setUserContext(userContext);
	}

	public void handleTokenSessionUserContext(HttpServletRequest request) {
		boolean tokenIsValid = false;
		String token = request.getParameter(TokenSession.TOKEN_PARAM_NAME);
		if (token != null) {
			TokenSessionStore tokenSessionStore = UserContextHolder.getTokenSessionStore();
			TokenSession tokenSession = tokenSessionStore.getTokenSession(token);
			if (tokenSession != null) {
				tokenIsValid = true;
				//
				tokenSessionStore.touchTokenSession(token);
				//
				UserContext userContext = UserContextHolder.getUserContext();
				userContext.setUserId(tokenSession.getUserId());
				userContext.setAppId(tokenSession.getAppId());
				userContext.setToken(tokenSession.getToken());
				String ip = HttpUtil.getIpAddrByRequest(request);
				userContext.setClientIp(ip);
				//
				UserContextHolder.setUserContext(userContext);
				//
				UserContextHolder.loadUserInfoIntoContext();
			} else {
				throw new AuthenticationException("会话超时或已失效");
			}
		}
		if (!tokenIsValid) {
			UserContext userContext = UserContextHolder.getUserContext();
			String ip = HttpUtil.getIpAddrByRequest(request);
			userContext.setClientIp(ip);
			//
			UserContextHolder.setUserContext(userContext);
		}
	}
}
