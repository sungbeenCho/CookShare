CREATE DATABASE IF NOT EXISTS cookshare
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE cookshare;

DROP TABLE IF EXISTS likes;
DROP TABLE IF EXISTS comment;
DROP TABLE IF EXISTS recipe;
DROP TABLE IF EXISTS member;

CREATE TABLE member (
    member_id   VARCHAR(50)  PRIMARY KEY,
    password    VARCHAR(255) NOT NULL,
    name        VARCHAR(50)  NOT NULL,
    email       VARCHAR(100) NOT NULL,
    reg_date    DATETIME     NOT NULL DEFAULT NOW()
);

CREATE TABLE recipe (
    recipe_id    INT AUTO_INCREMENT PRIMARY KEY,
    member_id    VARCHAR(50) NOT NULL,
    title        VARCHAR(100) NOT NULL,
    ingredients  TEXT         NOT NULL,
    steps        TEXT         NOT NULL,
    category     VARCHAR(20)  NOT NULL,
    level        VARCHAR(20)  NOT NULL,
    cook_time    INT          NOT NULL,
    image        VARCHAR(255),
    likes_count  INT          NOT NULL DEFAULT 0,
    reg_date     DATETIME     NOT NULL DEFAULT NOW(),
    FOREIGN KEY (member_id) REFERENCES member(member_id) ON DELETE CASCADE
);

CREATE TABLE comment (
    comment_id  INT AUTO_INCREMENT PRIMARY KEY,
    recipe_id   INT          NOT NULL,
    member_id   VARCHAR(50)  NOT NULL,
    content     TEXT         NOT NULL,
    reg_date    DATETIME     NOT NULL DEFAULT NOW(),
    FOREIGN KEY (recipe_id) REFERENCES recipe(recipe_id) ON DELETE CASCADE,
    FOREIGN KEY (member_id) REFERENCES member(member_id) ON DELETE CASCADE
);

CREATE TABLE likes (
    member_id  VARCHAR(50) NOT NULL,
    recipe_id  INT         NOT NULL,
    reg_date   DATETIME    NOT NULL DEFAULT NOW(),
    PRIMARY KEY (member_id, recipe_id),
    FOREIGN KEY (member_id) REFERENCES member(member_id) ON DELETE CASCADE,
    FOREIGN KEY (recipe_id) REFERENCES recipe(recipe_id) ON DELETE CASCADE
);
