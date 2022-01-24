package com.board.model;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class userVO {
	 //카멜 표기법 표기 SQL 에서는 SNAKE 표기법 표기를 사용 했다.
	private String userName; //이름
	private String userGrade; //직급
	private String userPhonenum; //전화번호

	private String userDepartment; //부서
	private String userAccess; //권한

	private String userId; //아이디
	private String userPassward; //비밀번호
}
