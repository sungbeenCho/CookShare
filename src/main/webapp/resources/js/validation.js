// 로그인 폼 검사
function validateLogin(form) {
    if (form.memberId.value.trim() === "") {
        alert("아이디를 입력하세요.");
        form.memberId.focus();
        return false;
    }
    if (form.password.value.trim() === "") {
        alert("비밀번호를 입력하세요.");
        form.password.focus();
        return false;
    }
    return true;
}

// 회원가입 폼 검사
function validateSignup(form) {
    if (form.memberId.value.trim().length < 4) {
        alert("아이디는 최소 4자 이상 입력하세요.");
        form.memberId.focus();
        return false;
    }
    if (form.password.value.trim().length < 4) {
        alert("비밀번호는 최소 4자 이상 입력하세요.");
        form.password.focus();
        return false;
    }
    if (form.name.value.trim() === "") {
        alert("이름을 입력하세요.");
        form.name.focus();
        return false;
    }
    if (form.email.value.trim() === "") {
        alert("이메일을 입력하세요.");
        form.email.focus();
        return false;
    }
    var emailPattern = /^[^@\s]+@[^@\s]+\.[^@\s]+$/;
    if (!emailPattern.test(form.email.value.trim())) {
        alert("올바른 이메일 형식을 입력하세요.");
        form.email.focus();
        return false;
    }
    return true;
}
function validateRecipe(form) {
    if (form.title.value.trim() === "") {
        alert("제목을 입력하세요.");
        form.title.focus();
        return false;
    }
    if (form.cookTime.value.trim() === "" || isNaN(form.cookTime.value)) {
        alert("조리시간을 숫자로 입력하세요.");
        form.cookTime.focus();
        return false;
    }
    if (form.ingredients.value.trim() === "") {
        alert("재료를 입력하세요.");
        form.ingredients.focus();
        return false;
    }
	if (form.cookTime.value === "") {
	    alert("조리시간을 선택하세요.");
	    return false;
	}
    if (form.image.value.trim() === "") {
        alert("이미지 파일을 선택하세요.");
        return false;
    }
    return true;
}
