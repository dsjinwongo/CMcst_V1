package com.board.controller;

import javax.annotation.Resource;

import com.board.bean.global_bean;
import com.board.service.UserService;

import io.netty.bootstrap.ServerBootstrap;
import io.netty.channel.ChannelFuture;
import io.netty.channel.ChannelInitializer;
import io.netty.channel.ChannelOption;
import io.netty.channel.ChannelPipeline;
import io.netty.channel.EventLoopGroup;
import io.netty.channel.nio.NioEventLoopGroup;
import io.netty.channel.socket.SocketChannel;
import io.netty.channel.socket.nio.NioServerSocketChannel;

public class NettySocketServer {

	private UserService userService;
	private int port;
	private EventLoopGroup bossGroup;
	private EventLoopGroup workerGroup;
	private ChannelFuture f;
	private NettySocketServerHandler serverHandler;
	private global_bean gb;
	
	public NettySocketServer(int port, global_bean gb,UserService userService) {
		this.userService=userService;
		this.port = port;
		this.gb = gb;
	}
	
	public void run() {
		bossGroup = new NioEventLoopGroup(1);
		workerGroup = new NioEventLoopGroup();
		
		ServerBootstrap b = new ServerBootstrap();
		b.group(bossGroup, workerGroup).channel(NioServerSocketChannel.class).childHandler(new ChannelInitializer<SocketChannel>() {
			@Override
			public void initChannel(SocketChannel ch) throws Exception {
				ChannelPipeline pipeline = ch.pipeline();
				serverHandler = new NettySocketServerHandler(gb,userService);
				pipeline.addLast(serverHandler);
			}
		})
		.childOption(ChannelOption.SO_BACKLOG, 128)
		.childOption(ChannelOption.SO_KEEPALIVE, true)
		.childOption(ChannelOption.SO_TIMEOUT, 5);
		
		try {
			f = b.bind(port).sync();
			f.channel().closeFuture().sync();
		} catch(InterruptedException e) {
			//죽었을 때 에러가 잡히면 gb.setFlag(0);
			System.out.println("에러를 잡았다 위치는 Server");
			e.printStackTrace();
		}
	}
	
	public void serverDestroy() throws InterruptedException {
		System.out.println("socket server is overed");	
		bossGroup.shutdownGracefully().sync();
		workerGroup.shutdownGracefully().sync();
		f.channel().closeFuture().sync();
	}
	
	
	
}
