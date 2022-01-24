package com.board.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.board.model.boardVO;
import com.board.model.productVO;
import com.board.model.userVO;

@Mapper
public interface UserMapper {

	// 로그인
	public int login(@Param("userId")String userId,@Param("userPassward")String userPassward) ;
	
	//회원가입
	public void register(userVO vo) throws Exception;
	
	//권한체크
	public String checkAccess(@Param("userId")String userId);
	
	//현황판 등록
	public void enroll(boardVO boardvo);
	
	//현황판 출력
	public List<boardVO> getList();
	
	//현황판 선택 usermapper에만 존재 아직 기능 미구현
	public int getSelect(int index);
	
	//현황판 삭제 @param을 해주지 않았을 경우 mysql 문을 사용할때, paraetersetting 부분에서 오류가 날 수 있다.
	public void delete(@Param("sindex")int sindex);
	
	//시작버튼 동작
	public void startAction(@Param("sindex")int sindex,@Param("scompletenum")int scompletenum,@Param("srating")int srating, @Param("sttime")int sttime);
	
	//중지버튼 동작
	public void stopAction(@Param("sindex")int sindex);
	
	//완료되었을때, 실행되는 동작
	public void completeAction(@Param("sindex")int sindex);
	
	//초기화 버튼을 눌렀을때, 실행되는 동작
	public void resetAction();
	
	// 저장된 데이터를 csv 파일 형식으로 내보내는 동작
	public void outAction();
	
	//제품목록 출력
	public List<productVO> getProduct();
	
	//제품등록
	public void regiproduct(productVO vo) throws Exception;

}
