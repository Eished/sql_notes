-- Active: 1658517114424@@172.22.164.224@3306@imc_db
USE imc_db;

create table
    imc_course (
        course_id INT UNSIGNED auto_increment NOT NULL COMMENT '课程ID',
        title varchar(20) NOT NULL DEFAULT '' COMMENT '主标题',
        title_desc varchar(50) NOT NULL DEFAULT '' COMMENT '副标题 ',
        type_id smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '课程方向ID',
        class_id smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '课程分类ID',
        level_id smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '课程难度ID',
        online_time datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '课程上线时间',
        study_cnt int(10) unsigned NOT NULL DEFAULT '0' COMMENT '学习人数',
        course_time time NOT NULL DEFAULT '00:00:00' COMMENT '课程时长',
        intro varchar(200) NOT NULL DEFAULT '' COMMENT '课程简介',
        info varchar(200) NOT NULL DEFAULT '' COMMENT '学习需知',
        harvest varchar(200) NOT NULL DEFAULT '' COMMENT '课程收获',
        user_id int(10) unsigned NOT NULL DEFAULT '0' COMMENT '讲师ID',
        main_pic varchar(200) NOT NULL DEFAULT '' COMMENT '课程主图片',
        content_score decimal(3, 1) NOT NULL DEFAULT '0.0' COMMENT '内容评分',
        level_score decimal(3, 1) NOT NULL DEFAULT '0.0' COMMENT '简单易懂',
        logic_score decimal(3, 1) NOT NULL DEFAULT '0.0' COMMENT '逻辑清晰',
        score decimal(3, 1) NOT NULL DEFAULT '0.0' COMMENT '综合评分',
        PRIMARY KEY (course_id),
        UNIQUE KEY udx_title (title)
    ) COMMENT '课程主表';

create table
    imc_chapter (
        chapter_id INT UNSIGNED auto_increment NOT NULL COMMENT '章节 ID',
        course_id INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '课程 ID ',
        chapter_name varchar(50) NOT NULL DEFAULT '' COMMENT ' 课程章节名 ',
        chapter_info varchar(200) NOT NULL DEFAULT '' COMMENT '章节说明',
        chapter_no TINYINT(2) UNSIGNED ZEROFILL NOT NULL DEFAULT 0 COMMENT '章节编号',
        PRIMARY KEY (chapter_id),
        UNIQUE KEY udx_courseid_chaptername (course_id, chapter_name)
    ) COMMENT '课程章节';

CREATE Table
    imc_subsection (
        sub_id int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '小节ID',
        chapter_id int(10) unsigned NOT NULL DEFAULT '0' COMMENT '章节ID',
        course_id int(10) unsigned NOT NULL DEFAULT '0' COMMENT '课程ID',
        sub_name varchar(50) NOT NULL DEFAULT '' COMMENT '小节名称',
        sub_url varchar(200) NOT NULL DEFAULT '' COMMENT '小节URL',
        video_type enum('avi', 'mp4', 'mpeg') NOT NULL DEFAULT 'mp4' COMMENT '视频格式',
        sub_time time NOT NULL DEFAULT '00:00:00' COMMENT '小节时长',
        sub_no tinyint(2) unsigned zerofill NOT NULL DEFAULT '00' COMMENT '章节编号',
        PRIMARY KEY (sub_id),
        UNIQUE KEY udx_chapterid_courseid_subname (
            chapter_id,
            course_id,
            sub_name
        )
    ) COMMENT = '课程小节表';

CREATE TABLE
    imc_class (
        class_id smallint(5) unsigned NOT NULL AUTO_INCREMENT COMMENT '课程分类ID',
        class_name varchar(10) NOT NULL DEFAULT '' COMMENT '分类名称',
        add_time timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '填加时间',
        PRIMARY KEY (class_id)
    ) COMMENT = '课程分类';

CREATE TABLE
    imc_level (
        level_id smallint(5) unsigned NOT NULL AUTO_INCREMENT COMMENT '课程难度ID',
        level_name varchar(10) NOT NULL DEFAULT '' COMMENT '课程难度名称',
        add_time timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '填加时间',
        PRIMARY KEY (level_id)
    ) COMMENT = '课程方向表';

CREATE TABLE
    imc_type (
        type_id smallint(5) unsigned NOT NULL AUTO_INCREMENT COMMENT '课程方向ID',
        type_name varchar(10) NOT NULL DEFAULT '' COMMENT '课程方向名称',
        add_time timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '填加时间',
        PRIMARY KEY (type_id)
    ) COMMENT = '课程方向表';

