<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.MemberDao,dto.Member" %>

<%
    request.setCharacterEncoding("UTF-8");

    String memberId = request.getParameter("memberId");
    String password = request.getParameter("password");

    MemberDao memberDao = MemberDao.getInstance();
    Member member = memberDao.login(memberId, password);

    if (member != null) {
        session.setAttribute("user", member);
        response.sendRedirect("welcome.jsp");
    } else {
        response.sendRedirect("login.jsp?error=1");
    }
%>
