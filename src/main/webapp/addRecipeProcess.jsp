<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="dao.RecipeDao, dto.Recipe, dto.Member" %>

<%
    request.setCharacterEncoding("UTF-8");

    // 로그인 체크
    Member user = (Member) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 업로드 경로 설정
    String savePath = application.getRealPath("/resources/images");
    int maxSize = 10 * 1024 * 1024; // 10MB
    String encType = "UTF-8";

    MultipartRequest multi = new MultipartRequest(
            request,
            savePath,
            maxSize,
            encType,
            new DefaultFileRenamePolicy()
    );

    String title = multi.getParameter("title");
    String category = multi.getParameter("category");
    String level = multi.getParameter("level");
    int cookTime = Integer.parseInt(multi.getParameter("cookTime"));
    String ingredients = multi.getParameter("ingredients");
    String steps = multi.getParameter("steps");
    String image = multi.getFilesystemName("image");

    Recipe recipe = new Recipe();
    recipe.setMemberId(user.getMemberId());
    recipe.setTitle(title);
    recipe.setCategory(category);
    recipe.setLevel(level);
    recipe.setCookTime(cookTime);
    recipe.setIngredients(ingredients);
    recipe.setSteps(steps);
    recipe.setImage(image);

    RecipeDao recipeDao = RecipeDao.getInstance();
    int recipeId = recipeDao.insertRecipe(recipe);

    if (recipeId > 0) {
        response.sendRedirect("recipeDetail.jsp?recipeId=" + recipeId);
    } else {
        response.sendRedirect("error.jsp");
    }
%>
