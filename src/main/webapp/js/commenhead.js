function initHead(pageLocation) {
	var currentDate = new Date();
	
	var year = currentDate.getFullYear();
	var month = currentDate.getMonth() + 1; 
	var day = currentDate.getDate();
	
	var week;
	var weekDay
	
	if(currentDate.getDay() == 0){
		var weekDay = 7;
	}else{
		var weekDay = currentDate.getDay();
	}
	
	if(weekDay == 1){
		week = "星期一";
	}else if(weekDay == 2){
		week = "星期二";
	}else if(weekDay == 3){
		week = "星期三";
	}else if(weekDay == 4){
		week = "星期四";
	}else if(weekDay == 5){
		week = "星期五";
	}else if(weekDay == 6){
		week = "星期六";
	}else if(weekDay == 7){
		week = "星期日";
	}
	
	var formatStr;
	
	if(month < 10){
		month = '0' + month;
	}
	
	if(day < 10){
		day = '0' + day;
	}
	
	formatStr = year + "-" + month + "-" + day;
	
	var headDoc = window.parent.parent.frames["topFrame"].document;
	
	headDoc.getElementById("topCurrentDate").innerHTML = formatStr + " " +  week;
	
	headDoc.getElementById("topCurrentPage").innerHTML = "当前位置：" + " " +  pageLocation;
		
	/**
	alert(self.frames["mainFrame"].parent.frames["leftFrame"]);	
	var topCurrentDate = headDoc.find("#topCurrentDate");
	document.getElementById("topCurrentDate").innerHTML = formatStr;
	**/
	/**
	currentDate.getYear();        //获取当前年份(2位)
	currentDate.getFullYear();    //获取完整的年份(4位,1970-????)
	currentDate.getMonth();       //获取当前月份(0-11,0代表1月)
	currentDate.getDate();        //获取当前日(1-31)
	currentDate.getDay();         //获取当前星期X(0-6,0代表星期天)
	currentDate.getTime();        //获取当前时间(从1970.1.1开始的毫秒数)
	currentDate.getHours();       //获取当前小时数(0-23)
	currentDate.getMinutes();     //获取当前分钟数(0-59)
	currentDate.getSeconds();     //获取当前秒数(0-59)
	currentDate.getMilliseconds();    //获取当前毫秒数(0-999)
	currentDate.toLocaleDateString();     //获取当前日期
	**/
}


function initLoginUser(userName){
    var headDoc = window.parent.parent.frames["topFrame"].document;
    
    var showUsername;
	if(userName.length > 10){
		showUsername = userName.substr(0,10);
		showUsername = showUsername + "..";
	}else{
		showUsername = userName;
	}
	headDoc.getElementById("topCurrentUser").innerHTML = showUsername;
}

