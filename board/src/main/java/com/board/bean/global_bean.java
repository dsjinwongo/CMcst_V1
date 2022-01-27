package com.board.bean;

import lombok.Getter;
import lombok.Setter;

// lombok 을 이용한 어노테이션으로 getter 와 setter을 자동으로 설정, 코드 간편하게 변환.
@Getter
@Setter
public class global_bean {
	
	private String doorlock_state = "0";		
	private String heater_state = "0";		
	private String alive_coin = "0";		
	private String msg = null;
	private String reserve = null;
	private int current_temper = 0;
	private int current_humid = 0;
	private String client_host = null;
	private int sindex = 0;
	private int sordernum = 0;
	private int remain = 0;
	private int flag = 0;
}
