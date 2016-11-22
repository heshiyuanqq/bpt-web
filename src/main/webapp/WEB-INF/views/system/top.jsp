<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<script type="text/javascript" src="${ctx}/vendors/activemq/amq_jquery_adapter.js"></script>
<script type="text/javascript" src="${ctx}/vendors/activemq/amq.js"></script>
<script>


</script>
<header id="header">
	<ul class="header-inner">
		<li id="menu-trigger" data-trigger="#sidebar">
			<div class="line-wrap" title='菜单'>
				<div class="line top"></div>
				<div class="line center"></div>
				<div class="line bottom"></div>
			</div>
		</li>

		<li class="logo hidden-xs"><a href="${ctx}/" style="margin: -16px -20px;"> <img
				src="${ctx}/img/monkey.png" width="47" height="47"  alt="China Mobile" style="margin-top:-24px; ">
				<span style="font-size: 240%; ">2016</span>
		</a></li>
		<li class="logo hidden-xs" ><a href="${ctx}/" style="margin: -10px -20px;left:45%;position:absolute;font-size: 240%; ">
			资产管理平台
		</a></li>
		<li class="pull-right">
			<ul class="top-menu">
				<li class="dropdown"><a data-toggle="dropdown" id="personDrop"
					class="tm-person" href="javascript:void(0)">
					<img src="${ctx}${user.portraitAddress}" alt=""><span class="tmn-name">${user.userName}</span>
				</a>
					<ul class="dropdown-menu dm-icon pull-right">
						<li><a href="javascript:void(0)" data-toggle="modal"
							onclick="openProfileModel()"><i class="md md-person"></i>
								个人信息</a></li>
						<li><a href="javascript:void(0)" data-toggle="modal"
							onclick="openChangePwdModel()"><i class="md md-https"></i>修改密码</a>
						</li>
						<li><a href="javascript:void(0)" data-toggle="modal"
							onclick="openAvatarSetting()"><i class="md md-account-circle"></i>头像设置</a>
						</li>
						<li><a href="javascript:void(0)" onclick="logoutFnc()"><i
								class="md md-input"></i>退&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;出</a>
						</li>
					</ul></li>
					
				
				<li class="dropdown">
					<a id="questionNotice" title="消息" data-toggle="dropdown" style="margin-left: 10px;min-width:40px;color: white;" href="javascript:void(0)" >
						<i class="fa fa-bell-o" style="font-size: 22px;"></i>
						
					</a>
						
				</li>

				<li>
					<button class="btn-default btn-icon"
						style="border: 0px; background-color: #40E0D0;" title="锁屏"
						onclick="lockScreen();">
						<i class="md md-lock-outline"></i>
					</button>
				</li>
			</ul>
		</li>
	</ul>
	<!-- <a id="backtop" href="javascript:void" title="返回顶部"></a> -->
	
	

