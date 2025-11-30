<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>

<script type="text/javascript" src="./resources/js/validation.js"></script>

<div class="auth-card p-4">
    <h3 class="text-center mb-4">CookShare 로그인</h3>
	<c:if test="${param.signupSuccess == '1'}">
    	<div class="alert alert-success" role="alert">
        	회원가입이 정상적으로 완료되었습니다! 로그인해주세요.
    	</div>
	</c:if>
    <c:if test="${not empty param.error}">
        <div class="alert alert-danger" role="alert">
            아이디 또는 비밀번호가 올바르지 않습니다.
        </div>
    </c:if>

    <form action="loginProcess.jsp" method="post" onsubmit="return validateLogin(this);">
        <div class="mb-3">
            <label for="memberId" class="form-label">아이디</label>
            <input type="text" class="form-control" id="memberId" name="memberId">
        </div>
        <div class="mb-3">
            <label for="password" class="form-label">비밀번호</label>
            <input type="password" class="form-control" id="password" name="password">
        </div>
        <button type="submit" class="btn btn-orange w-100 mb-2">로그인</button>
        <a href="signup.jsp" class="btn btn-outline-secondary w-100">회원가입</a>
    </form>
</div>

<%@ include file="footer.jsp" %>
