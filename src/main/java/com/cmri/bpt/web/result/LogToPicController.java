package com.cmri.bpt.web.result;
import java.io.ByteArrayOutputStream;
import java.io.PrintStream;
import java.sql.Date;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.cmri.bpt.common.csv.CSVReadToPic;
import com.cmri.bpt.common.entity.CallLogPO;
import com.cmri.bpt.common.entity.CallOnlineNumPO;
import com.cmri.bpt.common.entity.CallSuccessRatePO;
import com.cmri.bpt.common.entity.CallUserNumberPO;
import com.cmri.bpt.common.entity.CellChangePicturePO;
import com.cmri.bpt.common.entity.FtpFailPicturePO;
import com.cmri.bpt.common.entity.FtpPicturePO;
import com.cmri.bpt.common.entity.LogSequenceVO;
import com.cmri.bpt.common.entity.NetWorKDoCellIDPO;
import com.cmri.bpt.common.entity.NetWorkFlowPicturePO;
import com.cmri.bpt.common.entity.NetWorkPicturePO;
import com.cmri.bpt.common.entity.PicUESmsPO;
import com.cmri.bpt.common.entity.PingPicturePO;
import com.cmri.bpt.common.entity.WebPicturePO;
import com.cmri.bpt.common.entity.WeiXinPicturePO;
import com.cmri.bpt.common.entity.WeiXinTypePO;
import com.cmri.bpt.common.user.UserContext;
import com.cmri.bpt.common.user.UserContextHolder;
import com.cmri.bpt.common.util.CSVUtils;
import com.cmri.bpt.common.util.GetFileName;
import com.cmri.bpt.common.util.JsonUtil;
import com.cmri.bpt.common.util.MapKeyComparator;
import com.cmri.bpt.service.result.logsequence.ILogSequenceService;
import com.cmri.bpt.service.result.pic_call.ICallSuccessRateService;
import com.cmri.bpt.service.result.pic_call.ICallUserNumberService;
import com.cmri.bpt.service.result.pic_cellchange.ICellChangePictureService;
import com.cmri.bpt.service.result.pic_ftp.IFtpPictureService;
import com.cmri.bpt.service.result.pic_network.INetWorkPictureService;
import com.cmri.bpt.service.result.pic_ping.IPingPictureService;
import com.cmri.bpt.service.result.pic_sms.IPicUESmsService;
import com.cmri.bpt.service.result.pic_web.IWebPictureService;
import com.cmri.bpt.service.result.pic_weixin.IWeiXinPictureService;
import com.cmri.bpt.common.util.StaticVariable;




@Controller
@RequestMapping(value = "/logtopic")
public class LogToPicController extends AbstractController{
	
	
	static Logger logger = Logger.getLogger(LogToPicController.class);
	
