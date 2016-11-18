package com.cmri.bpt.web.util;

import java.util.HashMap;
import java.util.Map;

public class PhoneCrawlerHolder {


	private static Map<Integer,PhoneNumberCrawler> userPhoneCrawler =new HashMap<Integer, PhoneNumberCrawler>();
	
	public static void addPhoneCrawler(Integer userId, PhoneNumberCrawler crawler)
	{	
		userPhoneCrawler.put(userId, crawler);	
		
	}
	
	
	public static PhoneNumberCrawler getPhoneCrawler(Integer userId)
	{
		return userPhoneCrawler.get(userId);
	}
	
	
	
	
	
}
