<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<div id="sidebar">
		<div class="inner">
			<!-- Search -->
			<section id="search" class="alt">
				<!-- 이 action 자리에 회원가입 같은 동작 액션이 들어간다. form에서의 action은 data-target과는 다르기 때문에 주의해야한다. -->
				<form method="post" action="#">
					<input type="text" name="query" id="query" placeholder="Search" />
				</form>
			</section>
			
			<!-- Menu -->
			<nav id="menu">
				<header class="major">
					<h2>
						<a href="logoutAction.cst">로그아웃</a>
					</h2>
				</header>
				<ul>
				<font size = "4em">
					<li>
						<a href="fp.cst">Homepage</a><p></p><!--  info 란도 이곳에 한번에 만들기. use button -->
						<a href="cs.cst">current state</a><p></p>
						<a href="regi.cst">new registragion</a><p></p>
						<a href="work.cst">work enroll</a><p></p>
						<a href="new_product.cst">new product</a><p></p>
					</li>
				</font>
					<!--  opener sub menu list 
					<li>
						<span class="opener">Submenu</span>
						<ul>
							<li><a href="#">Lorem Dolor</a></li>
							<li><a href="#">Ipsum Adipiscing</a></li>
							<li><a href="#">Tempus Magna</a></li>
							<li><a href="#">Feugiat Veroeros</a></li>
						</ul>
					</li>
					-->
				</ul>
			</nav>
			<!-- Section -->
			
			<!-- Footer -->
			<footer id="footer">
				<p class="copyright">&copy; Untitled. All rights reserved. Demo Images: <a href="https://unsplash.com">Unsplash</a>. Design: <a href="https://html5up.net">HTML5 UP</a>.</p>
			</footer>
			</div>
		</div>
	</body>
</html>