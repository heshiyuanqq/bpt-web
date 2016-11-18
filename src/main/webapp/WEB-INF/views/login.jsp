<%@page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/common/taglibs.jsp"%>
<!DOCTYPE html>
<!--[if IE 9 ]><html class="ie9"><![endif]-->
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>外场大容量系统</title>
<link rel="shortcut icon" href="${ctx }/favicon.ico"
	type="images/x-icon">
<%@ include file="/WEB-INF/common/tmoscommon.jsp"%>
<script>
	(function($) {
		$.fn.bootstrapValidator.validators.geetestVal = {
			/**
			 * @param {BootstrapValidator} validator The validator plugin instance
			 * @param {jQuery} $field The jQuery object represents the field element
			 * @param {Object} options The validator options
			 * @returns {boolean}
			 */
			validate : function(validator, $field, options) {
				return $field.val() == '1';
			}
		};
	}(window.jQuery));
</script>
<style>
.m-b-20 {
    margin-bottom: 10px!important;
}
.mylogin{
	list-style: none;
}
</style>
<script>
	//极验
	var gtResult = 0;
	jQuery(function($) {

		$('#logForm').bootstrapValidator({
			message : 'This value is not valid',
			excluded : [ ':disabled' ],
			feedbackIcons : {
				valid : 'md md-check',
				invalid : 'md md-close',
				validating : 'md md-refresh'
			},
			group : '.input-group',
			//submitButtons: '#logBtn',
			fields : {
				username : {
					container : 'tooltip',
					validators : {
						notEmpty : {
							message : '账号不能为空!'
						},
						regexp : {
							regexp : /^([a-zA-Z0-9]+)$/i,
							message : '账号只能是英文或者字母!'
						}
					}
				},
				password : {
					container : 'tooltip',
					validators : {
						notEmpty : {
							message : '密码不能为空!'
						}
					}
				},
				geetestVali : {
					container : 'tooltip',
					validators : {
						geetestVal : {}
					}
				}
			}
		});

		$('#forForm').bootstrapValidator({
			message : 'This value is not valid',
			excluded : [ ':disabled' ],
			feedbackIcons : {
				valid : 'md md-check',
				invalid : 'md md-close',
				validating : 'md md-refresh'
			},
			group : '.input-group',
			submitButtons : '#forBtn',
			fields : {
				fogEmail : {
					container : 'tooltip',
					validators : {
						notEmpty : {
							message : '邮箱地址不能为空!'
						},
						emailAddress : {
							message : '请输入有效的邮箱地址!'
						}
					}
				}
			}
		});

		$('#regForm').bootstrapValidator({
			message : 'This value is not valid',
			excluded : [ ':disabled' ],
			feedbackIcons : {
				valid : 'md md-check',
				invalid : 'md md-close',
				validating : 'md md-refresh'
			},
			group : '.input-group',
			submitButtons : '#regBtn',
			fields : {
				regUserDetailName : {
					container : 'tooltip',
					validators : {
						notEmpty : {
							message : '用户名不能为空!'
						},
						regexp : {
							regexp : /^[a-zA-Z0-9\u4e00-\u9fa5]+$/i,
							message : '用户名不能存在特殊字符!'
						}
					}
				},
				regPhone : {
					container : 'tooltip',
					validators : {
						notEmpty : {
							message : '手机号不能为空!'
						},
						numeric : {
							message : '清输入正确的手机号!'
						},
						regexp:{
							regexp:/^1[3|4|5|7|8]\d{9}$/,
							message:'请输入正确的手机号!'
						}
					}
				},
				regPassword : {
					container : 'tooltip',
					validators : {
						notEmpty : {
							message : '密码不能为空!'
						}
					}
				},
				regRepeatPassword : {
					container : 'tooltip',
					validators : {
						notEmpty : {
							message : '密码不能为空!'
						},
						identical : {
							field : 'regPassword',
							message : '确认密码和密码不一致!'
						}
					}
				},
				agreeThis : {
					container : 'tooltip',
					validators : {
						notEmpty : {
							message : '请选择并同意相关协议!'
						}
					}
				}
			}
		});

		var content = ${errorType} + '';
		if (content != '' && content == '1') {
			notify(' 提示 ', '用户名或者密码不正确！', 'danger');
		}

		//加载城市
		$.ajax({
			type : "POST",
			url : '${ctx}/queryParentProvinces',
			dataType : 'JSON',
			success : function(data) {
				$("#provinceSelect").select2({
					minimumResultsForSearch : Infinity,
					placeholder : "请选择省份",
					data : data
				});
				$("#provinceSelect").val(null).trigger("change");
			},
			error : function() {
				notify('提示', '加载省份失败!!', 'danger');
			}
		});

		$("#provinceSelect").on("change", function (e) { 
			if($("#provinceSelect").val()!=null){
				 loadCityFunc();
				}
			});
		
	});
	document.onkeydown = function(e) {
		if (!e)
			e = window.event;//火狐中是 window.event
		if ((e.keyCode || e.which) == 13) {
			var id = $('.lc-block.toggled').attr('id');
			if ('l-login' == id) {
				submitLoginForm();
			} else if ('l-register' == id) {
				submitRegForm();
			} else if ('l-forget-password' == id) {
				//找回密码
				submitForgotForm();
			}

		}
	}
	
	function loadCityFunc(){
		$("#cityDiv").show();
		$("#citySelectDiv").html('<select id="citySelect" style="width:100%"></select>');
		$.ajax({
			type : "POST",
			url : '${ctx}/queryCityByProId',
			dataType : 'JSON',
			 data: {
	            	id:$("#provinceSelect").val()
	            },
			success : function(data) {
				$("#citySelect").select2({
					minimumResultsForSearch : Infinity,
					placeholder : "请选择城市",
					data : data
				});
				$("#citySelect").val(null).trigger("change");
			},
			error : function() {
				notify('提示', '加载城市失败!!', 'danger');
			}
		});
	}
	
	function submitForgotForm() {
		$('#forForm').data('bootstrapValidator').validate();
		if (!$('#forForm').data('bootstrapValidator').isValid()) {
			return false;
		} else {
			$('#forBtn').attr("disabled", true);
			$.ajax({
				type : "POST",
				url : "${ctx}/register/forgotPwd",
				data : {
					email : $("#fogEmail").val()
				},
				success : function(data) {
					if (data == '1') {
						swal({
							title : "密码找回",
							text : "邮件已发送，请注意查收！！",
							timer : 2000,
							showConfirmButton : false
						});
					} else {
						swal({
							title : "密码找回!",
							text : "邮箱发送出错或者邮箱不存在,请联系管理员!",
							type : "error",
							showCancelButton : true,
							cancelButtonText : '确定',
							showConfirmButton : false
						});
					}
					$('#forBtn').attr("disabled", false);
				}
			});
		}
	}
	function submitRegForm() {
		$('#regForm').data('bootstrapValidator').validate();
		
			if($("#provinceSelect").val()==null){
				notify('提示', '请选择省', 'danger');
				return;
			}
			
			if($("#citySelect").val()==null){
				notify('提示', '请选择城市', 'danger');
				return;
			}
		if (!$('#regForm').data('bootstrapValidator').isValid()) {
			return false;
		} else {
			$('#regBtn').attr("disabled", true);
			//使用ajax注册
			$.ajax({
				type : "POST",
				url : "${ctx}/registerUser",
				data : {
					nickname : $("#regUserDetailName").val(),
					password : $("#regPassword").val(),
					phoneNumber : $("#regPhone").val(),
					cityId: $("#citySelect").val()
				},
				success : function(data) {
					if (data == '1') {
						notify(' 注册失败 ', '用户名已经存在！', 'danger');
					} else if (data == '2') {
						notify(' 注册失败 ', '手机号已经存在！', 'danger');
					} else if (data == '3') {
						notify(' 注册失败 ', '非法注册密码！', 'danger');
					} else if (data == '4') {
						notify(' 注册失败 ', '非法城市！', 'danger');
					} else if (data == '6') {
						swal("注册成功!", "2秒后自动跳转","success");
						setTimeout(function(){window.location.reload()},2000);
					} else {
						notify(' 注册失败 ', '用户保存失败！', 'danger');
					}
					$('#regBtn').attr("disabled", false);
				}
			});
		}
	}

	function submitLoginForm() {
		$('#logForm').data('bootstrapValidator').validate();
		if (!$('#logForm').data('bootstrapValidator').isValid()) {
			if (gtResult == 0) {
				notify('提示', '请拖到滑块完成验证！', 'danger');
			}
			return false;
		} else {
			if (gtResult == 0) {
				notify('提示', '请拖到滑块完成验证！', 'danger');
				$('#logBtn').attr("disabled", false);
			} else {
				$('#logBtn').attr("disabled", true);
				$('#logForm').data('bootstrapValidator').defaultSubmit();
				$('#logBtn').attr("disabled", false);
			}
		}
	}
