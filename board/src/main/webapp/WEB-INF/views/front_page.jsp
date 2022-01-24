<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
	<body class="is-preload" onload="noBack();" onpageshow="if(event.persisted) noBack();" onunload="">

		<!-- Wrapper -->
		<div id="wrapper">
			<div id="main">
				<div class="inner">
				
				<!-- header -->			
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
									this is project for 창명제어기술 board test.
									with Double J.
									</p>
								</div>
						</article>
						<article>
								<div class="content">
								<form method = "post" action = "loginAction.cst">
                                	<input type="text" name="user_id" class="text" required="required" placeholder = " NFC "/>
                                	<input type="text" name="user_passward" class="text" required="required" placeholder = " 비밀번호 "/>
                                	<p></p>
                                	<input type="submit" value="로그인" class="primary" />
                                </form>
								</div>
						</article>
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