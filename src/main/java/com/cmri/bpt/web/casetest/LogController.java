package com.cmri.bpt.web.casetest;

import java.net.URLDecoder;
import java.text.SimpleDateFormat;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.cmri.bpt.common.entity.LogSequenceVO;
import com.cmri.bpt.common.util.GetFileName;
import com.cmri.bpt.service.result.logsequence.ILogSequenceService;
import com.cmri.bpt.service.result.logsequence.ILogService;

@Controller
@RequestMapping(value = "/log")
public class LogController {
	
	static Logger logger = Logger.getLogger(LogController.class);
	
	@Autowired
	private ILogService logService;
	@Autowired
	private ILogSequenceService logSequenceService;
	
	@ResponseBody
	@RequestMapping(value = "/receivelog", method = RequestMethod.POST)
	public String receivelog(Model mode, @RequestParam("zipfile") MultipartFile file,
			HttpServletRequest request, HttpServletResponse response) {
		
		String returnCode = null;
		try{
			request.setCharacterEncoding("UTF-8");
			
			//返回值（成功/失败）
			
			String imsino = request.getParameter("imsino");
			String finish_flag = request.getParameter("finishFlag");
			String userId = request.getParameter("userId");
			String sequence_no = request.getParameter("sequenceNo");
			if(!StringUtils.hasText(finish_flag)){
				finish_flag = "false";
			}
			
			String filename = URLDecoder.decode(file.getOriginalFilename(), "UTF-8");
			filename = filename.substring(0, filename.lastIndexOf("."));
			System.out.println(filename);
			String[] filenames = filename.split("_");
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy年MM月dd日HH时mm分ss秒");
			String sDateTime = sdf.format(Long.parseLong(filenames[2]));
			String case_file_name = filenames[1] + "_" + sDateTime;
			String imsinum = filenames[0];
			
			//验证是否userIndex 相同
			String userIdx = filenames[1].split("bpt")[0];
			
			
			//如果不相同 以文件上所带的Id为准
			if(!userId.equals(userIdx))
				userId = userIdx;
			
			
			// 文件保存目录
	        String decompressDir = request.getSession().getServletContext().getRealPath("/")
	        		+ "testcase/" + userId + "/" + filenames[1] +"_"
	        		+ sDateTime +"/"+ filenames[0] +"/" + sequence_no + "/";
	        // 文件保存路径  
	        String filePath = decompressDir + file.getOriginalFilename(); 
	        
	        logger.debug(filePath);
	        
			logService.receiveLogAndUnzip(file,filePath,decompressDir);
			
			LogSequenceVO logSequenceVO = new LogSequenceVO();
			logSequenceVO.setCase_file_name(case_file_name);
			logSequenceVO.setFinish_flag(finish_flag);
			logSequenceVO.setSequence_no(Integer.parseInt(sequence_no));
			logSequenceVO.setLocation(imsinum);
			logSequenceVO.setFlag(0);
			this.logSequenceService.saveLogSequence(logSequenceVO);
			
			/*
			String deleteFilePath = request.getSession().getServletContext().getRealPath("/")
	        		+ "testcase/" + userId + "/" + filenames[1] +"_"
	        		+ sDateTime +"/"+ filenames[0];
			Integer fileNumber = Integer.parseInt(sequence_no);
			
			GetFileName.deleteFile(deleteFilePath, fileNumber-1);
			*/
			
		}catch(Exception e){
			returnCode = "FAILED";
		}finally{
			if (null == returnCode) {
				returnCode = "SUCCESS";
			}
		}
		return returnCode;
	}
}
