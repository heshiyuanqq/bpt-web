<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="${pageContext.request.contextPath}/css/public.css"
	rel="stylesheet" type="text/css">

<link href="${pageContext.request.contextPath}/css/buttonstyle.css"
	rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-1.8.0.js"></script>
<script language="javascript" type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery.form.js"></script>


<script type="text/javascript" language="javascript"
	src="${pageContext.request.contextPath}/js/commenhead.js"></script>
<script type="text/javascript" language="javascript"
	src="${pageContext.request.contextPath}/js/taskmain/fxw_taskmain.js"></script>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/bootstrap/css/bootstrap-theme.min.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.css"
	rel="stylesheet">
<script src="${pageContext.request.contextPath}/js/jquery.min.js"></script>
<script
	src="${pageContext.request.contextPath}/js/bootstrap/bootstrap.min.js"></script>
<script
	src="${pageContext.request.contextPath}/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.min.js"></script>
<script
	src="${pageContext.request.contextPath}/echarts/build/dist/echarts.js"></script>

<title>测试结果与分析</title>
<style type="text/css">
#Division1_img {
	left: 0 top:       0px;
	width: 3px;
	height: 750px;
}

#Division2_img {
	left: 0px;
	top: 0px;
	width: 3px;
	height: 750px;
}

#u4638_img {
	left: 0px;
	top: 0px;
	width: 250px;
	height: 24px;
}

#u3723 {
	position: absolute;
	left: 50px;
	top: 4px;
	width: 201px;
	word-wrap: break-word;
}

#u3724 {
	position: absolute;
	left: 300px;
	top: 4px;
	width: 201px;
	word-wrap: break-word;
}

p {
	display: block;
	-webkit-margin-before: 1em;
	-webkit-margin-after: 1em;
	-webkit-margin-start: 0px;
	-webkit-margin-end: 0px;
}

#u3722 {
	font-family: 'Arial Negreta', 'Arial';
	font-weight: 700;
	color: #FFFFFF;
}

#u4670 {
	position: absolute;
	left: 200px;
	top: 5px;
	width: 16px;
	height: 16px;
	font-family: 'Arial Negreta', 'Arial';
	font-weight: 700;
	color: #FFFFFF;
	text-align: left;
}

#u4670_img {
	left: 0px;
	top: 0px;
	width: 16px;
	height: 16px;
}

.ax_h1 {
	font-style: normal;
	color: #333333;
	text-align: left;
	line-height: normal;
}

.ax_动态面板 {
	font-family: 'Arial Normal', 'Arial';
	font-weight: 400;
	font-style: normal;
	font-size: 13px;
	color: #333333;
	line-height: normal;
}

