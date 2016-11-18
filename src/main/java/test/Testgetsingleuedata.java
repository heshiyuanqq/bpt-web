package test;

import java.util.ArrayList;
import java.util.List;

import org.apache.xbean.spring.context.FileSystemXmlApplicationContext;
import org.junit.Before;
import org.junit.Test;
import org.springframework.context.ApplicationContext;

import com.cmri.bpt.common.entity.CaseUeVO;
import com.cmri.bpt.common.entity.SingleUeLogPO;
import com.cmri.bpt.service.result.getsingleuelog.IGetSingleUeLogService;
import com.cmri.bpt.web.restor.SpringBeanUtil;

public class Testgetsingleuedata {
	@Before
	public void init() {
		ApplicationContext ctx = new FileSystemXmlApplicationContext("classpath:conf/spring/root-context.xml");
	
	}

	@Test
	public void test() {

		IGetSingleUeLogService testsingleuelong = SpringBeanUtil.getBean(IGetSingleUeLogService.class);
        List<CaseUeVO> list=new ArrayList<CaseUeVO>();
		CaseUeVO log = new CaseUeVO();

	    log.setCasename("1bptmixcase_2016年05月31日10时02分12秒");
	    log.setUe_id("460002126050807");
	    log.setUser_id(1);

	    list.add(log);
	    String path="E:\\yd_bpt\\.metadata\\.plugins\\org.eclipse.wst.server.core\\tmp1\\wtpwebapps\\bpt-web\\testcase";
	    List<SingleUeLogPO> retlist=new ArrayList<SingleUeLogPO>();
	    retlist=  testsingleuelong.GetSingleUeLog(list, path);
	    System.out.println(retlist.size());

	//	@SuppressWarnings("serial")
	



	}
}
