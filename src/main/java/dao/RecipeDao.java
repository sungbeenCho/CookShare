package dao;

import dto.Recipe;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RecipeDao {

    private static RecipeDao instance = new RecipeDao();

    private static final String URL =
            "jdbc:mysql://localhost:3306/cookshare?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul";
    private static final String USER = "root";
    private static final String PASSWORD = "1234";

    private RecipeDao() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static RecipeDao getInstance() {
        return instance;
    }

    private Connection getConnection() throws Exception {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    // 레시피 등록
    public int insertRecipe(Recipe recipe) {
        String sql = "INSERT INTO recipe(member_id, title, ingredients, steps, category, level, cook_time, image) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setString(1, recipe.getMemberId());
            pstmt.setString(2, recipe.getTitle());
            pstmt.setString(3, recipe.getIngredients());
            pstmt.setString(4, recipe.getSteps());
            pstmt.setString(5, recipe.getCategory());
            pstmt.setString(6, recipe.getLevel());
            pstmt.setInt(7, recipe.getCookTime());
            pstmt.setString(8, recipe.getImage());

            pstmt.executeUpdate();

            try (ResultSet rs = pstmt.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    // 최신 레시피 8개
    public List<Recipe> getLatestRecipes() {
        List<Recipe> list = new ArrayList<>();
        String sql = "SELECT * FROM recipe ORDER BY reg_date DESC LIMIT 8";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                Recipe r = new Recipe();
                r.setRecipeId(rs.getInt("recipe_id"));
                r.setMemberId(rs.getString("member_id"));
                r.setTitle(rs.getString("title"));
                r.setImage(rs.getString("image"));
                r.setCategory(rs.getString("category"));
                r.setLevel(rs.getString("level"));
                r.setCookTime(rs.getInt("cook_time"));
                list.add(r);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 좋아요 Top 5
    public List<Recipe> getTop5ByLikes() {
        List<Recipe> list = new ArrayList<>();
        String sql = "SELECT * FROM recipe ORDER BY likes_count DESC LIMIT 5";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                Recipe r = new Recipe();
                r.setRecipeId(rs.getInt("recipe_id"));
                r.setTitle(rs.getString("title"));
                r.setImage(rs.getString("image"));
                r.setLikesCount(rs.getInt("likes_count"));
                list.add(r);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // recipe_id로 가져오기
    public Recipe getRecipeById(int recipeId) {
        String sql = "SELECT * FROM recipe WHERE recipe_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, recipeId);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Recipe r = new Recipe();
                    r.setRecipeId(rs.getInt("recipe_id"));
                    r.setMemberId(rs.getString("member_id"));
                    r.setTitle(rs.getString("title"));
                    r.setIngredients(rs.getString("ingredients"));
                    r.setSteps(rs.getString("steps"));
                    r.setCategory(rs.getString("category"));
                    r.setLevel(rs.getString("level"));
                    r.setCookTime(rs.getInt("cook_time"));
                    r.setImage(rs.getString("image"));
                    r.setLikesCount(rs.getInt("likes_count"));
                    r.setRegDate(rs.getTimestamp("reg_date"));
                    return r;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // 내가 쓴 레시피 목록
    public List<Recipe> getRecipesByMember(String memberId) {
        List<Recipe> list = new ArrayList<>();

        String sql = "SELECT * FROM recipe WHERE member_id = ? ORDER BY recipe_id DESC";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, memberId);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Recipe r = new Recipe();
                    r.setRecipeId(rs.getInt("recipe_id"));
                    r.setMemberId(rs.getString("member_id"));
                    r.setTitle(rs.getString("title"));
                    r.setCategory(rs.getString("category"));
                    r.setLevel(rs.getString("level"));
                    r.setCookTime(rs.getInt("cook_time"));
                    r.setImage(rs.getString("image"));
                    r.setLikesCount(rs.getInt("likes_count"));
                    r.setRegDate(rs.getTimestamp("reg_date"));
                    list.add(r);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public void updateLikesCount(int recipeId, int newCount) {
        String sql = "UPDATE recipe SET likes_count = ? WHERE recipe_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, newCount);
            pstmt.setInt(2, recipeId);
            pstmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // -----------------------------------------------------------
    // 검색 기능 (keyword / category / level / cookTime / sort)
    // -----------------------------------------------------------
    public List<Recipe> searchRecipes(String keyword, String category,
                                      String level, String cookTime,
                                      String sort) {

        List<Recipe> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder("SELECT * FROM recipe WHERE 1=1");

        // 제목 검색
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND title LIKE ?");
        }

        // 종류(category)
        if (category != null && !category.trim().isEmpty()) {
            sql.append(" AND category = ?");
        }

        // 난이도(level)
        if (level != null && !level.trim().isEmpty()) {
            sql.append(" AND level = ?");
        }

        // 🔥 조리시간 필터 (범위 처리)
        if (cookTime != null && !cookTime.trim().isEmpty()) {
            switch (cookTime) {
                case "20": // 30분 미만
                    sql.append(" AND cook_time < 30");
                    break;

                case "45": // 30~60분
                    sql.append(" AND cook_time >= 30 AND cook_time <= 60");
                    break;

                case "90": // 60~120분
                    sql.append(" AND cook_time > 60 AND cook_time <= 120");
                    break;

                case "150": // 120분 이상
                    sql.append(" AND cook_time >= 120");
                    break;
            }
        }

        // 정렬
        if ("likes".equals(sort)) {
            sql.append(" ORDER BY likes_count DESC");
        } else {
            sql.append(" ORDER BY recipe_id DESC"); // 최신순
        }

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {

            int idx = 1;

            if (keyword != null && !keyword.trim().isEmpty()) {
                pstmt.setString(idx++, "%" + keyword + "%");
            }
            if (category != null && !category.trim().isEmpty()) {
                pstmt.setString(idx++, category);
            }
            if (level != null && !level.trim().isEmpty()) {
                pstmt.setString(idx++, level);
            }

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Recipe r = new Recipe();
                    r.setRecipeId(rs.getInt("recipe_id"));
                    r.setMemberId(rs.getString("member_id"));
                    r.setTitle(rs.getString("title"));
                    r.setCategory(rs.getString("category"));
                    r.setLevel(rs.getString("level"));
                    r.setCookTime(rs.getInt("cook_time"));
                    r.setImage(rs.getString("image"));
                    r.setLikesCount(rs.getInt("likes_count"));
                    r.setRegDate(rs.getTimestamp("reg_date"));
                    list.add(r);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // 레시피 수정
    public int updateRecipe(Recipe r) {
        String sql = "UPDATE recipe SET title=?, ingredients=?, steps=?, category=?, level=?, cook_time=?, image=? WHERE recipe_id=?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, r.getTitle());
            pstmt.setString(2, r.getIngredients());
            pstmt.setString(3, r.getSteps());
            pstmt.setString(4, r.getCategory());
            pstmt.setString(5, r.getLevel());
            pstmt.setInt(6, r.getCookTime());
            pstmt.setString(7, r.getImage());
            pstmt.setInt(8, r.getRecipeId());

            return pstmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // 레시피 삭제
    public int deleteRecipe(int recipeId) {
        String sql = "DELETE FROM recipe WHERE recipe_id=?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, recipeId);
            return pstmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

}