<!--  baidu share
	<div class="share-box">
		<div class="share-box-top">分享到</div>
		<div class="share-box-inner">
			<div id="bdshare" class="bdshare_t bds_tools_32 get-codes-bdshare">
				<a class="bds_qzone" data-cmd="qzone" href="#"></a><br> <a
					class="bds_tsina"  data-cmd="tsina" href="#"></a><br> <a
					class="bds_tqq"   data-cmd="tqq" href="#"></a><br> <a
					class="bds_renren"  data-cmd="renren" href="#"></a><br> <span
					class="bds_more"></span><br>
			</div>
			<script type="text/javascript" id="bdshare_js"
				data="type=tools&amp;uid=585159"
				src="http://bdimg.share.baidu.com/static/js/bds_s_v2.js?cdnversion="+~(-new Date()/36e5)];></script>
			<script type="text/javascript">
				var bds_config = {
					'snsKey' : {
						'tsina' : '86978135',
						'tqq' : '4343e352bd271ad96028827d38ea4d39'
					}
				};
				document.getElementById("bdshell_js").src = "http://share.baidu.com/static/js/shell_v2.js?cdnversion="
						+ new Date().getHours();
			</script>
		</div>
	</div>
	-->
	<div class="modal fade"  id="profileModel"
		data-backdrop="static" data-keyboard="false" tabindex="-1"
		role="dialog" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h4 class="modal-title">个人 信息</h4>
				</div>
				<div class="modal-body">
					<form role="form" name="proForm" id="proForm"
						class="form-horizontal" method="post">
						<div class="input-group m-b-20 ">
							<span class="input-group-addon"><i class="md md-person"
								title="账号"></i></span>
							<div class="fg-line ">
								<input disabled="disabled" type="text" name="proUsername"
									class="form-control" value="${user.account}" placeholder="账号">
							</div>
						</div>
						<div class="input-group m-b-20">
							<span class="input-group-addon"><i class="md md-event"
								title="注册时间"></i></span>
							<div class="fg-line">
								<input disabled="disabled" type="text" class="form-control"
									name="proCreateTime" id="proCreateTime"
									value="${user.createTime}" placeholder="创建时间">
							</div>
						</div>
						<div class="input-group m-b-20">
							<span class="input-group-addon"><i
								class="md md-account-circle" title="用户名"></i></span>
							<div class="fg-line fg-toggled">
								<input type="text" class="form-control"
									name="proRegUserDetailName" id="proRegUserDetailName"
									value="${user.userName}" placeholder="用户名">
							</div>
						</div>
						<div class="input-group m-b-20">
							<span class="input-group-addon"><i
								class="md md-local-phone" title="手机号码"></i></span>
							<div class="fg-line">
								<input type="text" name="proRegPhone" id="proRegPhone"
									class="form-control" value="${user.phone}" placeholder="手机号码">
							</div>
						</div>
						<div class="input-group m-b-20">
							<span class="input-group-addon"><i class="md md-mail"
								title="邮箱"></i></span>
							<div class="fg-line">
								<input type="text" name="proRegEmail" id="proRegEmail"
									class="form-control" value="${user.email}" placeholder="邮箱">
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button id="saveBtn" class="btn bgm-orange btn-icon"
						onclick="submitProChange()">
						<i class="md md-check"></i>
					</button>
					<button id="cancelBtn" class="btn bgm-deeporange  btn-icon"
						data-dismiss="modal">
						<i class="md md-close"></i>
					</button>
				</div>
			</div>
		</div>
	</div>
	<div class="modal fade"  id="changePwdModel"
		data-backdrop="static" data-keyboard="false" tabindex="-1"
		role="dialog" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h4 class="modal-title">修改密码</h4>
				</div>
				<div class="modal-body">
					<form role="form" name="pwdForm" id="pwdForm"
						class="form-horizontal" method="post">
						<div class="input-group m-b-20 ">
							<span class="input-group-addon"><i class="md  md-https"
								title="原密码"></i></span>
							<div class="fg-line fg-toggled">
								<input type="password" name="oldpassword" id="oldpassword"
									class="form-control" placeholder="原密码">
							</div>
						</div>
						<div class="input-group m-b-20 ">
							<span class="input-group-addon"><i class="md  md-https"
								title="新密码"></i></span>
							<div class="fg-line fg-toggled">
								<input type="password" name="regPassword" id="regPassword"
									class="form-control" placeholder="新密码">
							</div>
						</div>
						<div class="input-group m-b-20 ">
							<span class="input-group-addon"><i class="md  md-https"
								title="确认新密码"></i></span>
							<div class="fg-line fg-toggled">
								<input type="password" name="password" id="password"
									class="form-control" placeholder="确认新密码">
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button id="pwdSaveBtn" class="btn bgm-orange btn-icon"
						onclick="submitPwdChange()">
						<i class="md md-check"></i>
					</button>
					<button id="pwdCancelBtn" class="btn bgm-deeporange  btn-icon"
						data-dismiss="modal">
						<i class="md md-close"></i>
					</button>
				</div>
			</div>
		</div>
	</div>
</header>