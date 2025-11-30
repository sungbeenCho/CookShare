<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="jakarta.servlet.http.*, dao.RecipeDao, dto.Recipe, dto.Member" %>
<%@ include file="header.jsp" %>

<%
    Member user = (Member) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int recipeId = Integer.parseInt(request.getParameter("recipeId"));
    RecipeDao recipeDao = RecipeDao.getInstance();
    Recipe r = recipeDao.getRecipeById(recipeId);

    // 작성자만 접근 가능
    if (!user.getMemberId().equals(r.getMemberId())) {
        response.sendRedirect("welcome.jsp");
        return;
    }
%>

<h3 class="fw-bold mb-4 text-danger">⚠ 레시피 삭제</h3>

<div class="p-4 border rounded bg-white shadow-sm mb-4">
    <h4 class="fw-bold"><%= r.getTitle() %></h4>
    <p class="text-muted mb-4">정말로 이 레시피를 삭제하시겠습니까?</p>

    <form action="processDeleteRecipe.jsp" method="post">
        <input type="hidden" name="recipeId" value="<%= r.getRecipeId() %>">
        <input type="hidden" name="image" value="<%= r.getImage() %>">

        <button class="btn btn-danger btn-lg w-100 mb-2">삭제하기</button>
        <a href="recipeDetail.jsp?recipeId=<%= r.getRecipeId() %>" class="btn btn-secondary w-100">취소</a>
    </form>
</div>

<%@ include file="footer.jsp" %>
