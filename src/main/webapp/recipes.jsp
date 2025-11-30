<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.RecipeDao, dto.Recipe, java.util.List" %>
<%@ include file="header.jsp" %>

<%
    // 로그인 체크
    if (session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    request.setCharacterEncoding("UTF-8");

    String keyword = request.getParameter("keyword");
    String category = request.getParameter("category");
    String level = request.getParameter("level");
    String cookTime = request.getParameter("cookTime");
    String sort = request.getParameter("sort");

    RecipeDao recipeDao = RecipeDao.getInstance();

    // 검색 결과 가져오기
    List<Recipe> list = recipeDao.searchRecipes(keyword, category, level, cookTime, sort);
%>

<h3 class="fw-bold mb-4">🔍 레시피 검색 결과</h3>

<!-- 필터 유지된 검색 폼 -->
<form action="recipes.jsp" method="get" class="row g-3 mb-4">

    <div class="col-md-4">
        <input type="text" name="keyword" class="form-control"
               value="<%= keyword == null ? "" : keyword %>"
               placeholder="제목 검색">
    </div>

    <div class="col-md-2">
        <select name="category" class="form-select">
            <option value="">종류</option>
            <option value="한식" <%= "한식".equals(category) ? "selected" : "" %>>한식</option>
            <option value="중식" <%= "중식".equals(category) ? "selected" : "" %>>중식</option>
            <option value="양식" <%= "양식".equals(category) ? "selected" : "" %>>양식</option>
            <option value="일식" <%= "일식".equals(category) ? "selected" : "" %>>일식</option>
            <option value="아시안" <%= "아시안".equals(category) ? "selected" : "" %>>아시안</option>
            <option value="멕시칸" <%= "멕시칸".equals(category) ? "selected" : "" %>>멕시칸</option>
            <option value="분식" <%= "분식".equals(category) ? "selected" : "" %>>분식</option>
            <option value="치킨" <%= "치킨".equals(category) ? "selected" : "" %>>치킨</option>
            <option value="피자" <%= "피자".equals(category) ? "selected" : "" %>>피자</option>
            <option value="버거" <%= "버거".equals(category) ? "selected" : "" %>>버거</option>
            <option value="샐러드" <%= "샐러드".equals(category) ? "selected" : "" %>>샐러드</option>
            <option value="샌드위치" <%= "샌드위치".equals(category) ? "selected" : "" %>>샌드위치</option>
            <option value="디저트" <%= "디저트".equals(category) ? "selected" : "" %>>디저트</option>
        </select>
    </div>

    <div class="col-md-2">
        <select name="level" class="form-select">
            <option value="">난이도</option>
            <option value="쉬움" <%= "쉬움".equals(level) ? "selected" : "" %>>쉬움</option>
            <option value="보통" <%= "보통".equals(level) ? "selected" : "" %>>보통</option>
            <option value="어려움" <%= "어려움".equals(level) ? "selected" : "" %>>어려움</option>
        </select>
    </div>

    <div class="col-md-2">
        <select name="cookTime" class="form-select">
            <option value="">시간</option>
            <option value="20" <%= "20".equals(cookTime) ? "selected" : "" %>>30분 미만</option>
            <option value="45" <%= "45".equals(cookTime) ? "selected" : "" %>>30분 ~ 1시간</option>
            <option value="90" <%= "90".equals(cookTime) ? "selected" : "" %>>1~2시간</option>
            <option value="150" <%= "150".equals(cookTime) ? "selected" : "" %>>2시간 이상</option>
        </select>
    </div>

    <div class="col-md-2">
        <button type="submit" class="btn btn-orange w-100">검색</button>
    </div>
</form>


<!-- 정렬 버튼 -->
<div class="mb-4">
    <a href="recipes.jsp?sort=latest" class="btn btn-sm btn-outline-secondary">최신순</a>
    <a href="recipes.jsp?sort=likes" class="btn btn-sm btn-outline-secondary">좋아요순</a>
</div>


<!-- 검색 결과 목록 -->
<div class="row row-cols-1 row-cols-md-4 g-4 mb-5">

<%
    if (list.size() == 0) {
%>
    <p class="text-muted">검색 결과가 없습니다.</p>
<%
    } else {

        for (Recipe r : list) {
%>
    <div class="col">
        <div class="card shadow-sm h-100">
            <img src="./resources/images/<%= r.getImage() %>"
                 class="card-img-top"
                 style="height:160px; object-fit:cover;">
            <div class="card-body">
                <h6 class="card-title text-truncate"><%= r.getTitle() %></h6>
                <p class="text-danger">❤ <%= r.getLikesCount() %></p>

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
