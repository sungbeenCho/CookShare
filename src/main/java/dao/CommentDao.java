package dao;

import dto.Comment;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CommentDao {

    private static CommentDao instance = new CommentDao();

    private static final String URL =
            "jdbc:mysql://localhost:3306/cookshare?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul";
    private static final String USER = "root";
    private static final String PASSWORD = "1234";

    private CommentDao() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static CommentDao getInstance() {
        return instance;
    }

    private Connection getConnection() throws Exception {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    // ----------------------------------------------------
    // 댓글 등록
    // ----------------------------------------------------
    public int addComment(Comment cmt) {
        String sql = "INSERT INTO comment(recipe_id, member_id, content, reg_date) VALUES(?, ?, ?, NOW())";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, cmt.getRecipeId());
            pstmt.setString(2, cmt.getMemberId());
            pstmt.setString(3, cmt.getContent());

            return pstmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ----------------------------------------------------
    // 댓글 목록 가져오기 (recipeDetail.jsp)
    // ----------------------------------------------------
    public List<Comment> getCommentsByRecipe(int recipeId) {
        List<Comment> list = new ArrayList<>();
        String sql = "SELECT * FROM comment WHERE recipe_id = ? ORDER BY comment_id DESC";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, recipeId);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Comment c = new Comment();
                    c.setCommentId(rs.getInt("comment_id"));
                    c.setRecipeId(rs.getInt("recipe_id"));
                    c.setMemberId(rs.getString("member_id"));
                    c.setContent(rs.getString("content"));
                    c.setRegDate(rs.getTimestamp("reg_date"));
                    list.add(c);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ----------------------------------------------------
    // 댓글 1개 조회 (댓글 수정 시 필요)
    // ----------------------------------------------------
    public Comment getCommentById(int commentId) {
        Comment c = null;

        String sql = "SELECT * FROM comment WHERE comment_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, commentId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                c = new Comment();
                c.setCommentId(rs.getInt("comment_id"));
                c.setRecipeId(rs.getInt("recipe_id"));
                c.setMemberId(rs.getString("member_id"));
                c.setContent(rs.getString("content"));
                c.setRegDate(rs.getTimestamp("reg_date"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return c;
    }

    // ----------------------------------------------------
    // 댓글 삭제 (작성자 본인만)
    // ----------------------------------------------------
    public int deleteComment(int commentId, String memberId) {
        String sql = "DELETE FROM comment WHERE comment_id = ? AND member_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, commentId);
            pstmt.setString(2, memberId);

            return pstmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ----------------------------------------------------
    // 댓글 수정 (작성자 본인만)
    // ----------------------------------------------------
    public int updateComment(int commentId, String memberId, String content) {
        String sql = "UPDATE comment SET content = ? WHERE comment_id = ? AND member_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, content);
            pstmt.setInt(2, commentId);
            pstmt.setString(3, memberId);

            return pstmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ----------------------------------------------------
    // 마이페이지: 내가 쓴 댓글들 가져오기
    // ----------------------------------------------------
    public List<Comment> getCommentsByMember(String memberId) {
        List<Comment> list = new ArrayList<>();

        String sql =
                "SELECT c.comment_id, c.content, c.reg_date, r.title, r.recipe_id " +
                "FROM comment c " +
                "JOIN recipe r ON c.recipe_id = r.recipe_id " +
                "WHERE c.member_id = ? " +
                "ORDER BY c.comment_id DESC";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, memberId);

            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                Comment c = new Comment();
                c.setCommentId(rs.getInt("comment_id"));
                c.setContent(rs.getString("content"));
                c.setRegDate(rs.getTimestamp("reg_date"));
                c.setRecipeId(rs.getInt("recipe_id"));
                c.setRecipeTitle(rs.getString("title"));
                list.add(c);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}
