<%@page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/common/taglibs.jsp"%>
<!DOCTYPE html>
<!--[if IE 9 ]><html class="ie9"><![endif]-->
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>基站信息侦测任务管理系统</title>
<link rel="shortcut icon" href="${ctx }/favicon.ico"
	type="images/x-icon">
<%@ include file="/WEB-INF/common/tmoscommon.jsp"%>
<link href="<c:url value="/css/auth.enter.css"/>" rel="stylesheet">


</head>

<body class="cmmt_loing_body">
	<div class="passport-header-header">
		<div
			class="passport-header-header_cell passport-header-header_cell__service">
			<div class="passport-header-header_col">
				<a
					class="passport-header-header_logo passport-header-header_logo_ru"></a>
			</div>

		</div>
		<div
			class="passport-header-header_cell passport-header-header_cell__user"></div>
	</div>

	<div data-block="domik" class="domik-wrap">
		<div class="domik">
			<div class="domik-roof">
				<span class="domik-roof-border"></span><span class="domik-roof-body"></span><span
					class="domik-roof-logo"></span>
			</div>
			<div class="domik-content">
				<form method="post" data-form-name="auth">
					<div class="domik-field" data-block="login-auth">
						<input type="text" placeholder="логин" id="login" name="login"
							value="" class="js-login-field domik-input">
						<div
							class="domik-error b-popup b-popup_to_right domik-error-login-auth domik-error-login-auth_missingvalue b-popup_open">
							<div class="b-popup_tail"></div>
							<div class="b-popup_content">Заполните это поле</div>
						</div>
					</div>
					<div class="domik-field" data-block="password-auth">
						<input type="password" placeholder="пароль" id="passwd"
							name="passwd" class="js-passwd-field domik-input">
						<div
							class="domik-error b-popup b-popup_to_right domik-error-password-auth domik-error-password-auth_missingvalue">
							<div class="b-popup_tail"></div>
							<div class="b-popup_content">Заполните это поле</div>
						</div>
						<div
							class="domik-error b-popup b-popup_to_right domik-error-password-auth domik-error-password-auth_lang">
							<div class="b-popup_tail"></div>
							<div class="b-popup_content">Смените раскладку</div>
						</div>
						<div
							class="domik-error b-popup b-popup_to_right domik-error-password-auth domik-error-password-auth_characters">
							<div class="b-popup_tail"></div>
							<div class="b-popup_content">Недопустимый ввод</div>
						</div>
					</div>
					<div class="domik-field js-domik-captcha"></div>
					<div class="domik-row">
						<div class="domik-submit" data-block="submit">
							<button
								class=" nb-button _nb-action-button js-submit-button domik-submit-button nb-group-start"
								type="submit">
								<span class="_nb-button-content">登 录</span>
							</button>
							<a
								class=" nb-button _nb-action-button nb-group-end domik-qr-code"
								href="https://passport.yandex.ru/auth?mode=qr&amp;from=mail&amp;origin=hostroot_ru_nol_mobile_enter&amp;retpath=https%3A%2F%2Fmail.yandex.ru"><span
								class="_nb-button-content"><span
									class="domik-qr-code-link"></span></span></a>
						</div>
						<label class="toggler domik-twoweeks"><input
							class="toggler-controller" name="twoweeks" value="no"
							type="checkbox" autocomplete="off"><span
							class="control__checkbox toggler-view"><span
								class="control__checkbox-icon">&nbsp;</span></span>Чужой компьютер</label>
					</div>
					<div class="domik-scl js-domik-scl">
						<button class="scl-link scl-icon scl-icon_vk js-scl-button"
							data-provider="vk"></button>
						<button class="scl-link scl-icon scl-icon_fb js-scl-button"
							data-provider="fb"></button>
						<button class="scl-link scl-icon scl-icon_tw js-scl-button"
							data-provider="tw"></button>
						<button class="scl-link scl-icon scl-icon_mr js-scl-button"
							data-provider="mr"></button>
						<button class="scl-link scl-icon scl-icon_gg js-scl-button"
							data-provider="gg"></button>
						<button class="scl-link scl-icon scl-icon_ok js-scl-button"
							data-provider="ok"></button>
					</div>
					<input type="hidden" name="retpath" value="https://mail.yandex.ru">
				</form>
				<div class="domik-separator"></div>
				<div
					class="domik-row domik-additional-buttons js-domik-additional-buttons">
					<a class="pseudo-button_small pseudo-button_remember"
						href="https://passport.yandex.ru/passport?mode=restore&amp;retpath=https%3A%2F%2Fmail.yandex.ru&amp;from=mail">Вспомнить
						пароль</a><a class="pseudo-button_small pseudo-button_register"
						href="https://passport.yandex.ru/registration?mode=register&amp;retpath=https%3A%2F%2Fmail.yandex.ru&amp;from=mail&amp;origin=hostroot_ru_nol_mobile_enter">Регистрация</a>
				</div>
			</div>
		</div>
	</div>

	<%@ include file="/WEB-INF/views/system/foot.jsp"%>
</body>
</html>