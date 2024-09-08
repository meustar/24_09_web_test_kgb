<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="DETAIL"></c:set>
<%@ include file="../common/head.jspf"%>
<%@ include file="../common/toastUiEditorLib.jspf"%>
<hr />

<!-- <iframe src="http://localhost:8080/usr/article/doIncreaseHitCount?id=757" frameborder="0"></iframe> -->
<!-- 변수 -->
<script>
	const params = {};
	params.id = parseInt('${param.id}');
	params.memberId = parseInt('${loginedMemberId}')
	
	console.log(params);
	console.log(params.id);
	console.log(params.memberId);

	var isAlreadyAddGoodRp = ${isAlreadyAddGoodRp};
	var isAlreadyAddBadRp = ${isAlreadyAddBadRp};
</script>


<section class="mt-24 text-xl px-4">
	<div class="mx-auto">
		<table class="table" border="1" cellspacing="0" cellpadding="5" style="width: 100%; border-collapse: collapse;">
			<tbody>
				<tr>
					<th style="text-align: center;">ID</th>
					<td style="text-align: center;">${article.id}</td>
				</tr>
				<tr>
					<th style="text-align: center;">Registration Date</th>
					<td style="text-align: center;">${article.regDate.substring(0,10)}</td>
				</tr>
				<tr>
					<th style="text-align: center;">Modified date</th>
					<td style="text-align: center;">${article.updateDate}</td>
				</tr>
				<tr>
					<th style="text-align: center;">BoardId</th>
					<td style="text-align: center;">${article.boardId}</td>
				</tr>
				<tr>
					<th style="text-align: center;">Writer</th>
					<td style="text-align: center;">${article.extra__writer}</td>
				</tr>
				<tr>
					<th class="reaction" style="text-align: center;">Like</th>
					<td id="likeCount" style="text-align: center;">${article.goodReactionPoint}</td>
				</tr>
				<tr>
					<th style="text-align: center;">Dislike</th>
					<td id="DislikeCount" style="text-align: center;">${article.badReactionPoint}</td>
				</tr>
				<tr>
					<th style="text-align: center;">LIKE / Dislike / ${usersReaction }</th>
					<td style="text-align: center;">

						<button id="likeButton" class="btn btn-outline btn-success" onclick="doGoodReaction(${param.id})">
							👍 LIKE
							<span class="likeCount">${article.goodReactionPoint}</span>
						</button>
						<button id="DislikeButton" class="btn btn-outline btn-error" onclick="doBadReaction(${param.id})">
							👎 DISLIKE
							<span class="DislikeCount">${article.badReactionPoint}</span>
						</button>
						<%-- 						<a href="/usr/reactionPoint/doGoodReaction?relTypeCode=article&relId=${param.id }&replaceUri=${rq.currentUri}" --%>
						<%-- 							class="btn btn-outline btn-success">👍 LIKE ${article.goodReactionPoint}</a> --%>
						<%-- 						<a href="/usr/reactionPoint/doBadReaction?relTypeCode=article&relId=${param.id }&replaceUri=${rq.currentUri}" --%>
						<%-- 							class="btn btn-outline btn-error">👎 DISLIKE ${article.badReactionPoint}</a> --%>
					</td>
				</tr>

				<tr>
					<th style="text-align: center;">Views</th>

					<td style="text-align: center;">
						<span class="article-detail__hit-count">${article.hitCount}</span>
					</td>
				</tr>
				<tr>
					<th style="text-align: center;">Title</th>
					<td style="text-align: center;">${article.title}</td>
				</tr>
				<tr>
					<th style="text-align: center;">Attached Image</th>
					<td style="text-align: center;">
						<div style="text-align: center;">
							<img class="mx-auto rounded-xl" src="${rq.getImgUri(article.id)}" onerror="${rq.profileFallbackImgOnErrorHtml}" alt="" />
						</div>
						<div>${rq.getImgUri(article.id)}</div>
					</td>
				</tr>
				<tr>
					<th style="text-align: center;">Body</th>
					<td>
						<div class="toast-ui-viewer">
							<script type="text/x-template">${article.body}</script>
						</div>
					</td>
				</tr>

			</tbody>
		</table>
		<div class="btns">
			<button class="btn" type="button" onclick="history.back()">뒤로가기</button>
			<c:if test="${article.userCanModify }">
				<a class="btn" href="../article/modify?id=${article.id }">수정</a>
			</c:if>
			<c:if test="${article.userCanDelete }">
				<a class="btn" href="../article/doDelete?id=${article.id }">삭제</a>
			</c:if>

		</div>
	</div>
