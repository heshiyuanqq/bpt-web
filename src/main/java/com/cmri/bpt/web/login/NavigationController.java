package com.cmri.bpt.web.login;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.util.AntPathMatcher;
import org.springframework.util.PathMatcher;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.util.UrlPathHelper;

@Controller
@RequestMapping(value = "/nav", produces = MediaType.APPLICATION_JSON_VALUE)
public class NavigationController {
	public static final String OriginalRequestUrlKey = "_original_request_url_";

	private static final Log logger = LogFactory.getLog(NavigationController.class);

	private static final UrlPathHelper urlPathHelper = new UrlPathHelper();

	private static final PathMatcher pathMatcher = new AntPathMatcher();

	@RequestMapping(value = "/**", method = RequestMethod.GET)
	public ModelAndView navPage(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		String path = urlPathHelper.getLookupPathForRequest(request);
		Map<String, String[]> paramMap = cloneRequestParameters(request);		

		String view = path.replace("/nav", "");
		return new ModelAndView(view, paramMap);
	}

	private Map<String, String[]> cloneRequestParameters(HttpServletRequest request) {
		Map<String, String[]> paramMap = request.getParameterMap();

		return paramMap;

	}

}
