CREATE TABLE users(
    uname TEXT PRIMARY KEY NOT NULL,
    pw TEXT NOT NULL,
    name TEXT NOT NULL,
    surname TEXT NOT NULL,
    sess_id UUID UNIQUE
);

CREATE TABLE messages(
    full_text   TEXT NOT NULL,
    username    TEXT NOT NULL,
    expiring_date   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_users_id
        FOREIGN KEY(username) REFERENCES users(uname)
);
-- for debug purposes
INSERT into users VALUES ('davide', 'pw', 'Davide', 'Spada');
INSERT into users VALUES ('dav', 'pw', 'Davide', 'Spada');

INSERT into messages VALUES ('Hello John Doe, this is the offer token for your flight from BLQ to CPH in date April 10th 11:10 - April 10th 13:30.<a href="#" target="_blank">1234', 'davide','2024-03-19 13:03:27.236215+00');
INSERT into messages VALUES ('Hello John Doe, this is the offer token for your flight from BLQ to CPH in date April 10th 11:10 - April 11th 13:30.<a href="#" target="_blank">1234', 'davide','2024-03-19 13:03:27.236215+00');
INSERT into messages VALUES ('Hello John Doe, this is the offer token for your flight from BLQ to CPH in date April 10th 11:10 - April 12th 13:30.<a href="#" target="_blank">1234', 'davide','2024-03-19 13:03:27.236215+00');
INSERT into messages VALUES ('Hello John Doe, this is the offer token for your flight from BLQ to CPH in date April 10th 11:10 - April 13th 13:30.<a href="#" target="_blank">1234', 'davide','2024-03-19 13:03:27.236215+00');