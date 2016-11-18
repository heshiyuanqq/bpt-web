<%@page language="java" import="java.util.*" pageEncoding="UTF-8"%>
 <script type="text/javascript">
 var mapResultUrl;
	//1--第一页4 条数
var	mapResultRenderId='mapResultList';
var	mapResultRowCount=5;
var iconDatas;
$.ajax({
    type: "POST",
    url: '${ctx}/baiduMap/queryMapIcon',
    success: function(data){
   	 data=eval("("+data+")");
   	 iconDatas=data;
    },
   error:function(){
   	notify('提示','加载失败,请重试!!','danger');
         }
});
function dataTypeIcon(data){
	for(var i=0;i<iconDatas.length;i++){
		var str=iconDatas[i].excelContent;
		var c=eval("data."+str+"");
		if(c==iconDatas[i].conditionText){
			return iconDatas[i].src;
		}
	}
}
function dataTypeIconObj(data){
	for(var i=0;i<iconDatas.length;i++){
		var str=iconDatas[i].excelContent;
		var c=eval("data."+str+"");
		if(c==iconDatas[i].conditionText){
			return  new BMap.Icon(iconDatas[i].src, new BMap.Size(20,25));
		}
	}
}

function baiduPagePanel(current,url){
mapResultUrl=url;
if(current<1){
current=1;
}
$.ajax({
type: "POST",
url: mapResultUrl,
data: {
 current:current,
 rowCount:mapResultRowCount
},
success: function(data){
	 data=eval("("+data+")");
	var renderResult='<div '+
	' style="font-style: normal; font-variant: normal; font-weight: normal; font-stretch: normal; font-size: 12px; line-height: normal; font-family: arial, sans-serif;">'+
	'<div style="background: rgb(255, 255, 255);">'
		+'<ol style="list-style: none; padding: 0px; margin: 0px;">';
	var rows=data.rows;
	$.each( rows, function(i, n){
		renderResult+='<li'+
		' style="margin: 2px 0px; padding: 0px 5px 5px 0px; cursor: pointer; overflow: hidden; line-height: 17px;border: 2px dashed #0087F7; border-radius: 5px; background: white; " onclick="showInfo(\''+rows[i].station_no+'\',\''+rows[i].station_name+'\',\''+rows[i].longitude+'\',\''+rows[i].latitude+'\');"><span'+
		' style="background: url(\'';
		renderResult+=dataTypeIcon(rows[i]);
		renderResult+='\')  no-repeat;filter:blue; width: 19px; height: 25px; cursor: pointer; float: left; *zoom: 1; overflow: hidden; margin: 2px 3px 0 5px; *margin-right: 0px; display: inline;">&nbsp;</span>'+
	    ' <div style="zoom: 1; overflow: hidden; padding: 0px 5px;">'+
		' <div style="line-height: 20px; font-size: 12px;">'+
		' <span style="color: #00c;"><b>基站编号:</b>'+rows[i].station_no+
		' </span><a target="_blank"'+
			' href=""'+
			' style="margin-left: 5px; font-size: 12px; color: #3d6dcc; font-weight: normal; text-decoration: none;">详情»</a>'+
	' </div>'+
	'<div '+
		' style="padding: 2px 0; line-height: 18px; *zoom: 1; overflow: hidden;">'+
		' <b'+
			' style="float: left; font-weight: bold; *zoom: 1; overflow: hidden; padding-right: 5px; *margin-right: -3px;">'+
			' 基站名称:</b><span'+
			' style="color: #666; display: block; zoom: 1; overflow: hidden;">'+
			rows[i].station_name+'</span>'+
			' </div>'+
			' <div'+
			'	style="padding: 2px 0; line-height: 18px; *zoom: 1; overflow: hidden;">'+
			'	<b'+
			'		style="float: left; font-weight: bold; *zoom: 1; overflow: hidden; padding-right: 5px; *margin-right: -3px;">'+
			'经度:</b><span'+
			'		style="color: #666;">'+
			rows[i].longitude+'</span>'+
			'  <b style="padding-left: 10px"'+
			' 		>纬度:</b><span'+
			' 		style="color: #666;">'+
			rows[i].latitude+' </span>'+
			' </div>'+
			' </div></li>';
	});
	//加入分页
	var pageSize=parseInt(((data.total-1)/mapResultRowCount))+1;
	renderResult+='</ol>'+
	'</div>'+
	'<div '+
	'	style="white-space: nowrap; text-align: right; margin-top: 5px; padding: 2px; overflow: hidden; zoom: 1; background: rgb(229, 236, 249);">'+
	'	<div style="float: left; margin-right: 5px;">'+
	'		<p style="margin: 0; padding: 0; white-space: nowrap">';
	if(pageSize==1){
		//只有一页
		renderResult+='	<span style="margin-right: 3px">'+1+'</span>';
	}else {
		renderResult+='	<sapn><a style="color: #7777cc; margin-right: 3px" href="javascript:void(0)" onclick="baiduPagePanel(1,\''+mapResultUrl+'\');">首页</a></span>';
		
		if(current!=1){
			renderResult+='<sapn><a style="color: #7777cc; margin-right: 3px" href="javascript:void(0)" onclick="baiduPagePanel('+(current-1)+',\''+mapResultUrl+'\');">上一页</a></span>';
		}
		renderResult+='<span style="margin-right: 3px">'+current+'</span>';
		if(current!=pageSize){
			//
			renderResult+='	<sapn><a style="color: #7777cc; margin-right: 3px" href="javascript:void(0)" onclick="baiduPagePanel('+(current+1)+',\''+mapResultUrl+'\');">下一页</a></span>';
		}
		renderResult+='<span style="margin-right: 10px">当前区域一共'+data.total+'条</span>'
			+'	<span style="margin-right: 10px">总共'+data.realTotalRecord+'条</span>'
			;
	}
	
	renderResult+='    	</p>'+
	'      	</div>'+
	'	</div>'+
	'</div>';
	$('#'+mapResultRenderId).html('');
	$('#'+mapResultRenderId).append(renderResult);
},
error:function(){
swal({   
title: "加载失败",   
text: "加载数据失败",   
type: "error",
timer: 2000,   
showConfirmButton: false 
});
}
});
}

