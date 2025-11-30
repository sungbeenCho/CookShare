package dao;

import dto.Recipe;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class LikeDao {

    private static LikeDao instance = new LikeDao();

    private static final String URL =
            "jdbc:mysql://localhost:3306/cookshare?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul";
    private static final String USER = "root";
    private static final String PASSWORD = "1234";

    private LikeDao() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static LikeDao getInstance() {
        return instance;
    }

    private Connection getConnection() throws Exception {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    // 특정 유저가 특정 레시피에 이미 좋아요를 눌렀는지 확인
    public boolean isLiked(String memberId, int recipeId) {
        String sql = "SELECT 1 FROM likes WHERE member_id = ? AND recipe_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, memberId);
            pstmt.setInt(2, recipeId);

            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 좋아요 추가
    public int addLike(String memberId, int recipeId) {
        String sql = "INSERT INTO likes(member_id, recipe_id) VALUES(?, ?)";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, memberId);
            pstmt.setInt(2, recipeId);

            return pstmt.executeUpdate();

        } catch (Exception e) {
            // 이미 PK 중복(같은 사람 같은 레시피에 또 누름)일 수도 있음
            e.printStackTrace();
        }
        return 0;
    }

    // 좋아요 취소
    public int removeLike(String memberId, int recipeId) {
        String sql = "DELETE FROM likes WHERE member_id = ? AND recipe_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, memberId);
            pstmt.setInt(2, recipeId);

            return pstmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // 해당 레시피의 좋아요 개수
    public int countLikes(int recipeId) {
        String sql = "SELECT COUNT(*) FROM likes WHERE recipe_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, recipeId);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // 로그인한 유저가 좋아요한 레시피 목록
    public List<Recipe> getLikedRecipes(String memberId) {
        List<Recipe> list = new ArrayList<>();

        String sql = "SELECT r.* FROM likes l " +
                     "JOIN recipe r ON l.recipe_id = r.recipe_id " +
                     "WHERE l.member_id = ? " +
                     "ORDER BY r.recipe_id DESC";

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
}
