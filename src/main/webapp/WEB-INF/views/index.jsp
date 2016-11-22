<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/common/taglibs.jsp"%>
<%@ include file="/WEB-INF/common/easyui.jsp"%>


<link type="text/css" rel="stylesheet"
	href="${ctx}/css/myStyle.css" />

<link rel="shortcut icon"
	href="${ctx}/favicon.ico"
	type="images/x-icon">


<!DOCTYPE html>
<!--[if IE 9 ]><html class="ie9"><![endif]-->
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>外场大容量系统</title>
<link rel="shortcut icon" href="${ctx}/favicon.ico" type="images/x-icon">
<style type="text/css">
* {
	margin: 0;
	padding: 0;
	list-style: none;
}

.main ul {
	width: 80px;
	border: 0;
	overflow: visible;
}

.main ul .first {
	width: 80px;
	height: 80px;
	text-align: center;
	margin-top: -1px;
	position: relative;
}

.main ul li.home {
	margin-top: 0;
}

.main ul .first a {
	width: 80px;
	height: 70px;
	color: #212e50;
	background: #f0f5f8;;
	font-size: 12px;
	display: block;
	text-decoration: none;
	padding-top: 10px;
}

.main ul .first a:hover {
	background: #09F;
}

.main ul .first span {
	font-family: "iconfont";
	font-size: 36px;
	color: #5e8dca;
}

.first ul {
	width: 125px;
	display: none;
	position: absolute;
	top: 0;
	left: 80px;
	border: 1px solid #c9e1f9;
	background: #f0f5f8;;
}

.first ul .second {
	width: 125px;
	height: 30px;
	line-height: 30px;
	background: #f0f5f8;
	position: relative;
}

.first ul .second a {
	width: 120px;
	height: 30px;
	padding-left: 5px;
	padding-top: 0;
}

.first ul .second a:hover {
	color: #fff;
	background: #09F;
}

.second ul {
	width: 125px;
	left: 125px;
	top: -1px;
	border: 1px solid #c9e1f9;
}

.second ul .third {
	width: 125px;
	height: 30px;
	line-height: 30px;
	background: #f0f5f8;;
}

.second ul .third a {
	width: 120px;
	height: 30px;
	padding-left: 5px;
	padding-top: 0;
}

.move:hover {
	color: #fff;
	background: #09F;
}
</style>
<style type="text/css">
.panel-body .accordion-body {
	background-color: #F8F8F8;
}

.myMenuLiBtn {
	width: 170px;
	background-color: #BEBEBE;
	font-weight: bold;
}

.accordion .accordion-header-selected {
	background: #1888CC none repeat scroll 0% 0%;
}

