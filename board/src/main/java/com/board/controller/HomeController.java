package com.board.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.PostConstruct;
import javax.annotation.PreDestroy;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.swing.JOptionPane;

import org.apache.ibatis.session.SqlSession;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.board.bean.global_bean;
import com.board.model.boardVO;
import com.board.model.productVO;
import com.board.model.userVO;
import com.board.service.UserService;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

/**
 * Handles requests for the application home page.
 */
@EnableScheduling
@Controller
public class HomeController {
	
	//@Autowired
	private SqlSession sqlSession;
	
	//private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	@Resource
	private UserService userService;
	private NettySocketServer server;
	private NettySocketClient client;
	private Thread thread;
	private global_bean gb = new global_bean();
	private int sindex = 0;
	private int sordernum = 0;
	private String sstate="";
	private int scompletenum = 0;
	private double sftime = 0;
	private int listcheck = 1;
	
	@PostConstruct
	private void start() {
		thread = new Thread(new Runnable() {			
			@Override
			public void run() {
				try {
					server = new NettySocketServer(2456,gb,userService);
					server.run();
										
				}
				catch (Exception e) {
					e.printStackTrace();
				}
			}
			
			
		});
		thread.start();	
	}
	// alert 기능
	public void alert(String notice, HttpServletResponse res) throws IOException {
		res.setCharacterEncoding("UTF-8");
		PrintWriter out = res.getWriter();
		out.println("<script type='text/javascript'>");
		out.println("alert('"+notice+"');");
		out.println("</script>");
		out.flush();
	}
	
	@SuppressWarnings("static-access")
	@PreDestroy
	private void destroy() throws InterruptedException {
		System.out.println("PreDestroy");
		thread.interrupted();
		server.serverDestroy();
	}
	
	@RequestMapping(value="/json", method=RequestMethod.GET)
	public ResponseEntity<String> getNotifierLogList() {	
		HttpHeaders responseHeaders = new HttpHeaders();
		responseHeaders.add("Content-Type", "text/html; charset=UTF-8");
		return new ResponseEntity<String>("string test", responseHeaders, HttpStatus.CREATED);
	}
	
	// 제품 등록
	@RequestMapping(value="/regiProduct.cst", method = RequestMethod.POST)
	public String regi_product(HttpSession session, HttpServletRequest req, HttpServletResponse res, Model model) throws IOException {
	
		try {			
			res.setCharacterEncoding("UTF-8");
			productVO vo = new productVO();
			
			vo.setCode(req.getParameter("code"));
			vo.setName(req.getParameter("name"));
			vo.setTime(req.getParameter("time"));
			vo.setBprocess(req.getParameter("bprocess"));
			
			userService.regi_product(vo);
			alert("제품등록이 완료되었습니다",res);
			
		}catch(Exception e){
			alert("이미 등록된 제품입니다.",res);
			e.printStackTrace();
		}finally {
			
		}
		model.addAttribute("product", userService.getProduct());
		
		return "/regi_product";
	}
	
	//회원가입 동작
	@RequestMapping(value = "/regiAction.cst", method = RequestMethod.POST)
	public String register(HttpServletRequest req, HttpServletResponse res) throws IOException {
	
		try {
			
			res.setCharacterEncoding("UTF-8");
			userVO vo = new userVO();
			
			vo.setUserName(req.getParameter("user_name"));
			vo.setUserGrade(req.getParameter("user_grade"));
			vo.setUserPhonenum(req.getParameter("user_phonenum"));
			vo.setUserDepartment(req.getParameter("user_department"));
			vo.setUserAccess(req.getParameter("user_access"));
			vo.setUserId(req.getParameter("user_id"));
			vo.setUserPassward(req.getParameter("user_passward"));
			
			userService.register(vo);
			alert("회원가입이 완료되었습니다",res);
			
		}catch(Exception e){
			alert("이미 등록된 아이디 입니다.",res);
			e.printStackTrace();
		}finally {
			
		}
		return "/new_registration";
		
	}
	
