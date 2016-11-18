package com.cmri.bpt.web.casetest;

import java.sql.SQLException;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.cmri.bpt.common.util.JsonUtil;
import com.cmri.bpt.entity.po.BaseActionPO;
import com.cmri.bpt.service.action.interfac.IActionService;

@Controller
@RequestMapping("/webAction")
public class ActionController {
	
	@Autowired
	private IActionService actionService;
	
	private static final Log logger = LogFactory.getLog("rest."+ActionController.class);
	
	/**
	 * 获取测试行为
	 * @return JSON POList
	 */
	@ResponseBody
	@RequestMapping(value="/getActionListWeb",method = RequestMethod.POST)
	public String getActionList(){
		String reStr = "FAILED";
		try {
			List<BaseActionPO> polist = actionService.getAllAction();
			if(polist != null){
				reStr = JsonUtil.Object2Json(polist);
				logger.debug(reStr);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return reStr;
	}
}
