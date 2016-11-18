package com.cmri.bpt.web.timetasker;

import java.text.SimpleDateFormat;
import java.util.Date;

public class GetdataJob {
	public void test(){
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		System.out.println(df.format(new Date()));
	}

}
