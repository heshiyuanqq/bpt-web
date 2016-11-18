package com.framework.web;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import com.cmri.bpt.common.token.DefaultTokenGenerator;
import com.cmri.bpt.common.token.DefaultTokenSessionEventListener;
import com.cmri.bpt.common.token.DefaultTokenSessionExpireStrategy;
import com.cmri.bpt.common.token.TokenSessionStore;
import com.cmri.bpt.common.token.TokenSessionStoreFactory;
import com.cmri.bpt.common.user.UserContextHolder;
import com.cmri.bpt.web.restor.DefaultUserContextHandler;
import com.cmri.bpt.web.restor.DefaultUserInfoSetter;
import com.cmri.bpt.web.restor.SpringBeanUtil;
import com.cmri.bpt.web.util.SysValueHolder;

public class StartupLisenter implements ServletContextListener {

	public void contextInitialized(ServletContextEvent evnt) {
		
		TokenSessionStore tokenSessionStore = SpringBeanUtil.getBean(TokenSessionStore.class);
		
		tokenSessionStore.InitSessions();//开启线程循环检测更新tokensession
		
		tokenSessionStore.addTokenSessionEventListener(new DefaultTokenSessionEventListener());
		tokenSessionStore.setTokenGenerator(new DefaultTokenGenerator());
		tokenSessionStore.setTokenSessionExpireStrategy(new DefaultTokenSessionExpireStrategy());
		//
		UserContextHolder.setTokenSessionStore(tokenSessionStore);
		//
		UserContextHolder.setUserInfoSetter(new DefaultUserInfoSetter());
		//
		UserContextHolder.setUserContextHandler(new DefaultUserContextHandler());
		
		
		
		
		String realPath = "";
		{// get the real path
			String path = this.getClass().getClassLoader().getResource("").getPath();
			String fullPath = "";
			try {
				fullPath = URLDecoder.decode(path, "UTF-8");

			} catch (UnsupportedEncodingException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			String pathArr[] = fullPath.split("/WEB-INF/classes/");
			realPath = pathArr[0];
		}
		
		SysValueHolder.WebPath = realPath;
		
		
		
		
	}

	public void contextDestroyed(ServletContextEvent evnt) {
		//
	}

}
