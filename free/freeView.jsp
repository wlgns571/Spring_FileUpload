<%@page import="com.study.exception.BizNotEffectedException"%>
<%@page import="com.study.exception.BizNotFoundException"%>
<%@page import="com.study.free.service.FreeBoardServiceImpl"%>
<%@page import="com.study.free.service.IFreeBoardService"%>
<%@page import="com.study.free.vo.FreeBoardVO"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/inc/header.jsp"%>
<title>자유게시판 - 글 보기</title>
</head>
<body>
	<%@ include file="/WEB-INF/inc/top.jsp"%>
		<div class="container">
			<div class="page-header">
				<h3>
					자유게시판 - <small>글 보기</small>
				</h3>
			</div>
			<table class="table table-striped table-bordered">
				<tbody>
					<tr>
						<th>글번호</th>
						<td>${freeBoard.boNo }</td>
					</tr>
					<tr>
						<th>글제목</th>
						<td>${freeBoard.boTitle }</td>
					</tr>
					<tr>
						<th>글분류</th>
						<td>${freeBoard.boCategoryNm }</td>
					</tr>
					<tr>
						<th>작성자명</th>
						<td>${freeBoard.boWriter }</td>
					</tr>
					<!-- 비밀번호는 보여주지 않음  -->
					<tr>
						<th>내용</th>
						<td><textarea rows="10" name="boContent" class="form-control input-sm">
						${freeBoard.boContent }
					</textarea></td>
					</tr>
					<tr>
						<th>등록자 IP</th>
						<td>${freeBoard.boIp }</td>
					</tr>
					<tr>
						<th>조회수</th>
						<td>${freeBoard.boHit }</td>
					</tr>
					<tr>
						<th>최근등록일자</th>
						<td>${freeBoard.boModDate eq null  ? freeBoard.boRegDate : freeBoard.boModDate}</td>
					</tr>
					<tr>
						<th>삭제여부</th>
						<td>${freeBoard.boDelYn }</td>
					</tr>
					<tr>
						<td colspan="2">
							<div class="pull-left">
								<a href="freeList.wow" class="btn btn-default btn-sm"> <span class="glyphicon glyphicon-list" aria-hidden="true"></span> &nbsp;&nbsp;목록
								</a>
							</div>
							<div class="pull-right">
								<a href="freeEdit.wow?boNo=${freeBoard.boNo }" class="btn btn-success btn-sm"> <span class="glyphicon glyphicon-pencil" aria-hidden="true"></span> &nbsp;&nbsp;수정
								</a>
							</div>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		<!-- container -->
		<div class="container">
		<!-- reply container -->
		<!-- // START : 댓글 등록 영역  -->
		<div class="panel panel-default">
			<div class="panel-body form-horizontal">
				<form name="frm_reply" action="<c:url value='/reply/replyRegist' />"
					method="post" onclick="return false;">
					<input type="hidden" name="reParentNo" value="${freeBoard.boNo}">
					<input type="hidden" name="reCategory" value="FREE"> <input
						type="hidden" name="reMemId" value="${USER_INFO.userId }">
					<input type="hidden" name="reIp"
						value="<%=request.getRemoteAddr()%>">
					<div class="form-group">
						<label class="col-sm-2  control-label">댓글</label>
						<div class="col-sm-8">
							<textarea rows="3" name="reContent" class="form-control"
							${USER_INFO == null ? "readonly" : ""}></textarea>
							<!--  로그인 안되어있으면 readOnly -->
						</div>
						<div class="col-sm-2">
							<button id="btn_reply_regist" type="button"
								class="btn btn-sm btn-info">등록</button>
						</div>
					</div>
				</form>
			</div>
		</div>
		<!-- // END : 댓글 등록 영역  -->
		<!-- // START : 댓글 목록 영역  -->
		<div id="id_reply_list_area">
