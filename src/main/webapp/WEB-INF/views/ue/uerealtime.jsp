<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/common/taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>终端实时状态</title>

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
	style="padding: 0; margin: 0; border: 0; font-family: 微软雅黑, 宋体">

	<div class="easyui-layout" data-options="region:'center',fit:true"
		style="padding: 0; margin: 0; border: 0;">

		<div data-options="region:'center',fit:true"
			style="padding-bottom: 5px; border: 0;">
			<div id="main-list-table-wrapper"
				style="width: 100%; height: 100%; over-flow: scroll;">
				<table class="easyui-datagrid" id="main-list-table"></table>
			</div>
		</div>

	</div>
</body>



<script type="text/javascript">
	function getAppBaseUrl(appRelativeUrl) {
		if (appRelativeUrl == null) {
			appRelativeUrl = "";
		}
		return __appBaseUrl + appRelativeUrl;
	}
	
	function isArray(obj) {
		return obj != null && Object.prototype.toString.apply(obj) == "[object Array]";
	}

	function requestUEGroup() {
		$.getJSON(getAppBaseUrl('/ue/real'), function(retData) {
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
			selectOnCheck : false,
			autoRowHeight : true,
			nowrap : false,
			remoteSort:false,
			onDblClickRow : function() {
			},
			idField : 'id',
			columns : [ [ {
				field : 'sysId',
				halign : 'center',
				align : 'left',
				title : '系统编号',
				sortable:true,
				width : 80,
				sorter:function(a,b){  
					a = parseInt(a);  
					b = parseInt(b);  
					return (a>b?1:-1);  					
				} 
			}, {
				field : 'tag',
				halign : 'center',
				align : 'left',
				title : '分组信息',
				sortable:true,
				width : 80
			}, {
				field : 'mode',
				halign : 'center',
				align : 'left',
				title : '网络制式',
				width : 70

			}, {
				field : 'cell',
				halign : 'center',
				align : 'left',
				title : '小区ID',
				sortable:true,
				width : 70

			}, {
				field : 'rxlevel',
				halign : 'center',
				align : 'left',
				title : '信号质量',
				width : 70

			}, {
				field : 'task',
				halign : 'center',
				align : 'left',
				title : '当前任务',
				sortable:true,
				width : 100

			}, {
				field : 'progress',
				halign : 'center',
				align : 'left',
				title : '执行进度',
				width : 70

			},

			{
				field : 'cmd',
				halign : 'center',
				align : 'left',
				title : '已发命令',
				sortable:true,
				width : 100

			}, 
			
			{
				field : 'cmdState',
				halign : 'center',
				align : 'left',
				title : '命令状态',
				sortable:true,
				width : 100

			},
			{
				field : 'status',
				halign : 'center',
				align : 'left',
				title : '当前终端状态',
				sortable:true,
				width : 80

			}, {
				field : 'online',
				halign : 'center',
				align : 'left',
				title : '当前终端是否在线',
				width : 120,
				sortable:true,
				formatter : function(value, row, index) {
					if (value == 1) {
						return "是";
					} else {
						return "否";
					}
				},
				styler: function(value,row,index){
					if (value == 1){
						return 'background-color:green;';
					}
					else
						return 'background-color:red;';
				}


			},
			{
				field : 'ipv4',
				halign : 'center',
				align : 'left',
				title : 'ipv4地址',
				sortable:true,
				width : 100
			},
			{
				field : 'ipv6',
				halign : 'center',
				align : 'left',
				title : 'ipv6地址',
				sortable:true,
				width : 120
			},
			
			
			
			] ]
		});

		requestUEGroup();
		//
		$(window).resize(function() {
			resizeGridTable();
		});
		//
		resizeGridTable();
	});

	$(function() {
		window.setInterval(requestUEGroup, 15000);
	});
</script>
</html>