.myMenuLiBtn:hover {
	background: #1888CC none repeat scroll 0% 0%;
}
</style>
<script type="text/javascript">
	$(function() {
		$('.main>ul>li').hover(function(e) {
			$(this).children('ul').toggle();
		});
		$('.first>ul>li').hover(function(e) {
			$(this).children('ul').toggle();
		});
	});
	/* 添加tabs */
	function addTab(obj, icon) {
		var url = $(obj).attr('url');
		var tabtitle = $.trim($(obj).text());
		if ($("#mytabs").tabs('exists', tabtitle)) {
			$("#mytabs").tabs('select', tabtitle)
		} else {
			console.log(icon);
			if (icon == undefined) {
				$("#mytabs")
						.tabs(
								'add',
								{
									title : tabtitle,
									content : '<iframe src="'
											+ url
											+ '" scrolling="auto" frameborder="0"  style="width:100%;height:100%;border:0;" ></iframe>',
									closable : true
								});
			} else {
				$("#mytabs")
						.tabs(
								'add',
								{
									title : tabtitle,
									iconCls : icon,
									content : '<iframe src="'
											+ url
											+ '" scrolling="auto" frameborder="0"  style="width:100%;height:100%;border:0;" ></iframe>',
									closable : true
								});
			}

		}

	}
	/* 存储移除的menu */
	var noteArray = new Array();
	/* 移除menu */
	function up() {
		if ($(".main>ul>li").length > 1) {
			noteArray.push($(".main>ul>li").first().clone(true));
			$(".main>ul>li").first().remove();
		}
	}
	/* 还原menu */
	function down() {
		var node = noteArray.pop();
		if (node != null) {
			node.show().prependTo(".main>ul");
		}
	}
	window.setInterval(function() {
		var realTime = new Date();
		var realYear = realTime.getFullYear();
		var realMouth = realTime.getMonth() + 1;
		var realDate = realTime.getDate();
		var realHour = realTime.getHours();
		var realMinute = realTime.getMinutes();
		var realSecond = realTime.getSeconds();
		$("#realTime").html(
				realYear + "年" + realMouth + "月" + realDate + "日" + "&nbsp;"
						+ realHour + ":" + realMinute + ":" + realSecond);
	}, 500);

	function changepwd() {
		$("#changePasswordDlg").dialog('open').dialog('setTitle', '修改密码');

	}

	function changepassword() {
		$('#changePasswordForm').form('submit', {
			url : "/changepwd",
			onSubmit : function() {
				return $(this).form('validate');
			},
			success : function(result) {

				var rel = $.parseJSON(result);

				if (rel.type == 'warn') {
					$.messager.alert("系统提示", result.errorMsg);
					return;
				} else {
					$.messager.alert("系统提示", "修改密码成功");
					$('#changePasswordDlg').dialog('close');

				}
			}
		});
	}

	function logout() {
		$.messager
				.confirm(
						"提示",
						"你确定要退出该系统吗?",
						function(flag) {
							if (flag) {
								$.get("${ctx}/logout",function(){
										$(".tabs li").each(function(index, obj) {
											//获取所有可关闭的选项卡
											var tab = $(".tabs-closable", this).text();
											$(".easyui-tabs").tabs('close', tab);
										});
										window.location.href = "${ctx}/login";
								});
							}
						});
	}
	$.extend($.fn.validatebox.defaults.rules, {
		/*必须和某个字段相等*/
		equalTo : {
			validator : function(value, param) {
				return $(param[0]).val() == value;
			},
			message : '字段不匹配'
		},
		/*远程原始密码校验*/
		checkOldPassword :{  
	        validator : function(value,param){ 
	            var sysUser = {};  
	            var flag ;  
	            sysUser.oldPassword = value;  
	             $.ajax({  
		                url : "/checkPassword",  
		                type : 'POST',                    
		                timeout : 60000,  
		                data:sysUser, 
		                dataType:"json",
		                async: false,  //禁止异步  
		                success : function(result) { 
		                	if (result.type == 'info') {
		                		 flag = true;   
		                	}else{
		                		flag=false;
		                	} 
		                }  
	            });  
	            if(flag){  
	                  $("#oldPassword").removeClass('validatebox-invalid');  
	            }  
	            return flag; 
	        },  
	        message: '原始密码输入错误！'  
	    }  
	});

	function createIframe(url) {
		return '<iframe src="'
				+ url
				+ '" scrolling="auto" frameborder="0"  style="width:100%;height:100%;border:0;" ></iframe>';
	}
</script>
</head>


