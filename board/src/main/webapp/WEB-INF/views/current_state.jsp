<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Date"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.board.bean.global_bean"%>
<%@ page import="java.io.PrintWriter, java.util.ArrayList, java.net.URLEncoder" %>
<%@ page import="java.net.URLEncoder" %>
<%@page import="com.board.bean.global_bean"%>
<%@taglib prefix="c" uri = "http://java.sun.com/jsp/jstl/core" %>


<%
String userId = (String)session.getAttribute("userId");

boolean login = userId == null ? false : true;

	if(login){
	
	String userAccess = (String)session.getAttribute("userAccess");
	//C 인 사람만 입력칸 버튼 누르지 못하게 할 예정
%>		
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
		<!--  비동기 처리를 위한 AJAX 사용 -->
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
		<META HTTP-EQUIV="refresh" CONTENT="10">
	
	</head>
	<script type="text/javascript">
	 window.history.forward(1);
	 function noBack(){window.history.forward(1);}
	</script>
	<!--  layout body  -->
	<body class="is-preload" onload="noBack();" onpageshow="if(event.persisted) noBack();" onunload="">
	<script>
		var count=${Current_temper};
		console.log(count);
	</script>
		<!-- Wrapper -->
		<div id="wrapper">
			<div id="main">
				<div class="inner">
				
				<!-- header -->
				<%@include file = "layout/header.jsp" %>
				<font size = "4em">
				<tr>
				<table width = 120>
					<th><a href="stay.cst">대기화면으로 나가기 </a></th>
					<th><a href="logoutAction.cst">로그아웃</a></th>
					<!-- <th><a href="outAction.cst">현황판 파일로 저장</a>  작동안함.-->
				</table>
				</tr>
				</font>
				
				<section id="banner">
					<div style = "width:100%";>
						<table border="1px" id="curr_Table">
							<thead>
								<tr>
									<th>번호</th>
									<th>상태</th>
									<th>제품코드</th>
									<th>제품명</th>
									<th>주문수량</th>
									<th>완료수량</th>
									<th>진행률</th>
									<th>1대당 작업시간</th>
									<th>예상 작업시간(분)</th>
									<th>예상 완료시각</th>																
								</tr>
							</thead>
							<c:forEach items="${list}" var="list">
            					<tr>
                					<td><c:out value="${list.tableindex}"/></td>
               						<td><c:out value="${list.state}"/></td>
                					<td><c:out value="${list.pcode}"/></td>
                					<td><c:out value="${list.pname}"/></td>
                					<td><c:out value="${list.ordernum}"/></td>
                					<td><c:out value="${list.completenum}"/></td>
                					<td><c:out value="${list.rating}"/>%</td>
                					<td><c:out value="${list.ftime}"/>초</td>
                					<td><c:out value="${list.stime}"/>분</td>
                					<td><c:out value="${list.ttime}"/>분</td>
                                    <!-- 추후에 버튼 말고 a 태그에서 controller 작동 할 수 있는 방법을 알면 공간적으로 절약될듯.  -->
            					</tr>
       						</c:forEach>

							<tbody id="currTbody"></tbody>
							<tfoot>
							</tfoot>
						</table>	
					</div>
				 </section>
			</div>
		</div>
				<!-- Sidebar -->
	</div>
		<!-- Scripts -->
			<script src="resources/assets/js/jquery.min.js"></script>
			<script src="resources/assets/js/browser.min.js"></script>
			<script src="resources/assets/js/breakpoints.min.js"></script>
			<script src="resources/assets/js/util.js"></script>
			<script src="resources/assets/js/main.js"></script>
	</body>
</html>