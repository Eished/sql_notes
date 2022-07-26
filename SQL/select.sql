-- Active: 1658517114424@@172.22.164.224@3306@imc_db

SELECT 'Hello ','MySQL',2022+1;

SELECT * FROM imc_db.imc_class;

SELECT class_id,class_name FROM imc_db.imc_class;

USE imc_db;

SELECT class_id,class_name FROM imc_class;

-- WHERE 语句

-- % 代表通配符，任意数量字符

SELECT title FROM imc_course WHERE title LIKE '%MYSQL%';

--

-- 学习人数等于1000人的课程都有那些？

-- 列出他们的课程标题和学习人数

SELECT title,study_cnt FROM imc_course WHERE study_cnt>1000;

SELECT title, study_cnt
FROM imc_course
WHERE
    study_cnt BETWEEN 1000 AND 2000;

-- is null

CREATE TABLE test_is(id int,c1 VARCHAR(10),PRIMARY KEY(id));

INSERT INTO test_is VALUES(1,'a'),(2,'b'),(3,NULL);

SELECT * from test_is WHERE c1=NULL;

SELECT * from test_is WHERE c1 is NULL;

-- LIKE 和 NOT LIKE

SELECT 'this is mysql' LIKE '%mysql';

SELECT 'this is mysql course' LIKE '%mysql%';

SELECT 'this' LIKE '_hi_';

-- IN 和 NOT IN

SELECT course_id, title
from imc_course
WHERE
    course_id in (1, 3, 5, 7, 9);

SELECT course_id, title
FROM imc_course
WHERE
    course_id NOT IN (1, 3, 5, 7, 9);

-- AND &&

SELECT title, study_cnt
FROM imc_course
WHERE
    title LIKE '%mysql%' && study_cnt > 5000;

-- OR ||

SELECT title, study_cnt
FROM imc_course
WHERE
    title LIKE '%mysql%' || study_cnt > 5000;

-- UNION ALL 拼接两次查询

SELECT title, study_cnt
FROM imc_course
WHERE
    title LIKE '%mysql%'
    AND study_cnt < 5000
UNION ALL
SELECT title, study_cnt
FROM imc_course
WHERE
    title NOT LIKE '%mysql%'
    AND study_cnt > 5000;

-- XOR

SELECT title, study_cnt
FROM imc_course
WHERE
    title LIKE '%mysql%'
    AND study_cnt < 5000
    XOR title NOT LIKE '%mysql%'
    AND study_cnt > 5000;

-- JOIN

INSERT INTO
    imc_course(
        title,
        title_desc,
        type_id,
        class_id,
        level_id,
        online_time,
        user_id
    )
VALUES (
        'MySQL 关联测试',
        '测试 MySQL 关联查询',
        8,
        1,
        1,
        NOW(),
        29
    );

SELECT
    a.course_id,
    a.title,
    b.chapter_name
FROM imc_course a
    LEFT JOIN imc_chapter b ON b.course_id = a.course_id
WHERE a.title like '%MySQL%';

-- 普通写法

SELECT a.course_id, a.title
FROM imc_course a
WHERE a.course_id NOT IN (
        SELECT b.course_id
        FROM imc_chapter b
    );

-- LEFT JOIN

SELECT a.course_id, a.title
FROM imc_course a
    LEFT JOIN imc_chapter b on b.course_id = a.course_id
WHERE b.course_id IS NULL;

-- RIGHT JOIN

SELECT a.course_id, a.title
FROM imc_chapter b
    RIGHT JOIN imc_course a on b.course_id = a.course_id
WHERE b.course_id IS NULL;

-- GROUP BY

SHOW VARIABLES LIKE 'sql_mode';

SET SESSION sql_mode='ONLY_FULL_GROUP_BY';

SELECT
    level_name,
    class_name,
    COUNT(*)
FROM imc_course a
    JOIN imc_class b ON b.class_id = a.class_id
    JOIN imc_level c on c.level_id = a.level_id
GROUP BY
    level_name,
    class_name;

-- GROUP BY HAVING

SELECT
    level_name,
    class_name,
    COUNT(*)
FROM imc_course a
    JOIN imc_class b ON b.class_id = a.class_id
    JOIN imc_level c on c.level_id = a.level_id
GROUP BY
    level_name,
    class_name
HAVING COUNT(*) > 3;

-- COUNT

SELECT COUNT(*),COUNT(DISTINCT user_id) FROM imc_course;

-- SUM

SELECT
    b.level_name,
    SUM(study_cnt)
FROM imc_course a
    JOIN imc_level b ON b.level_id = a.level_id
GROUP BY level_name;

-- AVG

SELECT sum(study_cnt)/COUNT(study_cnt) FROM imc_course;

SELECT AVG(study_cnt) FROM imc_course;

-- 综合运用

UPDATE imc_course a
    JOIN (
        SELECT
            course_id,
            AVG(content_score) AS avg_content,
            AVG(level_score) AS avg_level,
            AVG(logic_score) AS avg_logic,
            AVG(score) AS avg_score
        FROM imc_classvalue
        GROUP BY
            course_id
    ) b ON a.course_id = b.course_id
SET
    a.content_score = b.avg_content,
    a.level_score = b.avg_level,
    a.logic_score = b.avg_logic,
    a.score = b.avg_score;

SHOW WARNINGS;

SELECT * FROM imc_course;

-- MAX

SELECT title, study_cnt
from imc_course
WHERE study_cnt = (
        SELECT MIN(study_cnt)
        FROM imc_course
    );