	@Autowired
	private ICallSuccessRateService callsuccessrateservice;
	@Autowired
	private ICallUserNumberService callusernumberservice;
	@Autowired
	private IPingPictureService pingpictureservice;
	@Autowired
	private INetWorkPictureService networkpictureservice;
	@Autowired
	private IFtpPictureService ftppictureservice;
	@Autowired
	private IPicUESmsService picUESmsService;
	@Autowired
	private IWebPictureService webpictureservice;
	@Autowired
	private IWeiXinPictureService weixinpictureservice;
	@Autowired
	private ICellChangePictureService cellchangepictureservice;
	@Autowired
	private ILogSequenceService logSequenceService;
/**
 * @author 范晓文
 * 根据前端传过来的case_name处理语音通话成功率的图所需的数据（）
 * @param mode
 * @param request
 * @param response
 * @return
 */
	

@ResponseBody
@RequestMapping(value="/getcallsuccessrate",method=RequestMethod.POST)
public String getcallsuccessrate(Model mode, 
	HttpServletRequest request, HttpServletResponse response) {
	List<CallSuccessRatePO> listcallsuccessrate=new ArrayList<CallSuccessRatePO>();
	String retString=null;
    String case_name = request.getParameter("case_name");
	try {
		//listcallsuccessrate=callsuccessrateservice.getCallsuccessRate(case_name);//如果之前处理过该case则直接从数据库中取得数据，否则处理相应的LOG，分析并存入数据库后再取得所需数据
		//if(listcallsuccessrate==null || listcallsuccessrate.size()==0){ 
		    GetFileName.maps=this.getnewpath(case_name);
		  //String userid="user1";
			UserContext ctx = UserContextHolder.getUserContext();
			String userid=ctx.getUserId().toString();
			String path=request.getSession().getServletContext().getRealPath("/") + "testcase/"+userid+"//"+case_name;
			listcallsuccessrate=this.insertcallsuccessratedata(path,case_name);
		//}
		if(listcallsuccessrate==null || listcallsuccessrate.size()==0){
			retString="null";
		}
		else{
		    retString=JsonUtil.Object2Json(listcallsuccessrate);
		}
	} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	
	return retString;

}
/**
 * @author 范晓文
 * 根据前端传过来的case_name处理语音通话用户输统计的图所需的数据（）
 * @param mode
 * @param request
 * @param response
 * @return
 */


@ResponseBody
@RequestMapping(value="/getcallusernumber",method=RequestMethod.POST)
public String getcallusernumber(Model mode, 
	HttpServletRequest request, HttpServletResponse response) {
	List<CallOnlineNumPO> listcallusernumber=new ArrayList<CallOnlineNumPO>();
	CallUserNumberPO callUserNumberPO=new CallUserNumberPO();
	List<CallUserNumberPO> listcallusernumber1=new ArrayList<CallUserNumberPO>();
	String retString=null;
    String case_name = request.getParameter("case_name");
    int time=0;
	
	try {
//		/listcallusernumber=callusernumberservice.getCallUserNumber(case_name);//如果之前处理过该case则直接从数据库中取得数据，否则处理相应的LOG，分析并存入数据库后再取得所需数据
		//if(listcallusernumber==null || listcallusernumber.size()==0){
		 GetFileName.maps=this.getnewpath(case_name);
		//String userid="user1";
			UserContext ctx = UserContextHolder.getUserContext();
			String userid=ctx.getUserId().toString();
			String path=request.getSession().getServletContext().getRealPath("/") + "testcase/"+userid+"//"+case_name;
			listcallusernumber=this.insertcallusernumberdata(path,case_name);
			
			/*for ( int i = 0; i < listcallusernumber.size(); i++) {
				while (time < listcallusernumber.get(i).getX_data()) {
					callUserNumberPO.setX_data(time);
					callUserNumberPO.setY_data(0);
					listcallusernumber1.add(callUserNumberPO);
					time++;
				}
				callUserNumberPO.setX_data(listcallusernumber.get(i).getX_data());
				callUserNumberPO.setY_data(listcallusernumber.get(i).getY_data());
				listcallusernumber1.add(callUserNumberPO);
				
				//title7 = callusernumber[i].start_time;
				time++;
			}*/
		//}
		if(listcallusernumber==null||listcallusernumber.size()==0){
			retString="null";
		}
		else{
			retString=JsonUtil.Object2Json(listcallusernumber);
		}
		
	} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	
	return retString;

}
/**
 * 
 * @功能 获取pinglog的数据
 * @日期 2015年11月2日
 * @返回值类型 String
 * @author 范晓文
 * @package名 com.reserch.controller
 * @文件名 LogToPicController.java
 */
@ResponseBody
@RequestMapping(value="/getpinglog",method=RequestMethod.POST)
public String getpinglog(Model mode, 
	HttpServletRequest request, HttpServletResponse response) throws SQLException {
	List<PingPicturePO> listpingdata=new ArrayList<PingPicturePO>();
	String retString=null;
    String case_name = request.getParameter("case_name");
	try {
		//listpingdata=pingpictureservice.selectPingPicture(case_name);//如果之前处理过该case则直接从数据库中取得数据，否则处理相应的LOG，分析并存入数据库后再取得所需数据
		//if(listpingdata==null || listpingdata.size()==0){
		GetFileName.maps=this.getnewpath(case_name);
		//String userid="user1";
				UserContext ctx = UserContextHolder.getUserContext();
				String userid=ctx.getUserId().toString();
			String path=request.getSession().getServletContext().getRealPath("/") + "testcase/"+userid+"/"+case_name;
			listpingdata=pingpictureservice.insertpingpicturedata(path, case_name);
	//	}
		retString=JsonUtil.Object2Json(listpingdata);
	} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	
	return retString;

}

/**
 * 
 * @功能 获取weblog的内容
 * @日期 2015年11月23日
 * @返回值类型 String
 * @author 范晓文
 * @package名 com.reserch.controller
 * @文件名 LogToPicController.java
 */

@ResponseBody
@RequestMapping(value="/getweblog",method=RequestMethod.POST)
public String getweblog(Model mode, 
	HttpServletRequest request, HttpServletResponse response) throws SQLException {
	List<WebPicturePO> listwebdata=new ArrayList<WebPicturePO>();
	String retString=null;
    String case_name = request.getParameter("case_name");
	try {
		//listwebdata=webpictureservice.selectWebPicture(case_name);//如果之前处理过该case则直接从数据库中取得数据，否则处理相应的LOG，分析并存入数据库后再取得所需数据
		//if(listwebdata==null || listwebdata.size()==0){  
		 GetFileName.maps=this.getnewpath(case_name);
		//String userid="user1";
			UserContext ctx = UserContextHolder.getUserContext();
			String userid=ctx.getUserId().toString();
			String path=request.getSession().getServletContext().getRealPath("/") + "testcase/"+userid+"//"+case_name;
			listwebdata=webpictureservice.insertwebpicturedata(path, case_name);
		//}
		retString=JsonUtil.Object2Json(listwebdata);
	} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	
	return retString;

}
/**
 * 
 * @功能 获取微信LOG的内容
 * @日期 2015年11月30日
 * @返回值类型 String
 * @author 范晓文
 * @package名 com.reserch.controller
 * @文件名 LogToPicController.java
 */

@ResponseBody
@RequestMapping(value="/getweixinlog",method=RequestMethod.POST)
public String getweixinlog(Model mode, 
	HttpServletRequest request, HttpServletResponse response) throws SQLException {
	List<WeiXinPicturePO> listweixindata=new ArrayList<WeiXinPicturePO>();
	String retString=null;
	WeiXinTypePO weixinpo=new WeiXinTypePO();
    String case_name = request.getParameter("case_name");
    String type = request.getParameter("type");
    weixinpo.setCase_name(case_name);
    weixinpo.setType(type);
	try {
		//listweixindata=weixinpictureservice.selectWeiXinPicture(weixinpo);//如果之前处理过该case则直接从数据库中取得数据，否则处理相应的LOG，分析并存入数据库后再取得所需数据
		//if(listweixindata==null || listweixindata.size()==0){  
		 GetFileName.maps=this.getnewpath(case_name);
		//String userid="user1";
			UserContext ctx = UserContextHolder.getUserContext();
			String userid=ctx.getUserId().toString();
			String path=request.getSession().getServletContext().getRealPath("/") + "testcase/"+userid+"//"+case_name;
			listweixindata=weixinpictureservice.insertweixinpicturedata(path, case_name,type);
		//}
		retString=JsonUtil.Object2Json(listweixindata);
	} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	
	return retString;

}

/**
 * 
 * @功能 获取小区切换LOG的内容
 * @日期 2015年11月30日
 * @返回值类型 String
 * @author 范晓文
 * @package名 com.reserch.controller
 * @文件名 LogToPicController.java
 */
@ResponseBody
@RequestMapping(value="/getcellchangelog",method=RequestMethod.POST)
public String getcellchangelog(Model mode, 
	HttpServletRequest request, HttpServletResponse response) throws SQLException {
	List<CellChangePicturePO> listcellchagedata=new ArrayList<CellChangePicturePO>();
	String retString=null;
    String case_name = request.getParameter("case_name");
	try {
		//listcellchagedata=cellchangepictureservice.selectCellChangePicture(case_name);//如果之前处理过该case则直接从数据库中取得数据，否则处理相应的LOG，分析并存入数据库后再取得所需数据
		//if(listcellchagedata==null || listcellchagedata.size()==0){  
		 GetFileName.maps=this.getnewpath(case_name);
		//String userid="user1";
			UserContext ctx = UserContextHolder.getUserContext();
			String userid=ctx.getUserId().toString();
			String path=request.getSession().getServletContext().getRealPath("/") + "testcase/"+userid+"//"+case_name;
			listcellchagedata=cellchangepictureservice.insertcellchangepicturedata(path, case_name);
		//}
		if(listcellchagedata==null){
			retString="null";
		}
		else{
		retString=JsonUtil.Object2Json(listcellchagedata);
		}
	} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	
	return retString;

}
/**
 * 
 * @功能 获取ftplog的数据
 * @日期 2015年11月2日
 * @返回值类型 String
 * @author 范晓文
 * @package名 com.reserch.controller
 * @文件名 LogToPicController.java
 */
@ResponseBody
@RequestMapping(value="/getftplog",method=RequestMethod.POST)
public String getftplog(Model mode, 
	HttpServletRequest request, HttpServletResponse response) throws SQLException {
	List<FtpPicturePO> listftpdata=new ArrayList<FtpPicturePO>();
	List<FtpPicturePO> listdowndata=new ArrayList<FtpPicturePO>();
	List<FtpPicturePO> listupdata=new ArrayList<FtpPicturePO>();
	Map<Integer,Integer> downfail=new HashMap<Integer, Integer>();
	Map<Integer,Integer> upfail=new HashMap<Integer, Integer>();
	Map<Integer,Integer> fail=new TreeMap<Integer, Integer>();
	List<FtpFailPicturePO> listfaildata=new ArrayList<FtpFailPicturePO>();
	int max_x=0;
	int downnum=0;
	int upnum=0;
	String retString="null";
	String data1="null";
	String data2="null";
    String case_name = request.getParameter("case_name");
    logger.debug("测试用例名称----"+case_name);
	try {
		//listftpdata=ftppictureservice.selectFtpPicture(case_name);//如果之前处理过该case则直接从数据库中取得数据，否则处理相应的LOG，分析并存入数据库后再取得所需数据
		//if(listftpdata==null || listftpdata.size()==0){  
		    GetFileName.maps=this.getnewpath(case_name);
		  //String userid="user1";
			UserContext ctx = UserContextHolder.getUserContext();
			String userid=ctx.getUserId().toString();
			String path=request.getSession().getServletContext().getRealPath("/") + "testcase/"+userid+"//"+case_name;
			logger.debug("测试用例路径----"+path);
			listftpdata=ftppictureservice.insertftppicturedata(path, case_name);
		//}
			if(listftpdata!=null&&listftpdata.size()>0){
				for(int i=0;i<listftpdata.size();i++){
					if(listftpdata.get(i).getFtp_type().equals("FTPDownLog.csv")){
						listdowndata.add(listftpdata.get(i));
						if(max_x<listftpdata.get(i).getX_data()){
							max_x=listftpdata.get(i).getX_data();
						}
						if(listftpdata.get(i).getX_data()<downnum){
							
								downfail.put(downnum, downfail.get(downnum)+listftpdata.get(i).getFail_num());
							
						}
						else{
							while(listftpdata.get(i).getX_data()>=downnum)
							{
								downnum+=5;
								downfail.put(downnum, 0);
							}
							downfail.put(downnum, listftpdata.get(i).getFail_num());
						}
					}
					else if(listftpdata.get(i).getFtp_type().equals("FTPUpLog.csv")){
						listupdata.add(listftpdata.get(i));
						if(max_x<listftpdata.get(i).getX_data()){
							max_x=listftpdata.get(i).getX_data();
						}
						if(listftpdata.get(i).getX_data()<upnum){
							
							upfail.put(upnum, upfail.get(upnum)+listftpdata.get(i).getFail_num());
						
					}
					else{
						while(listftpdata.get(i).getX_data()>=upnum)
						{
							upnum+=5;
							upfail.put(upnum, 0);
						}
						upfail.put(upnum, listftpdata.get(i).getFail_num());
					}
					}
					
				}
			    for(Map.Entry<Integer, Integer> entry:downfail.entrySet()){
			    	if(upfail.containsKey(entry.getKey())){
			    		fail.put(entry.getKey(), entry.getValue()+upfail.get(entry.getKey()));
			    		upfail.remove(entry.getKey());
			    	}
			    	else{
			    		fail.put(entry.getKey(), entry.getValue());
			    	}
			    	
			    }
		          fail.putAll(upfail);
		          fail=sortMapByKey1(fail);
		          for(Map.Entry<Integer, Integer> entry:fail.entrySet()){
		        	  FtpFailPicturePO failpo=new FtpFailPicturePO();
		        	  failpo.setX_data(entry.getKey());
		        	  failpo.setY_data(entry.getValue());
		        	  listfaildata.add(failpo);
		          }
			    if(listdowndata!=null&&listdowndata.size()>10){
			    	data1=JsonUtil.Object2Json(listdowndata);
			    }
			    if(listupdata!=null&&listupdata.size()>10){
			    	data2=JsonUtil.Object2Json(listupdata);
			    }
			    if(!data1.equals("null")||!data2.equals("null"))
			    {
				retString=data1+"$$"+data2+"$$"+max_x+"$$"+JsonUtil.Object2Json(listfaildata);
			    }
			}
		
	} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
		ByteArrayOutputStream baos = new ByteArrayOutputStream();  
		e.printStackTrace(new PrintStream(baos));  
		String exception = baos.toString();  
		logger.debug(exception);
	}
	
