CREATE TABLE Equipo (
    team_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    ciudad VARCHAR(50)
);

CREATE TABLE Estadio (
    stadium_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    calle VARCHAR(100),
    ciudad VARCHAR(50),
    capacidad INTEGER
);

-- 2. Tablas dependientes (requieren tablas anteriores)
CREATE TABLE Partido (  -- ¡CREACIÓN FALTANTE!
    match_id SERIAL PRIMARY KEY,
    fecha TIMESTAMP NOT NULL,
    home_team_id INTEGER NOT NULL REFERENCES Equipo(team_id),
    away_team_id INTEGER NOT NULL REFERENCES Equipo(team_id),
    stadium_id INTEGER NOT NULL REFERENCES Estadio(stadium_id),
    resultado VARCHAR(10)
);

CREATE TABLE Jugador (
    player_id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    fecha_nacimiento DATE,
    team_id INTEGER NOT NULL REFERENCES Equipo(team_id)
);

-- 3. Tablas de relaciones N:M
CREATE TABLE Jugador_Partido (
    player_id INTEGER REFERENCES Jugador(player_id),
    match_id INTEGER REFERENCES Partido(match_id),
    minutos_jugados INTEGER NOT NULL,
    PRIMARY KEY (player_id, match_id)
);

-- 4. Tablas especializadas
CREATE TABLE Administrador (
    user_id INTEGER PRIMARY KEY REFERENCES Usuario(user_id),
    nivel_acceso INTEGER DEFAULT 1
);

CREATE TABLE Entrenador (
    user_id INTEGER PRIMARY KEY REFERENCES Usuario(user_id),
     licencia VARCHAR(50)
);

-- 5. Actualizar Equipo con FKs faltantes
ALTER TABLE Equipo
ADD COLUMN admin_id INTEGER REFERENCES Administrador(user_id),
ADD COLUMN coach_id INTEGER REFERENCES Entrenador(user_id);


-- Tablas adicionales del modelo
CREATE TABLE Posicion (
    position_id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE Jugador_Posicion (
    player_id INTEGER REFERENCES Jugador(player_id),
    position_id INTEGER REFERENCES Posicion(position_id),
    PRIMARY KEY (player_id, position_id)
);

CREATE TABLE Arbitro (
    referee_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    experiencia INTEGER DEFAULT 0
);

CREATE TABLE Partido_Arbitro (
    match_id INTEGER REFERENCES Partido(match_id),
    referee_id INTEGER REFERENCES Arbitro(referee_id),
    rol VARCHAR(50) NOT NULL,
    PRIMARY KEY (match_id, referee_id)
);

CREATE TABLE Estadistica (
    stat_id SERIAL PRIMARY KEY,
    tipo VARCHAR(50) NOT NULL,
    match_id INTEGER NOT NULL REFERENCES Partido(match_id),
    player_id INTEGER NOT NULL REFERENCES Jugador(player_id),
    goles INTEGER DEFAULT 0,
    asistencias INTEGER DEFAULT 0
);
CREATE TABLE Usuario (
    user_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    password VARCHAR(255) NOT NULL,
    tipo VARCHAR(20) CHECK (tipo IN ('admin', 'coach')),
    supervisor_id INTEGER REFERENCES Usuario(user_id),
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP 
);
