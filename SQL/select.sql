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

SET
    SESSION sql_mode = 'ONLY_FULL_GROUP_BY,
STRICT_TRANS_TABLES,
NO_ZERO_IN_DATE,
NO_ZERO_DATE,
ERROR_FOR_DIVISION_BY_ZERO,
NO_ENGINE_SUBSTITUTION';

-- 移除

SET SESSION sql_mode = (
        SELECT
        REPLACE (
                @ @sql_mode,
                'ONLY_FULL_GROUP_BY,',
                ''
            )
    );

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
    a.score = (
        content_score + level_score + logic_score
    ) / 3;

SHOW WARNINGS;

SELECT * FROM imc_course;

SELECT * FROM imc_classvalue;

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

-- CTE

WITH cte AS (
        SELECT
            title,
            study_cnt,
            class_id
        FROM imc_course
        WHERE study_cnt > 2000
    )
SELECT *
FROM cte
UNION ALL
SELECT *
FROM cte
ORDER BY 1 DESC;

-- WITH RECURSIVE

WITH RECURSIVE test AS (
        SELECT 1 AS n
        UNION ALL
        SELECT 1 + n
        FROM test
        WHERE n < 10
    )
SELECT *
FROM test;

-- WITH RECURSIVE QUERY

WITH
    RECURSIVE replay(
        quest_id,
        quest_title,
        user_id,
        replyid,
        q_path
    ) AS(
        SELECT
            quest_id,
            quest_title,
            user_id,
            replyid,
            CAST(quest_id AS CHAR(200)) AS q_path
        FROM imc_question
        WHERE
            course_id = 59
            AND replyid = 0
        UNION ALL
        SELECT
            a.quest_id,
            a.quest_title,
            a.user_id,
            a.replyid,
            CONCAT(b.q_path, '>>', a.quest_id) AS q_path
        FROM imc_question a
            JOIN replay b ON a.replyid = b.quest_id
    )
SELECT *
FROM replay;

-- 窗口函数

WITH
    test(study_name, class_name, score) AS(
        SELECT
            'sqlercn',
            'MySQL',
            95
        UNION ALL
        SELECT
            'tom',
            'MySQL',
            99
        UNION ALL
        SELECT
            'Jerry',
            'MySQL',
            99
        UNION ALL
        SELECT
            'Gavin ',
            'MySQL',
            98
        UNION ALL
        SELECT
            'sqlercn',
            'PostGreSQL',
            99
        UNION ALL
        SELECT
            'tom',
            'PostGreSOL',
            99
        UNION ALL
        SELECT
            'Jerry',
            'PostGreSQL',
            98
    )
SELECT
    study_name,
    class_name,
    score,
    ROW_NUMBER() OVER(
        PARTITION BY class_name
        ORDER BY
            score DESC
    ) AS rw,
    RANK() OVER(
        PARTITION BY class_name
        ORDER BY
            score DESC
    ) AS rk,
    DENSE_RANK() OVER(
        PARTITION BY class_name
        ORDER BY
            score DESC
    ) AS drk
FROM test
ORDER BY class_name, rw;

-- 按学习人数对课程进行排名，并列出每类课程学习人数排名前3的课程名称，学习人数以及名次。

WITH tmp AS(
        SELECT
            class_name,
            title,
            score,
            RANK() OVER(
                PARTITION BY class_name
                ORDER BY
                    score DESC
            ) AS cnt
        FROM imc_course a
            JOIN imc_class b ON b.class_id = a.class_id
    )
SELECT *
FROM tmp
WHERE cnt <= 3;

-- 每门课程的学习人数占本类课程总学习人数的百分比

WITH tmp AS (
        SELECT
            class_name,
            title,
            study_cnt,
            SUM(study_cnt) OVER(PARTITION BY class_name) AS class_total
        FROM imc_course a
            JOIN imc_class b ON b.class_id = a.class_id
    )
SELECT
    class_name,
    title,
    CONCAT(
        study_cnt / class_total * 100,
        '%'
    )
FROM tmp;

-- 查询出分类ID为5的课程名称和分类名称

SELECT
    a.title,
    b.class_name,
    b.class_id
FROM imc_course a
    JOIN imc_class b ON a.class_id = b.class_id AND b.class_id = 5;

-- ON 过滤失效

SELECT
    a.title,
    b.class_name,
    b.class_id
