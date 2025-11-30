<%@ page import="dao.CommentDao" %>
<%@ page import="dto.Comment, dto.Member" %>
<%@ page import="jakarta.servlet.http.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    request.setCharacterEncoding("UTF-8");

    Member user = (Member) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int recipeId = Integer.parseInt(request.getParameter("recipeId"));
    String content = request.getParameter("content");

    CommentDao commentDao = CommentDao.getInstance();

    Comment c = new Comment();
    c.setRecipeId(recipeId);
    c.setMemberId(user.getMemberId());
    c.setContent(content);

    commentDao.addComment(c);

    response.sendRedirect("recipeDetail.jsp?recipeId=" + recipeId);
%>
