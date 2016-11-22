package com.cmri.bpt.web.interceptor;


import java.io.PrintWriter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.cmri.bpt.common.exception.UnAuthorizedException;
import com.cmri.bpt.service.user.bo.User;

public class AuthorizedInterceptor extends HandlerInterceptorAdapter {

	private static final Logger logger = Logger.getLogger(AuthorizedInterceptor.class);

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {

		super.postHandle(request, response, handler, modelAndView);
	}

	@Override
	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
		super.afterCompletion(request, response, handler, ex);

	}

	@Override
	public void afterConcurrentHandlingStarted(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		super.afterConcurrentHandlingStarted(request, response, handler);

	}

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

		User user = (User) request.getSession().getAttribute("user");

		if (user == null) {
			try {

				String acceptType = request.getHeader("Accept");
				if (acceptType.contains("/json")) {
					acceptType = "json";
				} else if (acceptType.contains("/html")) {
					acceptType = "html";
				} else {
					acceptType = "*/*";
				}

				if ("json".equals(acceptType)) {

				} else {
					//response.sendRedirect("/login");这样跳转的是ifream而不是最顶层窗口
				      PrintWriter out = response.getWriter();
				      StringBuilder sb=new StringBuilder("");
				      sb.append("<html>");  
				      sb.append("<script type=\"text/javascript\">"); 
				      sb.append("window.open('/web/login','_top')");  
				      sb.append("</script>");  
				      sb.append("</html>");
				      out.print(sb.toString());
				      out.close();
				      return false;
				}

			} catch (Exception ee) {

				logger.error(ee.getMessage());
			}

		}

		return true;
	}

}