	return retString;

}

/**
 * 
 * @功能 获取networklog的内容
 * @日期 2015年11月2日
 * @返回值类型 String
 * @author 范晓文
 * @package名 com.reserch.controller
 * @文件名 LogToPicController.java
 */

@ResponseBody
@RequestMapping(value="/getnetworklog",method=RequestMethod.POST)
public String getnetworklog(Model mode, 
	HttpServletRequest request, HttpServletResponse response) throws SQLException {
	List<NetWorkPicturePO> listnetworkdata=new ArrayList<NetWorkPicturePO>();
	String retString=null;
	Map<String,List<NetWorkPicturePO>> retmap=new HashMap<String, List<NetWorkPicturePO>>();
    String case_name = request.getParameter("case_name");
    Map<String,String> cellmap=new HashMap<String,String>();
    List<NetWorKDoCellIDPO> docell=new ArrayList<NetWorKDoCellIDPO>();
    int num=1;
	try {
		//listnetworkdata=networkpictureservice.selectNetWorkPicture(case_name);//如果之前处理过该case则直接从数据库中取得数据，否则处理相应的LOG，分析并存入数据库后再取得所需数据
		//if(listnetworkdata==null || listnetworkdata.size()==0){  
		 GetFileName.maps=this.getnewpath(case_name);
		//String userid="user1";
			UserContext ctx = UserContextHolder.getUserContext();
			String userid=ctx.getUserId().toString();
			String path=request.getSession().getServletContext().getRealPath("/") + "testcase/"+userid+"//"+case_name;
			listnetworkdata=networkpictureservice.insertnetworkpicturedata(path, case_name);
		
		//}
		for(int i=0;i<listnetworkdata.size();i++){
			if(retmap!=null && retmap.containsKey(cellmap.get(listnetworkdata.get(i).getCell_type()))){
				retmap.get(cellmap.get(listnetworkdata.get(i).getCell_type())).add(listnetworkdata.get(i));
			}
			else{
				List<NetWorkPicturePO> list_temp=new ArrayList<NetWorkPicturePO>();
				list_temp.add(listnetworkdata.get(i));
				cellmap.put( listnetworkdata.get(i).getCell_type(),"CELL"+num);
				retmap.put("CELL"+num, list_temp);
				NetWorKDoCellIDPO cellidpo=new NetWorKDoCellIDPO();
				cellidpo.setCellid("CELL"+num);
				cellidpo.setCellname(listnetworkdata.get(i).getCell_type());
				docell.add(cellidpo);
				num++;
			}
			
		}
		if(docell.size()==0){		
			retString="null";
		}
		else{
		retString=JsonUtil.Object2Json(docell);		
		retString=retString+"$$"+(num-1)+"$$"+JsonUtil.Object2Json(retmap);
		}
	} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	
	return retString;

}
@ResponseBody
@RequestMapping(value="/getnetworkflowlog",method=RequestMethod.POST)
public String getnetworkflowlog(Model mode, 
		HttpServletRequest request, HttpServletResponse response) throws SQLException {
	List<NetWorkFlowPicturePO> listnetworkflowdata=new ArrayList<NetWorkFlowPicturePO>();
	String retString=null;
	Map<String,List<NetWorkFlowPicturePO>> retmap=new HashMap<String, List<NetWorkFlowPicturePO>>();
	String case_name = request.getParameter("case_name");
	String name = request.getParameter("name");
	Map<String,String> cellmap=new HashMap<String,String>();
	List<NetWorKDoCellIDPO> docell=new ArrayList<NetWorKDoCellIDPO>();
	try {
		GetFileName.maps=this.getnewpath(case_name);
		UserContext ctx = UserContextHolder.getUserContext();
		String userid=ctx.getUserId().toString();
		String path=request.getSession().getServletContext().getRealPath("/") + "testcase/"+userid+"//"+case_name;
		listnetworkflowdata=networkpictureservice.insertNetworkFlowdata(path, case_name,name);
		
		if(listnetworkflowdata.size()>0){		
			retString=JsonUtil.Object2Json(listnetworkflowdata);		
		}
	} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	
	return retString;
	
}
/**
 * @author 范晓文
 * 从log中提取所需数据存入数据库并将分析后的数据返回
 * @param path
 * @param case_name
 * @return
 */
