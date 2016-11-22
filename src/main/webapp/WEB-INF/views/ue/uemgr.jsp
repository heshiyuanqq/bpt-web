<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/common/taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>终端分组管理</title>

<style type="text/css">
<!--
input, textarea {
	font-size: 12px;
	font-family: 微软雅黑, 宋体;
	border: 1px solid #95B8E7;
}

div.dialog-button {
	text-align: center;
}

select, .xbtn {
	height: 24px;
	font-size: 12px;
	font-family: 微软雅黑, 宋体;
	border: 1px solid #95B8E7;
	-moz-border-radius: 5px 5px 5px 5px;
	-webkit-border-radius: 5px 5px 5px 5px;
	border-radius: 5px 5px 5px 5px;
	min-width: 240px;
	color: navy;
}

input.textbox {
	height: 24px;
	font-size: 12px;
	font-family: 微软雅黑, 宋体;
	border: 1px solid #95B8E7;
	-moz-border-radius: 5px 5px 5px 5px;
	-webkit-border-radius: 5px 5px 5px 5px;
	border-radius: 5px 5px 5px 5px;
	color: navy;
}

select.brands {
	min-width: 100px;
}

select.serials {
	min-width: 150px;
}

select.models {
	min-width: 300px;
}

select.classes {
	min-width: 100px;
}

select.types {
	width: 500px;
}

.bold {
	font-weight: bold;
}

div.dlg-item-bar {
	padding: 10px 6px;
	vertical-align: middle;
}

.x-btn-separator {
	height: 24px;
	border-left: 1px solid #ccc;
	border-right: 1px solid #fff;
	margin: 2px 1px;
}
-->
</style>

<%@ include file="/WEB-INF/common/easyui.jsp"%>
<%@ include file="/WEB-INF/common/var.jsp"%>
</head>


<body class="easyui-layout"
	style="padding: 0; margin: 0; border: 0; font-family: 微软雅黑, 宋体"  
	onkeydown="javascript:keyPress(event);" onkeyup="javascript:keyRelease(event);">


	<div id="north-panel" data-options="region:'north'"
		style="width: 100%; height: 50px; vertical-align: middle; background-color: #EEEEEE;">
		<div style="margin: 10px 6px 0px 10px;">
			分组命名：<input id="tagName" title="输入， 然后按回车键 " class="textbox"
				style="width: 160px;" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<a id="btn-change-tag" href="#" class="easyui-linkbutton"
				style="width: 80px; height: 28px; font-weight: bold;"
				onclick="javascript: changeTag();">修改分组</a> <a id="btn-refresh-data"
				href="#" class="easyui-linkbutton"
				style="width: 80px; height: 28px; font-weight: bold;"
				onclick="javascript: refreshNewData();">刷新分组</a> <a
				id="btn-update-ue" href="#" class="easyui-linkbutton"
				style="width: 100px; height: 28px; font-weight: bold;"
				onclick="javascript: udpateUeInfo();">手动更新UE信息</a> <a
				id="btn-fly-mode" href="#" class="easyui-linkbutton"
				style="width: 80px; height: 28px; font-weight: bold;"
				onclick="javascript: flymode();">飞行模式</a>
		</div>
	</div>
	<div data-options="region:'center',fit:true"
		style="padding-bottom: 5px; border: 0;">
		<div id="main-list-table-wrapper"
			style="width: 100%; height: 100%; over-flow: scroll;">
			<table class="easyui-datagrid" id="main-list-table"></table>
		</div>
	</div>



	<div id="win" class="easyui-window" title="My Window"
		style="width: 600px; height: 430px"
		data-options="iconCls:'icon-save',modal:true,closed:true">
		<div class="easyui-layout" data-options="fit:true">
			<div data-options="region:'north',split:true" style="height: 30px;color: gray;background-color: #BEBEBE">请在中间框内输入!(格式为:Imsi,箱号,手机号  例如:460080100030306,箱a,13800000000)</div>
			<div data-options="region:'center'">
				<input id="phone_info" class="easyui-textbox" multiline="true"
					style="width: 100%; height: 100%;" >
			</div>
			<div data-options="region:'south',split:true" style="height: 35px;background-color: #BEBEBE">
				<div style="padding: 1px; text-align: right;text-align: center;">
					<a id="btn-ok" href="#" class="easyui-linkbutton"
						data-options="iconCls:'icon-ok'" onclick="javascript: submitUeInfo();" style="background-color: #BEBEBE">确定</a>
					<a id="btn-cancel"
						href="#" class="easyui-linkbutton"
						data-options="iconCls:'icon-cancel'" onclick="javascript: cancelWindow();" style="background-color: #BEBEBE">取消</a>
				</div>
			</div>

		</div>
	</div>
