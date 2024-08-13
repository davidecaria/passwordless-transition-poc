DROP TABLE IF EXISTS temporaryAccessPassDelivery;

CREATE TABLE temporaryAccessPassDelivery (
    time datetime2,
    user_id varchar(128),
    tap_id varchar(128),
    start_datetime datetime2,
    lifetime_minutes INT,
    primary key(time,user_id)
);

CREATE INDEX index_user_id ON temporaryAccessPassDelivery (user_id);