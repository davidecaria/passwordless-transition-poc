DROP TABLE IF EXISTS fromStagedToCommitted;

CREATE TABLE fromStagedToCommitted (
    time datetime2,
    user_id varchar(128),
    creationTime datetime2,
    model varchar(128),
    key_id varchar(128),
    primary key(time,user_id)
);

CREATE INDEX index_user_id ON fromStagedToCommitted (user_id);