	@RequestMapping(value = "/loginAction.cst")
	public String loginProcess(HttpSession session, HttpServletResponse res, HttpServletRequest req, Locale locale, Model model) throws IOException {
		res.setCharacterEncoding("UTF-8");
		String userId = req.getParameter("user_id");
		String userPassward = req.getParameter("user_passward");
		int loginCheck = userService.login(userId, userPassward);

		if(loginCheck == 1) {
			//로그인에 성공하면 유저 데이터베이스에서 권한을 확인함.
			String userAccess = userService.checkAccess(userId);
			// 로그인시 아이디와 비밀번호 입력하고 세션을 할당 userId와 userAccess를 세션으로 할당한다.
			session.setAttribute("userAccess", userAccess);
			session.setAttribute("userId", userId);

			alert("로그인 되었습니다!", res);

			return "/stay_page";
		}
		else {
			alert("아이디 또는 비밀번호가 올바르지 않습니다!", res);
			return "/front_page";
		}
	}
	
	@RequestMapping(value = "/logoutAction.cst",method = RequestMethod.GET)
	public String logoutProcess(HttpServletResponse res, HttpServletRequest req) throws IOException {
		HttpSession session = req.getSession();
		session.invalidate();
		return "redirect:/fp.cst";
	}
	
	//서버에 현황판 내용 저장
	@RequestMapping(value = "/enrollAction.cst",method = RequestMethod.POST)
	public String enroll(HttpSession session, HttpServletResponse res, HttpServletRequest req, Model model) throws IOException {
		
		try {
			double ftime = Double.parseDouble(req.getParameter("ftime"));
			int ordernum = Integer.parseInt(req.getParameter("ordernum"));
			int stime = (int)(ftime*ordernum)/60; //분 단위 계산
			
			res.setCharacterEncoding("UTF-8");	
			boardVO boardvo = new boardVO();
			
			boardvo.setState("대기");
			boardvo.setPcode(req.getParameter("pcode"));
			boardvo.setPname(req.getParameter("pname"));
			boardvo.setOrdernum(Integer.parseInt(req.getParameter("ordernum")));
			boardvo.setCompletenum(0);
			boardvo.setRating("0");		
			boardvo.setFtime(req.getParameter("ftime")); // 1대당 작업시간
			boardvo.setStime(Integer.toString(stime)); // 예상 작업시간(분)
			boardvo.setTtime(Integer.toString(stime)); // 예상완료시간 = 예상 작업시간 후 (분)
	
			userService.enroll(boardvo);
			userService.updateindex1();
	        userService.updateindex2();
	        userService.updateindex3();
			
		}catch(Exception e){
			alert("올바른 입력이 아닙니다.",res);
			e.printStackTrace();
		}finally {
			
		}
		model.addAttribute("list",userService.getList());
		Gson gson = new GsonBuilder().create();
		model.addAttribute("product_json", gson.toJson(userService.getProduct()));
		model.addAttribute("product",userService.getProduct());
		
		return "/work_enroll";
	}
	
	// 현황판 접근 and 게시글 표시
	@RequestMapping("/cs.cst")
	public String currboard(HttpServletRequest request,Model model) throws IOException {
		
		// 현황판 표시
		//gb를 통해 연결한 netty 값을 받아오기 위해 setAttribute를 통해 값 넣는다.
		try {
			request.setAttribute("gb", gb);		
		}
		catch(Exception e) {
			System.out.println("gb error");
		};
		
		
		model.addAttribute("Current_temper",gb.getCurrent_temper());
		
		// model.addAttribute를 통해 프론트에서 list 변수를 통해 userService.getList()속 값을 list라는 변수를 통해 접근 가능 하도록 한다.
		model.addAttribute("list",userService.getList());
		return "/current_state";
		
	}
	
	//현황판 등록
	@RequestMapping(value = "/work.cst")
	public String work_enroll(HttpServletRequest request,Model model) throws IOException {
	
		model.addAttribute("list",userService.getList());
		
		//Gson을 활용해서 Json으로 파싱
		Gson gson = new GsonBuilder().create();
		
		model.addAttribute("product_json", gson.toJson(userService.getProduct()));
		model.addAttribute("product",userService.getProduct());

		return "/work_enroll";
	}
	//현황판 row 선택

	//현황판 삭제
    @PostMapping("/deleteAction.cst")
    public String delete( HttpServletResponse res, HttpServletRequest req) {
		res.setCharacterEncoding("UTF-8");
		int sindex = Integer.parseInt(req.getParameter("sindex"));
		System.out.println(sindex);
        userService.delete(sindex);
        userService.updateindex1();
        userService.updateindex2();
        userService.updateindex3();
        
        return "redirect:/work.cst";
    }
    
