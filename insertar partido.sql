DO $$
DECLARE
    jornada INT;
    partido_num INT;
    equipo_local INT;
    equipo_visitante INT;
    fecha_base DATE := '2024-08-01';
    estadio_id INT;
    resultado TEXT;
    equipos_restantes INT[];
    equipos_disponibles INT[];
    emparejamiento INT[];
BEGIN
    -- Generar calendario para 38 jornadas
    FOR jornada IN 1..38 LOOP
        -- Inicializar array de equipos disponibles (1-20)
        equipos_disponibles := ARRAY[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];
        
        -- Generar 10 partidos por jornada
        FOR partido_num IN 1..10 LOOP
            -- Seleccionar aleatoriamente equipos que no se hayan emparejado aún
            IF array_length(equipos_disponibles, 1) >= 2 THEN
                -- Seleccionar equipo local aleatorio
                equipo_local := equipos_disponibles[1 + floor(random() * array_length(equipos_disponibles, 1))::INT];
                
                -- Eliminar el equipo local de los disponibles
                equipos_disponibles := array_remove(equipos_disponibles, equipo_local);
                
                -- Seleccionar equipo visitante aleatorio entre los restantes
                equipo_visitante := equipos_disponibles[1 + floor(random() * array_length(equipos_disponibles, 1))::INT];
                
                -- Eliminar el equipo visitante de los disponibles
                equipos_disponibles := array_remove(equipos_disponibles, equipo_visitante);
                
                -- Asignar estadio (equipo_local % 10 + 1 para tener solo 10 estadios)
                estadio_id := (equipo_local % 10) + 1;
                
                -- Generar resultado solo para las primeras 19 jornadas (primera vuelta)
                IF jornada <= 19 THEN
                    resultado := 
                        CASE 
                            WHEN (jornada + equipo_local) % 7 = 0 THEN NULL -- Partido pendiente (7% sin resultado)
                            ELSE (1 + (jornada + equipo_local) % 3)::TEXT || '-' || (1 + (jornada + equipo_visitante) % 2)::TEXT
                        END;
                ELSE
                    -- Para la segunda vuelta, generar resultados solo si la jornada actual -19 es <= 19
                    IF (jornada - 19) <= 19 THEN
                        resultado := 
                            CASE 
                                WHEN (jornada + equipo_visitante) % 7 = 0 THEN NULL -- Partido pendiente (7% sin resultado)
                                ELSE (1 + (jornada + equipo_visitante) % 3)::TEXT || '-' || (1 + (jornada + equipo_local) % 2)::TEXT
                            END;
                    ELSE
                        resultado := NULL; -- Partidos futuros sin resultado
                    END IF;
                END IF;
                
                -- Insertar partido de ida o vuelta
                IF jornada <= 19 THEN
                    -- Primera vuelta (equipo_local de local)
                    INSERT INTO Partido (fecha, home_team_id, away_team_id, stadium_id, resultado)
                    VALUES (
                        fecha_base + (jornada * 7)::INTEGER,
                        equipo_local,
                        equipo_visitante,
                        estadio_id,
                        resultado
                    );
                ELSE
                    -- Segunda vuelta (equipo_visitante de local, invirtiendo los equipos)
                    INSERT INTO Partido (fecha, home_team_id, away_team_id, stadium_id, resultado)
                    VALUES (
                        fecha_base + (jornada * 7)::INTEGER,
                        equipo_visitante,
                        equipo_local,
                        (equipo_visitante % 10) + 1, -- Estadio del nuevo local
                        resultado
                    );
                END IF;
            END IF;
        END LOOP;
    END LOOP;
END $$;