
--
-- Drop tables
--
DROP TABLE convert_queue;
DROP TABLE doc_callbacks;
DROP TABLE doc_changes;
DROP TABLE doc_pucker;
DROP TABLE file_statistic2;
DROP TABLE tast_result;

CREATE TABLE convert_queue (
	cq_id SERIAL PRIMARY KEY,
	cq_data text,
	cq_priority smallint,
	cq_create_time timestamp NOT NULL DEFAULT '2000-01-01 00:00:00',
	cq_update_time timestamp default current_timestamp,
	cq_isbusy smallint NOT NULL
);
   
CREATE TABLE doc_callbacks (
	dc_key character varying(255) NOT NULL PRIMARY KEY,
	dc_callback text NOT NULL
);
   
CREATE TABLE doc_changes (
	dc_key character varying(255) NOT NULL,
	dc_change_id integer NOT NULL,
	dc_user_id character varying(255) NOT NULL,
	dc_user_id_original character varying(255) NOT NULL,
	dc_user_name character varying(255) NOT NULL,
	dc_data text NOT NULL,
	dc_date timestamp NOT NULL default current_timestamp,
	CONSTRAINT key_id PRIMARY KEY (dc_key,dc_change_id)
);

CREATE TABLE doc_pucker (
	dp_key character varying(255) NOT NULL PRIMARY KEY,
	dp_callback text  NOT NULL,
	dp_documentformatsave integer  NOT NULL,
	dp_indexuser integer  NOT NULL
);

CREATE TABLE file_statistic2 (
	fsc_id serial NOT NULL PRIMARY KEY,
	fsc_affiliate character varying(255) NOT NULL default '',
	fsc_filename character varying(255) NOT NULL DEFAULT '',
	fsc_time timestamp NOT NULL default '2000-01-01 00:00:00',
	fsc_tag character varying(255) NOT NULL DEFAULT ''
);

CREATE TABLE tast_result (
	tr_key character varying(255) NOT NULL PRIMARY KEY,
	tr_format character varying(45) NOT NULL,
	tr_status smallint NOT NULL,
	tr_status_info integer NOT NULL,
	tr_last_open_date timestamp NOT NULL default current_timestamp,
	tr_title character varying(255) NOT NULL
);
   
UPDATE pg_class
	SET relowner = (SELECT oid FROM pg_roles WHERE rolname = 'onlyoffice')
	WHERE relname IN (SELECT relname FROM pg_class, pg_namespace WHERE pg_namespace.oid = pg_class.relnamespace AND pg_namespace.nspname = 'public');
     
GRANT USAGE ON SCHEMA public to onlyoffice;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO onlyoffice;
GRANT CONNECT ON DATABASE onlyoffice to onlyoffice;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA public TO onlyoffice;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA public TO onlyoffice;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO onlyoffice;
GRANT USAGE ON SCHEMA public to onlyoffice;

