package com.cmri.bpt.web.restor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Date;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.cmri.bpt.common.base.Result;
import com.cmri.bpt.common.base.Result.Type;
import com.cmri.bpt.common.exception.AuthenticationException;
import com.cmri.bpt.common.rest.RestProxy;
import com.cmri.bpt.common.user.UserContextHandler;
import com.cmri.bpt.common.user.UserContextHolder;
import com.cmri.bpt.common.util.DateUtil;



@Controller
@RequestMapping(value = "/rest", produces = MediaType.APPLICATION_JSON_VALUE)
public class RestController {
    public static final String REQUEST_MAPPING_ROOT = "/rest/";

    private Log logger = LogFactory.getLog("rest." + RestController.class.getName());
    // private Log logger = LogFactory.getLog(RestController.class.getName());
    //
    RestProxy          restProxy;
    //
    UserContextHandler userContextHandler;

    public RestController() {
        restProxy = RestProxy.getDefault();
        //
        userContextHandler = UserContextHolder.getUserContextHandler();
    }

    private Result<?> handleTokenSessionUserContext(HttpServletRequest request) {
        Result<?> result = null;
        // ------------------------------------------------------------------
        try {
        	
        	System.err.println("****************userContextHandler="+userContextHandler+"*****************");
            userContextHandler.handleTokenSessionUserContext(request);
        } catch (AuthenticationException ex) {
            result = Result.newOne();
            result.type = Type.warn;
            result.message = ex.getMessage();

            logger.debug(result.toString());
        }

        // ------------------------------------------------------------------
        return result;
    }

    @SuppressWarnings("unchecked")
    @RequestMapping(value = "/ping", method = RequestMethod.GET)
    @ResponseBody
    public ResponseEntity<Result<Object>> ping(HttpServletRequest request) {
        //
        Result<Object> result = (Result<Object>) this.handleTokenSessionUserContext(request);
        if (result == null) {
            result = Result.newOne();
            result.data = DateUtil.toStdDateTimeStr(new Date());
            return new ResponseEntity<Result<Object>>(result, HttpStatus.OK);
        } else {
            return new ResponseEntity<Result<Object>>(result, HttpStatus.UNAUTHORIZED);
        }
    }

    @RequestMapping(value = "/**", method = RequestMethod.GET)
    @ResponseBody
    public ResponseEntity<Result<?>> doGet(HttpServletRequest request, HttpServletResponse response) {
        Result<?> result = this.handleTokenSessionUserContext(request);        
        if (result == null) {
            result = restProxy.handleGetRequest(request, response);
            //
            HttpStatus status = HttpStatus.valueOf(response.getStatus());
            return new ResponseEntity<Result<?>>(result, status);
           
        } else {
            return new ResponseEntity<Result<?>>(result, HttpStatus.UNAUTHORIZED);
        }
    }

    @RequestMapping(value = "/**", method = RequestMethod.POST)
    @ResponseBody
    public ResponseEntity<Result<?>> doPost(HttpServletRequest request, HttpServletResponse response) {
        Result<?> result = this.handleTokenSessionUserContext(request);    	
        if (result == null) {
            result = restProxy.handlePostRequest(request, response);
           // //
            HttpStatus status = HttpStatus.valueOf(response.getStatus());
            return new ResponseEntity<Result<?>>(result, status);
            
        } else {
            return new ResponseEntity<Result<?>>(result, HttpStatus.UNAUTHORIZED);
        }
    }

    @RequestMapping(value = "/**", method = RequestMethod.PUT)
    @ResponseBody
    public ResponseEntity<Result<?>> doPut(HttpServletRequest request, HttpServletResponse response) {
        //Result<?> result = this.handleTokenSessionUserContext(request);
        Result<?> result=null;
        if (result == null) {
            result = restProxy.handlePutRequest(request, response);
            //
            HttpStatus status = HttpStatus.valueOf(response.getStatus());
            return new ResponseEntity<Result<?>>(result, status);
           
        } else {
            return new ResponseEntity<Result<?>>(result, HttpStatus.UNAUTHORIZED);
        }
    }
}
