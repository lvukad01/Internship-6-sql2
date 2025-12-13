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


--6. Izlistati sve događaje (golovi, kartoni) za određenu utakmicu
--Prikazati tip događaja, ime igrača koji ga je ostvario.

EXPLAIN ANALYZE
SELECT t.name AS tournament, m.type AS match_type, e.Event_type, CONCAT(p.name, ' ', p.last_name) AS player
FROM events e
JOIN matches m ON m.match_id=e.match_id
JOIN tournaments t ON t.tournament_id=m.tournament_id
JOIN players p ON p.player_id =e.player_id
WHERE m.match_id=273;


CREATE INDEX idx_events_match_id
ON events(match_id);


--7. Prikaži sve igrače koji su dobili žuti ili crveni karton na cijelom turniru
--S navedenim timom, utakmicom i minutom.
EXPLAIN ANALYZE
SELECT CONCAT(p.name, ' ', p.last_name) AS player, t.name AS Team, m.type AS match_type, e.event_type, e.minute
FROM events e
JOIN matches m ON m.match_id=e.match_id
JOIN players p ON p.player_id=e.player_id
JOIN teams t ON t.team_id=p.team_id
JOIN tournaments tr ON tr.tournament_id=m.tournament_id
WHERE tr.tournament_id=11
ORDER BY t.team_id;


CREATE INDEX idx_events_event_type
ON events(event_type);



--8. Prikaži sve strijelce turnira
--Izvući igrače koji su postigli pogodak, broj golova te tim.

EXPLAIN ANALYZE
SELECT t.name AS team, CONCAT(p.name, ' ', p.last_name) AS player, COUNT(*) AS goals
FROM events e
JOIN players p ON p.player_id=e.player_id
JOIN teams t ON t.team_id=p.team_id
JOIN matches m ON m.match_id=e.match_id
JOIN tournaments tr ON tr.tournament_id=m.tournament_id
WHERE tr.tournament_id=11 AND e.event_type='goal'
GROUP BY t.name,p.name,p.last_name
ORDER BY t.name;

--9. Prikaži tablicu bodova za određeni turnir
--Za svaki tim izlistati broj osvojenih bodova, gol, razliku i plasman.
EXPLAIN ANALYZE
SELECT t.name AS team, tt.points, tt.goals_for AS goals, (tt.goals_for-goals_against) AS goal_difference,tt.place
FROM tournament_teams tt
JOIN teams t ON t.team_id=tt.team_id
JOIN tournaments tr ON tr.tournament_id=tt.tournament_id
WHERE tr.tournament_id=33;

CREATE INDEX idx_tournament_teams_tournament_id
ON tournament_teams(tournament_id);


--10. Prikaži sve finalne utakmice u povijesti
--Izvući utakmice čija je faza “finale” i prikazati pobjednika.
EXPLAIN ANALYZE
SELECT tr.name AS tournament,tr.year, t.name AS winner
FROM matches m
JOIN tournaments tr ON tr.tournament_id=m.tournament_id
JOIN teams t ON t.team_id=tr.winner_id
WHERE m.type='Final'
ORDER BY tr.name,tr.year;

CREATE INDEX idx_matches_type
ON matches(type);


--11. Prikaži sve vrste utakmica
--Npr. grupna faza, četvrtfinale, polufinale, finale – s brojem utakmica te vrste.
EXPLAIN ANALYZE
SELECT m.type, COUNT(*) AS number_of_matches
FROM matches m
GROUP BY m.type;


--12. Prikaži sve utakmice odigrane na određeni datum
--Prikazati timove, vrstu utakmice i rezultat.
EXPLAIN ANALYZE
SELECT t1.name AS team1, t2.name AS team2, m.type AS match_type, CONCAT(m.team1_score, '-', m.team2_score) AS result
FROM matches m
JOIN teams t1 ON t1.team_id=m.team1_id
JOIN teams t2 ON t2.team_id=m.team2_id
WHERE m.match_datetime='2005-10-03';

CREATE INDEX idx_matches_match_datetime
ON matches(match_datetime);



--13. Prikaži igrače koji su postigli najviše golova na određenom turniru
--Sortirati po broju golova silazno.

EXPLAIN ANALYZE
SELECT p.player_id, CONCAT(p.name, ' ', p.last_name) AS player, t.name AS team, COUNT (*) AS GOALS
FROM Events e
JOIN players p ON p.player_id=e.player_id
JOIN matches m ON m.match_id=e.match_id
JOIN teams t ON t.team_id=p.team_id
WHERE m.tournament_id=11
GROUP BY p.player_id, player,t.name
ORDER BY GOALS DESC;

--Već imamo potrebne  indexe



--14. Prikaži sve turnire na kojima je određeni tim sudjelovao
--Za svaki turnir navesti godinu održavanja i ostvareni plasman.

EXPLAIN ANALYZE
SELECT tr.name AS tournament, tr.year, tt.place
FROM tournament_teams tt
JOIN tournaments tr ON tr.tournament_id=tt.tournament_id
JOIN teams t ON t.team_id=tt.team_id
WHERE t.team_id=85;

CREATE INDEX idx_tournament_teams_team_id
ON tournament_teams(team_id);


--15. Pronađi pobjednika turnira na temelju odigranih utakmica
--Izvući tim s najviše bodova ili pobjednika finala, ovisno o strukturi turnira.

EXPLAIN ANALYZE
SELECT tr.name, tr.year,
    CASE 
        WHEN m.team1_score > m.team2_score THEN t1.name
        ELSE t2.name
    END AS winner
FROM Matches m
JOIN teams t1 ON t1.team_id=m.team1_id
JOIN teams t2 ON t2.team_id=m.team2_id
JOIN tournaments tr ON tr.tournament_id=m.tournament_id
WHERE m.type = 'Final';

--Ne treba dodavati novi index, već imamo potrebni index


--16. Za svaki turnir ispiši broj timova i igrača
EXPLAIN ANALYZE
SELECT 
    tr.tournament_id,
    tr.name,
    COUNT(DISTINCT tt.team_id) AS team_count,
    COUNT(DISTINCT p.player_id) AS player_count
FROM Tournaments tr
LEFT JOIN Tournament_Teams tt ON tr.tournament_id = tt.tournament_id
LEFT JOIN Players p ON p.team_id = tt.team_id
GROUP BY tr.tournament_id, tr.name; 

--već imamo potrebne indexe


--17. Najbolji strijelci po timu
--Za svaki tim ispiši najboljeg strijelca na svim turnirima gdje je taj tim sudjelovao
EXPLAIN ANALYZE
SELECT 
    t.team_id,
    t.name AS team,
    p.player_id,
    CONCAT(p.name, ' ', p.last_name) AS player,
    COUNT(e.event_id) AS goals
FROM Teams t
JOIN Players p ON p.team_id = t.team_id
LEFT JOIN Events e ON e.player_id = p.player_id AND e.event_type = 'goal'
GROUP BY t.team_id, t.name, p.player_id, player
ORDER BY goals DESC,t.team_id;

--već imamo potrebne indexe

--18. Utakmice nekog suca
--Za određenog sudca ispiši sve utakmice na kojima je sudio
EXPLAIN ANALYZE
SELECT tr.name as tournament, tr.year, m.type
FROM matches m
JOIN tournaments tr ON tr.tournament_id=m.tournament_id
JOIN referees r ON r.referee_id=m.referee_id
WHERE r.referee_id=391;

CREATE INDEX idx_matches_referee_id
ON matches(referee_id);






