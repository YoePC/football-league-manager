INSERT INTO Estadistica (tipo, match_id, player_id, goles, asistencias)
SELECT 
    'Rendimiento',
    p.match_id,
    j.player_id,
    CASE WHEN random() < 0.15 THEN 1 ELSE 0 END, -- 15% de probabilidad de gol
    CASE WHEN random() < 0.1 THEN 1 ELSE 0 END   -- 10% de probabilidad de asistencia
FROM 
    Partido p
JOIN 
    Jugador j ON j.team_id = p.home_team_id OR j.team_id = p.away_team_id
WHERE 
    p.resultado IS NOT NULL
    AND random() < 0.7; -- Solo 70% de los jugadores participan

DO $$
DECLARE
    partido_record RECORD;
    goles_local INT;
    goles_visitante INT;
BEGIN
    FOR partido_record IN SELECT match_id FROM Partido WHERE resultado IS NOT NULL LOOP
        goles_local := (random() * 3)::INT;
        goles_visitante := (random() * 3)::INT;
        
        -- Asegurar que no sea empate en algunos partidos
        IF random() < 0.7 THEN
            IF goles_local = goles_visitante THEN
                goles_local := goles_local + 1;
            END IF;
        END IF;
        
        UPDATE Partido 
        SET resultado = goles_local || '-' || goles_visitante
        WHERE match_id = partido_record.match_id;
    END LOOP;
END $$;
