package com.cmri.bpt.web.util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

/**
 * 
 * @author k
 *
 */
public final class   DateUtils {
	public static String DATE_STYLE_yyyy_MM_dd_HH_mm_ss = "yyyy-MM-dd HH:mm:ss";
	public static String DATE_STYLE_yyyy_MM_dd = "yyyy-MM-dd";
	public static String DATE_FILE_STYLE_yyyy_MM_dd = "yyyy_MM_dd";
	public static String DATE_STYLE_yyyy_MM = "yyyy-MM";
	public static String DATE_STYLE_yyyyyearMMmonday = "yyyy年MM月dd日";
	public static SimpleDateFormat sdf_yyyy_MM = new SimpleDateFormat("yyyy-MM");
	public static SimpleDateFormat sdf_yyyy_MM_dd = new SimpleDateFormat("yyyy-MM-dd");
//	public static String DATE_STYLE_yyyyyearmmmonday = "yyyy年mm月dd日";
	public static String DATE_STYLE_yyyy = "yyyy";
	public static SimpleDateFormat sdf_yyyy = new SimpleDateFormat("yyyy");
	public static SimpleDateFormat sdf_yyyy_MM_dd_hh_mm_ss = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	public static SimpleDateFormat sdf_yyyy_MM_dd_hh_mm = new SimpleDateFormat("yyyy-MM-dd HH:mm");
	

	
	
	/**
	 *  返回形式 例如"yyyy-MM-dd"、"yyyy-MM-dd HH:mm:ss"、"yyyy-MM-dd hh:mm:ss"
	 * @param style
	 * @return
	 */
	  public static String getCurrentDateString(String style) {
	    return new java.text.SimpleDateFormat(style).format(new java.util.Date());
	  }
	  public static String getCurrentDateString(String style,java.util.Date d) {
		  return new java.text.SimpleDateFormat(style).format(d);
	  }
	  /**
	   * 返回默认格式yyyy-MM-dd HH:mm:ss 字符串
	   * @return
	   */
	  public static String getCurrentDateTimeString() {
		    return new java.text.SimpleDateFormat(DateUtils.DATE_STYLE_yyyy_MM_dd_HH_mm_ss).format(new java.util.Date());
	  }
	  /**
	   * 
	   * @return "yyyy年MM月dd日"
	   */
	  public static String getCurrentDayTimeString() {
		    return new java.text.SimpleDateFormat(DateUtils.DATE_STYLE_yyyyyearMMmonday).format(new java.util.Date());
	  }
	  /**
	   * 
	   * @return "yyyy年MM月dd日"
	   */
	  public static String getCurrentDayTimeString(java.util.Date d) {
		  return new java.text.SimpleDateFormat(DateUtils.DATE_STYLE_yyyyyearMMmonday).format(d);
	  }
	
	  /**yyyy-MM-dd 
	   * 
	   * @return
	   */
	  public static String getCurrentDayString() {
		    return new java.text.SimpleDateFormat(DateUtils.DATE_STYLE_yyyy_MM_dd).format(new java.util.Date());
	  }
	  /**yyyy-MM
	   * 
	   * @return
	   */
	  public static String getCurrentMonthString() {
		    return new java.text.SimpleDateFormat(DateUtils.DATE_STYLE_yyyy_MM).format(new java.util.Date());
	  }
	  /**
	   *  把一定格式的日期转化为YYYY年mm月DD日
	   * @param String DATE_STYLE_yyyy_MM_dd_HH_mm_ss
	   * @return
	   */
	  public static String changeDate2YMD(String DATE_STYLE_yyyy_MM_dd_HH_mm_ss ){
		  try {
			  java.util.Date d=	new java.text.SimpleDateFormat(DateUtils.DATE_STYLE_yyyy_MM_dd_HH_mm_ss).parse(DATE_STYLE_yyyy_MM_dd_HH_mm_ss);
			  String str=	getCurrentDateString(DateUtils.DATE_STYLE_yyyyyearMMmonday,d);
			  return str;
		  } catch (ParseException e) {
			e.printStackTrace();
			 return "";
		}
	  }
	
