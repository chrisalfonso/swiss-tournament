-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.

-- REFERENCE(S): 
-- Udacity FSND P3 forum discussion "problem with playerStandings" posted by abhishek_ghosh
-- Udacity FSND P3 forum discussion "swissPairings using only SQL query" posted by joshua_313208


--CREATE DATABASE tournament;
--\c tournament

DROP TABLE IF EXISTS players, matches CASCADE;

CREATE TABLE players (
	id serial PRIMARY KEY,
	name text
);


CREATE TABLE matches (
	id serial PRIMARY KEY,
	winner integer REFERENCES players(id) NOT NULL,
	loser integer REFERENCES players(id) NOT NULL
);

CREATE VIEW standings AS
SELECT players.id, players.name, 
(SELECT count(matches.winner) FROM matches WHERE players.id = matches.winner) AS wins, 
(SELECT count(matches.id) FROM matches WHERE players.id = matches.winner OR players.id = matches.loser) AS matches
FROM players order by wins desc, matches desc; 


-- Add rank column to standings (Prefer to modify standings view but unit test allows only 4 columns in standings view)
CREATE VIEW standingsRanks AS
SELECT standings.*, row_number() OVER (ORDER BY wins DESC) AS rank FROM standings;

-- Players with even-numbered ranks
CREATE VIEW evenRanks AS
SELECT id, name, rank, row_number() OVER (ORDER BY rank) AS pairID FROM standingsRanks 
WHERE mod(rank, 2) = 0;

-- Players with odd-numbered ranks
CREATE VIEW oddRanks AS
SELECT id, name, rank, row_number() OVER (ORDER BY rank) AS pairID FROM standingsRanks 
WHERE mod(rank, 2) = 1;

