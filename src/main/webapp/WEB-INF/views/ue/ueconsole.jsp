<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>

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
<%@ include file="/WEB-INF/common/bootstrap_css.jsp"%>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/jquery.ext.css">
<script
	src="${pageContext.request.contextPath}/resources/common/common.js"></script>
<script
	src="${pageContext.request.contextPath}/resources/common/jquery.ext.js"></script>
	
<!-- 系统参数样式开始 -->
 <style type="text/css">
		.left_title {
			width: 99%;
			height: 30px;
			background: #3FB4D7 none repeat scroll 0% 0%;
			background-image: linear-gradient(to bottom, #5BC0DE 0px, #2AABD2 100%);
			line-height: 30px;
			font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
			font-size: 14px;
			color: #FFF;
			border: 1px solid #28A4C9;
			border-radius: 6px;
			margin: 2px auto;
			text-align: center;
		}
		
		param_input {
			width: 450px;
		}
		
		.text_center {
			text-align: center;
			/* 
			vertical-align: middle; */
			font-size: 12px;
			font-weight: bolder;
			padding-top: auto;
			padding-bottom: auto;
		}
</style> 
<!-- 系统参数样式结束 -->

</head>
<body class="easyui-layout"
	style="padding: 0; margin: 0; border: 0; font-family: 微软雅黑, 宋体;">

	<div id="north-panel" data-options="region:'center'"
		style="width: 45%; vertical-align: middle; background-color: #EEEEEE;">
		<div style="margin: 10px 6px 0px 10px;">

			<input id="cmdmode" class="easyui-switchbutton" 
				checked  style="width:200px" data-options="onText:'全局模式',offText:'精准模式'"/>
				 
			<div id="ueIds" style="margin: 10px 6px 0px 10px;display:none">
				<label for="ueId">UE系统ID(以逗号隔开):</label> <input type="text"
					name="ueId" id="ueId_id" class="easyui-textbox"
					style="width: 400px" value=""></input>
			</div>

		</div>
		<div style="margin: 10px 6px 0px 10px;">
			<a id="ue-quit" href="#" class="easyui-linkbutton"
				style="width: 80px; height: 28px; font-weight: bold;"
				onclick="javascript: quit();">安全退出</a> <a id="ue-autocall" href="#"
				class="easyui-linkbutton"
				style="width: 120px; height: 28px; font-weight: bold;"
				onclick="javascript: requestUeCall();">自动获取UE手机号</a> <a
				id="ue-stopcall" href="#" class="easyui-linkbutton"
				style="width: 120px; height: 28px; font-weight: bold;"
				onclick="javascript: stopUeCall();">停止获取UE手机号</a> <a
				id="ue-storecall" href="#" class="easyui-linkbutton"
				style="width: 120px; height: 28px; font-weight: bold;"
				onclick="javascript: storeUeCall();">下发手机号</a><a id="ue-expirecall"
				href="#" class="easyui-linkbutton"
				style="width: 120px; height: 28px; font-weight: bold;"
				onclick="javascript: expireUeCall();">过期手机号</a>
		</div>
		<div style="margin: 10px 6px 0px 10px;">
			<a id="ue-restart" href="#" class="easyui-linkbutton"
				style="width: 80px; height: 28px; font-weight: bold;"
				onclick="javascript: controlUE('restart');">UE重启</a> <a
				id="ue-shutdown" href="#" class="easyui-linkbutton"
				style="width: 80px; height: 28px; font-weight: bold;"
				onclick="javascript: controlUE('shutdown');">UE关机</a> <a
				id="ue-openwifi" href="#" class="easyui-linkbutton"
				style="width: 80px; height: 28px; font-weight: bold;"
				onclick="javascript: controlUE('openwifi');">打开Wifi</a> <a
				id="ue-closewifi" href="#" class="easyui-linkbutton"
				style="width: 80px; height: 28px; font-weight: bold;"
				onclick="javascript: controlUE('closewifi');">关闭Wifi</a>
		</div>
		<div style="margin: 10px 6px 0px 10px;">
			<label for="ftp_n">ftp Ip:</label> <input type="text" name="ftp_n"
				id="ftp_id" class="easyui-textbox" style="width: 120px" value=""></input>
			<a id="agent_update" href="#" class="easyui-linkbutton"
				style="width: 120px; height: 28px; font-weight: bold;"
				onclick="javascript: updateUE('Agent');">控制模块升级</a> <a
				id="jar_update" href="#" class="easyui-linkbutton"
				style="width: 120px; height: 28px; font-weight: bold;"
				onclick="javascript: updateUE('Jar');">业务模块升级</a>
		</div>
		<div style="margin: 10px 6px 0px 10px;">
			<label for="time_sync">NTP Ip:</label> <input type="text"
				name="time_sync" id="time_sync_id" class="easyui-textbox"
				style="width: 120px" value="192.168.1.100"></input> <a
				id="time_sync_btn" href="#" class="easyui-linkbutton"
				style="width: 80px; height: 28px; font-weight: bold;"
				onclick="javascript: syncTime();">UE时间同步</a>
		</div>
		<div style="margin: 10px 6px 0px 10px;">
			<label for="delay_n">延时收集时间(s):</label> <input type="text"
				name="delay_n" id="delay_id" class="easyui-numberbox"
				style="width: 80px" value="10" data-options="min:0"></input> <label
				for="retry_n">重试收集时间(s):</label> <input type="text" name="retry_n"
				id="retry_id" class="easyui-numberbox" style="width: 80px"
				value="10" data-options="min:0"></input> <a id="log-receive"
				href="#" class="easyui-linkbutton"
				style="width: 80px; height: 28px; font-weight: bold;"
				onclick="javascript: receiveLog();">日志回收</a>
		</div>
	</div>


	<!-- 系统参数编辑区域开始 -->
	 <div id="center-panel" data-options="region:'south',title:'系统参数配置',collapsed:true" 
		style="width: 100%;height:55%; vertical-align: middle; background-color: #EEEEEE;">
				<div style="width: 50%; height: auto; position: absolute;">
						<div id="column1-col"
							style="width: 100%; height: 100%; position: relative; float: left; margin: 5px 2px;">
							<!-- <div class="left_title">系统参数配置</div> -->
							<div id="context1"
								style="width: 99%; height: auto; border: 1px solid #DDD; border-radius: 6px; margin: 4px auto; padding: 10px">
								<table class="table table-bordered"  id="table_sysParam">
										<tr>
												<td class="text_center">FTP</td>
												<td>
													<div class="input-group param_input">
														<span class="input-group-addon">FTP IP</span> <input 
															name="ftpIp" type="text" class="form-control" maxlength="15">
													</div>
												</td>
										</tr>
										<tr>
												<td class="text_center">NTP</td>
												<td>
													<div class="input-group param_input">
														<span class="input-group-addon">NTP IP</span> <input 
															name="ntpIp" type="text" class="form-control" maxlength="15">
													</div>
												</td>
										</tr>
										<tr>
												<td class="text_center">延时</td>
												<td>
													<div class="input-group param_input">
														<span class="input-group-addon">随机延时</span> <input 
															name="duration" type="text" class="form-control">
													</div>
												</td>
										</tr>
										<tr>
											<td colspan="2">
												<button type="button" class="btn btn-primary"
													style="float: right;" onclick="saveSysParam();">保存参数</button>
											</td>
										</tr>
								</table>
							</div>
						</div>
				</div>
	</div> 
	<!-- 系统参数编辑区域结束 -->
</body>

<script type="text/javascript"
	src="${pageContext.request.contextPath}/resources/common/common.js">
	
</script>

<script type="text/javascript">
	function getAppBaseUrl(appRelativeUrl) {
		if (appRelativeUrl == null) {
			appRelativeUrl = "";
		}
		return __appBaseUrl + appRelativeUrl;
	}
	
	
	function getUeIds()
	{
		var checked = $('#cmdmode').switchbutton("options").checked;
		
		if(checked==true)
			return null;
		else
			return $('#ueId_id').textbox('getValue');
		
	}

	function stopLog() {
		$.ajax({
			type : "POST",
			async : false,
			url : "${pageContext.request.contextPath}/ueMgr/stopLog",
			data : {},
			success : function(data) {
				Toast.show(data, 5000);
			},
			fail : function() {
				Toast.show("失败！", 5000);
			}
		});
	}

	function receiveLog() {

		var delay = $('#delay_id').numberbox('getValue');
		var retry = $('#retry_id').numberbox('getValue');
		var ids = getUeIds();

		$.ajax({
			type : "POST",
			async : false,
			url : "${pageContext.request.contextPath}/ueMgr/receiveLog",
			data : {
				"delay" : delay,
				"retry" : retry,
				"ids":ids
			},
			success : function(data) {
				Toast.show(data, 5000);
			},
			fail : function() {
				Toast.show("失败！", 5000);
			}
		});
	}

	function updateUE(type) {
		
		var ftp = $('#ftp_id').textbox('getValue');
		var ids = getUeIds();
		
		$.ajax({
			type : "POST",
			async : false,
			url : "${pageContext.request.contextPath}/ueMgr/ueupdate",
			data : {
				"ftp" : ftp,
				"type" : type,
				"ids":ids
			},
			success : function(data) {
				Toast.show(data, 5000);
			},
			fail : function() {
				Toast.show("失败！", 5000);
			}
		});
	}

	function requestUeCall() {
		$.ajax({
			type : "POST",
			async : false,
			url : "${pageContext.request.contextPath}/ueMgr/phonecrawl",
			success : function(data) {
				Toast.show("成功", 5000);
			},
			fail : function() {
				Toast.show("失败！", 5000);
			}
		});
	}

	function stopUeCall() {
		$.ajax({
			type : "POST",
			async : false,
			url : "${pageContext.request.contextPath}/ueMgr/phonecrawlend",
			success : function(data) {
				Toast.show("成功", 5000);
			},
			fail : function() {
				Toast.show("失败！", 5000);
			}
		});
	}

	function storeUeCall() {
		$.ajax({
			type : "POST",
			async : false,
			url : "${pageContext.request.contextPath}/ueMgr/storeCall",
			success : function(data) {
				Toast.show("成功", 5000);
			},
			fail : function() {
				Toast.show("失败！", 5000);
			}
		});
	}

	function expireUeCall() {
		$.ajax({
			type : "POST",
			async : false,
			url : "${pageContext.request.contextPath}/ueMgr/expireCall",
			success : function(data) {
				Toast.show("成功", 5000);
			},
			fail : function() {
				Toast.show("失败！", 5000);
			}
		});
	}

	function syncTime() {
		var ftp = $('#time_sync_id').textbox('getValue');
		var ids = getUeIds();
		$.ajax({
			type : "POST",
			async : false,
			url : "${pageContext.request.contextPath}/ueMgr/syncTime",
			data : {
				"ftp" : ftp,
                "ids":ids
			},
			success : function(data) {
				Toast.show(data, 5000);
			},
			fail : function() {
				Toast.show("失败！", 5000);
			}
		});
	}

	function controlUE(type) {

		var ids = getUeIds();
		$.ajax({
			type : "POST",
			async : false,
			url : "${pageContext.request.contextPath}/ueMgr/uecontrol",
			data : {

				"type" : type,
				"ids":ids
			},
			success : function(data) {
				Toast.show(data, 5000);
			},
			fail : function() {
				Toast.show("失败！", 5000);
			}
		});
	}

	function quit() {

		var ids = getUeIds();
		$.messager.confirm("提示", "你确定要UE退出吗?", function(flag) {
			if (flag) {
				$.ajax({
					type : "POST",
					async : false,
					url : "${pageContext.request.contextPath}/ueMgr/quit",
					data : {
						"ids":ids
					},
					success : function(data) {
						Toast.show(data, 5000);
					},
					fail : function() {
						Toast.show("失败！", 5000);
					}
				});
			}
		});
	}

	function saveSysParam() {
		var ftpIp = $("#table_sysParam input[name='ftpIp']").val();
		var ntpIp = $("#table_sysParam input[name='ntpIp']").val();
		var duration = $("#table_sysParam input[name='duration']").val();
		var params = {
			'ftpIp' : ftpIp,
			'ntpIp' : ntpIp,
			'duration' : duration
		};

		$.ajax({
			type : "GET",
			async : false,
			url : "${pageContext.request.contextPath}/ueMgr/saveSysParam",
			data : params,
			success : function(data) {
				$("#ftp_id").textbox('setValue', ftpIp);
				$("#time_sync_id").textbox('setValue', ntpIp);

				Toast.show("保存成功！");
				$(".toast").css("z-index", 1000);
			},
			fail : function() {
				Toast.show("保存失败！");
				$(".toast").css("z-index", 1000);
			}
		});
	}

	$(function() {

		//查出当前用户的系统参数
		$.getJSON("${pageContext.request.contextPath}/ueMgr/showSysParam",
				function(data) {
					$("#table_sysParam input[name='ftpIp']").val(data.ftpIp);
					$("#ftp_id").textbox('setValue', data.ftpIp);

					$("#table_sysParam input[name='ntpIp']").val(data.ntpIp);
					$("#time_sync_id").textbox('setValue', data.ntpIp);

					$("#table_sysParam input[name='duration']").val(
							data.duration);
				});
		
	
		$('#cmdmode').switchbutton({
				
				onChange : 	function (checked) {

					if (checked == false) {
						$('#ueIds').show();
					} else {
						$('#ueIds').hide();
					}

				}
			});
		
		
		
		
	
		});
</script>
</html>
