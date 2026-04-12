CREATE DATABASE IF NOT EXISTS `114_JDBC`
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE `114_JDBC`;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS `electiveSub`;
DROP TABLE IF EXISTS `course`;
DROP TABLE IF EXISTS `user`;

SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE `user` (
    `uId` VARCHAR(20) NOT NULL COMMENT '学生学号',
    `uName` VARCHAR(30) NOT NULL COMMENT '学生姓名',
    `uPw` VARCHAR(30) NOT NULL COMMENT '登录密码',
    `uSchool` VARCHAR(50) NOT NULL COMMENT '所在学院',
    `uDepartment` VARCHAR(50) NOT NULL COMMENT '所在系',
    PRIMARY KEY (`uId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `course` (
    `cId` INT NOT NULL COMMENT '课程编号',
    `cName` VARCHAR(50) NOT NULL COMMENT '课程名称',
    `cType` VARCHAR(10) NOT NULL COMMENT '课程类型',
    PRIMARY KEY (`cId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `electiveSub` (
    `uId` VARCHAR(20) NOT NULL COMMENT '学生学号',
    `cId` INT NOT NULL COMMENT '课程编号',
    `grade` INT DEFAULT NULL COMMENT '课程成绩',
    PRIMARY KEY (`uId`, `cId`),
    CONSTRAINT `fk_elective_user`
        FOREIGN KEY (`uId`) REFERENCES `user` (`uId`)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT `fk_elective_course`
        FOREIGN KEY (`cId`) REFERENCES `course` (`cId`)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `user` (`uId`, `uName`, `uPw`, `uSchool`, `uDepartment`) VALUES
('924106840540', '张航', 'a123', '计算机学院', '计算机科学与技术'),
('924106840541', '张学长', 'b123', '计算机学院', '软件工程'),
('924106840539', '喻学长', 'c123', '计算机学院', '计算机科学与技术'),
('924000000000', '经济李同学', 'd123', '经济管理学院', '工商管理');

INSERT INTO `course` (`cId`, `cName`, `cType`) VALUES
(1, 'Java程序设计', '必修'),
(2, '数据库原理', '必修'),
(3, '数据结构', '选修'),
(4, '计算机逻辑设计', '必修'),
(5, '计算机网络', '必修'),
(6, 'Web应用开发', '选修'),
(7, '人工智能基础', '选修'),
(8, '商务英语', '选修'),
(9, '市场营销学', '选修'),
(10, '会计信息系统', '选修');

INSERT INTO `electiveSub` (`uId`, `cId`, `grade`) VALUES
('924106840540', 1, 95),
('924106840540', 3, 90),
('924106840540', 6, 98),
('924106840541', 2, 92),
('924106840541', 4, 89),
('924106840541', 7, 94),
('924106840539', 5, 86),
('924106840539', 8, 93),
('924000000000', 9, 88),
('924000000000', 10, 91);
