var mapResultUrl;
			//1--第一页4 条数
var	mapResultRenderId='mapResultList';
var	mapResultRowCount=5;
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
				' style="background: url(http://api.map.baidu.com/images/markers.png) -23px -275px no-repeat;filter:blue; width: 19px; height: 25px; cursor: pointer; float: left; *zoom: 1; overflow: hidden; margin: 2px 3px 0 5px; *margin-right: 0px; display: inline;">&nbsp;</span>'+
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
	       		renderResult+='<li'+
				' style="margin: 2px 0px; padding: 0px 5px 5px 0px; cursor: pointer; overflow: hidden; line-height: 17px;border: 2px dashed #0087F7; border-radius: 5px; background: white; " onclick="showNoExitInfo(\''+rows[i].station_no+'\',\''+rows[i].station_name+'\',\''+rows[i].longitude+'\',\''+rows[i].latitude+'\',\''+img+'\');"><span'+
				' style="background: url('+img+')  no-repeat; width: 30px; height: 26px; cursor: pointer; float: left; *zoom: 1; overflow: hidden; margin: 2px 3px 0 5px; *margin-right: 0px; display: inline;">&nbsp;</span>'+
			    ' <div style="zoom: 1; overflow: hidden; padding: 0px 5px;">'+
				' <div style="line-height: 20px; font-size: 12px;">'+
				' <span style="color: #00c;"><b>基站编号:</b>'+rows[i].station_no+
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
	       			' </div>'+
	       			' </div></li>';
	       		
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

function baiduPageExitPanel(data,img,renderId,footId){
	var renderResult='<div '+
   	' style="font-style: normal; font-variant: normal; font-weight: normal; font-stretch: normal; font-size: 12px; line-height: normal; font-family: arial, sans-serif;">'+
	'<div style="background: rgb(255, 255, 255);">'
		+'<ol style="list-style: none; padding: 0px; margin: 0px;">';
   	var rows=data;
   	$.each( rows, function(i, n){
   		renderResult+='<li'+
		' style="margin: 2px 0px; padding: 0px 5px 5px 0px; cursor: pointer; overflow: hidden; line-height: 17px;border: 2px dashed #0087F7; border-radius: 5px; background: white; " onclick="showInfo(\''+rows[i].station_no+'\',\''+rows[i].station_name+'\',\''+rows[i].longitude+'\',\''+rows[i].latitude+'\');"><span'+
		' style="background: url('+img+') -23px -275px no-repeat; width: 30px; height: 26px; cursor: pointer; float: left; *zoom: 1; overflow: hidden; margin: 2px 3px 0 5px; *margin-right: 0px; display: inline;">&nbsp;</span>'+
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


