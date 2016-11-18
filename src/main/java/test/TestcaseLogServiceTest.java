package test;

import java.util.ArrayList;
import java.util.List;

import org.apache.xbean.spring.context.FileSystemXmlApplicationContext;
import org.junit.Before;
import org.junit.Test;
import org.springframework.context.ApplicationContext;

import com.cmri.bpt.entity.testcase.TestcaseLog;
import com.cmri.bpt.entity.testcase.TestcaseLog.TestcaseStatus;
import com.cmri.bpt.service.testcase.TestcaseLogService;
import com.cmri.bpt.service.user.UserService;
import com.cmri.bpt.service.user.bo.User;
import com.cmri.bpt.web.restor.SpringBeanUtil;

public class TestcaseLogServiceTest {

	@Before
	public void init() {
		ApplicationContext ctx = new FileSystemXmlApplicationContext("classpath:conf/spring/root-context.xml");

	}

	@Test
	public void test() {

		TestcaseLogService testcaseServcie = SpringBeanUtil.getBean(TestcaseLogService.class);

		TestcaseLog log = new TestcaseLog();

		log.setAppSessionId(1);
		log.setTestcase("t1");
		log.setAction("a1");
		log.setStatus(TestcaseStatus.running);

		testcaseServcie.persist(log);

		log.setAppSessionId(2);
		log.setTestcase("t2");
		log.setAction("a2");
		log.setStatus(TestcaseStatus.running);

		testcaseServcie.persist(log);

		log.setStatus(TestcaseStatus.finished);

		testcaseServcie.persist(log);

		List<Integer> id = new ArrayList<Integer>();
		id.add(1);
		id.add(2);

		@SuppressWarnings("serial")
		List<TestcaseLog> result = testcaseServcie.query(id);

		System.out.println(result.size());

	}
}