</script>
</head>

<body class="login-content ">
	<!-- Login -->

	<div class="lc-block toggled" id="l-login">
		<form role="form" name="logForm" id="logForm" class="form-horizontal"
			action="${ctx}/login" method="post">
			<div class="input-group m-b-20">
				<img src="<c:url value="/images/logo.gif"/>" alt="China Mobile">
			</div>
			<div class="input-group m-b-20 ">
				<span class="input-group-addon"><i class="md md-person"></i></span>
				<div class="fg-line fg-toggled">
					<input type="text" name="username" id="username"
						class="form-control" placeholder="手机号">
				</div>
			</div>
			<div class="input-group m-b-20 ">
				<span class="input-group-addon"><i class="md  md-https"></i></span>
				<div class="fg-line">
					<input type="password" name="password" id="password"
						class="form-control" placeholder="密码">
				</div>
			</div>

			<div class="input-group m-b-20 ">

				<div style="margin-left: 40px;">
					<script type="text/javascript"
						src="http://api.geetest.com/get.php?gt=494d1f35af52e2c62b1e596638f9530c&product=float"
						async></script>
					<script>
						window.gt_custom_ajax = function(result, selector,
								message) {
							gtResult = result;
							$("#geetestVali").val(result);
							if (result == "1") {
								$('#logForm').data('bootstrapValidator')
										.updateStatus('geetestVali', 'VALID',
												null);
							}
							//result表示成功与否，1为成功，0为失败
							//selector是一个仅接受类似'.gt_refresh_button'的验证码内部元素className的选择器
							//message表示触发理由，有Success, Fail, Forbidden, Abuse等
						}
					</script>
				</div>
			</div>
			<div class="input-group m-b-20 " style="display: none">
				<input type="hidden" name="geetestVali" id="geetestVali" value="0">
			</div>
			<div class="clearfix"></div>

			<div class="checkbox">
				<label> <input type="checkbox" name="rememberMe"
					value="true"> <i class="input-helper"></i> 请记住我
				</label>
			</div>

			<a href="javascript:void(0)" id="logBtn" onclick="submitLoginForm()"
				class="btn btn-login btn-danger btn-float" title="登录系统"><i
				class="md md-arrow-forward"></i></a>

			<ul class="login-navigation">
				<li data-block="#l-register" class="bgm-red" title="注册">注册</li>
			</ul>

		</form>
	</div>
	<!-- Register -->
	<div class="lc-block" id="l-register">
		<form role="form" name="regForm" id="regForm" class="form-horizontal"
			method="post">
			<div class="input-group m-b-20">
				<img src="<c:url value="/images/logo.gif"/>" alt="China Mobile">
			</div>
			<div class="input-group m-b-20">
				<span class="input-group-addon"><i
					class="md md-account-circle"></i></span>
				<div class="fg-line">
					<input type="text" class="form-control" name="regUserDetailName"
						id="regUserDetailName" placeholder="用户名">
				</div>
			</div>

			<div class="input-group m-b-20">
				<span class="input-group-addon"><i class="md md-local-phone"></i></span>
				<div class="fg-line">
					<input type="text" name="regPhone" id="regPhone"
						class="form-control" placeholder="手机号码">
				</div>
			</div>

			<div class="input-group m-b-20">
				<span class="input-group-addon"><i class="md  md-https"></i></span>
				<div class="fg-line">
					<input type="password" class="form-control" name="regPassword"
						id="regPassword" placeholder="密码">
				</div>
			</div>

			<div class="input-group m-b-20">
				<span class="input-group-addon"><i class="md  md-https"></i></span>
				<div class="fg-line">
					<input type="password" id="regRepeatPassword"
						name="regRepeatPassword" class="form-control" placeholder="确认密码">
				</div>
			</div>

			<div class="input-group m-b-20">
				<div class="input-group m-b-20">
					<span class="input-group-addon">省</span>
					<div class="fg-line" style="width:370px;">
						<select id="provinceSelect" style="width:100%"></select>
					</div>
				</div>
			</div>

			<div class="input-group m-b-20" id="cityDiv" style="display: none;" >
				<div class="input-group m-b-20">
					<span class="input-group-addon">市</span>
					<div class="fg-line" id="citySelectDiv" style="width:370px;">
					</div>
				</div>
			</div>

			<div class="input-group m-b-20">
				<span class="input-group-addon"></span>
				<div class="col-sm-10">
					<div class="checkbox">
						<label class="form-checkbox form-icon"> <input
							type="checkbox" value="" name="agreeThis" id="agreeThis">
							<i class="input-helper"></i> 我同意此协议
						</label>
					</div>
				</div>
			</div>

			<div class="clearfix"></div>


		</form>

		<a href="javascript:void(0)" id="regBtn" onclick="submitRegForm()"
			class="btn btn-login btn-danger btn-float" title="注册"><i
			class="md md-arrow-forward"></i></a>

		<ul class="login-navigation" style="bottom: -2;">
			<li data-block="#l-login" class="bgm-green" title="登录">登录</li>
		</ul>
	</div>

	<!-- Forgot Password -->
	<div class="lc-block" id="l-forget-password">
		<div class="input-group m-b-20">
			<img src="<c:url value="/images/logo.gif"/>" alt="China Mobile">
		</div>
		<p class="text-left">系统将会向邮箱发送找回密码邮件,即可重置新密码</p>
		<form role="form" name="forForm" id="forForm" class="form-horizontal"
			method="post">
			<div class="input-group m-b-20">
				<span class="input-group-addon"><i class="md md-email"></i></span>
				<div class="fg-line">
					<input type="text" name="fogEmail" id="fogEmail"
						class="form-control" placeholder="邮箱">
				</div>
			</div>
		</form>

		<a href="javascript:void(0)" id="forBtn" onclick="submitForgotForm()"
			class="btn btn-login btn-danger btn-float" title="确定"><i
			class="md md-arrow-forward"></i></a>

		<ul class="login-navigation">
			<li data-block="#l-login" class="bgm-green" title="登陆">登陆</li>
			<li data-block="#l-register" class="bgm-red" title="注册">注册</li>
		</ul>

	</div>
	<%@ include file="/WEB-INF/views/system/foot.jsp"%>
</body>
</html>