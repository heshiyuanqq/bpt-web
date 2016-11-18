package com.cmri.bpt.web.servlet;

import com.cmri.bpt.common.dict.MsgTopic;
import com.cmri.bpt.common.msg.MsgBroker;
import com.cmri.bpt.common.msg.MsgSender;

public class LocInfoMsgSender implements MsgSender<LocInfoDTO> {

	private static final LocInfoMsgSender instance = new LocInfoMsgSender();

	public static LocInfoMsgSender getInstance() {
		return instance;
	}

	//
	private MsgBroker<LocInfoDTO> msgBroker = MsgCenter.LocInfoMsgBroker;

	public String getTopic() {

		return MsgTopic.UE_LOC;
	}

	public void sendMessage(LocInfoDTO msg) {
		msgBroker.sendMsgFor(this, msg);
	}

}
