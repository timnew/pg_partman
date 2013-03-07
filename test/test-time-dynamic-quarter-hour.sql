-- ########## TIME DYNAMIC TESTS ##########

\set ON_ERROR_ROLLBACK 1
\set ON_ERROR_STOP true

BEGIN;
SELECT set_config('search_path','partman, tap',false);

SELECT plan(82);
CREATE SCHEMA partman_test;
CREATE ROLE partman_basic;
CREATE ROLE partman_revoke;
CREATE ROLE partman_owner;

CREATE TABLE partman_test.time_dynamic_table (col1 int primary key, col2 text, col3 timestamptz NOT NULL DEFAULT now());
INSERT INTO partman_test.time_dynamic_table (col1, col3) VALUES (generate_series(1,10), CURRENT_TIMESTAMP);
GRANT SELECT,INSERT,UPDATE ON partman_test.time_dynamic_table TO partman_basic;
GRANT ALL ON partman_test.time_dynamic_table TO partman_revoke;

SELECT create_parent('partman_test.time_dynamic_table', 'col3', 'time-dynamic', 'quarter-hour');
SELECT has_table('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0), 'YYYY_MM_DD_HH24MI'), 'Check time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0), 'YYYY_MM_DD_HH24MI')||' exists');
SELECT has_table('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'15 mins'::interval, 'YYYY_MM_DD_HH24MI'), 
    'Check time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'15 mins'::interval, 'YYYY_MM_DD_HH24MI')||' exists');
SELECT has_table('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'30 mins'::interval, 'YYYY_MM_DD_HH24MI'), 
    'Check time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'30 mins'::interval, 'YYYY_MM_DD_HH24MI')||' exists');
SELECT has_table('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'45 mins'::interval, 'YYYY_MM_DD_HH24MI'), 
    'Check time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'45 mins'::interval, 'YYYY_MM_DD_HH24MI')||' exists');
SELECT has_table('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'60 mins'::interval, 'YYYY_MM_DD_HH24MI'), 
    'Check time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'60 mins'::interval, 'YYYY_MM_DD_HH24MI')||' exists');
SELECT hasnt_table('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'75 mins'::interval, 'YYYY_MM_DD_HH24MI'), 
    'Check time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'75 mins'::interval, 'YYYY_MM_DD_HH24MI')||' exists');
SELECT col_is_pk('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0), 'YYYY_MM_DD_HH24MI'), ARRAY['col1'], 
    'Check for primary key in time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0), 'YYYY_MM_DD_HH24MI'));
SELECT col_is_pk('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'15 mins'::interval, 'YYYY_MM_DD_HH24MI'), ARRAY['col1'], 
    'Check for primary key in time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'15 mins'::interval, 'YYYY_MM_DD_HH24MI'));
SELECT col_is_pk('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'30 mins'::interval, 'YYYY_MM_DD_HH24MI'), ARRAY['col1'], 
    'Check for primary key in time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'30 mins'::interval, 'YYYY_MM_DD_HH24MI'));
SELECT col_is_pk('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'45 mins'::interval, 'YYYY_MM_DD_HH24MI'), ARRAY['col1'], 
    'Check for primary key in time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'45 mins'::interval, 'YYYY_MM_DD_HH24MI'));
SELECT col_is_pk('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'60 mins'::interval, 'YYYY_MM_DD_HH24MI'), ARRAY['col1'], 
    'Check for primary key in time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'60 mins'::interval, 'YYYY_MM_DD_HH24MI'));
SELECT table_privs_are('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0), 'YYYY_MM_DD_HH24MI'), 'partman_basic', 
    ARRAY['SELECT','INSERT','UPDATE'], 
    'Check partman_basic privileges of time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0), 'YYYY_MM_DD_HH24MI'));
SELECT table_privs_are('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'15 mins'::interval, 'YYYY_MM_DD_HH24MI'), 'partman_basic', 
    ARRAY['SELECT','INSERT','UPDATE'], 
    'Check partman_basic privileges of time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'15 mins'::interval, 'YYYY_MM_DD_HH24MI'));
SELECT table_privs_are('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'30 mins'::interval, 'YYYY_MM_DD_HH24MI'), 'partman_basic', 
    ARRAY['SELECT','INSERT','UPDATE'], 
    'Check partman_basic privileges of time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'30 mins'::interval, 'YYYY_MM_DD_HH24MI'));
SELECT table_privs_are('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'45 mins'::interval, 'YYYY_MM_DD_HH24MI'), 'partman_basic', 
    ARRAY['SELECT','INSERT','UPDATE'], 
    'Check partman_basic privileges of time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'45 mins'::interval, 'YYYY_MM_DD_HH24MI'));
SELECT table_privs_are('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'60 mins'::interval, 'YYYY_MM_DD_HH24MI'), 'partman_basic', 
    ARRAY['SELECT','INSERT','UPDATE'], 
    'Check partman_basic privileges of time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'60 mins'::interval, 'YYYY_MM_DD_HH24MI'));
SELECT table_privs_are('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0), 'YYYY_MM_DD_HH24MI'), 'partman_revoke', 
    ARRAY['SELECT', 'INSERT', 'UPDATE', 'DELETE', 'TRUNCATE', 'REFERENCES', 'TRIGGER'], 
    'Check partman_revoke privileges of time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0), 'YYYY_MM_DD_HH24MI'));
SELECT table_privs_are('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'15 mins'::interval, 'YYYY_MM_DD_HH24MI'), 'partman_revoke', 
    ARRAY['SELECT', 'INSERT', 'UPDATE', 'DELETE', 'TRUNCATE', 'REFERENCES', 'TRIGGER'], 
    'Check partman_revoke privileges of time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'15 mins'::interval, 'YYYY_MM_DD_HH24MI'));
SELECT table_privs_are('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'30 mins'::interval, 'YYYY_MM_DD_HH24MI'), 'partman_revoke', 
    ARRAY['SELECT', 'INSERT', 'UPDATE', 'DELETE', 'TRUNCATE', 'REFERENCES', 'TRIGGER'], 
    'Check partman_revoke privileges of time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'30 mins'::interval, 'YYYY_MM_DD_HH24MI'));
SELECT table_privs_are('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'45 mins'::interval, 'YYYY_MM_DD_HH24MI'), 'partman_revoke', 
    ARRAY['SELECT', 'INSERT', 'UPDATE', 'DELETE', 'TRUNCATE', 'REFERENCES', 'TRIGGER'], 
    'Check partman_revoke privileges of time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'45 mins'::interval, 'YYYY_MM_DD_HH24MI'));
SELECT table_privs_are('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'60 mins'::interval, 'YYYY_MM_DD_HH24MI'), 'partman_revoke', 
    ARRAY['SELECT', 'INSERT', 'UPDATE', 'DELETE', 'TRUNCATE', 'REFERENCES', 'TRIGGER'], 
    'Check partman_revoke privileges of time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'60 mins'::interval, 'YYYY_MM_DD_HH24MI'));

SELECT partition_data_time('partman_test.time_dynamic_table');
SELECT is_empty('SELECT * FROM ONLY partman_test.time_dynamic_table', 'Check that parent table has had data moved to partition');
SELECT results_eq('SELECT count(*)::int FROM partman_test.time_dynamic_table', ARRAY[10], 'Check count from parent table');
SELECT results_eq('SELECT count(*)::int FROM partman_test.time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0), 'YYYY_MM_DD_HH24MI'), 
    ARRAY[10], 'Check count from time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0), 'YYYY_MM_DD_HH24MI'));

REVOKE INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER ON partman_test.time_dynamic_table FROM partman_revoke;
INSERT INTO partman_test.time_dynamic_table (col1, col3) VALUES (generate_series(11,20), CURRENT_TIMESTAMP + '15 mins'::interval);
INSERT INTO partman_test.time_dynamic_table (col1, col3) VALUES (generate_series(21,25), CURRENT_TIMESTAMP + '30 mins'::interval);

SELECT is_empty('SELECT * FROM ONLY partman_test.time_dynamic_table', 'Check that parent table has had no data inserted to it');
SELECT results_eq('SELECT count(*)::int FROM partman_test.time_dynamic_table', ARRAY[25], 'Check count from time_dynamic_table');
SELECT results_eq('SELECT count(*)::int FROM partman_test.time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'15 mins'::interval, 'YYYY_MM_DD_HH24MI'), 
    ARRAY[10], 'Check count from time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'15 mins'::interval, 'YYYY_MM_DD_HH24MI'));
SELECT results_eq('SELECT count(*)::int FROM partman_test.time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'30 mins'::interval, 'YYYY_MM_DD_HH24MI'), 
    ARRAY[5], 'Check count from time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'30 mins'::interval, 'YYYY_MM_DD_HH24MI'));

UPDATE part_config SET premake = 5 WHERE parent_table = 'partman_test.time_dynamic_table';
SELECT run_maintenance();
SELECT has_table('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'75 mins'::interval, 'YYYY_MM_DD_HH24MI'), 
    'Check time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'75 mins'::interval, 'YYYY_MM_DD_HH24MI')||' exists');
SELECT hasnt_table('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'90 mins'::interval, 'YYYY_MM_DD_HH24MI'), 
    'Check time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'90 mins'::interval, 'YYYY_MM_DD_HH24MI')||' exists');
SELECT col_is_pk('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'75 mins'::interval, 'YYYY_MM_DD_HH24MI'), ARRAY['col1'], 
    'Check for primary key in time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'75 mins'::interval, 'YYYY_MM_DD_HH24MI'));
SELECT table_privs_are('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0), 'YYYY_MM_DD_HH24MI'), 'partman_basic', ARRAY['SELECT','INSERT','UPDATE'], 
    'Check partman_basic privileges of time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0), 'YYYY_MM_DD_HH24MI'));
SELECT table_privs_are('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'15 mins'::interval, 'YYYY_MM_DD_HH24MI'), 'partman_basic', 
    ARRAY['SELECT','INSERT','UPDATE'], 
    'Check partman_basic privileges of time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'15 mins'::interval, 'YYYY_MM_DD_HH24MI'));
SELECT table_privs_are('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'30 mins'::interval, 'YYYY_MM_DD_HH24MI'), 'partman_basic', 
    ARRAY['SELECT','INSERT','UPDATE'], 
    'Check partman_basic privileges of time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'30 mins'::interval, 'YYYY_MM_DD_HH24MI'));
SELECT table_privs_are('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'45 mins'::interval, 'YYYY_MM_DD_HH24MI'), 'partman_basic', 
    ARRAY['SELECT','INSERT','UPDATE'], 
    'Check partman_basic privileges of time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'45 mins'::interval, 'YYYY_MM_DD_HH24MI'));
SELECT table_privs_are('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'60 mins'::interval, 'YYYY_MM_DD_HH24MI'), 'partman_basic', 
ARRAY['SELECT','INSERT','UPDATE'], 
    'Check partman_basic privileges of time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'60 mins'::interval, 'YYYY_MM_DD_HH24MI'));
SELECT table_privs_are('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'75 mins'::interval, 'YYYY_MM_DD_HH24MI'), 'partman_revoke', 
    ARRAY['SELECT'], 'Check partman_revoke privileges of time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'75 mins'::interval, 'YYYY_MM_DD_HH24MI'));

GRANT DELETE ON partman_test.time_dynamic_table TO partman_basic;
REVOKE ALL ON partman_test.time_dynamic_table FROM partman_revoke;
ALTER TABLE partman_test.time_dynamic_table OWNER TO partman_owner;

UPDATE part_config SET premake = 6 WHERE parent_table = 'partman_test.time_dynamic_table';
SELECT run_maintenance();
SELECT has_table('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'90 mins'::interval, 'YYYY_MM_DD_HH24MI'), 
    'Check time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'90 mins'::interval, 'YYYY_MM_DD_HH24MI')||' exists');
SELECT hasnt_table('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'105 mins'::interval, 'YYYY_MM_DD_HH24MI'), 
    'Check time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'105 mins'::interval, 'YYYY_MM_DD_HH24MI')||' exists');
SELECT col_is_pk('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'90 mins'::interval, 'YYYY_MM_DD_HH24MI'), ARRAY['col1'], 
    'Check for primary key in time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'90 mins'::interval, 'YYYY_MM_DD_HH24MI'));
SELECT table_privs_are('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0), 'YYYY_MM_DD_HH24MI'), 'partman_basic', ARRAY['SELECT','INSERT','UPDATE'], 
    'Check partman_basic privileges of time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0), 'YYYY_MM_DD_HH24MI'));
SELECT table_privs_are('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'15 mins'::interval, 'YYYY_MM_DD_HH24MI'), 'partman_basic', 
    ARRAY['SELECT','INSERT','UPDATE'], 
    'Check partman_basic privileges of time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'15 mins'::interval, 'YYYY_MM_DD_HH24MI'));
SELECT table_privs_are('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'30 mins'::interval, 'YYYY_MM_DD_HH24MI'), 'partman_basic', 
    ARRAY['SELECT','INSERT','UPDATE'], 
    'Check partman_basic privileges of time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'30 mins'::interval, 'YYYY_MM_DD_HH24MI'));
SELECT table_privs_are('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'45 mins'::interval, 'YYYY_MM_DD_HH24MI'), 'partman_basic', 
    ARRAY['SELECT','INSERT','UPDATE'], 
    'Check partman_basic privileges of time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'45 mins'::interval, 'YYYY_MM_DD_HH24MI'));
SELECT table_privs_are('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'60 mins'::interval, 'YYYY_MM_DD_HH24MI'), 'partman_basic', 
    ARRAY['SELECT','INSERT','UPDATE'], 
    'Check partman_basic privileges of time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'60 mins'::interval, 'YYYY_MM_DD_HH24MI'));
SELECT table_privs_are('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'75 mins'::interval, 'YYYY_MM_DD_HH24MI'), 'partman_revoke', 
    ARRAY['SELECT'], 'Check partman_revoke privileges of time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'75 mins'::interval, 'YYYY_MM_DD_HH24MI'));
SELECT table_privs_are('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'90 mins'::interval, 'YYYY_MM_DD_HH24MI'), 'partman_revoke', 
    '{}'::text[], 'Check partman_revoke privileges of time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'90 mins'::interval, 'YYYY_MM_DD_HH24MI'));
SELECT table_privs_are('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'90 mins'::interval, 'YYYY_MM_DD_HH24MI'), 'partman_basic', 
    ARRAY['SELECT','INSERT','UPDATE', 'DELETE'], 
    'Check partman_basic privileges of time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'90 mins'::interval, 'YYYY_MM_DD_HH24MI'));
SELECT table_owner_is ('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'90 mins'::interval, 'YYYY_MM_DD_HH24MI'), 'partman_owner', 
    'Check that ownership change worked for time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'90 mins'::interval, 'YYYY_MM_DD_HH24MI'));

INSERT INTO partman_test.time_dynamic_table (col1, col3) VALUES (generate_series(200,210), CURRENT_TIMESTAMP + '300 mins'::interval);
SELECT results_eq('SELECT count(*)::int FROM ONLY partman_test.time_dynamic_table', ARRAY[11], 'Check that data outside trigger scope goes to parent');

SELECT reapply_privileges('partman_test.time_dynamic_table');
SELECT table_privs_are('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0), 'YYYY_MM_DD_HH24MI'), 'partman_basic', 
    ARRAY['SELECT','INSERT','UPDATE', 'DELETE'], 
    'Check partman_basic privileges of time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0), 'YYYY_MM_DD_HH24MI'));
SELECT table_privs_are('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'15 mins'::interval, 'YYYY_MM_DD_HH24MI'), 'partman_basic', 
    ARRAY['SELECT','INSERT','UPDATE', 'DELETE'], 
    'Check partman_basic privileges of time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'15 mins'::interval, 'YYYY_MM_DD_HH24MI'));
SELECT table_privs_are('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'30 mins'::interval, 'YYYY_MM_DD_HH24MI'), 'partman_basic', 
    ARRAY['SELECT','INSERT','UPDATE', 'DELETE'], 
    'Check partman_basic privileges of time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'30 mins'::interval, 'YYYY_MM_DD_HH24MI'));
SELECT table_privs_are('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'45 mins'::interval, 'YYYY_MM_DD_HH24MI'), 'partman_basic', 
    ARRAY['SELECT','INSERT','UPDATE', 'DELETE'], 
    'Check partman_basic privileges of time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'45 mins'::interval, 'YYYY_MM_DD_HH24MI'));
SELECT table_privs_are('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'60 mins'::interval, 'YYYY_MM_DD_HH24MI'), 'partman_basic', 
    ARRAY['SELECT','INSERT','UPDATE', 'DELETE'], 
    'Check partman_basic privileges of time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'60 mins'::interval, 'YYYY_MM_DD_HH24MI'));
SELECT table_privs_are('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'90 mins'::interval, 'YYYY_MM_DD_HH24MI'), 'partman_basic', 
    ARRAY['SELECT','INSERT','UPDATE', 'DELETE'], 
    'Check partman_basic privileges of time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'90 mins'::interval, 'YYYY_MM_DD_HH24MI'));

SELECT table_privs_are('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0), 'YYYY_MM_DD_HH24MI'), 'partman_revoke', 
    '{}'::text[], 'Check partman_revoke privileges of time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0), 'YYYY_MM_DD_HH24MI'));
SELECT table_privs_are('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'15 mins'::interval, 'YYYY_MM_DD_HH24MI'), 'partman_revoke', 
    '{}'::text[], 'Check partman_revoke privileges of time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'15 mins'::interval, 'YYYY_MM_DD_HH24MI'));
SELECT table_privs_are('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'30 mins'::interval, 'YYYY_MM_DD_HH24MI'), 'partman_revoke', 
    '{}'::text[], 'Check partman_revoke privileges of time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'30 mins'::interval, 'YYYY_MM_DD_HH24MI'));
SELECT table_privs_are('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'45 mins'::interval, 'YYYY_MM_DD_HH24MI'), 'partman_revoke', 
    '{}'::text[], 'Check partman_revoke privileges of time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'45 mins'::interval, 'YYYY_MM_DD_HH24MI'));
SELECT table_privs_are('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'60 mins'::interval, 'YYYY_MM_DD_HH24MI'), 'partman_revoke', 
    '{}'::text[], 'Check partman_revoke privileges of time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'60 mins'::interval, 'YYYY_MM_DD_HH24MI'));
SELECT table_privs_are('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'75 mins'::interval, 'YYYY_MM_DD_HH24MI'), 'partman_revoke', 
    '{}'::text[], 'Check partman_revoke privileges of time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'75 mins'::interval, 'YYYY_MM_DD_HH24MI'));
SELECT table_privs_are('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'90 mins'::interval, 'YYYY_MM_DD_HH24MI'), 'partman_revoke', 
    '{}'::text[], 'Check partman_revoke privileges of time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'90 mins'::interval, 'YYYY_MM_DD_HH24MI'));

SELECT table_owner_is ('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0), 'YYYY_MM_DD_HH24MI'), 'partman_owner', 
    'Check that ownership change worked for time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0), 'YYYY_MM_DD_HH24MI'));
SELECT table_owner_is ('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'15 mins'::interval, 'YYYY_MM_DD_HH24MI'), 'partman_owner', 
    'Check that ownership change worked for time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'15 mins'::interval, 'YYYY_MM_DD_HH24MI'));
SELECT table_owner_is ('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'30 mins'::interval, 'YYYY_MM_DD_HH24MI'), 'partman_owner', 
    'Check that ownership change worked for time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'30 mins'::interval, 'YYYY_MM_DD_HH24MI'));
SELECT table_owner_is ('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'45 mins'::interval, 'YYYY_MM_DD_HH24MI'), 'partman_owner', 
    'Check that ownership change worked for time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'45 mins'::interval, 'YYYY_MM_DD_HH24MI'));
SELECT table_owner_is ('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'60 mins'::interval, 'YYYY_MM_DD_HH24MI'), 'partman_owner', 
    'Check that ownership change worked for time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'60 mins'::interval, 'YYYY_MM_DD_HH24MI'));
SELECT table_owner_is ('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'75 mins'::interval, 'YYYY_MM_DD_HH24MI'), 'partman_owner', 
    'Check that ownership change worked for time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'75 mins'::interval, 'YYYY_MM_DD_HH24MI'));
SELECT table_owner_is ('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'90 mins'::interval, 'YYYY_MM_DD_HH24MI'), 'partman_owner', 
    'Check that ownership change worked for time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'90 mins'::interval, 'YYYY_MM_DD_HH24MI'));

SELECT undo_partition_time('partman_test.time_dynamic_table', 20);
SELECT has_table('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'15 mins'::interval, 'YYYY_MM_DD_HH24MI'), 
    'Check time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'15 mins'::interval, 'YYYY_MM_DD_HH24MI')||' still exists');
SELECT is_empty('SELECT * FROM partman_test.time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'15 mins'::interval, 'YYYY_MM_DD_HH24MI'), 
    'Check time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'15 mins'::interval, 'YYYY_MM_DD_HH24MI')||' is empty');
SELECT has_table('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'30 mins'::interval, 'YYYY_MM_DD_HH24MI'), 
    'Check time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'30 mins'::interval, 'YYYY_MM_DD_HH24MI')||' still exists');
SELECT is_empty('SELECT * FROM partman_test.time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'30 mins'::interval, 'YYYY_MM_DD_HH24MI'), 
    'Check time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'30 mins'::interval, 'YYYY_MM_DD_HH24MI')||' is empty');
SELECT has_table('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'45 mins'::interval, 'YYYY_MM_DD_HH24MI'), 
    'Check time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'45 mins'::interval, 'YYYY_MM_DD_HH24MI')||' still exists');
SELECT is_empty('SELECT * FROM partman_test.time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'45 mins'::interval, 'YYYY_MM_DD_HH24MI'), 
    'Check time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'45 mins'::interval, 'YYYY_MM_DD_HH24MI')||' is empty');
SELECT has_table('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'60 mins'::interval, 'YYYY_MM_DD_HH24MI'), 
    'Check time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'60 mins'::interval, 'YYYY_MM_DD_HH24MI')||' still exists');
SELECT is_empty('SELECT * FROM partman_test.time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'60 mins'::interval, 'YYYY_MM_DD_HH24MI'), 
    'Check time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'60 mins'::interval, 'YYYY_MM_DD_HH24MI')||' is empty');
SELECT has_table('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'75 mins'::interval, 'YYYY_MM_DD_HH24MI'), 
    'Check time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'75 mins'::interval, 'YYYY_MM_DD_HH24MI')||' still exists');
SELECT is_empty('SELECT * FROM partman_test.time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'75 mins'::interval, 'YYYY_MM_DD_HH24MI'), 
    'Check time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'75 mins'::interval, 'YYYY_MM_DD_HH24MI')||' is empty');
SELECT has_table('partman_test', 'time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'90 mins'::interval, 'YYYY_MM_DD_HH24MI'), 
    'Check time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'90 mins'::interval, 'YYYY_MM_DD_HH24MI')||' still exists');
SELECT is_empty('SELECT * FROM partman_test.time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'90 mins'::interval, 'YYYY_MM_DD_HH24MI'), 
    'Check time_dynamic_table_p'||to_char(date_trunc('hour', CURRENT_TIMESTAMP) + 
                '15min'::interval * floor(date_part('minute', CURRENT_TIMESTAMP) / 15.0)+'90 mins'::interval, 'YYYY_MM_DD_HH24MI')||' is empty');


SELECT * FROM finish();
ROLLBACK;