<body class="easyui-layout" style="background-color: #F8F8F8;">
	<!-- LOGO -->
	<div data-options="region:'north',border:false"
		style="height: 61px; background-color: #F8F8F8;">
		<img src="${ctx}/images/cm.png"
			style="z-index: 2; padding-left: 20px; padding-top: 11px;"
			width="129px" height="40px" />
		<div
			style="text-align: left; padding-top: 15px; position: absolute; top: 0; right: 5%; z-index: 1; width: 80%; color: #a3dbfa;">
			<a href="javascript:void(0)"
				style="font-size: 28px; font-family: fangzhenglantinghei; padding-left: 20px; text-decoration: none; color: #0089c7; border-left-width: 1px; border-left-color: #BEBEBE; border-left-style: solid;">
				基站大容量性能测试系统</a>
		</div>
		<div
			style="text-align: right; padding-top: 15px; position: absolute; top: 0; z-index: 1; width: 95%; color: #a3dbfa;">
			<!-- 下拉菜单 -->
			<!-- 提供menu属性，指向下拉菜单项div的id -->
			<a href="javascript:void(0)" class="easyui-menubutton"
				data-options="menu:'#bm'" style=""> <label
				style="font-weight: bold; font-size: 14px; font-family: fangzhenglantinghei;">${user.nickname }</label>
			</a>
		</div>
	</div>
	<!-- 版权 -->
	<div data-options="region:'south'"
		style="height: 20px; background: #F8F8F8;">
		<div
			style="width: 100%; height: 100%; text-align: center; font-size: 1em; z-index: 1;">
			<table width=100% height=100%>
				<tr align="center">
					<td><font color="#212e50"
						style="font-family: fangzhenglantinghei; font-size: 12px;">&copy;2015-2016&nbsp;中国移动通信有限公司研究院&nbsp;版权所有</font>
					</td>
				</tr>
			</table>
		</div>
	</div>
	<!-- 菜单 -->
	<div
		data-options="region:'west',title:'&nbsp;菜&nbsp;&nbsp;单',iconCls:'menuPage',border:false"
		style="width: 200px; background: #f0f5f8;">
		<!-- first一级菜单,second二级菜单,third三级菜单 -->
		<div class="easyui-accordion" style="height: 100%;">
			<div title="&nbsp;UE管理" data-options="iconCls:'ueManage'"
				style="overflow: auto; padding: 10px;">
				<ul>
					<li><a href="javascript:void(0);"
						onclick="addTab(this,'ueGroupManage');" url="${ctx}/nav/ue/uemgr"
						class="easyui-linkbutton myMenuLiBtn"
						data-options="plain:true,iconCls:'ueGroupManage'">&nbsp;UE分组管理</a></li>
					<li style="margin-top: 5px;"><a href="javascript:void(0);"
						onclick="addTab(this,'ueRealTime');" url="${ctx}/nav/ue/uerealtime"
						class="easyui-linkbutton myMenuLiBtn"
						data-options="plain:true,iconCls:'ueRealTime'">&nbspUE实时状态</a></li>

					<!--<li style="margin-top: 5px;"><a href="javascript:void(0);"
						onclick="addTab(this,'ueLoc');" url="/nav/ue/ueloc"
						class="easyui-linkbutton myMenuLiBtn"
						data-options="plain:true,iconCls:'ueLoc'">&nbspUE地理实时状态</a></li>
                     -->
                     
                     
					<li style="margin-top: 5px;"><a href="javascript:void(0);"
						onclick="addTab(this,'ueConsole');" url="${ctx }/nav/ue/ueconsole"
						class="easyui-linkbutton myMenuLiBtn"
						data-options="plain:true,iconCls:'ueConsole'">&nbspUE控制台</a></li>

				</ul>
			</div>
			<div title="&nbsp;测试管理" data-options="iconCls:'testcaseManage'"
				style="overflow: auto; padding: 10px;">
				<ul>
					<li>
						<ul id="tt" class="easyui-tree">

							<li><span>测试用例</span>
								<ul>
									<li><span>寻呼测试</span></li>
									<li><span>语音测试</span></li>
									<li><span>业务保持测试</span></li>

									<li><span> <a href="javascript:void(0);"
											onclick="addTab(this,'testcaseManage');"
											url="${ctx }/nav/casetest/mixCaseTest"
											data-options="plain:true,iconCls:'testcaseManage'">&nbsp;混合业务测试</a>
									</span></li>
									<li><span>其他测试</span></li>
								</ul></li>
						</ul>
					</li>
					<li style="margin-top: 5px;"><a href="javascript:void(0);"
						onclick="addTab(this,'testcaseConfig');"
						url="${ctx }/nav/casetest/paramConfig"
						class="easyui-linkbutton myMenuLiBtn"
						data-options="plain:true,iconCls:'testcaseConfig'">&nbsp;测试参数管理</a></li>
				</ul>
			</div>
			<div title="&nbsp;统计管理" data-options="iconCls:'statisticManage'"
				style="overflow: auto; padding: 10px;">
				<ul>
					<li><a href="javascript:void(0);"
						onclick="addTab(this,'statisticResult');"
						url="${ctx }/nav/result/resultMain" class="easyui-linkbutton myMenuLiBtn"
						data-options="plain:true,iconCls:'statisticResult'">&nbsp;统计结果</a></li>

				</ul>
			</div>
		</div>

	</div>
	</div>

	<div id="changePasswordDlg" class="easyui-dialog"
		style="width: 300px; height: 180px; padding: 10px 20px" closed="true"
		buttons="#changePasswordDlg-buttons">
		<form id="changePasswordForm" method="post">
			<table cellspacing="10px;">
				原始密码：
				<input id="oldPassword"  name="oldPassword" class="easyui-validatebox"
					required="true" type="password" validType="checkOldPassword" 
					 value=""/>
				<br/>
				<br/>修改密码：
				<input id="password" name="newPassword" class="easyui-validatebox"
					required="true" type="password" value="" />
				<br />
				<br /> 确认密码：
				<input type="password" name="repassword" id="repassword"
					required="true" class="easyui-validatebox"
					validType="equalTo['#password']" invalidMessage="两次输入密码不匹配" />
			</table>
		</form>
	</div>

	<div id="changePasswordDlg-buttons">
		<a href="javascript:void(0)" class="easyui-linkbutton"
			iconCls="icon-ok" onclick="changepassword()">确定</a> <a
			href="javascript:void(0)" class="easyui-linkbutton"
			iconCls="icon-cancel"
			onclick="javascript:$('#changePasswordDlg').dialog('close')">取消</a>
	</div>

	<!-- 页面主体 -->
	<div data-options="region:'center',border:false">
		<!-- tabs -->
		<div id="mytabs" class="easyui-tabs" data-options="fit:true">
			<!-- <div data-options="closeable:'false',title:'主页',iconCls:'homePage',content:createIframe('homepage.html')"></div> -->
		</div>
	</div>
	<div id="bm">
		<div data-options="iconCls:'icon-edit'" onclick="changepwd()">修改密码</div>
		<div onclick="logout();">注销</div>
	</div>
</html>