<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>

<script type="text/javascript" src="./resources/js/validation.js"></script>

<div class="auth-card p-4">
    <h3 class="text-center mb-4">회원가입</h3>

    <c:if test="${not empty param.duplicate}">
        <div class="alert alert-danger" role="alert">
            이미 사용 중인 아이디입니다.
        </div>
    </c:if>

    <form action="signupProcess.jsp" method="post" onsubmit="return validateSignup(this);">
        <div class="mb-3">
            <label for="memberId" class="form-label">아이디</label>
            <input type="text" class="form-control" id="memberId" name="memberId">
        </div>
        <div class="mb-3">
            <label for="password" class="form-label">비밀번호</label>
            <input type="password" class="form-control" id="password" name="password">
        </div>
        <div class="mb-3">
            <label for="name" class="form-label">이름</label>
            <input type="text" class="form-control" id="name" name="name">
        </div>
        <div class="mb-3">
            <label for="email" class="form-label">이메일</label>
            <input type="text" class="form-control" id="email" name="email">
        </div>
        <button type="submit" class="btn btn-orange w-100">회원가입 완료</button>
    </form>
</div>

<%@ include file="footer.jsp" %>