<!-- 			<div class="row"> -->
<!-- 				<div class="col-sm-2 text-right">홍길동</div> -->
<!-- 				<div class="col-sm-6"> -->
<!-- 					<pre>내용</pre> -->
<!-- 				</div> -->
<!-- 				<div class="col-sm-2">12/30 23:45</div> -->
<!-- 				<div class="col-sm-2"> -->
<!-- 					<button name="btn_reply_edit" type="button" -->
<!-- 						class=" btn btn-sm btn-info" onclick="fn_modify()">수정</button> -->
<!-- 					<button name="btn_reply_delete" type="button" -->
<!-- 						class="btn btn-sm btn-danger">삭제</button> -->
<!-- 				</div> -->
<!-- 			</div> -->
<!-- 			<div class="row"> -->
<!-- 				<div class="col-sm-2 text-right">그댄 먼곳만 보네요</div> -->
<!-- 				<div class="col-sm-6"> -->
<!-- 					<pre> 롤링롤링롤링롤링</pre> -->
<!-- 				</div> -->
<!-- 				<div class="col-sm-2">11/25 12:45</div> -->
<!-- 				<div class="col-sm-2"></div> -->
<!-- 			</div> -->
		</div>
		<div class="row text-center" id="id_reply_list_more">
			<a id="btn_reply_list_more"
				class="btn btn-sm btn-default col-sm-10 col-sm-offset-1"> <span
				class="glyphicon glyphicon-chevron-down" aria-hidden="true"></span>
				더보기
			</a>
		</div>
		<!-- // END : 댓글 목록 영역  -->
		<!-- START : 댓글 수정용 Modal -->
		<div class="modal fade" id="id_reply_edit_modal" role="dialog">
			<div class="modal-dialog">
				<!-- Modal content-->
				<div class="modal-content">
					<form name="frm_reply_edit"
						action="<c:url value='/reply/replyModify' />" method="post"
						onclick="return false;">
						<div class="modal-header">
							<button type="button" class="close" data-dismiss="modal">×</button>
							<h4 class="modal-title">댓글수정</h4>
						</div>
						<div class="modal-body">
							<input type="hidden" name="reNo" value="">
							<textarea rows="3" name="reContent" class="form-control"></textarea>
							<input type="hidden" name="reMemId" value="${USER_INFO.userId }">
						</div>
						<div class="modal-footer">
							<button id="btn_reply_modify" type="button"
								class="btn btn-sm btn-info">저장</button>
							<button type="button" class="btn btn-default btn-sm"
								data-dismiss="modal">닫기</button>
						</div>
					</form>
				</div>
			</div>
		</div>
		<!-- END : 댓글 수정용 Modal -->
	</div>
	<!-- reply container -->
	
