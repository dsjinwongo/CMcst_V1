
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter, java.util.ArrayList, java.net.URLEncoder" %>
<%@ page import="java.util.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%
String userId = (String)session.getAttribute("userId");

boolean login = userId == null ? false : true;

	if(login){
	
	String userAccess = (String)session.getAttribute("userAccess");
	boolean access = userAccess.equals("C") ? true : false;
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
<!DOCTYPE html>

<html>
	<!--  layout header -->
	<head>
		<title>창명제어기술</title>
		<meta charset="utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />
		<link rel="stylesheet" href="resources/assets/css/main.css" />
	</head>
	
	<!--  layout body  -->
	<body class="is-preload">
		<!-- Wrapper -->
		<div id="wrapper">
			<div id="main">
				<div class="inner">
				
				<!-- header -->
				<%@include file = "layout/header.jsp" %>

				<section id="banner">
					<!--  body -->
					<div class="content">
					<!-- 검색란 -->
						<h2 style="text-align:center">커뮤니티 게시판</h2>	
							<font size = "4.8em">
								
								<table id="com_board">
									<tr id="tr_top">
										<th style="text-align:left;">번호</th>
										<th>제목</th>
										<th>글쓴이</th>
										<th>등록일</th>
										<th>조회</th>
									</tr>
									<tr>
										<!-- 번호 -->
										<td style="text-align:left; padding-left:12px"></td>
										<!-- [카테고리]제목 -->
										<td style="text-align:left;">
										</td>
										<!-- 글쓴이 -->
										<!-- 등록일 -->
										<!-- 조회 -->
									</tr>
									<tr>
										<td></td>
										<td></td>
										<td></td>
										<td></td>
										<td></td>
									</tr>
								</table>
							</font>				
							<form method = "post" class = "search">
								<div class="row gtr-uniform">
									<div class="col-2 col-3-xsmall">
										<select name = "searchDivide">
											<option value = "1"><% %>전체</option>
											<option value = "1"><% %>제목</option>
											<option value = "1"><% %>작성자</option>
										</select>
									</div>
									<div class="col-5 col-5-xsmall">
										<input type="text" name="query" id="query" placeholder="Search" />
									</div>	
									<div class="col-3 col-3-xsmall">
										<input class="write_btn" type="submit" value="검색">
									</div>
									<!-- 글쓰기 버튼의 경우 data-target contentRegi에 따라 작동 따라서 해당 jsp 문은 id를 data-target으로 하는 div에 연결된다.  -->
									<div class="col-1 col-1-xsmall">
										<input class="write_btn" type="button" value="글쓰기" data-target = "#contentRegi">
									</div>
								</div>
							</form>
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