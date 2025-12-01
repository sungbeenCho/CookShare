# CookShare — 레시피 공유 플랫폼

## 🔎 프로젝트 개요  
- 현대인들은 온라인에서 다양한 레시피를 검색하고 공유하는 데 익숙하지만 기존 플랫폼은 복잡하거나 광고가 많아 사용자 경험이 떨어지는 경우가 많다. 본 프로젝트는 간단하고 직관적인 UI 그리고 사용자 참여가 가능한 경량 레시피 공유 서비스를 목표로 한다.
- CookShare는 사용자가 레시피를 등록·공유하고, 좋아요·댓글 기능을 통해 소통할 수 있으며, 최근 본 레시피 기능과 다국어 UI를 제공함으로써 실사용 환경에 가까운 웹 애플리케이션을 구현했다.



## 🛠️ 기술 스택  
- 개발 도구 :	Eclipse IDE (Dynamic Web Project)
- 서버 :	Apache Tomcat 10.1
- 언어 :	Java(JSP), HTML/CSS, JavaScript
- 데이터베이스 :	MySQL 8.0.33
- 라이브러리 :	Bootstrap 5, JSTL, MySQL Connector/J
- 버전관리 :	GitHub
- 실행경로 :	http://localhost:8080/CookShare

## 🚀 설치 & 실행 방법  
1. 프로젝트 다운로드 또는 Git Clone

2. Eclipse → Import → Dynamic Web Project Import

3. MySQL에서 schema.sql 실행하여 테이블 생성(resources/sql/schema.sql)

4. RecipeDao, LikeDao, CommentDao, MemberDao의 DB URL/USER/PASSWORD 확인

5. Tomcat 10.1에 프로젝트 Run

6. 브라우저에서 http://localhost:8080/CookShare/login.jsp 접속


## 🏗️ 프로젝트 구조  
### 디렉토리 구조
<img width="447" height="459" alt="프젝 구조" src="https://github.com/user-attachments/assets/467bc8de-cfd7-4a1f-9997-74b33628202d" />

### 주요 패키지 / 모듈 설명

#### dao (DB 연동)

MemberDao: 회원가입 / 로그인 처리

RecipeDao: 레시피 CRUD + 검색

LikeDao: 좋아요 등록/해제

CommentDao: 댓글 CRUD


#### dto (데이터 객체)

Member / Recipe / Comment / Like: 각 테이블과 매핑되는 데이터 클래스


#### bundle (다국어)

message.properties (한국어)

message_en.properties (영어)


### DB 테이블 / 엔티티 구조 요약
  
#### Member (회원 정보 저장)

PK: member_id

password

name

email



#### Recipe (레시피 기본 정보 + 좋아요 수)

PK: recipe_id

FK: member_id

title

ingredients

steps

category

level

cook_time

image

likes_count

reg_date



#### Comment (댓글 정보 저장)

PK: comment_id

FK: recipe_id, member_id

content

reg_date



#### Like (좋아요 여부 저장)

PK: (member_id + recipe_id)

member_id (FK → Member)

recipe_id (FK → Recipe)



### ERD 관계 요약

Member 1 ─ N Recipe

Member 1 ─ N Comment

Recipe 1 ─ N Comment

Member N ─ M Recipe (Like 테이블로 연결)

## ✅ 주요 기능 & 특징  
- 회원 로그인/로그아웃
- 레시피 등록 / 수정 / 삭제
- 이미지 업로드 (Multipart)
- 좋아요 / 좋아요 취소
- 댓글 작성 / 수정 / 삭제
- 검색 필터 (종류, 난이도, 조리시간, 키워드)
- 최신순 / 좋아요순 정렬
- 최근 본 레시피 (쿠키로 저장, 최대 5개)
- KO / EN 다국어 지원 (JSTL fmt, message.properties)
  
## 👥 팀 / Contributors  
- 조성빈


