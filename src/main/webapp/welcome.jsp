<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.RecipeDao, dto.Recipe, java.util.List, jakarta.servlet.http.Cookie" %>
<%@ include file="header.jsp" %>

<%
    // 로그인 체크
    if (session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    RecipeDao recipeDao = RecipeDao.getInstance();

    // Top 5
    List<Recipe> top5List = recipeDao.getTop5ByLikes();

    // 최신 레시피
    List<Recipe> latestList = recipeDao.getLatestRecipes();

    // 최근 본 레시피 쿠키 불러오기
    Cookie[] cookies = request.getCookies();
    List<Integer> recentIds = new java.util.ArrayList<>();

    if (cookies != null) {
        for (Cookie c : cookies) {
            if (c.getName().startsWith("recent_")) {
                try {
                    recentIds.add(Integer.parseInt(c.getValue()));
                } catch (Exception ignored) {}
            }
        }
    }

    // 쿠키에서 가져온 ID들로 레시피 정보 조회
    List<Recipe> recentList = new java.util.ArrayList<>();
    for (Integer rid : recentIds) {
        Recipe rec = recipeDao.getRecipeById(rid);
        if (rec != null) recentList.add(rec);
    }
%>


<!-- Hero Section -->
<div class="p-5 mb-4 bg-white rounded-3 shadow">
    <div class="container-fluid py-5">
        <h1 class="display-6 fw-bold">🌿 오늘은 어떤 레시피를 공유할까요?</h1>
        <a href="addRecipe.jsp" class="btn btn-orange btn-lg mt-3">레시피 작성하기</a>
    </div>
</div>


<!-- Top 5 Recipes -->
<h3 class="fw-bold mb-3">🔥 인기 레시피 Top 5</h3>

<div class="row row-cols-1 row-cols-md-5 g-4 mb-5">
<%
    for (Recipe r : top5List) {
%>
    <div class="col">
        <div class="card shadow-sm h-100">
            <img src="./resources/images/<%= r.getImage() %>"
                 class="card-img-top"
                 style="height:150px; object-fit:cover;">
            <div class="card-body">
                <h6 class="card-title text-truncate"><%= r.getTitle() %></h6>
                <p class="card-text text-danger">❤ <%= r.getLikesCount() %></p>
                <a href="recipeDetail.jsp?recipeId=<%= r.getRecipeId() %>"
                   class="btn btn-sm btn-outline-secondary w-100">
                    자세히 보기
                </a>
            </div>
        </div>
    </div>
<%
    }
%>
</div>


<!-- Search Area -->
<h3 class="fw-bold mb-3">🔍 레시피 검색</h3>

<form action="recipes.jsp" method="get" class="row g-3 mb-5">
    <div class="col-md-4">
        <input type="text" name="keyword" class="form-control" placeholder="재료 또는 제목으로 검색">
    </div>

    <div class="col-md-2">
        <select name="category" class="form-select">
            <option value="">종류</option>
            <option value="한식">한식</option>
            <option value="중식">중식</option>
            <option value="양식">양식</option>
            <option value="일식">일식</option>
            <option value="아시안">아시안</option>
            <option value="멕시칸">멕시칸</option>
            <option value="분식">분식</option>
            <option value="치킨">치킨</option>
            <option value="피자">피자</option>
            <option value="버거">버거</option>
            <option value="샐러드">샐러드</option>
            <option value="샌드위치">샌드위치</option>
            <option value="디저트">디저트</option>
        </select>
    </div>

    <div class="col-md-2">
        <select name="level" class="form-select">
            <option value="">난이도</option>
            <option value="쉬움">쉬움</option>
            <option value="보통">보통</option>
            <option value="어려움">어려움</option>
        </select>
    </div>

    <div class="col-md-2">
        <select name="cookTime" class="form-select">
            <option value="">시간</option>
            <option value="20">30분 미만</option>
            <option value="45">30분 ~ 1시간</option>
            <option value="90">1~2시간</option>
            <option value="150">2시간 이상</option>
        </select>
    </div>

    <div class="col-md-2">
        <button type="submit" class="btn btn-orange w-100">검색</button>
    </div>
</form>



<!-- Latest Recipes -->
<h3 class="fw-bold mb-3">📌 최신 레시피</h3>

<div class="row row-cols-1 row-cols-md-4 g-4 mb-5">
<%
    for (Recipe r : latestList) {
%>
    <div class="col">
        <div class="card shadow-sm h-100">
            <img src="./resources/images/<%= r.getImage() %>"
                 class="card-img-top"
                 style="height:160px; object-fit:cover;">

            <div class="card-body">
                <h6 class="card-title text-truncate"><%= r.getTitle() %></h6>
                <p class="card-text mb-1">종류: <%= r.getCategory() %></p>
                <p class="card-text">
                    <small class="text-muted">
                        <%= r.getLevel() %> · <%= r.getCookTimeText() %>
                    </small>
                </p>

                <a href="recipeDetail.jsp?recipeId=<%= r.getRecipeId() %>"
                   class="btn btn-sm btn-outline-secondary w-100">
                    자세히 보기
                </a>
            </div>
        </div>
    </div>
<%
    }
%>
</div>



<!-- Recent Viewed Recipes -->
<h3 class="fw-bold mb-3">👀 최근 본 레시피</h3>

<div class="row row-cols-1 row-cols-md-5 g-4 mb-5">
<%
    if (recentList.size() == 0) {
%>
        <p class="text-muted">최근 본 레시피가 없습니다.</p>
<%
    } else {
        for (Recipe r : recentList) {
%>
        <div class="col">
            <div class="card shadow-sm h-100">
                <img src="./resources/images/<%= r.getImage() %>"
                     class="card-img-top"
                     style="height:140px; object-fit:cover;">
                <div class="card-body">
                    <h6 class="card-title text-truncate"><%= r.getTitle() %></h6>
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


<%@ include file="footer.jsp" %>
