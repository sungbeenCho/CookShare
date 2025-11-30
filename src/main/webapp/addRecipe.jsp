<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<fmt:setLocale value="${param.lang != null ? param.lang : (sessionScope.lang != null ? sessionScope.lang : 'ko')}" />
<fmt:setBundle basename="bundle.message" />

<%@ include file="header.jsp" %>

<script type="text/javascript" src="./resources/js/validation.js"></script>

<%
    // 로그인 체크
    if (session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<h3 class="fw-bold mb-4"><fmt:message key="recipe.add.title" /></h3>

<form action="addRecipeProcess.jsp?lang=${param.lang}"
      method="post"
      enctype="multipart/form-data"
      onsubmit="return validateRecipe(this);">

    <!-- 제목 -->
    <div class="mb-3">
        <label class="form-label"><fmt:message key="recipe.title" /></label>
        <input type="text" name="title" class="form-control">
    </div>

    <div class="row mb-3">

        <!-- 종류 -->
        <div class="col-md-4">
            <label class="form-label"><fmt:message key="recipe.category" /></label>
            <select name="category" class="form-select">
                <option value="한식"><fmt:message key="category.korean" /></option>
                <option value="양식"><fmt:message key="category.western" /></option>
                <option value="중식"><fmt:message key="category.chinese" /></option>
                <option value="일식"><fmt:message key="category.japanese" /></option>
                <option value="기타"><fmt:message key="category.etc" /></option>
                <option value="아시안"><fmt:message key="category.asian" /></option>
                <option value="멕시칸"><fmt:message key="category.mexican" /></option>
                <option value="분식"><fmt:message key="category.snack" /></option>
                <option value="치킨"><fmt:message key="category.chicken" /></option>
                <option value="피자"><fmt:message key="category.pizza" /></option>
                <option value="버거"><fmt:message key="category.burger" /></option>
                <option value="샐러드"><fmt:message key="category.salad" /></option>
                <option value="샌드위치"><fmt:message key="category.sandwich" /></option>
                <option value="디저트"><fmt:message key="category.dessert" /></option>
            </select>
        </div>

        <!-- 난이도 -->
        <div class="col-md-4">
            <label class="form-label"><fmt:message key="recipe.level" /></label>
            <select name="level" class="form-select">
                <option value="쉬움"><fmt:message key="level.easy" /></option>
                <option value="보통"><fmt:message key="level.medium" /></option>
                <option value="어려움"><fmt:message key="level.hard" /></option>
            </select>
        </div>

        <!-- 조리시간 -->
        <div class="col-md-4">
            <label class="form-label"><fmt:message key="recipe.cooktime" /></label>
            <select name="cookTime" class="form-select">
                <option value="20"><fmt:message key="cooktime.range1" /></option>
                <option value="45"><fmt:message key="cooktime.range2" /></option>
                <option value="90"><fmt:message key="cooktime.range3" /></option>
                <option value="150"><fmt:message key="cooktime.range4" /></option>
            </select>
        </div>

    </div>

    <!-- 재료 -->
    <div class="mb-3">
        <label class="form-label"><fmt:message key="recipe.ingredients" /></label>
        <textarea name="ingredients" class="form-control" rows="3"></textarea>
    </div>

    <!-- 조리 과정 -->
    <div class="mb-3">
        <label class="form-label"><fmt:message key="recipe.steps" /></label>
        <textarea name="steps" class="form-control" rows="5"></textarea>
    </div>

    <!-- 이미지 -->
    <div class="mb-3">
        <label class="form-label"><fmt:message key="recipe.image" /></label>
        <input type="file" name="image" class="form-control">
    </div>

    <button type="submit" class="btn btn-orange w-100">
        <fmt:message key="recipe.submit" />
    </button>
</form>

<%@ include file="footer.jsp" %>
