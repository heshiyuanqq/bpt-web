package com.cmri.bpt.web.common.domain;

import java.io.Serializable;

/**
 * 基础对象类
 * @author k
 *
 */
public class BaseDomain  implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = -5362232899905450545L;
	
	private Long id;
	private String name;
	private String remark;
	private String status;
	private String createTime;
	private Long creator;
	private String creatorName;
	private String modificationTime;
	private Long modifier;
	private String deleteTime;
	private Long deleter;
	
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getCreateTime() {
		return createTime;
	}
	public void setCreateTime(String createTime) {
		this.createTime = createTime;
	}
	public Long getCreator() {
		return creator;
	}
	public void setCreator(Long creator) {
		this.creator = creator;
	}
	public String getCreatorName() {
		return creatorName;
	}
	public void setCreatorName(String creatorName) {
		this.creatorName = creatorName;
	}
	public String getModificationTime() {
		return modificationTime;
	}
	public void setModificationTime(String modificationTime) {
		this.modificationTime = modificationTime;
	}
	public Long getModifier() {
		return modifier;
	}
	public void setModifier(Long modifier) {
		this.modifier = modifier;
	}
	public String getDeleteTime() {
		return deleteTime;
	}
	public void setDeleteTime(String deleteTime) {
		this.deleteTime = deleteTime;
	}
	public Long getDeleter() {
		return deleter;
	}
	public void setDeleter(Long deleter) {
		this.deleter = deleter;
	}
	
	
	

}
