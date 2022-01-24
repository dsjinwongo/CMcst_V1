<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter, java.util.ArrayList, java.net.URLEncoder" %>
<%@page import="com.board.bean.global_bean"%>
<%
String userId = (String)session.getAttribute("userId");

boolean login = userId == null ? false : true;

	if(login){
	
	String userAccess = (String)session.getAttribute("userAccess");
	
	boolean access = userAccess.equals("A")||userAccess.equals("B") ? false : true;
	
	if(access){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('접근권한이 없습니다.');");
		script.println("location.href = 'stay.cst';");
		script.println("</script>");
		script.close();
	}else{
		
	}
	System.out.println(access);
	//C 인 사람만 입력칸 버튼 누르지 못하게 할 예정
%>	
	<td>아이디 "<%= userId%>"로 로그인 중입니다.</td>
<%
	}else{
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('잘못된 접근 입니다. 로그인을 해주세요.');");
		script.println("location.href = 'fp.cst';");
		script.println("</script>");
		script.close();
		return;	
	}
%>
<% 
	// netty 통신으로 연결 될 gb
	String user_id = (String)request.getAttribute("user_id");
	global_bean gb = null;
	
	try {
		gb = (global_bean)request.getAttribute("gb");
	} catch(java.lang.NullPointerException e) {

		
	}

%>
<!DOCTYPE html>
<html>
	<!--  layout header -->
	<head>
		<title>창명제어기술</title>
		<meta charset="utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />
		<link rel="stylesheet" href="resources/assets/css/main.css" />
	</head>
	<script type="text/javascript">
	 window.history.forward(1);
	 function noBack(){window.history.forward(1);}
	</script>
	<!--  layout body  -->
	<body class="is-preload" onload="noBack();" onpageshow="if(event.persisted) noBack();" onunload="" >
		<!-- Wrapper -->
		<div id="wrapper">
			<div id="main">
				<div class="inner">
				
				<!-- header -->
				<%@include file = "layout/header.jsp" %>
				
				<section id="banner">
					<!--  body -->
					<div class="content">
						<header><h1>신규 등록<br/></h1></header>
						<font size = "3.4em">
						<!-- action은 위 form을 보낼 곳, 제품등록에서는 regiProduct.cst로 보내도록 하겠다. -->
                        <form method="post" action="regiProduct.cst">
	                        <div>
	                           	<strong><text>제품코드</text></strong>
	                               <input type="text" name="code" class="text" required="required"/>
	                               <p></p>
	                               
	                           	<strong><text>제품명</text></strong>
	                               <input type="text" name="name" class="text" required="required"/>
	                               <p></p>
	                               
	                           	<strong><text>시간(초)</text></strong>
	                               <input type="text" name="time" class="text" required="required"/>
	                               <p></p>
	                               
	                               <div class="col-12">
									<ul class="actions">
										<li><input type="submit" value="등록" class="primary" /></li>
										<li><input type="reset" value="취소" /></li>
									</ul>
								</div>                                                                                  
	                          </div>
                           </form>
					
						</font >
						<!--  info 와 로그인 정보를 여기서 바로 하게 하면 좋을 것 같다. -->
					</div>
				 </section>
			</div>
		</div>
		<!-- Sidebar -->
		<%@include file = "layout/sidebar.jsp" %>	
	</div>
			<!-- Scripts -->
			<script src="resources/assets/js/jquery.min.js"></script>
			<script src="resources/assets/js/browser.min.js"></script>
			<script src="resources/assets/js/breakpoints.min.js"></script>
			<script src="resources/assets/js/util.js"></script>
			<script src="resources/assets/js/main.js"></script>

	</body>
</html>