
PRAGMA foreign_keys = ON;

CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    fname TEXT NOT NULL, 
    lname TEXT NOT NULL
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
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    parent_reply_id INTEGER, -- EACH REPLY REF PARENT REPLY (TRACK PREVIOUS REPLIES?)
    user_id INTEGER NOT NULL,
    body TEXT NOT NULL,

    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (parent_reply_id) REFERENCES replies(id)
);

CREATE TABLE question_likes (
    -- heart BOOLEAN, -- can we default this to false?
    user_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
    users (fname, lname)
VALUES
    ('John', 'Doe'),
    ('Lorenzo', 'Tijerina'),
    ('Logan', 'Hart');

INSERT INTO
    questions (title, body, author_id)
VALUES
    ('Meaning of Life', 'Why are we here?', (SELECT id FROM users WHERE lname = 'Doe')),
    ('Stack Overflow?', 'What even is stack bro?', (SELECT id FROM users WHERE lname = 'Tijerina'));

INSERT INTO
    question_follows (user_id, question_id)
VALUES 
    (3, 1),
    (3, 2),
    (1, 2),
    (2, 1),
    (2, 2);

INSERT INTO 
    replies (question_id, parent_reply_id, user_id, body)
VALUES
    (1, NULL, 2, "No fuckin clue"),
    (2, NULL, 1, "I don't stack!"),
    (2, 2, 3, "Change your tune, bro.");

INSERT INTO
    question_likes (user_id, question_id)
VALUES
    (3, 1),
    (2, 1),
    (2, 2),
    (1, 2);

