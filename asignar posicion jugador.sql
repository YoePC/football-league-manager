DO $$
DECLARE
    equipo_id_var INT;
    player_id_var INT;
    posicion_principal INT;
    posicion_secundaria INT;
    jugadores_por_equipo INT := 11;
    total_equipos INT := 20;
BEGIN
    FOR equipo_id_var IN 1..total_equipos LOOP
        -- Asignar posiciones para cada jugador del equipo actual
        FOR player_offset IN 0..(jugadores_por_equipo-1) LOOP
            player_id_var := (equipo_id_var-1)*jugadores_por_equipo + 1 + player_offset;
            
            -- Asignar posiciones según el número de jugador en el equipo
            CASE 
                -- Portero (1 por equipo)
                WHEN player_offset = 0 THEN
                    posicion_principal := 1; -- Portero
                    INSERT INTO Jugador_Posicion (player_id, position_id) VALUES (player_id_var, posicion_principal);
                
                -- Defensas (4 por equipo)
                WHEN player_offset BETWEEN 1 AND 4 THEN
                    posicion_principal := 2 + (player_offset % 4); -- Defensas (posiciones 2-5)
                    INSERT INTO Jugador_Posicion (player_id, position_id) VALUES (player_id_var, posicion_principal);
                    
                    -- 50% de defensas con posición secundaria
                    IF random() > 0.5 THEN
                        posicion_secundaria := 6 + (player_offset % 3); -- Mediocampista defensivo
                        INSERT INTO Jugador_Posicion (player_id, position_id) VALUES (player_id_var, posicion_secundaria);
                    END IF;
                
                -- Mediocampistas (4 por equipo)
                WHEN player_offset BETWEEN 5 AND 8 THEN
                    posicion_principal := 6 + (player_offset % 4); -- Mediocampistas (posiciones 6-9)
                    INSERT INTO Jugador_Posicion (player_id, position_id) VALUES (player_id_var, posicion_principal);
                    
                    -- 70% de mediocampistas con posición secundaria
                    IF random() > 0.3 THEN
                        CASE 
                            WHEN posicion_principal BETWEEN 6 AND 7 THEN -- Mediocampistas defensivos
                                posicion_secundaria := 2 + (player_offset % 4); -- Defensa
                            ELSE -- Mediocampistas ofensivos
                                posicion_secundaria := 10; -- Delantero
                        END CASE;
                        INSERT INTO Jugador_Posicion (player_id, position_id) VALUES (player_id_var, posicion_secundaria);
                    END IF;
                
                -- Delanteros (2 por equipo)
                WHEN player_offset BETWEEN 9 AND 10 THEN
                    posicion_principal := 10; -- Delantero
                    INSERT INTO Jugador_Posicion (player_id, position_id) VALUES (player_id_var, posicion_principal);
                    
                    -- 30% de delanteros con posición secundaria
                    IF random() > 0.7 THEN
                        posicion_secundaria := 8 + (player_offset % 2); -- Mediocampista ofensivo
                        INSERT INTO Jugador_Posicion (player_id, position_id) VALUES (player_id_var, posicion_secundaria);
                    END IF;
            END CASE;
        END LOOP;
    END LOOP;
END $$;

