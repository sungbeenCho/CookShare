<%@ page import="dao.RecipeDao, dto.Recipe" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    request.setCharacterEncoding("UTF-8");

    String saveFolder = application.getRealPath("/resources/images");
    int maxSize = 10 * 1024 * 1024;

    MultipartRequest multi = new MultipartRequest(
            request,
            saveFolder,
            maxSize,
            "UTF-8",
            new DefaultFileRenamePolicy()
    );

    int recipeId = Integer.parseInt(multi.getParameter("recipeId"));
    String oldImage = multi.getParameter("oldImage");

    String title = multi.getParameter("title");
    String ingredients = multi.getParameter("ingredients");
    String steps = multi.getParameter("steps");
    String category = multi.getParameter("category");
    String level = multi.getParameter("level");
    int cookTime = Integer.parseInt(multi.getParameter("cookTime"));

    // 파일 새로 업로드했는지 확인
    String newImage = multi.getFilesystemName("image");
    String finalImage = (newImage != null) ? newImage : oldImage;

    Recipe r = new Recipe();
    r.setRecipeId(recipeId);
    r.setTitle(title);
    r.setIngredients(ingredients);
    r.setSteps(steps);
    r.setCategory(category);
    r.setLevel(level);
    r.setCookTime(cookTime);
    r.setImage(finalImage);

    RecipeDao recipeDao = RecipeDao.getInstance();
    recipeDao.updateRecipe(r);

    response.sendRedirect("recipeDetail.jsp?recipeId=" + recipeId);
%>
