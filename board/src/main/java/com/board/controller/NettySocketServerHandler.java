package com.board.controller;

import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.nio.charset.Charset;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import com.board.bean.global_bean;
import com.board.model.boardVO;
import com.board.service.UserService;

import io.netty.buffer.ByteBuf;
import io.netty.channel.ChannelFutureListener;
import io.netty.channel.ChannelHandler.Sharable;
import io.netty.channel.ChannelHandlerContext;
import io.netty.channel.ChannelInboundHandlerAdapter;

@Sharable
public class NettySocketServerHandler extends ChannelInboundHandlerAdapter {

	private UserService userService;
	private String readMessage = null;
	private global_bean gb;
	private boardVO vo;
	private static boolean sleepOnce=false;

	
	public NettySocketServerHandler(global_bean gb, UserService userService) {
		this.userService = userService;
		this.gb = gb;	
	}
	
	@Override
	public void channelRead(ChannelHandlerContext ctx, Object msg) {
		int idx = 0;
		
		// TODO Auto-generated method stub
		InetSocketAddress socketAddr = (InetSocketAddress)ctx.channel().remoteAddress();
		InetAddress inetaddress = socketAddr.getAddress();
		String ipAddress = inetaddress.getHostAddress(); 
		readMessage = ((ByteBuf)msg).toString(Charset.forName("UTF8"));
		ctx.writeAndFlush(msg).addListener(ChannelFutureListener.CLOSE);
		System.out.println("message from received : " + readMessage);
		System.out.println("ipaddress from received : " + ipAddress);
		
		// 메세지를 읽고 message from received 표시.
		try {
			gb.setClient_host(ipAddress);
			gb.setMsg(readMessage);
			
		} catch(Exception e) {
			System.out.println("gb pasing error");
		}
		
		try {
			JSONParser jparse = new JSONParser();
			JSONObject json = (JSONObject)jparse.parse(readMessage);
			
			
			for(idx=1;idx<=3;idx++) {
				int datacode = Integer.parseInt((String)json.get("datacode"+idx));			
				switch(datacode) {
					case 10 : //doorlock // 10 과 14를 업데이트를 확인하기 위해 임시로 바꾸어 주었다.
						gb.setDoorlock_state((String)json.get("dataval"+idx));
						break;
					case 12 : //heater
						gb.setHeater_state((String)json.get("dataval"+idx));
						break;
					case 90 : //개당 걸리는 시간
						gb.setSftime(Double.parseDouble((String)json.get("dataval"+idx))/10);
						break;
					case 85 : //현재 완료된 개수
						gb.setCurrent_temper(Integer.parseInt((String)json.get("dataval"+idx)));
						break;
					case 22 : //HUMID
						gb.setCurrent_humid(Integer.parseInt((String)json.get("dataval"+idx)));
						break;
					case 30 : //ECHO
						
						break;
				}
			}
			
			
		} catch(Exception e) {
			System.out.println("json parsing error");
		}
		
	}
	
	@Override
	public void channelReadComplete(ChannelHandlerContext ctx) throws Exception{
		
		//생산 완료 후 current_temper는 초기화 되었는데 precurrtemp가 초기화가 안된경우 초기화 
		if(gb.getPrecurrtemp()>gb.getCurrent_temper())
			gb.setPrecurrtemp(0);
		
		//제품생산이 진행중일 때 실행하는 로직
		if(gb.getPrecurrtemp() != gb.getCurrent_temper()) 
		{
			//생산중임 제품이 기록되어 있을 때
			if(gb.getSindex()!=0) 
			{
				gb.setPrecurrtemp(gb.getCurrent_temper());
				gb.setAverageTime(gb.getSftime()+gb.getAverageTime());
			}
			else //생산중임 제품이 무엇인지 모를 때
			{
				//중단 혹은 대기중인 맨 위 등록된 제품의 주문개수, 시간 가져오기
				if(userService.getStoppedProduct()!=null)
					vo = userService.getStoppedProduct();
				else
					vo = userService.getWaitingProduct();
				
				if(vo!=null) 
				{
					//첫 변화가 감지되었을 때는 count가 안전히 초기화 되기를 기다림
					if(vo.getCompletenum()+1==gb.getCurrent_temper())
					{
						gb.setFlag(1);
						gb.setSindex(vo.getTableindex());
						gb.setSordernum(vo.getOrdernum());
						gb.setSftime(Double.parseDouble(vo.getFtime()));
					}
					else
					{
						gb.setMsgValue(1);
						gb.setStoppedProductCount(vo.getCompletenum()+1);
					}
				}
				else //제품이 없을때 count 증가 방지
					gb.setMsgValue(1);
			}
		}else 
		{
			System.out.println("대기중 입니다");
		}
		
		System.out.println("precurrtemp:"+gb.getPrecurrtemp()+"Current_temper:"+gb.getCurrent_temper());

		System.out.println("read complete");
	}
	
	@Override
	public void exceptionCaught(ChannelHandlerContext ctx, Throwable cause) {
		// TODO Auto-generated method stub
		cause.printStackTrace();
		ctx.close();
	}


}
