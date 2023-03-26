{% macro init_challenge_20() %}
{% if execute and var('ch20', var('run_all', false)) %}
  {% set stored_procedure_query %}
 
CREATE OR REPLACE PROCEDURE {{target.database}}.{{target.schema}}.ch20_clone_with_copy_grants(DATABASE_NAME varchar,
                                                                                  SCHEMA_NAME varchar,
                                                                                  TARGET_DATABASE varchar,
                                                                                  CLONED_SCHEMA_NAME varchar,
                                                                                  AT_OR_BEFORE_STATEMENT varchar)
    RETURNS varchar 
    LANGUAGE SQL
    EXECUTE AS caller
AS
    $$
    DECLARE
    -- placeholders
        executed              varchar default '';
        current_execution     varchar default '';
        temp                  varchar;
        at_or_before          varchar default (:AT_OR_BEFORE_STATEMENT);
        counter               integer default 0;
        holder                resultset; 
    -- identifiers
        object_privileges     varchar default (:DATABASE_NAME || '.INFORMATION_SCHEMA' || '.OBJECT_PRIVILEGES');
        old_schema            varchar default (:DATABASE_NAME || '.' || SCHEMA_NAME);
        new_schema            varchar default (:TARGET_DATABASE || '.' || :CLONED_SCHEMA_NAME);
    -- statements
        drop_statement        varchar default ('DROP SCHEMA IF EXISTS IDENTIFIER(\'' || :new_schema || '\') ');
        clone_statement       varchar default ('CREATE SCHEMA IDENTIFIER(\'' || :new_schema || '\') CLONE IDENTIFIER(\'' || :old_schema || '\')' || :at_or_before);
        grants_statement      varchar default ('select * from identifier(\'' || :object_privileges || '\') where OBJECT_TYPE = \'SCHEMA\' and OBJECT_NAME = \'' || :SCHEMA_NAME || '\'');
    
    -- grants
        current_grants        resultset DEFAULT (EXECUTE IMMEDIATE grants_statement);
        cur                   CURSOR for current_grants;



    BEGIN
    -- clone schema
        -- drop if exists
        holder := (EXECUTE IMMEDIATE drop_statement);
        -- clone
        holder := (EXECUTE IMMEDIATE clone_statement);
    -- assign grants
        for row_variable IN cur DO          
            temp := 'GRANT ' || row_variable.PRIVILEGE_TYPE || ' on ' || row_variable.OBJECT_TYPE || ' identifier(\'' || NEW_SCHEMA || '\') to role ' || row_variable.GRANTEE || CASE WHEN row_variable.IS_GRANTABLE = 'NO' then '' ELSE ' WITH GRANT OPTION ' END || '; ';
            holder := (EXECUTE IMMEDIATE temp);
            let c1 CURSOR for holder;
            open c1;
            fetch c1 into current_execution;
            executed := executed || temp || '--' || current_execution || ';\n';
            counter := counter + 1;

        END for;
    RETURN counter::varchar || ' grants were granted\n\n' || executed;
    END;
    $$

{% endset %}
  {{ log('Query for sp challenge_20 created', info=True)}}
  {{ log(stored_procedure_query)}}
  {% do run_query(stored_procedure_query) %}
  {{ log('Query for sp challenge_20 ran', info=True)}}

{% endif%}

{% endmacro %}