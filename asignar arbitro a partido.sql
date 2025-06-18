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
