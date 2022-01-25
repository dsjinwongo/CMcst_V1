<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
	Date nowTime = new Date();
	SimpleDateFormat sf = new SimpleDateFormat("yyyy년 MM월 dd일 a hh:mm");
	
	String user_name = (String)session.getAttribute("userId");
%>

<!DOCTYPE html>


<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
		<!-- body Header -->
			<header id="header">
			 <%= sf.format(nowTime) %><br>
			 아이디 "<%= user_name%>"로 로그인 중입니다.
			<font size = "1em" style="text-align:right;">
				<img src="resources/images/logo04.png" alt="" />
			</font>
			</header>
			<body class="is-preload" onload="noBack();" onpageshow="if(event.persisted) noBack();" onunload="">
			</body>
		<!-- body Banner -->
</body>
</html>