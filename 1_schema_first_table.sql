CREATE SCHEMA pokequeue;

CREATE TABLE pokequeue.MESSAGES(
    id INT IDENTITY(1,1) PRIMARY KEY,
    [message] VARCHAR(255) NOT NULL
);

INSERT INTO pokequeue.MESSAGES ([message]) VALUES ('PokeQueue - Sistemas Expertos II PAC 2025');
INSERT INTO pokequeue.MESSAGES ([message]) VALUES ('RODRIGO ELIEZER FUNES ENRIQUEZ');
INSERT INTO pokequeue.MESSAGES ([message]) VALUES ('20171001103');
INSERT INTO pokequeue.MESSAGES ([message]) VALUES ('Agosto 09, 2025');

SELECT * FROM pokequeue.MESSAGES