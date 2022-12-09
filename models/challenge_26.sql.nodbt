/* Preparation */
create or replace table challenge_26_log (inserted_at timestamp);
use role accountadmin;
CREATE OR REPLACE NOTIFICATION INTEGRATION dvd_frosty_fridays_ch26 TYPE = EMAIL ENABLED = TRUE ALLOWED_RECIPIENTS =('myemail@domain.com') COMMENT = 'notification set up for frosty friday ch 25';
grant usage on integration dvd_frosty_fridays_ch26 to role role_dvd_test;

/* tasks */
-- parent task
create or replace task challenge_26_launcher warehouse = warehouse_dvd_test schedule = '5 minute' AS EXECUTE IMMEDIATE $$
    DECLARE
        curr_timestamp_ts timestamp default (
                select current_timestamp()
            );
        curr_timestamp varchar;
    BEGIN
        select :curr_timestamp_ts::varchar into :curr_timestamp;
        call system $set_return_value(:curr_timestamp);
        insert into challenge_26_log values(:curr_timestamp_ts);
    END;
$$;
-- child task 
create or replace task challenge_26_notifier warehouse = warehouse_dvd_test
after challenge_26_launcher AS EXECUTE IMMEDIATE $$
    DECLARE 
        curr_timestamp varchar default (select * from values(
                        system$get_predecessor_return_value('CHALLENGE_26_LAUNCHER')
                    )
            );
        region varchar default (
            select current_region()
        );
        account varchar default (
            select current_account()
        );
        text varchar default 'Task has successfully finished on ' || :account || 'which is deployed on ' || :region || ' region at ' || :curr_timestamp;
    BEGIN CALL SYSTEM $SEND_EMAIL(
        'dvd_frosty_fridays_ch26',
        'myemail@domain.com',
        'Snowflake notification - challenge 26',
        :text
    );
    END;
    $$; 

alter task challenge_26_notifier resume;
alter task challenge_26_launcher resume;
execute task challenge_26_launcher;