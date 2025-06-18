
CREATE FUNCTION TotalGolesJugador(player_id INT) RETURNS INT AS $$
SELECT COALESCE(SUM(goles), 0) 
FROM Estadistica 
WHERE player_id = $1;
$$ LANGUAGE SQL;

-- 2. Partidos por equipo
CREATE FUNCTION PartidosEquipo(team_id INT) RETURNS TABLE(match_id INT, fecha DATE) AS $$
SELECT match_id, fecha 
FROM Partido 
WHERE home_team_id = $1 OR away_team_id = $1;
$$ LANGUAGE SQL;

-- 3. Jugadores por posición
CREATE FUNCTION JugadoresPosicion(posicion VARCHAR) RETURNS TABLE(nombre VARCHAR, equipo VARCHAR) AS $$
SELECT j.nombre, e.nombre 
FROM Jugador j
JOIN Jugador_Posicion jp ON j.player_id = jp.player_id
JOIN Posicion p ON jp.position_id = p.position_id
JOIN Equipo e ON j.team_id = e.team_id
WHERE p.nombre = $1;
$$ LANGUAGE SQL;

-- 4. Árbitros con más partidos
CREATE FUNCTION TopArbitros() RETURNS TABLE(nombre VARCHAR, partidos BIGINT) AS $$
SELECT a.nombre, COUNT(*) 
FROM Arbitro a
JOIN Partido_Arbitro pa ON a.referee_id = pa.referee_id
GROUP BY a.referee_id 

$$ LANGUAGE SQL;