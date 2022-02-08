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
<%

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
	</head>
	<script>
		function product_complete(){
			
			var code=$("select[name='pcode']").val();
			
			var product_obj = ${product_json};
			
			console.log(product_obj);
			
			function find_code(element){
				if(element.code==code){
					console.log(code);
					return true;
					}
			}
			
			var tproduct=product_obj.find(find_code);
			
			$('input[name=pname]').attr('value',tproduct.name);
			$('input[name=ftime]').attr('value',tproduct.time);

		}
	</script>
	 <script type="text/javascript">
	 window.history.forward(1);
	 function noBack(){window.history.forward(1);}
	</script>
	<style>
	select option[value=""][disabled] {
		display: none;
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
				<section id="banner">
					<div style = "width:100%";>
						<tr>
						<table border="1px" >
							<colgroup>
								<!-- column 의 설정을 할수 있다. -->
								<col style="width:200px;">
								<col style="width:320px;">
								<col style="width:120px;">
							</colgroup>
							<thead>
								<tr>
									<th>제품코드</th>
									<th>제품명</th>
									<th>주문수량</th>
									<th>1대당 작업시간 (초)</th>
								</tr>
							</thead>

							<tbody ></tbody>
							
							<tfoot>
								<form method = "post" action = "enrollAction.cst">
                                	<!--<td>
	                                	<input type="text" placeholder="제품코드" name = pcode class="text" required="required">
	                                	<td><input type="text" placeholder="제품명" name = pname class="text" required="required"></td>
										<td><input type="number" placeholder="주문수량" name = ordernum required="required"></td>
										<td><input type="number" placeholder="개당 작업시간" name = ftime required="required"></td>									                                 	
	                                   	<td><input type="submit" value="추가" class="primary" /></td>
	                                	-->
	                                	<td>
	                                	<select name="pcode" required onchange="product_complete()">
										    <option disabled selected>제품코드</option>
										    <c:forEach items="${product}" var="product">
										    	<option value="${product.code}"><c:out value="${product.code}"/></option>
										    </c:forEach>
										</select>
										</td>
										<td><input type="text" placeholder="제품명" value="" name = "pname" required="required"></td>
										<td><input type="number" placeholder="주문수량" name = "ordernum" required="required"></td>
										<td><input type="number" placeholder="개당 작업시간" value="" name = "ftime" required="required"></td>									                                 	
	                                   	<td><input type="submit" value="추가" class="primary" /></td>
                                	</td>
									
                                </form>
                                <form method = "post" action = "resetAction.cst">
                                	<td><input type="submit" value="현황판 초기화" class="primary" /></td>
                                </form>								
							</tfoot>
						</table>
						<table border="1px" id="curr_Table">
							<thead>
								<tr>
									<th>번호</th>
									<th>상태</th>
									<th>제품코드</th>
									<th>제품명</th>
									<th>주문수량</th>
									<th>1대당 작업시간 (초)</th>
									
								</tr>
							</thead>
							<c:forEach items="${list}" var="list">
            					<tr>
           							
                					<td><c:out value="${list.tableindex}"/></td>
               						<td><c:out value="${list.state}"/></td>
                					<td><c:out value="${list.pcode}"/></td>
                					<td><c:out value="${list.pname}"/></td>
                					<td><c:out value="${list.ordernum}"/></td>
                					<td><c:out value="${list.ftime}"/></td>
                					
                					
                					<form method = "post" action = "deleteAction.cst" id = deleteAction>
                                		<input type="hidden" name = sindex value = "${list.tableindex}">
                                   	    <td><input type="submit" value="삭제"/></td>
                                    </form>

                                    <form method = "post" action = "startAction.cst" id = startAction>
                                        <input type="hidden" name = sordernum value = "${list.ordernum}">
                                        <input type="hidden" name = sstate value = "${list.state}">
                                        <input type="hidden" name = sindex value = "${list.tableindex}">
                                        <input type="hidden" name = sftime value = "${list.ftime}">
                                 
                                   	    <td><input type="submit" value="시작"/></td>
                                    </form>
                                    
                                    <form method = "post" action = "stopAction.cst" id = startAction>
                                        <input type="hidden" name = scompletenum value = "${list.completenum}">
                                        <input type="hidden" name = sordernum value = "${list.ordernum}"> 
                                		<input type="hidden" name = sindex value = "${list.tableindex}">
                                   	    <td><input type="submit" value="중지"/></td>
                                    </form>
                                    <!-- 추후에 버튼 말고 a 태그에서 controller 작동 할 수 있는 방법을 알면 공간적으로 절약될듯.  -->
            					</tr>
       						</c:forEach>
							<tbody id="currTbody"></tbody>
							<tfoot> </tfoot>
						</table>	
						</tr>
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