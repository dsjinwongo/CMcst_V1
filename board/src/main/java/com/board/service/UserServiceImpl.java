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
	public void updateindex1() {
		mapper.updateindex1();
	}
	@Override
	public void updateindex2() {
		mapper.updateindex2();
	}
	@Override
	public void updateindex3() {
		mapper.updateindex3();
	}

	@Override
	public int getSelect(int index) {
		return mapper.getSelect(index);
	}
	
	@Override
	public void startAction(int sindex,int scompletenum, int srating, String sttime, double sftime, int sstime) {
		mapper.startAction(sindex,scompletenum,srating,sttime,sftime,sstime);
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
	public void updateProductTime(double sftime, String pcode) {
		mapper.updateProductTime(sftime, pcode);
	}
	
	@Override
	public String getPcode(int sindex) {
		return mapper.getPcode(sindex);
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
	
	//중단된 맨위 제품 불러오기
	@Override
	public boardVO getStoppedProduct() {
		return mapper.getStoppedProduct();
	}
	
	//대기중인 맨위 제품 불러오기
	@Override
	public boardVO getWaitingProduct() {
		return mapper.getWaitingProduct();
	}

}