	  public static String changeDate2upper(java.util.Date d ){
			  String temp=getCurrentDateString(DateUtils.DATE_STYLE_yyyy_MM,d); //2011-01-01 临时状态方便找出年月日
			  String  year=temp.split("-")[0];
			  String  month=temp.split("-")[1];
			  String  day=temp.split("-")[2];
			  year=num2bignum(year);
			  month=handMonthAndDay(month);
			  day=handMonthAndDay(day);			
			  return year+"年"+month+"月"+day+"日";
	  }
	  private static String handMonthAndDay(String month){
		  int monthlength=month.length();
		  if(monthlength==2){
			  char a=month.charAt(0);
			  if(a=='0'){//第一位是零
				  month=String.valueOf(month.charAt(1));
				  month=num2bignum(month);
			  }else{ //第一位不是零  
				  char last=month.charAt(1);
				  //第一位是一
				  if(a!='1'){
					  month=num2bignum(String.valueOf(month.charAt(0)))+"十";
				  }else{
					  month="十"; 
				  }
				  if(last!='0'){
					  month+=  num2bignum(String.valueOf(last)); 
				  }
			  }
		  }else{
			  throw new IllegalArgumentException("参数错误!");
		  }
		  return month;
	  }
	  
	  /**
	   * 将数字的0123456789转化为大写
	   * @param str
	   * @return
	   */
	  public static String num2bignum(String str){
		 return str.replaceAll("0","〇").replaceAll("1","一").replaceAll("2", "二")
	  		.replaceAll("3","三").replaceAll("4","四").replaceAll("5", "五")
	  		.replaceAll("6","六").replaceAll("7","七").replaceAll("8", "八")
	  		.replaceAll("9","九");
	  }
	  /**
	   * 将style类型的日期字符串 转换成style2类型的日期字符串
	   * @param date
	   * @param style
	   * @param style2
	   * @return
	   */
	  public static String formatDate(String date,String style,String style2){
		  try {
			java.util.Date d= new java.text.SimpleDateFormat(style).parse(date);
			return new java.text.SimpleDateFormat(style2).format(d);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return null;
	  }
	  public static String formatSqsj(String date){
		  return formatDate(date, DateUtils.DATE_STYLE_yyyy_MM_dd_HH_mm_ss, DateUtils.DATE_STYLE_yyyyyearMMmonday);
	  }
	  public static void main(String[] args) throws Exception {
		//System.out.println(changeDate2upper(new java.util.Date()));
		
		System.out.println(DateUtils.getMonthsAfterDay());
	}
	  /**
	   * 获取本月最后一天的日期string
	   * @return
	 * @throws Exception 
	   */
	  public static String getMonthLastDay() throws Exception{
		    Date date = new Date();
			Calendar calendar = Calendar.getInstance();//日历对象
			calendar.setTime(date);
			calendar.add(Calendar.MONTH, 1);
			long time = sdf_yyyy_MM.parse(sdf_yyyy_MM.format(calendar.getTime())+"-01").getTime()-24*60*60*1000;
			calendar.setTime(new Date(time));
			return sdf_yyyy_MM_dd.format(calendar.getTime());
	  }
	  /**
	   * 获取N月之前(后)的第一天
	   * @param arg
	   * @return
	   * @throws Exception
	   */
	  public static String getMonthsBeforeDay(int arg) throws Exception{
		    Date date = new Date();
			Calendar calendar = Calendar.getInstance();//日历对象
			calendar.setTime(date);
			calendar.add(Calendar.MONTH, arg);
			long time = sdf_yyyy_MM.parse(sdf_yyyy_MM.format(calendar.getTime())+"-01").getTime();
			calendar.setTime(new Date(time));
			return sdf_yyyy_MM_dd.format(calendar.getTime());
	  }
	  /**
	   * 获取N月之前(后)的日期
	   * @param arg
	   * @return
	   * @throws Exception
	   */
	  public static String getMonthsBeforeToday(int arg){
		    Date date = new Date();
			Calendar calendar = Calendar.getInstance();//日历对象
			calendar.setTime(date);
			calendar.add(Calendar.MONTH, arg);
			return sdf_yyyy_MM_dd.format(calendar.getTime());
	  }
	 
	  /**
	   * 获取当前时间到下个月15号的天数
	   * @return
	   * @throws Exception
	   */
	  public static int getMonthsAfterDay() throws Exception{
		    Date getCurrentDate = new Date();
			Calendar calendar = Calendar.getInstance();//日历对象
			calendar.add(Calendar.MONTH, +1);    //得到下一个月
		    calendar.set(Calendar.DATE,  15);    //下个月的15号
		    int day=(int)((calendar.getTime().getTime()-getCurrentDate.getTime())/(1000*60*60*24));
			return day;
	  }
	  /**
	   * 将字符串格式化为yyyy-MM-dd格式
	   * @param value
	   * @return
	   */
	public static Date parseYYYYMMDDDate(String value) {
		if(value!=null){
			try {
				return sdf_yyyy_MM_dd.parse(value);
			} catch (ParseException e) {
				e.printStackTrace();
			}
		}
		return null;
	}
	/**
	   * 将字符串格式化为yyyy-MM格式
	   * @param value
	   * @return
	   */
	public static Date parseYYYYMMDate(String value) {
		if(value!=null){
			try {
				return sdf_yyyy_MM.parse(value);
			} catch (ParseException e) {
				e.printStackTrace();
			}
		}
		return null;
	}
	/**
	 * 获取上个月的日期
	 * @return
	 */
	public static Date getPreMonthYYYYMM(){
		// 新建一个日历对象。注意：类Calendar是抽象的要使用getInstance()实例化，或者实例化其子类
		Calendar calen = Calendar.getInstance();
		// 日历对象默认的日期为当前日期，调用setTime设置该日历对象的日期为程序中指定的日期
		calen.setTime(new Date());
		// 将日历的"天"增加5
		calen.add(Calendar.MONTH, -1);
		// 获取日历对象的时间，并赋给日期对象c
		Date date = calen.getTime();
		return date;
	}
	/**
	 * 获取上个月的日期Str
	 * @return
	 */
	public static String getPreMonthYYYYMMStr(){
		return formatYYYYMMDate(getPreMonthYYYYMM());
	}
	/**
	 * 将Date格式化为yyyy-MM-dd格式
	 * @param date
	 * @return
	 */
	public static String formatYYYYMMDDDate(Date date){
		if(date!=null ){
			return sdf_yyyy_MM_dd.format(date);
		}
		return null;
	}
	/**
	 * 将Date格式化为yyyy-MM格式
	 * @param date
	 * @return
	 */
	public static String formatYYYYMMDate(Date date){
		if(date!=null ){
			return sdf_yyyy_MM.format(date);
		}
		return null;
	}
	
	/**
	 * 获取上5年
	 * @return
	 */
	public static Date getPreYearYYYY(){
		// 新建一个日历对象。注意：类Calendar是抽象的要使用getInstance()实例化，或者实例化其子类
		Calendar calen = Calendar.getInstance();
		// 日历对象默认的日期为当前日期，调用setTime设置该日历对象的日期为程序中指定的日期
		calen.setTime(new Date());
		// 将日历的"天"增加5
		calen.add(Calendar.YEAR, -5);
		// 获取日历对象的时间，并赋给日期对象c
		Date date = calen.getTime();
		return date;
	}
	
	/**
	 * 获取上一年的日期Str
	 * @return
	 */
	public static String getPreYearYYYYStr(){
		return formatYYYYDate(getPreYearYYYY());
	}
	/**
	 * 将Date格式化为yyyy格式
	 * @param date
	 * @return
	 */
	public static String formatYYYYDate(Date date){
		if(date!=null ){
			return sdf_yyyy.format(date);
		}
		return null;
	}
	 /**yyyy
	   * 
	   * @return
	   */
	  public static String getCurrentYearString() {
		    return new java.text.SimpleDateFormat(DateUtils.DATE_STYLE_yyyy).format(new java.util.Date());
	  }
	  /**
		 * 获取上一年的日期Str
		 * @return
		 */
		public static String getPreYearYYYYMMStr(){
			return formatYYYYMMDate(getPreYearYYYY());
		}


		/**
		 * 获取上一年的日期
		 * @return
		 */
		public static Date getPreOneYearMonthYYYYMM(){
			// 新建一个日历对象。注意：类Calendar是抽象的要使用getInstance()实例化，或者实例化其子类
			Calendar calen = Calendar.getInstance();
			// 日历对象默认的日期为当前日期，调用setTime设置该日历对象的日期为程序中指定的日期
			calen.setTime(new Date());
			// 将日历的"天"增加5
			//calen.add(Calendar.MONTH, -1);
			calen.add(Calendar.YEAR, -1);
			// 获取日历对象的时间，并赋给日期对象c
			Date date = calen.getTime();
			return date;
		}
		/**
		 * 获取上一年的日期Str
		 * @return
		 */
		public static String getPreOneYearYYYYStr(){
			return formatYYYYMMDate(getPreOneYearMonthYYYYMM());
		}
		
		/**
		 * 获取这个月的第一天
		 * @return
		 */
		public static String getFirstDayofThisTime(){
			// 新建一个日历对象。注意：类Calendar是抽象的要使用getInstance()实例化，或者实例化其子类
			 Calendar calendar = Calendar.getInstance();     
			    calendar.set(Calendar.DAY_OF_MONTH, calendar     
			            .getActualMinimum(Calendar.DAY_OF_MONTH));   
			return sdf_yyyy_MM_dd.format(calendar.getTime());
		}
		
		public static String formatYYYYMMDDDHHMMSSDate(Date date){
			if(date!=null ){
				return sdf_yyyy_MM_dd_hh_mm_ss.format(date);
			}
			return null;
		}
		

}
