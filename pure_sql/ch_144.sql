-- setup
/* start setup */
USE DATABASE frosty;
USE SCHEMA challenges;
CREATE TABLE ch_144_table1 (
    id INT,
    name STRING
);

INSERT INTO ch_144_table1 VALUES (1, 'dummy');

CREATE OR REPLACE DYNAMIC TABLE ch_144_dynamic_table
TARGET_LAG = '1 minute'
WAREHOUSE = COMPUTE_WH
AS
SELECT *
FROM ch_144_table1;
/* end setup */

-- challenge

CREATE OR REPLACE SNAPSHOT POLICY frosty.challenges.ch_144_snapshot_policy
-- WITH RETENTION LOCK
SCHEDULE = '60 MINUTES'
-- 'USING CRON 0 * * * * UTC'
EXPIRE_AFTER_DAYS = 1
COMMENT = 'snapshot policy created for challenge 144';


CREATE SNAPSHOT SET IF NOT EXISTS frosty_challenges_ch_144_dynamic_table
FOR DYNAMIC TABLE frosty.challenges.ch_144_dynamic_table
WITH SNAPSHOT POLICY frosty.challenges.ch_144_snapshot_policy
COMMENT = 'if you find me, disable/delete me! - ch144';

SHOW SNAPSHOT SETS IN ACCOUNT;
