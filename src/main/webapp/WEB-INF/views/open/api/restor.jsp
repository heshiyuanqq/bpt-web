<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>REST API</title>
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/resources/css/jquery.ext.css" />

<script type="text/javascript"
	src="<%=request.getContextPath()%>/vendors/jquery/jquery.min.js"></script>
<script type="text/javascript"
	src="<%=request.getContextPath()%>/vendors/jquery/jquery-ui.min.js"></script>
<script type="text/javascript"
	src="<%=request.getContextPath()%>/resources/common/common.js"></script>
<script type="text/javascript"
	src="<%=request.getContextPath()%>/resources/common/laytpl.js"></script>
<script type="text/javascript"
	src="<%=request.getContextPath()%>/vendors/layer/layer.min.js"></script>
<script type="text/javascript"
	src="<%=request.getContextPath()%>/vendors/layer/extend/layer.ext.js"></script>
<script type="text/javascript"
	src="<%=request.getContextPath()%>/resources/common/jquery.ext.js"></script>

<style type="text/css">
a.plain {
	color: blue;
	text-decoration: none;
}

table {
	width: 100%;
	border-collapse: collapse;
	border-spacing: 1;
	border: 1px solid gray;
	table-layout: fixed;
}

table tr {
	height: 30px;
}

table tr th {
	background-color: #EFEFEF;
}

table tr th, table tr td {
	text-align: left;
	vertical-align: middle;
}

table tr th.label, table tr td.label {
	padding-left: 4px;
	width: 100px;
}

table tr th.label2, table tr td.label2 {
	padding-left: 4px;
	width: 200px;
}
</style>
</head>
<body>
	<br /> REST API - 接口&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[
	<a class="plain" href="<%=request.getContextPath()%>/nav/open/api/list">
		返回列表 </a>]
	<hr />
	<table id="listTable" border="1">

	</table>


</body>
<script type="text/javascript">
	Ajax.baseUrl = "<%=request.getContextPath()%>";
	//
	function renderDetail(data){
		var tplHtml = $id("list_template").html();
		//
		var theTpl = laytpl(tplHtml);
		var htmlStr = theTpl.render(data);
		//
		$id("listTable").html(htmlStr);
	}
	
	var restorName = "<%=request.getParameter("name")%>";
	$(function() {

		var ajax = Ajax.get("/restApi/restor/" + restorName);
		ajax.done(function(result) {
			if (result.type == "info") {
				renderDetail(result.data);
			} else {
				Layer.msgWarn(result.message);
			}
		});
		ajax.go();
	});
</script>

<script type="text/html" id="list_template">
    	<tr><td class="label">名称</td><td>{{d.name}}</td></tr>
    	<tr><td class="label">类别</td><td>{{d.category}}</td></tr>
    	<tr><td class="label">说明</td><td>{{d.desc || ""}}</td></tr>
    	<tr><td class="label">映射路径</td><td>{{d.mappingPath}}</td></tr>
    	<tr><td class="label">GET组</td>
    		<td>
    			{{# var list = d.getMethods; }}
    			{{# for(var i = 0, len = list.length; i < len; i++){ }}
				{{# if(i>0){ }} <br/> {{# } }}
				<table border="1" style="border-color:#AAAAAA;">
    				<thead><th class="label">{{ i+1 }}</th><th>{{list[i].desc}}</th></thead>
			    	<tr><td class="label">{{list[i].httpMethod}}</td><td>{{list[i].mappingPatterns}}</td></tr>
			    	<tr><td class="label">参数</td>
						<td>
						{{# var params = list[i].params, len2 = params.length}}
						{{# if(len2 >0){ }}
							<table border="1" style="border-color:#DDDDDD;">
							<thead><th class="label2">名称</th><th>类型</th><th>说明</th></thead>
							{{# for(var i2 = 0; i2 < len2; i2++){ }}
							<tr><td class="label2">{{params[i2].name}}</td><td>{{params[i2].type}}</td><td>{{params[i2].desc || ""}}</td></tr>
							{{# } }}
							</table>
						{{# } }}
						</td>
					</tr>
			    	<tr><td class="label">返回(data)</td><td>{{list[i].return.type}}<span style="width:100px;">&nbsp;</span>{{ list[i].return.genericTypes != null ? "&lt;" + list[i].return.genericTypes.join(" , ") +"&gt;" : "" }}<span style="width:100px;">&nbsp;</span>{{list[i].return.desc || ""}}</td></tr>
				</table>					
				{{# } }}				
    		</td>
    	</tr>
		<tr><td class="label">POST组</td>
    		<td>
    			{{# var list = d.postMethods; }}
    			{{# for(var i = 0, len = list.length; i < len; i++){ }}
				{{# if(i>0){ }} <br/> {{# } }}
				<table border="1" style="border-color:#AAAAAA;">
    				<thead><th class="label">{{ i+1 }}</th><th>{{list[i].desc}}</th></thead>
			    	<tr><td class="label">{{list[i].httpMethod}}</td><td>{{list[i].mappingPatterns}}</td></tr>
			    	<tr><td class="label">参数</td>
						<td>
						{{# var params = list[i].params, len2 = params.length; }}
						{{# if(len2 >0){ }}
							<table border="1" style="border-color:#DDDDDD;">
							<thead><th class="label2">名称</th><th>类型</th><th>说明</th></thead>
							{{# for(var i2 = 0; i2 < len2; i2++){ }}
							<tr><td class="label2">{{params[i2].name}}</td><td>{{params[i2].type}}<span style="width:100px;">&nbsp;</span>{{ params[i2].genericTypes != null ? "&lt;" + params[i2].genericTypes.join(" , ") +"&gt;" : "" }}</td><td>{{params[i2].desc || ""}}</td></tr>
							{{# } }}
							</table>
						{{# } }}
						</td>
					</tr>
			    	<tr><td class="label">返回(data)</td><td>{{list[i].return.type}}<span style="width:100px;">&nbsp;</span>{{ list[i].return.genericTypes != null ? "&lt;" + list[i].return.genericTypes.join(" , ") +"&gt;" : "" }}<span style="width:100px;">&nbsp;</span>{{list[i].return.desc || ""}}</td></tr>
				</table>					
				{{# } }}				
    		</td>
    	</tr>
</script>

</html>
