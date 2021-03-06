<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>디테일</title>
<link href="https://fonts.googleapis.com/icon?family=Material+Icons"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://use.fontawesome.com/releases/v5.14.0/css/all.css"
	integrity="sha384-HzLeBuhoNPvSl5KYnjx0BT+WB0QEEqLprO+NBkkk5gbc67FTaL7XIGa2w1L0Xbgc"
	crossorigin="anonymous">
<style>
.container {
	text-align: center;
}

.content {
	width:100%;
	margin: 5px auto;
	line-height: 30px;
}

.container h1 {
	margin-top: 50px;
}

.menu {
	display: inline-block;
	margin-top: 10px;
	margin-left: 50px;
}

.menu form {
	display: inline-block;
}

a {
	text-decoration: none;
	color: grey;
	padding-left: 10px;
}

#tolist {
	margin-left: 250px;
}

#title {
	font-size: 1.8em;
	font-weight: bold;
	color: #DBC9EC;
	padding: 10px;
}

#ctnt {
	width: 40%;
	font-size: 1.1em;
	margin: 5px auto;
	background-color: #F0E9F7;
	padding: 50px;
	border-radius: 20%;
}
#ctnt>img{
	width:80%;
}

.sub {
	font-size: 0.8em;
	color: grey;
	display : inline-block;
}

#nm, #m_dt, #hits {display : inline-block; margin-left:30px;}

#like {
	margin-left: 20px;
}

.pointerCursor {
	cursor: pointer;
}

.material-icons {
	color: #f5d1ca;
}

.likelist {
	
}
.like_hate_btn {
	list-style-type:none;
}
.cmt {margin: 30px;}
.cmt table {margin:10px auto;}
.cmt th, td {padding-left:30px; height:25px;}

#cmt_r_dt {font-size:0.8em;}
#cmtupdFrm {display:inline-block;}
#cmttext{margin-top:40px;}
</style>
</head>
<body>
	<div class="container">
		<h1></h1>

		<div class="content">
			<div id="title">${vo.title}</div>
			<div class="sub">
				<div id="nm">작성자 : ${vo.nm}</div>
				<div id="m_dt">수정일시: ${vo.m_dt}</div>
				<div id="hits">조회수 : ${vo.hits}</div>
			</div>

				<div class="pointerCursor" onclick="toggleLike(${vo.yn_like})">
					<c:if test="${vo.yn_like == 1}">
						<i class="fas fa-thumbs-up"></i>
					</c:if>
					<c:if test="${vo.yn_like == 0}">
						<i class="far fa-thumbs-up"></i>
					</c:if>
					${likelist.size() }
				</div>

			<div class="likelist">
				<c:forEach items="${likelist}" var="like">
					${like.nm}
				</c:forEach>
				<c:if test="${likelist.size() != 0}">
					님이 좋아합니다.
				</c:if>
			</div>
			<div id="ctnt">${vo.ctnt}</div>

		</div>
		<div class="menu">
			<a href="/board/list?page=${param.page }&record_cnt=${param.record_cnt}&searchText=${param.searchText}" id="tolist">리스트로</a>
			<c:if test="${loginUser.i_user == vo.i_user }">
				<a href="/board/regmod?i_board=${vo.i_board}">수정</a>
				<form id="delFrm" action="/board/del" method="post">
					<input type="hidden" name="i_board" value="${vo.i_board }">
					<a href="#" onclick="submitDel()">삭제</a>
				</form>
			</c:if>
		</div>
		
		<div>
			<form id="cmtFrm" action ="/board/cmt" method="post">
				<input type="hidden" id="updvalue" name="i_cmt" value="0">
				<input type="hidden" name="i_board" value="${vo.i_board}">
				<div>
					<input type="text" name="cmt" id="cmttext" placeholder="댓글내용">
					<input type="submit" id="cmtSubmit" value="전송">
					<input type="button" value="취소" onclick="clkCmtCancel()">
				</div>
			</form>
		</div>
		
		<div class="cmt">
			댓글 리스트
			<table>
				<c:forEach items="${cmtlist}" var="cmt" varStatus="status">
					<tr>
						<th id="cmt_count">${status.count}</th>
						<td id="cmt_cmt">${cmt.cmt}</td>
						<td id="cmt_nm">${cmt.nm} </td>
						<td id="cmt_r_dt">${cmt.r_dt==cmt.m_dt ? cmt.r_dt : cmt.m_dt }</td>
						
						<td> 
							<c:if test="${loginUser.i_user == cmt.i_user}">
									<a id="updcmt" href="#" onclick="updateCmt('${cmt.cmt}','${cmt.i_cmt }')">수정</a>
									<a href="#" onclick="cmtdel(${cmt.i_cmt})">삭제</a>
							</c:if>
						</td>
					</tr>
				</c:forEach>
			</table>
		</div>
	</div>
	<script>

		function submitDel(){
			if(confirm("삭제하시겠습니까?")){
				delFrm.submit();
			}
		}
		
		function submitMod(){
			modFrm.submit();
		}
		
		function toggleLike(yn_like){
			location.href="/board/toggleLike?i_board=${vo.i_board}&yn_like="+yn_like+"&page=${param.page}&record_cnt=${param.record_cnt}&searchText=${searchText}";
		}
		
		function updateCmt(text,i_cmt){
			cmtFrm.i_cmt.value=i_cmt;
			cmttext.value=text;
			cmtSubmit.value='수정';
		}
		
		function clkCmtCancel(){
			cmtFrm.i_cmt.value = 0;
			cmtFrm.cmt.value = '';
			cmtSubmit.value='전송';
		}
		
		function cmtdel(i_cmt){
			if(confirm("삭제하시겠습니까?")) {
				location.href="/board/cmt?i_cmt=" + i_cmt + "&i_board=${vo.i_board}";
			}
		}
	</script>
</body>
</html>