private List<CallSuccessRatePO> insertcallsuccessratedata(String path,String case_name)
{
	Long min=0L;
	Map<Integer,CallLogPO> retlistrate=new TreeMap<Integer, CallLogPO>() ;	
	List<CallLogPO> listcalllog=new ArrayList<CallLogPO>();
	List<CallSuccessRatePO> listallcalllog=new ArrayList<CallSuccessRatePO>();
	

	try{
		//主叫log sendcalllog.csv的最小时间戳
		min=CSVReadToPic.Getmintimefromlog(path,"sendCallLog.csv");
		//读取对应文件夹下的所有sendcalllog.csv
		listcalllog=CSVReadToPic.ReadAllCallLog(path,min);
		/*Long min_calllog=CSVReadToPic.Getmintimefromlog(path,"callLog.csv");
		if(min_calllog<min){
			min=min_calllog;
		}*/
		SimpleDateFormat sdf = new SimpleDateFormat("HH:mm:ss");
		String start_time = sdf.format(new Date(min));
	
		/**
		 * 新增统计接通成功率的业务逻辑代码
		 */
		int timeActive=0;
		int timeIdel=0;
		int successNumber=0;
		int failNumber = 0;
		int length = listcalllog.size();
		int maxtime=0;
		if(listcalllog!=null){
		/**
		 *List排序方法 
		 *int compare(Student o1, Student o2) 返回一个基本类型的整型，  
         * 返回负数表示：o1 小于o2，  
         * 返回0 表示：o1和o2相等，  
         * 返回正数表示：o1大于o2。  
		 */		
		/*Collections.sort(listcalllog, new Comparator<CallLogPO>(){  			             
	        public int compare(CallLogPO o1, CallLogPO o2) {                
                //按照Active的时间戳进行升序排列  
                if(o1.getTime1() > o2.getTime1()){  
                    return 1;  
                }  
                if(o1.getTime1() == o2.getTime1()){  
                    return 0;  
                }  
                return -1;  
	            }  
	        });*/
			//System.out.println("排序后："+listcalllog);
			maxtime=listcalllog.get(length-1).getTime();
			//开始判断坐标时间是否在通话每一个通话区间中. 
			for(int m=0;m<maxtime;m+=StaticVariable.call_ConnectRate_StepSize){			
				CallSuccessRatePO callSuccessRatePO = new CallSuccessRatePO();
				for(int i=0;i<listcalllog.size();i++){								
					    timeActive = listcalllog.get(i).getTime1();
					    timeIdel = listcalllog.get(i).getTime();
					    if(m>=timeActive&&m<=timeIdel){
					    	successNumber = successNumber+listcalllog.get(i).getSuccess_num();
					    	failNumber = failNumber+listcalllog.get(i).getFail_num();					    	
					    }				 
				}
				if(successNumber==0&&failNumber==0){
					callSuccessRatePO.setCase_name(case_name);
					callSuccessRatePO.setStart_time(start_time);
					callSuccessRatePO.setX_time(m);
					callSuccessRatePO.setY_rate(0);
					callSuccessRatePO.setSuccessnumber(0);
					callSuccessRatePO.setFailenumber(0);
					listallcalllog.add(callSuccessRatePO);
					timeActive=0;
					timeIdel=0;
					successNumber=0;
					failNumber = 0;
				}else{					
					callSuccessRatePO.setCase_name(case_name);
					callSuccessRatePO.setStart_time(start_time);									
					callSuccessRatePO.setX_time(m);					
					callSuccessRatePO.setSuccessnumber(successNumber+StaticVariable.sendcallLog_SuccessNum);
					callSuccessRatePO.setFailenumber(failNumber);
					float rate=(float)(successNumber+StaticVariable.sendcallLog_SuccessNum)/(successNumber+failNumber+StaticVariable.sendcallLog_SuccessNum);
					DecimalFormat df=new DecimalFormat("0.00");					
					callSuccessRatePO.setY_rate(Float.parseFloat(df.format(rate*100)));
					listallcalllog.add(callSuccessRatePO);
					timeActive=0;
					timeIdel=0;
					successNumber=0;
					failNumber = 0;
				}				
			}
		} 
		StaticVariable.sendcallLog_SuccessNum=0;
		//CSVReadToPic.callLogSuccessNum=0;
	}catch (Exception e) {
		
		e.printStackTrace();
	}
	
	return listallcalllog;

	}



