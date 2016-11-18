/*
*作者:范晓文
*模块：测试任务管理eNB前端JS
*日期:20150907
*/
var selectedatt=new Array();//全局变量。0代表gsm或者tds，1代表lte.一共7个
selectedatt=[0,0,0,0,0,0];
//测试任务管理为每一个小区设置可选的enbconfig配置选项
function selectenb(enbid,ul){
  $.ajax({
			type : "POST",
			async : false,
			url : "../enbconfig/getenbconfig",
			data : { 
				
			},

			success : function(data) {
				if(data=="none")
					{
					  alert("请首先配置eNB参数");
					  return false;
					}
				else
				{
					var enb = $.parseJSON(data);
				
					
					for(var i=0;i<enb.length;i++){
						var $li=$("<li><a onclick='return getenbconfig(\""+enb[i].enbname +"\",\""+enbid+"\");'>"+enb[i].enbname+"</a></li>");
					    $("#"+ul).append($li);
					}
				}

			},
			fail : function() {
				alert("失败！");
			}
		});
}

//现实选择的enb配置文件
function getenbconfig(configname,enbid){
	 
	  document.getElementById(enbid).value=configname;
  }
 
//保存为当前case的各个小区配置的enb配置文件
function saveenbconfig(num){
	  var ul="ul"+num;
	  var penbid="penb"+num;
	  var enbid="enb"+num;
	  var enbname=document.getElementById(penbid).value;
	  $("#"+ul).children().remove();
	  document.getElementById(penbid).value="";
	  document.getElementById(enbid).value=enbname;
	  saveenbconfigok(enbid);
	  var num0=num.substring(0,1);
	  var num1=num.substring(1,2);
	 // alert(num0+"............."+num1+"........"+selectedatt[0]);
	  if(selectedatt[num0-1]==1&&num0!=7){
		  if(num1==0){
			    num=num0+'1';
			  }else{
				 num=num0+'0'; 
			  }
		  enbid="enb"+num;
		 // alert(enbid);
		  document.getElementById(penbid).value="";
		  document.getElementById(enbid).value=enbname;
		  saveenbconfigok(enbid);
	  }
	}


function saveenbconfigok(enbid){
	  var enbconfig=document.getElementById(enbid).value;
	  var caseid=window.frames["taskFrame"].document.getElementById("casename").innerHTML;
	  $.ajax({
			type : "POST",
			async : false,
			url : "../enbconfig/saveenbconfig",
			data : { 
				caseid:caseid,
				enbid:enbid,
				enbconfig:enbconfig
				
				
			},

			success : function(data) {
				
				

			},
			fail : function() {
				alert("失败！");
			}
		});
	  
  }
  
//预览界面显示当前case的所有小区的enb配置
function showenbconfig(caseid){
	clearselectenb();
	$.ajax({
		type : "GET",
		async : false,
		url : "../enbconfig/showenbconfig",
		data : {
			caseid : Number(caseid),
		},

		success : function(data) {
			
			if(data=="FAILD")
				{
				   alert("enb初始化失败");
				   return false;
				}
			var strs= new Array(); //定义一数组
			strs=data.split("_"); //字符分割 
			var att=$.parseJSON(strs[0]);
			for(var j=0;j<att.length;j++)
				{
				 if(att[j].type=="LTE"){
					   selectedatt[0]=1;
					   var myenbname="enb"+parseInt((att[j].id+1)/2)+"_name";
					   var myenbleft="enb"+parseInt((att[j].id+1)/2)+"_left";
					   var myenbright="enb"+parseInt((att[j].id+1)/2)+"_right";
					   document.getElementById(myenbname).innerHTML=att[j].station;
					   document.getElementById(myenbleft).title=att[j].name;
					   if(document.getElementById(myenbright)!=null){
					   document.getElementById(myenbright).title=att[j].name;
					   }
					   }
				 else{
					  if((att[j].id)%2==1){
						  var myenbname="enb"+parseInt((att[j].id+1)/2)+"_name";
						  var myenbleft="enb"+parseInt((att[j].id+1)/2)+"_left";
						  document.getElementById(myenbname).innerHTML=att[j].station;
						  document.getElementById(myenbleft).title=att[j].name;
						  }
					  else{
						  var myenbright="enb"+parseInt((att[j].id+1)/2)+"_right";
						  document.getElementById(myenbright).title=att[j].name;
					  }
				 }
				}
			if(strs[1] == 'none'){
				
			}else{
				
				var enbconfig = $.parseJSON(strs[1]);
		
			    for(var i=0;i<enbconfig.length;i++){
				document.getElementById(enbconfig[i].enbid).value = enbconfig[i].enbconfig;
			
			}
			    return true;
			}
		},
		fail : function() {
			alert("enb查询数据失败！");
			return false;
		}
	});	
}

//清空所有enb配置文件的显示
function clearselectenb(){
	document.getElementById("enb10").value="";
	document.getElementById("enb11").value="";
	document.getElementById("enb20").value="";
	document.getElementById("enb21").value="";
	document.getElementById("enb30").value="";
	document.getElementById("enb31").value="";
	document.getElementById("enb40").value="";
	document.getElementById("enb41").value="";
	document.getElementById("enb50").value="";
	document.getElementById("enb51").value="";
	document.getElementById("enb60").value="";
	document.getElementById("enb61").value="";
	document.getElementById("enb70").value="";
}