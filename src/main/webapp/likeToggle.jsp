<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.LikeDao, dao.RecipeDao, dto.Member" %>

<%
    request.setCharacterEncoding("UTF-8");

    Member user = (Member) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int recipeId = Integer.parseInt(request.getParameter("recipeId"));

    LikeDao likeDao = LikeDao.getInstance();
    RecipeDao recipeDao = RecipeDao.getInstance();

    boolean liked = likeDao.isLiked(user.getMemberId(), recipeId);

    if (liked) {
        likeDao.removeLike(user.getMemberId(), recipeId);
    } else {
        likeDao.addLike(user.getMemberId(), recipeId);
    }

    // 좋아요 개수 다시 계산 후 업데이트
    int newCount = likeDao.countLikes(recipeId);
    recipeDao.updateLikesCount(recipeId, newCount);

    // 상세 페이지로 다시 이동
    response.sendRedirect("recipeDetail.jsp?recipeId=" + recipeId);
%>
