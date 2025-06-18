INSERT INTO Usuario (nombre, email, tipo) VALUES
('Admin Principal', 'admin1@liga.com', 'admin'),
('Entrenador Barcelona', 'entrenador1@liga.com', 'coach'),
('Entrenador Madrid', 'entrenador2@liga.com', 'coach'),
('Entrenador Atlético', 'entrenador3@liga.com', 'coach'),
('Entrenador Sevilla', 'entrenador4@liga.com', 'coach'),
('Entrenador Valencia', 'entrenador5@liga.com', 'coach'),
('Admin Secundario', 'admin2@liga.com', 'admin'),
('Entrenador Betis', 'entrenador6@liga.com', 'coach'),
('Entrenador Villarreal', 'entrenador7@liga.com', 'coach'),
('Entrenador Athletic', 'entrenador8@liga.com', 'coach');

DO $$
BEGIN
  FOR i IN 9..500 LOOP
    INSERT INTO Usuario (nombre, email, tipo) VALUES
    (
      'Usuario ' || i,
      'user' || i || '@liga.com',
      CASE WHEN i % 5 = 0 THEN 'admin' ELSE 'coach' END
    );
  END LOOP;
END $$;


-- Administradores (aproximadamente 20% de los usuarios)
INSERT INTO Administrador (user_id)
SELECT user_id FROM Usuario WHERE tipo = 'admin';

-- Entrenadores (el resto)
INSERT INTO Entrenador (user_id)
SELECT user_id FROM Usuario WHERE tipo = 'coach';

INSERT INTO Usuario (user_id, nombre, email, tipo)
VALUES (17, 'NombreEntrenador', 'entrenador17@liga.com', 'coach')
ON CONFLICT (user_id) DO NOTHING;
INSERT INTO Entrenador (user_id)
VALUES (17)
ON CONFLICT (user_id) DO NOTHING;





INSERT INTO Equipo (nombre, ciudad, admin_id, coach_id) VALUES
('FC Barcelona', 'Barcelona', 1, 2),
('Real Madrid', 'Madrid', 7, 3),
('Atlético de Madrid', 'Madrid', 1, 4),
('Sevilla FC', 'Sevilla', 7, 5),
('Valencia CF', 'Valencia', 1, 6),
('Real Betis', 'Sevilla', 7, 8),
('Villarreal CF', 'Villarreal', 1, 9),
('Athletic Club', 'Bilbao', 7, 10),
('Real Sociedad', 'San Sebastián', 1, 11),
('Granada CF', 'Granada', 7, 13),
('Mallorca','Mallorca','52','14'),
('Girona','Canarias','52','15');

TRUNCATE TABLE Equipo RESTART IDENTITY CASCADE;






INSERT INTO Estadio (nombre, calle, ciudad, capacidad) VALUES
('Camp Nou', 'Aristides Maillol', 'Barcelona', 99354),
('Santiago Bernabéu', 'Concha Espina', 'Madrid', 81044),
('Wanda Metropolitano', 'Avenida de Luis Aragonés', 'Madrid', 68456),
('Ramón Sánchez-Pizjuán', 'Avenida Eduardo Dato', 'Sevilla', 43883),
('Mestalla', 'Avenida de Suecia', 'Valencia', 55000),
('Benito Villamarín', 'Avenida de Heliópolis', 'Sevilla', 60721),
('Estadio de la Cerámica', 'Calle Blasco Ibáñez', 'Villarreal', 23500),
('San Mamés', 'Rafael Moreno Pitxitxi', 'Bilbao', 53289),
('Anoeta', 'Paseo de Anoeta', 'San Sebastián', 39500),
('Nuevo Los Cármenes', 'Avenida del Estadio', 'Granada', 19336);







