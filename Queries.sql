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
