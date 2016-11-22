<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>



<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>UE位置实时监控</title>
<base href="<%=request.getContextPath()%>/" />

<%@ include file="/WEB-INF/common/easyui.jsp"%>

<jsp:include page="/WEB-INF/common/var.jsp" flush="true" />

<script type="text/javascript"
	src="<%=request.getContextPath()%>/vendors/laytpl/laytpl.js"></script>

<link rel="stylesheet"
	href="${ctx}/resources/css/jquery.ext.css">
<script
	src="${ctx}/resources/common/common.js"></script>
<script
	src="${ctx}/resources/common/jquery.ext.js"></script>






<style type="text/css">
<!--
div.dialog-button {
	text-align: center;
}

tr td.label {
	text-align: right;
	padding: 4px 0;
	padding-right: 4px;
	width: 100px;
	vertical-align: midddle;
	height: 30px;
	line-height: 28px;
}

tr td.field {
	text-align: left;
	padding: 4px 0;
	width: 500px;
	vertical-align: midddle;
	height: 30px;
	line-height: 28px;
}

tr td.field input, tr td.field textarea {
	border: 1px solid lightgray;
	color: navy;
}

div.ellipsis {
	width: 100%;
	overflow: hidden;
	text-overflow: ellipsis;
}

div.progress {
	height: 80%;
	border: 1px solid gray;
	text-align: left;
	border-radius: 2px;
}

div.progress div.value {
	height: 100%;
	width: 50%;
	background-color: green;
}

div.progress div.fail {
	background-color: red;
}
-->
</style>
</head>
<body class="easyui-layout" style="padding: 0; margin: 0; border: 0;">
	<div id="north-panel" data-options="region:'north'"
		style="height: 40px; vertical-align: middle; background-color: #EEEEEE;">
		<table
			style="width: 99%; height: 99%; font-family: 微软雅黑, 宋体; font-size: 12px;">
			<tr>
				<td width="180" style="border-right: 1px dotted gray;"><span
					style="color: navy; font-weight: bold; font-size: 14px;">&nbsp;UE位置实时监控</span></td>
				
				<td width="440" style="padding-left: 10px; font-size: 9pt;">&nbsp;提示：点击位置红色标记可以查看实时信息&nbsp;&nbsp;&nbsp;&nbsp;<label
					style="color: navy; vertical-align: middle;"><input
						id="chkOverview" type="checkbox" />&nbsp;显示缩略图控件</label></td>
				<td style="text-align: right;">最后更新：<span id="lastUpdateTime"></span></td>
			</tr>
		</table>
	</div>
	<div data-options="region:'center',fit:true"
		style="padding-bottom: 5px;">
		<div id="theMap" style="width: 100%; height: 100%; over-flow: hidden;">
		</div>
	</div>
</body>
<script type="text/html" id="template-infoWin">
  <div>
    <table style="width:100%;">
      <thead>
        <tr height="26"><th colspan="2" style="border-bottom:1px solid #eeeeee;">Summary</th></tr>
      </thead>
      <tbody>
        <tr height="22"><td>No.</td><td>{{d.sysId}}</td></tr>
        <tr height="22"><td>Model</td><td>{{d.phoneType}}</td></tr>
        <tr height="22"><td>Task</td><td>{{d.task}}</td></tr>
        <tr height="22"><td>KPI</td><td>{{d.rate || ""}}</td></tr>
        <tr height="22"><td>Time</td><td>{{d.ts}}</td></tr>  
      </tbody>
    </table>
  </div>  
</script>

<script type="text/javascript"
	src="http://api.map.baidu.com/api?v=2.0&ak=tutEANRgPdMOKwMALNLMzuPZQH7Opz3p"></script>