</body>


<script type="text/javascript"
	src="${ctx }/resources/common/util.js">
	
</script>
<script type="text/javascript"
	src="${ctx }/resources/common/json.js">
	
</script>

<script type="text/javascript">
	var KEY = { SHIFT:16};    
	var selectIndexs = {firstSelectRowIndex:0, lastSelectRowIndex:0};  
	var keyDownOrUpFlags = {isShiftDown:false}  
	var onSelectSwitch=true;//onSelect事件开关
	  
	function keyPress(event){//响应键盘按下事件  
		    var e = event || window.event;    
		    var code = e.keyCode | e.which | e.charCode; 
		    if(code==KEY.SHIFT){
			    	keyDownOrUpFlags.isShiftDown = true;  
		    }
	}  
	  
	function keyRelease(event) { //响应键盘按键放开的事件  
		    var e = event || window.event;    
		    var code = e.keyCode | e.which | e.charCode; 
		    if(code==KEY.SHIFT){
		    	keyDownOrUpFlags.isShiftDown = false;  
		    	selectIndexs.firstSelectRowIndex = 0;  
		    }
	}  
		
	


	function getAppBaseUrl(appRelativeUrl) {
		if (appRelativeUrl == null) {
			appRelativeUrl = "";
		}
		return __appBaseUrl + appRelativeUrl;
	}

	function isArray(obj) {
		return obj != null
				&& Object.prototype.toString.apply(obj) == "[object Array]";
	}

	
	
	
	
	
	//ue info window related 
	function submitUeInfo()
	{
		var phoneInfo = $('#phone_info').textbox('getValue');
		
		var postParams = {};
		postParams["info"] = phoneInfo;
	
		$.ajax({
			type : 'POST',
			contentType : "application/json",
			url : getAppBaseUrl('/ue/info/update'),
			data : JSON.encode(postParams),
			success : function(resultInfo) {
				if (resultInfo == true) {

					$('#win').window('close');
					$.messager.alert("提示", "发送成功,请刷新分组!", 'info');

				} else {
					$.messager.alert("提示", "发送失败!", 'warning');
				}
			},

			dataType : "json"
		});
		
		
	}
	
	function cancelWindow()
	{
		$('#win').window('close');
	}
	
	
	
	
	
	
	
	
	//
	
	
	
	
	
	
	
	
	
	
	
	
	
	function requestUEGroup() {
		$.getJSON(getAppBaseUrl('/ue/tag'), function(retData) {
			fillMainList(retData);
		});

	}

	//装换为DataGrid的数据格式
	function convertToDGJson(srcData) {
		var retData = {
			total : 0,
			rows : []
		};
		if (srcData != null && isArray(srcData)) {
			retData["rows"] = srcData;
			retData["total"] = retData["rows"].length;
		}
		return retData;
	}

	var lastDataList = [];
	//填充订单列表
	function fillMainList(retData, bInit) {

		mainListTable.datagrid('clearChecked');
		//		
		if (retData) {
			lastDataList = convertToDGJson(retData);
		}
		var newData = lastDataList;

		mainListTable.datagrid('loadData', newData);
		
		if (newData["total"] == 0 && bInit !== true) {
			$.messager
					.show({
						title : '提示',
						msg : '<span style="color:red;">没有</span>查到<span style="color:red;">终端</span> 。',
						timeout : 4000,
						showType : 'fade'
					});
		}
	}

	//查询订单
	function showErrorMsg(msg) {
		$.messager.alert("提示", msg["message"], 'error');
	}

	function toUpdateTag(postParams) {
		//alert(JSON.encode(postParams));
		$.ajax({
			type : 'POST',
			contentType : "application/json",
			url : getAppBaseUrl('/ue/tag/update'),
			data : JSON.encode(postParams),
			success : function(resultInfo) {
				if (resultInfo == true) {

					requestUEGroup();

					$.messager.alert("提示", "修改成功!", 'info');

				} else {
					$.messager.alert("提示", "修改失败!s", 'warning');
				}
			},
			statusCode : {
				401 : function() {
					$.messager.alert("提示", "您尚未登录，请先登录", 'warning');
				},
				404 : function() {
					$.messager.alert("提示", "页面未找到", 'warning');
				},
				500 : function() {
					$.messager.alert("提示", "服务器繁忙，请稍后再试", 'warning');
				},
				511 : function() {
					$.messager.alert("提示", "未登录，或权限不够", 'warning');
				}
			},
			dataType : "json"
		});
	}

	function getSelectedUEIds() {
		var selectedUEIds = [];
		var selectedRows = mainListTable.datagrid('getChecked');
		var selectedCount = selectedRows.length;
		for (var i = 0; i < selectedCount; i++) {
			selectedUEIds[i] = selectedRows[i].id;
		}
		return selectedUEIds;
	}

	function changeTag() {
		var selectedRows = mainListTable.datagrid('getChecked');
		var selectedCount = selectedRows.length;
		if (selectedCount < 1) {
			$.messager.alert("提示", "请选择 要更改的设备", 'warning');
			return;
		}

		var postParams = {};
		postParams["tag"] = $('#tagName').val().trim();
		postParams["ids"] = getSelectedUEIds();

		toUpdateTag(postParams);

	}

	function flymode() {
		var selectedRows = mainListTable.datagrid('getChecked');
		var selectedCount = selectedRows.length;
		if (selectedCount < 1) {
			$.messager.alert("提示", "请选择 要更改的设备", 'warning');
			return;
		}

		var postParams = {};

		postParams["ids"] = getSelectedUEIds();

		$.ajax({
			type : 'POST',
			contentType : "application/json",
			url : getAppBaseUrl('/ueMgr/flymode'),
			data : JSON.encode(postParams),
			success : function(resultInfo) {
				if (resultInfo == true) {

					$.messager.alert("提示", "发送成功!", 'info');

				} else {
					$.messager.alert("提示", "发送失败!", 'warning');
				}
			},

			dataType : "json"
		});

	}

	function udpateUeInfo() {
		$('#win').window('open');
	}

	function refreshNewData() {
		requestUEGroup();
		resizeGridTable();
	}

	//
	function resizeGridTable() {
		var targetWidth = $(window).width();

		var northHeight = $('#north-panel').height();
		var targetHeight = $(window).height() - northHeight - 2;
		mainListTable.datagrid("resize", {
			width : targetWidth,
			height : targetHeight
		});
	}
	//
	var mainListTable;
	//
	$(document).ready(function() {
		$.ajaxSetup({
			cache : false
		});

		mainListTable = $('#main-list-table');
		
		mainListTable.datagrid({
			rownumbers : true,
			selectOnCheck : true,
			autoRowHeight : true,
			nowrap : false,
			remoteSort:false,
			singleSelect  :false,
			onSelect:function(index,row){
						if(onSelectSwitch){
								  //当shift为抬起状态时，记录起始角标
						           if(index != selectIndexs.firstSelectRowIndex && !keyDownOrUpFlags.isShiftDown ){    
						            	selectIndexs.firstSelectRowIndex = index;
							        }    
									//shift为按下状态时，记录结束角标
							        if(keyDownOrUpFlags.isShiftDown ) {  
								        	mainListTable.datagrid('clearSelections');                  
								            selectIndexs.lastSelectRowIndex = index;  
								            var tempIndex = 0;  
								            if(selectIndexs.firstSelectRowIndex > selectIndexs.lastSelectRowIndex ){  
									                tempIndex = selectIndexs.firstSelectRowIndex;  
									                selectIndexs.firstSelectRowIndex = selectIndexs.lastSelectRowIndex;  
									                selectIndexs.lastSelectRowIndex = tempIndex;  
								            } 
								            onSelectSwitch=false;
								            for(var i = selectIndexs.firstSelectRowIndex ; i <= selectIndexs.lastSelectRowIndex ; i++){  
								            	
								            		mainListTable.datagrid('selectRow', i);     
								            }    
								            
								            onSelectSwitch=true;
							        }      
						}
		    },
			idField : 'id',
			columns : [ [ {
				field : 'id',
				checkbox : true,
				width : 40,
				title : '选择'
			}, {
				field : 'sysId',
				halign : 'left',
				align : 'left',
				title : '系统编号',
				width : 60
			}, {
				field : 'xppId',
				halign : 'left',
				align : 'left',
				title : 'xpp编号',
				width : 240
			}, {
				field : 'box',
				halign : 'left',
				align : 'left',
				title : '箱子编号',
				sortable : true,
				width : 70
			}, {
				field : 'phoneNumber',
				halign : 'left',
				align : 'left',
				title : '手机号',
				sortable:true,
				width : 100
			}, {
				field : 'tag',
				halign : 'left',
				align : 'left',
				title : '分组',
				width : 140

			} ] ]
		});

		requestUEGroup();
		//
		$(window).resize(function() {
			resizeGridTable();
		});
		//
		resizeGridTable();

	});
	
	//修改easyui-textbox默认样式
	$(function(){
		$("#phone_info").next("span").find("textarea").css("backgroundColor","#F8F8F8");
	});
	
</script>
</html>
