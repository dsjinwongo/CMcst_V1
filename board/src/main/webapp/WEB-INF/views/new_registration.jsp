<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter, java.util.ArrayList, java.net.URLEncoder" %>
<%
    String userId = (String)session.getAttribute("userId");
	String userAccess = (String)session.getAttribute("userAccess");
	
    boolean login = userId.equals("admin") ? true : false;
    boolean access = userAccess.equals("A") ? true : false;
    
    System.out.println(login);
    System.out.println(access);

	if(login && access){
%>	
<%
	}else{
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('접근 권한이 없습니다');");
		script.println("location.href = 'stay.cst';");
		script.println("</script>");
		script.close();

		return;	
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
						<!-- action은 위 form을 보낼 곳, 회원가입에서는 regiAction.jsp로 보내도록 하겠다. -->
                        	<form method="post" action="regiAction.cst">
                        	<div>
                            	<strong><text>이름</text></strong>
                                <input type="text" name="user_name" class="text" required="required"/>
                                <p></p>
                                
                            	<strong><text>핸드폰 번호 ex)010-1234-1234</text></strong>
                                <input type="text" name="user_phonenum" class="text" required="required"/>
                                <p></p>
                                
                            	<strong><text>직급</text></strong>
                                <input type="text" name="user_grade" class="text" required="required"/>
                                <p></p>
                                                                
                            	<strong><text>부서</text></strong>
                                <input type="text" name="user_department" class="text" required="required"/>
                                <p></p>
                                
                                <strong><text>권한 ex) A B C</text></strong>
                                <input type="text" name="user_access" class="text" required="required"/>
                                <p></p>
                                                                                                                       
                            	<strong><text>아이디</text></strong>
                                <input type="text" name="user_id" class="text" required="required"/>
                                <p></p>
                                
                            	<strong><text>비밀번호</text></strong>
                                <input type="text" name="user_passward" class="text" required="required"/>
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