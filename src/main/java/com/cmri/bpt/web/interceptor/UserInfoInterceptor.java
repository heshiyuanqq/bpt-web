package com.cmri.bpt.web.interceptor;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.cmri.bpt.common.user.UserContext;
import com.cmri.bpt.common.user.UserContextHandler;
import com.cmri.bpt.common.user.UserContextHolder;
import com.cmri.bpt.service.param.mapper.SysParamMapper;
import com.cmri.bpt.service.user.UserService;
import com.cmri.bpt.service.user.bo.User;
import com.cmri.bpt.web.restor.RestController;

public class UserInfoInterceptor extends HandlerInterceptorAdapter {

	private static final Logger userLogger = Logger.getLogger("user." + UserInfoInterceptor.class);

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {

		super.postHandle(request, response, handler, modelAndView);
	}

	@Override
	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex)
			throws Exception {
		super.afterCompletion(request, response, handler, ex);

	}

	@Override
	public void afterConcurrentHandlingStarted(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		super.afterConcurrentHandlingStarted(request, response, handler);

	}

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {

		// ------------------------------------------------------------------
		HandleUser(request);

		return true;
	}

	@Resource
	private UserService userService;
	//
	UserContextHandler userContextHandler = UserContextHolder.getUserContextHandler();

	protected void HandleUser(HttpServletRequest request) {
		String uri = request.getRequestURI();
		System.out.println(uri);
		if (request.getRequestURI().startsWith(RestController.REQUEST_MAPPING_ROOT)) {
			return;
		}

		if (request.getRequestURI().startsWith("/vendors/") || request.getRequestURI().startsWith("/resoures/")) {
			return;
		}

		userLogger.debug("url:" + request.getRequestURI());

		User user = (User) request.getSession().getAttribute("user");

		UserContext userContext = UserContextHolder.getUserContext();

		if (user != null) {

			HttpSession session = request.getSession();
			userContext = (UserContext) session.getAttribute(UserContextHolder.SESSION_KEY_USER_CONTEXT);

			if (userContext == null || !user.getId().equals(userContext.getUserId())) {

				userContext = UserContextHolder.getUserContext();
				// 设置登陆上下文
				userContext.clear();
				userContext.setHttpSession(session);
				userContext.setUserId(user.getId());
				UserContextHolder.setUserContext(userContext);
				userContext = UserContextHolder.loadUserInfoIntoContext();
				//
				session.setAttribute(UserContextHolder.SESSION_KEY_USER_CONTEXT, userContext);

			} else {
				UserContextHolder.setUserContext(userContext);
			}

			userLogger.debug("userId:" + userContext.getUserId());

			// 用户已登录 需要判定 是否是处理Token的线程
			if (userContext.isAuthenticated()) {
				return;
			}

		} else {

			userLogger.debug("userId: null");
			userContext.clear();
			userContext = UserContextHolder.loadUserInfoIntoContext();

		}

	}
}