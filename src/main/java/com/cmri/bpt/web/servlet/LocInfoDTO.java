package com.cmri.bpt.web.servlet;

import java.util.Date;

public class LocInfoDTO {

	private Integer userId;
	
	//登录的UE的数据库Id
	private Integer ueId;
	
	private String phoneType;
	
	//按用户分配的组内Id
	private Integer sysId;

	private Double lat;
	private Double lng;

	private String task;
	
	//性能指标
	private String rate;

	private Date ts;

	public Integer getUserId() {
		return userId;
	}

	public void setUserId(Integer userId) {
		this.userId = userId;
	}

	public Integer getUeId() {
		return ueId;
	}

	public void setUeId(Integer ueId) {
		this.ueId = ueId;
	}

	public Integer getSysId() {
		return sysId;
	}

	public void setSysId(Integer sysId) {
		this.sysId = sysId;
	}

	public Double getLat() {
		return lat;
	}

	public void setLat(Double lat) {
		this.lat = lat;
	}

	public Double getLng() {
		return lng;
	}

	public void setLng(Double lng) {
		this.lng = lng;
	}

	public String getTask() {
		return task;
	}

	public void setTask(String task) {
		this.task = task;
	}

	public String getRate() {
		return rate;
	}

	public void setRate(String rate) {
		this.rate = rate;
	}

	public Date getTs() {
		return ts;
	}

	public void setTs(Date ts) {
		this.ts = ts;
	}

	public String getPhoneType() {
		return phoneType;
	}

	public void setPhoneType(String phoneType) {
		this.phoneType = phoneType;
	}
	

}
