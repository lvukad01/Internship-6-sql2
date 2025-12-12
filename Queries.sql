--1. Prikaži popis svih turnira

SELECT t.name, t.year, t.location, tm.name AS winner_id 
FROM Tournaments t
LEFT JOIN  Teams tm on t.winner_id=tm.team_id;


--2. Prikaži sve timove koji sudjeluju na određenom turniru

SELECT tt.team_id, te.name AS team_name, te.contact
FROM Tournament_Teams tt
LEFT JOIN Teams te ON tt.team_id = te.team_id
WHERE tt.tournament_id = 2;

--3. Prikaži sve igrače iz određenog tima

SELECT p.name, p.last_name, EXTRACT(Year FROM p.Birthday), p.jersey 
FROM Players p
WHERE p.team_id=900;

--4. Prikaži sve utakmice određenog turnira

SELECT m.Match_datetime AS Date_and_time, t1.name AS team1, t2.name AS team2, m.type, CONCAT(m.team1_score, '-', m.team2_score) AS result
FROM Matches m
JOIN teams t1 ON t1.team_id=m.team1_id
JOIN teams t2 ON t2.team_id=m.team2_id
WHERE m.tournament_id=30;

--5. Prikaži sve utakmice određenog tima kroz sve turnire

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

--6. Izlistati sve događaje (golovi, kartoni) za određenu utakmicu
--Prikazati tip događaja, ime igrača koji ga je ostvario.

SELECT t.name AS tournament, m.type AS match_type, e.Event_type, p.name AS player 
FROM events e
JOIN matches m ON m.match_id=e.match_id
JOIN tournaments t ON t.tournament_id=m.tournament_id
JOIN players p ON p.player_id =e.player_id
WHERE m.match_id=273;


--