-- ORDER BY

SELECT title, study_cnt from imc_course ORDER BY study_cnt DESC;

-- LIMIT

SELECT course_id, title
FROM imc_course
ORDER BY course_id
LIMIT 10, 10;

-- VIEW

CREATE VIEW vm_course AS 
	SELECT
	    a.course_id,
	    a.title,
	    b.class_name,
	    c.type_name,
	    d.level_name
	FROM imc_course a
	    JOIN imc_class b ON b.class_id = a.class_id
	    JOIN imc_type c ON c.type_id = a.type_id
	    JOIN imc_level d ON d.level_id = a.
level_id; 

SELECT * from vm_course;

-- DELETE

SELECT *
FROM imc_course a
    LEFT JOIN imc_chapter b ON a.course_id = b.course_id
WHERE b.chapter_id is NULL;

DELETE a
FROM imc_course a
    LEFT JOIN imc_chapter b ON a.course_id = b.course_id
WHERE b.chapter_id is NULL;

-- DELETE 实战

SHOW CREATE TABLE imc_type;

SELECT * FROM imc_type;

INSERT INTO
    imc_type(type_name)
VALUES ('前端开发'), ('后端开发'), ('移动开发'), ('数据库');

SELECT *
FROM imc_type a
    JOIN(
        SELECT
            type_name,
            COUNT(*),
            MIN(type_id) AS min_type_id
        FROM imc_type
        GROUP BY type_name
        HAVING
            COUNT(*) > 1
    ) b ON a.type_name = b.type_name
    AND a.type_id > min_type_id;

DELETE a
FROM imc_type a
    JOIN(
        SELECT
            type_name,
            COUNT(*),
            MIN(type_id) AS min_type_id
        FROM imc_type
        GROUP BY type_name
        HAVING
            COUNT(*) > 1
    ) b ON a.type_name = b.type_name
    AND a.type_id > min_type_id;

CREATE UNIQUE INDEX uqx_typename ON imc_type(type_name);

-- UPDATE

SELECT user_nick,user_status FROM imc_user WHERE user_nick='沙占';

UPDATE imc_user SET user_status=0 WHERE user_nick='沙占';

-- UPDATE 实战

ALTER TABLE imc_course
ADD
    is_recommand TINYINT DEFAULT 0 COMMENT '0不推荐，1推荐';

SHOW CREATE TABLE imc_course;

SELECT course_id FROM imc_course ORDER BY RAND() LIMIT 10;

UPDATE imc_course SET is_recommand=1 ORDER BY RAND() LIMIT 10;

SELECT course_id,title FROM imc_course WHERE is_recommand=1;

-- 系统函数

-- 时间函数

SELECT CURRENT_DATE(),CURTIME(),NOW();

-- DATE_FORMAT

SELECT DATE_FORMAT(NOW(),'%Y-%m-%d %H:%i:%s');

-- CONVERT TIME

SELECT SEC_TO_TIME('60'),TIME_TO_SEC('1:00:00');

-- DATEDIFF

SELECT
    title,
    DATEDIFF(NOW(), online_time)
FROM imc_course
ORDER BY 2 DESC;

SELECT
    NOW(),
    -- 当前时间加一天 
    DATE_ADD(NOW(), INTERVAL 1 DAY),
    -- 当前时间加一年 
    DATE_ADD(NOW(), INTERVAL 1 YEAR),
    -- 当前时间减一个半小时
    DATE_ADD(
        NOW(),
        INTERVAL '-1:30' HOUR_MINUTE
    );

-- EXTRACT

SELECT
    NOW(),
    -- 年份
    EXTRACT(
        YEAR
        FROM
            NOW()
    ),
    EXTRACT(
        MONTH
        FROM
            NOW()
    ),
    EXTRACT(
        DAY
        FROM
            NOW()
    ),
    EXTRACT(
        HOUR
        FROM NOW()
    );

-- CONCAT

SELECT
    CONCAT_WS('-', class_name, title)
FROM imc_course a
    JOIN imc_class b ON a.class_id = b.class_id;

-- LENGTH CHARLENGTH

SELECT
    class_name,
    LENGTH(class_name),
    CHAR_LENGTH(class_name)
FROM imc_class;

-- FORMAT

SELECT FORMAT(123456.789,4);

-- LEFT RIGHT

SELECT LEFT('imooc',1);

SELECT RIGHT('imooc',4);

-- SUBSTRING

SELECT SUBSTRING('imooc',2);

-- SUBSTRING_INDEX

SELECT SUBSTRING_INDEX('192.168.0.100','.',-2);

-- LOCATE

SELECT
    title,
    LOCATE('-', title),
    SUBSTRING(title, 1, LOCATE('-', title) -1),
    SUBSTRING_INDEX(title, '-', 1)
FROM imc_course;

-- TRIM

SELECT TRIM(' imooc '),TRIM('x' from 'xxxximoocxx');

-- CASE WHEN

SELECT
    user_nick,
    CASE
        WHEN sex = 1 THEN '男'
        WHEN sex = 0 THEN '女'
        ELSE '未知'
    END AS '性别'
FROM imc_user;

SELECT
    user_nick,
    CASE
        WHEN sex = 1 THEN '男'
        WHEN sex = 0 THEN '女'
        ELSE '未知'
    END AS '性别'
FROM imc_user
WHERE
    CASE
        WHEN sex = 1 THEN '男'
        WHEN sex = 0 THEN '女'
        ELSE '未知'
    END = '男';