var noExitrederId='noExitMapResultList';
var noExitDomains=[];
function noExitDomain(id,equipt){
	this.id=id;
	this.equipt=equipt;
}
function baiduPageNoExitPanel(responseText,url,img){
$.ajax({
type: "POST",
url: url,
data: {
	excelId:responseText
},
success: function(data){
	  data=eval("("+data+")");
	var renderResult='<div '+
	' style="font-style: normal; font-variant: normal; font-weight: normal; font-stretch: normal; font-size: 12px; line-height: normal; font-family: arial, sans-serif;">'+
	'<div style="background: rgb(255, 255, 255);">'
		+'<ol style="list-style: none; padding: 0px; margin: 0px;">';
	var rows=data;
	$.each( rows, function(i, n){
		noExitDomains.push(new noExitDomain("noExit"+i,data[i]));
		renderResult+='<li id="noExit'+i+'"'+
		' style="margin: 2px 0px; padding: 0px 5px 5px 0px; cursor: pointer; overflow: hidden; line-height: 17px;border: 2px dashed #0087F7; border-radius: 5px; background: white; " ><span'+
		' style="background: url('+img+')  no-repeat; width: 30px; height: 26px; cursor: pointer; float: left; *zoom: 1; overflow: hidden; margin: 2px 3px 0 5px; *margin-right: 0px; display: inline;">&nbsp;</span>'+
		'<div class="pull-right noHover"  ><button class="btn btn-danger btn-icon" style="width:30px;height:30px;" title="删除该条" onclick="removerThisNoExit(\'noExit'+i+'\')" ><i class="md md-delete"></i></button></div>'+
		' <div style="zoom: 1; overflow: hidden; padding: 0px 5px;" onclick="showNoExitInfo(\'noExit'+i+'\',\''+img+'\');">'+
		' <div style="line-height: 20px; font-size: 12px;">'+
		' <span style="color: #00c;"><b>基站编号:</b>'+rows[i].station_no+
		' </span>'+
		' <span class="pull-right" style="color: #00c;"><b>运营商:</b>'+rows[i].operators+
		' </span>'+
	' </div>'+
	'<div '+
		' style="padding: 2px 0; line-height: 18px; *zoom: 1; overflow: hidden;">'+
		' <b'+
			' style="float: left; font-weight: bold; *zoom: 1; overflow: hidden; padding-right: 5px; *margin-right: -3px;">'+
			' 基站名称:</b><span'+
			' style="color: #666; display: block; zoom: 1; overflow: hidden;">'+
			rows[i].station_name+'</span>'+
			' </div>'+
			' <div'+
			'	style="padding: 2px 0; line-height: 18px; *zoom: 1; overflow: hidden;">'+
			'	<b'+
			'		style="float: left; font-weight: bold; *zoom: 1; overflow: hidden; padding-right: 5px; *margin-right: -3px;">'+
			'经度:</b><span'+
			'		style="color: #666;">'+
			rows[i].longitude+'</span>'+
			'  <b style="padding-left: 10px"'+
			' 		>纬度:</b><span'+
			' 		style="color: #666;">'+
			rows[i].latitude+' </span>'+
			'<div '+
			' style="padding: 2px 0; line-height: 18px; *zoom: 1; overflow: hidden;">'+
			' <b'+
				' style="float: left; font-weight: bold; *zoom: 1; overflow: hidden; padding-right: 5px; *margin-right: -3px;">'+
				' 基站类型:</b><span'+
				' style="color: #666; display: block; zoom: 1; overflow: hidden;">'+
				rows[i].station_type+'</span>'+
				' </div>'+
			' </div>'+
			' </div>'+
			'</li>';
		
	});
	renderResult+='</ol>'+
	'</div>'+
	'</div>';
	$('#noExitMapResultListFoot').html('一共'+rows.length+'条');
	$('#'+noExitrederId).html('');
	$('#'+noExitrederId).append(renderResult);
	 swal({   
      title: "加载成功",   
      text: "加载数据成功",   
      type: "success",
      timer: 2000,   
      showConfirmButton: false 
	 });
},
error:function(){
 swal({   
  title: "加载失败",   
  text: "加载数据失败",   
  type: "error",
  timer: 2000,   
  showConfirmButton: false 
});
}
});
}

