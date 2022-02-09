<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Date"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page import="java.io.PrintWriter, java.util.ArrayList, java.net.URLEncoder" %>
<%@ page import="java.net.URLEncoder" %>
<%@page import="com.board.bean.global_bean"%>
<%@taglib prefix="c" uri = "http://java.sun.com/jsp/jstl/core" %>
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
	 function noBack(){ window.history.forward(1); }
	</script>
	<style>
	select option[value=""][disabled] {
		display: none;
	}
	.content{
	padding-right: 10px;
	}
	</style>
	<!--  layout body  -->
	<body class="is-preload" onload="noBack();" onpageshow="if(event.persisted) noBack();" onunload="" >
		<!-- Wrapper -->
		<div id="wrapper">
			<div id="main">
				<div class="inner">
				
				<!-- header -->
				<%@include file = "layout/header.jsp" %>
				
				<section id="banner" style="overflow:hidden">
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
	                               
	                            <strong><text>후공정 여부</text></strong>
	                            <select class="text" name="bprocess" required>
	                            	<option disabled selected>후공정 여부</option>
	                            	<option value="1">진행 함</option>
	                            	<option value="0">진행하지 않음</option>
	                            </select>
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
					<div style = "width:100%; height:550px; overflow:auto">
					<table border="1px" id="curr_Table">
						<thead style="position: sticky; top: 0px; background-color:white;">
							<tr>
								<th>제품코드</th>
								<th>제품명</th>
								<th>1대당 작업시간 (초)</th>
								<th>후공정 여부</th>
							</tr>
						</thead>
							<tbody id="currTbody">
								<c:forEach items="${product}" var="product">
	            					<tr>
	                					<td><c:out value="${product.code}"/></td>
	               						<td><c:out value="${product.name}"/></td>
	                					<td><c:out value="${product.time}"/></td>
	                					<c:choose>
	                					<c:when test="${product.bprocess eq 1}"><td>O</td></c:when>
	                					<c:when test="${product.bprocess eq 0}"><td>X</td></c:when>
	                					</c:choose>
	               					
	                					<form method = "post" action = "deleteProduct.cst" id = delete_product>
	                                		<input type="hidden" name = "pcode" value = "${product.code}">
	                                   	    <td><input type="submit" value="삭제"/></td>
	                                    </form>
	                                    
	                                    <!-- 추후에 버튼 말고 a 태그에서 controller 작동 할 수 있는 방법을 알면 공간적으로 절약될듯.  -->
	            					</tr>
	       						</c:forEach>
							</tbody>
					</table>
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