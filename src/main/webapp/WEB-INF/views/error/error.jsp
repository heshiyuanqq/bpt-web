<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>



<style type="text/css">
div,p,td,span {
	font-family: Arial, Helvetica, '微软雅黑', sans-serif;
	font-size: 14px;
}

/* 细网格线Table*/
table.thin-grid-line {
	width: 600px;
	height: auto;
	border-collapse: collapse;
	table-layout: fixed;
}

table.thin-grid-line tbody tr td {
	height: 32px;
	border: 0;
	border-bottom: solid 1px #B4B4B4;
	vertical-align: middle;
	color: #000000;
	padding: 10px;
	font-size: 16px;
}

table.thin-grid-line tbody tr.title-row {
	font-weight: bold;
}

table.thin-grid-line tbody tr.title-row td {
	color: #FB6700;
	height: 40px;
	text-align: center;
	font-size: 24px;
}
</style>

</head>
<body
	style="font-family: 微软雅黑, Arial, Couriew, 宋体; font-size: 16px; margin: 0;">
	
	<div
		style="text-align: center; height: 280px; padding: 20px 0; margin: 0;">
		<center>
			<table class="thin-grid-line">
				<col width=200 />
				<col width=400 />
				<tr class="title-row">
					<td colspan="2" style="font-family: 隶书">不好意思，出错了！</td>
				</tr>
				<tr>
					<td style="text-align: right;">提示&nbsp;：</td>
					<td id="errorMsg"></td>
				</tr>
			</table>
		</center>
	</div>


</body>


<script type="text/javascript">
	var errorInfo = <%=request.getAttribute("errorInfo")%>;
	$id("errorMsg").text(errorInfo.message);
	if(errorInfo["codeName"] == "login"){
		changePageUrl("<%=request.getContextPath() %>/login", "_top");
	}
</script>