function baiduPageCicleExitPanel(data,renderId,footId){
var renderResult='<div '+
' style="font-style: normal; font-variant: normal; font-weight: normal; font-stretch: normal; font-size: 12px; line-height: normal; font-family: arial, sans-serif;">'+
'<div style="background: rgb(255, 255, 255);">'
+'<ol style="list-style: none; padding: 0px; margin: 0px;">';
var rows=data;
$.each( rows, function(i, n){
	var equipt=rows[i].equipt;
	var dis=rows[i].dis;
renderResult+='<li'+
' style="margin: 2px 0px; padding: 0px 5px 5px 0px; cursor: pointer; overflow: hidden; line-height: 17px;border: 2px dashed #0087F7; border-radius: 5px; background: white; " onclick="showInfo(\''+equipt.station_no+'\',\''+equipt.station_name+'\',\''+equipt.longitude+'\',\''+equipt.latitude+'\');"><span'+
' style="background: url(\'';
renderResult+=dataTypeIcon(equipt);
renderResult+='\')  no-repeat; width: 30px; height: 26px; cursor: pointer; float: left; *zoom: 1; overflow: hidden; margin: 2px 3px 0 5px; *margin-right: 0px; display: inline;">&nbsp;</span>'+
' <div style="zoom: 1; overflow: hidden; padding: 0px 5px;">'+
' <div style="line-height: 20px; font-size: 12px;">'+
' <span style="color: #00c;"><b>基站编号:</b>'+equipt.station_no+
' </span>'+
'<a target="_blank"'+
	' href=""'+
	' style="margin-left: 5px; font-size: 12px; color: #3d6dcc; font-weight: normal; text-decoration: none;">详情»</a>'+
	' <span class="pull-right" style="color: #00c;"><b>距离:</b>'+(new Number(dis)).toFixed(3)+' 米'+
	' </span>'+
	' </div>'+
'<div '+
' style="padding: 2px 0; line-height: 18px; *zoom: 1; overflow: hidden;">'+
' <b'+
	' style="float: left; font-weight: bold; *zoom: 1; overflow: hidden; padding-right: 5px; *margin-right: -3px;">'+
	' 基站名称:</b><span'+
	' style="color: #666; display: block; zoom: 1; overflow: hidden;">'+
	equipt.station_name+'</span>'+
	' </div>'+
	' <div'+
	'	style="padding: 2px 0; line-height: 18px; *zoom: 1; overflow: hidden;">'+
	'	<b'+
	'		style="float: left; font-weight: bold; *zoom: 1; overflow: hidden; padding-right: 5px; *margin-right: -3px;">'+
	'经度:</b><span'+
	'		style="color: #666;">'+
	equipt.longitude+'</span>'+
	'  <b style="padding-left: 10px"'+
	' 		>纬度:</b><span'+
	' 		style="color: #666;">'+
	equipt.latitude+' </span>'+
	' </div>'+
	' </div></li>';

});
renderResult+='</ol>'+
'</div>'+
'</div>';
$('#'+footId).html('一共'+rows.length+'条');
$('#'+renderId).html('');
$('#'+renderId).append(renderResult);
}

