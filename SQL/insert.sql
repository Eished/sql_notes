-- Active: 1658517114424@@172.22.164.224@3306@imc_db

USE imc_db;

show grants;

show grants for 'mc_class'@'172.22.%.%';

grant all privileges on imc_db to mc_class@'172.22.%.%';

grant select,update,insert,drop on imc_db.* to mc_class@'172.22.%.%';

grant
    create,
    alter,
    references,
    index on imc_db.* to mc_class @'172.22.%.%';

flush privileges;

SHOW CREATE TABLE imc_class;

INSERT INTO
    imc_class(class_name)
values ('MySQL'), ('Redis'), ('MongoDB'), ('安全测试'), ('Oracle'), ('SQL Server'), ('Hbase') ON duplicate KEY
UPDATE add_time = current_time;

SELECT * from imc_class;

CREATE UNIQUE INDEX uqx_classname ON imc_class(class_name);