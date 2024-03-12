CREATE TABLE users(
    uname TEXT PRIMARY KEY,
    pw TEXT,
    name TEXT,
    surname TEXT,
    sess_id UUID UNIQUE
);

-- for debug purposes
INSERT into users VALUES ('davide', 'pw', 'Davide', 'Spada')