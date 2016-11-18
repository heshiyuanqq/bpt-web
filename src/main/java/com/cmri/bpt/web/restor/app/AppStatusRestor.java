package com.cmri.bpt.web.restor.app;

import com.cmri.bpt.common.annotation.Param;
import com.cmri.bpt.common.http.HttpMethod;
import com.cmri.bpt.common.rest.RestMapping;
import com.cmri.bpt.common.rest.Restor;
import com.cmri.bpt.common.token.TokenSession;
import com.cmri.bpt.common.token.TokenSessionStore;
import com.cmri.bpt.common.user.UserContext;
import com.cmri.bpt.common.user.UserContextHolder;
import com.cmri.bpt.service.ue.AppStatusService;
import com.cmri.bpt.service.ue.bo.AppStatus;
import com.cmri.bpt.web.restor.RestBase;
import com.cmri.bpt.web.restor.SpringBeanUtil;

@Restor(category = "终端状态信息")
@RestMapping(value = "/v1/app", desc = "终端信息", method = HttpMethod.POST)
public class AppStatusRestor extends RestBase {

	AppStatusService service = SpringBeanUtil.getBean(AppStatusService.class);

	@RestMapping(value = "/status", desc = "状态信息")
	public Boolean submitStatus(@Param(name = "status") AppStatus s) {

		this.checkAuthenticationWithFailureMessage(null);

		UserContext ctx = UserContextHolder.getUserContext();

		TokenSessionStore store = UserContextHolder.getTokenSessionStore();

		TokenSession session = store.getTokenSession(ctx.getToken());

		s.setAppSessionId(session.getId());

		service.pesist(s);

		return true;
	}

}
