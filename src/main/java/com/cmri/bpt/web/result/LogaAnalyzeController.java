package com.cmri.bpt.web.result;

import java.net.URLDecoder;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.cmri.bpt.common.entity.LogAnylizeInfoVO;
import com.cmri.bpt.common.entity.LogSequenceVO;
import com.cmri.bpt.common.user.UserContext;
import com.cmri.bpt.common.user.UserContextHolder;
import com.cmri.bpt.common.util.GetFileName;
import com.cmri.bpt.service.result.logsequence.ILogSequenceService;

/**
 * log分析表处理（页面的表）
 * @author gehb
 *
 */
@Controller
@RequestMapping(value = "/logAnalyze")
public class LogaAnalyzeController  {

	/*@Autowired
	private ILogService logService;*/
	@Autowired
	private ILogSequenceService logSequenceService;
	
	/**
	 * log基本分析信息
	 * @param mode
	 * @param request caselogname：测试name+时间戳
	 * @param response
	 * @return
	 */
	@RequestMapping(value = "/loganylizebycaselogname", method = RequestMethod.GET)
	public ModelAndView loganylizebycaselogname( Model mode, HttpServletRequest request, HttpServletResponse response) {
		//返回值（成功/失败）
		String returnCode = "SUCCESS";
		LogAnylizeInfoVO logAnylizeInfoVO = new LogAnylizeInfoVO();
		try {
			request.setCharacterEncoding("UTF-8");//传值编码
			response.setContentType("text/html;charset=UTF-8");//设置传输编码
			String caselogname = request.getParameter("caselogname");
			
			//caselogname=URLDecoder.decode(caselogname,"UTF-8");
			caselogname= new String(caselogname.getBytes("ISO-8859-1"),"UTF-8");
			GetFileName.maps=this.getnewpath(caselogname);
		//	String path = request.getSession().getServletContext().getRealPath("/");
			logAnylizeInfoVO.setCaselogname(caselogname);
		}catch (Exception e) {
			e.printStackTrace();
			returnCode ="FAILED";
		} finally {
			if(returnCode == null){
				returnCode = "SUCCESS";
			}
		}
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("result/resultShow");
		modelAndView.addObject("returnCode", returnCode);
		modelAndView.addObject("logAnylizeInfoVO", logAnylizeInfoVO);
		return modelAndView;
	}
	
	
	public Map<String,Map<String,Integer>> getnewpath(String case_name){
		LogSequenceVO logSequenceVO = new LogSequenceVO();
		logSequenceVO.setCase_file_name(case_name);
		List<LogSequenceVO> logSequenceVOs = null;
		Map<String, Integer> logSequenceMap=new HashMap<String, Integer>();
		Map<String,Map<String,Integer>> retMap=new HashMap<String, Map<String,Integer>>();
		//String userid="user1";
				UserContext ctx = UserContextHolder.getUserContext();
				String userid=ctx.getUserId().toString();
		try {
			logSequenceVOs = this.logSequenceService
					.selectLogSequenceByCaseFileName(logSequenceVO);
		logSequenceMap = GetFileName.getLogSequenceMap(logSequenceVOs);
		retMap.put(userid, logSequenceMap);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return retMap;
		
	}
	
	
}
