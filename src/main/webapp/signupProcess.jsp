<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.MemberDao,dto.Member" %>

<%
    request.setCharacterEncoding("UTF-8");

    String memberId = request.getParameter("memberId");
    String password = request.getParameter("password");
    String name = request.getParameter("name");
    String email = request.getParameter("email");

    MemberDao memberDao = MemberDao.getInstance();

    // 아이디 중복 체크
    if (memberDao.isExistId(memberId)) {
        response.sendRedirect("signup.jsp?duplicate=1");
        return;
    }

    Member member = new Member(memberId, password, name, email);
    int result = memberDao.insertMember(member);

    if (result > 0) {
        response.sendRedirect("login.jsp?signupSuccess=1");
    } else {
        response.sendRedirect("error.jsp");
    }
%>
