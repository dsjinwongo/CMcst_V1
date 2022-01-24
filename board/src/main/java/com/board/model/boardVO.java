package com.board.model;

import java.sql.Date;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class boardVO {

	// 현황판 제작을위한 변수
	//만약 tableindex를 index 라는 명칭으로 사용했다면 mysql 문에서 오류가 날 것. 따라서 변수명을 tableindex로 바꾸어 주었다.
	private int tableindex;
	private String state;
	private String pcode;
	private String pname;
	private int ordernum;
	private int completenum;
	private String rating;
	private String ftime;
	private String stime;
	private String ttime;
}
