<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/common/taglibs.jsp"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<script language="javascript" type="text/javascript"
	src="${ctx}/js/jquery-1.8.0.js"></script>
<script language="javascript" type="text/javascript"
	src="${ctx}/js/jquery.form.js"></script>


<link rel="stylesheet"
	href="${ctx}/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet"
	href="${ctx}/bootstrap/css/bootstrap-theme.min.css">
<link rel="stylesheet"
	href="${ctx}/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.css"
	rel="stylesheet">
<script src="${ctx}/js/jquery.min.js"></script>
<script
	src="${ctx}/js/bootstrap/bootstrap.min.js"></script>
<script
	src="${ctx}/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.min.js"></script>
<title>参数配置</title>
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

.param_input {
	width: 450px;
}

.text_center {
	text-align: center;
	vertical-align: middle;
	font-size: 12px;
	font-weight: bolder;
}
</style>
<script type="text/javascript">
	/**
	 * 参数实体
	 **/
	function paramobj(code, value) {
		this.code = code;
		this.value = value;
	}

	var paramsize = 8;
	function creatParamList() {
		var paramList = new Array();
		var p = 0;
		for (var i = 1; i <= paramsize; i++) {
			var pcode = $("#param" + i).attr("name");
			var pvalue = $("#param" + i).val();
			if (pvalue != null && pvalue != "") {
				var paramo = new paramobj(pcode, pvalue);
				paramList[p++] = paramo;
			}
		}
		if (p == 0) {
			return null;
		}
		return JSON.stringify(paramList);
	}

	function postparam() {
		var params = creatParamList();
		if (params != null) {
			$.ajax({
						type : "POST",
						async : false,
						url : "${ctx}/webCaseTest/saveCaseParam",
						data : {
							"paramlist" : params,
						},
						success : function(data) {
							alert(data);
						},
						fail : function() {

						}
					});
		}

	}
</script>

</head>

<body>
	<div style="width: 99%; height: auto; position: absolute;">
		<div id="column1-col"
			style="width: 100%; height: 100%; position: relative; float: left; margin: 5px 2px;">
			<div class="left_title">测试参数配置</div>
			<div id="context1"
				style="width: 99%; height: auto; border: 1px solid #DDD; border-radius: 6px; margin: 4px auto; padding: 10px">
				<table class="table table-bordered">
					<tr>
						<td rowspan="2" class="text_center">微信（文本，语音，图片，视频）</td>
						<td>
							<div class="input-group param_input">
								<span class="input-group-addon">微信发送对象</span> <select
									id="param1" name="WeiXin_DestID" class="form-control"
									style="text-align: center">
									<option value="Group">群发</option>
									<option value="P2P">对发</option>
								</select>
							</div>
						</td>

					</tr>
					<tr>
						<td>
							<div class="input-group param_input">
								<span class="input-group-addon">微信图片文件夹</span> <select
									id="param7" name="WeiXin_Image_Size" class="form-control"
									style="text-align: center">
									<option value="1">1</option>
									<option value="2">2</option>
									<option value="3">3</option>
									<option value="4">4</option>
									<option value="5">5</option>
									<option value="6">6</option>
									<option value="7">7</option>
									<option value="8">8</option>
									<option value="9">9</option>
									<option value="10">10</option>
								</select>
							</div>
						</td>
					</tr>
					<tr>
						<td rowspan="4" class="text_center">FTP上传下载</td>
						<td>
							<div class="input-group param_input">
								<span class="input-group-addon">FTP服务器地址</span> <input
									id="param2" name="FTP_DestIP" type="text" class="form-control"
									placeholder="192.168.1.1">
							</div>
						</td>
					</tr>
					<tr>
						<td>
							<div class="input-group param_input">
								<span class="input-group-addon">FTP上传目标文件夹</span> <input
									id="param3" name="FTP_Upload_FilePath" type="text"
									class="form-control" placeholder="/testcase/">
							</div>
						</td>
					</tr>
					<tr>
						<td>
							<div class="input-group param_input">
								<span class="input-group-addon">FTP上传时限</span> <input
									id="param4" name="FTP_Upload_Duration" type="text"
									class="form-control" placeholder="600">
							</div>
						</td>
					</tr>
					<tr>
						<td>
							<div class="input-group param_input">
								<span class="input-group-addon">FTP下载线程</span> <input
									id="param8" name="FTP_Download_ProcessNum" type="text"
									class="form-control" placeholder="1">
							</div>
						</td>
					</tr>
					<tr>
						<td class="text_center">Web</td>
						<td>
							<div class="input-group param_input">
								<span class="input-group-addon">目标网址</span> <input id="param5"
									name="Web_Browse_DestWebSite" type="text" class="form-control"
									placeholder="www.baidu.com">
							</div>
						</td>
					</tr>
					<tr>
						<td class="text_center">Ping</td>
						<td>
							<div class="input-group param_input">
								<span class="input-group-addon">目的IP</span> <input id="param6"
									name="Ping_Send_DestIP" type="text" class="form-control"
									placeholder="www.baidu.com">
							</div>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<button type="button" class="btn btn-primary"
								style="float: right;" onclick="postparam();">保存参数</button>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</div>
</body>

<script type="text/javascript">
	function bindUserCaseParam() {

		$.ajax({
					type : "GET",
					async : false,
					url : "${ctx}/webCaseTest/queryUserParam",
					data : {

					},
					success : function(data) {

						for ( var param in data) {

							var tmp = $("[name='" + data[param].strParamId
									+ "']");

							if (tmp.length == 0) {
								tmp = $("[name='" + data[param].strParamAllName
										+ "']");
							}

							tmp.val(data[param].strValue);

						}

					},
					fail : function() {

					}
				});

	}

	$(document).ready(bindUserCaseParam);
</script>




</html>