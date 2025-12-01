<%@ page import="dao.RecipeDao, dto.Recipe" %>
<%@ page import="java.io.File" %>
<%@ page import="java.util.List, java.util.Iterator" %>
<%@ page import="org.apache.commons.fileupload.FileItem" %>
<%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory" %>
<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    request.setCharacterEncoding("UTF-8");

    // 업로드 폴더 설정
    String savePath = application.getRealPath("/resources/images");
    File uploadDir = new File(savePath);
    if (!uploadDir.exists()) uploadDir.mkdirs();

    int maxSize = 10 * 1024 * 1024;

    // Commons FileUpload 설정
    DiskFileItemFactory factory = new DiskFileItemFactory();
    factory.setSizeThreshold(maxSize);
    factory.setRepository(uploadDir);

    ServletFileUpload upload = new ServletFileUpload(factory);
    upload.setHeaderEncoding("UTF-8");

    int recipeId = 0;
    String oldImage = "";
    String title = "";
    String ingredients = "";
    String steps = "";
    String category = "";
    String level = "";
    int cookTime = 0;

    String finalImage = "";

    try {
        List<FileItem> items = upload.parseRequest(request);

        for (FileItem item : items) {

            if (item.isFormField()) {
                // 텍스트 파라미터
                String field = item.getFieldName();
                String value = item.getString("UTF-8");

                switch (field) {
                    case "recipeId":
                        recipeId = Integer.parseInt(value);
                        break;
                    case "oldImage":
                        oldImage = value;
                        break;
                    case "title":
                        title = value;
                        break;
                    case "ingredients":
                        ingredients = value;
                        break;
                    case "steps":
                        steps = value;
                        break;
                    case "category":
                        category = value;
                        break;
                    case "level":
                        level = value;
                        break;
                    case "cookTime":
                        cookTime = Integer.parseInt(value);
                        break;
                }

            } else {
                // 파일 업로드 처리
                if ("image".equals(item.getFieldName())) {
                    String fileName = new File(item.getName()).getName();

                    if (fileName != null && !fileName.isEmpty()) {
                        File uploadedFile = new File(savePath + File.separator + fileName);
                        item.write(uploadedFile);
                        finalImage = fileName;  // 새로운 이미지 사용
                    }
                }
            }
        }

        // 이미지 업로드 안 했으면 기존 이미지 유지
        if (finalImage == null || finalImage.isEmpty()) {
            finalImage = oldImage;
        }

    } catch (Exception e) {
        e.printStackTrace();
        out.println("Error while editing recipe: " + e.getMessage());
        return;
    }

    // DTO 구성
    Recipe r = new Recipe();
    r.setRecipeId(recipeId);
    r.setTitle(title);
    r.setIngredients(ingredients);
    r.setSteps(steps);
    r.setCategory(category);
    r.setLevel(level);
    r.setCookTime(cookTime);
    r.setImage(finalImage);

    // DB 업데이트
    RecipeDao recipeDao = RecipeDao.getInstance();
    recipeDao.updateRecipe(r);

    response.sendRedirect("recipeDetail.jsp?recipeId=" + recipeId);
%>
