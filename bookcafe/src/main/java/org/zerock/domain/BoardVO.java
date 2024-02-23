package org.zerock.domain;

import java.util.Date;
import java.util.List;

import lombok.Data;

@Data
public class BoardVO {

	private Long bno;
	private String title;
	private String content;
	private String writer;
	private Date regdate;
	private Date updateDate;
	
	//댓글 개수의 대한 변수.
	private int replyCnt;
	
	private List<BoardAttachVO> attachList;
} 
