--2. Prikaži sve timove koji sudjeluju na određenom turniru
--Za zadani turnir izlistati sve timove i predstavnika tima.


EXPLAIN ANALYZE
SELECT tt.team_id, te.name AS team_name, te.contact
FROM Tournament_Teams tt
LEFT JOIN Teams te ON tt.team_id = te.team_id
WHERE tt.tournament_id = 2;

CREATE INDEX idx_tt_tournament_id
ON tournament_teams(tournament_id);
--3. Prikaži sve igrače iz određenog tima
--Izvući popis svih igrača, njihove godine rođenja i ostale podatke.


EXPLAIN ANALYZE
SELECT p.name, p.last_name, EXTRACT(Year FROM p.Birthday), p.jersey 
FROM Players p
WHERE p.team_id=900;

CREATE INDEX idx_players_team_id
ON players(team_id);

--4. Prikaži sve utakmice određenog turnira
--Prikazati datume, vrijeme, timove koji igraju, vrstu utakmice i rezultat.


EXPLAIN ANALYZE
SELECT m.Match_datetime AS Date_and_time, t1.name AS team1, t2.name AS team2, m.type, CONCAT(m.team1_score, '-', m.team2_score) AS result
FROM Matches m
JOIN teams t1 ON t1.team_id=m.team1_id
JOIN teams t2 ON t2.team_id=m.team2_id
WHERE m.tournament_id=30;

CREATE INDEX idx_matches_tournament_id
ON matches(tournament_id);


--5. Prikaži sve utakmice određenog tima kroz sve turnire
--Izvući sve utakmice u kojima je tim sudjelovao, s rezultatima i fazama natjecanja.

EXPLAIN ANALYZE
SELECT 
    m.match_datetime,tr.name AS tournament,
	m.type AS match_type,
	t1.name AS team1,
    t2.name AS team2,
    m.team1_score,
    m.team2_score
FROM Matches m
JOIN Tournaments tr ON m.tournament_id = tr.tournament_id
JOIN Teams t1 ON m.team1_id = t1.team_id
JOIN Teams t2 ON m.team2_id = t2.team_id
WHERE 10 IN (m.team1_id, m.team2_id)
ORDER BY tr.name;

CREATE INDEX idx_matches_team1_id
ON matches(team1_id);

CREATE INDEX idx_matches_team2_id
ON matches(team2_id);
