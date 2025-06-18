-- Top 3 jugadores con más goles
SELECT j.nombre, SUM(s.goles) AS total_goles
FROM Jugador j JOIN Estadistica s ON j.player_id = s.player_id
GROUP BY j.player_id
ORDER BY total_goles DESC LIMIT 3;


-- Partidos de un equipo con nombre de estadio
SELECT p.match_id, e.nombre AS estadio
FROM Partido p JOIN Estadio e ON p.stadium_id = e.stadium_id
WHERE p.home_team_id = 1 OR p.away_team_id = 1;


-- Jugadores que han marcado goles en partidos con resultado '3-0'
SELECT nombre FROM Jugador 
WHERE player_id IN (
    SELECT player_id FROM Estadistica 
    WHERE goles > 0 AND match_id IN (
        SELECT match_id FROM Partido WHERE resultado = '3-0'
    )
);


SELECT 
    e.nombre AS equipo_local, 
    SUM(s.goles) AS goles_en_casa
FROM 
    Partido p
JOIN 
    Equipo e ON p.home_team_id = e.team_id
JOIN 
    Estadistica s ON p.match_id = s.match_id
WHERE 
    s.player_id IN (SELECT player_id FROM Jugador WHERE team_id = p.home_team_id)
GROUP BY 
    e.nombre
ORDER BY 
    goles_en_casa DESC
LIMIT 5;


SELECT 
    eq.nombre AS equipo, 
    j.nombre AS jugador, 
    SUM(es.asistencias) AS total_asistencias
FROM 
    Jugador j
JOIN 
    Equipo eq ON j.team_id = eq.team_id
JOIN 
    Estadistica es ON j.player_id = es.player_id
GROUP BY 
    eq.nombre, j.nombre
ORDER BY 
    eq.nombre, total_asistencias DESC;


SELECT 
    EXTRACT(YEAR FROM fecha) AS temporada, 
    ROUND(AVG(goles_partido), 2) AS promedio_goles
FROM (
    SELECT 
        p.match_id, 
        p.fecha, 
        SUM(s.goles) AS goles_partido
    FROM 
        Partido p
    JOIN 
        Estadistica s ON p.match_id = s.match_id
    GROUP BY 
        p.match_id, p.fecha
) AS subquery
GROUP BY 
    temporada
ORDER BY 
    temporada;


SELECT 
    e.nombre AS estadio, 
    e.capacidad, 
    COUNT(p.match_id) AS partidos_jugados
FROM 
    Estadio e
LEFT JOIN 
    Partido p ON e.stadium_id = p.stadium_id
GROUP BY 
    e.nombre, e.capacidad
ORDER BY 
    e.capacidad DESC;


SELECT 
    j.nombre AS jugador
FROM 
    Jugador j
JOIN 
    Equipo e ON j.team_id = e.team_id
WHERE 
    e.ciudad = 'Barcelona'  -- Ejemplo: filtrar por ciudad
GROUP BY 
    j.player_id, j.nombre
HAVING 
    COUNT(DISTINCT e.team_id) = (SELECT COUNT(*) FROM Equipo WHERE ciudad = 'Barcelona');