FROM imc_course a
    LEFT JOIN imc_class b ON a.class_id = b.class_id AND b.class_id = 5;

-- 查询列不指定表名, 造成 WHERE 失效

SELECT *
FROM imc_course
WHERE title IN (
        SELECT title
        FROM imc_class
    );

-- 查看 慢查询日志 目录

show variables like '%query%';

set global long_query_time = 0;

show global variables like 'long_query_time';

-- EXPLAIN

EXPLAIN
SELECT
    level_name,
    class_name,
    study_cnt,
    level_score,
    course_id
FROM imc_course a
    JOIN imc_class b ON b.class_id = a.class_id
    JOIN imc_level c on c.level_id = a.level_id
WHERE
    study_cnt > 3000
    AND a.course_id = (
        SELECT b.course_id
        FROM imc_chapter b
        LIMIT 1
    );

EXPLAIN
SELECT a.course_id, a.title
FROM imc_course a
WHERE a.course_id = (
        SELECT b.course_id
        FROM imc_chapter b
        LIMIT 1
    );

EXPLAIN
SELECT a.title
FROM imc_course a
UNION
SELECT b.chapter_name
FROM imc_chapter b;

EXPLAIN
SELECT
    level_name,
    class_name,
    study_cnt,
    level_score,
    course_id
FROM imc_course a
    JOIN imc_class b ON b.class_id = a.class_id
    JOIN imc_level c on c.level_id = a.level_id
WHERE study_cnt > 3000;

-- 查询出2019年1月1号以后注册的男性会员的呢称

EXPLAIN
SELECT user_nick, reg_time
FROM imc_user
WHERE
    sex = 1
    AND reg_time > '2019-01-01';

-- 筛选率

SELECT
    COUNT(DISTINCT sex),
    COUNT(
        DISTINCT DATE_FORMAT(reg_time, '%Y-%m-%d')
    ),
    COUNT(*),
    COUNT(
        DISTINCT DATE_FORMAT(reg_time, '%Y-%m-%d')
    ) / COUNT(*),
    COUNT(DISTINCT sex) / COUNT(*)
FROM imc_user;

-- 建立 reg_time 索引, 在筛选率低的字段建索引基本没用

CREATE INDEX idx_regtime ON imc_user(reg_time);

-- 查看高级别 mysql 课程信息

EXPLAIN
SELECT
    course_id,
    b.class_name,
    d.type_name,
    c.level_name,
    title,
    score
FROM imc_course a
    JOIN imc_class b ON b.class_id = a.class_id
    JOIN imc_level c ON c.level_id = a.level_id
    JOIN imc_type d oN d.type_id = a.type_id
WHERE
    c.level_name = '高级'
    AND b.class_name = 'MySQL';

-- 建立 a 表索引

SHOW CREATE TABLE imc_course;

CREATE UNIQUE INDEX uqx_classname ON imc_class(class_name);

CREATE UNIQUE INDEX uqx_levelname ON imc_level(level_name);

CREATE INDEX
    idx_classid_typeid_levelid ON imc_course(class_id, type_id, level_id);

-- 需求：查询出不存在课程的分类名称。

INSERT INTO imc_class SET class_name='AI';

EXPLAIN
SELECT class_name
FROM imc_class
WHERE class_id NOT IN(
        SELECT class_id
        FROM imc_course
    );

-- 效果一样，MySQL 8.0 自动优化 NOT IN 为 LEFT JOIN

EXPLAIN
SELECT class_name
FROM imc_class a
    LEFT JOIN imc_course b ON a.class_id = b.class_id
WHERE b.class_id IS NULL;

-- 查询对于内容，逻辑和难度三项评分之后大于28分的用户评分

EXPLAIN
SELECT *
FROM imc_classvalue
WHERE (
        content_score + level_score + logic_score
    ) > 28;

CREATE INDEX
    idx_contentScore_levelScore_logicScore ON imc_classvalue(
        content_score,
        level_score,
        logic_score
    );

ALTER TABLE imc_classvalue
ADD
    COLUMN total_score DECIMAL(3, 1) AS (
        content_score + level_score + logic_score
    );

SHOW CREATE TABLE imc_classvalue;

CREATE INDEX idx_totalScore ON imc_classvalue(total_score);

EXPLAIN SELECT * FROM imc_classvalue WHERE total_score > 28;