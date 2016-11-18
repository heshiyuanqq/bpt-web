package com.cmri.bpt.web.restor;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.log4j.Logger;

import com.cmri.bpt.common.user.UserContext;
import com.cmri.bpt.common.user.UserContextHolder;
import com.cmri.bpt.common.user.UserInfoSetter;

public class DefaultUserInfoSetter implements UserInfoSetter {

	private static final Logger logger = Logger.getLogger(DefaultUserInfoSetter.class);

	//
	public void setUserInfo(UserContext userContext) {
		UserContextHolder.setUserContext(userContext);
	}
}
