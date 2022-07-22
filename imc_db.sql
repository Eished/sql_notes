-- Active: 1658517114424@@172.22.164.224@3306@imc_db

create table
    imc_course (
        course_id INT UNSIGNED auto_increment NOT NULL COMMENT '课程 ID',
        title varchar(20) NOT NULL DEFAULT '' COMMENT '主标题',
        title_desc varchar(50) NOT NULL DEFAULT '' COMMENT '副标题 ',
        -- ......
        PRIMARY KEY (course_id),
        UNIQUE KEY udx_title (title)
    ) COMMENT '课程主表';

create table
    imc_chapter (
        shapter_id INT UNSIGNED auto_increment NOT NULL COMMENT '章节 ID',
        course_id INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '课程 ID ',
        chapter_name varchar(50) NOT NULL DEFAULT '' COMMENT ' 课程章节名 ',
        chapter_info varchar(200) NOT NULL DEFAULT '' COMMENT '章节说明',
        chapter_no TINYINT(2) UNSIGNED ZEROFILL NOT NULL DEFAULT 0 COMMENT '章节编号',
        PRIMARY KEY (shapter_id),
        UNIQUE KEY udx_courseid_chaptername (course_id, chapter_name)
    ) COMMENT '课程章节';