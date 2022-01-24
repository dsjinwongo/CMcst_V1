<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter, java.util.ArrayList, java.net.URLEncoder" %>
    
<!DOCTYPE html>
<%
String userId = (String)session.getAttribute("userId");

boolean login = userId == null ? false : true;

	if(login){
	
	String userAccess = (String)session.getAttribute("userAccess");
	boolean access = userAccess.equals("C") ? true : false;
	System.out.println(access);
	//C 인 사람만 입력칸 버튼 누르지 못하게 할 예정
%>	
	아이디 "<%= userId%>"로 로그인 중입니다.
	
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
	<body class="is-preload" onload="noBack();" onpageshow="if(event.persisted) noBack();" onunload="">
		<!-- Wrapper -->
		<div id="wrapper">
			<div id="main">
				<div class="inner">
				
				<!-- header -->
				<%@include file = "layout/header.jsp" %>
				<section>
					<font size = "6em">
						<h2>Industrial AI</h2>
					</font>
					<div class="features">
						<article>
							<span class="icon fa-gem"></span>
								<div class="content">
									<h3>cmcst board</h3>
									<p>
									this is project for 창명제어기술 currboard test.
									with Double J.
									</p>
								</div>
						</article>
						<article>
								<div class="content">
									<ul><p>안녕하세요 "<%= userId%>"님.</p></ul>
									<ul><p>오늘도 좋은 하루 되세요.</p></ul>
								</div>
						</article>
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