<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Date"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page
	import="java.io.PrintWriter, java.util.ArrayList, java.net.URLEncoder"%>
<%@ page import="java.net.URLEncoder"%>
<%@page import="com.board.bean.global_bean"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<%
	String userId = (String) session.getAttribute("userId");

boolean login = userId == null ? false : true;

if (login) {

	String userAccess = (String) session.getAttribute("userAccess");

	boolean access = userAccess.equals("A") || userAccess.equals("B") ? false : true;

	if (access) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('접근권한이 없습니다.');");
		script.println("location.href = 'stay.cst';");
		script.println("</script>");
		script.close();
	} else {

	}
	System.out.println(access);
	//C 인 사람만 입력칸 버튼 누르지 못하게 할 예정
%>
<%
	} else {
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
String user_id = (String) request.getAttribute("user_id");
global_bean gb = null;

try {
	gb = (global_bean) request.getAttribute("gb");
} catch (java.lang.NullPointerException e) {

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
<meta name="viewport"
	content="width=device-width, initial-scale=1, user-scalable=no" />
<link rel="stylesheet" href="resources/assets/css/main.css" />
<!--  비동기 처리를 위한 AJAX 사용 -->
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
</head>
<script type="text/javascript">
	window.history.forward(1);
	function noBack() {
		window.history.forward(1);
	}
</script>
<style>
select option[value=""][disabled] {
	display: none;
}
</style>
<!--  layout body  -->
<body class="is-preload" onload="noBack();"
	onpageshow="if(event.persisted) noBack();" onunload="">
	<!-- Wrapper -->
	<div id="wrapper">
		<div id="main">
			<div class="inner">

				<!-- header -->
				<%@include file="layout/header.jsp"%>
				<section id="banner">
					<div style="width: 100%;">
						<tr>
							<table border="1px">
								<thead>
									<tr>
										<th style="width: 20%;">제품코드</th>
										<th style="width: 50%;">제품명</th>
										<th style="width: 15%;">주문수량</th>
										<th style="width: 15%;">1대당 작업시간 (초)</th>
									</tr>
								</thead>

								<tbody></tbody>

								<tfoot>
									<form method="post" action="enrollAction.cst">
										<!--<td>
	                                	<input type="text" placeholder="제품코드" name = pcode class="text" required="required">
	                                	<td><input type="text" placeholder="제품명" name = pname class="text" required="required"></td>
										<td><input type="number" placeholder="주문수량" name = ordernum required="required"></td>
										<td><input type="number" placeholder="개당 작업시간" name = ftime required="required"></td>									                                 	
	                                   	<td><input type="submit" value="추가" class="primary" /></td>
	                                	-->
	                                	<td><input type="text" name="pcode" placeholder="제품코드" id="searchInput" required="required"></td>
										<td><input type="text" placeholder="제품명" value=""
											name="pname" required="required"></td>
										<td><input type="text" placeholder="주문수량" name="ordernum"
											required="required"></td>
										<td><input type="text" placeholder="개당 작업시간" value=""
											name="ftime" required="required"></td>
										<td><input type="submit" value="추가" class="primary" /></td>
										</td>

									</form>
									<form method="post" action="resetAction.cst">
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

										<td><c:out value="${list.tableindex}" /></td>
										<td><c:out value="${list.state}" /></td>
										<td><c:out value="${list.pcode}" /></td>
										<td><c:out value="${list.pname}" /></td>
										<td><c:out value="${list.ordernum}" /></td>
										<td><c:out value="${list.ftime}" /></td>


										<form method="post" action="deleteAction.cst" id=deleteAction>
											<input type="hidden" name=sindex value="${list.tableindex}">
											<td><input type="submit" value="삭제" /></td>
										</form>

										<form method="post" action="startAction.cst" id=startAction>
											<input type="hidden" name=sordernum value="${list.ordernum}">
											<input type="hidden" name=sstate value="${list.state}">
											<input type="hidden" name=sindex value="${list.tableindex}">
											<input type="hidden" name=sftime value="${list.ftime}">
											<input type="hidden" name=scompletenum
												value="${list.completenum}">
											<td><input type="submit" value="시작" /></td>
										</form>

										<form method="post" action="stopAction.cst" id=stoptAction>
											<input type="hidden" name=sordernum value="${list.ordernum}">
											<input type="hidden" name=sindex value="${list.tableindex}">
											<td><input type="submit" value="중지" /></td>
										</form>
										<!-- 추후에 버튼 말고 a 태그에서 controller 작동 할 수 있는 방법을 알면 공간적으로 절약될듯.  -->
									</tr>
								</c:forEach>
								<tbody id="currTbody"></tbody>
								<tfoot>
								</tfoot>
							</table>
						</tr>
					</div>
				</section>
			</div>
		</div>
		<!-- Sidebar -->
		<%@include file="layout/sidebar.jsp"%>
	</div>

	<!-- Scripts -->
	<script src="resources/assets/js/jquery.min.js"></script>
	<script src="resources/assets/js/browser.min.js"></script>
	<script src="resources/assets/js/breakpoints.min.js"></script>
	<script src="resources/assets/js/util.js"></script>
	<script src="resources/assets/js/main.js"></script>
	<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
	<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
	<script>
		function product_complete() {

			var code = $("input[name='pcode']").val();

			var product_obj = ${product_json};

			console.log(product_obj);

			function find_code(element) {
				if (element.code == code) {
					console.log(code);
					return true;
				}
			}

			var tproduct = product_obj.find(find_code);

			$('input[name=pname]').attr('value', tproduct.name);
			$('input[name=ftime]').attr('value', tproduct.time);
		}
	</script>
	<script>
		// ref: https://programmer93.tistory.com/2
		$(function() { //화면 다 뜨면 시작
			$("#searchInput").autocomplete({
				source : function(request, response) {
					$.ajax({
						url : "/wordSearchShow.action",
						type : "get",
						data : {
							"searchWord" : $("#searchInput").val()
						},
						dataType : "json",
						success : function(data) {
							//서버에서 json 데이터 response 후 목록에 추가
							response($.map(data, function(item) { //json[i] 번째 에 있는게 item 임.
								return {
									label : item,
									value : item, //그냥 사용자 설정값?
									test : item + "test" //이런식으로 사용
								}
							}));
						}
					});
				}, // source 는 자동 완성 대상
				select : function(event, ui) { //아이템 선택시
					console.log(ui);//사용자가 오토컴플릿이 만들어준 목록에서 선택을 하면 반환되는 객체
					console.log(ui.item.label);
					console.log(ui.item.value);
					console.log(ui.item.test);

				},
				focus : function(event, ui) { //포커스 가면
					return false;//한글 에러 잡기용도로 사용됨
				},
				minLength : 1,// 최소 글자수
				autoFocus : true, //첫번째 항목 자동 포커스 기본값 false
				classes : { //잘 모르겠음
					"ui-autocomplete" : "highlight"
				},
				delay : 500, //검색창에 글자 써지고 나서 autocomplete 창 뜰 때 까지 딜레이 시간(ms)
				//        disabled: true, //자동완성 기능 끄기
				position : {
					my : "right top",
					at : "right bottom"
				}, //잘 모르겠음
				close : function(event) { //자동완성창 닫아질때 호출
					console.log(event);
					product_complete();
				}
			}).autocomplete("instance")._renderItem = function(ul, item) { //요 부분이 UI를 마음대로 변경하는 부분
				return $("<li>") //기본 tag가 li로 되어 있음 
				.append("<div>" + item.value + "</div>") //여기에다가 원하는 모양의 HTML을 만들면 UI가 원하는 모양으로 변함.
				.appendTo(ul);
			};

		});
	</script>

</body>
</html>