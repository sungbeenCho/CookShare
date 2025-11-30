<%@ page import="dao.CommentDao" %>
<%@ page import="dto.Member" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    Member user = (Member) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int commentId = Integer.parseInt(request.getParameter("commentId"));
    int recipeId = Integer.parseInt(request.getParameter("recipeId"));

    CommentDao commentDao = CommentDao.getInstance();

    // DAO가 요구하는 정확한 파라미터
    commentDao.deleteComment(commentId, user.getMemberId());

    response.sendRedirect("recipeDetail.jsp?recipeId=" + recipeId);
%>