    //제품 삭제
    @PostMapping("/deleteProduct.cst")
    public String delete_product( HttpServletResponse res, HttpServletRequest req, Model model) throws IOException {
    	try {
    		res.setCharacterEncoding("UTF-8");
    		String pcode = req.getParameter("pcode");
    		
    		System.out.println(pcode);
            userService.delete_product(pcode);
            
            alert("제품이 삭제되었습니다!", res);
    	}
    	catch(Exception e) {
    		alert("(삭제불가)작업이 진행중인 제품입니다.",res);
			e.printStackTrace();
    	}
    	model.addAttribute("product", userService.getProduct());
    	
        return "/regi_product";
    }
    
    //데이터베이스에 진행중이라 표시하고 게계 시작 코드를 넘기는데 사용
    @RequestMapping("/startAction.cst")
    public String startAction( HttpServletResponse res, HttpServletRequest req) {
		res.setCharacterEncoding("UTF-8");
		
		sindex = Integer.parseInt(req.getParameter("sindex"));
		sordernum = Integer.parseInt(req.getParameter("sordernum"));
		sftime = Double.parseDouble(req.getParameter("sftime"));		
		scompletenum = Integer.parseInt(req.getParameter("scompletenum"));
		sstate = req.getParameter("sstate");
		
		if(sstate.contentEquals("완료됨")) {
			System.out.println("이미 완료된 작업입니다.");
			return "redirect:/work.cst";
		}
		
		gb.setMsgValue(1);
		gb.setStoppedProductCount(scompletenum);
		gb.setSindex(sindex);
		gb.setSordernum(sordernum);
		gb.setSftime(sftime);
		
		//gb.setSordernum(sordernum);
		gb.setFlag(1);
		
		//데이터베이스에 주기적으로 데이터를 받아 넣어주는 함수
		syncAction();
		
        return "redirect:/work.cst";
    }
    
    //데이터베이스에 중단됨 이라 표시하고  기계 중단코드를 넘기는데에 사용
    @RequestMapping("/stopAction.cst")
    public String stopAction( HttpServletResponse res, HttpServletRequest req) {
		
    	res.setCharacterEncoding("UTF-8");
		
    	int sindex = Integer.parseInt(req.getParameter("sindex"));
		int sordernum = Integer.parseInt(req.getParameter("sordernum"));
		
		System.out.println(sindex);
		//System.out.println(remain)
		//remain의 값으로 userService를 이용해 주분수량 줄이는 기능 (상의후 적용)
		
		if(sindex != gb.getSindex()) {
			System.out.println("작업중인 인덱스와 다른 인덱스의 중지 버튼을 누르셨습니다. 기존 작업이 계속됩니다.");
		}else {
			gb.setFlag(0);
        	userService.stopAction(sindex);
        	
        	//인덱스 초기화(자동시작할 때 중단, 대기중인 제품을 읽어와서 초기화하기 위함)
        	gb.setSindex(0);
        	
        	//다른 제품 시작을 위해 count값 초기화
        	gb.setMsgValue(1);
		}
        return "redirect:/work.cst";
    }
    
    // 데이터베이스를 비우는 동작
    @RequestMapping("/resetAction.cst")
    public String resetAction( HttpServletResponse res, HttpServletRequest req) {
		res.setCharacterEncoding("UTF-8");
		
        userService.resetAction();
        
        return "redirect:/work.cst";
    }
    
