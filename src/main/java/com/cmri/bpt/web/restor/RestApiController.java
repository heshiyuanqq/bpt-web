package com.cmri.bpt.web.restor;

import java.util.List;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.cmri.bpt.common.base.Result;
import com.cmri.bpt.common.base.Result.Type;
import com.cmri.bpt.common.rest.RestProxy;



@Controller
@RequestMapping(value = "/restApi", produces = MediaType.APPLICATION_JSON_VALUE)
public class RestApiController {
	RestProxy restProxy;

	public RestApiController() {
		restProxy = RestProxy.getDefault();
	}

	@RequestMapping(value = "/list", method = RequestMethod.GET)
	@ResponseBody
	public ResponseEntity<Result<List<Map<String, String>>>> doGet1() {
		Result<List<Map<String, String>>> result = Result.newOne();
		result.data = restProxy.getApiRestorList();

		return new ResponseEntity<Result<List<Map<String, String>>>>(result,
				HttpStatus.OK);
	}

	@RequestMapping(value = "/restor/{restorName}", method = RequestMethod.GET)
	@ResponseBody
	public ResponseEntity<Result<Map<String, Object>>> doGet2(
			@PathVariable String restorName) {
		Result<Map<String, Object>> result = Result.newOne();
		result.data = restProxy.getApiRestor(restorName);
		return new ResponseEntity<Result<Map<String, Object>>>(result,
				HttpStatus.OK);
	}

	@RequestMapping(value = "/class/{className}", method = RequestMethod.GET)
	@ResponseBody
	public ResponseEntity<Result<List<Map<String, String>>>> doGet3(
			@PathVariable String className) {
		Result<List<Map<String, String>>> result = Result.newOne();
		Class<?> clazz = null;
		try {
			clazz = Class.forName(className.replace('-', '.'));
			result.data = restProxy.getApiClassFields(clazz);
		} catch (ClassNotFoundException e) {
			result.type = Type.warn;
			result.message = "未找到给定的类[" + className + "]";
		}
		return new ResponseEntity<Result<List<Map<String, String>>>>(result,
				HttpStatus.OK);
	}
}
