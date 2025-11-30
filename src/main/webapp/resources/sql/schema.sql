CREATE DATABASE IF NOT EXISTS cookshare
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE cookshare;

-- 기존 테이블이 있다면 삭제 (외래키 순서 고려)
DROP TABLE IF EXISTS likes;
DROP TABLE IF EXISTS comment;
DROP TABLE IF EXISTS recipe;
DROP TABLE IF EXISTS member;

-- 1. member
CREATE TABLE member (
    member_id   VARCHAR(50)  PRIMARY KEY,
    password    VARCHAR(255) NOT NULL,
    name        VARCHAR(50)  NOT NULL,
    email       VARCHAR(100) NOT NULL,
    reg_date    DATETIME     NOT NULL DEFAULT NOW()
);

-- 2. recipe
CREATE TABLE recipe (
    recipe_id    INT AUTO_INCREMENT PRIMARY KEY,
    member_id    VARCHAR(50) NOT NULL,
    title        VARCHAR(100) NOT NULL,
    ingredients  TEXT         NOT NULL,
    steps        TEXT         NOT NULL,
    category     VARCHAR(20)  NOT NULL,   -- 한식/양식/중식/일식/기타
    level        VARCHAR(20)  NOT NULL,   -- 쉬움/보통/어려움
    cook_time    INT          NOT NULL,   -- 분 단위
    image        VARCHAR(255),            -- 파일명
    likes_count  INT          NOT NULL DEFAULT 0,
    reg_date     DATETIME     NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_recipe_member
        FOREIGN KEY (member_id) REFERENCES member(member_id)
        ON DELETE CASCADE
);

-- 3. comment
CREATE TABLE comment (
    comment_id  INT AUTO_INCREMENT PRIMARY KEY,
    recipe_id   INT          NOT NULL,
    member_id   VARCHAR(50)  NOT NULL,
    content     TEXT         NOT NULL,
    reg_date    DATETIME     NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_comment_recipe
        FOREIGN KEY (recipe_id) REFERENCES recipe(recipe_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_comment_member
        FOREIGN KEY (member_id) REFERENCES member(member_id)
        ON DELETE CASCADE
);

-- 4. likes
CREATE TABLE likes (
    member_id  VARCHAR(50) NOT NULL,
    recipe_id  INT         NOT NULL,
    reg_date   DATETIME    NOT NULL DEFAULT NOW(),
    PRIMARY KEY (member_id, recipe_id),
    CONSTRAINT fk_likes_member
        FOREIGN KEY (member_id) REFERENCES member(member_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_likes_recipe
        FOREIGN KEY (recipe_id) REFERENCES recipe(recipe_id)
        ON DELETE CASCADE
);