function baiduPageExitPanel(data,renderId,footId){
	var renderResult='<div '+
	' style="font-style: normal; font-variant: normal; font-weight: normal; font-stretch: normal; font-size: 12px; line-height: normal; font-family: arial, sans-serif;">'+
	'<div style="background: rgb(255, 255, 255);">'
	+'<ol style="list-style: none; padding: 0px; margin: 0px;">';
	var rows=data;
	$.each( rows, function(i, n){
	renderResult+='<li'+
	' style="margin: 2px 0px; padding: 0px 5px 5px 0px; cursor: pointer; overflow: hidden; line-height: 17px;border: 2px dashed #0087F7; border-radius: 5px; background: white; " onclick="showInfo(\''+rows[i].station_no+'\',\''+rows[i].station_name+'\',\''+rows[i].longitude+'\',\''+rows[i].latitude+'\');"><span'+
	' style="background: url(\'';
	renderResult+=dataTypeIcon(rows[i]);
	renderResult+='\')  no-repeat; width: 30px; height: 26px; cursor: pointer; float: left; *zoom: 1; overflow: hidden; margin: 2px 3px 0 5px; *margin-right: 0px; display: inline;">&nbsp;</span>'+
	' <div style="zoom: 1; overflow: hidden; padding: 0px 5px;">'+
	' <div style="line-height: 20px; font-size: 12px;">'+
	' <span style="color: #00c;"><b>基站编号:</b>'+rows[i].station_no+
	' </span><a target="_blank"'+
		' href=""'+
		' style="margin-left: 5px; font-size: 12px; color: #3d6dcc; font-weight: normal; text-decoration: none;">详情»</a>'+
	' </div>'+
	'<div '+
	' style="padding: 2px 0; line-height: 18px; *zoom: 1; overflow: hidden;">'+
	' <b'+
		' style="float: left; font-weight: bold; *zoom: 1; overflow: hidden; padding-right: 5px; *margin-right: -3px;">'+
		' 基站名称:</b><span'+
		' style="color: #666; display: block; zoom: 1; overflow: hidden;">'+
		rows[i].station_name+'</span>'+
		' </div>'+
		' <div'+
		'	style="padding: 2px 0; line-height: 18px; *zoom: 1; overflow: hidden;">'+
		'	<b'+
		'		style="float: left; font-weight: bold; *zoom: 1; overflow: hidden; padding-right: 5px; *margin-right: -3px;">'+
		'经度:</b><span'+
		'		style="color: #666;">'+
		rows[i].longitude+'</span>'+
		'  <b style="padding-left: 10px"'+
		' 		>纬度:</b><span'+
		' 		style="color: #666;">'+
		rows[i].latitude+' </span>'+
		' </div>'+
		' </div></li>';

	});
	renderResult+='</ol>'+
	'</div>'+
	'</div>';
	$('#'+footId).html('一共'+rows.length+'条');
	$('#'+renderId).html('');
	$('#'+renderId).append(renderResult);
	}
	
