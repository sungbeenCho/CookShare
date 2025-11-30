<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="jakarta.servlet.http.*" %>
<%@ page import="dao.RecipeDao, dto.Recipe, dto.Member" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<fmt:setLocale value="${param.lang != null ? param.lang : (sessionScope.lang != null ? sessionScope.lang : 'ko')}" />
<fmt:setBundle basename="bundle.message" />

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

    // 작성자 아닌 경우 접근 불가
    if (!user.getMemberId().equals(r.getMemberId())) {
        response.sendRedirect("welcome.jsp");
        return;
    }
%>

<h3 class="fw-bold mb-4"><fmt:message key="recipe.edit.title" /></h3>

<form action="processEditRecipe.jsp?lang=${param.lang}" 
      method="post" 
      enctype="multipart/form-data" 
      class="row g-3">

    <input type="hidden" name="recipeId" value="<%= r.getRecipeId() %>">
    <input type="hidden" name="oldImage" value="<%= r.getImage() %>">

    <!-- 제목 -->
    <div class="col-md-12">
        <label class="form-label"><fmt:message key="recipe.title" /></label>
        <input type="text" name="title" class="form-control" value="<%= r.getTitle() %>" required>
    </div>

    <!-- 종류 -->
    <div class="col-md-4">
        <label class="form-label"><fmt:message key="recipe.category" /></label>
        <select name="category" class="form-select">
            <option value="한식" <%= r.getCategory().equals("한식")?"selected":"" %>>
                <fmt:message key="category.korean" />
            </option>
            <option value="중식" <%= r.getCategory().equals("중식")?"selected":"" %>>
                <fmt:message key="category.chinese" />
            </option>
            <option value="양식" <%= r.getCategory().equals("양식")?"selected":"" %>>
                <fmt:message key="category.western" />
            </option>
            <option value="일식" <%= r.getCategory().equals("일식")?"selected":"" %>>
                <fmt:message key="category.japanese" />
            </option>
            <option value="아시안" <%= r.getCategory().equals("아시안")?"selected":"" %>>
                <fmt:message key="category.asian" />
            </option>
            <option value="멕시칸" <%= r.getCategory().equals("멕시칸")?"selected":"" %>>
                <fmt:message key="category.mexican" />
            </option>
            <option value="분식" <%= r.getCategory().equals("분식")?"selected":"" %>>
                <fmt:message key="category.snack" />
            </option>
            <option value="치킨" <%= r.getCategory().equals("치킨")?"selected":"" %>>
                <fmt:message key="category.chicken" />
            </option>
            <option value="피자" <%= r.getCategory().equals("피자")?"selected":"" %>>
                <fmt:message key="category.pizza" />
            </option>
            <option value="버거" <%= r.getCategory().equals("버거")?"selected":"" %>>
                <fmt:message key="category.burger" />
            </option>
            <option value="샐러드" <%= r.getCategory().equals("샐러드")?"selected":"" %>>
                <fmt:message key="category.salad" />
            </option>
            <option value="샌드위치" <%= r.getCategory().equals("샌드위치")?"selected":"" %>>
                <fmt:message key="category.sandwich" />
            </option>
            <option value="디저트" <%= r.getCategory().equals("디저트")?"selected":"" %>>
                <fmt:message key="category.dessert" />
            </option>
        </select>
    </div>

    <!-- 난이도 -->
    <div class="col-md-4">
        <label class="form-label"><fmt:message key="recipe.level" /></label>
        <select name="level" class="form-select">
            <option value="쉬움" <%= r.getLevel().equals("쉬움")?"selected":"" %>>
                <fmt:message key="level.easy" />
            </option>
            <option value="보통" <%= r.getLevel().equals("보통")?"selected":"" %>>
                <fmt:message key="level.medium" />
            </option>
            <option value="어려움" <%= r.getLevel().equals("어려움")?"selected":"" %>>
                <fmt:message key="level.hard" />
            </option>
        </select>
    </div>

    <!-- 조리시간 -->
    <div class="col-md-4">
        <label class="form-label"><fmt:message key="recipe.cooktime" /></label>
        <select name="cookTime" class="form-select">
            <option value="20" <%= r.getCookTime()==20?"selected":"" %>>
                <fmt:message key="cooktime.range1" />
            </option>
            <option value="45" <%= r.getCookTime()==45?"selected":"" %>>
                <fmt:message key="cooktime.range2" />
            </option>
            <option value="90" <%= r.getCookTime()==90?"selected":"" %>>
                <fmt:message key="cooktime.range3" />
            </option>
            <option value="150" <%= r.getCookTime()==150?"selected":"" %>>
                <fmt:message key="cooktime.range4" />
            </option>
        </select>
    </div>

    <!-- 이미지 -->
    <div class="col-md-12">
        <label class="form-label"><fmt:message key="recipe.image.change" /></label>
        <input type="file" name="image" class="form-control">
        <p class="text-muted mt-1">
            <fmt:message key="recipe.currentImage" /> : <%= r.getImage() %>
        </p>
    </div>

    <!-- 재료 -->
    <div class="col-md-12">
        <label class="form-label"><fmt:message key="recipe.ingredients" /></label>
        <textarea name="ingredients" rows="4" class="form-control"><%= r.getIngredients() %></textarea>
    </div>

    <!-- 조리 과정 -->
    <div class="col-md-12">
        <label class="form-label"><fmt:message key="recipe.steps" /></label>
        <textarea name="steps" rows="6" class="form-control"><%= r.getSteps() %></textarea>
    </div>

    <!-- 버튼 -->
    <div class="col-md-12">
        <button class="btn btn-orange w-100">
            <fmt:message key="recipe.edit.submit" />
        </button>
    </div>
</form>

<%@ include file="footer.jsp" %>
