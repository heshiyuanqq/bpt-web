package test;

import org.junit.Before;
import org.junit.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.FileSystemXmlApplicationContext;

import com.cmri.bpt.common.token.DefaultTokenGenerator;
import com.cmri.bpt.common.token.DefaultTokenSessionEventListener;
import com.cmri.bpt.common.token.DefaultTokenSessionExpireStrategy;
import com.cmri.bpt.common.token.TokenSessionStore;
import com.cmri.bpt.service.user.UserService;
import com.cmri.bpt.service.user.bo.User;
import com.cmri.bpt.web.restor.SpringBeanUtil;

public class DatabaseTokenStoreTest {

	@Before
	public void init() {

		//ApplicationContext ctx = new FileSystemXmlApplicationContext("classpath:conf/spring/root-context.xml");

	}

	@Test
	public void test() {
		
		TokenSessionStore tokenSessionStore = SpringBeanUtil.getBean(TokenSessionStore.class);

		tokenSessionStore.InitSessions();

		tokenSessionStore.addTokenSessionEventListener(new DefaultTokenSessionEventListener());
		tokenSessionStore.setTokenGenerator(new DefaultTokenGenerator());
		tokenSessionStore.setTokenSessionExpireStrategy(new DefaultTokenSessionExpireStrategy());

		tokenSessionStore.createTokenSession(1, 1, "aaa");

	}

}