.left_title {
    width: 99%;
    height: 30px;
    background: #3FB4D7 none repeat scroll 0% 0%;
    background-image: linear-gradient(to bottom, #5BC0DE 0px, #2AABD2 100%);
    line-height: 30px;
    font-family: "Helvetica Neue",Helvetica,Arial,sans-serif;
    font-size: 14px;
    color: #FFF;
    border: 1px solid #28A4C9;
    border-radius: 6px;
    margin: 2px auto;
    text-align: center;
}
.func {
    width: 25px;
    height: 25px;
    padding: 2px;
    position: absolute;
    top: 5px;
    right: 5px;
    color: #FFF;
    cursor: pointer;
    }
    
    .func1 {
    width: 25px;
    height: 25px;
    padding: 2px;
    position: absolute;
    top: 40px;
    right: 3px;
    color: #FFF;
    cursor: pointer;
    }
        .func2 {
    width: 25px;
    height: 25px;
    padding: 2px;
    position: absolute;
    top: 178px;
    right: 3px;
    color: #FFF;
    cursor: pointer;
    }
        .func3 {
    width: 25px;
    height: 25px;
    padding: 2px;
    position: absolute;
    top: 5px;
    right: 15px;
    color: #FFF;
    cursor: pointer;
    }
    
    .tabletitle {
    width: 60%;
    height: 29px;
    line-height: 29px;
    color: #FFF;
    background: #36E2B4 none repeat scroll 0% 0%;
    border: 1px solid #36E2B4;
    border-radius: 5px;
    text-align: center;
    margin: 0 auto;
    cursor: pointer;
}
input {
	/* 圆角边框 */
	text-align: center;
}
</style>


<script type="text/javascript">

var color1=new Array();
color1=["active","success","info","warning","danger"];
window.onload = function() {
	$(".form_datetime").datetimepicker({format: 'yyyy-mm-dd',  
        autoclose: true,  
        startView: 2,  
        minView: 2,  
        forceParse: false,  
        language: 'zh-CN' });
	$(".form_datetime1").datetimepicker({format: 'yyyy-mm-dd',  
        autoclose: true,  
        startView: 2,  
        minView: 2,  
        forceParse: false,  
        language: 'zh-CN'});
	show_case_list();//显示所有case列表
};

//前端封装map方法
function Map() {
    this.elements = new Array();
 
    //获取MAP元素个数
    this.size = function() {
        return this.elements.length;
    };
 
    //判断MAP是否为空
    this.isEmpty = function() {
        return (this.elements.length < 1);
    };
 
    //删除MAP所有元素
    this.clear = function() {
        this.elements = new Array();
    };
 
    //向MAP中增加元素（key, value) 
    this.put = function(_key, _value) {
        this.elements.push( {
            key : _key,
            value : _value
        });
    };
 
    //删除指定KEY的元素，成功返回True，失败返回False
    this.remove = function(_key) {
        var bln = false;
        try {
            for (var i = 0; i < this.elements.length; i++) {
                if (this.elements[i].key == _key) {
                    this.elements.splice(i, 1);
                    return true;
                }
            }
        } catch (e) {
            bln = false;
        }
        return bln;
    };
 
    //获取指定KEY的元素值VALUE，失败返回NULL
    this.get = function(_key) {
        try {
            for (var i = 0; i < this.elements.length; i++) {
                if (this.elements[i].key == _key) {
                    return this.elements[i].value;
                }
            }
        } catch (e) {
            return null;
        }
    };
 
    //获取指定索引的元素（使用element.key，element.value获取KEY和VALUE），失败返回NULL
    this.element = function(_index) {
        if (_index < 0 || _index >= this.elements.length) {
            return null;
        }
        return this.elements[_index];
    };
 
    //判断MAP中是否含有指定KEY的元素
    this.containsKey = function(_key) {
        var bln = false;
        try {
            for (var i = 0; i < this.elements.length; i++) {
                if (this.elements[i].key == _key) {
                    bln = true;
                }
            }
        }catch (e) {
            bln = false;
        }
        return bln;
    };
 
    //判断MAP中是否含有指定VALUE的元素
    this.containsValue = function(_value) {
        var bln = false;
        try {
            for (var i = 0; i < this.elements.length; i++) {
                if (this.elements[i].value == _value) {
                    bln = true;
                }
            }
        } catch (e) {
            bln = false;
        }
        return bln;
    };
};
//根据action.txt的action类型 对应不同的文字显示以及图片显示
var behaviormap = new Map();
behaviormap.put("Tel","Call");
behaviormap.put("WeiXinText","TXT");
behaviormap.put("WeiXinImage","Img");
behaviormap.put("WeiXinVoice","Voc");
behaviormap.put("WeiXinVideo","Vid");
behaviormap.put("FTP","FTP");
behaviormap.put("SMS","SMS");
behaviormap.put("Web","Web");
behaviormap.put("Ping","Ping");
behaviormap.put("Network","NW");
behaviormap.put("CellChange","Cell");

var behaviorimg=new Map();
behaviorimg.put("Tel","${pageContext.request.contextPath}/img/result/call.gif");
behaviorimg.put("WeiXinText","${pageContext.request.contextPath}/img/result/txt.gif");
behaviorimg.put("WeiXinImage","${pageContext.request.contextPath}/img/result/img.gif");
behaviorimg.put("WeiXinVoice","${pageContext.request.contextPath}/img/result/voc.gif");
behaviorimg.put("WeiXinVideo","${pageContext.request.contextPath}/img/result/vid.gif");
behaviorimg.put("FTP","${pageContext.request.contextPath}/img/result/ftp.gif");
behaviorimg.put("SMS","${pageContext.request.contextPath}/img/result/sms.gif");
behaviorimg.put("Web","${pageContext.request.contextPath}/img/result/web.gif");
behaviorimg.put("Ping","${pageContext.request.contextPath}/img/result/ping.gif");
behaviorimg.put("Network","${pageContext.request.contextPath}/img/result/nw.gif");
behaviorimg.put("CellChange","${pageContext.request.contextPath}/img/result/nw.gif");
//填写查询时间
$(function(){
	//$("input[type=file]").change(function(){$(this).parents(".uploader").find(".filename").val($(this).val());});
	$("#time_end").change(function(){
		if($("#time_end").val()<$("#time_start").val() && $("#time_end").val()!=""){
			alert("最终时间不得超过起始时间，请重新填写");
			document.getElementById("time_end_flag").style.color="#ff0000";
			document.getElementById("time_end").value=" ";
		}
		else{
			document.getElementById("time_end_flag").style.color="";
		}
	
	});
	
});


//查询列表 打开和关闭
function change_img(){
	var img=$("#drop").attr("class");
	if(img=="glyphicon glyphicon-arrow-up")
		{
			$("#drop").attr("class","glyphicon glyphicon-arrow-down");
			$("#u4642_state1").css("display","none");
			$("#case_list").css("height","720px");
			$(".func").attr("title","打开");
			$("#drop2").attr("class","glyphicon glyphicon-arrow-down");
			$("#detail").css("display","none");
			$(".func2").attr("title","打开");

		   
			
		}
	else{
		$("#drop").attr("class","glyphicon glyphicon-arrow-up");
		$("#u4642_state1").css("display","block");
		$("#case_list").css("height","544px");
		$(".func").attr("title","收起");
		
	
		
	   }
	
}

//case列表的打开与关闭
function change_img2(){
	var img=$("#drop2").attr("class");
	if(img=="glyphicon glyphicon-arrow-up")
		{
			$("#drop2").attr("class","glyphicon glyphicon-arrow-down");
			$("#detail").css("display","none");
			$(".func2").attr("title","打开");
			$("#case_list").css("height","544px");
			
		}
	else{
		$("#drop2").attr("class","glyphicon glyphicon-arrow-up");
		$("#detail").css("display","block");
		$(".func2").attr("title","收起");
		$("#case_list").css("height","319px");

		
	   }
	
}
var color=new Array();
color=["info","success","warning","danger"];
var num=0;

//显示所选case下所有的action
function detail(casename)
{
	//jquery不支持id中含.
	
	if(document.getElementById(casename).style.color!=""){
		 document.getElementById(casename).style.color="";
		 var name =casename.replace(/\./g, '\\.');
		 $("#"+name+"show").remove();
		 resetcolor();
		 num--;
		}
	else{
		
		 $.ajax({
				type : "POST",
				async : false,
				url : "${pageContext.request.contextPath}/result/searchbehaviorbycase",
		        data:  { 
		        	casename:casename,
					},
               success : function(data) {
                    //alert(data);
					if(data!='null'&& data != '' && data != null){
				    document.getElementById(casename).style.color="#ff0000";
					 var behaviorgroup=data.split(";");
					 var titlename=casename.split("分")[0]+"分";
					 
					 var titlename=titlename.split("_")[0];
					  
					
					 var a="<div class=\"panel panel-"+color[num%4]+"\" id=\""+casename+"show\">"+
					   "<div class=\"panel-heading\" style=\"text-align:center\">"+
					       "<span >"+titlename+"</span>"+ 
					       "<img id=\"u4743_img\" class=\"img \" src=\"${pageContext.request.contextPath}/img/result/u4726.png\" onclick=\"showlogresult('"+casename+"');\" tabindex=\"0\" style=\"width:20px;height:20px;margin-left:20%;cursor: pointer;\"> " +          
					  " </div>"+
					  " <div class=\"panel-body\">";
					  var group_num=1;
					  for(var i=0;i<behaviorgroup.length;i++)
						  {
                             if(i%3==0)
						    	  {
						    	     a=a+"<div id=\"group"+group_num+"\" style=\"width:100%;height:40px\">";
						    	     group_num++;
						    	  }
                             var pos=(i%3==0)?13:37;
						      a=a+ "<div id=\""+casename+"_"+behaviorgroup[i]+"\"  class=\"ax_图片\" onclick=\"showonelogresult('"+casename+"','"+behaviorgroup[i]+"');\" style=\"cursor: pointer;width: 20%;height: 37px; position:relative;float:left; margin-left:10%\">"+
								         "<img id=\""+casename+"_"+behaviorgroup[i]+"\" class=\"img\"  src="+behaviorimg.get(behaviorgroup[i])+" tabindex=\"0\" style=\"width: 37px;height: 37px;font-family: \'Gill Sans MT Negreta\', \'Gill Sans MT\';font-weight: 700;font-size: 12px;color: #FFFFFF;\">"+
							             "<div id=\"u4721\" class=\"text\" style=\"position:absolute;top:9px;left:5px\">"+
							                "<p ><span>"+behaviormap.get(behaviorgroup[i])+"</span></p>"+
							             "</div>"+
					               "</div>";
					          if(i%3==2)
					        	  {
					        	  a=a+"</div>";
					        	  }
						  }
			          var $tr=$(a);
					 $("#column2").append($tr);
					 num++;
					 
						return true;
					}else if(data=='null')
						{
						   alert(casename+"没有可供分析的日志文件");
						   return true;
						
						}

				},
				fail : function() {
					alert("失败！");
				}
			});
		
		}

}

//删除指定testcase并刷新
function  deleteByName(casename){
	$.ajax({
		type : "POST",
		async : false,
		url : "${pageContext.request.contextPath}/result//deleteCaseByName",
        data:  { 
        	casename:casename,
			},
       success : function(data) {
    	   if("success" == data){
    		   search();
    		   alert("删除成功！");
    	   }else{
    		   alert("删除失败！");
    	   }
       },
		fail : function() {
			alert("失败！");
		}
	});


}

//重置所有测试结果与指标项目 下 所选case模块的颜色
function  resetcolor(){
	var $tbody=$('#column2').children();
	for(var i=0,len=$tbody.length;i<len;i++){
		if(i!=0){	
			$tbody[i].setAttribute("class","panel panel-"+color[(i-1)%4]);
			}
		}
}

//根据条件查询 所有满足条件的case列表
function search(){
	 var objS = document.getElementById("behaviorgroupselect");
	 var grade = objS.options[objS.selectedIndex].value;
	
	 var start_date= document.getElementById("time_start").value;
	 var end_date=document.getElementById("time_end").value;
	 /* if(grade==" "&&start_date==" "&&end_date==" "){
		 alert("请设置查询条件");
		 return false;
	 } */
	$.ajax({
		type : "POST",
		async : false,
		url : "${pageContext.request.contextPath}/result/searchallcase",
        data:  { 
			selectedcase:grade,
			start_date:start_date,
			end_date:end_date
			
		},
  
		success : function(data) {
			if(data!='null'){
				$("#case_list_tobody").children().remove();
				var $tbody=$('#column2').children();
				for(var i=0,len=$tbody.length;i<len;i++){
					if(i!=0){	
						$($tbody[i]).remove();
						}
					}
				num=0;
				var caselist=$.parseJSON(data);
				for(var i=0;i<caselist.length;i++){
					var txtname=caselist[i].filename.split("分")[0]+"分";
					var trcolor="";
					var trnum=i+1;
					if(i%2==0)
						{
						   trcolor=color1[(i/2)%5];
						}
					
					var a="<tr class=\""+trcolor+"\" id=\""+caselist[i].filename+"\" style=\" cursor: pointer;\">" +
					"<th scope=\"row\">"+trnum+"</th>" +
					"<td>" +
					"<a onclick=\"detail('"+caselist[i].filename + "')\">"+ txtname +"</a>" +
					"</td>" +
					"<td width='40'>" +
					"<a onclick=\"deleteByName('"+caselist[i].filename + "')\">"+ "删除" +"</a>" +
						"</td>" +
					"</tr>";
					var $tr=$(a);
					$("#case_list_tobody").append($tr);
				}
				$('#column2').children().remove();
				clearmypicture();
				return true;
			}else if(data=='null')
				{
				   alert("没有符合条件的测试用例");
				   return true;
				
				}

		},
		fail : function() {
			alert("查询失败！");
		}
	});
}


//显示所有case列表
function show_case_list(){
	 var objS = document.getElementById("behaviorgroupselect");
	 var grade = objS.options[objS.selectedIndex].value;
	 var start_date= document.getElementById("time_start").value;
	 var end_date=document.getElementById("time_end").value;
	$.ajax({
		type : "POST",
		async : false,
		url : "${pageContext.request.contextPath}/result/searchallcase",
       data:  { 
			selectedcase:grade,
			start_date:start_date,
			end_date:end_date
			
		},
 
		success : function(data) {
			//alert(data);

			if(data!='null'){
				$("#case_list_tobody").children().remove();
				var $tbody=$('#column2').children();
				for(var i=0,len=$tbody.length;i<len;i++){
					if(i!=0){	
						$($tbody[i]).remove();
						}
					}
				num=0;
				var caselist=$.parseJSON(data);
				for(var i=0;i<caselist.length;i++){
					
						var txtname=caselist[i].filename.split("分")[0]+"分";
						var trcolor="";
						var trnum=i+1;
						if(i%2==0)
							{
							   trcolor=color1[(i/2)%5];
							}
						//var a="<input id=\""+caselist[i].filename+"\" style=\"width: 100%;height: 25px;\" type=\"text\" value=\""+txtname+"\" readonly  onclick=\"detail('"+caselist[i].filename+"');\"/>";
						//var a="<tr class=\""+trcolor+"\" id=\""+caselist[i].filename+"\" onclick=\"detail('"+caselist[i].filename+"');\" style=\" cursor: pointer;\"><th scope=\"row\">"+trnum+"</th><td>"+txtname+"</td></tr>";
						var a="<tr class=\""+trcolor+"\" id=\""+caselist[i].filename+"\" style=\" cursor: pointer;\">" +
						"<th scope=\"row\">"+trnum+"</th>" +
						"<td>" +
						"<a onclick=\"detail('"+caselist[i].filename + "')\">"+ txtname +"</a>" +
						"</td>" +
						"<td width='40'>" +
						"<a onclick=\"deleteByName('"+caselist[i].filename + "')\">"+ "删除" +"</a>" +
 						"</td>" +
						"</tr>";
						var $tr=$(a);
						$("#case_list_tobody").append($tr);
					
					var $op=$("<option>"+caselist[i].filename+"</option>");
					$("#behaviorgroupselect").append($op);
				}
				return true;
			}else if(data=='null')
				{
				   alert("还没有可用的测试用例");
				   return true;
				
				}

		},
		fail : function() {
			alert("失败！");
		}
	});
}

//显示所选case的所有log结果图
function showlogresult(casename) {
/* 	alert(casename+"----"+encodeURI(casename));
	casename=encodeURI(casename); */

	$("#showAllLog").attr("href","${pageContext.request.contextPath}/logAnalyze/loganylizebycaselogname?caselogname="+casename);
	document.getElementById("showAllLog").click();
}
var clicknum=0;

//显示所选case下的被选action的单个log结果图
function showonelogresult(casename,logtype) {
	//alert(logtype);
   require.config({
       paths: {
           echarts: '${pageContext.request.contextPath}/echarts/build/dist'
       }
   });
   require(
       [
           'echarts',
           'echarts/chart/line',   // 按需加载所需图表，如需动态类型切换功能，别忘了同时加载相应图表
           'echarts/chart/bar',
           'echarts/chart/scatter',
           'echarts/chart/pie'
       ],
       function (ec) {
    	   
         
           if(logtype=="FTP"){
      	    $.ajax({
   			type : "POST",
   			async : false,
   			url : "${pageContext.request.contextPath}/logtopic/getftplog",
   			data : { 
   				case_name : casename
   			},
               success : function(data) {
           		
               	var up=[];
               	var down=[];
               	var title4;
   				if(data != 'null'){
   				
   				  var a="<div class=\"panel panel-info\" id=\""+logtype+"\" style=\"width: 100%;\"><div class=\"panel-heading\">"+
  				"<span class=\"glyphicon glyphicon-home\" aria-hidden=\"true\"></span>&nbsp;FTP("+casename+")"+
  				"</div>"+
  				"<div class=\"panel-footer\" style=\" width: 100%;\">"+
  					"<div id=\"myftpdown_speed"+casename+"\" style=\"width: 100%; height: 200px\">"+
  					"</div>"+
  				 "<div id=\"myftpup_speed"+casename+"\" style=\"width: 100%; height: 150px\">"+
  					"</div>"+ 
  				 "<div id=\"myftp_fail"+casename+"\" style=\"width: 100%; height: 150px\">"+
  					"</div>"+ 
  				"</div>"+
  			    "</div>";
  	              var $tr=$(a);
  	              $("#"+casename+"_"+logtype).attr("onclick","closepicture(\""+casename+"\",\""+logtype+"\")");
  	   
  	   $("#result_list").append($tr);
  	    var myChart4 = ec.init(document.getElementById('myftpdown_speed'+casename));
   		var myChart41 = ec.init(document.getElementById('myftpup_speed'+casename));
		var myChart5= ec.init(document.getElementById('myftp_fail'+casename)); 
		myChart4.showLoading({
		  text:'....',
		  effect:'bubble',
		    textStyle : {
		        fontSize : 20
		    }
		});
		/* myChart41.showLoading({
			  text:'....',
			  effect:'bubble',
			    textStyle : {
			        fontSize : 20
			    }
			}); */
		/**
		myChart5.showLoading({
			  text:'....',
			  effect:'bubble',
			    textStyle : {
			        fontSize : 20
			    }
			});
		**/	
				var ftpdata=new Array();
			    var xAxisDate = new Array();
				var seriesDateUp = new Array();
				var seriesDateDown = new Array();
				ftpdata=data.split("$$");
				
				if(ftpdata[0]!='null'){
					var ftpdownlog = $.parseJSON(ftpdata[0]);
				    for(var j=0;j<ftpdownlog.length;j++){
                
           	            down.push([ftpdownlog[j].x_data, parseFloat(ftpdownlog[j].y_Stringdata)]); 
              	        title4=ftpdownlog[j].start_time;
                    	xAxisDate.push(ftpdownlog[j].x_data);
                     	seriesDateDown.push(parseFloat(ftpdownlog[j].y_Stringdata));
              }
					
			}
         	    
				if(ftpdata[1]!='null'){
					var ftpuplog=$.parseJSON(ftpdata[1]); 
				    for(var k=0;k<ftpuplog.length;k++){
         	        up.push([ftpuplog[k].x_data,parseFloat(parseFloat(ftpuplog[k].y_Stringdata))]);
           	        title4=ftpuplog[k].start_time;
           	        seriesDateUp.push(parseFloat(ftpuplog[k].y_Stringdata));
       
           }
				}
         	               
         	    var fail=$.parseJSON(ftpdata[3]);
         	    var fail_data=[];
         	    var x1_data=[];

             for(var m=0;m<fail.length;m++){
          	   fail_data.push(fail[m].y_data);
          	   x1_data.push(fail[m].x_data)
          	 
             }
             console.log(ftpdownlog);
             console.log(ftpuplog);
             console.log(fail);
              	if (down.length != 0) {
            	    var option4 = {
            	    		title : {
            	    			    text:'FTP DL',
					   		        x:'center',
					   		     y:'10',
					   		     textStyle:{
	   					   		        
   					   		         fontSize: 12,
   					   		         fontWeight:'lighter',
   					   		         color:'#4488BB'
   					   		        }
					   		    },
                 		    /* tooltip : {
                 		       trigger: 'axis',
                 		       formatter : function (params) {
                     	            return params.seriesName + ' : [ '
                     	                   + params.value[0] + ', ' 
                     	                   + params.value[1] + ' ]';
                     	        }
                 		  
                 		    }, */
	                 		   tooltip : {
	              					trigger : 'axis'
	              				},
                 		    legend: {
                 		    	x:'right',
                 		    	y:'10',
                 		        data:['DL'],
                 		        orient:'vertal',
                 		        itemGap:2,
                 		        itemHeight:10               		    
                 		    },               		    
                 		    
                 		     grid:{
                 		    	x:50,
                 		    	y:30,
                 		    	x2:45,
                 		    	y2:30
                 		    },
                 		    toolbox: {
                 		
                 		        show : false,
                 		        feature : {             		                     		   
                 		            dataZoom : {show: true},
                 		            magicType : {show: true, type: ['line', 'bar']},
                 		            restore : {show: true},
                 		            saveAsImage : {show: true}
                 		        }
                 		    },
                 		   dataZoom : {
        		  		    	fillerColor:'#00EEEE',
        		  		        show : true,
        		  		        realtime: true,
        		  		        height:10,
        		  		        start : 0,
        		  		        end : 8
        		  		    },
                 		    calculable : true,
                 		    xAxis :  [
                 		            {
                 		            	type : 'category',
                       					boundaryGap : false,
                       					name:'time(s)',
                       					data : xAxisDate
                 		            
                 		          }
                 		      ],
                 		    yAxis : [
                 		        {
                 		            type : 'value',
                 		            name:'                  Data Rate(Mbps)',
                 		            interval:'auto',
                 		            scale:true,
                 		            
                 		            axisLabel : {
                 		                formatter: '{value}'
                 		            }
                 		        }
                 		    ],
                 		    
                 		   series : [ {
              					name : 'DL',
              					type : 'line',
              					data : seriesDateDown
              				} ]
            	    
                 		   /* series : (function(){
                 		    	var all=[];
                 		    	if(down.length!=0){
                 		    		var onedown=  {
                         		            name:'FTPDL',
                         		            type:'line',
                         		            data:  down,
                         		            itemStyle:{
                                               normal: {
                                               color:"#FF7F50"                                      
                                             }},
                         		            markPoint : {
                         		                data : [
                         		                        {type : 'max', name: '最大值'},
                             		                    {type : 'min', name: '最小值'}                          		              
                         		                ]
                         		            },
                         		            markLine : {
                         		                data : [
                         		                    {type : 'average', name : '平均值'}
                         		                ]
                         		            }
                         		        }
                 		    		all.push(onedown);
                 		    	} */
                 		    /* 	if(up.length!=0){
                 		    		var oneup=  {
                         		            name:'FTP上传',
                         		            type:'line',
                         		            data:  up,
                         		            markPoint : {
                         		                data : [
                         		                        {type : 'max', name: '最大值'},
                             		                    {type : 'min', name: '最小值'} 
                         		              
                         		                ]
                         		            },
                         		            markLine : {
                         		                data : [
                         		                    {type : 'average', name : '平均值'}
                         		                ]
                         		            }
                         		        }
                 		    		all.push(oneup);
                 		    	} 
                 		    	return all;
                 		    	
                 		    	
                 		    })(),*/
                 		};
              	}
            	if (up.length != 0) {
            	    var option41 = {
            	    		title : {
            	    			text:'FTP UL',
					   		     x:'center',
					   		  y:'10',
					   		     textStyle:{
	   					   		        
   					   		         fontSize: 12,
   					   		         fontWeight:'lighter',
   					   		         color:'#4488BB'
   					   		        }
					   		    },
					   		 color:['#87cefa'],
                 		    tooltip : {
                 		        trigger: 'axis',
                 		       formatter : function (params) {
                     	            return params.seriesName + ' : [ '
                     	                   + params.value[0] + ', ' 
                     	                   + params.value[1] + ' ]';
                     	        }
                 		  
                 		    },
                 		    legend: {
                 		    	x:'right',
                 		    	y:'10',
                 		        data:['FTPUL'],
                 		        orient:'vertal',
                 		        itemGap:2,
                 		        itemHeight:10
                 		      
                 		    
                 		    },
                 		    grid:{
                 		    	x:50,
                 		    	y:30,
                 		    	x2:45,
                 		    	y2:30
                 		    },
                 		    toolbox: {
                 		
                 		        show : false,
                 		        feature : {             		                     		   
                 		            dataZoom : {show: true},
                 		            magicType : {show: true, type: ['line', 'bar']},
                 		            restore : {show: true},
                 		            saveAsImage : {show: true}
                 		        }
                 		    },
                 		    dataZoom : {
               		    	fillerColor:'#00EEEE',
               		        show : true,
               		        realtime: true,
               		        height:10,
               		        begin:0,
               		        end:8
               		      
               		    },
                 		    calculable : true,
                 		    xAxis :  [
                 		            {
                 		             type : 'value',
                 		              name:'time(s)', 
                 		             axisLabel:{
               	          	            show:true
               	          	         },
                 		            
                 		          }
                 		      ],
                 		    yAxis : [
                 		        {
                 		            type : 'value',
                 		            name:'                  Data Rate(Mbps)',
                 		            interval:'auto',
                 		            scale:true,
                 		           splitNumber:3,
                 		            axisLabel : {
                 		                formatter: '{value}'
                 		            }
                 		        }
                 		    ],
                 		
                 		   series : (function(){
                 		    	var all=[];
                 		    /* 	if(down.length!=0){
                 		    		var onedown=  {
                         		            name:'FTP下载',
                         		            type:'line',
                         		            data:  down,
                         		            markPoint : {
                         		                data : [
                         		                        {type : 'max', name: '最大值'},
                             		                    {type : 'min', name: '最小值'} 
                         		              
                         		                ]
                         		            },
                         		            markLine : {
                         		                data : [
                         		                    {type : 'average', name : '平均值'}
                         		                ]
                         		            }
                         		        }
                 		    		all.push(onedown);
                 		    	} */
                 		     	if(up.length!=0){
                 		    		var oneup=  {
                         		            name:'FTPUL',
                         		            type:'line',
                         		            data:  up,
                         		            markPoint : {
                         		                data : [
                         		                        {type : 'max', name: '最大值'},
                             		                    {type : 'min', name: '最小值'} 
                         		              
                         		                ]
                         		            },
                         		            markLine : {
                         		                data : [
                         		                    {type : 'average', name : '平均值'}
                         		                ]
                         		            }
                         		        }
                 		    		all.push(oneup);
                 		    	} 
                 		    	return all;
                 		    	
                 		    	
                 		    })(),
                 		};
              	}
            	   var option5 = {
            			   title : {
					   		        text: 'FTP失败统计',
					   		        x:'center',
					   		     y:'12',
					   		     textStyle:{
	   					   		        
   					   		         fontSize: 12,
   					   		         fontWeight:'lighter',
   					   		         color:'#4488BB'
   					   		        
   					   		     
   					   		        }
					   		    },
   		    		    tooltip : {
   		    		        trigger: 'axis',
   		    		       formatter: function (params){
   		    		    	  return '时间 :'+params[0].name+ 's<br/>'+
   			                    '出现次数:'+ params[0].value+ '次<br/>';
   		    		       }
   		    		    },
   		    		    legend: {
   		    		    	x : 'right',
   		    		    	y:'12',
   		    		        data:['失败次数统计']
   		    		    },
   		    		  grid:{
           		    	x:30,
           		    	y:30,
           		    	x2:45,
           		    	y2:30
           		    },
   		    		    toolbox: {
   		    		    	 
   		    		        show : false,
   		    		        feature : {
   		    		            dataZoom : {show: true},
   		    		            magicType : {show: true, type: ['line', 'bar']},
   		    		            restore : {show: true},
   		    		            saveAsImage : {show: true}
   		    		        }
   		    		    },
   		    		     dataZoom : {
   		       		    	fillerColor:'#00EEEE',
   		       		        show : true,
   		       		        realtime: true,
   		       		        height:10,
   		       		        start : 0,
   		       		        end : 8
   		       		    }, 
   		    		    calculable : true,
   		    		    xAxis : [ {
   						
   							 name:'时间',
   							 axisLabel:{
       	          	            show:false
       	          	          },
   					
   							data:x1_data,
   						} ],
   						yAxis : [ {
   							type : 'value',
   							 name:'                  失败次数(次)',
   							scale : true,
   							interval:'auto',
   						    splitNumber:3,
   							 axisLabel : {
   		    		                formatter: '{value}'
   		    		            }
   						} ],
   		    	
   		    		    series : [
   		    		        {
   		    		            name:'失败次数统计',
   		    		            type:'line',
   		    		            data:fail_data,
   		    		         itemStyle:{
                                 normal: {
                    
                                 color:"#4488BB"
                        
                               }},
   		    		            markPoint : {
   		    		                data : [
   		    		                    {type : 'max', name: '最大值'},
   		    		                    {type : 'min', name: '最小值'}
   		    		                ]
   		    		            },
   		    		            markLine : {
   		    		                data : [
   		    		                    {type : 'average', name: '平均值'}
   		    		                ]
   		    		            }
   		    		        }
   		    		     
   		    		    ]
   		    		};
            		if (up.length != 0){
						 myChart41.setOption(option41);
						 myChart41.hideLoading(); 

					}else{
						$("#myftpup_speed").hide();
					}
					if (down.length != 0){
						myChart4.setOption(option4);
						 myChart4.hideLoading();

					}else{
						$("#myftpdown_speed").hide();
					}

						myChart5.hideLoading();
						myChart5.setOption(option5); 
  			

   				}else{
   					alert("FTP吞吐率查询失败！");
   				}

   			},
   			fail : function() {
   				alert("FTP吞吐率查询失败！");
   			}
   		});
       }
           else if(logtype=="Network"){
        	  
              $.ajax({
      			type : "POST",
      			async : false,
      			url : "${pageContext.request.contextPath}/logtopic/getnetworklog",
      			data : { 
      				case_name : casename
      			},
                  success : function(data) {
             	//console.log(data);
                   var cell_type=[];
                   var allcell=[];                              
      				if(data != 'null'){

         				var a="<div class=\"panel panel-info\" id=\""+logtype+"\" style=\"width: 100%;\">" +
         				"<div class=\"panel-heading\">" +
        				    "<span class=\"glyphicon glyphicon-home\" aria-hidden=\"true\"></span>&nbsp;NetWork(" + casename + ")"+
        				"</div>" +
        				
        				/* "<div class=\"panel-footer\" style=\" width: 100%; height: 160px\">" +
        					"<div id=\"mynetwork"+casename+"\" style=\"width: 100%; height: 150px\"></div>" +        				
        				"</div>" +  */
        				
	    				"<div id=\"mynetwork_call_container\" class=\"panel-footer\" style=\" width: 100%; height: 360px\">"+
	    					"<div id=\"mynetwork_call"+casename+"\" style=\"width: 100%; height: 350px\"></div>" +        				
	    				"</div>" +
	    				
	    				"<div id=\"mynetwork_video_container\" class=\"panel-footer\" style=\" width: 100%; height: 360px\">"+
	    					"<div id=\"mynetwork_video"+casename+"\" style=\"width: 100%; height: 350px\"></div>"+        				
    				    "</div>" +
	    				
	    				"<div id=\"mynetwork_flow_container\" class=\"panel-footer\" style=\" width: 100%; height: 360px\">"+
	    					"<div id=\"mynetwork_flow"+casename+"\" style=\"width: 100%; height: 350px\"></div>"+        				
	    				"</div>" +
        				
        			    "</div>";
        	              var $tr=$(a);
        	              $("#"+casename+"_"+logtype).attr("onclick","closepicture(\""+casename+"\",\""+logtype+"\")");
        	   
        	   $("#result_list").append($tr);
				/* var myChart= ec.init(document.getElementById('mynetwork'+casename));       
				myChart.showLoading({
     	       	  text:'....',
     	       	  effect:'bubble',
     	       	    textStyle : {
     	       	        fontSize : 20
     	       	    }
     	       	}); */
      					var networkdata=new Array();
      					networkdata=data.split("$$");
      					var getnetworkdata = $.parseJSON(networkdata[2]);
      					var networktype=$.parseJSON(networkdata[0]);
      	          	     for(var i=0;i<networkdata[1];i++){
      	            		 cell_type.push(networktype[i].cellname);
      	            		 var net;
      	            		 switch(i){
      	            		     case 0: net=getnetworkdata.CELL1;break;
      	            		     case 1: net=getnetworkdata.CELL2;break;
   	   	            		 case 2: net=getnetworkdata.CELL3;break;
   	   	            		 case 3: net=getnetworkdata.CELL4;break;
   	   	            		 case 4: net=getnetworkdata.CELL5;break;
   	   	            		 case 5: net=getnetworkdata.CELL6;break;
   	   	            		 case 6: net=getnetworkdata.CELL7;break;
   	   	            		 case 7: net=getnetworkdata.CELL8;break;
   	   	            		 case 8: net=getnetworkdata.CELL9;break;
   	   	            		 case 9: net=getnetworkdata.CELL10;break;
   	   	            		 case 10: net=getnetworkdata.CELL11;break;
   	   	            		 case 11: net=getnetworkdata.CELL12;break;
   	   	            		 case 12: net=getnetworkdata.CELL13;break;
   	   	            		default: 
   	   	            			alert("小区ID出错");
      	            		 
      	            		 }
      	            		   var cell = [];
      	            			for(var j=0;j<net.length;j++){

      	            				cell.push([
                		                        net[j].x_data,
                		                        net[j].y_data
                		                    ]);

      	            				var title0=net[j].start_time;
      	            			} 
      	            		
      	            			allcell.push(cell);
      	            		 
      	                     	}
      	          	 var option = {
      	          			title : {
					   		       // text: '信号强度',
      	          			text: 'LTE RSRP',
    		   		        x:'center',
    		   		        y: '25',
	    		   		     textStyle:{
					   		        
				   		         fontSize: 12,
				   		         fontWeight:'lighter',
				   		         color:'#4488BB'
				   		        
				   		     
				   		        }
					   		    },
                		    tooltip : {
                		        trigger: 'axis',
                		        showDelay : 1,
                		        formatter : function (params) {
                		            if (params.value.length > 1) {
                		                return "小区ID:"+params.seriesName + ' :<br/>time:'
                		                   + params.value[0] +'s <br/>RSRP:'
                		                   + params.value[1]+ '(dbm) ' ;
                		            }
                		            else {
                		                return params.seriesName + ' :<br/>'
                		                   + params.name + ' : '
                		                   + params.value;
                		            }
                		        },  
                		        axisPointer:{
                		            show: true,
                		            type : 'cross',
                		            lineStyle: {
                		                type : 'dashed',
                		                width : 1
                		            }
                		        }
                		    },
                		    legend: {
                		    	x : 'right',
                		    	y : '25',
                		    	itemHeight:10,
                		        itemGap:3,
                		    	padding:[2,30,2,30],
                		        data:cell_type,
                		    },
                		 
                		    toolbox: {
                		        show : false,
                		        feature : {                    

                		       //     saveAsImage : {show: true}
                		        }
                		    },
                		    grid:{
                 		    	x:30,
                 		    	y:50,
                 		    	x2:45,
                 		    	y2:30
                 		    },
                		    dataZoom : {
                		    	fillerColor:'#00EEEE',
                		        show : true,
                		        realtime: true,
                		        height:10,
                		        start : 40,
                		        end : 60
                		    }, 
                		    xAxis : [
                		        {
                		            type : 'value',
                		            scale:true,             		            
                		            name:'time(s)',
                		            axisLabel:{
              	          	            show:false
              	          	          },
                		            axisLabel : {
                		                formatter: '{value} '
                		            }
                		        }
                		    ],
                		    yAxis : [
                		        {
                		            type : 'value',
                		            scale:true,
                		            name:'                  RSRP(dbm)',
                		            splitNumber:3,
                		            axisLabel : {
                		                formatter: '{value}'
                		            }
                		        }
                		    ],
                		    series : (function(){
                		    	 var all=[];
                		    	 for(var i=0;i<networkdata[1];i++)
                		    		 {
                		    		  // alert(networktype[i].cellid);
                		    		    var one={
                		    		    		name:networktype[i].cellname,
                		    		    		type:'scatter',
                		    		    		data: allcell[i],
                		    		    		 itemStyle:{
                                                     normal: {
                                        
                                                     color:"#4488BB"
                                            
                                                   }},
                		    	
                		    		    		markPoint : {
                		    		    			effect:{
                		    		    			    show: false,
                		    		    			    type: 'scale',
                		    		    			    loop: true,
                		    		    			    period: 15,
                		    		    			    scaleSize : 1,
                		    		    			    bounceDistance: 10,
                		    		    			    color : null,
                		    		    			    shadowColor : null,
                		    		    			    shadowBlur : 0
                		    		    			} ,     
                             		                data : [
                             		                    {type : 'max', name: '最大值'},
                             		                    {type : 'min', name: '最小值'}
                             		                ]
                             		            },
                             		            markLine : {
                             		                data : [
                             		                    {type : 'average', name: '平均值'}
                             		                ]
                             		            }
                		    		    }
                		    		    all.push(one);
                		    		 }
                		    	 return all;
                		    	
                		    })(),
                		};
      				           /* myChart.hideLoading();
      				           myChart.setOption(option); */
      				}else{
      					alert("network查询失败！");
      					
      				}

      			},
      			fail : function() {
      				alert("network查询失败！");
      			}
      		});
 
              /*call速率  */       	  
              $.ajax({
      			type : "POST",
      			async : false,
      			url : "${pageContext.request.contextPath}/logtopic/getnetworkflowlog",
      			data : { 
      				case_name : casename,
      				name : 'calllog'
      			},
                
      			success : function(data) {    				
					var xAxisDate = new Array();
					var seriesDateUp = new Array();
					var seriesDateDown = new Array();
                             
      			   if(null != data && data != 'null' && data != ''){
	   					var networkFlowList = $.parseJSON(data);
	   					for (var i = 0; i < networkFlowList.length; i++) {
	   						var networkFlowObj = networkFlowList[i];
	   						xAxisDate.push(networkFlowObj.x_data );
	   						seriesDateUp.push(networkFlowObj.y_updata);
	   						seriesDateDown.push(networkFlowObj.y_downdata);
	   					}
	   					
        	   var myChart= ec.init(document.getElementById('mynetwork_call'+casename));       
               myChart.showLoading({
     	       	  text:'....',
     	       	  effect:'bubble',
     	       	    textStyle : {
     	       	        fontSize : 20
     	       	    }
     	       	});
               
               var option2 = {
       				title : {
       					text: 'VoLTE',
		   		        x:'center',
		   		     y:'12',
		   		     textStyle:{
				   		        
			   		         fontSize: 12,
			   		         fontWeight:'lighter',
			   		         color:'#4488BB'
			   		        
			   		     
			   		        }
       				},
       				tooltip : {
       					trigger : 'axis'
       				},
       				//上侧折线图对应Key
       				legend : {
       					data : [ 'DL', 'UL' ],
       					x : 'right',
     					y:'25'
       				},
       				//上侧多态图标栏显示,不需要直接关闭
       				toolbox : {
       					show : false,
       					feature : {
       						mark : {
       							show : true
       						},
       						dataView : {
       							show : true,
       							readOnly : false
       						},
       						magicType : {
       							show : true,
       							type : [ 'line', 'bar' ]
       						},
       						restore : {
       							show : true
       						},
       						saveAsImage : {
       							show : true
       						}
       					}
       				},
       				dataZoom : {
 		  		    	fillerColor:'#00EEEE',
 		  		        show : true,
 		  		        realtime: true,
 		  		        height:10,
 		  		        start : 30,
 		  		        end : 70
 		  		    },
       				calculable : true,
       				xAxis : [ {
       					type : 'category',
       					boundaryGap : false,
       					name:'time(s)',
       					data : xAxisDate
       				} ],
       				yAxis : [ {
       					type : 'value',
       					name:'                  Data Rate(Mbps)',
	    		        interval:'auto',
	    		        scale:true,
       					axisLabel : {
       						formatter : '{value}'
       					}
       				} ],
       				series : [ {
       					name : 'DL',
       					type : 'line',
       					data : seriesDateDown
       				}, {
       					name : 'UL',
       					type : 'line',
       					data : seriesDateUp
       				} ]
       			};
 
				           myChart.hideLoading();
				           myChart.setOption(option2); 
   
      				}else{
      					document.getElementById("mynetwork_call_container").style.display = 'none';     					
      					//alert("Network统计查询失败！");     					
      				}

      			},
      			fail : function() {
      				alert("call总流量速率查询失败！");
      			}
      		}); 
              
              
              /*video速率  */       	  
              $.ajax({
      			type : "POST",
      			async : false,
      			url : "${pageContext.request.contextPath}/logtopic/getnetworkflowlog",
      			data : { 
      				case_name : casename,
      				name : 'videolog'
      			},
                
      			success : function(data) {    				
					var xAxisDate = new Array();
					var seriesDateUp = new Array();
					var seriesDateDown = new Array();
                             
      			   if(null != data && data != 'null' && data != ''){
	   					var networkFlowList = $.parseJSON(data);
	   					for (var i = 0; i < networkFlowList.length; i++) {
	   						var networkFlowObj = networkFlowList[i];
	   						xAxisDate.push(networkFlowObj.x_data );
	   						seriesDateUp.push(networkFlowObj.y_updata);
	   						seriesDateDown.push(networkFlowObj.y_downdata);
	   					}
	   					
        	   var myChart= ec.init(document.getElementById('mynetwork_video'+casename));       
               myChart.showLoading({
     	       	  text:'....',
     	       	  effect:'bubble',
     	       	    textStyle : {
     	       	        fontSize : 20
     	       	    }
     	       	});
               
               var option2 = {
       				title : {
       					text: 'Video',
		   		        x:'center',
		   		     y:'12',
		   		     textStyle:{
				   		        
			   		         fontSize: 12,
			   		         fontWeight:'lighter',
			   		         color:'#4488BB'
			   		        
			   		     
			   		        }
       				},
       				tooltip : {
       					trigger : 'axis'
       				},
       				//上侧折线图对应Key
       				legend : {
       					data : [ 'DL', 'UL' ],
       					x : 'right',
     					y:'25'
       				},
       				//上侧多态图标栏显示,不需要直接关闭
       				toolbox : {
       					show : false,
       					feature : {
       						mark : {
       							show : true
       						},
       						dataView : {
       							show : true,
       							readOnly : false
       						},
       						magicType : {
       							show : true,
       							type : [ 'line', 'bar' ]
       						},
       						restore : {
       							show : true
       						},
       						saveAsImage : {
       							show : true
       						}
       					}
       				},
       				dataZoom : {
 		  		    	fillerColor:'#00EEEE',
 		  		        show : true,
 		  		        realtime: true,
 		  		        height:10,
 		  		        start : 30,
 		  		        end : 70
 		  		    },
       				calculable : true,
       				xAxis : [ {
       					type : 'category',
       					boundaryGap : false,
       					name:'time(s)',
       					data : xAxisDate
       				} ],
       				yAxis : [ {
       					type : 'value',
       					name:'                  Data Rate(Mbps)',
	    		        interval:'auto',
	    		        scale:true,
       					axisLabel : {
       						formatter : '{value}'
       					}
       				} ],
       				series : [ {
       					name : 'DL',
       					type : 'line',
       					data : seriesDateDown
       				}, {
       					name : 'UL',
       					type : 'line',
       					data : seriesDateUp
       				} ]
       			};
 
	           myChart.hideLoading();
	           myChart.setOption(option2); 
   
      				}else{
      					//var container = document.getElementById("mynetwork_video_container");
      					//alert(container);
      					document.getElementById("mynetwork_video_container").style.display = 'none';
      					//alert("Network统计查询失败！");     					
      				}

      			},
      			fail : function() {
      				alert("video总流量速率查询失败！");
      			}
      		});
               
              
             /*总流量速率  */       	  
              $.ajax({
      			type : "POST",
      			async : false,
      			url : "${pageContext.request.contextPath}/logtopic/getnetworkflowlog",
      			data : { 
      				case_name : casename
      			},
                
      			success : function(data) {    				
					var xAxisDate = new Array();
					var seriesDateUp = new Array();
					var seriesDateDown = new Array();
                             
      			   if(data != 'null'){
	   					var networkFlowList = $.parseJSON(data);
	   					for (var i = 0; i < networkFlowList.length; i++) {
	   						var networkFlowObj = networkFlowList[i];
	   						xAxisDate.push(networkFlowObj.x_data );
	   						seriesDateUp.push(networkFlowObj.y_updata);
	   						seriesDateDown.push(networkFlowObj.y_downdata);
	   					}
	   					
        	   var myChart= ec.init(document.getElementById('mynetwork_flow'+casename));       
               myChart.showLoading({
     	       	  text:'....',
     	       	  effect:'bubble',
     	       	    textStyle : {
     	       	        fontSize : 20
     	       	    }
     	       	});
               
               var option2 = {
       				title : {
       					text: 'Total Throughput',
		   		        x:'center',
		   		        y: '25',
		   		     textStyle:{
				   		        
			   		         fontSize: 12,
			   		         fontWeight:'lighter',
			   		         color:'#4488BB'
			   		        
			   		     
			   		        }
       				},
       				tooltip : {
       					trigger : 'axis'
       				},
       				//上侧折线图对应Key
       				legend : {
       					data : [ 'DL', 'UL' ],
       					x : 'right',
     					y:'25'
       				},
       				//上侧多态图标栏显示,不需要直接关闭
       				toolbox : {
       					show : false,
       					feature : {
       						mark : {
       							show : true
       						},
       						dataView : {
       							show : true,
       							readOnly : false
       						},
       						magicType : {
       							show : true,
       							type : [ 'line', 'bar' ]
       						},
       						restore : {
       							show : true
       						},
       						saveAsImage : {
       							show : true
       						}
       					}
       				},
       				dataZoom : {
 		  		    	fillerColor:'#00EEEE',
 		  		        show : true,
 		  		        realtime: true,
 		  		        height:10,
 		  		        start : 30,
 		  		        end : 70
 		  		    },
       				calculable : true,
       				xAxis : [ {
       					type : 'category',
       					boundaryGap : false,
       					name:'time(s)',
       					data : xAxisDate
       				} ],
       				yAxis : [ {
       					type : 'value',
       					name:'                  Data Rate(Mbps)',
	    		        interval:'auto',
	    		        scale:true,
       					axisLabel : {
       						formatter : '{value}'
       					}
       				} ],
       				series : [ {
       					name : 'DL',
       					type : 'line',
       					data : seriesDateDown
       				}, {
       					name : 'UL',
       					type : 'line',
       					data : seriesDateUp
       				} ]
       			};
 
				           myChart.hideLoading();
				           myChart.setOption(option2); 
   
      				}else{
      					//alert("Network统计查询失败！");     					
      				}

      			},
      			fail : function() {
      				alert("总流量速率统计查询失败！");
      			}
      		});   
              
           }
           else if(logtype=="Tel"){
        	   var callexist=1;
        	  
               $.ajax({
       			type : "POST",
       			async : false,
       			url : "${pageContext.request.contextPath}/logtopic/getcallsuccessrate",
       			data : { 
       				case_name : casename
       			},
       			
                   success : function(data) {
                	//console.log(data);
                   	var x_data=[];
                   	var y_data=[];
                   	var dl=[];
                   	var ul=[];
                       var title6;
                       
       				if(data != 'null'){
       				  var a="<div class=\"panel panel-info\" id=\""+logtype+"\" style=\"width: 100%; \"><div class=\"panel-heading\">"+
        				"<span class=\"glyphicon glyphicon-home\" aria-hidden=\"true\"></span>&nbsp;语音：("+casename+")"+
        				"</div>"+
        				"<div class=\"panel-footer\" style=\" width: 100%; height: 520px\">"+
        					"<div id=\"mycall_success"+casename+"\" class=\"panel-footer\" style=\"width: 100%; height: 250px;\">"+
        					"</div>"+
        					"<div id=\"mycall_number"+casename+"\" class=\"panel-footer\" style=\"width: 100%; height: 250px;\">"+
        					"</div>"+
        				"</div>"+
        			    "</div>";
        	              var $tr=$(a);
        	              $("#"+casename+"_"+logtype).attr("onclick","closepicture(\""+casename+"\",\""+logtype+"\")");
        	 			  $("#result_list").append($tr);
        	 			 var myChart6= ec.init(document.getElementById('mycall_success'+casename));
       			     	myChart6.showLoading({
       				       	  text:'....',
       				       	  effect:'bubble',
       				       	    textStyle : {
       				       	        fontSize : 20
       				       	    }
       				       	});
       			     
       					var callsuccessrate = $.parseJSON(data);
       					//console.log(callsuccessrate);
       	          	     for(var i=0;i<callsuccessrate.length;i++){
       	            		x_data.push(callsuccessrate[i].x_time);
       	            		y_data.push(callsuccessrate[i].y_rate);
       	            		title6=callsuccessrate[i].start_time;       	            		
       	                     	};
       	          	    
       					   var option6 = {
       							title : {
   					   		        text: '通话接通率',
   					   		        x:'left',
   					   		  //y:'12',
   					   		   textStyle:{
  					   		        
 					   		         fontSize: 20,
 					   		         fontWeight:'lighter',
 					   		         color:'#4488BB'
 					   		        
 					   		     
 					   		        }
   					   		    },
       				    		    tooltip : {
       				    		        trigger: 'axis',
       				    		       formatter: function (params){
       				    		    	  return '时间 :'+params[0].name+ 's<br/>'+
       					                    '接通率:'+ params[0].value+ '%<br/>';
       				    		       }
       				    		    },
       				    		    legend: {
       				    		    	x : 'center',
       				    		    	//y:'32',
       				    		        data:['接通率统计']
       				    		    },
       				    		    toolbox: {
       				    		        show : true,
       				    		        feature : {				  
       				    		        	dataZoom : {show: true},
       				    		            magicType : {show: true, type: ['line', 'bar']},
       				    		            restore : {show: true},
       				    		            saveAsImage : {show: true}
       				    		        }
       				    		    },
       				    		 grid:{
                      		    	x:30,
                      		    	y:70,
                      		    	x2:45,
                      		    	y2:40
                      		    },
       				    		    dataZoom : {
       				  		    	fillerColor:'#00EEEE',
       				  		        show : true,
       				  		        realtime: true,
       				  		        height:10,
       				  		        start : 0,
       				  		        end : 8
       				  		    },
       				    		    calculable : true,
       				    		    xAxis : [
       				    		        {
       				    		        	//type : 'category',
       				    		        	type : 'category',
       				    		            name:'时间(s)',	
       				    		         axisTick:{
       										alignWithLabel:true,
       										interval :'auto',      										
       										onGap:false,       										 
       									},
       									splitLine: {show:true},
       									axisLabel:{
       										interval:'auto'										
       									}, 
       				    		            data:x_data,
       				    		        }
       				    		    ],
       				    		    yAxis : [
       				    		        {
       				    		            type : 'value',
       				    		            name:'接通率(%)',
       				    		            interval:'auto',
       				    		            splitNumber:2,
       				    		            scale:true,
       				    		            axisLabel : {
       				    		                formatter: '{value} '
       				    		            }
       				    		        }
       				    		    ],
       				    		    series : [
       				    		        {
       				    		            name:'接通率统计',
       				    		            type:'line',
       				    		            showAllSymbole:false,
       				    		            data:y_data,
       				    		         itemStyle:{
                                             normal: {
                                
                                             color:"#4488BB"
                                    
                                           }},
       				    		            markPoint : {
       				    		            	
       				    		                data : [
       				    		                    {type : 'max', name: '最大值(%)'},
       				    		                    {type : 'min', name: '最小值(%)'}
       				    		                ]
       				    		            },
       				    		            markLine : {
       				    		                data : [
       				    		                    {type : 'average', name: '平均值(%)'}
       				    		                ]
       				    		            }
       				    		        }
       				    		     
       				    		    ]
       				    		};
       					   
       					   
       					   
       				       

       				           myChart6.hideLoading();
       				           myChart6.setOption(option6); 
       			

       				}else{
       					callexist=0;
       					alert("通话接通率查询失败！");
       				}

       			},
       			fail : function() {
       				alert("通话接通率查询失败！");
       			}
       		});
               if(callexist==1){//这儿修改了 原为 callexist==1 
            	   $.ajax({
             			type : "POST",
             			async : false,
             			url : "${pageContext.request.contextPath}/logtopic/getcallusernumber",
             			//getcallusernumber             			
             			data : { 
             				case_name : casename
             			},
                         success : function(data) {
                         //alert(data);
                         //console.log(data);
                         	var x_data=[];
                         	var y_data=[];
                         	var title7;
             				if(data != 'null'){
             					var myChart7= ec.init(document.getElementById('mycall_number'+casename)); 
             					myChart7.showLoading({
             		         	  text:'....',
             		         	  effect:'bubble',
             		         	    textStyle : {
             		         	        fontSize : 20
             		         	    }
             		         	});
             		     	
             				//用接通率得到的数据统计在线用户数 
             				//方法1： 在线人数为 sendcalllog 成功失败总和的2倍 
             					/* var callsuccessrate = $.parseJSON(data);
              	          	     for(var i=0;i<callsuccessrate.length;i++){
              	            		x_data.push(callsuccessrate[i].x_time);
              	            		y_data.push((callsuccessrate[i].successnumber+callsuccessrate[i].failenumber)*2);
              	            		title6=callsuccessrate[i].start_time;       	            		
              	                     	}
              	          	var n=60;
       	       	          	for(var i=1;i<callsuccessrate.length;i++){
       							x_data.splice(i,n);
       							y_data.splice(i,n);
       							
       						}	 */
             		
       				//方法2
      	       	     var callOnlineNum = $.parseJSON(data);
  	          	     for(var i=0;i<callOnlineNum.length;i++){
  	            		x_data.push(callOnlineNum[i].x_data);
  	            		y_data.push(callOnlineNum[i].y_data);
  	            		title7=callOnlineNum[i].start_time;       	            		
  	                     	}
  	          		/* var n=60;
      	          	for(var i=1;i<callOnlineNum.length;i++){
					x_data.splice(i,n);
					y_data.splice(i,n);
					
				} */	
       	       	          	
                        	 //var callusernumber = $.parseJSON(data);
                        	 //console.log(callusernumber);
                        	 //var time=0;
                      	     //for(var i=0;i<callusernumber.length;i++){
                      	    	 /* while(time<callusernumber[i].x_data){
                      	    		 x_data.push(time);
                                 	 y_data.push(0);
                                    time++;
                      	    	 } */
                        		     /* x_data.push(callusernumber[i].x_data);
                        		     y_data.push(callusernumber[i].y_data);
                        		     title7=callusernumber[i].start_time;
                        		     time++;
                                 	} */
             				  var option7= {
             						 title : {
        					   		        text: '通话用户数',
        					   		        x:'left',
        					   		     //y:'12',
        					   		     textStyle:{
        	   					   		        
           					   		         fontSize: 20,
           					   		         fontWeight:'lighter',
           					   		         color:'#4488BB'
           					   		        
           					   		     
           					   		        }
        					   		    },
             		    		    tooltip : {
             		    		        trigger: 'axis',
             		    		       formatter: function (params){
             		    		    	  return '时间 :'+params[0].name+ 's<br/>'+
             			                    '用户数:'+ params[0].value+ '<br/>';
             		    		       }
             		    		    },
             		    		    legend: {
             		    		    	x : 'center',
             		    		    	//y:'12',
             		    		        data:['通话用户数统计']
             		    		    },
             		    		    toolbox: {
             		    		        show : true,
             		    		        feature : {
             		    		        	dataZoom : {show: true},
             		    		            magicType : {show: true, type: ['line', 'bar']},
             		    		            restore : {show: true},
             		    		            saveAsImage : {show: true}
             		    		        }
             		    		    },
             		    		   grid:{
                         		    	x:30,
                         		    	y:70,
                         		    	x2:45,
                         		    	y2:40
                         		    },
             		    		    dataZoom : {
             		  		    	fillerColor:'#00EEEE',
             		  		        show : true,
             		  		        realtime: true,
             		  		        height:10,
             		  		        start : 0,
             		  		        end : 8
             		  		    }, 
             		    		    calculable : true,
             		    		    xAxis : [
             		    		        {
             		    		        	type : 'category',
             		    		            name:'时间(s)',
             		    		           //boundaryGap:[0,0.3],
             		    		          axisLabel:{
                    	          	            show:true,
                    	          	          interval:'auto'	
                    	          	          },
             		    		            data:x_data,
             		    		        }
             		    		    ],
             		    		    yAxis : [
             		    		        {
             		    		            type : 'value',
             		    		            name:'用户数',
             		    		            interval:'auto',
             		    		           splitNumber:3,
             		    		            scale:true,
             		    		            axisLabel : {
             		    		                formatter: '{value} '
             		    		            }
             		    		        }
             		    		    ],
             		    		    series : [
             		    		        {
             		    		            name:'通话用户数统计',
             		    		            type:'line',
             		    		            data: y_data,
             		    		           itemStyle:{
                                               normal: {
                                  
                                               color:"#4488BB"
                                      
                                             }},
             		    		            markPoint : {
             		    		                data : [
             		    		                    {type : 'max', name: '最大值'},
             		    		                    {type : 'min', name: '最小值'}
             		    		                ]
             		    		            },
             		    		            markLine : {
             		    		                data : [
             		    		                    {type : 'average', name: '平均值'}
             		    		                ]
             		    		            }
             		    		        }
             		    		     
             		    		    ]
             		    		};



             				           myChart7.hideLoading();
             				           myChart7.setOption(option7); 
             			

             				}else{
             			  
             					$("#"+logtype).remove();
             				}

             			},
             			fail : function() {
             				alert("通话用户数失败！");
             			}
             		});
               }
        	   
           }
           
           else if(logtype=="Web"){
        	   $.ajax({
       			type : "POST",
       			async : false,
       			url : "${pageContext.request.contextPath}/logtopic/getweblog",
       			data : { 
       				case_name : casename
       			},
                   success : function(data) {
                   //	alert(data);
                   	var x_data=[];
                   	var y_data=[];
                   	var y1_data=[];
                   	var y2_data=[];
                   	var y3_data=[];
                   	var x3_data=[];
                   	var start_time;
                     var a0=0,a1=0,a2=0,a3=0;
       				if(data != 'null'){
       				 var a="<div class=\"panel panel-info\" id=\""+logtype+"\" style=\"width: 100%;\"><div class=\"panel-heading\">"+
     				"<span class=\"glyphicon glyphicon-home\" aria-hidden=\"true\"></span>&nbsp;Web：("+casename+")"+
     				"</div>"+
     				"<div class=\"panel-footer\" style=\" width: 100%; height: 470px\">"+
     					 "<div id=\"myweb_fail"+casename+"\" style=\"width: 100%; height: 150px\">"+
     					"</div>"+
     					"<div id=\"myweb_success"+casename+"\" style=\"width: 98%; height: 150px\">"+
     					"</div>"+
     					"<div id=\"myweb_delay"+casename+"\" style=\"width: 98%; height: 150px\">"+
     					"</div>"+
     				"</div>"+
     			    "</div>";
     	              var $tr=$(a);
     	              $("#"+casename+"_"+logtype).attr("onclick","closepicture(\""+casename+"\",\""+logtype+"\")");
     	 			  $("#result_list").append($tr);
     	 			 var myChart11= ec.init(document.getElementById('myweb_fail'+casename));
      	 	        var myChart12= ec.init(document.getElementById('myweb_success'+casename));
     	 	        var myChart13= ec.init(document.getElementById('myweb_delay'+casename)); 

     	 	         myChart11.showLoading({
     	 	      	  text:'....',
     	 	      	  effect:'bubble',
     	 	      	    textStyle : {
     	 	      	        fontSize : 20
     	 	      	    }
     	 	      	}); 

     	 	        myChart12.showLoading({
     	 	      	  text:'....',
     	 	      	  effect:'bubble',
     	 	      	    textStyle : {
     	 	      	        fontSize : 20
     	 	      	    }
     	 	      	});

     	 	        myChart13.showLoading({
     	 	      	  text:'....',
     	 	      	  effect:'bubble',
     	 	      	    textStyle : {
     	 	      	        fontSize : 20
     	 	      	    }
     	 	      	});

       					var webfail = $.parseJSON(data);
       	          	     for(var i=0;i<webfail.length;i++){
       	            		x_data.push(webfail[i].x_data);
       	            		y1_data.push(webfail[i].y1_data);
       	            		y2_data.push(webfail[i].y2_data);
       	            		start_time=webfail[i].start_time;
       	            		if(webfail[i].y3_data!=-1){
       	            			x3_data.push(webfail[i].x_data);
       	            		    y3_data.push(parseFloat(webfail[i].y3_Stringdata));	            		    
       	            		    if(webfail[i].y3_data>0&&webfail[i].y3_data<=2){
       	            		    	   a0++;
       	            		    	}
       	            		    else if(webfail[i].y3_data>2&&webfail[i].y3_data<=4){
       	            		    	   a1++;
       	            		    }
       	            		    else if(webfail[i].y3_data>4&&webfail[i].y3_data<=6){
       	            		    	   a2++;
       	            		    }
       	            		    else{
       	            		    	a3++;
       	            		    }
       	            		    
       	            		}
       	                     	}
       	          	     console.log(x_data);
       	          	     console.log(y1_data);
       					    var option11 = {
       							title : {
   					   		        text: 'Webbrowser',
   					   		        x:'center',
   					   		  y:'12',
   					   		        textStyle:{
   					   		        
   					   		         fontSize: 12,
   					   		         fontWeight:'lighter',
   					   		         color:'#4488BB'
   					   		        
   					   		     
   					   		        }
   					   		    },
       				    		    tooltip : {
       				    		        trigger: 'axis',
       				    		       formatter: function (params){
       				    		    	  return '时间 :'+params[0].name+ 's<br/>'+
       					                    '失败次数:'+ params[0].value+ '<br/>';
       				    		       }
       				    		    },
       				    		    legend: {
       				    		    	x : 'right',
       				    		    	y:'12',
       				    		        data:['web失败次数统计']
       				    		    },
       				    		 toolbox: {
                                     
                                     show : false,
                                        feature : {                 
                                            dataZoom : {show: true},                       
                                            magicType : {show: true, type: ['line', 'bar']},
                                            restore : {show: true},
                                            saveAsImage : {show: true}
                                        }
                                    },
                                 grid:{
                                            x:30,
                                            y:30,
                                            x2:45,
                                            y2:30
                                          },
        				    		   dataZoom : {
        				  		    	fillerColor:'#00EEEE',
        				  		        show : true,
        				  		        realtime: true,
        				  		        height:10,
        				  		        start : 30,
        				  		        end : 70
        				  		    }, 
       				    		    calculable : true,
       				    		 xAxis : [
                                          {
                                            type : 'category',
                                              name:'time(s)',
                                           axisLabel:{
                                              show:true
                                            },
                                              //boundaryGap:[0,0.8],
                                              data:x_data,
                                          }
                                      ],
       				    		   yAxis : [
       	                                    {
       	                                        type : 'value',
       	                                        name:'                  失败次数(次)',
       	                                        interval:'auto',
       	                                        scale:true,
       	                                     splitNumber:3,
       	                                        axisLabel : {
       	                                            formatter: '{value}'
       	                                        }
       	                                    }
       	                                ],
       				    		 series : [
                                           {
                                               name:'web失败次数统计',
                                               type:'line',
                                               data: y1_data,
                                            itemStyle:{
                                                      normal: {
                                         
                                                      color:"#4488BB"
                                             
                                                    }},
                                               markPoint : {
                                                   data : [
                                                       {type : 'max', name: '最大值'},
                                                       {type : 'min', name: '最小值'}
                                                   ]
                                               },
                                               markLine : {
                                                   data : [
                                                       {type : 'average', name: '平均值'}
                                                   ]
                                               }
                                           }
                                           
                                           
                                            
                                      /*     {
                                               name:'Web延时统计',
                                               type:'pie',
                                               tooltip : {
                                                   trigger: 'item',
                                                   formatter: '{a} <br/>{b} : {c} ({d}%)'
                                               },
                                               center: [430,60],
                                               radius : [0, 15],
                                               itemStyle :{
                                                   normal : {
                                                       labelLine : {
                                                           length : 10
                                                       }
                                                   }
                                               },
                                               data:[
                                                   {value:a0, name:'0~2s'},
                                                   {value:a1, name:'2~4s'},
                                                   {value:a2, name:'4~6s'},
                                                   {value:a3, name:'6s以上'}
                                               ]
                                           }  */
                                        
                                       ]
       				    		}; 
       				    	  
       					   
       					   
       					   option12 = {
       					   		    title : {
       					   		        text: 'Success Rate',
       					   		        x:'center',
       					   		  y:'10',
       					   		   textStyle:{
      					   		        
     					   		         fontSize: 12,
     					   		         fontWeight:'lighter',
     					   		         color:'#4488BB'
     					   		        
     					   		     
     					   		        }
       					   		    },
       					   		    tooltip : {
       					   		        trigger: 'axis',
       					   		        formatter: function (params){
       					   		            return 'time :'+params[0].name+ 's<br/>'+
       					   		                    'Rate:'+ params[0].value+'%<br/>';         
       					   		        }
       					   		    },
       					   		    legend: {
       					   		        x : 'right',
       					   		    	y:'10',
       					   		        data:['Success Rate']
       					   		    },
       					   		    toolbox: {
       					   		          show : false,
       					   		        feature : {
       					   		        	dataZoom : {show: true},
       					   		            magicType : {show: true, type: ['line', 'bar']},
       					   		            restore : {show: true},
       					   		            saveAsImage : {show: true}
       					   		        }
       					   		    },
       					   		 grid:{
                       		    	x:30,
                       		    	y:30,
                       		    	x2:45,
                       		    	y2:30
                       		    },
        				    		   /*  dataZoom : {
        				  		    	fillerColor:'#00EEEE',
        				  		        show : true,
        				  		        realtime: true,
        				  		        height:10,
        				  		        start : 30,
        				  		        end : 70
        				  		    },  */
       					   		    calculable : true,
       					   		    xAxis : [
       					   		        {
       					   		            type : 'category',
       					   		            name:'time(s)',
       					   		      axisLabel:{
       					               show:true
       					             },
       					   		            boundaryGap : false,
       					   		            data : x_data,
       					   		        }
       					   		    ],
       					   		    yAxis : [
       					        		        {
       					        		            type : 'value',
       					        		            interval:'auto',
       					        		            name:'                  Success Rate(%)',
       					        		            scale:true,
       					        		            splitNumber:3,
       					        		            axisLabel : {
       					        		                formatter: '{value} '
       					        		            }
       					        		        }
       					        		    ],
       					   		    series : [
       					   		        {
       					   		            name:'Success Rate',
       					   		            type:'line',
       					   		            smooth:true,
       					   		      itemStyle:{
      				                       normal: {
      				          
      				                       color:"#4488BB"
      				              
      				                     }
       					   		        },
       					   		            data:y2_data,
       					   		        }
       					   		    ]
       					   		};
       					   
       					   
       					   var option13 = {
       							title : {
   					   		        text: 'Web Latency',
   					   		        x:'center',
   					   		        y:'10',
   					   		   textStyle:{
  					   		        
 					   		         fontSize: 12,
 					   		         fontWeight:'lighter',
 					   		         color:'#4488BB'
 					   		        }
   					   		    },
       							    tooltip : {
       							        trigger: 'axis',
       							       formatter: function (params){
       							    	  return 'time :'+params[0].name+ 's<br/>'+
       						               'Latency:'+ params[0].value+ 's<br/>';
       							       }
       							    },
       							    legend: {
       							    	x : 'right',
       							    	y:'10',
       							        data:['Latency']
       							    },
       							    toolbox: {
       							    	 
       							     show : false,
       							        feature : {							    
       							            dataZoom : {show: true},							         
       							            magicType : {show: true, type: ['line', 'bar']},
       							            restore : {show: true},
       							            saveAsImage : {show: true}
       							        }
       							    },
       							 grid:{
                       		    	x:30,
                       		    	y:30,
                       		    	x2:45,
                       		    	y2:30
                       		    },
        				    		  /*  dataZoom : {
        				  		    	fillerColor:'#00EEEE',
        				  		        show : true,
        				  		        realtime: true,
        				  		        height:10,
        				  		        start : 30,
        				  		        end : 70
        				  		    }, */
       							    calculable : true,
       							    xAxis : [
       							        {
       							        	type : 'category',
       							            name:'time(s)',
       							         axisLabel:{
       							            show:true
       							          },
       							            boundaryGap:[0,0.8],
       							            data:x3_data,
       							        }
       							    ],
       							    yAxis : [
       							        {
       							            type : 'value',
       							            name:'                  Latency(s)',
       							            interval:'auto',
       							            scale:true,
       							         splitNumber:3,
       							            axisLabel : {
       							                formatter: '{value}'
       							            }
       							        }
       							    ],
       							    series : [
       							        {
       							            name:'Latency',
       							            type:'line',
       							            data: y3_data,
       							         itemStyle:{
        				                       normal: {
        				          
        				                       color:"#4488BB"
        				              
        				                     }},
       							            markPoint : {
       							                data : [
       							                    {type : 'max', name: '最大值'},
       							                    {type : 'min', name: '最小值'}
       							                ]
       							            },
       							            markLine : {
       							                data : [
       							                    {type : 'average', name: '平均值'}
       							                ]
       							            }
       							        },
       							        
       							        
       							         
       							        {
       							            name:'Web延时统计',
       							            type:'pie',
       							            tooltip : {
       							                trigger: 'item',
       							                formatter: '{a} <br/>{b} : {c} ({d}%)'
       							            },
       							            center: [430,60],
       							            radius : [0, 15],
       							            itemStyle :{
       							                normal : {
       							                    labelLine : {
       							                        length : 10
       							                    }
       							                }
       							            },
       							            data:[
       							                {value:a0, name:'0~2s'},
       							                {value:a1, name:'2~4s'},
       							                {value:a2, name:'4~6s'},
       							                {value:a3, name:'6s以上'}
       							            ]
       							        }  
       							     
       							    ]
       							};
       					   
       					   
        				      myChart11.hideLoading();
       				          myChart12.hideLoading();
       				          myChart13.hideLoading();
        				      myChart11.setOption(option11);
        				      myChart12.setOption(option12);
       				          myChart13.setOption(option13);
       			

       				}else{
       					$("#web_picture").remove();
       				}

       			},
       			fail : function() {
       				alert("Web失败次数查询失败！");
       			}
       		});
           }
           else if(logtype=="Ping"){
        	   $.ajax({
       			type : "POST",
       			async : false,
       			url : "${pageContext.request.contextPath}/logtopic/getpinglog",
       			data : { 
       				case_name : casename
       			},
                   success : function(data) {
                   	//alert(data);
                   	var x_data=[];
                   	var y_data=[];
                   	var y1_data=[];
                   	var y2_data=[];
                   	var y3_data=[];
                   	var x3_data=[];
                   	var start_time;
                       var a0=0,a1=0,a2=0,a3=0;
       				if(data != 'null'){
       				 var a="<div class=\"panel panel-info\" id=\""+logtype+"\" style=\"width: 100%;\"><div class=\"panel-heading\">"+
      				"<span class=\"glyphicon glyphicon-home\" aria-hidden=\"true\"></span>&nbsp;Ping：("+casename+")"+
      				"</div>"+
      				"<div class=\"panel-footer\" style=\" width: 100%; height: 470px\">"+
      					"<div id=\"myping_fail"+casename+"\" style=\"width: 100%; height: 150px\">"+
      					"</div>"+
      					"<div id=\"myping_success"+casename+"\" style=\"width: 100%; height: 150px\">"+
      					"</div>"+
      					"<div id=\"myping_delay"+casename+"\" style=\"width: 100%; height: 150px\">"+
      					"</div>"+
      				"</div>"+
      			    "</div>";
      	              var $tr=$(a);
      	              $("#"+casename+"_"+logtype).attr("onclick","closepicture(\""+casename+"\",\""+logtype+"\")");
      	 			  $("#result_list").append($tr);
      	 			  var myChart8= ec.init(document.getElementById('myping_fail'+casename));
      	 	          var myChart9= ec.init(document.getElementById('myping_success'+casename));
      	 	          var myChart10= ec.init(document.getElementById('myping_delay'+casename)); 

      	 	        myChart8.showLoading({
      	 	      	  text:'....',
      	 	      	  effect:'bubble',
      	 	      	    textStyle : {
      	 	      	        fontSize : 20
      	 	      	    }
      	 	      	});

      	 	        myChart9.showLoading({
      	 	      	  text:'....',
      	 	      	  effect:'bubble',
      	 	      	    textStyle : {
      	 	      	        fontSize : 20
      	 	      	    }
      	 	      	});

      	 	        myChart10.showLoading({
      	 	      	  text:'....',
      	 	      	  effect:'bubble',
      	 	      	    textStyle : {
      	 	      	        fontSize : 20
      	 	      	    }
      	 	      	});

       					var pingfail = $.parseJSON(data);
       	          	     for(var i=0;i<pingfail.length;i++){
       	            		x_data.push(pingfail[i].x_data);
       	            		y1_data.push(pingfail[i].y1_data);
       	            		y2_data.push(pingfail[i].y2_data);
       	            		start_time=pingfail[i].start_time;
       	            		if(pingfail[i].y3_data!=-1){
       	            			x3_data.push(pingfail[i].x_data);
       	            		    y3_data.push(pingfail[i].y3_data);	            		    
       	            		    if(pingfail[i].y3_data>0&&pingfail[i].y3_data<=5){
       	            		    	   a0++;
       	            		    	}
       	            		    else if(pingfail[i].y3_data>5&&pingfail[i].y3_data<=10){
       	            		    	   a1++;
       	            		    }
       	            		    else if(pingfail[i].y3_data>10&&pingfail[i].y3_data<=15){
       	            		    	   a2++;
       	            		    }
       	            		    else{
       	            		    	a3++;
       	            		    }
       	            		    
       	            		}
       	                     	}
       					   var option8 = {
       							title : {
   					   		        text: 'Ping失败统计',
   					   		        x:'center',
   					   		  y:'12',
   					   		   textStyle:{
  					   		        
 					   		         fontSize: 12,
 					   		         fontWeight:'lighter',
 					   		         color:'#4488BB'
 					   		        
 					   		     
 					   		        }
   					   		    },
       				    		    tooltip : {
       				    		        trigger: 'axis',
       				    		       formatter: function (params){
       				    		    	  return '时间 :'+params[0].name+ 's<br/>'+
       					                    '失败次数:'+ params[0].value+ '<br/>';
       				    		       }
       				    		    },
       				    		    legend: {
       				    		    	x : 'right',
       				    		    	y:'12',
       				    		        data:['Ping失败次数统计']
       				    		    },
       				    		    toolbox: {
       				    		        show : false,
       				    		        feature : {				  
       				    		        	dataZoom : {show: true},
       				    		            magicType : {show: true, type: ['line', 'bar']},
       				    		            restore : {show: true},
       				    		            saveAsImage : {show: true}
       				    		        }
       				    		    },
       				    		 grid:{
                        		    	x:30,
                        		    	y:30,
                        		    	x2:45,
                        		    	y2:30
                        		    },
         				    		  /*  dataZoom : {
         				  		    	fillerColor:'#00EEEE',
         				  		        show : true,
         				  		        realtime: true,
         				  		        height:10,
         				  		        start : 30,
         				  		        end : 70
         				  		    }, */
       				    		    calculable : true,
       				    		    xAxis : [
       				    		        {
       				    		        	type : 'category',
       				    		            name:'时间(s)',
       				    		         axisLabel:{
       				    		            show:false
       				    		          },
       				    		        
       				    		            data:x_data,
       				    		        }
       				    		    ],
       				    		    yAxis : [
       				    		        {
       				    		            type : 'value',
       				    		            name:'                  失败次数',
       				    		            interval:'auto',
       				    		            scale:true,
       				    		            splitNumber:3,
       				    		            axisLabel : {
       				    		                formatter: '{value} '
       				    		            }
       				    		        }
       				    		    ],
       				    		    series : [
       				    		        {
       				    		            name:'Ping失败次数统计',
       				    		            type:'line',
       				    		            data:y1_data,
       				    		         itemStyle:{
                                             normal: {
                                
                                             color:"#4488BB"
                                    
                                           }},
       				    		            markPoint : {
       				    		            	
       				    		                data : [
       				    		                    {type : 'max', name: '最大值'},
       				    		                    {type : 'min', name: '最小值'}
       				    		                ]
       				    		            },
       				    		            markLine : {
       				    		                data : [
       				    		                    {type : 'average', name: '平均值'}
       				    		                ]
       				    		            }
       				    		        }
       				    		     
       				    		    ]
       				    		};
       					   
       					   
       					   option9 = {
       							title : {
   					   		        text: 'Ping成功率',
   					   		        x:'center',
   					   		  y:'12',
   					   		   textStyle:{
  					   		        
 					   		         fontSize: 12,
 					   		         fontWeight:'lighter',
 					   		         color:'#4488BB'
 					   		        
 					   		     
 					   		        }
   					   		    },
       					   		    tooltip : {
       					   		        trigger: 'axis',
       					   		        formatter: function (params){
       					   		            return '时间 :'+params[0].name+ 's<br/>'+
       					   		                    '成功率:'+ params[0].value+'%<br/>';         
       					   		        }
       					   		    },
       					   		    legend: {
       					   		  		x : 'right',
       					   		    	y:'12',
       					   		        data:['隐藏']
       					   		    },
       					   		    toolbox: {
       					   		        show : false,
       					   		        feature : {
       					   		        	dataZoom : {show: true},
       					   		            magicType : {show: true, type: ['line', 'bar']},
       					   		            restore : {show: true},
       					   		            saveAsImage : {show: true}
       					   		        }
       					   		    },
       					   		grid:{
                       		    	x:30,
                       		    	y:30,
                       		    	x2:45,
                       		    	y2:30
                       		    },
        				    		  /*  dataZoom : {
        				  		    	fillerColor:'#00EEEE',
        				  		        show : true,
        				  		        realtime: true,
        				  		        height:10,
        				  		        start : 30,
        				  		        end : 70
        				  		    }, */
       					   		    calculable : true,
       					   		    xAxis : [
       					   		        {
       					   		            type : 'category',
       					   		            name:'时间(s)',
       					   		      axisLabel:{
       					               show:false
       					             },
       					   		            boundaryGap : false,
       					   		            data : x_data,
       					   		        }
       					   		    ],
       					   		    yAxis : [
       					        		        {
       					        		            type : 'value',
       					        		            interval:'auto',
       					        		            name:'                  成功率(%)',
       					        		            scale:true,
       					        		         splitNumber:3,
       					        		            axisLabel : {
       					        		                formatter: '{value} '
       					        		            }
       					        		        }
       					        		    ],
       					   		    series : [
       					   		        {
       					   		            name:'隐藏',
       					   		            type:'line',
       					   		            smooth:true,
       					   		      itemStyle:{
                                          normal: {
                             
                                          color:"#4488BB"
                                 
                                        }},
       					   		            data:y2_data,
       					   		        }
       					   		    ]
       					   		};
       					   
       					   
       					   var option10 = {
       							title : {
   					   		        text: 'Ping时延',
   					   		        x:'center',
   					   		   y:'12',
   					   		   textStyle:{
  					   		        
 					   		         fontSize: 12,
 					   		         fontWeight:'lighter',
 					   		         color:'#4488BB'
 					   		        
 					   		     
 					   		        }
   					   		    },
       							    tooltip : {
       							        trigger: 'axis',
       							       formatter: function (params){
       							    	  return '时间 :'+params[0].name+ 's<br/>'+
       						               '时延:'+ params[0].value+ 'ms<br/>';
       							       }
       							    },
       							    legend: {
       							    	x : 'right',
       							    	y:'12',
       							        data:['时延']
       							    },
       							    toolbox: {
       							    	 
       							        show : false,
       							        feature : {							    
       							            dataZoom : {show: true},							         
       							            magicType : {show: true, type: ['line', 'bar']},
       							            restore : {show: true},
       							            saveAsImage : {show: true}
       							        }
       							    },
       							 grid:{
                        		    	x:30,
                        		    	y:30,
                        		    	x2:45,
                        		    	y2:30
                        		    },
         				    		  /*  dataZoom : {
         				  		    	fillerColor:'#00EEEE',
         				  		        show : true,
         				  		        realtime: true,
         				  		        height:10,
         				  		        start : 30,
         				  		        end : 70
         				  		    }, */
       							    calculable : true,
       							    xAxis : [
       							        {
       							        	type : 'category',
       							            name:'时间(s)',
       							         axisLabel:{
       							            show:false
       							          },
       							            boundaryGap:[0,0.8],
       							            data:x3_data,
       							        }
       							    ],
       							    yAxis : [
       							        {
       							            type : 'value',
       							            name:'                  时延(ms)',
       							            interval:'auto',
       							            splitNumber:3,
       							            scale:true,
       							          
       							            axisLabel : {
       							                formatter: '{value} '
       							            }
       							        }
       							    ],
       							    series : [
       							        {
       							            name:'时延',
       							            type:'line',
       							            data: y3_data,
       							         itemStyle:{
                                             normal: {
                                
                                             color:"#4488BB"
                                    
                                           }},
       							            markPoint : {
       							                data : [
       							                    {type : 'max', name: '最大值'},
       							                    {type : 'min', name: '最小值'}
       							                ]
       							            },
       							            markLine : {
       							                data : [
       							                    {type : 'average', name: '平均值'}
       							                ]
       							            }
       							        },
       							        
       							        
       							        
       							       /* {
       							            name:'Ping延时统计',
       							            type:'pie',
       							            tooltip : {
       							                trigger: 'item',
       							                formatter: '{a} <br/>{b} : {c} ({d}%)'
       							            },
       							            center: [430,60],
       							            radius : [0, 15],
       							            itemStyle :{
       							                normal : {
       							                    labelLine : {
       							                        length : 10
       							                    }
       							                }
       							            },
       							            data:[
       							                {value:a0, name:'0~5ms'},
       							                {value:a1, name:'5~10ms'},
       							                {value:a2, name:'10~15ms'},
       							                {value:a3, name:'15ms以上'}
       							            ]
       							        } */
       							     
       							    ]
       							};
       					   
       					   
       				          myChart8.hideLoading();
       				          myChart9.hideLoading();
       				          myChart10.hideLoading();
       				          myChart8.setOption(option8);
       				          myChart9.setOption(option9);
       				          myChart10.setOption(option10);
       			

       				}else{
       					alert("Ping失败次数查询失败！");
       				}

       			},
       			fail : function() {
       				alert("Ping失败次数查询失败！");
       			}
       		});
               
        	   
           }
           
           else if(logtype=="CellChange"){

               $.ajax({
          			type : "POST",
          			async : false,
          			url : "${pageContext.request.contextPath}/logtopic/getcellchangelog",
          			data : { 
          				case_name : casename
          			},
                       success : function(data) {
                    	 
          	           var a=0,a1=0,a2=0,a3=0;
                       var num_data=[];
                       var title2;
                       var time=0;
                       var fail_x=[];
                       var fail_y1=[];
                       var fail_y2=[];
                       var fail_y3=[];
                       var fail_y4=[];
          				if(data != 'null'){
          					var a="<div class=\"panel panel-info\" id=\""+logtype+"\" style=\"width: 100%;\"><div class=\"panel-heading\">"+
            				"<span class=\"glyphicon glyphicon-home\" aria-hidden=\"true\"></span>&nbsp;小区切换：("+casename+")"+
            				"</div>"+
            				"<div id=\"mytabtitle\" class=\"panel-footer\" style=\" width: 100%; height: 320px\">"+
            					"<div id=\"mytab"+casename+"\" style=\"width: 100%; height: 150px\">"+
            					"</div>"+
            					"<div id=\"mydelay"+casename+"\" style=\"width: 100%; height: 150px\">"+
            					"</div>"+
            				"</div>"+
            			    "</div>";
            			    var $tr=$(a);
            	              $("#"+casename+"_"+logtype).attr("onclick","closepicture(\""+casename+"\",\""+logtype+"\")");
            	 			  $("#result_list").append($tr);
            	 			 var myChart2= ec.init(document.getElementById('mytab'+casename)); 
            	 	           var myChart3 = ec.init(document.getElementById('mydelay'+casename)); 
            	 	        	myChart2.showLoading({
            	 	          	  text:'....',
            	 	          	  effect:'bubble',
            	 	          	    textStyle : {
            	 	          	        fontSize : 20
            	 	          	    }
            	 	          	});
            	 	           	myChart3.showLoading({
            	 	          	  text:'....',
            	 	          	  effect:'bubble',
            	 	          	    textStyle : {
            	 	          	        fontSize : 20
            	 	          	    }
            	 	          	});
            	 	           
          					var cellchange = $.parseJSON(data);
          	
          	          	     for(var i=0;i<cellchange.length;i++){
          	          	    	
          	          	    	 while(cellchange[i].x_data>time){
          	          	    		 num_data.push([time,0,15]);
          	          	    		
          	          	    		 time++;
          	          	    	 }
          	          	    	 if(cellchange[i].y1_data==0){
          	          	    		num_data.push(cellchange[i].x_data,0,15); 
          	          	    		 
          	          	    		 }
          	          	    	 else{
          	          	    	 num_data.push([cellchange[i].x_data,cellchange[i].y1_data,cellchange[i].y1_data*30]);
          	          	    	 }
          	          	       
      	          	            time++;
          	            		title2=cellchange[i].start_time;
          	            		if(cellchange[i].y1_data>0 && cellchange[i].y1_data<=10){
          	            			   a++;
          	            			}
          	            		else if(cellchange[i].y1_data>10 && cellchange[i].y1_data<=20){
       	            			   a1++;
       	            			}
          	            		else if(cellchange[i].y1_data>20 && cellchange[i].y1_data<=30){
       	            			   a2++;
       	            			}
          	            		else{
          	            			a3++;
          	            		}
          	            		
          	            		
          	            		if(cellchange[i].y2_data!=-1){
          	            			fail_x.push(cellchange[i].x_data);
          	            			fail_y1.push(cellchange[i].y2_data);
          	            			fail_y2.push(cellchange[i].y3_data);
          	            			fail_y3.push(cellchange[i].y4_data);
          	            			fail_y4.push(cellchange[i].y2_data-cellchange[i].y3_data);
          	            		}
          	                 }
          	          	     
          	          	   
          	 

          	          	 var option2 = {
          	          			title : {
   					   		        text: '小区切换重选事件',
   					   		        x:'center',
   					   		  y:'12',
   					   		   textStyle:{
  					   		        
 					   		         fontSize: 12,
 					   		         fontWeight:'lighter',
 					   		         color:'#4488BB'
 					   		        
 					   		     
 					   		        }
   					   		    },
          	      				tooltip : {
          	      							trigger : 'axis',
          	      							showDelay : 0,
          	      							axisPointer : {
          	      								show : true,
          	      								type : 'cross',
          	      								lineStyle : {
          	      									type : 'dashed',
          	      									width : 1
          	      								}
          	      							}
          	      						},
          	      					  legend: {
          	      							x : 'right',
         							    	y:'12',
         							        data:['切换/重选次数']
         							    },
          	      					
          	      						toolbox : {
          	      							show : false,
          	      							feature : {
          	      								
          	      								dataZoom : {
          	      									show : true
          	      								},
          	      								
          	      								restore : {
          	      									show : true
          	      								},
          	      								saveAsImage : {
          	      									show : true
          	      								}
          	      							}
          	      						},
          	      					grid:{
                           		    	x:30,
                           		    	y:30,
                           		    	x2:45,
                           		    	y2:30
                           		    },
            				    		  /*  dataZoom : {
            				  		    	fillerColor:'#00EEEE',
            				  		        show : true,
            				  		        realtime: true,
            				  		        height:10,
            				  		        start : 30,
            				  		        end : 70
            				  		    }, */
          	      						xAxis : [ {
          	      							 type : 'value',
          	      							 name:'时间',
          	      						 axisLabel:{
                                             show:false
                                           },
          	      							 boundaryGap:[0,0.3],
          	      							scale : true
          	      						} ],
          	      						yAxis : [ {
          	      							type : 'value',
          	      							 name:'                  次数',
          	      						 splitNumber:3,
          	      							scale : true
          	      						} ],
          	      						series : [ {
          	      							name : '切换/重选次数',
          	      							type : 'scatter',
          	      						 itemStyle:{
                                             normal: {
                                
                                             color:"#4488BB"
                                    
                                           }},
          	      							symbolSize : function(value) {
          	      								return Math.round(value[2] / 5);
          	      							},
          	      							data : num_data,
          	      						} ,
          	      						 /* {
          	             		            name:'每秒切换次数统计',
          	             		            type:'pie',
          	             		            tooltip : {
          	             		                trigger: 'item',
          	             		                formatter: '{a} <br/>{b} : {c} ({d}%)'
          	             		            },
          	             		            center: [1100,150],
          	             		            radius : [0, 30],
          	             		            itemStyle :{
          	             		                normal : {
          	             		                    labelLine : {
          	             		                        length : 20
          	             		                    }
          	             		                }
          	             		            },
          	             		            data:[
          	             		                {value:a, name:'0~10次'},
          	             		                {value:a1, name:'10~20次'},
          	             		                {value:a2, name:'20~30次'},
          	             		                {value:a3, name:'30次以上'}
          	             		            ]
          	             		        } */
          	             		     ]
          	      					};
          	           myChart2.hideLoading(); 
          	           myChart2.setOption(option2);
          	           if(fail_x.length==0){
    	          	    	 $("#mydelay"+casename).remove();
    	          	    	 $("#mytabtitle").css("height","160px");
    	          	    	 alert("无失败重选事件");
    	          	     }
          	           else{
          	           var option3 = {
          	        		 title : {
					   		        text: '小区切换失败时延',
					   		        x:'center',
					   		        y:'12',
					   		     textStyle:{
	   					   		        
   					   		         fontSize: 12,
   					   		         fontWeight:'lighter',
   					   		         color:'#4488BB'
   					   		        
   					   		     
   					   		        }
					   		    },
					   		    
					   		
          	          		    tooltip : {
          	          		        trigger: 'axis',
          	          		        formatter: function (params){
          	          		            return params[0].name + ' : '
          	          		                   + (params[2].value - params[1].value > 0 ? '+' : '-') 
          	          		                   + params[0].value + '<br/>'
          	          		                   + params[2].seriesName + ' : ' + params[2].value + '<br/>'
          	          		                   + params[3].seriesName + ' : ' + params[3].value + '<br/>'
          	          		                
          	          		        }
          	          		    },
          	          		    toolbox: {
          	          		    show : false,
        							feature : {
        								
        								dataZoom : {
        									show : true
        								},
        								
        								restore : {
        									show : true
        								},
        								saveAsImage : {
        									show : true
        								}
        							}
          	          		    },
          	          		grid:{
                   		    	x:30,
                   		    	y:50,
                   		    	x2:45,
                   		    	y2:30
                   		    },
    				    		   /* dataZoom : {
    				  		    	fillerColor:'#00EEEE',
    				  		        show : true,
    				  		        realtime: true,
    				  		        height:10,
    				  		        start : 30,
    				  		        end : 70
    				  		    }, */
          	          		    legend: {
          	          		    x : 'right',
          	          		        data:['最大值', '最小值','平均值','差值'],
          	          		        selectedMode:true
          	          		    },
          	          			y:'12',
          	          		    xAxis : [
          	          		        {
          	          		            type : 'category',
          	          		            name:'时间',
          	          		        axisLabel:{
          	          	            show:false
          	          	          },
          	          		            data : fail_x
          	          		        }
          	          		    ],
          	          		    yAxis : [
          	               		        {
          	               		            type : 'value',
          	               		            name:'                  延时 (s)',
          	               		            scale:true,
          	               		             splitNumber:3, 
          	               		            axisLabel : {
          	               		                formatter: '{value}'
          	               		            }
          	               		        }
          	               		    ],
          	          		    series : [
          	          		        {
          	          		            name:'最大值',
          	          		            type:'line',
          	          		            data:fail_y1
          	          		        },
          	          		        {
          	          		            name:'平均值',
          	          		            type:'line',
          	          		            itemStyle:{
          	          		                normal:{
          	          		                  lineStyle: {
          	          		                    width:1,
          	          		                    type:'dashed'
          	          		                  }
          	          		                }
          	          		            },
          	          		        
          	          		            data:fail_y3
          	          		        },
          	          		        {
          	          		            name:'最小值',
          	          		            type:'line',
          	          		            symbol:'none',
          	          		          
          	          		            data:fail_y2
          	          		        },
          	          		        {
          	          		            name:'最小值2',
          	          		            type:'bar',
          	          		            stack: '1',
          	          		            barWidth: 6,
          	          		            itemStyle:{
          	          		                normal:{
          	          		                    color:'rgba(0,0,0,0)'
          	          		                },
          	          		                emphasis:{
          	          		                    color:'rgba(0,0,0,0)'
          	          		                }
          	          		            },
          	          		            data:fail_y2
          	          		        },
          	          		        {
          	          		            name:'差值',
          	          		            type:'bar',
          	          		            stack: '1',
          	          		            data:fail_y4
          	          		        }
          	          		    ]
          	          		};
          					   


          	         
          	          myChart3.hideLoading();
          	          myChart3.setOption(option3);
          			
          	           }
          				}else{
          					alert("小区切换次数为零，无法分析");
          				}

          			},
          			fail : function() {
          				alert("小区切换重选查询失败！");
          			}
          		});  
                   
           }
           else if(logtype=="WeiXinText" || logtype=="WeiXinImage" || logtype=="WeiXinVideo" || logtype=="WeiXinVoice"){
        	   var type="";
        	   var title="";
        	   var table="";
        	   if(logtype=="WeiXinText")
        		   {
        		    type="WeiXinTextLog.csv";
        		    title="WeChat";
        		    table="myweixintext_";
        		   }
        	   else if(logtype=="WeiXinImage"){
        		   type="WeiXinImageLog.csv";
        		   title="微信图片";
       		      table="myweixinimage_";
        	   }
        	   else if(logtype=="WeiXinVideo"){
        		   type="WeiXinVideoLog.csv";
        		   title="微信视频";
       		      table="myweixinvideo_";
        	   }
        	   else if(logtype=="WeiXinVoice"){
        		   type="WeiXinVoiceLog.csv";
        		   title="微信语音";
       		      table="myweixinvoice_";
        	   }
        	   $.ajax({
       			type : "POST",
       			async : false,
       			url : "${pageContext.request.contextPath}/logtopic/getweixinlog",
       			data : { 
       				case_name : casename,
       				type:  type
       			},
                   success : function(data) {
                   	//alert(data);
                   	var x_data=[];
                   	var y_data=[];
                   	var y1_data=[];
                   	var y2_data=[];
                   	var y3_data=[];
                   	var x3_data=[];
                   	var start_time;
                       var a0=0,a1=0,a2=0,a3=0;
       				if(data != 'null'){
       				 var a="<div class=\"panel panel-info\" id=\""+logtype+"\" style=\"width: 100%;\"><div class=\"panel-heading\">"+
       				"<span class=\"glyphicon glyphicon-home\" aria-hidden=\"true\"></span>&nbsp;" + title + "：("+casename+")"+
       				"</div>"+
       				"<div class=\"panel-footer\" style=\" width: 100%; height: 470px\">"+
       					/* "<div id=\""+table+"fail"+casename+"\" style=\"width: 100%; height: 150px\">"+
       					"</div>"+ */
       					"<div id=\""+table+"sucess"+casename+"\" style=\"width: 100%; height: 150px\">"+
       					"</div>"+
       					"<div id=\""+table+"delay"+casename+"\" style=\"width: 100%; height: 150px\">"+
       					"</div>"+
       				"</div>"+
       			    "</div>";
       	              var $tr=$(a);
       	              $("#"+casename+"_"+logtype).attr("onclick","closepicture(\""+casename+"\",\""+logtype+"\")");
       	 			  $("#result_list").append($tr);
/*        	 			  var myChart14= ec.init(document.getElementById(table+"fail"+casename));
 */       	 	          var myChart15= ec.init(document.getElementById(table+"sucess"+casename));
       	 	          var myChart16= ec.init(document.getElementById(table+"delay"+casename)); 

       	 	       /*  myChart14.showLoading({
       	 	      	  text:'....',
       	 	      	  effect:'bubble',
       	 	      	    textStyle : {
       	 	      	        fontSize : 20
       	 	      	    }
       	 	      	}); */

       	 	        myChart15.showLoading({
       	 	      	  text:'....',
       	 	      	  effect:'bubble',
       	 	      	    textStyle : {
       	 	      	        fontSize : 20
       	 	      	    }
       	 	      	});

       	 	        myChart16.showLoading({
       	 	      	  text:'....',
       	 	      	  effect:'bubble',
       	 	      	    textStyle : {
       	 	      	        fontSize : 20
       	 	      	    }
       	 	      	});
       					var weixinfail = $.parseJSON(data);
       	          	     for(var i=0;i<weixinfail.length;i++){
       	            		x_data.push(weixinfail[i].x_data);
       	            		y1_data.push(weixinfail[i].y1_data);
       	            		y2_data.push(weixinfail[i].y2_data);
       	            		start_time=weixinfail[i].start_time;
       	            		if(weixinfail[i].y3_data!=-1){
       	            			x3_data.push(weixinfail[i].x_data);
       	            		    y3_data.push(parseFloat(weixinfail[i].y3_Stringdata));	            		    
       	            		    if(weixinfail[i].y3_data>0&&weixinfail[i].y3_data<=2){
       	            		    	   a0++;
       	            		    	}
       	            		    else if(weixinfail[i].y3_data>2&&weixinfail[i].y3_data<=4){
       	            		    	   a1++;
       	            		    }
       	            		    else if(weixinfail[i].y3_data>4&&weixinfail[i].y3_data<=6){
       	            		    	   a2++;
       	            		    }
       	            		    else{
       	            		    	a3++;
       	            		    }
       	            		    
       	            		}
       	                     	}
       					   var option14 = {
       							title : {
					   		        text:title+'失败统计',
					   		        x:'center',
					   		     y:'12',
					   		     textStyle:{
	   					   		        
   					   		         fontSize: 12,
   					   		         fontWeight:'lighter',
   					   		         color:'#4488BB'
   					   		        
   					   		     
   					   		        }
					   		    },
       				    		    tooltip : {
       				    		        trigger: 'axis',
       				    		       formatter: function (params){
       				    		    	  return '时间 :'+params[0].name+ 's<br/>'+
       					                    '失败次数:'+ params[0].value+ '<br/>';
       				    		       }
       				    		    },
       				    		    legend: {
       				    		    	x : 'right',
       				    		    	y:'12',
       				    		        data:['微信失败次数统计']
       				    		    },
       				    		    toolbox: {
       				    		        show : false,
       				    		        feature : {				  
       				    		        	dataZoom : {show: true},
       				    		            magicType : {show: true, type: ['line', 'bar']},
       				    		            restore : {show: true},
       				    		            saveAsImage : {show: true}
       				    		        }
       				    		    },
       				    		 grid:{
                        		    	x:30,
                        		    	y:30,
                        		    	x2:45,
                        		    	y2:30
                        		    },
         				    		    dataZoom : {
         				  		    	fillerColor:'#00EEEE',
         				  		        show : true,
         				  		        realtime: true,
         				  		        height:10,
         				  		        start : 30,
         				  		        end : 70
         				  		    }, 
       				    		    calculable : true,
       				    		    xAxis : [
       				    		        {
       				    		        	type : 'category',
       				    		            name:'时间(s)',
       				    		            axisLabel:{
       	          	          	            show:true
       	          	          	          },
       				    		        
       				    		            data:x_data,
       				    		        }
       				    		    ],
       				    		    yAxis : [
       				    		        {
       				    		            type : 'value',
       				    		            name:'                  失败次数',
       				    		            interval:'auto',
       				    		            scale:true,
       				    		         splitNumber:3,
       				    		            axisLabel : {
       				    		                formatter: '{value} '
       				    		            }
       				    		        }
       				    		    ],
       				    		    series : [
       				    		        {
       				    		            name:'微信失败次数统计',
       				    		            type:'line',
       				    		            data:y1_data,
       				    		         itemStyle:{
                                             normal: {
                                
                                             color:"#4488BB"
                                    
                                           }},
       				    		            markPoint : {
       				    		            	
       				    		                data : [
       				    		                    {type : 'max', name: '最大值'},
       				    		                    {type : 'min', name: '最小值'}
       				    		                ]
       				    		            },
       				    		            markLine : {
       				    		                data : [
       				    		                    {type : 'average', name: '平均值'}
       				    		                ]
       				    		            }
       				    		        }
       				    		     
       				    		    ]
       				    		};
       					   
       					   
       					   option15 = {
       							title : {
					   		        text:title+'  Success Rate',
					   		        x:'center',
					   		     y:'12',
					   		     textStyle:{
	   					   		        
   					   		         fontSize: 12,
   					   		         fontWeight:'lighter',
   					   		         color:'#4488BB'
   					   		        
   					   		     
   					   		        }
					   		    },
       					   		    tooltip : {
       					   		        trigger: 'axis',
       					   		        formatter: function (params){
       					   		            return 'time :'+params[0].name+ 's<br/>'+
       					   		                    'Rate:'+ params[0].value+'%<br/>';         
       					   		        }
       					   		    },
       					   		    legend: {
       					   		  		x : 'right',
       					   		    	y:'12',
       					   		        data:['Success Rate']
       					   		    },
       					   		    toolbox: {
       					   		        show : false,
       					   		        feature : {
       					   		        	dataZoom : {show: true},
       					   		            magicType : {show: true, type: ['line', 'bar']},
       					   		            restore : {show: true},
       					   		            saveAsImage : {show: true}
       					   		        }
       					   		    },
       					   		grid:{
                       		    	x:30,
                       		    	y:30,
                       		    	x2:45,
                       		    	y2:30
                       		    },
        				    		  /*  dataZoom : {
        				  		    	fillerColor:'#00EEEE',
        				  		        show : true,
        				  		        realtime: true,
        				  		        height:10,
        				  		        start : 30,
        				  		        end : 70
        				  		    }, */
       					   		    calculable : true,
       					   		    xAxis : [
       					   		        {
       					   		            type : 'category',
       					   		            name:'time(s)',
       					   		            boundaryGap : false,
       					   		      axisLabel:{
                	          	            show:true
                	          	          },
       					   		            data : x_data,
       					   		        }
       					   		    ],
       					   		    yAxis : [
       					        		        {
       					        		            type : 'value',
       					        		            interval:'auto',
       					        		            name:'                  Success Rate(%)',
       					        		            scale:true,
       					        		         splitNumber:3,
       					        		            axisLabel : {
       					        		                formatter: '{value} '
       					        		            }
       					        		        }
       					        		    ],
       					   		    series : [
       					   		        {
       					   		            name:'Success Rate',
       					   		            type:'line',
       					   		            smooth:true,
       					   		      itemStyle:{
                                          normal: {
                             
                                          color:"#4488BB"
                                 
                                        }},
       					   		            data:y2_data,
       					   		        }
       					   		    ]
       					   		};
       					   
       					   
       					   var option16 = {
       							title : {
					   		        text:title + '  Latency',
					   		        x:'center',
					   		     y:'12',
					   		     textStyle:{
	   					   		        
   					   		         fontSize: 12,
   					   		         fontWeight:'lighter',
   					   		         color:'#4488BB'
   					   		        
   					   		     
   					   		        }
					   		    },
       							    tooltip : {
       							        trigger: 'axis',
       							       formatter: function (params){
       							    	  return 'time :'+params[0].name+ 's<br/>'+
       						               'Latency:'+ params[0].value+ 's<br/>';
       							       }
       							    },
       							    legend: {
       							    	x : 'right',
       							    	y:'12',
       							        data:['Latency']
       							    },
       							    toolbox: {
       							    	 
       							        show : false,
       							        feature : {							    
       							            dataZoom : {show: true},							         
       							            magicType : {show: true, type: ['line', 'bar']},
       							            restore : {show: true},
       							            saveAsImage : {show: true}
       							        }
       							    },
       							 grid:{
                        		    	x:30,
                        		    	y:30,
                        		    	x2:45,
                        		    	y2:30
                        		    },
         				    		   /* dataZoom : {
         				  		    	fillerColor:'#00EEEE',
         				  		        show : true,
         				  		        realtime: true,
         				  		        height:10,
         				  		        start : 30,
         				  		        end : 70
         				  		    }, */
       							    calculable : true,
       							    xAxis : [
       							        {
       							        	type : 'category',
       							            name:'time(s)',
       							            boundaryGap:[0,0.8],
       							         axisLabel:{
       	          	          	            show:true
       	          	          	          },
       							            data:x3_data,
       							        }
       							    ],
       							    yAxis : [
       							        {
       							            type : 'value',
       							            name:'                  Latency(s)',
       							            interval:'auto',
       							            scale:true,
       							         splitNumber:3,
       							            axisLabel : {
       							                formatter: '{value} '
       							            }
       							        }
       							    ],
       							    series : [
       							        {
       							            name:'Latency',
       							            type:'line',
       							            data: y3_data,
       							         itemStyle:{
                                             normal: {
                                
                                             color:"#4488BB"
                                    
                                           }},
       							            markPoint : {
       							                data : [
       							                    {type : 'max', name: '最大值'},
       							                    {type : 'min', name: '最小值'}
       							                ]
       							            },
       							            markLine : {
       							                data : [
       							                    {type : 'average', name: '平均值'}
       							                ]
       							            }
       							        },
       							        
       							     
       							    ]
       							};
       					   
       					   
/*        				          myChart14.hideLoading();
 */       				          myChart15.hideLoading();
       				          myChart16.hideLoading();
/*        				          myChart14.setOption(option14);
 */       				          myChart15.setOption(option15);
       				          myChart16.setOption(option16);
       			

       				}else{
       					alert(title+"查询失败！");
       				}

       			},
       			fail : function() {
       				alert(title+"查询失败！");
       			}
       		});
               
           }
           else if(logtype=="SMS"){
        	   $.ajax({
          			type : "POST",
          			async : false,
          			url : "${pageContext.request.contextPath}/logtopic/getPicUESmsData",
          			data : { 
          				case_name : casename
          			},
                      success : function(data) {
                      // alert(data);
          	            var a=0,a1=0,a2=0,a3=0;
                      	var x_data=[];
                       var location_id=new Map();
                       var title1;
          				if(data != 'null'){
          					 var a="<div class=\"panel panel-info\" id=\""+logtype+"\" style=\"width: 100%;\"><div class=\"panel-heading\">"+
          	  				"<span class=\"glyphicon glyphicon-home\" aria-hidden=\"true\"></span>&nbsp;短信("+casename+")"+
          	  				"</div>"+
          	  				"<div class=\"panel-footer\" style=\" width: 100%; height: 200px\">"+
          	  					"<div id=\"mysms"+casename+"\" style=\"width: 100%; height: 180px\">"+
          	  					"</div>"+
          	  				"</div>"+
          	  			    "</div>";
          	  	              var $tr=$(a);
          	  	              $("#"+casename+"_"+logtype).attr("onclick","closepicture(\""+casename+"\",\""+logtype+"\")");
          	  	              $("#result_list").append($tr);
          	  	            var myChart1= ec.init(document.getElementById('mysms'+casename));
		       	  	       	myChart1.showLoading({
		       	  	       	  text:'....',
		       	  	       	  effect:'bubble',
		       	  	       	    textStyle : {
		       	  	       	        fontSize : 20
		       	  	       	    }
		       	  	       	});
          					var picUESmsPOs = $.parseJSON(data);
          	          	     for(var i=0;i<picUESmsPOs.length;i++){
          	            		x_data.push([picUESmsPOs[i].x_data,picUESmsPOs[i].y_data]);
          	            		location_id.put(picUESmsPOs[i].x_data,picUESmsPOs[i].ue_location);
          	            		title1=picUESmsPOs[i].start_time;

          					if(picUESmsPOs[i].y_data >= 0 && picUESmsPOs[i].y_data <30){
          						a++;
          					} else if(picUESmsPOs[i].y_data >= 30 && picUESmsPOs[i].y_data <60){
          						a1++;
          					} else if(picUESmsPOs[i].y_data >= 60 && picUESmsPOs[i].y_data <90){
          						a2++;
          					} else if(picUESmsPOs[i].y_data >= 90){
          						a3++;
          					}
          	                     	}

          	      
          		var option1 = {
          				title : {
			   		        text:'信接收时间',
			   		        x:'center',
			   		     y:'12',
			   		     textStyle:{
				   		        
				   		         fontSize: 12,
				   		         fontWeight:'lighter',
				   		         color:'#4488BB'
				   		        
				   		     
				   		        }
			   		    },
                		    tooltip : {
                		        trigger: 'axis',
                		        showDelay : 1,
                		        formatter : function (params) {
                		            if (params.value.length > 1) {
                		                return params.seriesName + '位置 :'
                		                   +location_id.get(params.value[0])+ ' :<br/>'
                		                   +"时间:"
                		                   + params.value[1]+ 's ' ;
                		            }
                		            else {
                		                return params.seriesName + ' :<br/>'
                		                   + params.name + ' : '
                		                   + params.value;
                		            }
                		        },  
                		        axisPointer:{
                		            show: true,
                		            type : 'cross',
                		            lineStyle: {
                		                type : 'dashed',
                		                width : 1
                		            }
                		        }
                		    },
                		    legend: {
                		    	x : 'right',
                		    	y:'12',
                		        data:['短信分布']
                		    },
                		    toolbox: {
                		        show : false,
                		        feature : {
                		            
                		            dataZoom : {show: true},
                		      
                		            restore : {show: true},
                		            saveAsImage : {show: true}
                		        }
                		    },
                		    grid:{
                		    	x:30,
                		    	y:30,
                		    	x2:45,
                		    	y2:30
                		    },
 				    		  /*  dataZoom : {
 				  		    	fillerColor:'#00EEEE',
 				  		        show : true,
 				  		        realtime: true,
 				  		        height:10,
 				  		        start : 30,
 				  		        end : 70
 				  		    }, */
                		    xAxis : [
                		        {
                		            type : 'value',
                		            scale:true,
                		            axisLabel:{
              	          	            show:false
              	          	          },
                		            name:'UE(号)',
                		            axisLabel : {
                		                formatter: '{value}'
                		            }
                		        }
                		    ],
                		    yAxis : [
                		        {
                		            type : 'value',
                		            scale:true,
                		            name:'                  时间(s)',
                		            boundaryGap:[0,0.9],
                		            splitNumber:3,
                		            axisLabel : {
                		                formatter: '{value}'
                		            }
                		        }
                		    ],
                		    series : [
                		     
                		        {
                		            name:'短信分布',
                		            type:'scatter',
                		            data:x_data,
                		            itemStyle:{
                                        normal: {
                           
                                        color:"#4488BB"
                               
                                      }},
                		            markPoint : {
                		                data : [
                		                    {type : 'max', name: '接收短信最大值'},
                		                    {type : 'min', name: '接收短信最小值'}
                		                ]
                		            },
                		            markLine : {
                		                data : [
                		                    {type : 'average', name: '平均值'}
                		                ]
                		            }
                		        },
                		        
                		      /*   {
                		            name:'统计时间',
                		            type:'pie',
                		            tooltip : {
                		                trigger: 'item',
                		                formatter: '{a} <br/>{b} : {c} ({d}%)'
                		            },
                		            center: [400,60],
                		            radius : [0, 15],
                		            itemStyle :{
                		                normal : {
                		                    labelLine : {
                		                        length : 10
                		                    }
                		                }
                		            },
                		            data:[
                		                {value:a, name:'0~30s'},
                		                {value:a1, name:'30~60s'},
                		                {value:a2, name:'60~90s'},
                		                {value:a3, name:'90s以上'}
                		            ]
                		        }
                		         */
                		        
                		    ]
                		};
          					   


          						myChart1.hideLoading();
             						myChart1.setOption(option1); 
          			

          				}else{
          					alert("短信接收查询失败！");
          				}

          			},
          			fail : function() {
          				alert("短信接收查询失败！");
          			}
          		});  
           }
          
           
    	   
       });
	
}

function closepicture(casename,logtype){
	 $("#"+casename+"_"+logtype).attr("onclick","showonelogresult(\""+casename+"\",\""+logtype+"\")");
	 $("#"+logtype).remove();
}

function clearmypicture(){
	$("#result_list").children().remove();
}

</script>
</head>
<body>
	<div style="width: 100%; height: 750px; position: absolute;">
		<a id="showAllLog" style="display: none;"></a>
		<div id="column1" style="width: 24%; height: 100%; float: left; border-collapse: collapse;margin:5px 2px;position: relative">
	
			<div class="left_title">历史测试任务列表
			</div>
		   <div class="func" title="收起" onclick="change_img();"><span id="drop" class="glyphicon glyphicon-arrow-up" aria-hidden="true"></span></div>
	
			<div id="u4642" class="ax_动态面板" data-label="历史任务搜索下拉面板" style="width: 99%;margin: 0px auto;">
				<div id="u4642_state1" class="panel_state" data-label="展开" style="display: block; margin:2px auto">
                   
			           
			        <div id="find">
					<div id="h_num1">

						<span style="float: left; padding-top: 3px"><span class="glyphicon glyphicon-search" aria-hidden="true"></span>
							测试用例 ：</span> <select id="behaviorgroupselect" style="width: 66%; height: 25px;">
							<option value=" " selected="selected"></option>

						</select>
					</div>
					<div id="h_num2" style="margin-top: 10px">
						<span style="float: left; padding-top: 3px"><span
							class="glyphicon glyphicon-list-alt" aria-hidden="true"></span>
							起始时间 ：</span> <input id="time_start" style="width: 66%; height: 25px;"
							type="text" value=" " readonly class="form-control form_datetime" />
					</div>

					<div id="h_num3" style="margin: 10px auto">
						<span id="time_end_flag" style="float: left; padding-top: 3px"><span
							class="glyphicon glyphicon-list-alt" aria-hidden="true"></span>
							最终时间 ：</span> <input id="time_end" style="width:  66%; height: 25px;"
							type="text" value=" " readonly class="form-control form_datetime1" />
					</div>
					<div class="tabletitle" onclick="return search();" style="margin-left: 109px;">
				                        点击查询
			        </div>
					</div>
                   <!--  <div class="tabletitle">
				                                选中测试用例详情
			        </div>
			        
			        <div class="func2 " title="打开" onclick="change_img2();"><span id="drop2" class="glyphicon glyphicon-arrow-down" aria-hidden="true"></span></div>
 -->
	<!-- 				<div id="detail" style="display:none">
<table class="table table-bordered table-condensed" style="text-align:center">
  
      <tbody >
      <thead>
      
      </thead>
        <tr class="active">
          <th scope="row">1</th>
          <td>LTE小区数</td>
          <td id="lte_num">23</td>
      

        </tr>
        <tr>
          <th scope="row">2</th>
          <td>GSM小区数 </td>
          <td id="gsm_num">1</td>
      
       
        </tr>
        <tr class="success">
          <th scope="row">3</th>
          <td>TDS小区数</td>
          <td id="tds_num">12</td>
    
       
        </tr>
        <tr>
          <th scope="row">4</th>
          <td>UE数量</td>
          <td id="ue_num">11</td>
    
         
        </tr>
        <tr class="info">
          <th scope="row">5</th>
          <td>DRX开启状态</td>
          <td id="drx_status">开</td>

     
        </tr>
        <tr>
          <th scope="row">6</th>
          <td>寻呼周期</td>
          <td id="call_time">22</td>

     
        </tr>
        <tr class="warning">
          <th scope="row">7</th>
          <td>RRC定时连接器</td>
          <td id="rrc_time">33</td>
  
         
        </tr>
 
      </tbody>
    </table>
    </div> -->
		


			</div>
			<div class="left_title" style="width:100%;">
				         测试用例列表
			 </div>
				
				<div id="case_list" style="width:100%;height: 544px;border: 1px solid #DDD;border-radius: 6px;overflow-y: scroll;" >
				<table class="table table-bordered table-condensed" style="text-align:center;font-size: 11px;">
  
			      <tbody id="case_list_tobody">
			          
			 
			      </tbody>
			    </table>
							
				
				
				
				</div>
		</div>
			
		
		</div>

<%-- 		<div id="column2"
			style="width: 24%; height: 100%; float: left; border: 1px solid #DBEAF9; border-collapse: collapse;">
			<div id="u3722" class="ax_形状" style="width: 100%">
				<img id="u4638_img" class="img " style="width: 100%" src="${pageContext.request.contextPath}/img/result/u4638.png">
				<div id="u3724" class="text"  style="text-align:center ;left:27%" >
					<p>
						<span>测试结果与指标项目</span>
					</p>
				</div>
				<hr
					style="height: 2px; border: none; border-top: 2px dotted #185598; width: 100%;" />
			</div>
		</div>

		<div id="column3" style="width: 52%; height: 100%; float: left; border: 1px solid #DBEAF9; border-collapse: collapse;">
			<div class="ax_形状" style="">
				<img id="u4638_img" class="img " src="${pageContext.request.contextPath}/img/result/u4638.png" style="width: 100%">
				<div id="u3724" class="text"  style="text-align:center ;left:64%" >
					<span style="font-family: Arial Negreta, Arial; font-weight: 700; color: #FFF;">测试结果与指标纵向对比</span>
				</div>
				<hr
					style="height: 2px; border: none; border-top: 2px dotted #185598; width: 100%" />
			</div>
			<div id="result_list"></div>
		</div> --%>

     
     	<div id="column2-col" style="width: 24%; height: 100%; position: relative;float: left;margin: 5px 2px; ">
			<div class="left_title">指标项目</div>
			<div id="column2" style="width: 99%;height: 750px;border: 1px solid #DDD;border-radius: 6px;margin:4px auto;overflow-y: scroll;">
			</div>
		</div>
		<div id="column3-col" style="width: 50%; height: 100%; position: relative;float: left;margin: 5px 2px; ">
			<div class="left_title">测试结果</div>
			 <div class="func3 " title="清空" onclick="clearmypicture();"><span  class="glyphicon glyphicon-trash" aria-hidden="true"></span></div>
			<div id="result_list" style="width: 99%;height: 750px;border: 1px solid #DDD;border-radius: 6px;margin:4px auto;overflow-y: scroll;">
			
			</div>
		</div>
     
     </div>
     	
     
 
</body>
</html>