PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE question (
    question_id integer CONSTRAINT question_pk PRIMARY KEY autoincrement,
    question_name text NOT NULL,
    answer text,
    detail text,
    parent_id integer CONSTRAINT parent_id_fk REFERENCES question,
    is_resolved integer DEFAULT 0 NOT NULL,
    date_modified text DEFAULT (datetime(CURRENT_TIMESTAMP, 'localtime')),
    date_created text DEFAULT (datetime(CURRENT_TIMESTAMP, 'localtime')),
    CONSTRAINT question_name_unique UNIQUE (question_name, parent_id)
);
INSERT INTO question VALUES(1,'How do I tell Kitty where to look for the config directory',NULL,NULL,NULL,0,'2026-03-22 16:04:13','2026-03-22 16:04:13');
INSERT INTO question VALUES(2,'How do I get started with Azure development',NULL,NULL,NULL,0,'2026-03-22 16:39:17','2026-03-22 16:39:17');
CREATE TABLE reference (
    reference_id integer NOT NULL CONSTRAINT reference_pk PRIMARY KEY autoincrement,
    reference_name text,
    reference_url text,
    question_id integer not null
        constraint question_id_fk references question (question_id) on delete cascade,
    description text,
    date_modified text DEFAULT (datetime(CURRENT_TIMESTAMP, 'localtime')),
    date_created text DEFAULT (datetime(CURRENT_TIMESTAMP, 'localtime'))
);
CREATE TABLE test (
    test_id integer NOT NULL CONSTRAINT test_pk PRIMARY KEY autoincrement,
    question_id integer CONSTRAINT test_question_question_id_fk REFERENCES question,
    hypothesis text NOT NULL,
    is_refuted integer DEFAULT 0,
    is_tested integer DEFAULT 0,
    result text,
    date_modified text DEFAULT (datetime(CURRENT_TIMESTAMP, 'localtime')),
    date_created text DEFAULT (datetime(CURRENT_TIMESTAMP, 'localtime'))
);
CREATE TABLE current (
    question_id integer CONSTRAINT current_question_question_id_fk REFERENCES question,
    test_id integer CONSTRAINT current_test_test_id_fk REFERENCES test,
    reference_id integer CONSTRAINT current_reference_id_fk REFERENCES reference(reference_id)
);
INSERT INTO "current" VALUES(NULL,NULL,NULL);
INSERT INTO sqlite_sequence VALUES('question',2);
INSERT INTO sqlite_sequence VALUES('question',1);
CREATE TRIGGER question_set_date_modified
AFTER
UPDATE
    ON question FOR each ROW
    WHEN new.date_modified = old.date_modified
BEGIN
UPDATE
    question
SET
    date_modified = (datetime(CURRENT_TIMESTAMP, 'localtime'))
WHERE
    question_id = new.question_id;

END;
CREATE TRIGGER test_set_date_modified
AFTER
UPDATE
    ON test FOR each ROW
    WHEN new.date_modified = old.date_modified
BEGIN
UPDATE
    question
SET
    date_modified = (datetime(CURRENT_TIMESTAMP, 'localtime'))
WHERE
    question_id = new.question_id;

END;
CREATE INDEX reference_question_id_index ON reference (question_id);
COMMIT;
