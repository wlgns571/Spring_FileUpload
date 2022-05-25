package com.study.reply.vo;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

public class ReplyVO {
	private int reNo;
	private String reCategory;
	private int reParentNo;
	private String reMemId;
	private String reContent;
	private String reIp;
	private String reRegDate;
	private String reModDate;
	private String reMemName;
	
	
	
	public String getReMemName() {
		return reMemName;
	}

	public void setReMemName(String reMemName) {
		this.reMemName = reMemName;
	}

	@Override 
	public String toString() {
		return ToStringBuilder.reflectionToString(this,ToStringStyle.MULTI_LINE_STYLE); 
	}

	public int getReNo() {
		return reNo;
	}

	public void setReNo(int reNo) {
		this.reNo = reNo;
	}

	public String getReCategory() {
		return reCategory;
	}

	public void setReCategory(String reCategory) {
		this.reCategory = reCategory;
	}

	public int getReParentNo() {
		return reParentNo;
	}

	public void setReParentNo(int reParentNo) {
		this.reParentNo = reParentNo;
	}

	public String getReMemId() {
		return reMemId;
	}

	public void setReMemId(String reMemId) {
		this.reMemId = reMemId;
	}

	public String getReContent() {
		return reContent;
	}

	public void setReContent(String reContent) {
		this.reContent = reContent;
	}

	public String getReIp() {
		return reIp;
	}

	public void setReIp(String reIp) {
		this.reIp = reIp;
	}

	public String getReRegDate() {
		return reRegDate;
	}

	public void setReRegDate(String reRegDate) {
		this.reRegDate = reRegDate;
	}

	public String getReModDate() {
		return reModDate;
	}

	public void setReModDate(String reModDate) {
		this.reModDate = reModDate;
	}
	  
	  
	  
}
