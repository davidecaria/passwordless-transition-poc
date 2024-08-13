DROP TABLE IF EXISTS fromUncommittedToStaged;

CREATE TABLE fromUncommittedToStaged (
    time datetime2,
    user_id varchar(128),
    logicapp_id varchar(128),
    sequence_number INT,
    primary key(time,user_id)
);

CREATE INDEX index_user_id ON fromUncommittedToStaged (user_id);