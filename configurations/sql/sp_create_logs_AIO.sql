DROP TABLE if EXISTS logs_AIO

CREATE TABLE logs_AIO (

    time datetime2,             -- time of the operation
    user_id varchar(255),       -- user principal name
    logicapp_id varchar(128),   -- id of the logic app issuing the record
    op_code varchar(128),       -- code to identify the operation, between 0, 1, 2
    tap_id varchar(128),        -- if op code is 2 this field is populated
    start_datetime datetime2,   -- if op code is 2 this field is populated
    lifetime_minutes INT,       -- if op code is 2 this field is populated
    PRIMARY KEY (time,user_id)

);

CREATE INDEX index_user_id ON logs_AIO (user_id);