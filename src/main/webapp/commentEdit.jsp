<%@ page import="dao.CommentDao" %>
<%@ page import="dto.Comment, dto.Member" %>
<%@ page import="jakarta.servlet.http.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>

<%
    request.setCharacterEncoding("UTF-8");

    Member user = (Member) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int commentId = Integer.parseInt(request.getParameter("commentId"));
    int recipeId = Integer.parseInt(request.getParameter("recipeId"));

    CommentDao commentDao = CommentDao.getInstance();

    // POST 요청 → 수정 처리
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String content = request.getParameter("content");

        commentDao.updateComment(commentId, user.getMemberId(), content);

        response.sendRedirect("recipeDetail.jsp?recipeId=" + recipeId);
        return;
    }

    // GET 요청 → 기존 댓글 불러오기
    Comment c = commentDao.getCommentById(commentId);

    if (!c.getMemberId().equals(user.getMemberId())) {
        response.sendRedirect("recipeDetail.jsp?recipeId=" + recipeId);
        return;
    }
%>

<h3 class="fw-bold mb-3">✏ 댓글 수정</h3>

<form action="commentEdit.jsp?commentId=<%=commentId%>&recipeId=<%=recipeId%>" 
      method="post">

    <textarea name="content" class="form-control mb-3" rows="4"><%= c.getContent() %></textarea>

    <button class="btn btn-orange w-100">수정 완료</button>
</form>

<%@ include file="footer.jsp" %>