    //1초간격으로 데이터베이스에 값을 넘겨준다
    @Scheduled(fixedDelay = 1000)
    public void syncAction() {
    	if(gb.getFlag() == 1) {
    		System.out.println("정상 호출 중 입니다.");
    		
    		//curr_temper을 completenum으로 사용함.
    		double temp = ((double)gb.getCurrent_temper()/gb.getSordernum())*100;
    		int srating = (int)temp;
        	System.out.println(temp);
        	
        	//날짜 형식 설정
        	Calendar cal = Calendar.getInstance();
        	cal.setTime(new Date());
        	SimpleDateFormat sf = new SimpleDateFormat("yyyy년 MM월 dd일 a hh:mm");
        	
        	//걸리는 시간(분)
    		int sstime_min = (int)(gb.getSftime()*(gb.getSordernum()-(int)gb.getCurrent_temper())/60);
    		cal.add(Calendar.MINUTE, sstime_min);
    		
    		String sttime = sf.format(cal.getTime());
    		
    		//걸리는 시간(시,분)
    		int sstime_hour=sstime_min/60;
    		sstime_min%=60;
    		String sstime=sstime_hour+"시간"+sstime_min+"분";
    		
    		String sftime_average=gb.getSftime()+"/"+Double.toString(Math.round(gb.getAverageTime()/gb.getCurrent_temper()*100)/100.0);
        	
        	if(gb.getSordernum() <= (int)gb.getCurrent_temper()) {
            	//완료되면 완료상태를 한번 데이터베이스에 저장하고 완료되었습니다 문구 표시 후 flag = 0으로 만들어 작업 중지 다음 작업 준비.
        		userService.startAction(gb.getSindex(), gb.getCurrent_temper(), srating, sttime, sftime_average, sstime);
        		
        		gb.setFlag(0);
        		System.out.println("완료되었습니다");
        		
        		//데이터베이스 상태를 완료됨으로 변경.
        		userService.completeAction(gb.getSindex());
        		
        		//제품 시간 업데이트
        		String pcode=userService.getPcode(gb.getSindex());
        		userService.updateProductTime(Math.round(gb.getAverageTime()/gb.getCurrent_temper()*100)/100.0, pcode);
        		
        		//평균시간 초기화
        		gb.setAverageTime(0);
        			
        		//인덱스 초기화(자동시작할 때 중단, 대기중인 제품을 읽어와서 초기화하기 위함)
        		gb.setSindex(0);
        		
        		//count값 초기화
        		gb.setMsgValue(1);
        		
        		//중단되었던 것이 자동시작하며 바로 완료될 때 pre가 초기화 되지 못하는 것을 방지
        		if(gb.getPrecurrtemp()!=gb.getCurrent_temper())
        			gb.setPrecurrtemp(gb.getCurrent_temper());
        		
        	}else {
            	userService.startAction(gb.getSindex(), gb.getCurrent_temper(), srating, sttime, sftime_average, sstime);
        	}    	
    	} else {
    		System.out.println("작업 중지중 입니다.");
    	}
    	
    	client_send();
    	
    	gb.setMsgValue(0);
    	gb.setStoppedProductCount(0);
    }
    
    public void client_send () {			
		//1초마다 서버에 msg를 보내 count값을 초기화 해야하는지를 결정
    	String testMsg = "{\"datacode1\":"+80+",\"dataval1\":"+gb.getMsgValue()+","
				+ "\"datacode2\":"+83+",\"dataval2\":"+gb.getStoppedProductCount()+","
						+ "\"datacode3\":"+"\"80\""+",\"dataval3\":"+"\"0\""+"}";
		int port = 2588;
		
		
		if(gb.getClient_host() != null) {
			client = new NettySocketClient(gb.getClient_host(),port,testMsg);
			
			client.run();
		}
		else {
			System.out.println("client address error");
		}
	}

	//csv 파일로 현황판 데이터를 내보내는 동작 (작동안함) my.ini 파일을 건들여주어야 한다고 함.
    @RequestMapping("/outAction.cst")
    public String outAction( HttpServletResponse res, HttpServletRequest req) {
        userService.outAction();
		System.out.println("성공");

        return "redirect:/cs.cst";
    }
    
    @ResponseBody
	@RequestMapping(value="/wordSearchShow.action", method=RequestMethod.GET, produces="text/plain;charset=UTF-8")
	public String wordSearchShow(HttpServletRequest request) {
		
		String searchWord = request.getParameter("searchWord");
		
		//Gson을 활용해서 Json으로 파싱
		Gson gson = new GsonBuilder().create();
		
		return gson.toJson(userService.searchProduct(searchWord));
	}
		
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// 게시판 접근 컨트롤
	@RequestMapping("/")
	public String main_log(HttpServletRequest request) throws IOException {	
		
		return "/front_page";
	}
	
	@RequestMapping("/fp.cst")
	public String main(HttpServletRequest request) throws IOException {	
		
		return "/front_page";
	}
	
	@RequestMapping("/stay.cst")
	public String stay(HttpServletRequest request) throws IOException {	
		
		return "/stay_page";
	}
	
	// 회원가입 페이지
	@RequestMapping(value = "/regi.cst")
	public String registration(HttpServletRequest request) throws IOException {
	
		return "/new_registration";
	}
	
	// 회원가입 페이지
	@RequestMapping(value = "/new_product.cst")
	public String new_product(HttpServletRequest request, Model model) throws IOException {
	
		model.addAttribute("product", userService.getProduct());
		
		return "/regi_product";
	}
	
	@RequestMapping("/nobo.cst")
	public String notice_board(HttpServletRequest request) throws IOException {	
		
		return "/notice_board";
	}

}


