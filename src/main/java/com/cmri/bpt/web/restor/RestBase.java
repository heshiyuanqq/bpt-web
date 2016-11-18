package com.cmri.bpt.web.restor;





import org.apache.log4j.*;

import com.cmri.bpt.common.exception.AuthenticationException;
import com.cmri.bpt.common.exception.BusinessException;
import com.cmri.bpt.common.exception.ValidationException;
import com.cmri.bpt.common.user.UserContext;
import com.cmri.bpt.common.user.UserContextHolder;
import com.cmri.bpt.common.util.StrUtil;

public abstract class RestBase {

	protected final Logger logger = Logger.getLogger("rest." + this.getClass());

	protected UserContext getUserContext() {
		return UserContextHolder.getUserContext();
	}

	protected void clearUserContext() {
		UserContextHolder.clearUserContext();
	}

	protected void checkAuthenticationWithFailureMessage(String failureMessage) {
		UserContext userContext = this.getUserContext();
		if (!userContext.isSystemUser()) {
			if (StrUtil.isNullOrBlank(failureMessage)) {
				failureMessage = "请先登录";
			}
			throw new AuthenticationException(failureMessage);
		}
	}

	protected void throwValidationException(String exceptionMsg) {
		throw new ValidationException(exceptionMsg);
	}

	//
	protected void throwBusinessException(String exceptionMsg) {
		throw new BusinessException(exceptionMsg);
	}

}
