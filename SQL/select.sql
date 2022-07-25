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