function baiduPageNoExitAndExitPanel(data,renderId,footId){
	var renderResult='<div '+
	' style="font-style: normal; font-variant: normal; font-weight: normal; font-stretch: normal; font-size: 12px; line-height: normal; font-family: arial, sans-serif;">'+
	'<div style="background: rgb(255, 255, 255);">'
	+'<ol style="list-style: none; padding: 0px; margin: 0px;">';
	$.each( data, function(i, n){
		var cequipt=data[i].cequipt;
		var equipt=data[i].equipt;
	renderResult+='<li'+
	' style="margin: 2px 0px; padding: 0px 5px 5px 0px; cursor: pointer; overflow: hidden; line-height: 17px;border: 2px dashed #0087F7; border-radius: 5px; background: white; " onclick="showInfo(\''+cequipt.station_no+'\',\''+cequipt.station_name+'\',\''+cequipt.longitude+'\',\''+cequipt.latitude+'\');"><span'+
	' style="background: url(\'';
	renderResult+=dataTypeIcon(cequipt);
	renderResult+='\')  no-repeat; width: 30px; height: 26px; cursor: pointer; float: left; *zoom: 1; overflow: hidden; margin: 2px 3px 0 5px; *margin-right: 0px; display: inline;">&nbsp;</span>'+
	' <div style="zoom: 1; overflow: hidden; padding: 0px 5px;">'+
	' <div style="line-height: 20px; font-size: 12px;">'+
	' <span style="color: #00c;"><b>预加基站编号:</b>'+equipt.station_no+
	' </span>'+
	' <span class="pull-right" style="color: #00c;"><b>预加运营商:</b>'+equipt.operators+
	' </span>'+
	' </div>'+
	'<div '+
	' style="padding: 2px 0; line-height: 18px; *zoom: 1; overflow: hidden;">'+
	' <b'+
		' style="float: left; font-weight: bold; *zoom: 1; overflow: hidden; padding-right: 5px; *margin-right: -3px;">'+
		' 预加基站名:</b><span'+
		' style="color: #666; display: block; zoom: 1; overflow: hidden;">'+
		equipt.station_name+'</span>'+
		' </div>'+
		'<div '+
		' style="padding: 2px 0; line-height: 18px; *zoom: 1; overflow: hidden;">'+
		' <b'+
			' style="float: left; font-weight: bold; *zoom: 1; overflow: hidden; padding-right: 5px; *margin-right: -3px;">'+
			' 预加基站类型:</b><span'+
			' style="color: #666; display: block; zoom: 1; overflow: hidden;">'+
			equipt.station_type+'</span>'+
			' </div>'+
			' <div style="line-height: 20px; font-size: 12px;">'+
			' <span style="color: #00c;"><b>勘察基站编号:</b>'+cequipt.station_no+
			' </span>'+
			' </div>'+
			'<div '+
			'<div '+
			' style="padding: 2px 0; line-height: 18px; *zoom: 1; overflow: hidden;">'+
			' <b'+
				' style="float: left; font-weight: bold; *zoom: 1; overflow: hidden; padding-right: 5px; *margin-right: -3px;">'+
				' 勘察基站名:</b><span'+
				' style="color: #666; display: block; zoom: 1; overflow: hidden;">'+
				cequipt.station_name+'</span>'+
				' </div>'+
				'<div '+
				' style="padding: 2px 0; line-height: 18px; *zoom: 1; overflow: hidden;">'+
				' <b'+
					' style="float: left; font-weight: bold; *zoom: 1; overflow: hidden; padding-right: 5px; *margin-right: -3px;">'+
					' 勘察基站类型:</b><span'+
					' style="color: #666; display: block; zoom: 1; overflow: hidden;">'+
					cequipt.station_type+'</span>'+
					' </div>'+
		' <div'+
		'	style="padding: 2px 0; line-height: 18px; *zoom: 1; overflow: hidden;">'+
		'	<b'+
		'		style="float: left; font-weight: bold; *zoom: 1; overflow: hidden; padding-right: 5px; *margin-right: -3px;">'+
		'勘察经度:</b><span'+
		'		style="color: #666;">'+
		cequipt.longitude+'</span>'+
		'  <b style="padding-left: 10px"'+
		' 		>勘察纬度:</b><span'+
		' 		style="color: #666;">'+
		cequipt.latitude+' </span>'+
		' </div>'+
		' </div></li>';

	});
	renderResult+='</ol>'+
	'</div>'+
	'</div>';
	$('#'+footId).html('一共'+data.length+'条');
	$('#'+renderId).html('');
	$('#'+renderId).append(renderResult);
	}

 </script>