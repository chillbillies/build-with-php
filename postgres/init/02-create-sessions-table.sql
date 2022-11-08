\connect zing

CREATE TABLE sessions (
    sess_id VARCHAR(128) NOT NULL PRIMARY KEY,
    sess_data BYTEA NOT NULL,
    sess_lifetime INTEGER NOT NULL,
    sess_time INTEGER NOT NULL
);
CREATE INDEX sessions_sess_lifetime_idx ON sessions (sess_lifetime);
GRANT SELECT, INSERT, UPDATE, DELETE ON sessions TO zing;

\connect zing_test

CREATE TABLE sessions (
                          sess_id VARCHAR(128) NOT NULL PRIMARY KEY,
                          sess_data BYTEA NOT NULL,
                          sess_lifetime INTEGER NOT NULL,
                          sess_time INTEGER NOT NULL
);
CREATE INDEX sessions_sess_lifetime_idx ON sessions (sess_lifetime);
GRANT SELECT, INSERT, UPDATE, DELETE ON sessions TO zing_test;