/**
 * @author 范晓文
 * 将map按照key值从小到大排序
 * @param map
 * @return
 */
public static Map<Integer,CallLogPO> sortMapByKey(Map<Integer,CallLogPO> map) {
    if (map == null || map.isEmpty()) {
        return null;
    }

    Map<Integer,CallLogPO> sortMap = new TreeMap<Integer,CallLogPO>(
           new MapKeyComparator());

    sortMap.putAll(map);

    return sortMap;
}

public static Map<Integer,WebPicturePO> sortWebMapByKey(Map<Integer,WebPicturePO> map) {
    if (map == null || map.isEmpty()) {
        return null;
    }

    Map<Integer,WebPicturePO> sortMap = new TreeMap<Integer,WebPicturePO>(
           new MapKeyComparator());

    sortMap.putAll(map);

    return sortMap;
}

public static Map<Integer,WeiXinPicturePO> sortWeiXinMapByKey(Map<Integer,WeiXinPicturePO> map) {
    if (map == null || map.isEmpty()) {
        return null;
    }

    Map<Integer,WeiXinPicturePO> sortMap = new TreeMap<Integer,WeiXinPicturePO>(
           new MapKeyComparator());

    sortMap.putAll(map);

    return sortMap;
}



public static Map<Integer,CellChangePicturePO> sortCellChangeMapByKey(Map<Integer,CellChangePicturePO> map) {
    if (map == null || map.isEmpty()) {
        return null;
    }

    Map<Integer,CellChangePicturePO> sortMap = new TreeMap<Integer,CellChangePicturePO>(
           new MapKeyComparator());

    sortMap.putAll(map);

    return sortMap;
}
public static Map<Integer,Integer> sortMapByKey1(Map<Integer,Integer> map) {
    if (map == null || map.isEmpty()) {
        return null;
    }

    Map<Integer,Integer> sortMap = new TreeMap<Integer,Integer>(
           new MapKeyComparator());

    sortMap.putAll(map);


    return sortMap;
}


