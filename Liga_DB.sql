PGDMP                      }           Liga_BD    17.4    17.4 i    ]           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                           false            ^           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                           false            _           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                           false            `           1262    24928    Liga_BD    DATABASE     o   CREATE DATABASE "Liga_BD" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'es-ES';
    DROP DATABASE "Liga_BD";
                     postgres    false            �            1255    25186 $   jugadoresposicion(character varying)    FUNCTION     w  CREATE FUNCTION public.jugadoresposicion(posicion character varying) RETURNS TABLE(nombre character varying, equipo character varying)
    LANGUAGE sql
    AS $_$
SELECT j.nombre, e.nombre 
FROM Jugador j
JOIN Jugador_Posicion jp ON j.player_id = jp.player_id
JOIN Posicion p ON jp.position_id = p.position_id
JOIN Equipo e ON j.team_id = e.team_id
WHERE p.nombre = $1;
$_$;
 D   DROP FUNCTION public.jugadoresposicion(posicion character varying);
       public               postgres    false            �            1255    25185    partidosequipo(integer)    FUNCTION     �   CREATE FUNCTION public.partidosequipo(team_id integer) RETURNS TABLE(match_id integer, fecha date)
    LANGUAGE sql
    AS $_$
SELECT match_id, fecha 
FROM Partido 
WHERE home_team_id = $1 OR away_team_id = $1;
$_$;
 6   DROP FUNCTION public.partidosequipo(team_id integer);
       public               postgres    false            �            1255    25187    toparbitros()    FUNCTION     �   CREATE FUNCTION public.toparbitros() RETURNS TABLE(nombre character varying, partidos bigint)
    LANGUAGE sql
    AS $$
SELECT a.nombre, COUNT(*) 
FROM Arbitro a
JOIN Partido_Arbitro pa ON a.referee_id = pa.referee_id
GROUP BY a.referee_id 

$$;
 $   DROP FUNCTION public.toparbitros();
       public               postgres    false            �            1255    25184    totalgolesjugador(integer)    FUNCTION     �   CREATE FUNCTION public.totalgolesjugador(player_id integer) RETURNS integer
    LANGUAGE sql
    AS $_$
SELECT COALESCE(SUM(goles), 0) 
FROM Estadistica 
WHERE player_id = $1;
$_$;
 ;   DROP FUNCTION public.totalgolesjugador(player_id integer);
       public               postgres    false            �            1259    25135    administrador    TABLE     D   CREATE TABLE public.administrador (
    user_id integer NOT NULL
);
 !   DROP TABLE public.administrador;
       public         heap r       postgres    false            �            1259    25069    arbitro    TABLE     �   CREATE TABLE public.arbitro (
    referee_id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    experiencia integer DEFAULT 0
);
    DROP TABLE public.arbitro;
       public         heap r       postgres    false            �            1259    25068    arbitro_referee_id_seq    SEQUENCE     �   CREATE SEQUENCE public.arbitro_referee_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.arbitro_referee_id_seq;
       public               postgres    false    231            a           0    0    arbitro_referee_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.arbitro_referee_id_seq OWNED BY public.arbitro.referee_id;
          public               postgres    false    230            �            1259    24971    partido    TABLE     �   CREATE TABLE public.partido (
    match_id integer NOT NULL,
    fecha timestamp without time zone NOT NULL,
    home_team_id integer NOT NULL,
    away_team_id integer NOT NULL,
    stadium_id integer NOT NULL,
    resultado character varying(10)
);
    DROP TABLE public.partido;
       public         heap r       postgres    false            �            1259    25076    partido_arbitro    TABLE     �   CREATE TABLE public.partido_arbitro (
    match_id integer NOT NULL,
    referee_id integer NOT NULL,
    rol character varying(50) NOT NULL
);
 #   DROP TABLE public.partido_arbitro;
       public         heap r       postgres    false            �            1259    25167    arbitrospartido    VIEW     �   CREATE VIEW public.arbitrospartido AS
 SELECT p.match_id,
    a.nombre,
    pa.rol
   FROM ((public.partido_arbitro pa
     JOIN public.arbitro a ON ((pa.referee_id = a.referee_id)))
     JOIN public.partido p ON ((pa.match_id = p.match_id)));
 "   DROP VIEW public.arbitrospartido;
       public       v       postgres    false    231    232    231    222    232    232            �            1259    25125 
   entrenador    TABLE     A   CREATE TABLE public.entrenador (
    user_id integer NOT NULL
);
    DROP TABLE public.entrenador;
       public         heap r       postgres    false            �            1259    24957    equipo    TABLE     �   CREATE TABLE public.equipo (
    team_id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    ciudad character varying(50),
    admin_id integer,
    coach_id integer
);
    DROP TABLE public.equipo;
       public         heap r       postgres    false            �            1259    24956    equipo_team_id_seq    SEQUENCE     �   CREATE SEQUENCE public.equipo_team_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.equipo_team_id_seq;
       public               postgres    false    218            b           0    0    equipo_team_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.equipo_team_id_seq OWNED BY public.equipo.team_id;
          public               postgres    false    217            �            1259    24964    estadio    TABLE     �   CREATE TABLE public.estadio (
    stadium_id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    calle character varying(100),
    ciudad character varying(50),
    capacidad integer
);
    DROP TABLE public.estadio;
       public         heap r       postgres    false            �            1259    24963    estadio_stadium_id_seq    SEQUENCE     �   CREATE SEQUENCE public.estadio_stadium_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.estadio_stadium_id_seq;
       public               postgres    false    220            c           0    0    estadio_stadium_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.estadio_stadium_id_seq OWNED BY public.estadio.stadium_id;
          public               postgres    false    219            �            1259    25040    estadistica    TABLE     �   CREATE TABLE public.estadistica (
    stat_id integer NOT NULL,
    tipo character varying(50) NOT NULL,
    match_id integer NOT NULL,
    player_id integer NOT NULL,
    goles integer DEFAULT 0,
    asistencias integer DEFAULT 0
);
    DROP TABLE public.estadistica;
       public         heap r       postgres    false            �            1259    25039    estadistica_stat_id_seq    SEQUENCE     �   CREATE SEQUENCE public.estadistica_stat_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.estadistica_stat_id_seq;
       public               postgres    false    229            d           0    0    estadistica_stat_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.estadistica_stat_id_seq OWNED BY public.estadistica.stat_id;
          public               postgres    false    228            �            1259    25163    estadisticasjugador    VIEW     �   CREATE VIEW public.estadisticasjugador AS
SELECT
    NULL::integer AS player_id,
    NULL::character varying(50) AS nombre,
    NULL::bigint AS goles_totales;
 &   DROP VIEW public.estadisticasjugador;
       public       v       postgres    false            �            1259    24993    jugador    TABLE     �   CREATE TABLE public.jugador (
    player_id integer NOT NULL,
    nombre character varying(50) NOT NULL,
    apellido character varying(50) NOT NULL,
    fecha_nacimiento date,
    team_id integer NOT NULL
);
    DROP TABLE public.jugador;
       public         heap r       postgres    false            �            1259    25004    jugador_partido    TABLE     �   CREATE TABLE public.jugador_partido (
    player_id integer NOT NULL,
    match_id integer NOT NULL,
    minutos_jugados integer NOT NULL
);
 #   DROP TABLE public.jugador_partido;
       public         heap r       postgres    false            �            1259    24992    jugador_player_id_seq    SEQUENCE     �   CREATE SEQUENCE public.jugador_player_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.jugador_player_id_seq;
       public               postgres    false    224            e           0    0    jugador_player_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.jugador_player_id_seq OWNED BY public.jugador.player_id;
          public               postgres    false    223            �            1259    25110    jugador_posicion    TABLE     k   CREATE TABLE public.jugador_posicion (
    player_id integer NOT NULL,
    position_id integer NOT NULL
);
 $   DROP TABLE public.jugador_posicion;
       public         heap r       postgres    false            �            1259    25171    jugadoresequipo    VIEW     �   CREATE VIEW public.jugadoresequipo AS
 SELECT j.player_id,
    j.nombre,
    e.nombre AS equipo
   FROM (public.jugador j
     JOIN public.equipo e ON ((j.team_id = e.team_id)));
 "   DROP VIEW public.jugadoresequipo;
       public       v       postgres    false    224    218    218    224    224            �            1259    24970    partido_match_id_seq    SEQUENCE     �   CREATE SEQUENCE public.partido_match_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.partido_match_id_seq;
       public               postgres    false    222            f           0    0    partido_match_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.partido_match_id_seq OWNED BY public.partido.match_id;
          public               postgres    false    221            �            1259    25159    partidosestadio    VIEW     �   CREATE VIEW public.partidosestadio AS
 SELECT p.match_id,
    p.fecha,
    e.nombre AS estadio
   FROM (public.partido p
     JOIN public.estadio e ON ((p.stadium_id = e.stadium_id)));
 "   DROP VIEW public.partidosestadio;
       public       v       postgres    false    220    222    222    222    220            �            1259    25102    posicion    TABLE     n   CREATE TABLE public.posicion (
    position_id integer NOT NULL,
    nombre character varying(50) NOT NULL
);
    DROP TABLE public.posicion;
       public         heap r       postgres    false            �            1259    25101    posicion_position_id_seq    SEQUENCE     �   CREATE SEQUENCE public.posicion_position_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.posicion_position_id_seq;
       public               postgres    false    234            g           0    0    posicion_position_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.posicion_position_id_seq OWNED BY public.posicion.position_id;
          public               postgres    false    233            �            1259    25025    usuario    TABLE     Q  CREATE TABLE public.usuario (
    user_id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    email character varying(100),
    tipo character varying(20),
    supervisor_id integer,
    CONSTRAINT usuario_tipo_check CHECK (((tipo)::text = ANY ((ARRAY['admin'::character varying, 'coach'::character varying])::text[])))
);
    DROP TABLE public.usuario;
       public         heap r       postgres    false            �            1259    25024    usuario_user_id_seq    SEQUENCE     �   CREATE SEQUENCE public.usuario_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.usuario_user_id_seq;
       public               postgres    false    227            h           0    0    usuario_user_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.usuario_user_id_seq OWNED BY public.usuario.user_id;
          public               postgres    false    226            �            1259    25175    view_jugadores_con_posicion    VIEW     j  CREATE VIEW public.view_jugadores_con_posicion AS
 SELECT j.player_id,
    j.nombre AS nombre_jugador,
    string_agg((p.nombre)::text, ', '::text) AS posiciones
   FROM ((public.jugador j
     JOIN public.jugador_posicion jp ON ((j.player_id = jp.player_id)))
     JOIN public.posicion p ON ((jp.position_id = p.position_id)))
  GROUP BY j.player_id, j.nombre;
 .   DROP VIEW public.view_jugadores_con_posicion;
       public       v       postgres    false    235    224    235    224    234    234            �            1259    25180    view_partidos_con_estadio    VIEW     �   CREATE VIEW public.view_partidos_con_estadio AS
 SELECT par.match_id,
    e.nombre AS nombre_estadio,
    par.fecha,
    par.home_team_id,
    par.away_team_id
   FROM (public.partido par
     JOIN public.estadio e ON ((par.match_id = e.stadium_id)));
 ,   DROP VIEW public.view_partidos_con_estadio;
       public       v       postgres    false    222    222    222    222    220    220            |           2604    25072    arbitro referee_id    DEFAULT     x   ALTER TABLE ONLY public.arbitro ALTER COLUMN referee_id SET DEFAULT nextval('public.arbitro_referee_id_seq'::regclass);
 A   ALTER TABLE public.arbitro ALTER COLUMN referee_id DROP DEFAULT;
       public               postgres    false    230    231    231            t           2604    24960    equipo team_id    DEFAULT     p   ALTER TABLE ONLY public.equipo ALTER COLUMN team_id SET DEFAULT nextval('public.equipo_team_id_seq'::regclass);
 =   ALTER TABLE public.equipo ALTER COLUMN team_id DROP DEFAULT;
       public               postgres    false    217    218    218            u           2604    24967    estadio stadium_id    DEFAULT     x   ALTER TABLE ONLY public.estadio ALTER COLUMN stadium_id SET DEFAULT nextval('public.estadio_stadium_id_seq'::regclass);
 A   ALTER TABLE public.estadio ALTER COLUMN stadium_id DROP DEFAULT;
       public               postgres    false    219    220    220            y           2604    25043    estadistica stat_id    DEFAULT     z   ALTER TABLE ONLY public.estadistica ALTER COLUMN stat_id SET DEFAULT nextval('public.estadistica_stat_id_seq'::regclass);
 B   ALTER TABLE public.estadistica ALTER COLUMN stat_id DROP DEFAULT;
       public               postgres    false    228    229    229            w           2604    24996    jugador player_id    DEFAULT     v   ALTER TABLE ONLY public.jugador ALTER COLUMN player_id SET DEFAULT nextval('public.jugador_player_id_seq'::regclass);
 @   ALTER TABLE public.jugador ALTER COLUMN player_id DROP DEFAULT;
       public               postgres    false    224    223    224            v           2604    24974    partido match_id    DEFAULT     t   ALTER TABLE ONLY public.partido ALTER COLUMN match_id SET DEFAULT nextval('public.partido_match_id_seq'::regclass);
 ?   ALTER TABLE public.partido ALTER COLUMN match_id DROP DEFAULT;
       public               postgres    false    221    222    222            ~           2604    25105    posicion position_id    DEFAULT     |   ALTER TABLE ONLY public.posicion ALTER COLUMN position_id SET DEFAULT nextval('public.posicion_position_id_seq'::regclass);
 C   ALTER TABLE public.posicion ALTER COLUMN position_id DROP DEFAULT;
       public               postgres    false    234    233    234            x           2604    25028    usuario user_id    DEFAULT     r   ALTER TABLE ONLY public.usuario ALTER COLUMN user_id SET DEFAULT nextval('public.usuario_user_id_seq'::regclass);
 >   ALTER TABLE public.usuario ALTER COLUMN user_id DROP DEFAULT;
       public               postgres    false    227    226    227            Z          0    25135    administrador 
   TABLE DATA           0   COPY public.administrador (user_id) FROM stdin;
    public               postgres    false    237   ��       T          0    25069    arbitro 
   TABLE DATA           B   COPY public.arbitro (referee_id, nombre, experiencia) FROM stdin;
    public               postgres    false    231   ��       Y          0    25125 
   entrenador 
   TABLE DATA           -   COPY public.entrenador (user_id) FROM stdin;
    public               postgres    false    236   u�       G          0    24957    equipo 
   TABLE DATA           M   COPY public.equipo (team_id, nombre, ciudad, admin_id, coach_id) FROM stdin;
    public               postgres    false    218   Z�       I          0    24964    estadio 
   TABLE DATA           O   COPY public.estadio (stadium_id, nombre, calle, ciudad, capacidad) FROM stdin;
    public               postgres    false    220   G�       R          0    25040    estadistica 
   TABLE DATA           ]   COPY public.estadistica (stat_id, tipo, match_id, player_id, goles, asistencias) FROM stdin;
    public               postgres    false    229   3�       M          0    24993    jugador 
   TABLE DATA           Y   COPY public.jugador (player_id, nombre, apellido, fecha_nacimiento, team_id) FROM stdin;
    public               postgres    false    224   ��       N          0    25004    jugador_partido 
   TABLE DATA           O   COPY public.jugador_partido (player_id, match_id, minutos_jugados) FROM stdin;
    public               postgres    false    225   0      X          0    25110    jugador_posicion 
   TABLE DATA           B   COPY public.jugador_posicion (player_id, position_id) FROM stdin;
    public               postgres    false    235   I;      K          0    24971    partido 
   TABLE DATA           e   COPY public.partido (match_id, fecha, home_team_id, away_team_id, stadium_id, resultado) FROM stdin;
    public               postgres    false    222   2D      U          0    25076    partido_arbitro 
   TABLE DATA           D   COPY public.partido_arbitro (match_id, referee_id, rol) FROM stdin;
    public               postgres    false    232   W      W          0    25102    posicion 
   TABLE DATA           7   COPY public.posicion (position_id, nombre) FROM stdin;
    public               postgres    false    234   %m      P          0    25025    usuario 
   TABLE DATA           N   COPY public.usuario (user_id, nombre, email, tipo, supervisor_id) FROM stdin;
    public               postgres    false    227   �m      i           0    0    arbitro_referee_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.arbitro_referee_id_seq', 10, true);
          public               postgres    false    230            j           0    0    equipo_team_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.equipo_team_id_seq', 12, true);
          public               postgres    false    217            k           0    0    estadio_stadium_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.estadio_stadium_id_seq', 500, true);
          public               postgres    false    219            l           0    0    estadistica_stat_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.estadistica_stat_id_seq', 4620, true);
          public               postgres    false    228            m           0    0    jugador_player_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.jugador_player_id_seq', 600, true);
          public               postgres    false    223            n           0    0    partido_match_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.partido_match_id_seq', 720, true);
          public               postgres    false    221            o           0    0    posicion_position_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.posicion_position_id_seq', 10, true);
          public               postgres    false    233            p           0    0    usuario_user_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.usuario_user_id_seq', 502, true);
          public               postgres    false    226            �           2606    25139     administrador administrador_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public.administrador
    ADD CONSTRAINT administrador_pkey PRIMARY KEY (user_id);
 J   ALTER TABLE ONLY public.administrador DROP CONSTRAINT administrador_pkey;
       public                 postgres    false    237            �           2606    25075    arbitro arbitro_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.arbitro
    ADD CONSTRAINT arbitro_pkey PRIMARY KEY (referee_id);
 >   ALTER TABLE ONLY public.arbitro DROP CONSTRAINT arbitro_pkey;
       public                 postgres    false    231            �           2606    25129    entrenador entrenador_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.entrenador
    ADD CONSTRAINT entrenador_pkey PRIMARY KEY (user_id);
 D   ALTER TABLE ONLY public.entrenador DROP CONSTRAINT entrenador_pkey;
       public                 postgres    false    236            �           2606    24962    equipo equipo_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY public.equipo
    ADD CONSTRAINT equipo_pkey PRIMARY KEY (team_id);
 <   ALTER TABLE ONLY public.equipo DROP CONSTRAINT equipo_pkey;
       public                 postgres    false    218            �           2606    24969    estadio estadio_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.estadio
    ADD CONSTRAINT estadio_pkey PRIMARY KEY (stadium_id);
 >   ALTER TABLE ONLY public.estadio DROP CONSTRAINT estadio_pkey;
       public                 postgres    false    220            �           2606    25047    estadistica estadistica_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.estadistica
    ADD CONSTRAINT estadistica_pkey PRIMARY KEY (stat_id);
 F   ALTER TABLE ONLY public.estadistica DROP CONSTRAINT estadistica_pkey;
       public                 postgres    false    229            �           2606    25008 $   jugador_partido jugador_partido_pkey 
   CONSTRAINT     s   ALTER TABLE ONLY public.jugador_partido
    ADD CONSTRAINT jugador_partido_pkey PRIMARY KEY (player_id, match_id);
 N   ALTER TABLE ONLY public.jugador_partido DROP CONSTRAINT jugador_partido_pkey;
       public                 postgres    false    225    225            �           2606    24998    jugador jugador_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public.jugador
    ADD CONSTRAINT jugador_pkey PRIMARY KEY (player_id);
 >   ALTER TABLE ONLY public.jugador DROP CONSTRAINT jugador_pkey;
       public                 postgres    false    224            �           2606    25114 &   jugador_posicion jugador_posicion_pkey 
   CONSTRAINT     x   ALTER TABLE ONLY public.jugador_posicion
    ADD CONSTRAINT jugador_posicion_pkey PRIMARY KEY (player_id, position_id);
 P   ALTER TABLE ONLY public.jugador_posicion DROP CONSTRAINT jugador_posicion_pkey;
       public                 postgres    false    235    235            �           2606    25080 $   partido_arbitro partido_arbitro_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public.partido_arbitro
    ADD CONSTRAINT partido_arbitro_pkey PRIMARY KEY (match_id, referee_id);
 N   ALTER TABLE ONLY public.partido_arbitro DROP CONSTRAINT partido_arbitro_pkey;
       public                 postgres    false    232    232            �           2606    24976    partido partido_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.partido
    ADD CONSTRAINT partido_pkey PRIMARY KEY (match_id);
 >   ALTER TABLE ONLY public.partido DROP CONSTRAINT partido_pkey;
       public                 postgres    false    222            �           2606    25109    posicion posicion_nombre_key 
   CONSTRAINT     Y   ALTER TABLE ONLY public.posicion
    ADD CONSTRAINT posicion_nombre_key UNIQUE (nombre);
 F   ALTER TABLE ONLY public.posicion DROP CONSTRAINT posicion_nombre_key;
       public                 postgres    false    234            �           2606    25107    posicion posicion_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.posicion
    ADD CONSTRAINT posicion_pkey PRIMARY KEY (position_id);
 @   ALTER TABLE ONLY public.posicion DROP CONSTRAINT posicion_pkey;
       public                 postgres    false    234            �           2606    25033    usuario usuario_email_key 
   CONSTRAINT     U   ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_email_key UNIQUE (email);
 C   ALTER TABLE ONLY public.usuario DROP CONSTRAINT usuario_email_key;
       public                 postgres    false    227            �           2606    25031    usuario usuario_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (user_id);
 >   ALTER TABLE ONLY public.usuario DROP CONSTRAINT usuario_pkey;
       public                 postgres    false    227            A           2618    25166    estadisticasjugador _RETURN    RULE     �   CREATE OR REPLACE VIEW public.estadisticasjugador AS
 SELECT j.player_id,
    j.nombre,
    sum(s.goles) AS goles_totales
   FROM (public.jugador j
     JOIN public.estadistica s ON ((j.player_id = s.player_id)))
  GROUP BY j.player_id;
 �   CREATE OR REPLACE VIEW public.estadisticasjugador AS
SELECT
    NULL::integer AS player_id,
    NULL::character varying(50) AS nombre,
    NULL::bigint AS goles_totales;
       public               postgres    false    4743    224    224    229    229    239            �           2606    25140 (   administrador administrador_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.administrador
    ADD CONSTRAINT administrador_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.usuario(user_id);
 R   ALTER TABLE ONLY public.administrador DROP CONSTRAINT administrador_user_id_fkey;
       public               postgres    false    237    227    4749            �           2606    25130 "   entrenador entrenador_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.entrenador
    ADD CONSTRAINT entrenador_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.usuario(user_id);
 L   ALTER TABLE ONLY public.entrenador DROP CONSTRAINT entrenador_user_id_fkey;
       public               postgres    false    227    236    4749            �           2606    25145    equipo equipo_admin_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.equipo
    ADD CONSTRAINT equipo_admin_id_fkey FOREIGN KEY (admin_id) REFERENCES public.administrador(user_id);
 E   ALTER TABLE ONLY public.equipo DROP CONSTRAINT equipo_admin_id_fkey;
       public               postgres    false    218    237    4765            �           2606    25150    equipo equipo_coach_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.equipo
    ADD CONSTRAINT equipo_coach_id_fkey FOREIGN KEY (coach_id) REFERENCES public.entrenador(user_id);
 E   ALTER TABLE ONLY public.equipo DROP CONSTRAINT equipo_coach_id_fkey;
       public               postgres    false    4763    236    218            �           2606    25048 %   estadistica estadistica_match_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.estadistica
    ADD CONSTRAINT estadistica_match_id_fkey FOREIGN KEY (match_id) REFERENCES public.partido(match_id);
 O   ALTER TABLE ONLY public.estadistica DROP CONSTRAINT estadistica_match_id_fkey;
       public               postgres    false    222    4741    229            �           2606    25053 &   estadistica estadistica_player_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.estadistica
    ADD CONSTRAINT estadistica_player_id_fkey FOREIGN KEY (player_id) REFERENCES public.jugador(player_id);
 P   ALTER TABLE ONLY public.estadistica DROP CONSTRAINT estadistica_player_id_fkey;
       public               postgres    false    4743    229    224            �           2606    25014 -   jugador_partido jugador_partido_match_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.jugador_partido
    ADD CONSTRAINT jugador_partido_match_id_fkey FOREIGN KEY (match_id) REFERENCES public.partido(match_id);
 W   ALTER TABLE ONLY public.jugador_partido DROP CONSTRAINT jugador_partido_match_id_fkey;
       public               postgres    false    225    4741    222            �           2606    25009 .   jugador_partido jugador_partido_player_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.jugador_partido
    ADD CONSTRAINT jugador_partido_player_id_fkey FOREIGN KEY (player_id) REFERENCES public.jugador(player_id);
 X   ALTER TABLE ONLY public.jugador_partido DROP CONSTRAINT jugador_partido_player_id_fkey;
       public               postgres    false    224    4743    225            �           2606    25115 0   jugador_posicion jugador_posicion_player_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.jugador_posicion
    ADD CONSTRAINT jugador_posicion_player_id_fkey FOREIGN KEY (player_id) REFERENCES public.jugador(player_id);
 Z   ALTER TABLE ONLY public.jugador_posicion DROP CONSTRAINT jugador_posicion_player_id_fkey;
       public               postgres    false    4743    235    224            �           2606    25120 2   jugador_posicion jugador_posicion_position_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.jugador_posicion
    ADD CONSTRAINT jugador_posicion_position_id_fkey FOREIGN KEY (position_id) REFERENCES public.posicion(position_id);
 \   ALTER TABLE ONLY public.jugador_posicion DROP CONSTRAINT jugador_posicion_position_id_fkey;
       public               postgres    false    4759    234    235            �           2606    24999    jugador jugador_team_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.jugador
    ADD CONSTRAINT jugador_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.equipo(team_id);
 F   ALTER TABLE ONLY public.jugador DROP CONSTRAINT jugador_team_id_fkey;
       public               postgres    false    4737    218    224            �           2606    25081 -   partido_arbitro partido_arbitro_match_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.partido_arbitro
    ADD CONSTRAINT partido_arbitro_match_id_fkey FOREIGN KEY (match_id) REFERENCES public.partido(match_id);
 W   ALTER TABLE ONLY public.partido_arbitro DROP CONSTRAINT partido_arbitro_match_id_fkey;
       public               postgres    false    4741    232    222            �           2606    25086 /   partido_arbitro partido_arbitro_referee_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.partido_arbitro
    ADD CONSTRAINT partido_arbitro_referee_id_fkey FOREIGN KEY (referee_id) REFERENCES public.arbitro(referee_id);
 Y   ALTER TABLE ONLY public.partido_arbitro DROP CONSTRAINT partido_arbitro_referee_id_fkey;
       public               postgres    false    4753    232    231            �           2606    24982 !   partido partido_away_team_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.partido
    ADD CONSTRAINT partido_away_team_id_fkey FOREIGN KEY (away_team_id) REFERENCES public.equipo(team_id);
 K   ALTER TABLE ONLY public.partido DROP CONSTRAINT partido_away_team_id_fkey;
       public               postgres    false    222    218    4737            �           2606    24977 !   partido partido_home_team_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.partido
    ADD CONSTRAINT partido_home_team_id_fkey FOREIGN KEY (home_team_id) REFERENCES public.equipo(team_id);
 K   ALTER TABLE ONLY public.partido DROP CONSTRAINT partido_home_team_id_fkey;
       public               postgres    false    222    218    4737            �           2606    24987    partido partido_stadium_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.partido
    ADD CONSTRAINT partido_stadium_id_fkey FOREIGN KEY (stadium_id) REFERENCES public.estadio(stadium_id);
 I   ALTER TABLE ONLY public.partido DROP CONSTRAINT partido_stadium_id_fkey;
       public               postgres    false    220    222    4739            �           2606    25034 "   usuario usuario_supervisor_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_supervisor_id_fkey FOREIGN KEY (supervisor_id) REFERENCES public.usuario(user_id);
 L   ALTER TABLE ONLY public.usuario DROP CONSTRAINT usuario_supervisor_id_fkey;
       public               postgres    false    4749    227    227            Z      x�3�2�24�25����� (      T   �   x�E�=�@�z�s�"?���Hek3����n�,��6��b/�R�ɛ��)���HWn�*��b��u#�OP1n�(=�ZC����0���f=�6��4�����zԣX�3��Ѯ���p�冩�O�K�����4�� P=��Pl'��"����B����N�A�/�:J�      Y   �  x�����HC�=��%�ܝ���\�5�l�4�QT��tt�G���+���XM5����U�J�*��)G��Z姫����}�Zo���O��{�=��/������}W�G?���߫ߧ����<:։Nu^���\�G׺ѭ���2���`�=��0��p�=����N����;�N��3�0���`���pV��a4��0 F�]ZrP��a1.���kO���1>�"c�o�&�d����2V�h.�e���!3f�g_�7g���3xF�w�ߟ�o����o��ƻ ��~���7����.�nЮ���.�nѮ~��d7���o����o��
��7�~���7�~��7�~���7�~����7�~���7�~���7�~���7�~s�
�����o����{&{'
~�/�����_��D�_�~�/�����_�~�/�e�p��������~�/�S%�/�����_�˻�L�_�~�/����o������_�~�/�����_�~�/gۂ����_�~�/w�d��B�����W��_�p��+~ů���W��_�+~ů���W��m,r��_�+~�>�B�F��4�-�m��5��_�+~}����+~ů���W��m)��W��_�+~ů���W��_�+~ů��l���W��_�+~ů��n�n�R��?΍�fixF����?I�I��      G   �   x�]�;n�0�g�:A���Xp�.5��-	(Bd����s�b��4):�#~}"%�њ���"Ãl�5���Y<��Zl�y���*.� 调)|�*���b1{����6v�sq���N�*�g�;8Uι�պw�;�,��r�����̩������)9	�=L�f^V9Ţ!m��9���tê�HT�����P���Qr�)[�,�\�ߞ��Xc�      I   �  x�u��n�E�S_1?�`�����#	`�8@�MK�(�8F���ҋ,,�%��m��x��4磻9�jv�Wˇ_�?\w/�N�������r:�/�������|�]v�����r�pZ�_�/�w��ۧ�w�.����쿻���z��;���sH��-�7���������|zXn/��oO�7��������;����o��?��!�~Z><�~���p���O���������rws��iy�����z��4M)������e��y<�;-�����v�E��0�^B<\�?����r���[���r<��~_���e8����;>���b�e��x������B���q��ܿ����������w�?���q9�b�c�im��?���O�?��y��rw���<=�g�w��t~�\v}���݋���a����?دo������kEi^�}w���x�����r��������x/��y�����n�]n�]7�4���~f���'�E����C��+�j�+ɕJ���*W(�+�ԗO~er��+�fؽ~�t^�yG} �BC���ߗ�����O�N�/�R������[Wb*�L��_��x��_�xؽ~�+��x�0��+ӕ/u�x��K��Y�|���v,m�m�1�Xێ���i;�k۱�������v,m�M۱��K�q�vB�m��v�m�1��v,mGi;N!ֶci;i�q���J�I�N��j۩�������j۩���m�Rm;��Ӧ�B�m��vҶVֶSi;m�N}H��T�N۶�͛j۩��j�i���J�I�NSH��T���v�C�m��vֶ�!��v.m�gm�.��v.m�m�9�\�Υ��i;��k۹���m�fʵ�\�Λ�srm;������S��\�ε�<�\�Υ�,m�)��v.m��v�C_��K۽��B_��K�����.������o��c�k�}i�ߴ��mm�/m��6���v_��7m�}�k�}i�߶ͫ���ݗ���v?���ݗ�{i��B_��Kۃ���a�m��A�x�P�J�ó��.����=l�bj�Ci{ش=�0Զ����m9����=l��0Զ����m{�P�J�Cm{�P�Jۃ�=La�m��Q��0ֶ����m��0ֶ�������d����=n�ck�ci{ܴ=�0ֶ����m�9�����=n��0ֶ����m{�X�K�cm{�X�Kۣ�=Na�m���I��0ն����mO�2�mO���Y�S���Tڞ�mO1L����=m��%�T۞Jۓ�=�0ն����i{��T۞J�Ӷ�iSm{*mO��iSm{*mO��4���=��gm{}�^۞K۳�=�\۞K���.̵���=o۞c�k�si{޴=�0׶����m�9̵���=oڞ�0׶����m{�\۞K�sm{�\۞K۳�=Oa�mϥ��u�sX���C)\��>������{S89����2P'�9\_�H�P�8��_��sB �����o)�J,�p�#E['�9\��K�D �9�k����`Dt��Z<)�(�w�����7j�p�nuK�ˆ]v�]�^z��V�T���٭�����[S%�a��j����3��3U4�iv�i�jZ�$E�ek��P�@�7� �zN��I&X�$���w���$���{����>	�d럤�����B�-��,аPr8���Pb0Y��()�,�]�Lh�h�~+It�3>J#8#%�����N���VJ
%�����@�L��d��`�m.g��P���Sb0Y�a��p��qT2Y�Y*!�,`=�4t"��5UR(Y��\ ��J'x_%����B�����k%��������\	�d뮤�y����B�-��,�0Xr8Y�;,1�,`-�J�K����&K'�%������gIC'B�Y�%��ZN�@Y�a��p���Zb0Y��-)�,�ݖLh�-9�~��[�%������qIC'��Y�%��Z��@Y�a��p��w]b0Y��.)�,�}�Lh/9�,`��Fo{�%�����Nķ��K
%�ܗ��@�~��d��`��5`R(Y�;01�,а`r8Y�x0�,�L�Ho=Y&�w����������'���&7���B�(�@rʺ0)�܃�.L&7��ua"�e\�FnCY&Q\8Z&����T�par8�޻01��o]�J��.L&�7\�N�7.L#8&�������x�.�;�z�����W���]8�w_���w����օ�zVo�z��=X�	�p�ޅ�۰ƅ�zVo�:��X�k]�4Dq�h]�Jh�0 e�����p���`��uaR(Y��01�,�par8Y��0�,�\�H�.L��p�.L
%�\���@Å��d���`z��0)�,�]�Lh�09�,`\�Fp.L$X&Q\8Z&��Z.�@Y����p��wab0Y��p\O}�zĺ01�,�par8Y��0�,�\�H�.L��p�.L
%�\���@Å��d���`��uaR(Y��01���.L'&����օIC�օI�d��sPh�09�,�]�L�.L
%x&�.L���ua2Y��0!�,`]�4Dq�h]�Jh�0 e�����ޅ��d�¤P��wab0Y����p��qa2=�f\�H�.�ی��Ѻ0)�,�ra. �&�����օI�d���`�@Å��d��d0��saB =h]�8���4.L$�.L'�����@�¤Pr>й0!��.L
%'����o]�D�&��C�օICNօI��XfÅ� (�7\�N��.L&�[&�����I�&������� ΅	�d�¤!�'�¤P�@˅� �Gc����ޅ��d�¤P��wab0Y����p��qa2Y��0!�,`]8���`�uᴞL֣�-N��d=��p���t�O�.����z@ٺpZO(�e��i=����.�>b����qᴞSփ�΅�zRY�*[&I\8Y&��Z.�@Y����p��wab0="�\8��ӈ'���`�@Å��d��d0��saB Y��0iH��ɺ0)�,�ra. �&�����օ�'�R������&������΅	�d�¤!�'�¤P�@˅� (4\�N�.L&X&�����ޅ��d��d0��saB Y��0iH��ɺ0)�,�ra. �&�����օI�d���`�@Å���q�o]�Fp.L$X&I\8Y&��Z.�@Y����p��wab0Y��0)�,�]�Lh�09�,`\�F2.L$X&I\8Y&��Z.�@Y����p��wab0Y��0)�,�]�Lh�09�,`\�Fp.L��mY&Y\8;&�G�.L'�ny&�����B��[΅	���-�¤P���wab0y��[&�'�����#\օIC�օI�����sP�o�09�t�]�Lʷ.L
%�{&��.L'�&����օIC�օI�d��sP\�.L'x&���B�ޅ��d�����ƅ�`d�@��uaҐŅ�uaR(Y���\ �.L��Z&���B�ޅ��d�����ƅ�`d�@��u�>���Z�듻��n˅���>��p�>����zΟ���x���	^}�׻p^��Շx.�קx�1^��y}�W�u.��'y�Q^�¤!�g�¤P�@˅� (4\�N�.L&X&�҇�������>ą�qa2Y��0!�,`]�4dq�l]�Jh�0 e�����ޅ��d�¤P��wab0}�ݻ09�,`\�Fp.L$X&Y\8[&��Z.�@Y����p��wab0Y��0)�,�]�Lh�09��0�o]�Fp.L$X&Y\8[&��Z.�@Y����p��wab0Y��0)�,�]�Lh�09�,`\�F��qaB Y��0i���ٺ0)�,�ra. �&�����օI�d���`�@Å��d��d0��saB ��օ�C/.�;^��?�B�?Y�`�      R      x�m����:se�}���C|��;�v'����*��,G>����HN"V�����?��_��_��?�������}�>�T�k�m��f������¿^��7���}�����g�_��o_��k�Z><����J�������x�����^�a�����_x��'Px�����ý�eSy���Py������{�ϙ�{W˭�xo?����ʭ��wϭ>���w��s�/��sk����
���N��w=���=���﷏���]�5��o�����g��G\>��!��g�y���!ut�xJ�G]>>�:�|||uw�xP�^�����|�j=y�1�ӑ?�+yYהy�t����{��{��{\	x�ם��{=	� �F>
�7O����؝�|�{�#/~�w:�|��w:�u����Y|�#_��|��w:�u"?����IG�.�O:�u.?���E����_u��J�����#��ȟ����&�G>>	��_I��Ϩ	���F���HG�>�|}�#���G:����t��3���g��#_����|}�o:�������g��#_W�7�����>�;�z�<�w$�Y�oK>�D� |J"K>5(�F2�kz"��d���e�d�ч	��#h��W6��N��u���:�Jam�E�0���q�0��nr�0��N�R�A[��RRRʒ2X7�RR�Z\�q�N&��D�r�N6��D�s�NF��D�t�%j���K�_3Y��잕�7��2P�-e�nn��B�SR��2�ķ���Ӗ2�y�R:O[�@2�R�Vz�@�iO�+[�)��=e��m���ؗ�2�WP�����5�o�a}cg�;kx��YC��em����e��鉬��~ce���J(�+e��
�+e��/f�u��̠묿�A�Y3����f]g������t]Gof�u��A�Y3���(L���]�
.hh� 4�b�Z9���x�h%+4����]0CC+��D_OJ�Ґ)�Kcb�4.��Ҹ4*FJ�Ұ)�K�b�4.��Ҹ42FJ���)�Kcc�4tKxs������ፆV�0GC+C����!�����hhe�4�F��Q�HCk�9Ѻ��ONceX?9M�|r����44���ih>��X�^��4֩W?9�u������8	8���r��T�D+�N���8!8�J�s�u��i�����`��rr��x9?Xw��"�;^�V��2�Da�x�U-�/���T�i(ޚ�X��ZSzM�B�HI��Z�ae�r
�Vn-%�eKǿ�dKG�k���ů�|蚫MǾ.}���__0jOG���*�/E�i�Ks�RĜF�1�/E�i�Ks�Z��ӈ�Z��F�1�/-
�+��S�+���_���Jh:�^)M(�+��)�z�4e[��&m땢��b�spwNC#��ih��-��r,�DV�p�IV�p�IV~p�IV|p�IVzp�I�(�ZN���r���Ktm{R��=)Ͳ�'�Pb�$������4�Z���f[듂�|k)	͸֑�Мk)ͺ֑�мk95r�Ŏ��n����M!�VZ�B+�?�4���ъZih��4�� �����JC+^h�D�oNC�9�bߜƊ�}R�m���fA�'��y��Iih&�}R5��R�m�����'�����Iih:�}R�An�ʯhhݠA+�4���V�JC+h����ҐA��:(���Z
�VZi@+'Z��Vs�n�jNc�׵��X��jN㛂/�44=ڸ���h�Z�����o̐6�H�1Eڸ(��i���΍K�o�;7�N�1Mڸ@���s���������ih�4���jZA�5�� ��VP�MCk��7�!
�4������{JC3���44e�zJCs���44i�zJC���Jihڲq!�sčKٟ�$n\����e�r�'���?1wٸ������E��O=.k�}�qa��S�K�e�z\�.����v٧�K�O4.q�X�h\�.���2w�%�ƅ�O=.u���m\�.1�۸�]b:�q���|n�w�	��E�3��IihJ�=)��'��I���44�۞���zr�D9����c�5�⅋���xᢆV�pQC+^���5ᢆ�8��Z��E'�8|s���i����4��Мi{SW�d)��9���44g�ޔ��Lۛ�Мi��44��?)�;�OJCs����мs��~o�Z��pQCu�;#����h��.jh��.jh�5䃭�E�����J.:Ѻ����X7�^r�kE/9���������|JCs���44g�kJCs���44g�kJCs���44g�kJCSҽ�44%�kJCs���44%�kNC��E����E��ࢆVPpQC+(���\Ԑ~kxe��(]�E�N��	K�b���E5��i�����P�avZ��0;Ts���9�N����k�t�k��=5��i����;���4q�w^�&���{�e��{�e��{�e��{�e��{�e��{�e��;V&:�󎕉N���YF��ce�S;�}�Q;cr��:cr�S:cr��9cr�S9cr��8cr�S8o�V��7o�Z�S7cr��6o�b�S6cr��5o�j�S5o�n��4��W�&Xy�2�@j�4a�_�_~��v�k��-�`5��� �� �8�����t�K��H����t�k���t���o
@���MhR��)M��7ŠI��� 4tߜ����}s�oC���i��{A)��G�4�~I�4�߫��֯ɡ����ɡ���/ʡ���oʡ��֯ʡ��ޅބ��JNc�ϫ�44�t��������д�UR�V�JJC�JWIihZ�*)�_%��y૤44�tՔ�息��Ј�9�uI�jNc]/(�7?����ЊJiH��h��4��RZ�B)�q�4��!��ЊJ9Ѻ_-��x[N���)�S]-��⩐��橮���<��S���zJC�TWOih���)M_=��y���44E|������XZx������9=����A-�\�LC+yx���^�LCz���J�ih%�4�F/<����LC+yx�D���9%�4�m��sJ�Nih��S�ľ&��;��I��Nih��S�ľ&��'��I��Iih�zR�ľ�����񩞾�D|���;����N�g{���鞾�D|�����'|z,p\|Ƨ�;����q�9���D|ҧ�;�D9݉���D}�ǧ44{�����1{�����1{�ɟ����1�}�������1{�)�o_oNC�9\�;.℅�Z���E�8ao��'�M�ㄽ�w��7]�_��t�;~.�E�8ao��?���w�:�t�;��n��SX7]�)��.z��M�c
릋�1�u�E�s��w�9�t�;��n��s�7]����t�;~�|�E'Zi�E�8ao��'�M}ℽ�O��7]����>q��t�'VLn��+&7]����>�br�E�8ao��+&7]􉉲�.��D�M}b�즋>1Qv�E��(��OL��t�'��o����7]􉉲�.��t�M}b�즋>��.��/�o��D+��%��.:b	榋�X���#�`n��%��.:b	榋�X���#�`n��%��.:b	榋�X���#�`n��%��.:�4�M�c)	����)�*t�i���9ք�M�k���{�5w�<�&�o��o;�w�v(���P<�}ۡx���C�|�m������M�|c��x���C�|c��x���C�|�mg���n;ω\!o�������j6��v��M�i��f�oJ���� V�T�W��7���l�M�|5�~�7_ͦ���W��7l�;��ds��\s��Ts��1Ls��3Dsm�P��@3'�5=��/$�K�u���V:�'e��r�'e�.r�'e���<%e���OI!�k�SR
�����F>%堯�OIA�k�SR��|J�B�OIY�k�SR��|����������������?�OH<| }?!��	�����G���A�b���C�WL�?|
}?!��1�+��>�~�$��ѯ�d|�$���E�b����WL2>|��IƇO�_1���q�+&>�~�$��ү�d|�D���I�b���    3�������'">����x���~"�_>���~��'"��s�d��|��~���~"�_>wLv?WNC�ޕ��<�s�44��\)�#<WJC�ϕ��<�s�44���)M�=wJCϝ��<�s�44���9u�4�w���i�� ��:W��4�}�ތ��'�/��Њ�ih��4��!����PNC+^(�D��=9��ONci��44�����������3R=�SJih��)M1<#��9�g�44'��������М�3r���i�z��4�J?oNc-�<P�g?��=��D��|��s?�P?��s?�P@��Y������A�OD:�?����DĠ���w̠����5衯-w�|JC_Mt}T���q�E���A�_]t}t�7f-]�Y�A�_]�Y�A�_\t�/\t�/\t�/\t�/\t�/\t�/\t|b|�E�'��\t�/\t|b|Ԕ�fGMih&q���fGKih&q���fGKih&q���fGKih&q���fGKih&q��ƺ����Xw��������������-�J�h�TbF{p������.I%f��IڏX�|�I҆���$iO��M�����I��wp�$m�;�CRY�{�$�5�7�?�v���hvop{���wp{����n�T�#���j�B�Tczp���Ѓ;$՘��"��,�uZ��:��4�F��Њ�9��aONCg��X�3�Ii(�'����E�:���m'S�o� ��H9�7R�⍔��)]�F�@�����v#e�����2X�&�9���9���9���9���9���9���9z��{�3G�vx�؏Ox�������Ц������'���?9�5��~R��x?)Mk�����5�OJC��'��i����д�[R���[R���[R��xKJC?�}KNC��3��O�&X!�1�`E�����V<��/X��-��Y�V���<��V,��y�k<�|���k:��%���cښ?6��)�؊��4S���f�ߖb��{[
"��m)�����,��y h\����U�ih#ߖ���s�Z�B)�� ��d���Do���\���a����!����
��dX��$+p���
z�b�䔁��W�@a_)MZ�W
A��RФ�{�4i�^)MZ�W
B����{�(4}��)MZ�w
C��/��}ci�[Zi�-�4���VpKC+�������fpKCk��-�4������4tq|r�:>9�����XS8�������443񎔆f&ޑ����;R��xGJC3�Hihf�)ͬ�#����w�44�����N���g[Mڀ󳵆;p�V�ܐ��ņ{p[iqNc+.��il�Tn�ilU��il%ƍ8'�e�;q~Y����^��	:w�4�s4���;r�^�ܓӠ��箜�Ol���Μ�o<��P�~�;�A%��9��[?ܡ�����P��B&T�z��	�c~��i0��gB�؊��u�n�ܯӠ6�玝�-��0��箝���4���s��ָ��i0^���q?ܿӠ����-w�459��j���<j�rGO�ʖ�zN�;{TB��Ӡ�-w�4���˧A%č>���>��iP�
��4��䎟���	����L��2�OgBm�|:j��әPۭ �΄�.��	ŧ�$�z�O��P|*WN�K͕��Rs儮��\9�+.5WN�K͕��Rs�4A��9!M�aN�K͕�4�W�Pߛ�n&������	�����fB}�����P� ��	���P�5 ��	���P�e ��C}�} ��G}ߕ ��K}߭ ��O}�� ��S}�?��W}��w�����HG(g�O#�U���Y�����>��W}��HM{��?�ӴW}�V��W}��kvڬ�G��'�V�����SK;�_���=��Ԓ5_��%m�SK�|���2�+V����\��%u�b�sBq�'w������.�Or�+�?ɝ��Dd�1��$s����H�T퓼�ҼGa+�d����X˹�X��H���b=��*�d��X,Ir5I��َŪ$�J59�X��p���َ��$��ę��َ��$�J(9��G+��ə��FZX��P�&g~�;ia��Ce������R%��ə��^ZX�d0Fmr�'f��j�&g~b�%�J(9��Ų%��T�3��Q�\r�Ʉ��(/9�z0&4b��~ɡF|r�5�%L%	�ar���3�X�*lcr���3��ca'����9�����#~�XX��P�'g�k�&�:�3�E�*əG������`t�љ�~	Q��4�ҡ/W����i"%CW��EDag�DJ��\�z\��4��"�F�1{��5)�u� ���:���^Kjp�{�ג:���ﵤ��w|-�ǩ�=_Kjr������rT�ѐ�����>�Z��¿	E|�d���Ҕ*!�r�H�T�T�'%5;���DI�N5~&QR�S�[��˵n�-�(Y.�ީF�rI�N�n�*�(\.���-`���%u<}Y|gM-O�9��Κ��*S��A�JS6�T��5����@N�OU�H[�P��z��	IR��������$!�?�]�\RT���%u@�]�\RT��%�@�]�\RT�E�%uA�]�\RT݅�%�A�]�\r#�.v.�j�;��
��K��%�%7C흓K��{'���wO.�j�\rC��A�䎨��r�-Qm�U䞨��*rS��I�䶨��*rc�.�.�5j�B�����Kn����%7H��[�vIt�MR�(��6�]]r��.�.�Sj�F�\+�w�-�Yj�7[X.�P	љ��s��dʡ�3׽�laٔC�!:s���K�*!:s���˧*!:�A]R��uM�P9T�t����*[:s=z��F�P�&k>ڧ�H�P�/���A�V*��R9TBɟ�^���T_r轟maC�Cŗ4z�i[�S�0��sB1�϶*��ɣ�޶��U�n�<z�o[�\�PC3y���|��j�Y�����gmu�賹:y�Y^�<��N}VX'�>[��I��Ț	�]�ɥ�:kVZ9TBɦ�Rk�ZM���ī~��Pri�T���j"%�LZ?�,���H�8Y��	~�ZM��9���&��N[��M������V��������f���*�X��k6\9��d4G�5[��e<��Q~ͦ+�C�d>G6ۮ�̾+�J(��х��+�J(�s�沰��X�ќO���9~yY�|eL�'o�__v_S�{��kl�2���3�X�`�՜ȍ�l6`9T2T�ve�ˡ��2��,�MX�����l�r�IenGi6�ƀ�2��K��V,�J����o�
��*!*sۿV+l�r������Wؐ�P#����/�
[���2TBTf��2ʮ��R�϶,�ʖ�܎Rm6f9T�T�vk�5ˡ��2��\��Y5���ml�gԝ��Y�����%;�*>*�A�Ge6�����٠�2�Ф2�Ф2T|T�	ug��C%De6��Ie6����mp�k9T�T�K��*x*s�E܅-[<���2�¦-��T��۶�U���v)wa�C%Denǯ4ٺ�0^��o�l�r�l�����&۷*[Js��Ja�Cj�s;~��.�q��<��W�l�r�AM�6�����%�����k"}"T�.��>���{��k�K�$tՄ�g�DC��	�BW>�5�Y�e�A�J.�U�G$���r�X���٠��6|s8���.�
��<�)K�*!���5HY�5ע#Z�s�r�ª.c
��ܣ ���˘b�:�(�)��2�Gs��^X�eL�қ{4�VvS.��/��x�v9Tj�f����lP�њ*8Z�A%Gk6��Hk6��Hk6��h�����P	њj<Қ*!Zs�=ᅽ^<�����~/�
���w_xaϗCOk�3���ˡ-�������/�1li�}w�9TB����˿&����r6'_X�P�Ӛ*xZ�AOk6�Ok6�Ok6��i�ƈ�5��*^X�P	њ�n/,s��h�}��V�9TB�����jhҚ�n/�3wqZs�M    ㅭa�������0�]����ls���5�{Қ�S�5ԧBk6�O��lP��lP��lP�
�y�0Z�A%Dk�vyaјC�Gk�vya٘C�Gk�vya�C�Gk�v'ya�Cj��{����z��	W>���	�t�PΦ�d.���-�Sy�r&k@�zl�W��y�*��1cʃ�<ٺ�}l��c��c%��:~��2����|?Zc�CEJg�vUya��5��F�P�R��]X^�H�P	Q���R2c
��<���8O��(Γ)9��d
��<�#�y2�Fj�dJ���e����̘r�3O��He�L�И��w8�(s��i���;֔9T�4�����*q�����j�Ҙ��w8�,3C��|�V���2�J��|�f���	C�Y^�P��lP��lP�Ә*x�AOc6��Nc6��Nc6��i��p�1_�Ｐ�̡�1_���̡�1_�����̡�1_�����̡�&�����g�vMc�vzaəC%Dc�vzaљ�堬:�0����a�gN(���̡>�A}*4f��Th�5ni�5ni���И'k�1TB4����+�*>�u�f�5h��:~��*4��/�nK/�Cs�A�����+���6�-��h�P2�k[:��*�d�׶t֣9\	� ��#��9|��9|�ʜP��(�a���L�ei��_ Y��
2��gi�Ls��ei��K�	?Kcq��5�X��p�L��Y����5�J(i����%j_��{{=��*�����z��9T|I���0
�jh&���׳T͠�}�Us���K��aV�9TB��[���j)t������r��8M�VO{a��D
�}����\m"�S:�����r5;dR
����j������5c�φ5K+�=��`�c�%�$�g͡>ʳA}�g��((�5�)�5�)���P�'�qOy6��(��nt/l^s��(��nu/l_s��(��nv/l`s��(��nw/�as��Ly~v�{a��Д�g����M��n6�����?�aG�C�Gy~����͡�<?e�ֳ�͡F��9~���6�1�(���Cֶ9�U��lP	Q��� _X��P�S���_X��P�S���_X��P�S���_���P����F��>7�a��g����9TB�������+sB��(���+ ��9T�������jPS�����Y��pe��7��\־9,�?����a�+$�_��n>�_n��
2��_��0ޓ	����F8�� ��p�^Ʉv�|a3�A]���P	Q���%_��P	Q��0��|�8�� ���8���7���6�������l��H1S��!k�Ӕ�&��rt�ĕ���(�}��Uq�h,,�+G'`a]\yv�|aa\yv�|ae\9�K�Jt�qHs>���*!�����.f}\�]���qe�aȕ݇Y� Wv#fa�\ٝ��re�b����\,G�k5k����,�+j�4�s����|��vɕ�1��M��q�}r�h�+l�+Go\a�\9��
[�ʳ;�{�ʳ[�����W�-W�An��dͻC��_����s�h&,�+G7aa�\9�	{���OX�4W���®��:
�	�*����SX�8W������"�d��~���s�P��]"W�=W�����r��ϕ�J����er�t娓+l�+��/�+�n�/l�+G�\a]yvs}a]9��
��ʳ����QrX�IW����V�r�ҕ�갰��e���t�;,l�+��p��P,!������u%j�HHٲ��D�a��GB�,v�9�Lhw���9��Lh��v�9��dB�㾰���-Ȅv�}aw��5��^��dB�����ΡJּ�[�*�d�c���Ɵ�	���Ρ�O�<���Ρ�O�<��[��Ӂ�v|r�<�mW�v��v�r��ە�ᰰ���w�h9,l�+G�aa�]YM�B�w/���m��mw%���L"��*�$��b�å��+G�ga�]9�>�����Y�~W������r�~6����������sB���r�6����0	�n -lÛ�<�YO�~��	v�Sv�w�`3�1%G�~��	���h�L�=U`K�1�F�~{<���<cʅ"=�r�GO�\�ѓiӢ�gcZ��x���0�E�gA�6��mP�-ڠ�1-ڠ�1-ڠ>Z�FcZ�A%D�~����*=���mP�Ѣ*>Z�A�G�6��h�5�i�5�i�-z¸6Ӣ�kO��hϡ�ETB�h�J�mP	Ѣ*!Z�A0Z�A0Z�A%D��0��h�J�mP�K�~�����s��e��&Ȅ���l�sx	2���1�����>>�C�dB��cv��唭|�^�#����_��h�_����_��h�_����_��h�_��L�Pd7�D
��<�#�#�Ac�l�B��S"�����˶>�����_vY��PQӗ���.��*n����%��9��/�Ǘ]V����%~�}�}����&��9�8�i˓)X��dʕ�<�b�*O�TiʓiS�'�0�'O�H�ɳ4R㘖<�r�$O�qLG�L�P�'S.4���&��?��$h���M�5��I��o,�s�O#I�w`�C����7���1�D��&��?�J(����?�Kl��7a�� �0�3'��ɗ��ޘ|�=�ɗ��ޘ|��s�lt��$��{��/�{��|ynl+�t����|١�/;T|�e����P���P���P����Z��о���о���о���о���о���о���P��6С؛ڷ�7'�lt���	�R�L����:T�/*{������˄J�?T�:��P�����@�C�dB%�*��Kje�âW�4�Z��
�4�Z��/XrB�S��t��JNHs�����ʶ�4�Z�hp]�*�*��#�e	����PaB5V*�*�ʄj�"T�:T�	�XE��t��+���P��P�2�����o���#���H�VB-'$ͪ�t��	I�*�*ۖjqMh9�ׄ�҄ke�C�jqM�9!M�V�:TB�GBE���H�(��#���:�1�S��P�JgB=�w*��{2��;�����\L��3���5�/&�cz��?�`���GB1�	ň�~$���GBkV��?p��ʝ�q��9��ʝ�q��9�}��sB��y�z�+wN�ǹr�����	�8W�	Ź���*	):��D
�6]��oeo�D
�&]��oeo�Dƴ���iӡ������C��@��귲9И�>�ݺVY�0^�#����[�*�*P�s٭k���5
��創���@�
��\�X[��t����剟�W�:TB�g�J��\b?���@c�L(�%���4�ޏ���.1���V�[c���Ɔ^�db?�����t�f�����\t�f}��&�#���@���4�[�*�*os�-l���8���X��lt�� �:T�4�2b�=p6�h��=С�1TB4f�J��lP	ј*!�AJ�A�J�A%Dc�PW_�:TB4f�J��lP	ј.`{�A�.��Ӊw���Ӡ)=qX�8�>	Zry�4R�����8�!=qX���؏8����M�+�*.�qݛ\W6:Td��7��l
t��h��kp�M�5�i�uor]�h0.���/��(Ǔ)��d��j<�ҡO�p(Ɠ)z�dS���4�hœ)J�ť�N<�r�O�n�,��O1���@�J�F\�6�����)���m~+*UZq��xDec�C�8�q���V6�G;�{����@�J��\�q6ӑk=�fJr���LK��8��ɵg35���l�&�����5f�ɵg35��X5�lt���ɵ�/�+�*!j�A%DM���c����P��{2���~��P�
=٠>��A�x���5����dB-V�*���GB��:l�9!�qT�:�?��Ge{��.��Ge{��[0'�5���@��t`{�COg�z"� �NV��P	љ*!:�A%Dg6���������lt��Ig6�����b��@�J��lP	љ*!:���C�	�-�    ���t溟 �lt�O��\������Лk� lt�qKw��	���@����=С�A?>d{�C�G�6����_��kO�=С�K}��7�:ԠN}��C���m��kߑ��P	%������P��kߑ��P	%���b�j�%���;R��k/F�=СJ:}�����@L�=С�MF}L�=С�MN}L�=С�MN�����5��Sӆl4�/9�1m��@�J(9�s��ɩ���NN�gvr��8��S?Ǚ���9�����^`{�C�����qf'�~�� �*���O�v_��P	%��P	%�>�	� �P�Jr�c��-���ɩ�iB6	:ԧ��z�E4�	:ԈON}L�P�`HDr��X)�p%�NA�M0'��,t6'��,t�sB�^�RA��`N��X*�p�,t��g��AyK��_�Ш�H�Ч�H�Ц�H�Х�H�Ф�H�У�hFV	N4��7!�A�����!��)���Ϗ�D6�����٠"�?Th�g����lP���lP���lP�џ'��D6����׵�U����+��;�y2�N{�,�&�1��Acʜ�<�"�9O��Jq�Lc��<��6�.�,4�\(͓):���r,񪜊¤-���+�cʑ(Iz�i�Ғ�H���E���<Y���<��O�1K=�L�Ў'S$�����{�#���d0m/��'С>ʱA}�c�Քc�֔c��@(��U�rlP	Q�*!ʱA%D9�¸�Ѝ'�?����x2�N1�L�Ӌ'S����4�iœi�S�'S�t�/��6�x��ŀ�T2Tb���JlP�P�**�A�C%6�I%6�I%6����ƀ��»:Tb�J�JlP	Q�*!*�A%D%6�bK��G0'�l
t��9�X6`[��"�#!��Y8�{b.���� ��\�lY��dB���ca��5�X�p�L��sy,4��<*����>yY�P�%E�����@��/Y�O^�:T|I��=���@��I��}�8Р��lt���&��Bew�C%�4��S��t���&?{��݁|��gO�;С�O���E+v:ԸM���)Bv�U�݁�P��g/Z�;p�}MH��ׄ���qMH��ׄd��qMH��ׄ$�Ϟ�gw�C�$��qMH����}v:TBI�����*���O4�Vv���Xcw�C}*I��^cw�C�g�����P�J2�����P#>���ka�4W�d�c���;СJ&=�Z�ƥ&��8.5ɤ�q�I&=�KM2�q\j�I��R�Tz��v:��dz��d�c�F�;p���D�*!
�A%D�6������ڠ�S�ФS�ФSTBt�	chҩ'�1D�6������ڠ�STBtj�J�NmPc�NmPc�NmP	ѩ'�1D�6�bw��uIe{�UŊ�VA&��p��t����ý�G��-Ȅ�^�b��áW2���{e��A� �*!:����BA���NmP�ѩ*>:�A�G�6������P�ҳPС�SO��=*!:�AM:�A%D���6핝�<���۴W�
:T�t�ko�^�+�P�ө��ץ�,�P�N}�m�+���rA�J�N}ս.�vA�qM�S�W�H(�	tj�ʖNmP�ҩ*[:�Aj:�Aj:�AeK��P�[�:TBtj��tj�J�NmP	ѩ�6�w�Q�>��Ż��⽮��YФ�H�=��4�i�_�N��"}4�y������<�ϓ)��dJ��<�"�<O�L�Γ)��d�4��48)Γ)z��44�͓)Z�d����1E�t�ɔ'�y2�Ic�LyR�'S���ɔ'uy2�2��df��ɔ']���2JU�L�Д�{/��3СR�)Tl4e�ʍ�lP�є*9��AE��A�E��A�GS�0.�4e�J��lP㑦lP	є�'RLj�3С��)\���� {R���oA&4��-�t8�J&4��6;jز3�a�+$��?;*!��Ɣ-;��ҔƟ�	Ŕ-;*x��AOS6��bʖ��<MyB�xv����h��M٠�)TB4e�J��lP	єjhҔjhҔ*!��s�3С�)TB4e�J��lp��݁�x�	]�?�M٠>��A}*4e��Th�5ni�5ni���Д'�7�JС�)d�GS6��h�M٠�)T|4e����lP���lP���lP�ї'��-��c��U���٠�7TB4g�J��lP	Q�j�ўj�Q�*!��qa�@TB4h�KX%8����CT��h�ʖmP�R�*[z�AeK�6��G�6��G�6�l���%�2mP	Ѧ'���:mP�ѧ*>
�A�G�6�����ڠ�&�ڠ�&�ڠ�SO�>:�A%D�6��I�6���Գ�,�-�ڠ��S�?˄ڞ�f��CO�6����5n��5n��W�4�q�*A�E����T�U��������?����H�?�#!�xV	:�$��*A�����4�Y%�P�ө'Ԉg��|�b'D�6������ڠ�STBtj�J�NmpM
:z%�GBt�	uCg��C%D�6�������`ס�b����t�g7T�:ԧB�~v�Ae��C}*t�g7T�:Ը�S?��]Р$�����{?��ѩ*>:�A�G�6�����ڠ�KN}��,6:ԠNN}�%���ZK�i��z7T�:TBɩw�AeѠC%��z7T:� KN�*�*��Ի�hСJN�*��Si;�����mr���69�}d���>�MN}�&�����j�%���l�S�{E�E��Prj5T�N��O��bp"Ŗ\Z����)���j<���HC19�*k�5�@G�Ae��1�¤��xPY)8ߋ?y'��i�#�Nb��D���<b�$	N��i���
K'҈�-��:��v��T屷Nb}�1BQ�L�Г'�ݝ�<�����
�Xb��݁�`�&V���������t�F<��z叀4���P	Q��r�GM6����5٠�&T|�d����lp�ev:z��5yBhv:TB��/�yiv:T|�d����lP�Q�*>j�A�GM6��GM6��GM6������&TB�d����@�J����6�;С��&�ǾM�t����o�*xj�[�Z�j�R��c�&v��;С�&�u�U�;p�fw��xeN(���P�R��c�1v:T����i}�:Ԡ�&��~c�4(�e��C%DM~����T���5٠�&���Llt�O���[3�G�a�':�fb��C}*���%06	:Ԉ�&���Ll4Wjj�A%DM6�����E�=6#c�����9��(g��COa~����$�P�S�߶!�$�P���=6#c�����S��c�%6	:TB����}�M���=v_b��C%D�~�^�b��CM��{��&A�q1�L���Klt�������`ס�b��M��=sB�B�&A�]0'+ltx�b��M�׸e���W��	�
�A&t���$�p��.A��/9�}ė��>�KN}�%����-lt8�J&t�%����-�t���S�{.��_r�{υ�_С�KN}�p�:T|ɩ�Z�~A�}ɩ�=�~A�1��S�{.����D�_СJN}���~A�
>9���*���ǎO�t���S?{}�%�5n�S;>�fР<�=��Pr�g���ipgՠ�xeN(��Y6�P�&�>v*c۠Ce���(8`۠C����Nel4(`۠C%���(8`۠C%���(8`���;j_j�S�:�mС�39�����SIN}l�ĶA��ɩ�^vc۠C}*ɩ�^vc۠C%��z�e7�:TBɩ�m��6�0�lN(&�S��{lc���c��6�ۘ����h;Hm���v���c��6�m�m�kV�����=.ɩ�ゑ��=.ɩ�ゑ��=.ɩ߽x��jh&�~�Fr�w/���A�J(9���6Lm��Pr��.~(ɩc�>u�1e��ߘ�O=�oL٧��WS�-u���o�a�U�AK����Zj|5e�R��m-U�1e��,8ws��=�U��Y{3����)/��1s6��    X �Ɔ^�3Sf������OИr)9�[���˭\J�e}�k��L�?�]���5'�ٟ�.A��,j�F�?�]��iԜ�&��jל�f��(n?�aܘ���]�_cBW,s4v	:T|�	]����%�P�5&t�2Gc��C�Ƅ�X�h�4X4�{N�ƙ�sB5N���q���P����j��='T�t�9!M�6v	:� �9�g��Ҥoc��C%t�Hh}_k���[���bBw,V4v	:T��c���KС������]�5�n&t�bEc��Ce{3�;+�*�;'���sB-N�;'���sB-N�;'���sB-N�''�����Z\���P����	���=?�k��#�����H�(��	=�M�aB�q�y��s�tz���`B�q�L�9n:�	=���X0�P�v0���&�ĒCc��C%4~$T���	��&�9�ׄ7'����Z\ޜP�kjqMxsB-��oN�����	��&�9����GB�&�d���lt���	�E�ƞ��kp\jX4�
2�w_jX5�0ޓ	��RòA�� z㡈ƶA�kĳm��+Ȅ�x(��mСJ6��^�m��P���nJNH<�m��=sB��ilt�O%9�<�m���$�~c.��m��:W�6�P�Jr�7��*!:����RöA���NmP�ѩ*>:�A�G�6����5���5����zB�{'�ⴧSTBtj�J�NmP	ѩ*!:�A%D�6�F�6�F�6����VۧF�6����u1�SO��ҩ*[:�AeK�6�l���-�ڠ��S��S��ST�t�	�J�6����uo2��D�P�ѩ��d���С�S׽�|c�C�G��{���6B��t�7�ol#4�>:uݛ�7�:�ФS׽�|c����t��<��`�Y&T���ڠ��ST�tj��tj��tj�
�N=a\5����ڠ�SWm8��E8Q�*��Ti�U�7�N�Di�U�76N�aL���p��}p"%I����|c��1�A���|c�1%B{���|c�ଣ�k
kVA���5����=M���:��N��*k����}Ma��Am�:TB�g�J��lP	Q�.�e���1G��A��9���d��C}*�g��T(���P�>�9!����vС>��:OX;�P	Q����NH�Q��H�Q��H�Q��H�Q��H�Q��HØ��EĔ�/RXT�y��4�ɔEy2BOnǜ�+s(1�ÆA����܎96:T�����6:�(�'�c·�cғ�1�ÆA��z͆A�J��lP	ѓ�D\��ɓ�3�%Oo�xF,ñ]И>*�d�<hȓi�S�'� �O��z�eq��O�\(Ǔ)��dʅj�e��RA��Ws2��RA�ʛjlP�S�*q��A�Tc�:��:�xB7Kg?ҾSQ��{ܩ���=�TT��w*�q{�;ո�ǝ�j�޽��RA��T��w*�q{�jK*!��A%D56��(����v�]�TСޓ�܎�K�
:ԧBMn��%K�S�*�w/��TС�-m�s�,4Wn�r;�.Y*8��b�����`��`��`�/��ނ��5K���_���.�,�0�Y*�P	ј�1��ZA�J��܏yDV:TB4���K�t�*!s��%�:TB4f�K�38���âA�ʖ���3W�E��-���g��*[Zs��EcѠC�>�s��\5��G{����ƢA�J�ݏ�:�W�b&�M��-5�39�t�l�ѽ���:Ը�F�c&�}�c�R��1���A���h�J�mP	Q��~���vС>jtߏU5V:�{R��~���~С>�to{���5��}?V�XChP�B�J�6mP	Q�*!��l���)��gi����b��]�<�ڠ��S��@�6�ӁNmP�ө��O�����FG�����ѩ{?ntt�ޏ����FG�����ѩ{�f�#t��I�����ѩ{�fl$t������ڠ�S\~�V�	c֒���=sB1k�VB��T�����d+�C}*t���J[	j�ҩ�1k�VB�q�S�c֒�����pl%t�����ڠ�KN}�u8�:��е���J�p�L���pl%4��-[	',z]Χ
�t�Џl�r2�%��� �'z�r&k@��p"���U	VSɟ�X�`������e����Tc�Cř�y?$�X@�P�&}~♇�B�hI��CR��c�%}�I5:TBI��=��B�ze��gϼ��С�M���:T�I���F�B��I��=��B�1j�>?{��5n�>?{���P���Tc�C}*I��sP���=��~���С>���c����СF|���Tc�A�*���c����СJ��Ɵ�	Ŝ*��ϻ����С�O�<�����СN��ϻ����Р���SҔ��������������������
���4)�_��H]�"�AY���qHW�LyP�g1���U٠�*TdTe�
��lP�Q�j0Q�j0Q�*<��1����U٠��Te�J��|�X�bנ1�NQ�,�&㩱�ŢAcʜ�<�"�$O��JG�Lc��<��!�.��4�raà�*�s��:�W�dbf���`�&fVX0�����B ��̂A�+X�$�`С�.\����٠�2���S�3��dBm��S�3ԧBg6�;��	��n,4��3*!:�A%Dg6����_�9,t�?Kg6�?Kg6����<�٠��3��@g6�Ӂ�lP�ә'�u��sB.~���A�J��lP	љ*!:�A%Dg6����54��54����y��t���c��lP	љ*!:�A%Dg6������٠��٠��٠�3Oc��lP	љ�Jg�*kxK*[:�AeKg6�l���mr�{{�j�%o����*����^�b��C%�����-�t���C�{���_��{O���С�K}��|�:��L}�����}��{O���С�f��;��h�"��[��G?�f%�~�J���<�94+y�shV�g/`��С�mR��Ь���^�b�C%�l��X�"�0fTXE�0^��V:�9��Qa��[0's��"t�5��zeN(��YE��HH�[V:TBɩ���Lhl�b��*Ȅ�6)V:��dBc���SIN=�����	�mR�"4�+5�*����/��XE�P	%��Gs>�'�#��Q�ɥ�fqX@8��N=�2����4��C��x�Yc���y���wС"�@T(h���mP�P�*
�A�C
�A�C
�AD��0�!���&{*!
�A%D�6��(��ڠ�@��@� �@TB�	cQ�*!
�A]?)�_;�b�CeK�6�l)��-ڠ��@T�h�}h�}h�ʖ=����t��(�_s��t��(�ڠ�@T|h���mPC�mPC�mP�Q�'�[;ڠ�@�Ф@TB�n�b�CO�6�	�é(�<ڠ��@Ը�@Ը�@T��	�I�6��(���c����9��Aa�CeK�6�l)��-ڠ5����t��e�A]o�;��HH�[�:lz叄4�����#�x�'�*4�w{�{Q�G���m��B5�5��48�ЫzB�����/�ځi��dС"�-T(�e����lP�Ж*ڲ�G0��,t����� �1TBtf����q�;�)Yz�d
��<�r�9O�X�Γ)U��dq4��4�(Γ)Rz���jAcʅ�<��͂��y���*7Z��;�76:Tr��q�y6:�x�5���zc��A� �*!Z�A�GZ�A%Dk��&�,�P�Ӛ��	6:T��q�l�͂<�y����j�Қ��	6�aKk6��h���٠�5��Suc�����9����fA�
��<�NՍ͂<�y����fA���w�nl4#��<+��Ek6��h���٠�5TB�f�J��lPC��lPC��lP	њ'��8�٠�5TB�f�J��l��PrB�    ̓���汷�nlt�O��<�6֍���Кǻ��A�P��<�6֍-��h�coc�XC8+\�!tX�����x	^?�-x��kP�����+��
��z��	�)k*!�A%D�6��h��=ڠ�H|sB1��B�J�"=�.��!t��(��
��p>|��B�ʖ"mP�R�*[��AeK�6�l)�5�h�5����-]zB]RYC�P	Ѧ��%K'Rtt�7~A�M��_P�|p"EF�~���Y<8��"��_P�t�Y���_P�rИF!�y2%B{�^���:T̴g��g�Kۏ��pС¦=Tܴg���g���g�
��<a�PڳA%D{6��h����=~���A�������M*x��{�&���<��m{����5�i���4��N{��G;*!ڳA%D{6��h���٠�=�Ф=�Ф=TB��	��M{6��h���٠�=\>���	�,�{��,�S�=ԧB{6�O��lP��lP��lP�
�y��ڳA%D{�
s�<*>ڳA�G{6��h��������נf�áW2�k�<�z���	�k(V��P|e��.����,t���=_{>���� c�C%������,t���=_{>������p}:T�ɞ���,t�l�=���Y8�P�&{��:j�%{���pР.�,t���=?�d�Cŗ����$*�d���%Y8�P�%{��c*,t������$����A�J(y��Sa�C%���?
��H�å'�?�R�0�7Dz"���H#=��)z"���C� �~ġ<�����݂Ɣȕ��-��W%V�,�0�2�lt�����j�j��9�X-`��C} w(V�,�P	A�緇P}6:T|�g����P�A�*>ȳC�yv��yv��yv�� �c@??����{ �*�''��,�P�P|`��C�7rB1s�fA�}#'��,h0F���P���#���	�Uw0��U�͂�˄�V}6:T�/�[��,�P��L��*v:Ը}�Pݪ�~A�aV���`NH�:{�+sB���5���=��m��-�Ҵ~gߠCԝ����ʒҴ~g�C%T~$�,��tС*?*J�0��=:{�S)L��w���A��L��w���A��T*j���=�p�L��w���A��J��=�P	�	%T$�J�	�Ig��C�ٖ����A�
���Ť�{С�o9!-Btv:���rB�b��=h���ИP���݃��٠�>TBh�J�
mP	Q�jhR�jhR�*!�􄷆&eڠ�NTB�i�J�Bm��C�Q�2;���PN'�-g�O�.=�R�r.�$��_��J��"�S:��3�A�C� �@O�<��e�䨳gС�J��r��3�P�%�?9��t�ؒ?��KgϠC����'G�=�c '�?9����ĭ)��_":{*���w|���t���?��%��gС�]��;�:{*���w�t�:TBɟ�x���gСJ���
YgϠC�����ΞA�
>��+d�=�|��'V�:{j�&~b���g�`8A���G�ɟ��N����o�=��`NH�0:{v����at�:�sBZL��t�5{�zeNH�	�=��P��'H��t���?O���?��u�:ԧ��y�T��g�a�'�?���t�O%�󈅷ΞA�kĳgС>���#�:{*���#�:{*���c�`Ϡ���9�����A�
>���_?�3�P�'����3�P�C�籿~�gР�������f�:TBɟ���:{*�����p�=��P��7��:{jh&޿���4��1{*���olp��3�P	%~�k�J��w7aϠC�g��w7aϠC}*ɡ��݄=���$�~c]��gС�mr�w7aϠ���'�~�w�΍#=�d
�F=���PO���ӓ)9��d
�6=�F3ez2f��dJ�*�eq��IO�\(ғ)z�dʅ=��1-���G�n���Ѣ[?�{��֏�-���G�n���Ѣ[����fA�ƴ�֏�-���h�lt��h����P�-�P�Ѣ*>Z�A�G�6��h�-ڠF3-ڠ�3-ڠ�EO�fZt���-�]�݋ݮ��E�n�����/��PܽX8���	Ť/�zeN(&}Y8��HH��X88����,t��e��&Ȅ��U����--ڠ��E\�����^Ʉ��U���u9e�C%D�n��!���-��_�t:T|���Y8�P�Ѣ۽'`Y9�PC���/C:k����A�J�mPC�mP	Ѣ�ҿ��~��uV���������%��(��l!�G�_ga_��--z���+i�G�_ga�ҿ-�(��l!�Q�g0'����PNG�ҟ����}�G/eg�`�^����n���L4�i��K��:��Ki�GʃƬ^��P�'S"���	u�hE��G+Zg�`?Z�:��ъ��<؏V����~��uv�Պ�'e~�����~��uv�hE��&kޭh�݃�P��76C��t�,�݃�h���G�`g�`?;��� ��=؏����~4vv�� �`N(&��=؏�����$�
��hb���G[g�`?��:������=؏&����~4�uv����	Q�W����|4�uv�hb����|��uv��ͯ�{�m~�݃�h����G�_g�`?��:��j�3�������ÜP��{�����T�݃ץ�݃�8!#�=�
2��#�=�2��#�=��dBe/F�{���+�Pً�4�K*�*!���l�{С�<T|�g����lP�Q�*>ʳAMʳAMʳA�Gy�P�>v:TB�g���g�J��|� vv����{�=��݃�����G`g�`?z ;����l)ϫp��	�����=�3>�����=أ�`N(f_�=؏�����~�Wvv�����{����݃����쫿r��P̾�{����݃=�+�H(��LG��T���}ڠ�P�i�݃��L���GeZg�`?*�:��Q���=؏ʴ����*�<x:��L[�dB�2��{�Ge�̖N}T�uv:TBtj�J�Nm��PrBao��G�`g�`?�;��Q/��=؏z����~�vv�U/�`N�ŹB�>�;�{���P|*t�+�P�yp"EG���5['Rlt�+�P�qp"EF���?cZ���iӡ��BͦA;d�`
���P�gИ�>ϣ�QH}6�̡�!�٠�>T��g����lP���lp�B�:\��fРF!k�	�͚A�M������,��q�[2��p�4o�xF,ñl��%�pF,ñn����46�:&3b�����:��Acʅ�<�r�2O�\h��E"κA���4f���4f�ʛ�lP�Ә*q��G�ǰ���nСB�1ۀ�@c��i�:TB4�똦aݠC%Dc��i�:TB4��ݫi�t�QIc��i��՗u���٠�1TB4f��X78aX��{���X7�P�
�٠>�A}*4f��4f��4f��Th�ƕ��lP	ј�cj�u���>��X7�P�ј�cj�u�����E:�:Ԡ�1�����Ŗ�<�^��Q:��/R6t�/R24�/R.��/R*��/Ґ�#�����x�F�x2�A;�L@9����lt�()���m�'��>��mС"� �u?-��A�h����N̶A�1�(���m��e�����lP��/T�f�ʖ�lP�Ҙ*[�AX�AY�AeKc�0F-�٠�1\㖽�WB,t��PۋmltX�Pۋmlt�Ʉ�^lc��[�	�����A�kĳy��+Ȅ�^lc�C%Dq6��h���y�]�gsBqOc����9����yС��>T��g��`N(�;�<�P�S�'��yp��b҅̓���>&]�<�P	Q��c҅̓����{Ɍ̓54���1���A���yС�>TB�g�J��l��PrB���A�zO�A�'�٠>�A}*�g��T��5n��5n����P�'�e �  �̓��y��E|�g����lP�Q�*����^�c�Cŗ���+qlt�A����+ql4�ۤ��v06:TBI���`lt���>_���<�P	%�����j�%�����y�`\�J_���<�P��t���'lt�l�Q?{��̓�mr�gϟ�yС�MN��� �<�P�/9���O�<h0F_r�g���̓�Pr��]%�~��Ur��]%�~��Ur��]%�~��Ur�g��yС�mr��]%�~��*���O���<�P	%�~�v� {�̓ק��A�M�	�=���A�� {�̓׈g�áW2��g^�<hP��A�E����$�̓�Pr�otlt6'7:6:T�ɩǾѱyС�ON=�F�`N���<�P�'��F�������������]      M      x�u�M����5��@;A ��H[?�	��aExCyc�٤�V+���(Z�
��Ŝ��2�eZ��ɮ~�
`�﾿�.?��������[�/��q���]�0t�.��H���|����v�������x9^ߗlyf��ݗ���ڽ=�O�O����0I8v��O�On��ǧ�a��K�o�O��{{?�~����8�N�r���>��%y-�����ñ�ȥ���ݗ�_�w��o��g�D�����{#/���l���;�w��Ow�r��~z:]��.�/�����辻]����.�=^u?�?;?�x>^o�������˵�&R����������-���kk��=x9]>��x��|�����/����eN^�sc�Wy�ݷ?���O��P^ޜ���ϗ��I>����r|�/ �����?O����-G�|��ݻ����.ߞ���?x����;_�7��|��"�n%\wx�î���ۗ��]�q�ޕ|�����������p�%5�/䭼�����/}�c�(ު�*�;~�ߥ���~�4��{���y	����z�΋v�8�>`�|�����ce������*�)��r��Z�ǒO�^$����?K4�ڔ����ڽ���Q�UӾ��)���,��W�/��IM��X��7#��'y/�^>�r�7<�������E^�����ӱ��.�4t_���������
������t_��y{��/;�=���)>ɺ�}��x9���������k;��1_e]����%�ua'�{<߮�KW�\��N�Fw,���ϫ�X�%��]V������w��X�e��}��n��Uw�y��@4K��D�f]��}������܏�C$����>�:Ds�{�S�!�κl��F��~���_B�H���;�~�Ctn_�z��q��F/����%�����/�����U�d��C��{뷥��_B�{�k�KL�_�݊_���M���^���s�Kl�z]�_Rn��������_�z*#M��r��/C��c�k�K����n�/a��P��d^�\���%�ާr�����^���y�ݞʀu��\�Z�S�k�Kƽ_�ݚ_��C��◐���},q���ݵ�%���n�/Q-�X탮�ٛ?�{n~����۵�%���j��ث�;=���m�s��������Ƭ�z����n�/���}I�u�X�K��;ĚxXvm�X�KַB�/���~Hm�P�K�_u5��c�!T�����xj:��_ҹ�j}I�����?^w�%BՏ�����s�'ɽ�c���Gn�O��������i���d#�@��\��b�sǫ��pϛ�(Ě�
HZw ��3��oy5 #��,�T� �|�������+P٫Ȝ���f��}�����3H]�|�@R���7��	���&�~�����& &j�	0���		���G�)2p�+�*~�a�!V�P�l�P�gb�+�Mo������m@��@�e�ۦ�P���t�����3F��Bº9�1#��=CN`d��!"����!'0�_�I��1�I����Q�|��!'��=C^`jY�i!�^�{���X�"z���ˀ{� d-��n�@P.��U��A��Z,�^ �w�
�*$�y���E� {!i�6T��̊%Lq`^`�z�H�l��E�Z`�h�(���@j[� Y�Z�Y��E#��!����!Y�Z����@�@J\8�rӢ� ��#�0�@�"��^ U/��!yQ=�z���F�
�j�̴pL��E{	�
a,+���j�̵�����1/00�zƴ@��zƸ��w�gL��g�
�C�3���3����!/00ƞ!/��g�
dӺg�L�=C^`dY������i���k��%�{� c�ذh8P/0`^L
D$E� �@��%�\` p0P-0S� L��� K!I�Y�8�``����Y����L�H7V2�'U�Y�Z�f�bk�,s+Z��p/��Bb�^�f�jE� YnZ2H�@�@HV�̘���R�"z0�D�"��Z -Z�
$��F��,غ�`�H�āZ�̬h�9!�T0�-��X�m-X�a��T10-�O�1+��1,/[=c^Ȁo/JϘ��UϐV=C\` m�i����gH��gH
$���!0025=CZ ��z������Y!q��(=CX`���A�� y}��x������(�����q��nEE�M������E�@��=�����+�2P�у�r�"Z�^ g/\�� A��}*A d,0c;�ʁb�̱p����d��8�Z v-�BR�Y�R�"x�,6-؃�Bâ�@�� �Q=0-0`ZD2����hƅ��V R+X�i��9�r�{!c��`�ޅB�V8�Rׂ�X m� �e��S
�@�@�\���i�gL��f��Xb��ւzƸ@ܯ{������q�<m�q��}������g��S�3��y�3���gH��CZ=��=CX`�Y7d/&q/*Y
d.s�Z �Q��q��r5H6�ZD	��㳋[xv��J=000S��d-$��.E2�//U
�
�lE����=� ���΂<�V`�XA��܊��y���E� Y�X��
��
�@��ܶU��c�$K�;L��l�b��� LL�т�b֢z0Z\�� (�����@T�`��`�Ƣ��Ш ���k`V t+ī�P���,u�[�j���p��vϘ���1)�-�1-$����q��_�i�����yj{��@���3c���a�3���3d�y�3�&��g�
�W;��3df�U���,aU"P��@�7�Jr�� 0)W)���S�[x,(�B�X`�bA���:E	2�w����Rs�P(��G�9��T����	� ;���D#�Z�ܭ��,A��:$�R w)��Bb�V��������dfE� C�Ԡ��I
�����KQ�L #&F)T�2u�!0'U'��O��-E� C��@A��̉*�A��ނ
d)��R�cY꾫 	
���6C`V`bj{Ɣ@8o�I�|���Br�XPϘ��Uϐ�gH	d�7z����~�3$Ʀg�
ć�3��)�A�t^�9����rb~ط{
�r3�D� [��@�1�X`�����
���@L�,n��6Bwb�@�#��@�Z��Bi`X`¾Ed)$����A��?���Ö�(0)0P�`�ō�Y�-��a=a�HM�`A�ԭd*;��J!��-0-���d�Q1�V 6+�jb��``P 6(	2�	�`��HA��T�����-�J�;
� K��H�(��S���@�V0Y
��=k0��n[����kQ(0'�M[=cV``���˺g�
�}[A=cV �Cϐ���!.0��z����~�3�&F��١���z��@8�z������I!q���=CZ`��@E���NF܋��Ày@(��S�[x�����J��C�F�@��a�9>�$��s��oE~�y1#����$�䂞�C���B9C���p�&�]4!�L�G�AO�a�NTT�I:�t��y�t(z�������/GE!ʡ:��F���!u@"���h���C�lB���v�1F�=`��a(F(����rVq'���
	K1��{�����Cnw��r��a�X�A;�u��L�A;�g�����ý(��UL�~��f��;��]�g�0���ȏ�I^�l��C��[]�g�04�]���0�6����aj�t��C>�.��xH���,�)t��C:�����ab��">��{ۭH�">����K�Cu��>�%꡺`�r����,�#��G�	:��P^0�DU�(�`��R�p\0`�9�'뎄�P[�-$G�i<�Gv�/���6��G4��C~Z��(� v]*���<�ߥj�P_0�0�mBx�.� *  ]��G�ץ꡴ 4Z"�/��ۂ���P[��-희�-�G����v�-Ȫ-��V/=�|�.(�����Qq<��Iy�����֗��h�W	x]�[d��i��\L�]�``�]�H�ە�EF�U�.�V]ļ`"���m�Ⱦ�"�#wۂ���mA<�.b[�Λ]ľ`ji��q���1�[��`���P[p4�>��g�9���GcG�#��� ����#�WĆʂ8��rZ0CF��m[����]�CeA\O�7�.�`]�NF�4��<_�c<��[��BR���pY���:��.�����(���~���p[W[��S���Cq���BpY��,n�˂����C���}��BzY�,U�!��
t�|�ƅ�PY۾��(� ���L��	ץ��� \������x:
.���m����En&榋���f9/��<��]� ��]ĸ`d�]Ĳ N]Ĵ`f�t˂|�.bYb�,��U�.���]Ĵ`di��e��cu@P��m�������t���      N      x�M�[�+)�l���7��_������d���z�7�rɬ"C �����o�{��=�{X�a���ƯG=~O4���c�ϣ��#*#*$*%*&*'+'������գ�c�ǿ�Y��rg��ʝ�;+wV��Y��rg��%�/�=�{����kx#�X�ݨ�1~�~�q��Ͳββββββββββ��{e���(D�rt���5�kD׈�]#�Fv��g�[��`���=����^��7����؍S��/�3���+D���������������������g��G��ވ�_���5�kd�Ȯ�]#�Fv���5�k����(����w�7��F4���Q�6~�~��=��Y��Z��:ku���Y��Vg��Z��:ku���7�`oD!���kD׈�]#�Ft���5�kd?s~��w���_���ݡ�Cw����;tw���ݡ�C��7�?��O�7��F4���QY>~�~��=���5����K��P2ɥ�RZҖN�.J�ț1�O&y)~�{�I.��Ғ��]b�$e����r�r�r�r�r�r�r�r�r�r�r�r���o\6ɥh��E�U�U�U�U�U�U�U�U�U*#_��Q;��5�j0�`��T��S�L5�j0�`�����7��O:��W���I��)�CF?�x�^=x�o|������1�1�q���S�wW���}J�}�����oJ&�RJKڒ����W��^H�\��w�v���z��ވF6Vc7N�n{�g���~/^��*0�`��P��C-�j�*2^˗������������������������������ܩܩܩܩܩܩܩܩܩ��rmߋ����������ǒI.��Ғ�tZ��XRƸ���������������������������^;�£�R��md��F-�\
)�%m鴾��_o����w��򒩋��������������������U���26z˴Lr)����������eZ7��n��KQr�r�r�r�r�r�r�r�r�r�r��j5�T�k`j`j`j`j`j`j`j`j`j`j`j`��]�=�����������D5�{��r)J�������%�\
)�%m鴾�����~�e�K�.�.�.�.�.�.�.�.�.�.�.Q]�m�Ж	m�Ж	m�Ж	m�Ж	m�Ж	m�Ж������Lɥ(��w��6��M�G�������I�����W>�ʧ^��+�z�S�|�O��W>�ʧ^�����-'�k�k�k�~.�����qJS���;�5��wbx#\=Z=z=F=f=�z��x���.�3�����+\����I.��Ғ���T|*#oF�{��R��[CuSrJ&�RJK��i}��J�7#�^ٶ\�ҽw�n�ƔLr)�����nuo"����ջ���m����Z&�RJK��i}fo����uG���o�n��RH)-iK����-e���n贼toޱ��7,��RH)-iK��u))c܌����w���w�2ɥ�RZҖ��w�RF�v�+�\���;]{�k�t흮�ӵw��N����;]{�k�t��/��;K^��j��}W5-�\
)�%m��|W5-e���ߖIm�ԖIm�ԖIm�ԖIm�ԖIm�ԖIm������Ͼ��e�K!���-u�7R��1nF�[?-/��~�_z�^���~�_z�^���~�_z�^��o�{E����~�v�$�BJiI[�ߨ�RFތ���w˩�R��+�x�1�V%�\
)�%m鴾V%e��Xv�([^���jQ�ݠ�;��;yt��g�)�]���.y�K�G���.y�K�G���.y�K����K�\
���:��������t��.�Ϝ���NBi��ֿWh�ވF6Vc7N���Z��<oh�S�S�S�LU��0Ub��T��SE�k2�5�����I.��Ғ�tZ�;0�;غ���P-��djejejejejejejejejejeje��������k��;�-�\
)�%m鴾��;���a����e�K!���-u�)הk/�{�/M��w����j��RH)-iK��m��2�Ͱy���\\\\\\\\\\\�5�o�j���w��a�$�BJiI[:�����n���;K.E)�*�*�*�*�*�*�*�*�*�*�*^��N�O��L�5ܺk�u�p���]í��[w��n�5ܺk�u�p��{	��rC���Pn(7���r��~o!�I^�o��^a�$�BJiI[:��V�+l���f�U��NWv=vn�vf'v������S�F����@��E�$�BJiI[:�o[���7�ֽ~jyIU�DE�C5�B%�A�@^�\o�ݿ�I.��Ғ�tZ_����n��;N�����������厗;ߝ�����w&�G�G�ǨǬ�U��O=~o����
�)㾕��]/UZL�$�BJiI[���z����>�߱-����ڵ���hdc5v��.����}�����o\z��K-�\
)�%m�k|�RK�f��k�S��d�K!���-�֗[RƸ����R������o4j��RH)-iK���Z�ț񽻘Vw�˯NѠÀ	���w�˯�R������РÀ	�P|� i�yܱI�漯��CX4�0`�7<�}uf��K�u�fћoj�;��&4�0`�7T�7G�H�xi���c�̢A�.��o�Z|i�����0�w���gw�NӠÀ	�P%��&i�Ҿ7&Ӛv�x�A�.��o�c_|i�{�3��V�r��L%=�xO��N-*y���!��!��!��!��!��!��W��e过ʄ��������z�j�Z�J�2�e��N/��w�/���1�8����_�c|q�/���1�8���ŝ��t�7�,�� �@�b Y �d1�,�� �@�WZ���}s�o���9�7���p���}s�o�}߿���7�A�.��:�񃤍��w�5�Ao~��ze���WW�^_1{���5�WY�^g1��bj���j���Ow���5#t0�����(c�&��a4����c�e�K!���-�֝����^�[���Q�hc�1���FF%��Q�heԲ�o�ȘZ�!t0��n4-�_Z-�F�)�tJ:%��NI��S�)�tJz��7�x���� �A�.��o-_Z-)u�:A��NP'��	�u�:A��:������hޫ�E$�A�.��ﾮe%�K��%�7�fA��Y�,h4�͂fA��YT�5�ԩ�'�A�.���&�R��r�a4��(�P9US1�R)U���Ϫ��W�<��)�A�.����b�M�h@�'�p��&���]�ƍ'o��+����A�.���VM���Rc-��٠٠٠٠٠٠٠٠٠٠٨f�N��ʖ�A�.���=�I�xi���X�b,sy�����������������������Ur�7�<�s���i�a��nxĻ�X��|is�¸�4�0`�7T�I�I�Yƻ�*z��7�&���hdc5v�4�-�=�������)�_%�a�a��n�*���$-_��!��FF�v��-�\
)�%m�n����zo5M�[�B���Plt0��ԽPl�6^�|kk�kq�h�a��nx���h���Ҿ��?����L����pρM��K����޼'>ײѠÀ	������߈/�V��)ǄL����sO|M�����6F�CKrD�&\p�#~%���K��9�7�͆:��������z�z�񞼦��CӠÀ	����w�/�����W�������~�z�v�r�n�j��|�·O�,����������������������Z�S�'��6�L����sO�M�����a4�5uh	�h�a��nx�[RkyėV�yDo�3fMc�Mh�a��n�f���$m�����m�O�L���G����|i��Gt�w�N��i28M���4�&��dp�N��i28M����4=h��L���G�u���|iQ�j��oB�&\pCux'�䄙�0�Z�w�,z�c\ˆ
��F4���q_���C���oQ�+�7!�?�.���8]�2^m����\:��+���H4�0`�7<�W�I�xi��Ht͠dP    2(�J%��AɠdP2(U�.}��f���L���G���&i���;���A��C�!�t:�Q�w�Ҡ7�(��I4�0`�7<��XZ�$��Z�T�?7TD5TBT@�
'��J��3ɥh݁�I�Y�i�y�������k]��M�ыZ����D#
ч:զ�,��&�f����&�f����&�\}<k�h�a��n����:D��Ʀ7��t��|������������������������������~�8�3�3�3�3�3�3�3�3�3�3�3��7k��\:�潾^Z�$t0��nM�l_Z�m�9i6i6i6i6i6i6i6i6i6i6i6�Y�J5i~0k~0m~0o~0q~0s~0u~0w~0y~0{~0}�c-�F�(i�4J%��FI��Q�(i�4JZ����%�o���΍G�ƣs�ѹ���xtn<:7��΍G���k�Z޺ۯ��G�u~��Q�G��~t����~M��K��<���h	�h�a��nx��Ak�ėV��D�ѼH��YMh�a��n����IZ������cc�a�9�1�1�0�Ƙ�scc�a�9�1箴�ϔ�te+Y�JU&����|�{)T��A#�a9� ��0�F��rA#�a9� G�����*��j*��j�*��ȗ1�;��\��=�N�����w8�N�����w8�N�����w��JtͷCv��}ء;�a�>�Ї��Cv��}ء�����񻎜?-�:�p���}�W��|i�-��~z?�i�a��n��������}��0�M�ʹHK4�0`�7<�m��Z�K��Z���l�5:�p�U�~J[��|i#��5F�oI-�:�p��xKj����j�����in�w�ǹ5:�p���~�[����ƻ�0Z�%t0��:Z&�4;�W;{��W;{��W;{��W;{��W;{��W;{�]M���7����	Lkx#�X��8����	L���o�X�<���Mh���	�PU�.A��6�&y���g8�Lr)����������3�Z/�ky+�S�?m�S�}(��F����N�
Z��z�[M6����L���G�M��ėV+�D�!�?RA�S9US1�R)*�������U�.4��L/ѠÀ	����j��/-�g��Ҁ�O:�dM2���wE�&y��S��D�&\p�#�V��$��ZE&zs�l�l�l�l�l�l�l�l�l�l�lT��V��L���G���&i��*2�a4'%'%'%'%'%'%'%'%'%'%'%g��w��x���V��L���G��M��ė��j�:�p��a�a�aV;�W�y�2���L���G�K��ėV�ˊF��QǨc�1�u�:F��QǪ�7[��\:���\�L.C&�!�ː�e��2dr2��\�L.C&�!Sk�D��tJ:%��NI��S�)�tJ:%��^%}ֆ}+������Jdr%2��\�L�D&W"�+�ɕ��Jdr%2�Z3������tp:8�N��������߽sћ��֬`oD#����m�f���o�Y�n�z��� "`�7T��Y���K���E�!~��ך�Lr)�����Ӻ�z�Y�e�W���_S������
C��{�'��V"ײ2ѠÀ	��������/������W�������~�z�v�r�n�j��|i�{��ZI&t0��LZI&��ZIV���5=&4�0`�7T�{��$-_Z���C�a4�5�k%�h�a��nx�[R+�ėV+�D��f?��h��ُf?��h��٠� m��|3��k%�h�a��nx��A+�ėV+�D��|�p�	�p�	�p�	�p�	�p�	�p�	�u�ۄ��J۵�L4�0`�7<⭣�e�K�V�m��6�m��6�m��6�m��6�m��6�m���u��nEoޫ��j3ѠÀ	���߫�$-_Z�6]��?��h��ُf?��h��ُf�f�����}}�M�:�p��x;h���j���0�o6�`6�`6�`6�`6�`6�-�6�8x�h��h�a��nx�[G��ė6Wm��v�l��v�l��v�l��v�l��v�l��v{��Ao~[�V���hdc5v�4�٫�Z������B�5���
���2�e�w;��R�n�T�T�T�T�T�T�T�T�T�T�T+���okz_���/ޫڦA�.��Jݫ�&i㥍����2ѠÀ	�������2�������it0��ý�i�6^ڨ;eMo�C�C�C�C�C�C�C�C�C�C�C3���BP'��	�u�:A��NR'I˗6��Y�a�_ɥ�e�A�.����M����2ћ�����(jt0��ٽ(j�6^ڬ;{k�a�a�a�a�a�a�a�a�a�a�Ak�D�!�,(�J%��AɠdP2)���K�On.���h�A�.���k�h�K�h���:A��NP'��	�u�:IZ��Y�ϚC�%��NI��S�)�tJ:%��NI����޼�JK�E�&\pC5��JM��K�^�A��C�!�t:�A�����C�YP2(�J%��AɠdR2I˗V�ݼu�:I��NR'���I�$u�:I���]���)_�d7��Te*q(p��{����-����o��~�|�[��"�����w�E��-�ȷ�"�z�|�J�֏���РÀ	ܐ*��BZ��>���\:�~�V��L���G�_F��f�K��f��hNJNJNJNJNJNJNJNJNJNJNJ�*飾�s�[[�7:�p���XM��������äääääääääì�Ԣ�wc�6zӠÀ	���wc�6z��J��QǨc�1�u�:F��QǨcԱ��uc��0�ok�>{ӠÀ	���wk�>{��
4ћF3����hf43�͌fF3���̪��,�tH:$�I��C�!�tH:$�j4������tp:8�N���������Z�Ż��yӠÀ	���w���K��hŠNP'��	�u�:A��NP'�U���Z�a4�����A�.�������K��h�7�fA��Y�,h4�͂fA��YT����y�M4�0`�7<�݄Z�&��Z�&:����
��*�Z*�J4�P�yp]������Z&�RJK��i}_�:z�Y�e�ug-oݙ���,��A�.��J�񃤍�V���Pv��h�a��nx��A��ėV��D�Ѽ_j>��<&4�0`�7T����M��e}������;:�p��x�hݙ���S\?}_r^4�0`�7T��e�E��K�����k.��Z��D�&\p�#�fZ�&��Z�V�_B_�bB�&\pCչ�F�$-_����i�a��5��4ѠÀ	����5��4���4�a4�פ����РÀ	�P%���7I˗����w�N�N:�p����i��/���������M�&\pCu�_��$m����fћ~�iu�h�a��nx��L��ėV�ӊ��էf��L����s�e�IZ���sӠ�h�|ju�h�a��nx�[R��ėV��Do�7ՊN�QuQ��1���=y}��M-D:�p��x_-D_Z�ڪ����A�.��:��&i㥭��Gt�Y-D+X����j��i|5���ޓ��h�;�#kӠÀ	�PU&]&ef��5�6F��u���Lr)���������h������5)3i3�3�3)4i4�4�4)5i5�5��|��tY4�0`�7<��h��,��Z�&:��Q�(i�4J%��FI��Q�(i��*9����^`����L���G��[��|i��¹�ht0������`ա>�Y��ݫ]7�E�&\p�#�f�y,��Z�&z�i�4s�9͜fN3����i�4s�y5�u)��c,t0��ە]w�ŗV��D��J%��AɠdP2(�J%��Q%���o_�mbѠÀ	���w��6��Ҿ�C�!�t:�A��C�!�ա>�Y�潔v-V:�p��x7���/����U�"�PP���&����0&���#�~�h�a��nx��O��ŗV��D������������� �
  U���ߞ��ĢA�.�����KK�V�E�&\pCuttա>�Yt���:Ի{g-J+x#�X��8�o�d/Jk�'��JwX��РÀ	�PU��$-_��PF�v�Ei-�\
)�%m�n�^��zoQZ�[w�}�xGڦA�.��Jݑ�I�xi�V�ݯʭC�i�a��nx��A+�ėV+�D�Ѽ���gwxmt0���^���K���4��>0H��D�&\p�#��L��ėV�֊���f�ǄL����s/���K�߻��t�wrв5ѠÀ	��������/����޼#pM��Mh�a��n�fwn�6^Z}P�����L���G��lM|i�lMt�;�v�ݦA�.��J�a�IZ���t��;)hٚh�a��nx�[G��ė6�X��W�?6��d�*U�J
z���}�s�[��_Z�&t0��{���K��i�7���~�-M�&\pC5�CK���Ң�_�C�E�&\p�#�Z�&��Z�&:�潖���	:�p�U�^K6I˗V�\��9��n|���)�Ƨ���n|���)�Ƨ���n|���)��oC�����L����p��&i�Շ:������=���q�_���z�����w�����ǭ���z���q����#*�G�ϠÀ	�PU�.F�6��ƈ��h~����j-�\
)�%m鴾=f�r���x��Z�2�m�:F���Ȩdt2J��ZV��S�m�gbӠÀ	����&6_���5�K4�0`�7T�����C���y���j�A�.���.��j�K��jŠNP'��	�u�:A��NP'�U�&~��y/�����L���G��f��|i�\M�f�,h4�͂fA��Y�,h4�j6�$y�\M4�0`�7<�	����V��D���?�`C�TM�TK�T�F�>�#�K�F���4ѠÀ	�������/��uuuuuuuuuuuF���=4F�=���L���G�{���/����44444444444�l�)�ha�h�a��nxĻ	�0M|i�0Mt�I�I�I�I�I�I�I�I�I�I�I�Y%�#���<��i�A�.���v��4�ŨQ��1M�&\pCu�t�t�ա>�Z����W���F4���q[������z��w�؉Axt0���w�(��/m�{�Qt����W�)t0��{�����V��D���N��ϾS�h�a��n���)S$-_��%�i��ŤC��D�&\p�#�:Z�&��|��R?�߄L�����I/�>[��ʹ^M4�0`�7<�m��j�K��j��BĄL��������K3�7E�ќ��֫�L���G�%�^M|i�^M�&��P'5R�Q5Q��C�=ޓ[�3���:�p��x_��-��5ꔘ��SbrJLN��)19%&��䔘��SbrJ|_�9z�o3-M:�p��x�ii���jiZ����ypq\����ypq\����ypq\wnt�7v�f�h�a��nx�[R7+ėV7+Do���D�9QnN����D�9QnN����D�9QnN��݄Ft�B4�0`�7<���;�K�;��h�����x8;Ύ�����x8;Ύ�����x8;Ύw]�;;^~m���Lr)�������JX/Xk���`��-���Ʃ��q
9��JN'���ʩ��+ނ57-X:�p����CM��K�k��h%��AɠdP2(�J%��Aɨ����yO��k�A�.���vӂ5��]��A��C�!�t:�A����Ϣ7i�δzgZ�3�ޙV�L�w��;��i�δzgZ��Z�V�?7TD5TBT@�
'��J��2ɥh�}m41ܙ�Lw&�;Ý����pgb�31ܙ�L�X�D�������������U2N�޷\~{:3ǝ����qg�3sܙ9��wf�;3ǝ�����VG<3�E�&\pCuttա>Z�潪t-L:�p���m�&i��´�ΤΤΤΤΤΤΤΤΤΤά:�>�Ft�;�2�ޙW�̫w��;��y�μzg^�3�ޙW�̫�X�DoN�M�M�M�M�M�M�M�M�M�M��j�ob�3sܙ9��wf�;3ǝ����qg�3sܙ9���h}�k�h�a��n�F��U��`���oF'��I�p=�D'��I�p=�����pN�W���N[A1!��0`�7T���6I˗6��i��y;�j��I.��Ғ�tZ�Z�Vk���Z��{�XO�͏:?��(��яJ?:�T�^46I/m��j�|j(��`(��`(��`(��`(��`(�VF�����i�a��n����o��/�{�(�y��d�M��d�M��d�M��d�M��d�M��d��;QL?S�ҕ�d�*U�$H�{��(/y��P��P��P��P��P��P�Z�&z���9�S7:�p�����M��K���Z�&t0��vв4�ղ4�a4ߞl��ƞl��ƞl��ƞl��ƞl��ƞl��o�|Z��ɠ��ɠ��ɠ��ɠ��ɠ��ɠ��;�~��>lt0��ý>l�6^���à7�tjY�h�a��nx��L��ėV�Ҋ�������������������� :��bS��D�&\p�#��L��ėV��D��|��b�_����~��/v��n�����b�_�����͛Ok��6�\M4�0`�7<⭣�j�K���䧟�}}��o��;���7��f_���}}��o��;Y���Eo����������4      X   �  x�5�Av���b��HȾ����:>QPR��r�2������U���y��U���6?����g�w��o���`~��f]��c0�[��}-?{����Z
^�w-',?z�]�����Y|Pw����U����w��U�*��PO���rV`^�e�Վj���lc^������~�w����o�ҿ4汎��h2��;J��)x��%G��^��|�Q"�{�wІ�������c~Վ�����?�g�S��6浿���G=x����m<��������g���?�a/���y��^��˻�z�:��^^�1��z���^�7���K�K���6t��s��{�u���s��?������_�����s���{�*��s}���y/�~�w}������|�4�9�9���{
΁�9�7���t�:|�˛zsDo����h��;��N���"�c�Dd.�rE����\�C����9����b��/���䠊�!��DS���0�0'],|aN�X��td���C>�0'u,�aZ1aTȞ�� �� ��?��D#+a&��ɞ���&�� ��K��D)K�0o[�1�bψea�1f�+,���䠙�]��D2˘��l�1'�,\cN�Y��td���C>�1'�,�cN�YXǜL䳰��ON�>���g�� �a�d�gD�0�99i�!s2���G�䠥����DJ�͗/o��0�/{FM�M2oE-�dN&�ZʜD��9�hj�)sb��BR�##+�|~���3�Z8˜Ե0�9��ka.sr��[�d����?���߇�c��
{����a�����c��^�|�qX�0��}TV���;,89���W�k
�3'��*�M��a��`�B^��Sqt�):i:��\~�u*��;�:8̜�������8�e��T�tV8̜LVث:=�89���Wу
�3��*�b~�'��*:Q��a��`��^E3*V8̜LVȫҏ*c��!{-�pX�0sr0Ya��+���'g�f�Ic*Vq�0�;���3'��*�S��a��`��^���>�t*�؋e��LVث�S��
�����
{��pX�0sb0Y!�J��8�:�|�U4��a�����d����U8�p�99���WѶ����yۿS퓙^6�LVثh^��
�����
{��pX�0�1��b/��wX�#3�jzX��a����W���53g��d��:=��0����s3ȬC���d����8�qX3�5&k�����a������=7k֌k�ɺ2Je���N&k�����a��:�[����X��a����.3\��Lqg�#?�\&��r��2�e��8w�3�e��H��{5=�qX�f�kL���Ȟ��N&k�����a����d�g�8���5�jzX��a��ט�w��̯����:�b~�'�5�jzX��a�ؘ��W���5�'�3�ȫ��:c��!{5=�qX�f(lL�ث�a���5�ac�~3����=t$b�d�&�=��aؘ͘��W���5k���d����8�qXgdlTֿse�;����`��^Mk�8��5�jzX��a�٘��W��u�����\Xpc�Ä��,)L&�%z�p�p��%�Ʉ�DS�2�ƝL�Y8L+w%7�$�2!�&&&fIa2a/�ÄÄÔYR�L���;,89�L�K�0�0�01K
�	{�&&&fIa2!/��)c��!{�&&&fIu�rIĞq�p��%�Ʉ�DS�2L~n��a��Tn��%���K�Ô�s?��>�Td�ÔK��Re�Tn��=L��R�yۘL�K�0�0�01K
�	{�&&&fIa2!/��)c��!{�&&&fIa2a/�ÄÄ��,�'�r��c�8Lq�0�O2�3��0����a�a�ab�&�=L8Lo����&�&�7ɼmL&�%z�p�p��%�Ʉ�D��0�������@��b�Lz�p�p��%�Ʉ�D��0����a�a��X��.4���jȍ(������6�̒�m��a�m�3KnT�c/��wXpr0��^��q��a�Yrc���6=l㰍�6���dy�����@琏�6=l�:���e0�����6�̒�m��a��8�e��J&{�a�mfɍ�6�ڝ�>|��`���6=l㰍�vfɍ�v��2�N&��k��6�8l3KnL��צ�m�q�f�ܘl#����0��s�N���u�M3��      K      x�u�mr&)��O����9Ğ`��-$���$�ݻ<�6	�J%�?%������?)��~�Oy��o�S�x�����*�?4��'8N?�|���?��G�������=_���o?���?~���g<_��p|������=��y���w}���� � E�~~��u���kN%����Mv��b���x�Ř��Ic�g]�9���j��Ǜ��p��j<�%��1�3Ͼ�(�Ⱦ�"�B���h���ڔ�w���b�@y���,��R��t8N���۲�%�cU�StS�����t�@�O-u�j���J}�*a�L�d�1��2�\����lTP�M�7�]�l���I�d�8κ$�8%8.�$s<��+2�� s����1�	�g_�I0&�-�$�d"X�l�1�c�Ř�ژ���c��	e�[���p��m���葊���
~�bݖL�G)�=��6���d�@�:uݐ� 1�P��ѱR*w��\�Է��~�9_Sٶ���ʶ���q�%����.�'8�tE�8��2��]�9��x���D�D����D�y��0a�1,c�՘ ֱ�ZL`ۗ�?��//�$�۲1�<�����@�+[� ?2�q�uȔAW��)���$����T=C�Y��kΣ���mg�~S_�*g�r����'���f>N<ٶ~8.�&s���K2�;�"s|���ǳ/�$2&���$
&���$*&tA�8��b�1,c�՘ ֑l1&�������jt�g���c@�Ώcݖ9%H�3M;S�!�s�vN2gjǪ�*Dڜ��r"�<��|�I?1$�9��*'�����~؋��.��qNX�<?��h��ڥ���sNh�<
dt]
����WG�H��Q�1Rly���(� Ptq���6J`Aɖf+ʶ0J����sV�sV.���-u�1/J	4��?)C��\촕�@D�d켕K�H���l:$���f3 1t>�G�	K���"k��|*�fco�\�~��;!�a6�t�ti��(�1�Qd`Dg��C���42l�)P ��3�>S+��L�m��ﳭKK	{�ua�Ab{��Cnݪ4 ⏷>y� b��U9C�>uu6\ �>v�B�>v��c��Ά/���M�~�ڄ��Z~�qZ���!`oE���$��KQ��'*R0��@���W �yE��Wl����iE	��V�X[��u8ԥm	�x�[���u��?!��*D찮��$츮[�1$����@�N�K[����m.K�v��EV?��t:v;�羶j>�Mٟ�^ �VR�T��J*w�R�0F��6w��U�
4Xu�@��U�
Xu�t���n���zy�V��[%^�9��C��Jȃ �^����q7A�!1cG��[V}�vt��uՇs'�u�0wgn���U���9���U���ߺ�+�{<j������)	���<j���Q�yl�o!	F�vS�ad�n%u��)0 Nh�	f�*�!`V�f�*P!`V��e���u/T	��{�J�����w�6c�q�Y�6�X@�jI��6��Ւ!��R
���THX/@�R�Щ���l*�%[�R.�zK@���e����h۩��F9�j	#ޣQ$cDH�k�)P!��f� `}3�7S@ `}3�o�@��ꛕ�����$��0�l;���z�sq�@�:ƺ�T!a=cݫD���q!����u��@����Q����m*�<��H��1',�����㋨oY��X��!��ݫ��E��	#?�gfX�B���+h�xE���~<O�"j���<�?QQՏ�����z�~����CTS��v�!�"1ߕQ�曲Pf��B_�u�@�$�B$���!`���	]wOK�0���h&�e
$��B�u���^��.���ی����`sZ���,��VZ�@D\JX�V=A B.�gDʥ�����^!�r.� �>�:C`O�t��u�X�#�ұ�[إ��Z����K;$�{{d�{[��(���>v[U���HA�^ݺQ��j'ֻ{+�v��ݺG��jG��m��X���m���g*��$,�v��iۮ����T ��/�B N�5"�RC �/5	"�RS�@�_j��N�5�� L�	#[�f,��Ԍ]�I������߂ `��F�"�wV�Y~K aş���:	���~��(�j�T'��nҨ�N��?�LU'���&ʪ�d�o���"��k�¾u����ڮ�џ�"�DL-���!��Z"Sk�@�bj��b1��,Ǥ֊����0vV�X���+��1�������ɬ�	3ua뀄9��W)A�,Dݪ�!b��u�R����:"���h�I��y�6��-s��EV7w��#,���ڔ��J�|�w�*'DT�r�@X�",S��:�H�Ԩ�N`��Ԩ�>���Ԩ�>Ȳ�kTU�M�Ԩ�N`�D*cAWf�
Vt�f���Z����ɬJ����ta�B��P�U� ��*oD�N��w�,�� �(�M��5m6�!�-a����&�"��uB��uFmۯ�p��!Dn�6�@4pkDn���-7S[�����60�r3�'�����3"7S{���׎]��ڱ�+7S��Y��,�Ǘ�$,͠�$"�P{���t���3�7D<Р[ud�X�Dg3
$"gRG���L���%�	�t�EVO��|��o��&��뙨��[�|"7C)A`��P�Y�J#+7C�b���P"Dn�C 6%����P��%����PZwN���ٌ�[P"nz�@} ��~�����v��,n��v	����mנN��?ui�u��Տf�݄:K�mw�>�%��勬����)X�퓗�ڬg���oT
�H�B`��P!����Ȋ�P���*���!�*qZ�� �b3T��+6C+�b3T�N��H� �'Dݨ�!�GD}�@�ψ�Wk����u���8�S���nSJ����N�2$��s��%�ӻN�.���;�=��Gk�����޶l�Q�Ȋ�u���muՙ���muՙ���muՙ���muՙ���mu�������ꓬ��1t�f���+6C�mԿo��N�7tiy@ĝݬ� b��nVɐ��@� ݩR!a�NFf�\�!a�ME�f�"���&�>z�u}] �лSt�;T|��(nQ1��)y�S����y� A r3u�T�@�f(�*��)EU��8U�r3Ա�+7C}mԏ7�5����f���u�@t�3���.X�g{���>�;���> �.Ў���nЎ���ځ�<��n��l��v��c��h�e��s�v��4���IQH}/4{������h�>'E!����}N�B�{����e��R��99���n5�}NN1�>'',����)z�]|M8	"k��A ���:֯��.R��g-x�Hu:F����"��yւ��T�c�=�.R��ћ�����2��狚[ւ3t��v�꬐=��]��B���8�A�0�nR��'¸dD"�K�@$¸TDW�A`%¸0$V"��`��D���+���u��,I�"�߿\���!�_�������Y������Sg���_ޮO}J��
�v�S7�����Sg���y�=����Q�9ס�	���r�*��ܠ�:�/��N�����x��N��L�:���/���~���$�xcNX�U�1_�\�3t+�8
��- ���r��n���(�.���rij�|�5���\�Zv_nM��ė;S�1������rgj��rkj�x�7u^Dqו�{S�Ew]y�6u^Dqו�[S�E��ue�X�+���rː+�[�@X��*�
�FX�e�s�ȹ�pnX��
�$=�Bxw�[�@��Vw�{����v[��v�x�.u^�x����y�}R��R�mo��vQ��-;�.J}.��-;�9Wˎ;t3�y�.u��ݣ���ԙ��ؼ]�:�o���Rg"��b󨐈h�@��<-�!�h�����X�-�q�sy����[�@�<��ky�6���^˛��-��i�x�([���k�E�-�wvZ�_ �  
�E��>��[��H��fy-��;�,���}g����@[���d���/rn�(c=���%�'$�6�d�ĲY$3$�f�,�Er�@�,�;�f�< 6����Y�d��"�`���"��Y�`9w�E���/��^���.�5�r|�Y�>'[�ﴊ�f�-�w:�n�Ȗ�;�b�Yd��F��,���N��m�2|�M�6�l	��K��,R/bn6�T,�n�H]����&�C l�a�%��"�!6�P�@�,Ba��fb,�EH�R��"tQs�Y�����"��^�,r	��"��^�,r	��"��^�,r	��"��^�,r	�-�E.��e��%���,r��m6�\�{��"�Iz||��"R 6�H�@�,"��YDa���fiX6�H�ĲYD$��"-a���"�"�Y�aA7�E�-��6��[d�mi�Ȏ�,�n��Y��;n�H�v�f�-��IQy�([\�cIz�([^�cI��ly��#OJ�ȹl�X��f�~	��6�t+	�E:����"�J�f��c%�f�� �l�f��s%a���I��Yd\r:�f�q�s�,2.9�e�ȸ�^�E?��"G�fi)A`�,m���_
�?,��%�~��%�~���[��m���i��fi�&ym���i��fi�ңm�ӷu�6K˸?�l��q{~�,-����YZ���YZ���YZ���YZ���YZ���fi�"�YZ��n6˿��������VE      U      x�m�A��HVF�v�(����#�� ��Q*!���{[I�E�yN+��_O~��߿|��������o���������˿��o��������O��u�������?��]��?׹�]?�����>}���v�|�������~�o���?���������=?�����>}������d�L�d_g�q&gr�398��3y��P~.�S������u.?�������d��:����l�����L�����}���}Bo��\g�sy���ܧ4<��)���Oi��}J���yJ�>��S:�������zpJ�{����}JߋS���~.�S�>��W�)�\ާ�N���~.�S����:��������>��)Oiݧ�xJ����S�<��S:�)���)�s����}J����N�8�ŕ�{��;]j,���[]�X׺8�u�uq���]�d7�8�u�vq���]�p��8�uowq�����z7׻��}�ws�����z7׻��}�ws�����z7׻��}�ws�����z7׻��}�ws�����z7׻��}�ws���{����;�z���w���;\����w�޹�;\�p�s�w���z�^�p���ν��z��{����;�z������=\��zϽ�������=\��zϽ�������=\��zϽ����}��߸��s��p���=�z�{��s��p�����^\���^�z/���z�{��{q�׽ދ뽸��^���^\�u���z/����{q��{�뽸ދ���^\���^�z/���z�{�7�{s���ޛ뽹��^����\�}���zo����{s�7�{�뽹ޛ����\�����zo���z�{�7�{s���ޛ뽹��^���>\�s���z�����p�����}�އ�}��>\���>�z���z�{���p�Ͻއ�}���^���>�m��&�q�;'�u�{'�y���ɣ�'��<����ʣ[(�<����.ʃ�(��<����Nʣ[)��<����nʣ�)�<����ʃ[*��<����ʣ�*��}�q��ƹ����������r������k��ˑ�{��y��;�����^��^N���[�{�s{���;87���r��w��8����ߍs��/g�}΍���\�������w:9��w���5��������k�����݀�k���
�ߝ��k�����]��k�������X��c�o����c�o��؄�c���ܘ��S
](u�ԅBJ](u�ЅRʷ�yo�7�ՅBJ](u�ЅRJ](t�ԅR
](u�ԅBJ](u�ЅRJ]ht�ՅV]hu�ՅFZ]hu�хVZ]ht�ՅV]hu�ՅFZ]hu�хVZ]ht�ՅV]hu�Յ�Q�.]��u!�Bԅ�A�.D]�u!�BЅ�Q�.D]��t!�Bԅ�Q�.]��uaЅQF]taԅQ]uaԅAF]uaЅQF]taԅ��_���� �.��0�¨�.�0�¨]X��R��ԅ�.,ta�K]X��R���Ѕ�.,ua�K]X��B���ԅ�.,ua�]X��R��ԅ�.lta�[]���V���х�.lua�[]���F���Յ�.lua�]���V6��Յ�.lta�[]���V��pЅ�.u�G]8��A��pԅ�.u�]8��Q�pԅ�.t�G]8��Q��pЅ�.?�çs�x����:~BG��<xF��C:���y�Σ�t=���I�G��<zV���:���y��΃�u=��艝��<zf��C;��y��Σ�v<���ɝG��<xv���;��w~�qn/��w~�qn���|�嫧-_v�{�.�^�0v�{�.�^��^v�{�.�^��^v�{��.|/����.|/����.|/����.|/��}w~��<��}w~�qn��}w~�qn��}w~�qn��}w~�qn��}w~�qn��}�sc��]���sc��]���sc��]���sc�O](t�ԅR
](u�ԅBJ](?��'8���P�B��.�P�B��.��P�B��.��P�B��.�P�B��.����B��.����B��.4���B��.����B��.����B��.4���B��.����B��.��t!�Bԅ�Q�.]��u!�Bԅ�A�.D]�u!�BЅ�Q�.D]��t!�Bԅ�Q�.�0�¨�.��0� �.��0�¨�.�0�¨�.��0~���uaЅQF]taԅQ]uaԅ�.,ua�]X��R��ԅ�.,ta�K]X��R���Ѕ�.,ua�K]X��B���ԅ�.,ua�]X��R6��Յ�.lta�[]���V���х�.lua�[]���F���Յ�.lua�]���V6��Յ�.lta�[]8��Q��pЅ�.u�G]8��A��pԅ�.u�]8��Q�pԅ�.t�G]8��Q�	���� �	���=�`0�#���=�`�@�#���=2a�P����=ra`�#���=�a�p�#���=�a���!���=�B����o	��o����o���o���o	���o����o	��o����o���o���o	���o����o	��o����o �p� �ww�����\r�%\��%
\��\��%\��%\�\2�%\P�%\r�\��%\��%\��������&�6�D�V���6VH�m�����ͅ�	�-�M�i�����Ɇ��)�M�e�x���K|���K��$���d�K����K�����$�K��`�K�������K�� �K��d�����K����K��$���d�K����K�����$�Kĸ`�Kȸ��̸�Kи �KԸd�ظ��Kܸ��K�$��d�K踠�K���$�K��`�K�������K � �K�d����K���K�$�k�C�%	u�đK� �K"�D�&���K*���K.��2�D�K6���K:�ē>��KB�@�KF���J�ĔKN� �KR�D�V���KZ���K^��b�D�Kf���Kj�Ėn��Kr�@�Kv���z�ėK~� �K��D�����K����K�����D�K����K��ę���K��@�K������ĚK�� �K��D�����K����K���¹D�Kƹ��KʹĜι�Kҹ@�Kֹ�����SC��!�ؐmH?7����-����-��������-����-��������-����-��������-����-��������-����-��������-����-��������-����-��������-����-��������-����-��������-����-������]��ƹ}�B�;��s�;7�s�;��s�;��s�;7�s�;��s�;��s�;7�s�;��s�;��s�;7�s�;��s�;��s�;7�s�;��s�;��s�;w����st��s�;��s�;��s�;7�s�;��s�;��s�;7�s�;��s�;��s�;7�s�;��s�;��s�;7�s�;��s�;��s�;7�s�;��s�;��s�;7�s�;��s�;��s�;7�s�;��s�;��s�;7�s�;��s�;��s�;7�s�;��s�;��s�;7�s�;��s�;��s�;7�s�;��s�;��s�;7�s�;��s�;��s�;7�s�;��s�;��s�;7�s�;��s�;��s�;7�s�;��s�;��s�;���J�{���s�;��s�;��s�;7�s�;��s�;��s�;7�s�;��s�;��s�;7�s�;��s�;��s�;7�s�;��s�;��s�;7�s�;��s�;��s�;7�s�;��s�;��s�;7�s�;��s�;��s�;7�s�;��s�;��s�;7�s�;��s�;��s�;7�s�;��s�;��s�;7�s�;��s�;��s�;7�s�;��s�;��s�;7�s�;��s�;��s�;7�s�;��s�;��s�;7�s�;��s�;��s�;���Y������Ik���~��9�Αw�s�#�x��;G�9�Αw��s��#�y��;G�9�΁w��s��y��;�9�Αw�s�#�x��;G�9�Αw��s��#�y��;G�9�΁w��s��y��;�9�Αw �  �s�#�x��;G�9�Αw��s����8��]�s�#�x��;G�9�Αw��s��#�y��;G�9�΁w��s��y��;�9�Αw�s�#�x��;G�9�Αw��s��<�K�x��;G�9�Αw��s��#�y��;G�9�΁w��s��y��;�9�Αw�s�#�x��;G�9�Αw��s��#�y��;G�9�΁w��s��y��;�9�Αw�s�#�x��;G�9�Αw��s��#�y��;G�9�΁w��s��y��;�9�Αw�s�#�x��;G�9�Αw��s��#�y��;G�9�΁w��s��y��;�9�Αw�s�#�x��;G�9�Αw��s��#�y��;G�9�΁w��s��y��;�9�Αw�s�#�x��;G�9�Αw��s��#�y��;G�9�΁w��s��y��;�9�Αw�s�#�x��;G�9�Αw��s��#�y��;G�9�΁w��s��y��;�9�Αw�s�#�x��;G�9�Αw��s��#�y��;G�9�΁w��s��y��;�9�Αw�s�#�x��;G�9�Αw����;����;���;����;����;���;����;����;���;����;����;���;����;����;���;����;����;���;����;����;���;����;����;���;����;����;���;����;����;���;����;����;�ww������<��#�<��#�<���<��#�<��#�<���<��#�<��#�<���<��#�<��#�<���<��#�<��#�<���<��#�<��#�<���<��#�<��#�<���<��#�<��#�<���<��#�<��#�<���<��#�<��#�<���<��#�<��#�<���<��#�<��#�<���<��#�<��#�<���<��#�<��#�<���<��#�<��#�<���<��#�<��#�<���<��#�<��#�<���<��#�<��#�<���<��#�<��#�<~�2_��7-�U�|ײ_��-�u�~߲_��7.���~�2_��.���|�_����y��^�����}ٯ_����f��ٯ`�;��fy�wy�wx�wy�wy�wx�wy�wy�wx�wy�wy�wx�wy�wy�wx�wy�wy�wx�wy�wy�wx�wy�wy�wx�wy�wy�wx�wy�wy�wx�wy�wy�wx�wy�wy�wx�wy�wy�wx�wy�wy�wx�wy�wy�wx�wy��䝗��w^��K�y�;/y�%������w^��K�y�;/x�%����w^���y�;/y��䝗��w^��K�y�;/y�%������w^��K�y�;/x�%����w^���y�;/y��䝗��w^��K�y�;/y�%������w^��K�y�;��?����ڄIt      W      x�3��/*I-��2�tIMK�+NTHN�+)J��2��IJ%�(���&g�s��E2�
K3S�R�L9}SS2����*Afd��s�!�s���ʇ)��t�()J�͇[a	AXah t[Nbȝ
Pc���� <�@�      P   L  x�u�KnX��1�
��x�V��,�a� F2򄠈� -��=e�X$t�������$�������_^>}����OO/�~|}x��q����_��?}�e|����>��_>}y{������w~|{z~�������?�MO��~��	�鯏�^>ڎ;�;~�����~yy�l�6����������wư��-�||}�����=�9�֏�O�}�����y��!��]\�_^~�O~�O~�����oo�_Y�ΰ���y����K=٦+m����۷�����_��_���|[U[�9kY�e�/Bq-�,�_�Z��,�]�ZƱ,u\�Z��e{�����RAu�e�X��m-�Ʋ�A�j�P��^-�h�S�Z��B�z�У�N-�j�G�Z��B�:�Ы�-tj�W=Z��B�z�Щ�z�Щ�z�Щ�0Z@j���Q\-`���V- ���FH-`���RX-`���V- ���FH-p���R\-p���W-0���G���8Z`j����Z�j����Z�h���8Z`ja_-p���¾Z�h���}�����¾Z�G{ja_-죅=������X-죅=���x����W���wO�+�}Ļ�x��>��S�����)�c�v�܎�۱r;FnG��X�#�#�δr;FnG��X�#�#�v�܎�ۑr;Wn���H��+�s�v��Ε�9r;Sn�����)�s�v��Δ۹r;Gng��\��#�3�v��Αۙr�Vn���L�]+�k�v�ܮ��5r�Rn����])�k�v�ܮ�۵r�FnW��Z�]#�+�v�ܮ�ەr�Wn���J��+�{�v����=r�Sn�����)�{�v���۽r�Gnw����ݙ+�{wGUl�
�"�b32l2�Ѱ�6�a�n���E:lf�Mxآ6s�&lQ��`���e�6�`�F3 l��|G�i���+l2,;�!6%�)���sgMhei9���"�ʵ5��U�)�H�2L�4U�Sծ��ژ���d���*SU�U]U&��*��M%5UdS��Jp�(�2:��TOe,*��"��dT�QE��`��<�G% UR�}J����2���S@e*����TRPE��$���)3N	9�SƜ�s*B��g/��%�i�)1��c� S�LEʔY�����)�L�3ASF��U*b�L+%�T�JXJb�H�2���RQ-el)��"\��R�KE��ᥤ��|)�K	0SF��a*"�L1%�TtLdJ��H�2˔0SQ3u���<��y�hJ��h�2ԔTS�5e�)���l�hS�MEܔ�ě��)NI8�Sf�r**��9%�T�N�~�:�Rc����v*r��;%�TOyJ橈�2���S�=e�)ɧ"}��S�OE���䟊 *P�@T��N��阧9���*�P�B1T���*z�D%U$Q��J(���2�\TFe2*Ѩ���lT�QE�����?���Z>��6�|��Gm>j�����|��QG���壎>j�Q�G}�棖�:���G-u�Q�_��ۑ����壎>j�Q�G}�棖�:���G-u�Q��Z>�|e>j���}������+)�s�6��w�M��)��WN��)_:��Ӽv��N~�4���_*�[���{�y�}�~�4��|��QG���壎>j�޼Ëy��Z>��6�|��Gm>j�����|��QG���壎>j�Q�G}�棖�:���G-u�Q�oE�h��|��QG���壎>j�Q�G}�棖�:���G-u�Q��Z>��6�|��Gm>j�����|��QG���壎>j�Q�G}�棖�:���G-u�Q��Z>��6�|��Gm>j�������y%�4�|��Gm>j�����|��QG���壎>j�Q�G}�棖�:���G-u�Q��Z>��>}�aN9�<�G-u�Q��Z>��6�|��Gm>j�����|��QG���壎>j�Q�G}�棖�:��o���#1O�Q�G}�棖�:���G-u�Q��Z>��6�|��Gm>j�����|��QG�|��QGa�Q�9��q�G��}��#D�|��G0A>B��G��}��#D�|��G0A>B��ǖ��R��|��G0A>B��G��}��#D�|��G0A>B��G��}��#D�}l���<�G��}��#D�|��G0A>B�3A>B��3A>B��9W��|�n���ٺw�us�.���us�.O�������s>>7�碏�ts�.�>D7�袏`>�|��#�� !��#�G�>}^q,�<�G��}��#D�|��G0A>B��G��}��#D�|��G0A>B��G��}��#D�|��G0A>B��G��}��#D�|��G0A>B��G8�l��|��G0A>B��G��}��#D�|��G0A>B��G��}��#D�|�s��<�G��}��#D�|��G0A>B��G��}��#D�|��G0A>B��G��Hw��|��G0A>B��G��}��#D�|��G0A>B��G��}D��#D�|�{N��1y��#F�|D���G4Q>b��G��}D��#F�|D���G4Q>b��G��}D�k�(�y��(1���#�G�>������h>�|��#��(1���#�G�>������h>�|��#����F��|D���G4Q>b��G��}D��#F�|D���G4Q>b��G��}D��#F�|D�w/1O��#F�|D���G4Q>b~`d>�|����|D�����? �/���	��9�WD��h�#��޽$�O�b��Jh>�����|)}D+4Eџ��B�G4Q>b��G��}D��#F�|D���G4Q>b��G��}D��#F�|D���G4Q>b��G��}D��#F�|D���G4���b��#�G�>������h>�|��#��(1���#�G�>������h>�|��#��(1���#��e`��|D���G4Q>b��G��}D��#F�|D���G4Q>b��G��}D��#F�|�k>��y��(1���#�G�>������h>�|��#��(1���#�G�>������v��#F��#���j���?|���F|_     