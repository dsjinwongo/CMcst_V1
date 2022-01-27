package com.board.service;

import java.util.List;

import javax.annotation.Resource;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Service;

import com.board.mapper.UserMapper;

import com.board.model.boardVO;
import com.board.model.userVO;
import com.board.model.productVO;

@Service
public class UserServiceImpl implements UserService {

	@Resource
	private UserMapper mapper;
	
	@Override
	public int login(String userId, String userPassward) {
		return mapper.login(userId,userPassward);

	}

	@Override
	public void register(userVO vo) throws Exception {
		mapper.register(vo);
	}
	
	@Override
	public String checkAccess(String userId) {
		return mapper.checkAccess(userId);
	}

	@Override
	public void enroll(boardVO boardvo) {
		mapper.enroll(boardvo);
	}

	@Override
	public List<boardVO> getList(){
		return mapper.getList();
	}
	
	@Override
	public void delete(int sindex) {
		mapper.delete(sindex);
	}

	@Override
	public int getSelect(int index) {
		return mapper.getSelect(index);
	}
	
	@Override
	public void startAction(int sindex,int scompletenum, int srating, String sttime) {
		mapper.startAction(sindex,scompletenum,srating,sttime);
	}
	
	@Override
	public void stopAction(int sindex) {
		mapper.stopAction(sindex);
	}
	
	@Override
	public void completeAction(int sindex) {
		mapper.completeAction(sindex);
	}
	
	@Override
	public void resetAction() {
		mapper.resetAction();
	}

	@Override
	public void outAction() {
		mapper.outAction();
	}
	
	@Override
	public List<productVO> getProduct(){
		return mapper.getProduct();
	}
	
	@Override
	public void regi_product(productVO vo) throws Exception {
		mapper.regi_product(vo);
	}
	
	@Override
	public void delete_product(String pcode) {
		mapper.delete_product(pcode);
	}

}