/**
 *  @author 范晓文
 * 从log中提取所需数据存入数据库并将分析后的数据返回
 * @param path
 * @param case_name
 * @return List<CallUserNumberPO> 该case_name在各个时间点的通话用户数目
 */
private List<CallOnlineNumPO> insertcallusernumberdata(String path,String case_name)
{
	Long min=(long) 0;	
	List<CallUserNumberPO> listcalllog=new ArrayList<CallUserNumberPO>();
	Map<Integer,Integer> retlist=new TreeMap<Integer, Integer>() ;
	List<CallOnlineNumPO> listallcalllog=new ArrayList<CallOnlineNumPO>();
	try{
		
		min=CSVReadToPic.Getmintimefromlog(path,"sendCallLog.csv");
		/*Long min_calllog=CSVReadToPic.Getmintimefromlog(path,"callLog.csv");
		if(min_calllog<min){
			min=min_calllog;
		}*/
		listcalllog=CSVReadToPic.ReadAllCallLog1(path,min);
		
		SimpleDateFormat sdf = new SimpleDateFormat("HH:mm:ss");
		String start_time = sdf.format(new Date(min));	
		int length=listcalllog.size();
		int timeActive=0;
		int timeIdel=0;
		int onlineNum=0;
		if(listcalllog!=null){
			
			int maxtime=listcalllog.get(length-1).getX_data1();//最大时间
			for(int m=0;m<maxtime;m+=StaticVariable.call_UserNumber_StepSize){			
				CallOnlineNumPO callOnlineNumPO = new CallOnlineNumPO();
				for(int i=0;i<listcalllog.size();i++){								
					    timeActive = listcalllog.get(i).getX_data();
					    timeIdel = listcalllog.get(i).getX_data1();
					    if(m>=timeActive&&m<=timeIdel){
					    	onlineNum = onlineNum+listcalllog.get(i).getY_data();						    	
					    }	
					    			   				    	
					    }

				if(onlineNum==0){
					callOnlineNumPO.setCase_name(case_name);
					callOnlineNumPO.setStart_time(start_time);
					callOnlineNumPO.setX_data(m);
					callOnlineNumPO.setY_data(StaticVariable.callLog_SuccessNum);					
					listallcalllog.add(callOnlineNumPO);
					timeActive=0;
					timeIdel=0;
					onlineNum=0;
				}else{				
						callOnlineNumPO.setCase_name(case_name);
						callOnlineNumPO.setStart_time(start_time);
						callOnlineNumPO.setX_data(m);
						callOnlineNumPO.setY_data(onlineNum+StaticVariable.callLog_SuccessNum);					
						listallcalllog.add(callOnlineNumPO);
						timeActive=0;
						timeIdel=0;
						onlineNum=0;															
				}				
			}
		}
		
		StaticVariable.callLog_SuccessNum=0;
	
		 
	}catch (Exception e) {
		
		e.printStackTrace();
	}
	return listallcalllog;

	}

	/**
	 * @author zzk 根据前端传过来的case_name处理手机短信统计的图所需的数据（）
	 * @param mode
	 * @param request
	 * @param response
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/getPicUESmsData", method = RequestMethod.POST)
	public String getPicUESmsData(Model mode, HttpServletRequest request,
			HttpServletResponse response) {
		List<PicUESmsPO> picUESmsPOs = new ArrayList<PicUESmsPO>();
		String retString = null;
		String case_name = request.getParameter("case_name");
		try {
			LogSequenceVO logSequenceVO = new LogSequenceVO();
			logSequenceVO.setCase_file_name(case_name);
			List<LogSequenceVO> logSequenceVOs = this.logSequenceService
					.selectLogSequenceByCaseFileName(logSequenceVO);
			//String userid="user1";
			UserContext ctx = UserContextHolder.getUserContext();
			String userid=ctx.getUserId().toString();
				String path=request.getSession().getServletContext().getRealPath("/") + "testcase/"+userid+"//"+case_name;
			picUESmsPOs = this.picUESmsService.createPicUESmsData(path,
					case_name, logSequenceVOs);
			if (picUESmsPOs == null || picUESmsPOs.size() == 0) {
				retString = "null";
			} else {
				retString = JsonUtil.Object2Json(picUESmsPOs);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}

		return retString;

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
	@Override
	protected ModelAndView handleRequestInternal(HttpServletRequest arg0,
			HttpServletResponse arg1) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}
}