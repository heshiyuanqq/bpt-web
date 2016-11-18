package com.cmri.bpt.web.resolver;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.context.MessageSource;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.HttpRequestMethodNotSupportedException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.AbstractHandlerExceptionResolver;

import com.cmri.bpt.common.base.Result;
import com.cmri.bpt.common.exception.BusinessException;
import com.cmri.bpt.common.exception.FieldValidationException;
import com.cmri.bpt.common.exception.HandleException;
import com.cmri.bpt.common.exception.UnAuthorizedException;
import com.cmri.bpt.common.util.JsonUtil;

/**
 * spring 捕获异常的统一处理
 */
public class ExceptionResolver extends AbstractHandlerExceptionResolver {

	private final static Log logger = LogFactory.getLog(ExceptionResolver.class);

	private String errorPage = "/error/error";
	private String errorInfoKey = "errorInfo";
	private String userLoginPage = "/login";
	private String notAuthorizedInfoKey = "notAuthorizedInfo";

	public void setErrorPage(String errorPage) {
		this.errorPage = errorPage;
	}

	public void setErrorInfoKey(String errorInfoKey) {
		this.errorInfoKey = errorInfoKey;
	}

	public void setNotAuthorizedInfoKey(String notAuthorizedInfoKey) {
		this.notAuthorizedInfoKey = notAuthorizedInfoKey;
	}

	@Resource(name = "messageSource")
	protected MessageSource messageSource;

	@Override
	protected ModelAndView doResolveException(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) {
		String contentType = request.getHeader("Accept");
		if (contentType == null) {
			contentType = request.getHeader("Content-Type");
		}
		if (contentType.contains("/json")) {
			contentType = "json";
		} else if (contentType.contains("/html")) {
			contentType = "html";
		} else {
			contentType = "*/*";
		}
		//
		Result<?> result = Result.newOne();

		// 对于未授权的异常
		if (ex instanceof UnAuthorizedException) {
			response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
			result.error("请重新登录!");
			result.codeName ="login";
		}

		String errorJson = JsonUtil.toJson(result);

		if ("json".equals(contentType)) {
			ServletOutputStream outputStream = null;
			try {
				outputStream = response.getOutputStream();
				outputStream.write(errorJson.getBytes());
				outputStream.flush();
				outputStream.close();
			} catch (IOException e) {
				logger.error("", e);
			}
			return null;
		} else {
			ModelAndView mv = new ModelAndView(this.errorPage);
			mv.addObject(this.errorInfoKey, errorJson);
			return mv;
		}
	}

}
