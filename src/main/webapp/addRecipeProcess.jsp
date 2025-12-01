<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.File" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="org.apache.commons.fileupload.FileItem" %>
<%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory" %>
<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload" %>
<%@ page import="dao.RecipeDao, dto.Recipe, dto.Member" %>

<%
    request.setCharacterEncoding("UTF-8");

    // 로그인 체크
    Member user = (Member) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 파일 업로드가 multipart 타입인지 체크
    boolean isMultipart = ServletFileUpload.isMultipartContent(request);
    if (!isMultipart) {
        out.println("Error: form enctype must be multipart/form-data");
        return;
    }

    // 업로드 저장 경로
    String savePath = application.getRealPath("/resources/images");
    File uploadDir = new File(savePath);
    if (!uploadDir.exists()) uploadDir.mkdirs();

    DiskFileItemFactory factory = new DiskFileItemFactory();
    factory.setRepository(uploadDir);
    factory.setSizeThreshold(10 * 1024 * 1024); // 10MB

    ServletFileUpload upload = new ServletFileUpload(factory);
    upload.setHeaderEncoding("UTF-8");

    String title = "";
    String category = "";
    String level = "";
    int cookTime = 0;
    String ingredients = "";
    String steps = "";
    String image = "";

    try {
        List<FileItem> items = upload.parseRequest(request);
        Iterator<FileItem> iter = items.iterator();

        while (iter.hasNext()) {
            FileItem item = iter.next();

            if (item.isFormField()) {
                // 일반 텍스트 파라미터
                String fieldName = item.getFieldName();
                String value = item.getString("UTF-8");

                switch (fieldName) {
                    case "title": title = value; break;
                    case "category": category = value; break;
                    case "level": level = value; break;
                    case "cookTime": cookTime = Integer.parseInt(value); break;
                    case "ingredients": ingredients = value; break;
                    case "steps": steps = value; break;
                }

            } else {
                // 파일 처리
                if ("image".equals(item.getFieldName())) {
                    String fileName = new File(item.getName()).getName();

                    if (fileName != null && !fileName.isEmpty()) {
                        File uploadedFile = new File(savePath + File.separator + fileName);
                        item.write(uploadedFile);
                        image = fileName;
                    }
                }
            }
        }

    } catch (Exception e) {
        e.printStackTrace();
        out.println("업로드 처리 중 오류 발생 : " + e.getMessage());
        return;
    }

    // DB 저장
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
