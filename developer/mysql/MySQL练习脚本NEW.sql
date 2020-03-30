-- 显示数据库
 SHOW DATABASES;
-- 创建数据库pets
 CREATE DATABASE pets;
-- 使用数据库 
 USE pets; 
-- 设置为非安全模式
SET SQL_SAFE_UPDATES = 0;
-- 删除表cats
DROP TABLE cats;
-- 创建表cats
CREATE TABLE cats
(
  id              INT unsigned NOT NULL AUTO_INCREMENT, # Unique ID for the record
  name            VARCHAR(150) NOT NULL,                # Name of the cat
  owner           VARCHAR(150) NOT NULL,                # Owner of the cat
  birth           DATE NOT NULL,                        # Birthday of the cat
  PRIMARY KEY     (id)                                  # Make the id the primary key
);
-- 显示表结构
 DESCRIBE cats;
-- 往cats插入数据
INSERT INTO cats(name,owner,birth) VALUES
( 'Sandy', 'Lennon', '2015-01-03' ),
( 'Cookie', 'Casey', '2013-11-13' ),
( 'Charlie', 'River', '2016-05-21' );
-- 查询cats
SELECT name FROM cats WHERE owner = 'Casey';
-- 删除cats
DELETE FROM cats WHERE name='Cookie';
-- 修改表增加字段
ALTER TABLE cats ADD gender CHAR(1) AFTER name;
-- 显示创建表语句
SHOW CREATE TABLE cats;

-- 用户管理--------------------------------------------------------------------------alter