-- Insertar 500 jugadores (50 por equipo para los primeros 10 equipos)
DO $$
DECLARE
  team_id_var INT;
  first_names TEXT[] := ARRAY['Lionel','Yoelvis','Alexis','Julio','Erlin','Armando','Lamine','Alan Brito','Eduardo','Pere','Fermin','Álex', 'Cristiano', 'Andrés','Miguel Marco', 'Xavi','Kiliam', 'Iker', 'Sergio', 'Gerard','Eldo', 'Carles', 'David', 'Raúl', 'Fernando', 'Diego', 'Santiago', 'Hugo', 'Jan', 'Antoine','Hermes', 'Luis', 'Karim', 'Gareth','Emilio Salido', 'Toni'];
  last_names TEXT[] := ARRAY['Messi','Pozo','Pelayo','Cesar','Haland','Paredes','Yamal','Prieto','Camavinga','Gil','Galarga','Cremento', 'Ronaldo', 'Iniesta','Gol', 'Hernández','Mbappé', 'Casillas', 'Ramos', 'Piqué','Mingo', 'Puyol', 'Villa', 'González', 'Torres', 'Costa', 'Cazorla', 'Lloris', 'Oblak', 'Griezmann','Angulo', 'Suárez', 'Benzema', 'Bale','Del Pozo', 'Kroos'];
BEGIN
  FOR team_id_var IN 1..12 LOOP
    FOR i IN 1..50 LOOP
      INSERT INTO Jugador (nombre, apellido, fecha_nacimiento, team_id) VALUES
      (
        first_names[1 + (i % array_length(first_names, 1))],
        last_names[1 + ((i+team_id_var) % array_length(last_names, 1))],
        DATE '1990-01-01' + (i % 6000) * INTERVAL '90 day',
        team_id_var
      );
    END LOOP;
  END LOOP;
END $$;
TRUNCATE TABLE Jugador RESTART IDENTITY CASCADE;



INSERT INTO Posicion (nombre) VALUES
('Portero'),
('Defensa central'),
('Lateral derecho'),
('Lateral izquierdo'),
('Mediocentro defensivo'),
('Mediocentro'),
('Mediocentro ofensivo'),
('Extremo derecho'),
('Extremo izquierdo'),
('Delantero centro');

-- Asignar 1-3 posiciones por jugador
DO $$
DECLARE
  pos_count INT;
BEGIN
  FOR player_id_var IN 1..220 LOOP
    pos_count := 1 + (player_id_var % 3);
    
    FOR i IN 1..pos_count LOOP
      INSERT INTO Jugador_Posicion (player_id, position_id) VALUES
      (
        player_id_var,
        1 + ((player_id_var + i) % 10)
      );
    END LOOP;
  END LOOP;
END $$;





-- Crear partidos para la temporada actual (10 jornadas, 5 partidos por jornada)
DO $$
DECLARE
  jornada INT;
  team1 INT;
  team2 INT;
  stadium INT;
  fecha_partido DATE;
  resultado TEXT;
BEGIN
  FOR jornada IN 1..40 LOOP  -- 40 jornadas para alcanzar 500 partidos
    FOR i IN 1..5 LOOP
      team1 := 1 + ((jornada + i) % 12);
      team2 := 1 + ((jornada + i + 3) % 12);
      WHILE team2 = team1 LOOP
        team2 := 1 + (team2 % ) + 1;
      END LOOP;
      
      stadium := 1 + ((jornada + i) % 40);
      fecha_partido := DATE '2023-08-01' + (jornada * 7) + (i % 5);
      
      resultado := 
        CASE 
          WHEN i % 5 = 0 THEN NULL  -- Partido no jugado aún
          ELSE (1 + (jornada + i) % 5) || '-' || (1 + (jornada + i + 2) % 3)
        END;
      
      INSERT INTO Partido (fecha, home_team_id, away_team_id, stadium_id, resultado) VALUES
      (fecha_partido, team1, team2, stadium, resultado);
    END LOOP;
  END LOOP;
END $$;


DO $$
DECLARE
    jornada INT;
    equipo_local INT;
    equipo_visitante INT;
    fecha_base DATE := '2024-08-01';
    estadio_id INT;
    resultado TEXT;
