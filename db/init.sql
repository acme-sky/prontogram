CREATE TABLE users(
    uname TEXT PRIMARY KEY,
    pw TEXT,
    name TEXT,
    surname TEXT,
    sess_id UUID UNIQUE
);


CREATE TABLE ASoffers(
    offer_token INTEGER PRIMARY KEY, 
    client_username TEXT NOT NULL,
    client_name TEXT NOT NULL,
    client_surname TEXT NOT NULL,
    departure_location TEXT NOT NULL,
    arrival_location TEXT NOT NULL,
    offer_timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    offer_duration INTEGER NOT NULL,
    departure_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    offer_price FLOAT NOT NULL,
    is_last_minute BOOLEAN NOT NULL,
    is_valid BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT fk_users_id
        FOREIGN KEY(client_username) REFERENCES users(uname)
);
-- for debug purposes
INSERT into users VALUES ('davide', 'pw', 'Davide', 'Spada');
INSERT into ASoffers VALUES (001 ,'davide', 'Davide', 'Spada', 'Napoli', 'Bologna', '2024-03-19 13:03:27.236215+00', 12, '2024-03-19 13:03:27.236215+00', 1773.69, FALSE, TRUE )