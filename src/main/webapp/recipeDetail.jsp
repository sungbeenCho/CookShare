<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.RecipeDao, dao.LikeDao, dao.CommentDao" %>
<%@ page import="dto.Recipe, dto.Member, dto.Comment" %>
<%@ page import="java.util.*, jakarta.servlet.http.Cookie" %>
<%@ include file="header.jsp" %>

<%
    // 로그인 체크
    Member user = (Member) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int recipeId = Integer.parseInt(request.getParameter("recipeId"));

    RecipeDao recipeDao = RecipeDao.getInstance();
    LikeDao likeDao = LikeDao.getInstance();
    CommentDao commentDao = CommentDao.getInstance();

    Recipe r = recipeDao.getRecipeById(recipeId);
    boolean isLiked = likeDao.isLiked(user.getMemberId(), recipeId);

    // 전체 댓글 불러오기
    List<Comment> commentList = commentDao.getCommentsByRecipe(recipeId);


    // -------------------------------------------------------
    // 최근 본 레시피 쿠키 저장
    // -------------------------------------------------------
    Cookie[] cookies = request.getCookies();
    List<String> recent = new ArrayList<>();

    if (cookies != null) {
        for (Cookie c : cookies) {
            if (c.getName().startsWith("recent_")) {
                recent.add(c.getValue());
            }
        }
    }

    // 중복 제거 후 맨 앞에 추가
    recent.remove(String.valueOf(recipeId));
    recent.add(0, String.valueOf(recipeId));

    // 최대 5개 유지
    while (recent.size() > 5) {
        recent.remove(recent.size() - 1);
    }

    // 쿠키 재저장
    for (int i = 0; i < recent.size(); i++) {
        Cookie ck = new Cookie("recent_" + i, recent.get(i));
        ck.setMaxAge(60 * 60 * 24 * 2);
        ck.setPath("/");
        response.addCookie(ck);
    }
%>


<!-- 레시피 상세 UI -->
<div class="row mb-4">
    <div class="col-md-6">
        <img src="./resources/images/<%= r.getImage() %>"
             class="img-fluid rounded shadow"
             style="max-height:350px; object-fit:cover;">
    </div>

    <div class="col-md-6">
        <h2 class="fw-bold"><%= r.getTitle() %></h2>

        <p class="text-muted">
            작성자: <%= r.getMemberId() %><br>
            난이도: <%= r.getLevel() %><br>
            조리시간:  <%= r.getCookTimeText() %>
        </p>

        <h4 class="text-danger">❤ <%= r.getLikesCount() %></h4>

        <!-- 좋아요 버튼 -->
        <form action="likeToggle.jsp" method="post">
            <input type="hidden" name="recipeId" value="<%= recipeId %>">
            <button class="btn btn-orange btn-lg">
                <%= isLiked ? "좋아요 취소" : "좋아요" %>
            </button>
        </form>
    </div>
</div>


<!-- 재료 -->
<h4 class="fw-bold mt-4">📌 재료</h4>
<div class="p-3 bg-white border rounded mb-4">
    <pre style="white-space:pre-wrap;"><%= r.getIngredients() %></pre>
</div>

<!-- 조리과정 -->
<h4 class="fw-bold">🍳 조리 과정</h4>
<div class="p-3 bg-white border rounded mb-4">
    <pre style="white-space:pre-wrap;"><%= r.getSteps() %></pre>
</div>


<!-- 댓글 -->
<h4 class="fw-bold mt-4">💬 댓글</h4>
<!-- 댓글 작성 -->
<form action="commentAdd.jsp" method="post" class="mb-4">
    <input type="hidden" name="recipeId" value="<%= recipeId %>">
    <textarea name="content" class="form-control mb-2" rows="3" placeholder="댓글을 입력하세요"></textarea>
    <button class="btn btn-orange w-100">댓글 작성</button>
</form>
<%
    for (Comment c : commentList) {
        boolean isOwner = c.getMemberId().equals(user.getMemberId());
%>

<div class="p-3 border rounded bg-white mb-3">
    <strong><%= c.getMemberId() %></strong> : <%= c.getContent() %><br>
    <small class="text-muted"><%= c.getRegDate() %></small>

    <% if (isOwner) { %>
        <div class="mt-2">
            <a href="commentEdit.jsp?commentId=<%= c.getCommentId() %>&recipeId=<%= recipeId %>"
               class="btn btn-sm btn-orange">수정</a>

            <a href="commentDelete.jsp?commentId=<%= c.getCommentId() %>&recipeId=<%= recipeId %>"
               class="btn btn-sm btn-danger">삭제</a>
        </div>
    <% } %>
</div>
<%
    }
%>

<%@ include file="footer.jsp" %>
