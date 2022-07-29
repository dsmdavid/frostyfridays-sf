{% macro init_challenge_07() %}
  {{ log('Starting challenge_07 pre-work', info=True)}}
  {% set initial_query %}
USE WAREHOUSE {{ target.warehouse }};
USE DATABASE {{ target.database }};
USE SCHEMA {{ target.schema }};

create or replace table week7_villain_information (
	id INT,
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	email VARCHAR(50),
	Alter_Ego VARCHAR(50)
);
insert into week7_villain_information (id, first_name, last_name, email, Alter_Ego) values (1, 'Chrissy', 'Riches', 'criches0@ning.com', 'Waterbuck, defassa');
insert into week7_villain_information (id, first_name, last_name, email, Alter_Ego) values (2, 'Libbie', 'Fargher', 'lfargher1@vistaprint.com', 'Ibis, puna');
insert into week7_villain_information (id, first_name, last_name, email, Alter_Ego) values (3, 'Becka', 'Attack', 'battack2@altervista.org', 'Falcon, prairie');
insert into week7_villain_information (id, first_name, last_name, email, Alter_Ego) values (4, 'Euphemia', 'Whale', 'ewhale3@mozilla.org', 'Egyptian goose');
insert into week7_villain_information (id, first_name, last_name, email, Alter_Ego) values (5, 'Dixie', 'Bemlott', 'dbemlott4@moonfruit.com', 'Eagle, long-crested hawk');
insert into week7_villain_information (id, first_name, last_name, email, Alter_Ego) values (6, 'Giffard', 'Prendergast', 'gprendergast5@odnoklassniki.ru', 'Armadillo, seven-banded');
insert into week7_villain_information (id, first_name, last_name, email, Alter_Ego) values (7, 'Esmaria', 'Anthonies', 'eanthonies6@biblegateway.com', 'Cat, european wild');
insert into week7_villain_information (id, first_name, last_name, email, Alter_Ego) values (8, 'Celine', 'Fotitt', 'cfotitt7@baidu.com', 'Clark''s nutcracker');
insert into week7_villain_information (id, first_name, last_name, email, Alter_Ego) values (9, 'Leopold', 'Axton', 'laxton8@mac.com', 'Defassa waterbuck');
insert into week7_villain_information (id, first_name, last_name, email, Alter_Ego) values (10, 'Tadeas', 'Thorouggood', 'tthorouggood9@va.gov', 'Armadillo, nine-banded');

create or replace table week7_monster_information (
	id INT,
	monster VARCHAR(50),
	hideout_location VARCHAR(50)
);

insert into week7_monster_information (id, monster, hideout_location) values (1, 'Northern elephant seal', 'Huangban');
insert into week7_monster_information (id, monster, hideout_location) values (2, 'Paddy heron (unidentified)', 'Várzea Paulista');
insert into week7_monster_information (id, monster, hideout_location) values (3, 'Australian brush turkey', 'Adelaide Mail Centre');
insert into week7_monster_information (id, monster, hideout_location) values (4, 'Gecko, tokay', 'Tafí Viejo');
insert into week7_monster_information (id, monster, hideout_location) values (5, 'Robin, white-throated', 'Turośń Kościelna');
insert into week7_monster_information (id, monster, hideout_location) values (6, 'Goose, andean', 'Berezovo');
insert into week7_monster_information (id, monster, hideout_location) values (7, 'Puku', 'Mayskiy');
insert into week7_monster_information (id, monster, hideout_location) values (8, 'Frilled lizard', 'Fort Lauderdale');
insert into week7_monster_information (id, monster, hideout_location) values (9, 'Yellow-necked spurfowl', 'Sezemice');
insert into week7_monster_information (id, monster, hideout_location) values (10, 'Agouti', 'Najd al Jumā‘ī');


create or replace table week7_weapon_storage_location (
	id INT,
	created_by VARCHAR(50),
	location VARCHAR(50),
	catch_phrase VARCHAR(50),
	weapon VARCHAR(50)
);

insert into week7_weapon_storage_location (id, created_by, location, catch_phrase, weapon) 
    values (1, 'Ullrich-Gerhold', 'Mazatenango', 'Assimilated object-oriented extranet', 'Fintone');
