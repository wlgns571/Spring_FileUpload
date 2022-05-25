<%@page import="com.study.code.vo.CodeVO"%>
<%@page import="com.study.code.service.CommCodeServiceImpl"%>
<%@page import="com.study.code.service.ICommCodeService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!-- FreeBoardVO의 작성양식의 틀렸을때 message의 출력 용도 -->

<!DOCTYPE html>
<html lang="ko">
<head>
<%@include file="/WEB-INF/inc/header.jsp"%>
</head>
<body>
	<%@ include file="/WEB-INF/inc/top.jsp"%>


	<div class="container">
		<div class="page-header">
			<h3>
				자유게시판 - <small>글 등록</small>
			</h3>
		</div>

		<form:form action="freeRegist.wow" method="post"
			modelAttribute="freeBoard" enctype="multipart/form-data">
			<%-- 	<form action="freeRegist.wow" method="post">	 --%>
			<table class="table table-striped table-bordered">
				<colgroup>
					<col width="20%" />
					<col />
				</colgroup>
				<tr>
					<th>제목</th>
					<td>
						<!-- 			<input type="text" name="boTitle" value="" class="form-control input-sm"  required="required" > -->
						<form:input path="boTitle" cssClass="form-control input-sm" /> <form:errors
							path="boTitle"></form:errors>
					</td>
				</tr>
				<tr>
					<th>작성자</th>
					<td>
						<!-- 			<input type="text" name="boWriter" value=""  class="form-control input-sm" required="required" > -->
						<form:input path="boWriter" cssClass="form-control input-sm" /> <form:errors
							path="boWriter"></form:errors> <%-- 			<input type="text" name="boWriter" value="${freeBoard.boWriter }"> --%>
					</td>
				</tr>
				<tr>
					<th>비밀번호</th>
					<td>
						<!-- 			<input type="password" name="boPass" value="" class="form-control input-sm"  -->
						<!-- 			           required="required" pattern="\w{4,}" title="알파벳과 숫자로 4글자 이상 입력"  > -->
						<form:password path="boPass" cssClass="form-control input-sm" />
						<form:errors path="boPass"></form:errors> <span
						class="text-danger"> <span
							class="glyphicon glyphicon-exclamation-sign" aria-hidden="true"></span>
							수정 또는 삭제시에 필요합니다.
					</span>
					</td>
				</tr>
				<tr>
					<th>분류</th>
					<td>
						<!-- 				<select name="boCategory" class="form-control input-sm" required="required"> -->
						<!-- 					<option value="">-- 선택하세요--</option> --> <%-- 					<c:forEach items="${cateList }" var="category"> --%>
						<%-- 					 <option value="${category.commCd }">${category.commNm }</option> --%>
						<%-- 					</c:forEach>							 --%> <!-- 				</select>	 --> <form:select
							path="boCategory" cssClass="form-control input-sm">
							<form:option value="">-선택하세요-</form:option>
							<form:options items="${cateList }" itemLabel="commNm"
								itemValue="commCd" />
						</form:select>

					</td>
				</tr>
				<tr>
					<th>IP</th>
					<td><%=request.getRemoteAddr()%> <input type="hidden"
						name="boIp" value="<%=request.getRemoteAddr()%>"></td>
				</tr>
				<tr>
					<th>내용</th>
					<td>
						<!-- 				<textarea rows="10" name="boContent" class="form-control"></textarea> -->
						<form:textarea path="boContent" cssClass="form-control input-sm"
							rows="10" /> <form:errors path="boContent"></form:errors>
					</td>
				</tr>
				<tr>
					<th>첨부파일
						<button type="button" id="id_btn_new_file">추가</button>
					</th>
					<td class="file_area">
						<div class="form-inline">
							<input type="file" name="boFiles" class="form-control">
							<button type="button" class="btn_delete btn btn-sm">삭제</button>
						</div>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<div class="pull-left">
							<a href="freeList.wow" class="btn btn-default btn-sm"> <span
								class="glyphicon glyphicon-list" aria-hidden="true"></span>
								&nbsp;&nbsp;목록
							</a>
						</div>
						<div class="pull-right">
							<button type="submit" class="btn btn-sm btn-primary">
								<span class="glyphicon glyphicon-save" aria-hidden="true"></span>
								&nbsp;&nbsp;저장
							</button>
						</div>
					</td>
				</tr>
			</table>
		</form:form>
		<%-- 	</form> --%>

	</div>
	<!-- container -->

</body>
<script type="text/javascript">
	$('#id_btn_new_file')
			.click(
					function() {
						$('.file_area')
								.append(
										'<div class="form-inline">'
												+ '<input type="file" name="boFiles" class="form-control">'
												+ ' <button type="button" class="btn_delete btn btn-sm">삭제</button>'
												+ '</div>');
					});

	$('.file_area').on('click', '.btn_delete', function() {
		$(this).closest('div').remove();
	});
</script>
</html>


