-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.

CREATE DATABASE tournament;
/c tournament

CREATE TABLE players (
	id serial PRIMARY KEY,
	name text
);

CREATE TABLE matches (
	id integer references players,
	outcome text,
	round integer
-- I think this table needs columns for 'winner' and 'loser' (just like the example 'results' table below)
);

-- Got this from the forum: 'problem with playerStandings' (using it as a model for now)
CREATE TABLE results (
	id serial PRIMARY KEY,
	winner integer REFERENCES players(id) NOT NULL,
	loser integer REFERENCES players(id) NOT NULL
);

-- Get all winners
CREATE VIEW num_wins AS
SELECT id, count(matches.outcome) AS wins FROM matches
WHERE outcome = 'winner'
GROUP BY id ORDER BY wins desc;

-- Get number of rounds played
CREATE VIEW num_matches AS
SELECT id, count(matches.round) AS rounds_played FROM matches
GROUP BY id;