insert into week7_weapon_storage_location (id, created_by, location, catch_phrase, weapon) 
    values (2, 'Olson-Lindgren', 'Dvorichna', 'Switchable demand-driven knowledge user', 'Andalax');
insert into week7_weapon_storage_location (id, created_by, location, catch_phrase, weapon) 
    values (3, 'Rodriguez, Flatley and Fritsch', 'Palmira', 'Persevering directional encoding', 'Toughjoyfax');
insert into week7_weapon_storage_location (id, created_by, location, catch_phrase, weapon) 
    values (4, 'Conn-Douglas', 'Rukem', 'Robust tangible Graphical User Interface', 'Flowdesk');
insert into week7_weapon_storage_location (id, created_by, location, catch_phrase, weapon) 
    values (5, 'Huel, Hettinger and Terry', 'Bulawin', 'Multi-channelled radical knowledge user', 'Y-Solowarm');
insert into week7_weapon_storage_location (id, created_by, location, catch_phrase, weapon) 
    values (6, 'Torphy, Ritchie and Lakin', 'Wang Sai Phun', 'Self-enabling client-driven project', 'Alphazap');
insert into week7_weapon_storage_location (id, created_by, location, catch_phrase, weapon) 
    values (7, 'Carroll and Sons', 'Digne-les-Bains', 'Profound radical benchmark', 'Stronghold');
insert into week7_weapon_storage_location (id, created_by, location, catch_phrase, weapon) 
    values (8, 'Hane, Breitenberg and Schoen', 'Huangbu', 'Function-based client-server encoding', 'Asoka');
insert into week7_weapon_storage_location (id, created_by, location, catch_phrase, weapon) 
    values (9, 'Ledner and Sons', 'Bukal Sur', 'Visionary eco-centric budgetary management', 'Ronstring');
insert into week7_weapon_storage_location (id, created_by, location, catch_phrase, weapon) 
    values (10, 'Will-Thiel', 'Zafar', 'Robust even-keeled algorithm', 'Tin');
    

--Create Tags
create or replace tag security_class comment = 'sensitive data';

--Apply tags
alter table week7_villain_information set tag security_class = 'Level Super Secret A+++++++';
alter table week7_monster_information set tag security_class = 'Level B';
alter table week7_weapon_storage_location set tag security_class = 'Level Super Secret A+++++++';

--Create Roles
use role securityadmin;
create role role_dvd_frosty_01;
create role role_dvd_frosty_02;
create role role_dvd_frosty_03;

--Assign Roles to yourself with all needed privileges
grant role role_dvd_frosty_01 to role accountadmin;
grant role role_dvd_frosty_01 to role role_dvd_test;
grant USAGE  on warehouse {{ target.warehouse }} to role role_dvd_frosty_01;
grant usage on database {{ target.database }} to role role_dvd_frosty_01;
grant usage on all schemas in database {{ target.database }} to role role_dvd_frosty_01;
grant select on all tables in database {{ target.database }} to role role_dvd_frosty_01;

grant role role_dvd_frosty_02 to role accountadmin;
grant role role_dvd_frosty_02 to role role_dvd_test;
grant USAGE  on warehouse {{ target.warehouse }} to role role_dvd_frosty_02;
grant usage on database {{ target.database }} to role role_dvd_frosty_02;
grant usage on all schemas in database {{ target.database }} to role role_dvd_frosty_02;
grant select on all tables in database {{ target.database }} to role role_dvd_frosty_02;

grant role role_dvd_frosty_03 to role accountadmin;
grant role role_dvd_frosty_03 to role role_dvd_test;
grant USAGE  on warehouse {{ target.warehouse }} to role role_dvd_frosty_03;
grant usage on database {{ target.database }} to role role_dvd_frosty_03;
grant usage on all schemas in database {{ target.database }} to role role_dvd_frosty_03;
grant select on all tables in database {{ target.database }} to role role_dvd_frosty_03;

--Queries to build history
use role role_dvd_frosty_01;
select * from week7_villain_information;

use role role_dvd_frosty_02;
select * from week7_monster_information;

use role role_dvd_frosty_03;
select * from week7_weapon_storage_location;
  {% endset %}
  {{ log('Query for challenge_07 created', info=True)}}

{% do run_query(initial_query) %}
  {{ log('Query for challenge_07 ran', info=True)}}


{% endmacro %}