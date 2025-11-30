package dao;

import dto.Member;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class MemberDao {

    private static MemberDao instance = new MemberDao();

    // DB 접속 정보 (여기만 네 환경에 맞게 수정)
    private static final String URL =
            "jdbc:mysql://localhost:3306/cookshare?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul";
    private static final String USER = "root";   // 네 MySQL 사용자명
    private static final String PASSWORD = "1234";   // 네 비밀번호

    private MemberDao() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static MemberDao getInstance() {
        return instance;
    }

    private Connection getConnection() throws Exception {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    // 회원가입
    public int insertMember(Member member) {
        String sql = "INSERT INTO member(member_id, password, name, email) VALUES (?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, member.getMemberId());
            pstmt.setString(2, member.getPassword());
            pstmt.setString(3, member.getName());
            pstmt.setString(4, member.getEmail());

            return pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ID 중복 체크
    public boolean isExistId(String memberId) {
        String sql = "SELECT member_id FROM member WHERE member_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, memberId);
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next(); // 있으면 true
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 로그인
    public Member login(String memberId, String password) {
        String sql = "SELECT member_id, password, name, email, reg_date " +
                     "FROM member WHERE member_id = ? AND password = ?";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, memberId);
            pstmt.setString(2, password);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Member member = new Member();
                    member.setMemberId(rs.getString("member_id"));
                    member.setPassword(rs.getString("password"));
                    member.setName(rs.getString("name"));
                    member.setEmail(rs.getString("email"));
                    member.setRegDate(rs.getTimestamp("reg_date"));
                    return member;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null; // 로그인 실패
    }
}