<script type="text/javascript">
	function getAppBaseUrl(appRelativeUrl) {
		if (appRelativeUrl == null) {
			appRelativeUrl = "";
		}
		return __appBaseUrl + appRelativeUrl;
	}

	function getWebSocket() {
		window.WebSocket = window.WebSocket || window.MozWebSocket;
		return window.WebSocket;
	}
	var connectionTimer = null;
	var webSocket = null;
	function startWebSocket() {

		if (getWebSocket() == null) {
			alert("当前浏览器不支持 WebSocket");
			return;
		} else if (webSocket != null) {
			return;
		}
		var serverBase = getServerBase();
		var wsServerBase = null;
		if (serverBase.startsWith("https://")) {
			wsServerBase = replaceStr(serverBase, "https://", "wss://");
		} else {
			wsServerBase = replaceStr(serverBase, "http://", "ws://");
		}
		//alert(wsServerBase);
		webSocket = new WebSocket(wsServerBase
				+ getAppBaseUrl("/tools/ue/v1/loc/realtime"));

		webSocket.onopen = function(evt) {

			Toast.show("服务器连接已建立", 2000);

			clearTimeout(connectionTimer);

		};

		webSocket.onclose = function(evt) {
			webSocket = null;
			connectionTimer = setTimeout(startWebSocket, 10000);
		};

		webSocket.onerror = function(msg) {
			Toast.show("服务器的连接失败", 5000, "warn");
		};

		webSocket.onmessage = function(evt) {
			var result = JSON.decode(evt.data);
			if (result != null) {
				if (result.type == "info") {
					if (result.code == 9122) {

						//
						refreshLoctions(result.data);
					} else if (result.code == 1) {
						var request = {
							code : 2
						};
						//
						webSocket.send(JSON.encode(request));
					} else if (result.code == 2) {
						var isOn = result.data;
						(isOn ? clearSwitcher.switchOn(false) : clearSwitcher
								.switchOff(false));
						(isOn ? $id("label-clearExpiredLocInfo").css("color",
								"#000") : $id("label-clearExpiredLocInfo").css(
								"color", "gray"));
					} else {

					}
				} else {
					Toast.show(result.message, 5000, "warn");
				}
			}
		};
	}
	var infoWinTemplate = null;
	var userNameLabelStyle = {
		color : "blue",
		fontSize : "14px",
		height : "28px",
		lineHeight : "24px",
		verticalAlign : "top",
		fontFamily : "微软雅黑",
		borderRadius : "14px",
		paddingBottom : "10px",
		paddingLeft : "10px",
		paddingRight : "10px",
		borderColor : "red",
		backgroundColor : "yellow"
	};
	function isLocInfoExpired(time) {
		var now = new Date().getTime();
		return now - time > 30 * 1000;
	}

	var currentUeId = null;
	//
	function refreshLoctions(locInfoList) {
		//清除旧标记
		theMap.clearOverlays();
		//
		for (var i = 0, c = locInfoList.length; i < c; i++) {

			var locInfo = locInfoList[i];

			var ts = Date.parseAsDate(locInfo.ts);
			var isExpired = isLocInfoExpired(ts);
			//
			locInfo.ts = ts.format("HH:mm:ss");
			//
			var point = new BMap.Point(locInfo.lng, locInfo.lat);
			var marker = new BMap.Marker(point);
			theMap.addOverlay(marker);
			//
			if (isFirstTime && i == 0) {
				isFirstTime = false;
				//
				setTimeout(function() {
					theMap.panTo(point);
				}, 1000);
			}

			//handle the infowindow only show the last one
			(function() {
				
				var infoWinHtml = infoWinTemplate.render(locInfo);
				var opts = {
					enableMessage : false
				};
				var infoWindow = new BMap.InfoWindow(infoWinHtml, opts);

				marker.ueId = locInfo.ueId;
				marker._infoWindow = infoWindow;

				marker.addEventListener("click", function() {

					this.openInfoWindow(infoWindow);
					currentUeId = this.ueId;
				});

			})();

			if (currentUeId == locInfo.ueId) {
				marker.openInfoWindow(marker._infoWindow);
			}

		}
		//
		$id("lastUpdateTime").text(new Date().format("yyyy-MM-dd HH:mm:ss"));
	}

	//=========================================================
	var theMap = null;
	var overView = null;
	var overViewOpen = null;
	var isFirstTime = true;
	function initMap() {
		theMap = new BMap.Map('theMap');
		theMap.centerAndZoom(new BMap.Point(116.404, 39.915), 14);
		theMap.addControl(new BMap.MapTypeControl()); //添加地图类型控件
		theMap.setCurrentCity("北京"); // 设置地图显示的城市 此项是必须设置的
		theMap.enableScrollWheelZoom(true);
		//
		overView = new BMap.OverviewMapControl();
		overViewOpen = new BMap.OverviewMapControl({
			isOpen : true,
			anchor : BMAP_ANCHOR_BOTTOM_RIGHT
		});
	}

	function showOrHideOverview() {
		var toShow = $id("chkOverview").is(":checked");
		if (toShow) {
			theMap.addControl(overView); //添加默认缩略地图控件
			theMap.addControl(overViewOpen); //右下角，打开
		} else {
			theMap.removeControl(overView);
			theMap.removeControl(overViewOpen);
		}
	}

	//
	function resizeMap() {
		//var targetWidth = $(window).width()-2;
		//var northHeight = $('#north-panel').height();
		//var targetHeight = $(window).height() - northHeight - 2;
		//$id('log').size{width: targetWidth, height:  targetHeight});
	}
	//
	var clearSwitcher = null;
	$(function() {
		infoWinTemplate = laytpl($id("template-infoWin").html());
		//
		$(window).resize(function() {
			resizeMap();
		});
		//
		resizeMap();
		//
		initMap();
		//
		$id("chkOverview").change(showOrHideOverview);
		//
		startWebSocket();
		//
		
	});
</script>
</html>
