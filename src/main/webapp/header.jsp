<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>

<fmt:setLocale value="${param.lang != null ? param.lang : (sessionScope.lang != null ? sessionScope.lang : 'ko')}" />
<fmt:setBundle basename="bundle.message" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title><fmt:message key="site.title"/></title>

    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <!-- Custom CSS -->
    <link rel="stylesheet" href="./resources/css/style.css">
</head>
<body>

<%
    // 현재 페이지와 recipeId 값을 추출
    String currentPage = request.getRequestURI();
    String recipeIdParam = request.getParameter("recipeId");
%>

<nav class="navbar navbar-expand-lg navbar-dark navbar-custom">
    <div class="container">
        <a class="navbar-brand fw-bold" href="welcome.jsp">
            <fmt:message key="site.title"/>
        </a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse"
                data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarNav">
            <!-- 왼쪽 메뉴 -->
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link" href="welcome.jsp"><fmt:message key="nav.home"/></a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="recipes.jsp"><fmt:message key="nav.recipes"/></a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="addRecipe.jsp"><fmt:message key="nav.add"/></a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="myRecipes.jsp"><fmt:message key="nav.mypage"/></a>
                </li>
            </ul>

            <!-- 오른쪽 메뉴 -->
            <ul class="navbar-nav">

                <!-- 언어 전환 버튼 -->
                <%
                    // editRecipe.jsp일 경우에는 recipeId 유지
                    if (currentPage.contains("editRecipe.jsp") && recipeIdParam != null) {
                %>
                    <li class="nav-item me-2">
                        <a class="nav-link" href="editRecipe.jsp?recipeId=<%=recipeIdParam%>&lang=ko">KO</a>
                    </li>
                    <li class="nav-item me-3">
                        <a class="nav-link" href="editRecipe.jsp?recipeId=<%=recipeIdParam%>&lang=en">EN</a>
                    </li>
                <%
                    } else {
                %>
                    <li class="nav-item me-2">
                        <a class="nav-link" href="?lang=ko">KO</a>
                    </li>
                    <li class="nav-item me-3">
                        <a class="nav-link" href="?lang=en">EN</a>
                    </li>
                <%
                    }
                %>

                <!-- 로그인 상태 -->
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <li class="nav-item">
                            <span class="navbar-text me-3">
                                ${sessionScope.user.name} 님
                            </span>
                        </li>
                        <li class="nav-item">
                            <a class="btn btn-outline-light btn-sm" href="logout.jsp">
                                <fmt:message key="nav.logout"/>
                            </a>
                        </li>
                    </c:when>

                    <c:otherwise>
                        <li class="nav-item">
                            <a class="btn btn-outline-light btn-sm" href="login.jsp">
                                <fmt:message key="nav.login"/>
                            </a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</nav>

<div class="container py-4">
