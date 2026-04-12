CREATE DATABASE IF NOT EXISTS `114_JDBC`
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE `114_JDBC`;

DROP TABLE IF EXISTS `electiveSub`;
DROP TABLE IF EXISTS `course`;
DROP TABLE IF EXISTS `user`;

CREATE TABLE `user` (
    `uId` VARCHAR(20) NOT NULL PRIMARY KEY,
    `uName` VARCHAR(30) NOT NULL,
    `uPw` VARCHAR(30) NOT NULL,
    `uSchool` VARCHAR(50) NOT NULL,
    `uDepartment` VARCHAR(50) NOT NULL
);

CREATE TABLE `course` (
    `cId` INT NOT NULL PRIMARY KEY,
    `cName` VARCHAR(50) NOT NULL,
    `cType` VARCHAR(10) NOT NULL
);

CREATE TABLE `electiveSub` (
    `uId` VARCHAR(20) NOT NULL,
    `cId` INT NOT NULL,
    `grade` INT NULL,
    PRIMARY KEY (`uId`, `cId`),
    CONSTRAINT `fk_elective_user` FOREIGN KEY (`uId`) REFERENCES `user`(`uId`),
    CONSTRAINT `fk_elective_course` FOREIGN KEY (`cId`) REFERENCES `course`(`cId`)
);

INSERT INTO `user` (`uId`, `uName`, `uPw`, `uSchool`, `uDepartment`) VALUES
('114001', '张三', 'abc123', '计算机学院', '软件工程'),
('114002', '李四', 'code456', '经济管理学院', '会计学'),
('114003', '王五', 'java789', '外国语学院', '英语');

INSERT INTO `course` (`cId`, `cName`, `cType`) VALUES
(1, 'Java程序设计', '必修'),
(2, '数据库原理', '必修'),
(3, '数据挖掘', '选修'),
(4, '软件工程导论', '必修'),
(5, '计算机网络', '必修'),
(6, '面向互联网的软件课程设计', '选修'),
(7, '人工智能基础', '选修'),
(8, '商务英语', '选修'),
(9, '市场营销学', '选修'),
(10, '会计信息系统', '选修');

INSERT INTO `electiveSub` (`uId`, `cId`, `grade`) VALUES
('114001', 1, 95),
('114001', 3, 90),
('114001', 6, 98),
('114002', 2, 88),
('114002', 9, 91),
('114002', 10, 87),
('114003', 5, 86),
('114003', 8, 93);
