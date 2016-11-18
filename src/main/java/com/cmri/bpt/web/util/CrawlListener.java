package com.cmri.bpt.web.util;

import java.util.List;

import com.cmri.bpt.entity.auth.AppTokenSession;

public interface CrawlListener {

	void onFinished(Integer userId, List<AppTokenSession> session);
}