CREATE TABLE
    imc_user (
        user_id int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '用户ID',
        user_nick varchar(20) NOT NULL DEFAULT '慕课网' COMMENT '用户昵称',
        user_pwd char(32) NOT NULL DEFAULT '' COMMENT '密码',
        sex char(2) NOT NULL DEFAULT '未知' COMMENT '性别',
        province varchar(20) NOT NULL DEFAULT '' COMMENT '省',
        city varchar(20) NOT NULL DEFAULT '' COMMENT '市',
        Position varchar(10) NOT NULL DEFAULT '未知' COMMENT '职位',
        mem varchar(100) NOT NULL DEFAULT '' COMMENT '说明',
        exp_cnt mediumint(8) unsigned NOT NULL DEFAULT '0' COMMENT '经验值',
        score int(10) unsigned NOT NULL DEFAULT '0' COMMENT '积分',
        follow_cnt int(10) unsigned NOT NULL DEFAULT '0' COMMENT '关注人数',
        fans_cnt int(10) unsigned NOT NULL DEFAULT '0' COMMENT '粉丝人数',
        is_teacher tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '讲师标识,0:普通用户,1:讲师用户',
        reg_time datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '注册时间',
        user_status tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '用户状态 1:正常 0:冻结',
        PRIMARY KEY (user_id),
        UNIQUE KEY udx_usernick (user_nick)
    ) COMMENT = '用户表';

CREATE TABLE
    imc_question (
        quest_id int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '评论',
        user_id int(10) unsigned NOT NULL DEFAULT '0' COMMENT '用户ID',
        course_id int(10) unsigned NOT NULL DEFAULT '0' COMMENT '课程ID',
        chapter_id int(10) unsigned NOT NULL DEFAULT '0' COMMENT '章节ID',
        sub_id int(10) unsigned NOT NULL DEFAULT '0' COMMENT '小节ID',
        replyid int(10) unsigned NOT NULL DEFAULT '0' COMMENT '父评论ID',
        quest_title varchar(50) NOT NULL DEFAULT '' COMMENT '评论标题',
        quest_content text COMMENT '评论内容',
        quest_type enum('问答', '评论') NOT NULL DEFAULT '评论' COMMENT '评论类型',
        view_cnt int(10) unsigned NOT NULL DEFAULT '0' COMMENT '浏览量',
        add_time datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '发布时间',
        PRIMARY KEY (quest_id)
    ) COMMENT = '问答评论表';

CREATE TABLE
    imc_note (
        note_id int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '笔记ID',
        user_id int(10) unsigned NOT NULL DEFAULT '0' COMMENT '用户ID',
        course_id int(10) unsigned NOT NULL DEFAULT '0' COMMENT '课程ID',
        chapter_id int(10) unsigned NOT NULL DEFAULT '0' COMMENT '章节ID',
        sub_id int(10) unsigned NOT NULL DEFAULT '0' COMMENT '小节ID',
        note_title varchar(50) NOT NULL DEFAULT '' COMMENT '笔记标题',
        note_content text COMMENT '评论内容',
        add_time datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '发布时间',
        PRIMARY KEY (note_id)
    ) COMMENT = '笔记表';

CREATE TABLE
    imc_classvalue (
        value_id int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '评价ID',
        user_id int(10) unsigned NOT NULL DEFAULT '0' COMMENT '用户ID',
        course_id int(10) unsigned NOT NULL DEFAULT '0' COMMENT '课程ID',
        content_score decimal(3, 1) NOT NULL DEFAULT '0.0' COMMENT '内容评分',
        level_score decimal(3, 1) NOT NULL DEFAULT '0.0' COMMENT '简单易懂',
        logic_score decimal(3, 1) NOT NULL DEFAULT '0.0' COMMENT '逻辑清晰',
        score decimal(3, 1) NOT NULL DEFAULT '0.0' COMMENT '综合评分',
        add_time datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '发布时间',
        PRIMARY KEY (value_id)
    ) COMMENT = '课程评价表';

CREATE TABLE
    imc_selectcourse (
        select_id int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '选课ID',
        user_id int(10) unsigned NOT NULL DEFAULT '0' COMMENT '用户ID',
        course_id int(10) unsigned NOT NULL DEFAULT '0' COMMENT '课程ID',
        select_time datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '选课时间',
        study_time time NOT NULL DEFAULT '00:00:00' COMMENT '累积听课时间',
        PRIMARY KEY (select_id)
    ) COMMENT = '用户选课表';