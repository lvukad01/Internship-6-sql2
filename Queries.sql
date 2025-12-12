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

SELECT t.name AS tournament, m.type AS match_type, e.Event_type, CONCAT(p.name, ' ', p.last_name) AS player
FROM events e
JOIN matches m ON m.match_id=e.match_id
JOIN tournaments t ON t.tournament_id=m.tournament_id
JOIN players p ON p.player_id =e.player_id
WHERE m.match_id=273;


--7. Prikaži sve igrače koji su dobili žuti ili crveni karton na cijelom turniru
--S navedenim timom, utakmicom i minutom.

SELECT CONCAT(p.name, ' ', p.last_name) AS player, t.name AS Team, m.type AS match_type, e.event_type, e.minute
FROM events e
JOIN matches m ON m.match_id=e.match_id
JOIN players p ON p.player_id=e.player_id
JOIN teams t ON t.team_id=p.team_id
JOIN tournaments tr ON tr.tournament_id=m.tournament_id
WHERE tr.tournament_id=11
ORDER BY t.team_id;


--8. Prikaži sve strijelce turnira
--Izvući igrače koji su postigli pogodak, broj golova te tim.

SELECT t.name AS team, CONCAT(p.name, ' ', p.last_name) AS player, COUNT(*) AS goals
FROM events e
JOIN players p ON p.player_id=e.player_id
JOIN teams t ON t.team_id=p.team_id
JOIN matches m ON m.match_id=e.match_id
JOIN tournaments tr ON tr.tournament_id=m.tournament_id
WHERE tr.tournament_id=11 AND e.event_type='goal'
GROUP BY t.name,p.name,p.last_name
ORDER BY t.name;

SELECT tr.tournament_id, * FROM events e
JOIN matches m ON m.match_id=e.match_id
JOIN tournaments tr ON tr.tournament_id=m.tournament_id
WHERE e.event_type='goal'
ORDER BY tr.tournament_id;

--9. Prikaži tablicu bodova za određeni turnir
--Za svaki tim izlistati broj osvojenih bodova, gol, razliku i plasman.

SELECT t.name AS team, tt.points, tt.goals_for AS goals, (tt.goals_for-goals_against) AS goal_difference,tt.place
FROM tournament_teams tt
JOIN teams t ON t.team_id=tt.team_id
JOIN tournaments tr ON tr.tournament_id=tt.tournament_id
WHERE tr.tournament_id=33;

