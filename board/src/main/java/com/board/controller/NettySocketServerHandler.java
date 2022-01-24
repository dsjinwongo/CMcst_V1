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
import com.board.service.UserService;

import io.netty.buffer.ByteBuf;
import io.netty.channel.ChannelFutureListener;
import io.netty.channel.ChannelHandler.Sharable;
import io.netty.channel.ChannelHandlerContext;
import io.netty.channel.ChannelInboundHandlerAdapter;

@Sharable
public class NettySocketServerHandler extends ChannelInboundHandlerAdapter {

	private String readMessage = null;
	private global_bean gb;
	private int precurrtemp=0;
	@Resource
	private UserService userService;

	
	public NettySocketServerHandler(global_bean gb) {
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
					case 14 : //coin
						gb.setAlive_coin((String)json.get("dataval"+idx));
						break;
					case 20 : //TEMP
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
		
		
		// TODO Auto-generated method stub
		//System.out.println(gb.getSindex());
		//System.out.println(gb.getCurrent_temper());
		if(precurrtemp != gb.getCurrent_temper() && gb.getSindex()!=0) {
			
			precurrtemp = gb.getCurrent_temper();
		}else {
			System.out.println("대기중 입니다");
		}

		System.out.println("read complete");
	}
	@Override
	public void exceptionCaught(ChannelHandlerContext ctx, Throwable cause) {
		// TODO Auto-generated method stub
		cause.printStackTrace();
		ctx.close();
	}


}
