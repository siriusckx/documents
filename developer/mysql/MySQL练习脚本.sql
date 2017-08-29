/*=========MySql常用快捷键==================
新建tab(new tab) ctrl+t
执行当前语句(execute current statement) ctrl+enter
执行全部或选中的语句(execute all or selection) ctrl+shift+enter
查看执行计划(explain current statement) ctrl+alt+x
注释 - -加空格，如 – select * from t; 
*/
/*----------------------------------------------数据库基本操作------------------------------------*/
-- 展示所有数据库
SHOW DATABASES;
-- 创建数据库pets
CREATE DATABASE pets;
-- 切换到数据库
USE pets;
-- 创建表cats
create TABLE cats(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT, # unique ID
    name VARCHAR(150) NOT NULL, # Name of the cat
    owner VARCHAR(150) NOT NULL, # Owner of the cat
    birth DATE NOT NULL, #Birthday of the cat
    PRIMARY KEY (id) # Make the id the primary key
);
-- 展示所有的表
SHOW TABLES;
-- 展示cats的表结构
DESCRIBE cats;
-- 往cats插入两条数据
INSERT INTO cats(name,owner,birth) VALUES
('Sandy','Lennon','2015-01-03'),
( 'Cookie', 'Casey', '2013-11-13' ),
( 'Charlie', 'River', '2016-05-21' );
-- 查询cats表所有记录
SELECT * FROM cats;
-- 根据属性查询属性
SELECT name FROM cats WHERE owner = 'Casey';

