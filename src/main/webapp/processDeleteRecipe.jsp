<%@ page import="dao.RecipeDao" %>
<%@ page import="java.io.File" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    request.setCharacterEncoding("UTF-8");

    int recipeId = Integer.parseInt(request.getParameter("recipeId"));
    String image = request.getParameter("image"); // 저장된 이미지 파일명

    RecipeDao recipeDao = RecipeDao.getInstance();

    // 1) DB에서 삭제
    recipeDao.deleteRecipe(recipeId);

    // 2) 이미지 파일 삭제
    String imgPath = application.getRealPath("/resources/images/" + image);
    File imgFile = new File(imgPath);

    if (imgFile.exists()) {
        imgFile.delete();
    }

    // 3) 메인 페이지로 이동
    response.sendRedirect("welcome.jsp");
%>
