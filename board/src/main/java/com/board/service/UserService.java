package com.board.service;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.board.model.boardVO;
import com.board.model.userVO;
import com.board.model.productVO;


public interface UserService {

	// 로그인
	public int login(String userId,String userPassward);
	
	//회원가입
	public void register(userVO vo)throws Exception;
	
	//권한 체크
	public String checkAccess(String userId);
	
	//현황판 등록
	public void enroll(boardVO boardvo);

	//현황판 목록
	public List<boardVO> getList();

	// 현황판 조회
	public int getSelect(int index);
	
	//현황판 삭제
	public void delete(int sindex);
	
	public void updateindex1();
	public void updateindex2();
	public void updateindex3();
	
	public void startAction(int sindex,int scompletenum,int srating,String sttime);
	
	public void stopAction(int sindex);
	
	public void completeAction(int sindex);

	public void resetAction();
	
	public void outAction();
	
	//제품목록
	public List<productVO> getProduct();
	
	//제품등록
	public void regi_product(productVO vo) throws Exception;
	
	//제품삭제
	public void delete_product(String pcode);
	
	//자동시작 제품 불러오기
	public boardVO getFirstProduct();

}