</section>

<script>
	function ReplyWrite__submit(form) {
		console.log(form.body.value);
		
		form.body.value = form.body.value.trim();
		
		if(form.body.value.length < 3){
			alert('3글자 이상 입력해');
			form.body.focus();
			return;
		}
		
		form.submit();
	}
</script>

<!-- 댓글 -->
<section class="mt-24 text-xl px-4">
	<c:if test="${rq.isLogined() }">
		<form action="../reply/doWrite" method="POST" onsubmit="ReplyWrite__submit(this); return false;" )>
			<table class="table" border="1" cellspacing="0" cellpadding="5" style="width: 100%; border-collapse: collapse;">
				<input type="hidden" name="relTypeCode" value="article" />
				<input type="hidden" name="relId" value="${article.id }" />
				<tbody>

					<tr>
						<th>댓글 내용 입력</th>
						<td style="text-align: center;">
							<textarea class="input input-bordered input-sm w-full max-w-xs" name="body" autocomplete="off" type="text"
								placeholder="내용을 입력해"></textarea>
						</td>

					</tr>
					<tr>
						<th></th>
						<td style="text-align: center;">
							<button class="btn btn-outline">작성</button>
						</td>

					</tr>
				</tbody>
			</table>
		</form>
	</c:if>

	<c:if test="${!rq.isLogined() }">
		댓글 작성을 위해 <a class="btn btn-outline btn-primary" href="${rq.loginUri }">로그인</a>이 필요합니다
	</c:if>
	<!-- 	댓글 리스트 -->
	<div class="mx-auto">
		<table class="table" border="1" cellspacing="0" cellpadding="5" style="width: 100%; border-collapse: collapse;">
			<thead>
				<tr>
					<th style="text-align: center;">Registration Date</th>
					<th style="text-align: center;">Writer</th>
					<th style="text-align: center;">Body</th>
					<th style="text-align: center;">Like</th>
					<th style="text-align: center;">Dislike</th>
					<th style="text-align: center;">Edit</th>
					<th style="text-align: center;">Delete</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="reply" items="${replies}">
					<tr class="hover">
						<td style="text-align: center;">${reply.regDate.substring(0,10)}</td>
						<td style="text-align: center;">${reply.extra__writer}</td>
						<td style="text-align: center;">
							<span id="reply-${reply.id }">${reply.body}</span>
							<form method="POST" id="modify-form-${reply.id }" style="display: none;" action="/usr/reply/doModify">
								<input type="text" value="${reply.body }" name="reply-text-${reply.id }" />
							</form>
						</td>
						<td style="text-align: center;">${reply.goodReactionPoint}</td>
						<td style="text-align: center;">${reply.badReactionPoint}</td>
						<td style="text-align: center;">
							<c:if test="${reply.userCanModify }">
								<%-- 								<a class="btn btn-outline btn-xs btn-success" href="../reply/modify?id=${reply.id }">수정</a> --%>
								<button onclick="toggleModifybtn('${reply.id}');" id="modify-btn-${reply.id }" style="white-space: nowrap;"
									class="btn btn-outline btn-xs btn-success">수정</button>
								<button onclick="doModifyReply('${reply.id}');" style="white-space: nowrap; display: none;"
									id="save-btn-${reply.id }" class="btn btn-outline btn-xs">저장</button>
							</c:if>
						</td>
						<td style="text-align: center;">
							<c:if test="${reply.userCanDelete }">
								<a class="btn btn-outline btn-xs btn-error" onclick="if(confirm('정말 삭제?') == false) return false;"
									href="../reply/doDelete?id=${reply.id }">삭제</a>
							</c:if>
						</td>
					</tr>
				</c:forEach>

				<c:if test="${empty replies}">
					<tr>
						<td colspan="4" style="text-align: center;">댓글이 없습니다</td>
					</tr>
				</c:if>
			</tbody>
		</table>
	</div>
</section>



<%@ include file="../common/foot.jspf"%>