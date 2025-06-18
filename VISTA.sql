CREATE VIEW PartidosEstadio AS
SELECT p.match_id, p.fecha, e.nombre AS estadio
FROM Partido p JOIN Estadio e ON p.stadium_id = e.stadium_id;

CREATE VIEW EstadisticasJugador AS
SELECT j.player_id, j.nombre, SUM(s.goles) AS goles_totales
FROM Jugador j 
JOIN Estadistica s ON j.player_id = s.player_id
GROUP BY j.player_id;



-- 4. Árbitros por partido
CREATE VIEW ArbitrosPartido AS
SELECT p.match_id, a.nombre, pa.rol
FROM Partido_Arbitro pa
JOIN Arbitro a ON pa.referee_id = a.referee_id
JOIN Partido p ON pa.match_id = p.match_id;

CREATE VIEW JugadoresEquipo AS
SELECT j.player_id, j.nombre, e.nombre AS equipo
FROM Jugador j JOIN Equipo e ON j.team_id = e.team_id;

CREATE OR REPLACE VIEW view_partidos_con_estadio AS
SELECT
    par.match_id,
    e.nombre AS nombre_estadio,
    par.fecha,
    par.home_team_id,
    par.away_team_id
    
FROM Partido par
JOIN Estadio e ON par.match_id = e.stadium_id;

-- 1) Vista: Jugadores junto con su posición (o posiciones concatenadas)
CREATE OR REPLACE VIEW view_jugadores_con_posicion AS
SELECT 
    j.player_id,
    j.nombre AS nombre_jugador,
    STRING_AGG(p.nombre, ', ') AS posiciones
FROM Jugador j
JOIN Jugador_Posicion jp ON j.player_id = jp.player_id
JOIN Posicion p ON jp.position_id = p.position_id
GROUP BY j.player_id, j.nombre;