BEGIN
    FOR jornada IN 1..40 LOOP
        -- Primera mitad de la temporada (ida)
        FOR equipo_local IN 1..12 LOOP
            equipo_visitante := 1 + ((jornada + equipo_local - 2) % 11);
            IF equipo_visitante >= equipo_local THEN
                equipo_visitante := equipo_visitante + 1;
            END IF;
            
            -- Asignar estadio del equipo local
            estadio_id := equipo_local;
            
            -- Solo generar resultado para jornadas pasadas
            IF jornada <= 20 THEN
                resultado := 
                    CASE 
                        WHEN (jornada + equipo_local) % 5 = 0 THEN NULL -- Partido pendiente
                        ELSE (1 + (jornada + equipo_local) % 3)::TEXT || '-' || (1 + (jornada + equipo_visitante) % 2)::TEXT
                    END;
            ELSE
                resultado := NULL; -- Todos los partidos de vuelta inicialmente pendientes
            END IF;
            
            INSERT INTO Partido (fecha, home_team_id, away_team_id, stadium_id, resultado)
            VALUES (
                fecha_base + (jornada * 7)::INTEGER,
                equipo_local,
                equipo_visitante,
                estadio_id,
                resultado
            );
        END LOOP;
        
        -- Segunda mitad de la temporada (vuelta) - mismos partidos pero con equipos invertidos
        IF jornada <= 20 THEN
            FOR equipo_local IN 1..12 LOOP
                equipo_visitante := 1 + ((jornada + equipo_local - 2) % 11);
                IF equipo_visitante >= equipo_local THEN
                    equipo_visitante := equipo_visitante + 1;
                END IF;
                
                -- Invertir localía para la vuelta
                estadio_id := equipo_visitante;
                
                INSERT INTO Partido (fecha, home_team_id, away_team_id, stadium_id, resultado)
                VALUES (
                    fecha_base + ((jornada + 20) * 7)::INTEGER,
                    equipo_visitante,
                    equipo_local,
                    estadio_id,
                    NULL -- Todos los partidos de vuelta inicialmente pendientes
                );
            END LOOP;
        END IF;
    END LOOP;
END $$;


TRUNCATE TABLE Partido RESTART IDENTITY CASCADE;




INSERT INTO Arbitro (nombre, experiencia) VALUES
('Mateu Lahoz', 15),
('Hernández Hernández', 12),
('Del Cerro Grande', 10),
('Gil Manzano', 8),
('Martínez Munuera', 7),
('Sánchez Martínez', 6),
('Estrada Fernández', 9),
('De Burgos Bengoetxea', 11),
('González Fuertes', 5),
('Medié Jiménez', 4);

-- Insertar 490 árbitros adicionales
DO $$
BEGIN
  FOR i IN 11..500 LOOP
    INSERT INTO Arbitro (nombre, experiencia) VALUES
    (
      'Árbitro ' || i,
      1 + (i % 20)
    );
  END LOOP;
END $$;
-- Asignar árbitros a los partidos
DO $$
DECLARE
    partido RECORD;
    arbitro_id INT;
BEGIN
    FOR partido IN SELECT match_id FROM Partido LOOP
        -- Arbitro principal
        arbitro_id := 1 + (partido.match_id % 6); -- 6 árbitros disponibles
        INSERT INTO Partido_Arbitro (match_id, referee_id, rol) VALUES (partido.match_id, arbitro_id, 'Principal');
        
        -- Asistentes
        INSERT INTO Partido_Arbitro (match_id, referee_id, rol) VALUES (partido.match_id, 1 + ((partido.match_id + 1) % 6), 'Asistente 1');
        INSERT INTO Partido_Arbitro (match_id, referee_id, rol) VALUES (partido.match_id, 1 + ((partido.match_id + 2) % 6), 'Asistente 2');
    END LOOP;
END $$;




-- Generar estadísticas para los partidos con resultado
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

-- Actualizar algunos resultados para que sean más realistas
DO $$
DECLARE
    partido RECORD;
    goles_local INT;
    goles_visitante INT;
BEGIN
    FOR partido IN SELECT match_id FROM Partido WHERE resultado IS NOT NULL LOOP
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
        WHERE match_id = partido.match_id;
    END LOOP;
END $$;





DO $$
DECLARE
  match_rec RECORD;
  player_count INT;
  goles INT;
  asistencias INT;
