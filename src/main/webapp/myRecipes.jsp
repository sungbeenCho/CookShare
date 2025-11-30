<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.RecipeDao, dao.CommentDao, dao.LikeDao" %>
<%@ page import="dto.Recipe, dto.Comment, dto.Member, java.util.List" %>
<%@ include file="header.jsp" %>

<%
    // 로그인 체크
    Member user = (Member) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String memberId = user.getMemberId();

    RecipeDao recipeDao = RecipeDao.getInstance();
    CommentDao commentDao = CommentDao.getInstance();
    LikeDao likeDao = LikeDao.getInstance();

    List<Recipe> myRecipes = recipeDao.getRecipesByMember(memberId);
    List<Comment> myComments = commentDao.getCommentsByMember(memberId);
    List<Recipe> likedRecipes = likeDao.getLikedRecipes(memberId);
%>

<h3 class="fw-bold mb-4">👤 마이페이지</h3>

<!-- 탭 메뉴 -->
<ul class="nav nav-tabs mb-4">
    <li class="nav-item">
        <a class="nav-link active" data-bs-toggle="tab" href="#tab1">내 레시피</a>
    </li>
    <li class="nav-item">
        <a class="nav-link" data-bs-toggle="tab" href="#tab2">내 댓글</a>
    </li>
    <li class="nav-item">
        <a class="nav-link" data-bs-toggle="tab" href="#tab3">좋아요한 레시피</a>
    </li>
</ul>


<div class="tab-content">

    <!-- 내 레시피 탭 -->
    <div class="tab-pane fade show active" id="tab1">
        <h4 class="fw-bold mb-3">📌 내가 작성한 레시피</h4>

        <div class="row row-cols-1 row-cols-md-4 g-4 mb-5">
        <%
            if (myRecipes.size() == 0) {
        %>
            <p class="text-muted">작성한 레시피가 없습니다.</p>
        <%
            } else {
                for (Recipe r : myRecipes) {
        %>
            <div class="col">
                <div class="card shadow-sm h-100">
                    <img src="./resources/images/<%= r.getImage() %>"
                         class="card-img-top"
                         style="height:150px; object-fit:cover;">

                    <div class="card-body">
                        <h6 class="card-title text-truncate"><%= r.getTitle() %></h6>
                        <a href="recipeDetail.jsp?recipeId=<%= r.getRecipeId() %>"
                           class="btn btn-sm btn-outline-secondary w-100 mb-2">
                            자세히 보기
                        </a>

                        <a href="editRecipe.jsp?recipeId=<%= r.getRecipeId() %>"
                           class="btn btn-sm btn-orange w-100 mb-2">
                            수정하기
                        </a>

                        <a href="deleteRecipe.jsp?recipeId=<%= r.getRecipeId() %>"
                           class="btn btn-sm btn-danger w-100">
                            삭제하기
                        </a>
                    </div>
                </div>
            </div>
        <%
                }
            }
        %>
        </div>
    </div>


    <!-- 내 댓글 탭 -->
    <div class="tab-pane fade" id="tab2">
        <h4 class="fw-bold mb-3">💬 내가 작성한 댓글</h4>

        <%
            if (myComments.size() == 0) {
        %>
            <p class="text-muted">작성한 댓글이 없습니다.</p>
        <%
            } else {
                for (Comment c : myComments) {
        %>
            <div class="mb-3 p-3 border rounded bg-white shadow-sm">
                <strong>[<%= c.getRecipeTitle() %>]</strong><br>
                <%= c.getContent() %><br>
                <small class="text-muted"><%= c.getRegDate() %></small><br>
                <a href="recipeDetail.jsp?recipeId=<%= c.getRecipeId() %>"
                   class="btn btn-sm btn-outline-secondary mt-2">레시피 보기</a>
            </div>
        <%
                }
            }
        %>
    </div>


    <!-- 좋아요한 레시피 탭 -->
    <div class="tab-pane fade" id="tab3">
        <h4 class="fw-bold mb-3">❤️ 좋아요한 레시피</h4>

        <div class="row row-cols-1 row-cols-md-4 g-4 mb-5">
        <%
            if (likedRecipes.size() == 0) {
        %>
            <p class="text-muted">좋아요한 레시피가 없습니다.</p>
        <%
            } else {
                for (Recipe r : likedRecipes) {
        %>
            <div class="col">
                <div class="card shadow-sm h-100">
                    <img src="./resources/images/<%= r.getImage() %>"
                         class="card-img-top"
                         style="height:150px; object-fit:cover;">

                    <div class="card-body">
                        <h6 class="card-title text-truncate"><%= r.getTitle() %></h6>
                        <p class="text-danger">❤ <%= r.getLikesCount() %></p>
                        <a href="recipeDetail.jsp?recipeId=<%= r.getRecipeId() %>"
                           class="btn btn-sm btn-outline-secondary w-100">
                            자세히 보기
                        </a>
                    </div>
                </div>
            </div>
        <%
                }
            }
        %>
        </div>
    </div>

</div>


<%@ include file="footer.jsp" %>
