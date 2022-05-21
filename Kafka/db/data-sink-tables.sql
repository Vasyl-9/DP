CREATE TABLE IF NOT EXISTS local_security_incident (
    id SERIAL PRIMARY KEY,
    data text,
    session_id text,
    user_id text,
	kafka_partition integer,
	kafka_offset bigint,
	kafka_topic text
);

CREATE TABLE IF NOT EXISTS scanning_result (
    id SERIAL PRIMARY KEY,
    data text,
    version integer,
    specification text,
    user_id text,
    instance_name text,
	kafka_partition integer,
	kafka_offset bigint,
	kafka_topic text
);