BEGIN
  FOR match_rec IN SELECT match_id, home_team_id, away_team_id FROM Partido WHERE resultado IS NOT NULL LIMIT 400 LOOP
    -- Estadísticas para jugadores locales (10-14 jugadores por partido)
    player_count := 10 + (match_rec.match_id % 5);
    FOR i IN 1..player_count LOOP
      goles := CASE WHEN i % 7 = 0 THEN 1 ELSE 0 END;  -- Aprox 1 de cada 7 jugadores marca gol
      asistencias := CASE WHEN i % 10 = 0 THEN 1 ELSE 0 END;
      
      INSERT INTO Estadistica (tipo, match_id, player_id, goles, asistencias) VALUES
      (
        'Rendimiento',
        match_rec.match_id,
        (SELECT player_id FROM Jugador WHERE team_id = match_rec.home_team_id LIMIT 1 OFFSET (i-1)),
        goles,
        asistencias
      );
    END LOOP;
    
    -- Estadísticas para jugadores visitantes (10-14 jugadores por partido)
    player_count := 10 + ((match_rec.match_id + 2) % 5);
    FOR i IN 1..player_count LOOP
      goles := CASE WHEN i % 8 = 0 THEN 1 ELSE 0 END;
      asistencias := CASE WHEN i % 12 = 0 THEN 1 ELSE 0 END;
      
      INSERT INTO Estadistica (tipo, match_id, player_id, goles, asistencias) VALUES
      (
        'Rendimiento',
        match_rec.match_id,
        (SELECT player_id FROM Jugador WHERE team_id = match_rec.away_team_id LIMIT 1 OFFSET (i-1)),
        goles,
        asistencias
      );
    END LOOP;
  END LOOP;
END $$;

TRUNCATE TABLE Estadistica RESTART IDENTITY CASCADE;



-- Poblar tabla Jugador_Partido (participación de jugadores en partidos)
DO $$
DECLARE
    partido RECORD;
    jugadores_equipo_local INT[];
    jugadores_equipo_visitante INT[];
    jugador_id INT;
    minutos_jugados INT;
BEGIN
    FOR partido IN SELECT match_id, home_team_id, away_team_id FROM Partido WHERE resultado IS NOT NULL LOOP
        -- Obtener jugadores del equipo local (11 titulares + 5 suplentes)
        SELECT array_agg(player_id) INTO jugadores_equipo_local 
        FROM Jugador 
        WHERE team_id = partido.home_team_id 
        LIMIT 16;
        
        -- Obtener jugadores del equipo visitante (11 titulares + 5 suplentes)
        SELECT array_agg(player_id) INTO jugadores_equipo_visitante 
        FROM Jugador 
        WHERE team_id = partido.away_team_id 
        LIMIT 16;
        
        -- Insertar jugadores locales (11 titulares + 3-5 suplentes que juegan)
        FOR i IN 1..11 LOOP
            INSERT INTO Jugador_Partido (player_id, match_id, minutos_jugados)
            VALUES (jugadores_equipo_local[i], partido.match_id, 90);
        END LOOP;
        
        FOR i IN 12..(11 + (1 + (partido.match_id % 4))) LOOP -- 1-4 suplentes
            minutos_jugados := 15 + (partido.match_id % 60); -- Entre 15-75 minutos
            INSERT INTO Jugador_Partido (player_id, match_id, minutos_jugados)
            VALUES (jugadores_equipo_local[i], partido.match_id, minutos_jugados);
        END LOOP;
        
        -- Insertar jugadores visitantes (11 titulares + 3-5 suplentes que juegan)
        FOR i IN 1..11 LOOP
            INSERT INTO Jugador_Partido (player_id, match_id, minutos_jugados)
            VALUES (jugadores_equipo_visitante[i], partido.match_id, 90);
        END LOOP;
        
        FOR i IN 12..(11 + (1 + ((partido.match_id + 2) % 4))) LOOP -- 1-4 suplentes
            minutos_jugados := 10 + (partido.match_id % 65); -- Entre 10-75 minutos
            INSERT INTO Jugador_Partido (player_id, match_id, minutos_jugados)
            VALUES (jugadores_equipo_visitante[i], partido.match_id, minutos_jugados);
        END LOOP;
    END LOOP;
END $$;



