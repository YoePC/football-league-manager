import psycopg2
from psycopg2.extras import RealDictCursor
from flask import Flask, render_template, request, redirect, url_for, flash, session, jsonify
from datetime import datetime
from werkzeug.security import generate_password_hash, check_password_hash
import functools

app = Flask(__name__)
app.secret_key = "SECRET_KEY_SEGURA_AQUI"

# Configuración de la conexión a PostgreSQL
DB_CONFIG = {
    "dbname": "Liga_BD",
    "user": "postgres",
    "password": "12345678",
    "host": "localhost",
    "port": 5432
}

def get_db_connection():
    conn = psycopg2.connect(
        dbname=DB_CONFIG["dbname"],
        user=DB_CONFIG["user"],
        password=DB_CONFIG["password"],
        host=DB_CONFIG["host"],
        port=DB_CONFIG["port"],
        cursor_factory=RealDictCursor
    )
    return conn

# Decorador para rutas que requieren login
def login_required(role=None):
    def decorator(f):
        @functools.wraps(f)
        def decorated_function(*args, **kwargs):
            if 'user_id' not in session:
                flash('Por favor inicie sesión para acceder a esta página.', 'danger')
                return redirect(url_for('login'))
            
            if role and session.get('user_type') != role:
                flash('No tiene permisos para acceder a esta página.', 'danger')
                return redirect(url_for('index'))
            
            return f(*args, **kwargs)
        return decorated_function
    return decorator

