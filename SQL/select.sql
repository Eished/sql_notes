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

SELECT
    course_id,
    AVG(content_score),
    AVG(level_score),
    AVG(logic_score),
    AVG(score)
FROM imc_classvalue
GROUP BY course_id;

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
	    JOIN imc_level d ON d.level_id = a.level_id;

SELECT * from vm_course;