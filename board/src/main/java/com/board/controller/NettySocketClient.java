package com.board.controller;

import io.netty.bootstrap.Bootstrap;
import io.netty.channel.ChannelFuture;
import io.netty.channel.ChannelInitializer;
import io.netty.channel.ChannelOption;
import io.netty.channel.EventLoopGroup;
import io.netty.channel.nio.NioEventLoopGroup;
import io.netty.channel.socket.SocketChannel;
import io.netty.channel.socket.nio.NioSocketChannel;

public class NettySocketClient {
	private String msg;
	private String host;
	private int port;
	
	public NettySocketClient(String host, int port, String msg) {
		this.msg = msg;
		this.host = host;
		this.port = port;
	}
	
	public void run() {
		//EventLoopGroup 생성 -> 같은 그룹에 속하면 스레드와 특정 리소스를 공유
		EventLoopGroup workerGroup = new NioEventLoopGroup();
		
		try {
			//Netty를 구동하기 위해 스레드를 생성하고 소켓을 오픈하는 bootstrap클래스 생성
			Bootstrap b = new Bootstrap();
			b.group(workerGroup);
			b.channel(NioSocketChannel.class);
			b.option(ChannelOption.SO_KEEPALIVE, true);
			/*
			 * Netty에서 Socket채널은 TCP 연결을 대표하고, 이를 통해 머신 사이에서 데이터 전달과정이 이루어진다.
			 * ChannelInitializer는 Socket 채녈이 생성될 때, ChannelHandler로서 SocketChannel을 초기화한다.
			*/ 
			b.handler(new ChannelInitializer<SocketChannel>() {

				@Override
				protected void initChannel(SocketChannel ch) throws Exception {
					// TODO Auto-generated method stub
					ch.pipeline().addLast(new NettySocketClientHandler(msg));				
				}			
			});
			
			try {
				System.out.println(host+"|"+port);
				
				ChannelFuture f = b.connect(host, port).sync();
				f.channel().closeFuture().sync();
			} catch (Exception e) {
				System.out.println("connection fail");
				//e.printStackTrace();
			}
			
		} catch (Exception e) {	
			System.out.println("connection fail over");
			//e.printStackTrace();
		} finally {				
			workerGroup.shutdownGracefully();
			System.out.println("client over");
		}
	}
}
