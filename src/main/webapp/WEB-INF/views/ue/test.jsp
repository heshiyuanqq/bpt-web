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
<script type="text/javascript"
	src="<%=request.getContextPath()%>/resources/common/common.js"></script>
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/jquery.ext.js"></script>





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
				<td>&nbsp;<label id="clearExpiredLocInfo"></label><label
					id="label-clearExpiredLocInfo" style="color: gray;">&nbsp;自动清除过期位置</label></td>
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
        <tr height="26"><th colspan="2" style="border-bottom:1px solid #eeeeee;">简要信息</th></tr>
      </thead>
      <tbody>
        <tr height="22"><td>系统编号</td><td>{{d.sysId}}</td></tr>
        <tr height="22"><td>Ue型号</td><td>{{d.phoneType}}</td></tr>
        <tr height="22"><td>任务</td><td>{{d.task}}</td></tr>
        <tr height="22"><td>性能指标</td><td>{{d.rate || ""}}</td></tr>
        <tr height="22"><td>时间</td><td>{{d.ts}}</td></tr>  
      </tbody>
    </table>
  </div>  
</script>

<script type="text/javascript"
	src="http://api.map.baidu.com/api?v=2.0&ak=tutEANRgPdMOKwMALNLMzuPZQH7Opz3p"></script>
<script type="text/javascript">
	var infoWinTemplate = null;

	var currentUeId = null;
	//
	function refreshLoctions(locInfoList) {
		//清除旧标记
		theMap.clearOverlays();
		//
		for (var i = 0, c = locInfoList.length; i < c; i++) {

			var locInfo = locInfoList[i];

			var ueId = locInfo.ueId;

			var ts = Date.parseAsDate(locInfo.ts);

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

				marker.currentInfoWindow = infoWindow;
				marker.ueId = locInfo.ueId;

				marker.addEventListener("click", function() {

					this.openInfoWindow(infoWindow);
					currentUeId = this.ueId;
				});

				

			})();

			if (currentUeId == ueId) {
				marker.openInfoWindow(marker.currentInfoWindow);
			}

		}

	}

	var theMap = null;

	var isFirstTime = true;

	function initMap() {
		theMap = new BMap.Map('theMap');
		theMap.centerAndZoom(new BMap.Point(116.404, 39.915), 14);
		theMap.addControl(new BMap.MapTypeControl()); //添加地图类型控件
		theMap.setCurrentCity("北京"); // 设置地图显示的城市 此项是必须设置的
		theMap.enableScrollWheelZoom(true);
	}

	function fakeData() {
		var locInfos = [];

		var loc1 = {
			"ueId" : 1,
			"lng" : "116.357031",
			"lat" : "39.90297",
			"sysId" : 1,
			"phoneType" : "华为",
			"task" : "微信",
			"rate" : "11MB/s",
			"ts" : new Date()
		};

		var loc2 = {
			"ueId" : 2,
			"lng" : "116.358168",
			"lat" : "39.902755",
			"sysId" : 2,
			"phoneType" : "三星",
			"task" : "FTP",
			"rate" : "11MB/s",
			"ts" : new Date()
		};
		locInfos.push(loc1);
		locInfos.push(loc2);

		refreshLoctions(locInfos);
	}

	window.setInterval(fakeData, 6000);

	$(function() {

		infoWinTemplate = laytpl($id("template-infoWin").html());
		initMap();

	});
</script>
</html>
