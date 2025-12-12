--CREATE TABLES

CREATE TYPE Events_type AS ENUM('goal','yellow_card','red_card');
CREATE TYPE TournamentTeams_Stage AS ENUM('grupa','osmina','četvrtfinale','polufinale','finale');


CREATE TABLE Teams
(
	Team_id SERIAL PRIMARY KEY,
	Name VARCHAR(50) NOT NULL,
	Country VARCHAR(50),
	Contact VARCHAR(50) NOT NULL,
	created_at TIMESTAMP DEFAULT now() NOT NULL,
	updated_at TIMESTAMP DEFAULT now() NOT NULL
);


CREATE TABLE Players
(
	Player_id SERIAL PRIMARY KEY,
	Name VARCHAR(50) NOT NULL,
	Last_name VARCHAR(50) NOT NULL,
	Birthday DATE NOT NULL CHECK(EXTRACT(Year FROM Birthday )  BETWEEN 1960 AND 2010),
	Jersey INT NOT NULL,
	Team_id INT REFERENCES Teams(Team_id),
	created_at TIMESTAMP DEFAULT now() NOT NULL,
	updated_at TIMESTAMP DEFAULT now() NOT NULL,
	UNIQUE(Team_id, Jersey)
);

ALTER TABLE Teams
ADD COLUMN 	Captain_id INT REFERENCES Players(Player_id);

CREATE TABLE Tournaments
(
	Tournament_id SERIAL PRIMARY KEY,
	Name VARCHAR(50) NOT NULL,
	Year INT NOT NULL CHECK(Year<2030 AND Year>1900),
	Location VARCHAR(50),
	Winner_id INT REFERENCES Teams(Team_id),
	created_at TIMESTAMP DEFAULT now() NOT NULL,
	updated_at TIMESTAMP DEFAULT now() NOT NULL
);

CREATE TABLE Matchtypes (
Matchtype_id SERIAL PRIMARY KEY,
Name VARCHAR(80) NOT NULL,
created_at TIMESTAMP DEFAULT now() NOT NULL,
updated_at TIMESTAMP DEFAULT now() NOT NULL
);

CREATE TABLE Referees (
Referee_id SERIAL PRIMARY KEY,
Name VARCHAR(50) NOT NULL,
Last_name VARCHAR(50) NOT NULL,
Birthday DATE,
created_at TIMESTAMP DEFAULT now() NOT NULL,
updated_at TIMESTAMP DEFAULT now() NOT NULL
);

CREATE TABLE Matches(
	Match_id SERIAL PRIMARY KEY,
	Matchtype_id INT REFERENCES Matchtypes(Matchtype_id),
	Team1_id INT REFERENCES Teams(team_id),
	Team2_id INT REFERENCES Teams(team_id),
	Referee_id INT REFERENCES Referees(Referee_id),
	Tournament_id INT REFERENCES Tournaments(Tournament_id),
	Match_datetime TIMESTAMPTZ,
	Team1_score INT DEFAULT 0,
	Team2_score INT DEFAULT 0,
	created_at TIMESTAMP DEFAULT now() NOT NULL,
	updated_at TIMESTAMP DEFAULT now() NOT NULL,
	CHECK (Team1_id <> Team2_id)
);

CREATE TABLE Events (
Event_id SERIAL PRIMARY KEY,
Match_id INT REFERENCES Matches(Match_id),
Player_id INT REFERENCES Players(Player_id),
Event_type Events_type NOT NULL, 
minute INT,
created_at TIMESTAMP DEFAULT now() NOT NULL,
updated_at TIMESTAMP DEFAULT now() NOT NULL
);


CREATE TABLE  Tournament_teams(
	Tournament_id INT REFERENCES Tournaments(Tournament_id),
	Team_id INT REFERENCES Teams(Team_id),
	Place INT,
	Points INT DEFAULT 0,
	Goals_for INT DEFAULT 0,
	Goals_against INT DEFAULT 0,
	Stage TournamentTeams_Stage NOT NULL,
	created_at TIMESTAMPTZ DEFAULT now() NOT NULL,
	updated_at TIMESTAMPTZ DEFAULT now() NOT NULL,
	PRIMARY KEY (tournament_id, team_id)	
);


-- trigger for updated_at

CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN 
	NEW.updated_at=NOW();
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_teams_updated
BEFORE UPDATE ON Teams
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_players_updated
BEFORE UPDATE ON Players
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();



CREATE TRIGGER trg_tournaments_updated
BEFORE UPDATE ON Tournaments
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();



CREATE TRIGGER trg_matchtypes_updated
BEFORE UPDATE ON Matchtypes
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();



CREATE TRIGGER trg_referees_updated
BEFORE UPDATE ON Referees
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();


CREATE TRIGGER trg_matches_updated
BEFORE UPDATE ON Matches
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();


CREATE TRIGGER trg_events_updated
BEFORE UPDATE ON Events
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_tournament_teams_updated
BEFORE UPDATE ON Tournament_teams
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();