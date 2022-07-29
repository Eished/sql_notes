-- Active: 1658517114424@@172.22.164.224@3306@imc_db

USE imc_db;

show grants;

show grants for 'mc_class'@'172.22.%.%';

grant all privileges on imc_db to mc_class@'172.22.%.%';

grant select,update,insert,drop on imc_db.* to mc_class@'172.22.%.%';

grant create,
delete,
create view,
execute
,
    alter,
    references,
    index on imc_db.* to mc_class @'172.22.%.%';

flush privileges;

-- root 用户执行后，mc_class 重新登录生效

SHOW CREATE TABLE imc_class;

INSERT INTO
    imc_class(class_name)
values ('MySQL'), ('Redis'), ('MongoDB'), ('安全测试'), ('Oracle'), ('SQL Server'), ('Hbase') ON duplicate KEY
UPDATE add_time = current_time;

SELECT * from imc_class;

CREATE UNIQUE INDEX uqx_classname ON imc_class(class_name);

-- 事务2

BEGIN;

-- UPDATE imc_course SET score=9.8 WHERE score>9.6;

UPDATE imc_course SET score=9.7 WHERE course_id>33;

COMMIT;