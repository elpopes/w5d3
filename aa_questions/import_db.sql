-- start here
PRAGMAforeign_keys = ON

CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    fname TEXT NOT NULL, 
    lname TEXT NOT NULL,
);

CREATE TABLE questions (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    author_id INTEGER NOT NULL,

    FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
    user_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE replies (
    reply_id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    parent_reply_id INTEGER, -- EACH REPLY REF PARENT REPLY (TRACK PREVIOUS REPLIES?)
    user_id INTEGER NOT NULL,
    body TEXT NOT NULL,

    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (parent_reply_id) REFERENCES reply(id)
);

CREATE TABLE question_likes (
    heart BOOLEAN, -- can we default this to false?
    user_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,

    FOREIGN KEY (user_id) REFERENCES user(id),
    FOREIGN KEY (question_id) REFERENCES question(id)
);

INSERT INTO
    users (fname, lname)
VALUES
    ('John', 'Doe'),
    ('Lorenzo', 'Tijerina'),
    ('Logan', 'Hart');

INSERT INTO
    questions (title, body, user_id)
VALUES
    ('Meaning of Life', 'Why are we here?', (SELECT id FROM users WHERE lname = 'Doe')),
    ('Stack Overflow?', 'What even is stack bro?', (SELECT id FROM users WHERE lname = 'Tijerina'));

INSERT INTO

