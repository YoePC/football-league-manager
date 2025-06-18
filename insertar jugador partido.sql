DO $$
DECLARE
    partido RECORD;
    jugadores_equipo_local INT[];
    jugadores_equipo_visitante INT[];
    jugador_id INT;
    minutos_jugados INT;
    num_suplentes_local INT;
    num_suplentes_visitante INT;
BEGIN
    FOR partido IN SELECT match_id, home_team_id, away_team_id FROM Partido WHERE resultado IS NOT NULL LOOP
        -- Obtener jugadores del equipo local (asegurando al menos 11 jugadores)
        SELECT array_agg(player_id) INTO jugadores_equipo_local 
        FROM Jugador 
        WHERE team_id = partido.home_team_id;
        
        -- Obtener jugadores del equipo visitante (asegurando al menos 11 jugadores)
        SELECT array_agg(player_id) INTO jugadores_equipo_visitante 
        FROM Jugador 
        WHERE team_id = partido.away_team_id;
        
        -- Verificar que hay suficientes jugadores
        IF array_length(jugadores_equipo_local, 1) < 11 OR array_length(jugadores_equipo_visitante, 1) < 11 THEN
            RAISE NOTICE 'No hay suficientes jugadores para el partido %. Equipo local: %, visitante: %', 
                         partido.match_id, 
                         array_length(jugadores_equipo_local, 1), 
                         array_length(jugadores_equipo_visitante, 1);
            CONTINUE;
        END IF;
        
        -- Determinar número de suplentes que jugarán (1-4)
        num_suplentes_local := 1 + (partido.match_id % 4);
        num_suplentes_visitante := 1 + ((partido.match_id + 2) % 4);
        
        -- Insertar jugadores locales (11 titulares)
        FOR i IN 1..11 LOOP
            INSERT INTO Jugador_Partido (player_id, match_id, minutos_jugados)
            VALUES (jugadores_equipo_local[i], partido.match_id, 90);
        END LOOP;
        
        -- Insertar suplentes locales (si existen)
        FOR i IN 12..LEAST(11 + num_suplentes_local, array_length(jugadores_equipo_local, 1)) LOOP
            minutos_jugados := 15 + (partido.match_id % 60); -- Entre 15-75 minutos
            INSERT INTO Jugador_Partido (player_id, match_id, minutos_jugados)
            VALUES (jugadores_equipo_local[i], partido.match_id, minutos_jugados);
        END LOOP;
        
        -- Insertar jugadores visitantes (11 titulares)
        FOR i IN 1..11 LOOP
            INSERT INTO Jugador_Partido (player_id, match_id, minutos_jugados)
            VALUES (jugadores_equipo_visitante[i], partido.match_id, 90);
        END LOOP;
        
        -- Insertar suplentes visitantes (si existen)
        FOR i IN 12..LEAST(11 + num_suplentes_visitante, array_length(jugadores_equipo_visitante, 1)) LOOP
            minutos_jugados := 10 + (partido.match_id % 65); -- Entre 10-75 minutos
            INSERT INTO Jugador_Partido (player_id, match_id, minutos_jugados)
            VALUES (jugadores_equipo_visitante[i], partido.match_id, minutos_jugados);
        END LOOP;
    END LOOP;
END $$;