</body>
<script type="text/javascript">
// ajax 로 비동기요청 ReplyController
//	  success : function(data) { 요안에서 data 내 DB에서 얻은 ReplyVO 목록 가지고
//		  댓글목록에다가 추가해주면 되지 ...}	
var params = {"reParentNo": ${freeBoard.boNo }, "curPage": 1 , "reCategory" : "FREE", "rowSizePerPage" : 10};
	function fn_reply_list(){
		$.ajax({
			url: "<c:url value='/reply/replyList.wow'/>"
			,data: params
			,dataType : "json" // 받을 때 json 이어야 한다. 지워도댐 spring 알아서 해줘서 ?
			,success : function(data){ // Controller가 return 한 것이 json 형태로 넘어옴
							console.log(data);
							$.each(data, function(i, elt){
						
								var str = "";
								str += str + '<div class="row" data-reNo="'+ data[i].reNo+'">'
										+ '<div class="col-sm-2 text-right">'+ data[i].reMemName+'</div>'
										+ '<div class="col-sm-6">'
										+ '<pre>'+ data[i].reContent +'</pre>'
										+ '</div>'
										+ '<div class="col-sm-2">'+ data[i].reRegDate+'</div>'
										+ '<div class="col-sm-2">';
										
										if(data[i].reMemId == "${USER_INFO.userId }"){
											str = str +
											  '<button name="btn_reply_edit" type="button"'
											+ 'class="btn btn-sm btn-info">수정</button>'
											+ '<button name="btn_reply_delete" type="button"'
											+ 'class="btn btn-sm btn-danger">삭제</button>';	
										}
										str = str + '</div>'
										+ '</div>';
										$("#id_reply_list_area").append(str);	
								}); // each
								params.curPage+=1;
			},error: function(req){
				
			}
		});
	}
	
	$(document).ready(function(){
		fn_reply_list(); // 처음에 댓글 10개 보여주기
		// 더보기 버튼 누를 때마다 fn_reply_list()에서 다음 10개 보여주기 할 거 같습니다ㅣ.
		$("#btn_reply_list_more").on("click", function(e){
			e.preventDefault();
			fn_reply_list();
		});
		
		//등록버튼
		//현재 버튼의 상위 form 태그 찾기
		// form 태그에서 파라미터 넘겨야하는건 input type hidden으로 해놓음
		// 필요한 파라미터 전부 넘기기 /reply/replyRegist.wow로 요청해서 DB에 저장하기
		// 컨트롤러에서 regist.wow 메소드 만들면 되고, 매개변수 어떻게 쓸까?
				
		// 서버에서 DB에 넣고나서 return 했다면
		// success 함수에서 댓글목록 초기화 합시다
		// 댓글목록초기화 : 현재있는 댓글목록 삭제 후, 다시 처음 10개 보여주기 (새로 댓글 등록한게 맨 위에 있겠지 ..)
		$("#btn_reply_regist").on("click", function(e){
				e.preventDefault();
				$form=$(this).closest("form[name='frm_reply']");
// 				console.log($(this).closest("form[name='frm_reply']")[0]);
			$.ajax({
				  url :"<c:url value='/reply/replyRegist.wow'/>"
				, data: $form.serialize() // 넘어가는 파라미터들을 json 으로 바꿔줌.( reContent, reMemId, reIp, reCategory, reParentNo )
				, type : "POST"
				, dataType :"JSON"
				, success : function(data){
					console.log(data);
					alert(data.data);
 					$form.find("textarea[name='reContent']").val('');
 					$("#id_reply_list_area").html('');
 					params.curPage=1;
					fn_reply_list();
				},error: function(req){
					console.log(req.status);
					if(req.status==401){
						location.href="<c:url value='/login/login.wow'/>";
					}
				}
				
			});
		}); // 등록버튼
		
		
		
		// 삭제버튼
		// 삭제버튼 상위 div에서 data-reno로 reno랑 reMemId를 같이 파라미터로 ajax 호출
		// 서버에서 DB 삭제 무조건 삭제 에러 신경쓰지말고 ...
		// 삭제 성공 후에 내가 누른 삭제버튼의 댓글 삭제
		$("#id_reply_list_area").on("click", 'button[name="btn_reply_delete"]',function(e){
			e.preventDefault();
 			$div=$(this).closest('.row'); //여기서 this = $("#id_reply_list_area")
			reNo= $div.data('reno');
			reMemId="${USER_INFO.userId}";
			console.log(reMemId);
			$.ajax({
				url : "<c:url value='/reply/replyDelete.wow'/>",
				type : "POST",
				data : {"reNo" : reNo, "reMemId" : "${USER_INFO.userId}"},
				dataType : "JSON",
				success : function(){
// 					$(this).closest('.row').remove();  여기서 this = function
					$div.remove();
				},
				error : function(){
					
				}
				
			});
		});
		
		
/* 		$("#id_reply_list_area").on("click". "button[name='btn_reply_edit']",function(e){
			$div = $(this).closest(".row");//댓글 div
			let reNo = $div.data("reno");
			let reContent =$div.find("pre").html("");
			let $modal = $("#id_reply_edit_modal");
			let $medalForm = $modal.find("form[name='frm_reply_edit']");
			$modalForm.find("input[name='reNo']").val(reNo);
			$modalForm.find("textarea[name='reContent']").val(reContent);
			$("#id_reply_edit_modal").modal("show");
		} *///모달창 띄우고 안에 내용 받아오기 
		
		
		
		
		
		//모달저장
		// 모달의 form 태그 찾아서 form.serialize() 이용해서
		//a.jax 요청
		// 서버에서 update하기 (예외처리나중에)
		// 성공했으면 댓글초기화(댓글목록 삭제 후 처음 10 개 보여주기)
		$("#btn_reply_modify").on("click", function(e){
			console.log($("form[name='frm_reply_edit']")[0]);
// 			$modal = $("#id_reply_edit_modal");
// 			let $modalForm = $modal.find("form[name = 'frm_reply_edit']");
			$.ajax({
				url : "<c:url value='/reply/replyModify.wow'/>",
				data : $("form[name='frm_reply_edit']").serialize(),
// 				data: $modalFomr.serialize()
				success: function(data){
					//댓글 목록 내용 지우고 다시 curPage=1, fn_reply_list
					$("#id_reply_list_area").html('');
 					params.curPage=1;
					fn_reply_list();
					 $('#id_reply_edit_modal').modal("hide");
					
					 //초기화 말고 , 해당댓글 그냥 내용 수정만......
				},
				error : function(req){
					console.log(req);
				}
					
				
			});
			
		});// 모달 저장
		
		
		
		
		
		// 수정버튼
		//모달창 찾기, 모달창 나타나게 하기
// 		$("#id_reply_list_area").on("click","button[name='btn_reply_edit']",Function(e){
// 			$div=$(this).closest(".row");
// 			alert($div.date("reno"));
// 			$("#id_reply_edit_modal").modal("show")
// 		});
		// 수정버튼 누른 댓글의 상위 div에 data-reno가 있어요. 그 댓글의 자식중에 댓글내용이 있어요.
		//모달창의 reContent, reNo에 붙여넣기 해주세요
		
		// 모달창 띄우기
		$("#id_reply_list_area").on("click", 'button[name="btn_reply_edit"]',function(e){
			$('#id_reply_edit_modal').modal();
		 	console.log( $(this).closest($('.row')).find('pre').html());
		 	$("#id_reply_edit_modal textarea[name='reContent']").val($(this).closest($(".row")).find('pre').html());
		 	$("input[name='reNo']").val($(this).closest($(".row")).data('reno'));
		
		});//수정버튼
		
		
		
		
		
	}); // document
</script>
</html>