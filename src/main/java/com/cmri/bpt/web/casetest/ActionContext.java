package com.cmri.bpt.web.casetest;

import java.util.List;

import com.cmri.bpt.entity.auth.AppTokenSession;
import com.cmri.bpt.entity.vo.behaviorVO;

public class ActionContext {

	public List<AppTokenSession> tokenSession;	
	public behaviorVO behavior;
	public String timestamp;
	public Integer seed;
	public Integer userId;
	
	
}
