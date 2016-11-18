package test;

import org.junit.Before;
import org.junit.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.FileSystemXmlApplicationContext;

import com.cmri.bpt.service.user.UserService;
import com.cmri.bpt.service.user.bo.User;
import com.cmri.bpt.web.restor.SpringBeanUtil;

public class UserServiceTest {

	@Before
	public void init() {
		//ApplicationContext ctx = new FileSystemXmlApplicationContext("classpath:conf/spring/root-context.xml");

	}

	@Test
	public void test() {

		UserService userS = SpringBeanUtil.getBean(UserService.class);
		User user = new User();
		user.setPhoneNumber("13900000000");
		user.setPassword("123456");
		userS.addUser(user);

	}

}