# ======== Rutas de Autenticación ========
@app.route("/login", methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email = request.form.get('email')
        password = request.form.get('password')
        
        conn = get_db_connection()
        cur = conn.cursor()
        
        try:
            cur.execute("SELECT * FROM Usuario WHERE email = %s", (email,))
            user = cur.fetchone()
            
            if user and check_password_hash(user['password'], password):
                session['user_id'] = user['user_id']
                session['user_name'] = user['nombre']
                session['user_type'] = user['tipo']
                flash('Inicio de sesión exitoso!', 'success')
                return redirect(url_for('index'))
            else:
                flash('Email o contraseña incorrectos', 'danger')
        except Exception as e:
            flash(f'Error al iniciar sesión: {str(e)}', 'danger')
        finally:
            cur.close()
            conn.close()
    
    return render_template('login.html')

@app.route("/register", methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        nombre = request.form.get('nombre')
        email = request.form.get('email')
        password = request.form.get('password')
        user_type = request.form.get('tipo')
        
        if not (nombre and email and password and user_type):
            flash('Todos los campos son obligatorios', 'danger')
            return redirect(url_for('register'))
        
        hashed_password = generate_password_hash(password)
        
        conn = get_db_connection()
        cur = conn.cursor()
        
        try:
            cur.execute(
                "INSERT INTO Usuario (nombre, email, password, tipo) VALUES (%s, %s, %s, %s) RETURNING user_id",
                (nombre, email, hashed_password, user_type)
            )
            user_id = cur.fetchone()['user_id']
            
            # Crear registro en la tabla específica (Administrador o Entrenador)
            if user_type == 'admin':
                cur.execute("INSERT INTO Administrador (user_id) VALUES (%s)", (user_id,))
            elif user_type == 'coach':
                cur.execute("INSERT INTO Entrenador (user_id) VALUES (%s)", (user_id,))
            
            conn.commit()
            flash('Registro exitoso! Por favor inicie sesión.', 'success')
            return redirect(url_for('login'))
        except psycopg2.IntegrityError:
            flash('El email ya está registrado', 'danger')
        except Exception as e:
            conn.rollback()
            flash(f'Error al registrar: {str(e)}', 'danger')
        finally:
            cur.close()
            conn.close()
    
    return render_template('register.html')

@app.route("/logout")
def logout():
    session.clear()
    flash('Ha cerrado sesión correctamente', 'info')
    return redirect(url_for('index'))

# ======== Ruta principal ========
@app.route("/")
def index():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    conn = get_db_connection()
    cur = conn.cursor()

    # Datos básicos para el dashboard
    cur.execute("SELECT COUNT(*) AS total FROM Equipo;")
    teams_count = cur.fetchone()['total']

    cur.execute("SELECT COUNT(*) AS total FROM Jugador;")
    players_count = cur.fetchone()['total']

    cur.execute("SELECT COUNT(*) AS total FROM Partido;")
    matches_count = cur.fetchone()['total']

    # Obtener partidos próximos
    cur.execute("""
        SELECT p.match_id, p.fecha, p.resultado, 
               e.nombre AS estadio, e.calle, e.ciudad,
               p.home_team_id, p.away_team_id
        FROM Partido p
        JOIN Estadio e ON p.stadium_id = e.stadium_id
        WHERE p.fecha >= CURRENT_DATE
        ORDER BY p.fecha
        LIMIT 5;
    """)
    upcoming_matches = cur.fetchall()

    # Obtener jugadores con más goles (Top 3)
    cur.execute("""
        SELECT j.player_id, j.nombre, j.apellido, SUM(s.goles) AS total_goles
        FROM Jugador j 
        JOIN Estadistica s ON j.player_id = s.player_id
        GROUP BY j.player_id
        ORDER BY total_goles DESC
        LIMIT 3;
    """)
    top_scorers = cur.fetchall()

    # Obtener estadios con más partidos
    cur.execute("""
        SELECT e.nombre AS estadio, e.capacidad, COUNT(p.match_id) AS partidos_jugados
        FROM Estadio e
        LEFT JOIN Partido p ON e.stadium_id = p.stadium_id
        GROUP BY e.nombre, e.capacidad
        ORDER BY partidos_jugados DESC
        LIMIT 3;
    """)
    top_stadiums = cur.fetchall()

    cur.close()
    conn.close()

    return render_template(
        "index.html",
        userName=session.get('user_name', 'Invitado'),
        userType=session.get('user_type'),
        teamsCount=teams_count,
        playersCount=players_count,
        matchesCount=matches_count,
        upcoming_matches=upcoming_matches,
        top_scorers=top_scorers,
        top_stadiums=top_stadiums
    )

# ======== CRUD Jugador (para entrenadores) ========
@app.route("/jugadores")
@login_required(role='coach')
def jugadores():
    conn = get_db_connection()
    cur = conn.cursor()

    # Obtener jugadores del equipo del entrenador
    cur.execute("""
        SELECT j.player_id, j.nombre, j.apellido, j.fecha_nacimiento, j.team_id
        FROM Jugador j
        JOIN Equipo e ON j.team_id = e.team_id
        JOIN Entrenador en ON e.coach_id = en.user_id
        WHERE en.user_id = %s
        ORDER BY j.player_id;
    """, (session['user_id'],))
    jugadores = cur.fetchall()

    # Obtener posiciones para el formulario
    cur.execute("SELECT position_id, nombre FROM Posicion ORDER BY nombre;")
    posiciones = cur.fetchall()

    # Obtener equipo del entrenador
    cur.execute("""
        SELECT e.team_id, e.nombre 
        FROM Equipo e
        JOIN Entrenador en ON e.coach_id = en.user_id
        WHERE en.user_id = %s;
    """, (session['user_id'],))
    equipo = cur.fetchone()

    cur.close()
    conn.close()

    return render_template(
        "jugadores.html",
        jugadores=jugadores,
        posiciones=posiciones,
        equipo=equipo
    )

@app.route("/jugador/insert", methods=["POST"])
@login_required(role='coach')
def insertar_jugador():
    nombre   = request.form.get("nombre_jugador")
    apellido = request.form.get("apellido_jugador")
    fecha_nac= request.form.get("fecha_nacimiento")
    team_id  = request.form.get("team_id")

    if not (nombre and apellido and team_id):
        flash("Los campos Nombre, Apellido y Equipo son obligatorios.", "danger")
        return redirect(url_for("jugadores"))

    conn = get_db_connection()
    cur = conn.cursor()
    try:
        sql = """
            INSERT INTO Jugador (nombre, apellido, fecha_nacimiento, team_id)
            VALUES (%s, %s, %s, %s);
        """
        cur.execute(sql, (nombre, apellido, fecha_nac, team_id))
        conn.commit()
        flash("Jugador insertado correctamente.", "success")
    except Exception as e:
        conn.rollback()
        flash(f"Error al insertar jugador: {e}", "danger")
    finally:
        cur.close()
        conn.close()

    return redirect(url_for("index"))

@app.route("/jugador/delete", methods=["POST"])
@login_required(role='coach')
def eliminar_jugador():
    player_id = request.form.get("player_id_delete")
    
    if not player_id:
        flash("Se requiere ID de jugador para eliminar", "danger")
        return redirect(url_for("jugadores"))

    conn = get_db_connection()
    cur = conn.cursor()
    
    try:
        # Primero eliminar las referencias en Jugador_Posicion
        cur.execute("DELETE FROM Jugador_Posicion WHERE player_id = %s", (player_id,))
        
        # Luego eliminar el jugador
        cur.execute("DELETE FROM Jugador WHERE player_id = %s", (player_id,))
        
        conn.commit()
        flash("Jugador eliminado correctamente", "success")
    except Exception as e:
        conn.rollback()
        flash(f"Error al eliminar jugador: {str(e)}", "danger")
    finally:
        cur.close()
        conn.close()
    
    return redirect(url_for("jugadores"))


# ======== CRUD Equipo (para administradores) ========
@app.route("/equipos")
@login_required(role='admin')
def equipos():
    conn = get_db_connection()
    cur = conn.cursor()

    cur.execute("""
        SELECT e.team_id, e.nombre, e.ciudad, 
               u.nombre AS admin_nombre, 
               c.nombre AS coach_nombre
        FROM Equipo e
        LEFT JOIN Usuario u ON e.admin_id = u.user_id
        LEFT JOIN Usuario c ON e.coach_id = c.user_id
        ORDER BY e.team_id;
    """)
    equipos = cur.fetchall()

    # Obtener administradores y entrenadores disponibles para asignar
    cur.execute("SELECT user_id, nombre FROM Usuario WHERE tipo = 'admin';")
    administradores = cur.fetchall()

    cur.execute("SELECT user_id, nombre FROM Usuario WHERE tipo = 'coach' AND user_id NOT IN (SELECT coach_id FROM Equipo WHERE coach_id IS NOT NULL);")
    entrenadores = cur.fetchall()

    # Obtener estadios para el formulario
    cur.execute("SELECT stadium_id, nombre FROM Estadio ORDER BY nombre;")
    estadios = cur.fetchall()

    cur.close()
    conn.close()

    return render_template(
        "equipos.html",
        equipos=equipos,
        administradores=administradores,
        entrenadores=entrenadores,
        estadios=estadios
    )
    
@app.route("/equipo/insert", methods=["POST"])
@login_required(role='admin')
def insertar_equipo():
    nombre = request.form.get("nombre_equipo")
    ciudad = request.form.get("ciudad_equipo")

    if not nombre:
        flash("El nombre del equipo es obligatorio.", "danger")
        return redirect(url_for("equipos"))

    conn = get_db_connection()
    cur = conn.cursor()
    try:
        cur.execute("INSERT INTO Equipo (nombre, ciudad) VALUES (%s, %s);", 
                   (nombre, ciudad))
        conn.commit()
        flash("Equipo insertado correctamente.", "success")
    except Exception as e:
        conn.rollback()
        flash(f"Error al insertar equipo: {e}", "danger")
    finally:
        cur.close()
        conn.close()

    return redirect(url_for("equipos"))

@app.route("/equipo/delete", methods=["POST"])
@login_required(role='admin')
def eliminar_equipo():
    team_id = request.form.get("team_id_delete")
    if not team_id:
        flash("El ID del equipo es obligatorio para eliminar.", "warning")
        return redirect(url_for("equipos"))

    conn = get_db_connection()
    cur = conn.cursor()
    try:
        # Primero eliminar jugadores asociados al equipo
        cur.execute("DELETE FROM Jugador WHERE team_id = %s;", (team_id,))
        # Luego eliminar el equipo
        cur.execute("DELETE FROM Equipo WHERE team_id = %s;", (team_id,))
        
        if cur.rowcount == 0:
            flash("No se encontró ningún equipo con ese ID.", "warning")
        else:
            conn.commit()
            flash("Equipo eliminado correctamente.", "success")
    except Exception as e:
        conn.rollback()
        flash(f"Error al eliminar equipo: {e}", "danger")
    finally:
        cur.close()
        conn.close()

    return redirect(url_for("equipos"))

@app.route("/equipo/update", methods=["POST"])
@login_required(role='admin')
def actualizar_equipo():
    team_id = request.form.get("team_id_update")
    nombre = request.form.get("nombre_equipo_update")
    ciudad = request.form.get("ciudad_equipo_update")

    if not (team_id and nombre):
        flash("ID y Nombre del equipo son obligatorios para actualizar.", "warning")
        return redirect(url_for("equipos"))

    conn = get_db_connection()
    cur = conn.cursor()
    try:
        sql = """
            UPDATE Equipo
            SET nombre = %s,
                ciudad = %s
            WHERE team_id = %s;
        """
        cur.execute(sql, (nombre, ciudad, team_id))
        if cur.rowcount == 0:
            flash("No se encontró el equipo con ese ID.", "warning")
        else:
            conn.commit()
            flash("Equipo actualizado correctamente.", "success")
    except Exception as e:
        conn.rollback()
        flash(f"Error al actualizar equipo: {e}", "danger")
    finally:
        cur.close()
        conn.close()

    return redirect(url_for("equipos"))

# ======== CRUD Partidos (para administradores) ========
@app.route("/partidos")
@login_required(role='admin')
def partidos():
    conn = get_db_connection()
    cur = conn.cursor()

    cur.execute("""
        SELECT p.match_id, p.fecha, p.resultado, 
               e.nombre AS estadio, 
               ht.nombre AS equipo_local, 
               at.nombre AS equipo_visitante
        FROM Partido p
        JOIN Estadio e ON p.stadium_id = e.stadium_id
        JOIN Equipo ht ON p.home_team_id = ht.team_id
        JOIN Equipo at ON p.away_team_id = at.team_id
        ORDER BY p.fecha DESC;
    """)
    partidos = cur.fetchall()

    # Obtener equipos y estadios para el formulario
    cur.execute("SELECT team_id, nombre FROM Equipo ORDER BY nombre;")
    equipos = cur.fetchall()

    cur.execute("SELECT stadium_id, nombre FROM Estadio ORDER BY nombre;")
    estadios = cur.fetchall()

    # Obtener árbitros para asignar
    cur.execute("SELECT referee_id, nombre FROM Arbitro ORDER BY nombre;")
    arbitros = cur.fetchall()

    cur.close()
    conn.close()

    return render_template(
        "partidos.html",
        partidos=partidos,
        equipos=equipos,
        estadios=estadios,
        arbitros=arbitros
    )
    
@app.route("/partido/insert", methods=["POST"])
@login_required(role='admin')
def insertar_partido():
    fecha = request.form.get("fecha")
    home_team_id = request.form.get("home_team_id")
    away_team_id = request.form.get("away_team_id")
    stadium_id = request.form.get("stadium_id")

    if not all([fecha, home_team_id, away_team_id, stadium_id]):
        flash("Todos los campos son obligatorios", "danger")
        return redirect(url_for("partidos"))

    if home_team_id == away_team_id:
        flash("Un equipo no puede jugar contra sí mismo", "danger")
        return redirect(url_for("partidos"))

    try:
        # Convertir la fecha al formato correcto para PostgreSQL
        fecha_dt = datetime.strptime(fecha, '%Y-%m-%dT%H:%M')
        
        conn = get_db_connection()
        cur = conn.cursor()
        
        cur.execute("""
            INSERT INTO Partido (fecha, home_team_id, away_team_id, stadium_id)
            VALUES (%s, %s, %s, %s)
        """, (fecha_dt, home_team_id, away_team_id, stadium_id))
        
        conn.commit()
        flash("Partido programado correctamente", "success")
    except ValueError:
        flash("Formato de fecha inválido", "danger")
    except Exception as e:
        conn.rollback()
        flash(f"Error al programar partido: {str(e)}", "danger")
    finally:
        if 'conn' in locals():
            cur.close()
            conn.close()

    return redirect(url_for("partidos"))

@app.route("/partido/edit/<int:match_id>", methods=["GET", "POST"])
@login_required(role='admin')
def editar_partido(match_id):
    conn = get_db_connection()
    cur = conn.cursor()

    if request.method == "POST":
        # Procesar actualización
        fecha = request.form.get("fecha")
        resultado = request.form.get("resultado")
        
        try:
            cur.execute("""
                UPDATE Partido 
                SET fecha = %s, resultado = %s
                WHERE match_id = %s
            """, (fecha, resultado, match_id))
            conn.commit()
            flash("Partido actualizado correctamente", "success")
        except Exception as e:
            conn.rollback()
            flash(f"Error al actualizar partido: {str(e)}", "danger")
        finally:
            cur.close()
            conn.close()
        return redirect(url_for("partidos"))

    # GET - Mostrar formulario de edición
    try:
        cur.execute("""
            SELECT p.*, e.nombre AS estadio, 
                   ht.nombre AS equipo_local, 
                   at.nombre AS equipo_visitante
            FROM Partido p
            JOIN Estadio e ON p.stadium_id = e.stadium_id
            JOIN Equipo ht ON p.home_team_id = ht.team_id
            JOIN Equipo at ON p.away_team_id = at.team_id
            WHERE p.match_id = %s
        """, (match_id,))
        partido = cur.fetchone()

        cur.execute("SELECT team_id, nombre FROM Equipo ORDER BY nombre;")
        equipos = cur.fetchall()

        cur.execute("SELECT stadium_id, nombre FROM Estadio ORDER BY nombre;")
        estadios = cur.fetchall()

        return render_template(
            "editar_partido.html",
            partido=partido,
            equipos=equipos,
            estadios=estadios
        )
    except Exception as e:
        flash(f"Error al cargar partido: {str(e)}", "danger")
        return redirect(url_for("partidos"))
    finally:
        cur.close()
        conn.close()

@app.route("/partido/delete/<int:match_id>", methods=["POST"])
@login_required(role='admin')
def eliminar_partido(match_id):
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute("DELETE FROM Partido WHERE match_id = %s", (match_id,))
        conn.commit()
        flash("Partido eliminado correctamente", "success")
    except Exception as e:
        conn.rollback()
        flash(f"Error al eliminar partido: {str(e)}", "danger")
    finally:
        cur.close()
        conn.close()
    return redirect(url_for("partidos"))

# ======== Vistas ========
@app.route("/vistas")
@login_required()
def vistas():
    conn = get_db_connection()
    cur = conn.cursor()

    # EstadisticasJugador
    cur.execute("SELECT * FROM EstadisticasJugador ORDER BY goles_totales DESC LIMIT 10;")
    estadisticas_jugador = cur.fetchall()

    # ArbitrosPartido
    cur.execute("SELECT * FROM ArbitrosPartido ORDER BY match_id LIMIT 10;")
    arbitros_partido = cur.fetchall()

    # JugadoresEquipo
    cur.execute("SELECT * FROM JugadoresEquipo ORDER BY equipo, nombre LIMIT 10;")
    jugadores_equipo = cur.fetchall()

    # view_partidos_con_estadio
    cur.execute("SELECT * FROM view_partidos_con_estadio ORDER BY fecha DESC LIMIT 10;")
    partidos_estadio = cur.fetchall()

    # view_jugadores_con_posicion
    cur.execute("SELECT * FROM view_jugadores_con_posicion ORDER BY nombre_jugador LIMIT 10;")
    jugadores_posicion = cur.fetchall()

    cur.close()
    conn.close()

    return render_template(
        "vistas.html",
        estadisticas_jugador=estadisticas_jugador,
        arbitros_partido=arbitros_partido,
        jugadores_equipo=jugadores_equipo,
        partidos_estadio=partidos_estadio,
        jugadores_posicion=jugadores_posicion
    )

# ======== Funciones ========
@app.route("/funciones")
@login_required()
def funciones():
    conn = get_db_connection()
    cur = conn.cursor()

    # Obtener jugadores para probar TotalGolesJugador
    cur.execute("SELECT player_id, nombre, apellido FROM Jugador ORDER BY nombre LIMIT 5;")
    jugadores = cur.fetchall()

    # Obtener equipos para probar PartidosEquipo
    cur.execute("SELECT team_id, nombre FROM Equipo ORDER BY nombre LIMIT 5;")
    equipos = cur.fetchall()

    # Obtener posiciones para probar JugadoresPosicion
    cur.execute("SELECT nombre FROM Posicion ORDER BY nombre;")
    posiciones = cur.fetchall()

    cur.close()
    conn.close()

    return render_template(
        "funciones.html",
        jugadores=jugadores,
        equipos=equipos,
        posiciones=posiciones
    )

@app.route("/funcion/total_goles/<int:player_id>")
@login_required()
def total_goles_jugador(player_id):
    conn = get_db_connection()
    cur = conn.cursor()

    try:
        cur.execute("SELECT TotalGolesJugador(%s) AS total_goles;", (player_id,))
        result = cur.fetchone()
        cur.execute("SELECT nombre, apellido FROM Jugador WHERE player_id = %s;", (player_id,))
        jugador = cur.fetchone()
        
        return jsonify({
            'jugador': f"{jugador['nombre']} {jugador['apellido']}",
            'total_goles': result['total_goles']
        })
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cur.close()
        conn.close()
        
@app.route("/funcion/partidos_equipo/<int:team_id>")
@login_required()
def partidos_equipo(team_id):
    conn = get_db_connection()
    cur = conn.cursor()

    try:
        # Ejecutar la función PartidosEquipo
        cur.execute("SELECT * FROM PartidosEquipo(%s) ORDER BY fecha DESC;", (team_id,))
        partidos = cur.fetchall()
        
        # Obtener nombre del equipo para mostrar
        cur.execute("SELECT nombre FROM Equipo WHERE team_id = %s;", (team_id,))
        equipo = cur.fetchone()
        
        if not equipo:
            return jsonify({'error': 'Equipo no encontrado'}), 404
        
        return jsonify({
            'equipo': equipo['nombre'],
            'partidos': partidos
        })
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cur.close()
        conn.close()

@app.route("/funcion/jugadores_posicion/<string:posicion>")
@login_required()
def jugadores_posicion(posicion):
    conn = get_db_connection()
    cur = conn.cursor()

    try:
        # Ejecutar la función JugadoresPosicion
        cur.execute("SELECT * FROM JugadoresPosicion(%s) ORDER BY nombre;", (posicion,))
        jugadores = cur.fetchall()
        
        if not jugadores:
            return jsonify({'error': 'No se encontraron jugadores para esta posición'}), 404
        
        return jsonify({
            'posicion': posicion,
            'jugadores': jugadores
        })
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cur.close()
        conn.close()

@app.route("/funcion/top_arbitros")
@login_required()
def top_arbitros():
    conn = get_db_connection()
    cur = conn.cursor()

    try:
        # Ejecutar la función TopArbitros
        cur.execute("SELECT * FROM TopArbitros() ORDER BY partidos DESC LIMIT 5;")
        arbitros = cur.fetchall()
        
        return jsonify({
            'arbitros': arbitros
        })
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cur.close()
        conn.close()

# Implementar rutas similares para las otras funciones...

# ======== Consultas ========

# Implementar rutas para las consultas...
@app.route("/consultas")
@login_required()
def consultas():
    conn = get_db_connection()
    cur = conn.cursor()
    
    # Datos necesarios para los selects de las consultas
    cur.execute("SELECT team_id, nombre FROM Equipo ORDER BY nombre LIMIT 5;")
    equipos = cur.fetchall()
    
    cur.execute("SELECT DISTINCT resultado FROM Partido WHERE resultado IS NOT NULL LIMIT 5;")
    resultados = cur.fetchall()
    
    cur.execute("SELECT ciudad FROM Equipo WHERE ciudad IS NOT NULL GROUP BY ciudad LIMIT 5;")
    ciudades = cur.fetchall()
    
    cur.close()
    conn.close()
    
    return render_template(
        "consultas.html",
        equipos=equipos,
        resultados=resultados,
        ciudades=ciudades
    )
    

# Consulta 1: Top 3 jugadores con más goles
@app.route("/consulta/top_jugadores_goles")
@login_required()
def consulta_top_jugadores_goles():
    conn = get_db_connection()
    cur = conn.cursor()
    
    cur.execute("""
        SELECT j.nombre, SUM(s.goles) AS total_goles
        FROM Jugador j JOIN Estadistica s ON j.player_id = s.player_id
        GROUP BY j.player_id
        ORDER BY total_goles DESC LIMIT 3;
    """)
    resultado = cur.fetchall()
    
    cur.close()
    conn.close()
    
    return jsonify({'resultado': resultado})

# Consulta 2: Partidos de un equipo con nombre de estadio
@app.route("/consulta/partidos_equipo_estadio/<int:team_id>")
@login_required()
def consulta_partidos_equipo_estadio(team_id):
    conn = get_db_connection()
    cur = conn.cursor()
    
    try:
        cur.execute("""
            SELECT p.match_id, e.nombre AS estadio
            FROM Partido p JOIN Estadio e ON p.stadium_id = e.stadium_id
            WHERE p.home_team_id = %s OR p.away_team_id = %s;
        """, (team_id, team_id))
        resultado = cur.fetchall()
        
        # Obtener nombre del equipo para el resultado
        cur.execute("SELECT nombre FROM Equipo WHERE team_id = %s;", (team_id,))
        equipo = cur.fetchone()
        
        return jsonify({
            'equipo': equipo['nombre'] if equipo else f"Equipo ID: {team_id}",
            'resultado': resultado
        })
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cur.close()
        conn.close()

# Consulta 3: Jugadores que han marcado goles en partidos con resultado '3-0'
@app.route("/consulta/jugadores_goles_resultado/<string:resultado>")
@login_required()
def consulta_jugadores_goles_resultado(resultado):
    conn = get_db_connection()
    cur = conn.cursor()
    
    try:
        cur.execute("""
            SELECT nombre FROM Jugador 
            WHERE player_id IN (
                SELECT player_id FROM Estadistica 
                WHERE goles > 0 AND match_id IN (
                    SELECT match_id FROM Partido WHERE resultado = %s
                )
            );
        """, (resultado,))
        resultado = cur.fetchall()
        
        return jsonify({
            'resultado_busqueda': resultado,
            'parametro': resultado
        })
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cur.close()
        conn.close()

# Consulta 4: Equipos con más goles en casa
@app.route("/consulta/equipos_goles_casa")
@login_required()
def consulta_equipos_goles_casa():
    conn = get_db_connection()
    cur = conn.cursor()
    
    cur.execute("""
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
    """)
    resultado = cur.fetchall()
    
    cur.close()
    conn.close()
    
    return jsonify({'resultado': resultado})

# Consulta 5: Jugadores con más asistencias por equipo
@app.route("/consulta/jugadores_asistencias")
@login_required()
def consulta_jugadores_asistencias():
    conn = get_db_connection()
    cur = conn.cursor()
    
    cur.execute("""
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
    """)
    resultado = cur.fetchall()
    
    cur.close()
    conn.close()
    
    return jsonify({'resultado': resultado})

# Consulta 6: Promedio de goles por temporada
@app.route("/consulta/promedio_goles_temporada")
@login_required()
def consulta_promedio_goles_temporada():
    conn = get_db_connection()
    cur = conn.cursor()
    
    cur.execute("""
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
    """)
    resultado = cur.fetchall()
    
    cur.close()
    conn.close()
    
    return jsonify({'resultado': resultado})

# Consulta 7: Estadios y cantidad de partidos jugados
@app.route("/consulta/estadios_partidos")
@login_required()
def consulta_estadios_partidos():
    conn = get_db_connection()
    cur = conn.cursor()
    
    cur.execute("""
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
    """)
    resultado = cur.fetchall()
    
    cur.close()
    conn.close()
    
    return jsonify({'resultado': resultado})

# Consulta 8: Jugadores de una ciudad específica
@app.route("/consulta/jugadores_ciudad/<string:ciudad>")
@login_required()
def consulta_jugadores_ciudad(ciudad):
    conn = get_db_connection()
    cur = conn.cursor()
    
    try:
        cur.execute("""
            SELECT 
                j.nombre AS jugador
            FROM 
                Jugador j
            JOIN 
                Equipo e ON j.team_id = e.team_id
            WHERE 
                e.ciudad = %s
            GROUP BY 
                j.player_id, j.nombre
            HAVING 
                COUNT(DISTINCT e.team_id) = (SELECT COUNT(*) FROM Equipo WHERE ciudad = %s);
        """, (ciudad, ciudad))
        resultado = cur.fetchall()
        
        return jsonify({
            'ciudad': ciudad,
            'resultado': resultado
        })
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cur.close()
        conn.close()

if __name__ == "__main__":
    app.run(debug=True, port=5000)