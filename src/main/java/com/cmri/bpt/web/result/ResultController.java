package com.cmri.bpt.web.result;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
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
import org.springframework.web.bind.annotation.ResponseBody;

import com.cmri.bpt.common.entity.FileNamesPO;
import com.cmri.bpt.common.entity.LogSequenceVO;
import com.cmri.bpt.common.user.UserContext;
import com.cmri.bpt.common.user.UserContextHolder;
import com.cmri.bpt.common.util.GetFileName;
import com.cmri.bpt.common.util.JsonUtil;
import com.cmri.bpt.common.util.SaveStringToFile;
import com.cmri.bpt.service.result.logsequence.ILogSequenceService;
import com.sun.org.apache.xerces.internal.impl.xpath.regex.ParseException;


@Controller
@RequestMapping(value = "/result")
public class ResultController {
	@Autowired
	private ILogSequenceService logSequenceService;
	/**
	 * 
	 * @功能 查询testcase文件夹下所有已经测试过并有测试结果的case名
	 * @日期 2016年1月26日
	 * @返回值类型 String
	 * @author 范晓文
	 * @package名 com.reserch.controller
	 * @文件名 ResultController.java
	 */
	@SuppressWarnings({ "unused", "unchecked" })
	@ResponseBody
	@RequestMapping(value = "/searchallcase", method = RequestMethod.POST,produces = "text/html;charset=UTF-8")
	public String selectenbconfigbycaseid(Model mode, 
		HttpServletRequest request, HttpServletResponse response) {
		String returnjson=null;
		String filenamesjson=null;
		List<FileNamesPO> filenames=new ArrayList<FileNamesPO>();
		
		try{
			String selectedcase = request.getParameter("selectedcase");
			String start_date = request.getParameter("start_date");
			String end_date = request.getParameter("end_date");
			if(!selectedcase.equals(" ")){
				FileNamesPO filename=new FileNamesPO();
				filename.setFilename(selectedcase);
				filenames.add(filename);
				returnjson=JsonUtil.Object2Json(filenames);
			}else{
				String a=request.getSession().getServletContext().getRealPath("/") + "testcase/";
				List<FileNamesPO> allfilenames=new ArrayList<FileNamesPO>();
				GetFileName getfilename=new GetFileName();
				//String userid="user1";
				UserContext ctx = UserContextHolder.getUserContext();
				String userid=ctx.getUserId().toString();
				allfilenames=getfilename.getFolderName1(request.getSession().getServletContext().getRealPath("/") + "testcase/"+userid);
				long start_timestemp=start_date.equals(" ")?0L:timechange(start_date,0);
                long end_timestemp=end_date.equals(" ")?2147483647000L:timechange(end_date,0);
                if(allfilenames!=null&&allfilenames.size()!=0){
					for(FileNamesPO tmp:allfilenames){
						 String[] strarray=tmp.getFilename().split("_");
						 long t=timechange(strarray[1],1);
						 if(t>=start_timestemp && t<=(end_timestemp+24*60*60*1000)){
							 FileNamesPO filename1=new FileNamesPO();
							 filename1.setFilename(tmp.getFilename());
							 filename1.setCreattime(t);
							 filenames.add(filename1);
						 }
						 
					}
					if(filenames==null||filenames.size()==0){
						returnjson=null;
					}else{
						 Collections.sort(filenames, new Comparator<FileNamesPO>(){
							 public int compare(FileNamesPO o1, FileNamesPO o2)
					            {
								 if(o1.getCreattime()>=o2.getCreattime()){
									return -1;
					                //比较规则
					            }else{
					            	return 1;
					            }
					           }
						 }
						 
				         );
					
					returnjson=JsonUtil.Object2Json(filenames);
					}
                }
                else{
                	returnjson=null;
                }
			
				
			}
			
		}
		catch(Exception e)
		{
			returnjson = "FAILED";
			e.printStackTrace();
		}
	
		return returnjson;
	}

/**
 * 
 * @功能 更改时间的格式，时间戳转格式
 * @日期 2016年1月26日
 * @返回值类型 long
 * @author 范晓文
 * @package名 com.reserch.controller
 * @文件名 ResultController.java
 */
public static long timechange(String datetime,int flag) throws ParseException{
	SimpleDateFormat simpleDateFormat=null;
	if(flag==0)
	{
      simpleDateFormat =new SimpleDateFormat("yyyy-MM-dd");
	}
	else if(flag==1)
	{
		simpleDateFormat =new SimpleDateFormat("yyyy年MM月dd日HH时mm分ss秒");
	}
    Date date = null;
	try {
		date = simpleDateFormat.parse(datetime);
	} catch (java.text.ParseException e) {
		e.printStackTrace();
	}
    long timeStemp =date.getTime();
   // System.out.println(timeStemp );
    return timeStemp;
}

/**
 * 
 * @功能  通过cse名称查询该case下所有的behavior类型
 * @日期 2016年1月26日
 * @返回值类型 String
 * @author 范晓文
 * @package名 com.reserch.controller
 * @文件名 ResultController.java
 */
@ResponseBody
@RequestMapping(value = "/searchbehaviorbycase", method = RequestMethod.POST)
public String searchbehaviorbycase(Model mode, 
	HttpServletRequest request, HttpServletResponse response) {
	String returnstring="";
	try{
		 String casename= request.getParameter("casename");
		//String userid="user1";
			UserContext ctx = UserContextHolder.getUserContext();
			String userid=ctx.getUserId().toString();
		 String filePath=request.getSession().getServletContext().getRealPath("/") + "testcase/"+userid+"/"+casename;
		 
		 List<String> behaviorlist=new ArrayList<String>();
		 returnstring=readActionstotxt(filePath , filePath + "/actions.txt",casename);
		 }
	catch(Exception e){
		 returnstring = "FAILED";
		 e.printStackTrace();
	}

	return returnstring;
}
/**
 * 
 * @功能 读取文件内容
 * @日期 2016年1月26日
 * @返回值类型 List<String>
 * @author 范晓文
 * @package名 com.reserch.controller
 * @文件名 ResultController.java
 */
public static List<String> readTxtFile(String filePath){
	  List<String> returnstring=new ArrayList<String>();
    try {
            String encoding="GBK";
            File file=new File(filePath);
            if(file.isFile() && file.exists()){ //判断文件是否存在
                InputStreamReader read = new InputStreamReader(
                new FileInputStream(file),encoding);//考虑到编码格式
                BufferedReader bufferedReader = new BufferedReader(read);
                String lineTxt = null;
                while((lineTxt = bufferedReader.readLine()) != null){
                	returnstring.add(lineTxt);
                    
                }
                
                read.close();
               
    }else{
        System.out.println("找不到指定的文件");
    }
    } catch (Exception e) {
        System.out.println("读取文件内容出错");

        e.printStackTrace();
    }
    return returnstring;
 
}
/**
 * 
 * @功能 读取该case名下所有action类型 并保存大action.txt文件中
 * @日期 2016年1月26日
 * @返回值类型 String
 * @author 范晓文
 * @package名 com.reserch.controller
 * @文件名 ResultController.java
 */
private  String readActionstotxt(String filePath,String fileName,String casename){
	List<FileNamesPO> listfilename=new ArrayList<FileNamesPO>();
	String actiontxt="";
	int flag_Tel=0;
	int flag_WeiXinText=0;
	int flag_WeiXinImage=0;
	int flag_WeiXinVoice=0;
	int flag_WeiXinVideo=0;
	int flag_FTP=0;
	int flag_SMS=0;
	int flag_Web=0;
	int flag_Ping=0;
	int flag_Network=0;
	int flag_CellChange=0;
	
	
	try{
		GetFileName.maps=getnewpath(casename);
		GetFileName getfilename=new GetFileName();
		listfilename=getfilename.getFolderName(filePath);
		if(listfilename!=null&& listfilename.size()>0){
			for(FileNamesPO filename:listfilename){
				if(flag_FTP==0&&(GetFileName.IsExistfile(filePath+"/"+filename.getFilename(),"FTPDownLog.csv") || GetFileName.IsExistfile(filePath+"/"+filename.getFilename(),"FTPUpLog.csv"))){
					actiontxt=actiontxt+";"+"FTP";
					flag_FTP=1;
				}
				if(flag_Network==0&&GetFileName.IsExistfile(filePath+"/"+filename.getFilename(),"networklog.csv")){
					actiontxt=actiontxt+";"+"Network";
					flag_Network=1;
				}
				if(flag_Web==0&&GetFileName.IsExistfile(filePath+"/"+filename.getFilename(),"WebLog.csv")){
					actiontxt=actiontxt+";"+"Web";
					flag_Web=1;
				}
				if(flag_Tel==0&&(GetFileName.IsExistfile(filePath+"/"+filename.getFilename(),"sendCallLog.csv")|| GetFileName.IsExistfile(filePath+"/"+filename.getFilename(),"CallLog.csv"))){
					actiontxt=actiontxt+";"+"Tel";
					flag_Tel=1;
				}
				/*if(flag_Tel==0&&(GetFileName.IsExistfile(filePath+"/"+filename.getFilename(),"sendCallLog.csv")|| GetFileName.IsExistfile(filePath+"/"+filename.getFilename(),"CallLog.csv"))){
					actiontxt=actiontxt+";"+"Tel";
					flag_Tel=1;
				}
				if(flag_SMS==0&&GetFileName.IsExistfile(filePath+"/"+filename.getFilename(),"smslog.csv")){
					actiontxt=actiontxt+";"+"SMS";
					flag_SMS=1;
				}
				if(flag_Ping==0&&GetFileName.IsExistfile(filePath+"/"+filename.getFilename(),"ping.csv")){
					actiontxt=actiontxt+";"+"Ping";
					flag_Ping=1;
				}
				if(flag_CellChange==0&&GetFileName.IsExistfile(filePath+"/"+filename.getFilename(),"networklog.csv")){
					actiontxt=actiontxt+";"+"CellChange";
					flag_CellChange=1;
				}*/
				if(flag_WeiXinText==0&&GetFileName.IsExistfile(filePath+"/"+filename.getFilename(),"WeiXinTextLog.csv")){
					actiontxt=actiontxt+";"+"WeiXinText";
					flag_WeiXinText=1;
				}
				/*if(flag_WeiXinImage==0&&GetFileName.IsExistfile(filePath+"/"+filename.getFilename(),"WeiXinImageLog.csv")){
					actiontxt=actiontxt+";"+"WeiXinImage";
					flag_WeiXinImage=1;
				}*/
				if(flag_WeiXinVoice==0&&GetFileName.IsExistfile(filePath+"/"+filename.getFilename(),"WeiXinVoiceLog.csv")){
					actiontxt=actiontxt+";"+"WeiXinVoice";
					flag_WeiXinVoice=1;
				}
				/*
				if(flag_WeiXinVideo==0&&GetFileName.IsExistfile(filePath+"/"+filename.getFilename(),"WeiXinVideo.csv")){
					actiontxt=actiontxt+";"+"WeiXinVideo";
					flag_WeiXinVideo=1;
				}*/
				
			}
			if(actiontxt!=null && !actiontxt.isEmpty()){
			actiontxt=actiontxt.substring(1);
			}else{
				return null;
			}
			
			SaveStringToFile.SaveJsonToFile1(actiontxt, filePath , fileName);
		
		}
		else{
			actiontxt="null";
		}
		
		
		
	}catch (Exception e) {
        System.out.println("写actions文件内容出错");

        e.printStackTrace();
    }
	
	return actiontxt;
	
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

@ResponseBody
@RequestMapping(value = "/deleteCaseByName", method = RequestMethod.POST)
public String deleteCaseByName(Model mode, HttpServletRequest request, HttpServletResponse response){
	UserContext ctx = UserContextHolder.getUserContext();
	String userid = ctx.getUserId().toString();
	String case_name = request.getParameter("casename");
	String path = request.getSession().getServletContext().getRealPath("/") + "testcase/" + userid;
	File file = new File(path);
	if (case_name!=null&&file.exists()) {
		for (File sonFile : file.listFiles()) {
			if (sonFile != null&&sonFile.getName() != null) {
				if (sonFile.getName().equals(case_name)) {
					GetFileName.deleteDir(sonFile);
					return "success";
				}
			}
		}
	}
	return "fail";
}
}