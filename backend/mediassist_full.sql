--
-- PostgreSQL database dump
--

\restrict PUnH7Swqul5tMd2pXC2O36PuVDJ6sfN3zcqSaDxXy0jcX1edCOqKYYIgV7RBuhr

-- Dumped from database version 18.6
-- Dumped by pg_dump version 18.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: alert; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alert (
    id integer NOT NULL,
    type character varying(50) NOT NULL,
    titre character varying(150) NOT NULL,
    message text NOT NULL,
    severite character varying(20) NOT NULL,
    statut character varying(20) NOT NULL,
    equipment_id integer,
    ticket_id integer,
    date_creation timestamp without time zone NOT NULL
);


ALTER TABLE public.alert OWNER TO postgres;

--
-- Name: alert_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.alert_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.alert_id_seq OWNER TO postgres;

--
-- Name: alert_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.alert_id_seq OWNED BY public.alert.id;


--
-- Name: departments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.departments (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    location character varying(150),
    description text
);


ALTER TABLE public.departments OWNER TO postgres;

--
-- Name: departments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.departments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.departments_id_seq OWNER TO postgres;

--
-- Name: departments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.departments_id_seq OWNED BY public.departments.id;


--
-- Name: equipment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.equipment (
    id integer NOT NULL,
    inventory_code character varying(50) NOT NULL,
    name character varying(100) NOT NULL,
    category character varying(50) NOT NULL,
    service character varying(100) NOT NULL,
    brand character varying(50),
    model character varying(100),
    status character varying(50) NOT NULL,
    category_id integer,
    department_id integer
);


ALTER TABLE public.equipment OWNER TO postgres;

--
-- Name: equipment_categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.equipment_categories (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    description text
);


ALTER TABLE public.equipment_categories OWNER TO postgres;

--
-- Name: equipment_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.equipment_categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.equipment_categories_id_seq OWNER TO postgres;

--
-- Name: equipment_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.equipment_categories_id_seq OWNED BY public.equipment_categories.id;


--
-- Name: equipment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.equipment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.equipment_id_seq OWNER TO postgres;

--
-- Name: equipment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.equipment_id_seq OWNED BY public.equipment.id;


--
-- Name: incident; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.incident (
    id integer NOT NULL,
    titre character varying(150) NOT NULL,
    description text NOT NULL,
    priorite character varying(20) NOT NULL,
    statut character varying(50) NOT NULL,
    date_signalement timestamp without time zone NOT NULL,
    solution text,
    equipment_id integer NOT NULL,
    ticket_id integer,
    technicien character varying(100)
);


ALTER TABLE public.incident OWNER TO postgres;

--
-- Name: incident_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.incident_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.incident_id_seq OWNER TO postgres;

--
-- Name: incident_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.incident_id_seq OWNED BY public.incident.id;


--
-- Name: intervention; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.intervention (
    id integer NOT NULL,
    ticket_id integer NOT NULL,
    date_intervention timestamp without time zone NOT NULL,
    type_intervention character varying(100) NOT NULL,
    description text,
    solution text,
    technicien character varying(100),
    statut character varying(50) NOT NULL,
    date_fin timestamp without time zone,
    actions text,
    resultat text,
    user_id integer,
    department_id integer
);


ALTER TABLE public.intervention OWNER TO postgres;

--
-- Name: intervention_comment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.intervention_comment (
    id integer NOT NULL,
    intervention_id integer NOT NULL,
    commentaire text NOT NULL,
    date_commentaire timestamp without time zone NOT NULL
);


ALTER TABLE public.intervention_comment OWNER TO postgres;

--
-- Name: intervention_comment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.intervention_comment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.intervention_comment_id_seq OWNER TO postgres;

--
-- Name: intervention_comment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.intervention_comment_id_seq OWNED BY public.intervention_comment.id;


--
-- Name: intervention_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.intervention_history (
    id integer NOT NULL,
    intervention_id integer NOT NULL,
    action character varying(100) NOT NULL,
    ancien_statut character varying(50),
    nouveau_statut character varying(50),
    ancien_technicien character varying(100),
    nouveau_technicien character varying(100),
    date_action timestamp without time zone NOT NULL,
    ancienne_description text,
    nouvelle_description text,
    anciennes_actions text,
    nouvelles_actions text,
    ancienne_solution text,
    nouvelle_solution text,
    ancien_resultat text,
    nouveau_resultat text
);


ALTER TABLE public.intervention_history OWNER TO postgres;

--
-- Name: intervention_history_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.intervention_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.intervention_history_id_seq OWNER TO postgres;

--
-- Name: intervention_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.intervention_history_id_seq OWNED BY public.intervention_history.id;


--
-- Name: intervention_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.intervention_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.intervention_id_seq OWNER TO postgres;

--
-- Name: intervention_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.intervention_id_seq OWNED BY public.intervention.id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    description text
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.roles_id_seq OWNER TO postgres;

--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- Name: ticket; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ticket (
    id integer NOT NULL,
    equipment_id integer NOT NULL,
    date_signalement timestamp without time zone NOT NULL,
    description text NOT NULL,
    priorite character varying(20) NOT NULL,
    statut character varying(20) NOT NULL,
    solution text,
    date_resolution timestamp without time zone,
    technicien character varying(100),
    user_id integer,
    department_id integer
);


ALTER TABLE public.ticket OWNER TO postgres;

--
-- Name: ticket_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ticket_history (
    id integer NOT NULL,
    ticket_id integer NOT NULL,
    action character varying(100) NOT NULL,
    ancien_statut character varying(20),
    nouveau_statut character varying(20),
    ancienne_priorite character varying(20),
    nouvelle_priorite character varying(20),
    date_action timestamp without time zone NOT NULL
);


ALTER TABLE public.ticket_history OWNER TO postgres;

--
-- Name: ticket_history_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ticket_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ticket_history_id_seq OWNER TO postgres;

--
-- Name: ticket_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ticket_history_id_seq OWNED BY public.ticket_history.id;


--
-- Name: ticket_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ticket_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ticket_id_seq OWNER TO postgres;

--
-- Name: ticket_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ticket_id_seq OWNED BY public.ticket.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    employee_code character varying(30) NOT NULL,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    email character varying(150) NOT NULL,
    phone character varying(30),
    password_hash character varying(255) NOT NULL,
    role_id integer NOT NULL,
    department_id integer,
    is_active boolean NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: alert id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alert ALTER COLUMN id SET DEFAULT nextval('public.alert_id_seq'::regclass);


--
-- Name: departments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments ALTER COLUMN id SET DEFAULT nextval('public.departments_id_seq'::regclass);


--
-- Name: equipment id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipment ALTER COLUMN id SET DEFAULT nextval('public.equipment_id_seq'::regclass);


--
-- Name: equipment_categories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipment_categories ALTER COLUMN id SET DEFAULT nextval('public.equipment_categories_id_seq'::regclass);


--
-- Name: incident id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incident ALTER COLUMN id SET DEFAULT nextval('public.incident_id_seq'::regclass);


--
-- Name: intervention id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.intervention ALTER COLUMN id SET DEFAULT nextval('public.intervention_id_seq'::regclass);


--
-- Name: intervention_comment id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.intervention_comment ALTER COLUMN id SET DEFAULT nextval('public.intervention_comment_id_seq'::regclass);


--
-- Name: intervention_history id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.intervention_history ALTER COLUMN id SET DEFAULT nextval('public.intervention_history_id_seq'::regclass);


--
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- Name: ticket id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ticket ALTER COLUMN id SET DEFAULT nextval('public.ticket_id_seq'::regclass);


--
-- Name: ticket_history id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ticket_history ALTER COLUMN id SET DEFAULT nextval('public.ticket_history_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: alert; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.alert (id, type, titre, message, severite, statut, equipment_id, ticket_id, date_creation) FROM stdin;
1	equipement_problematique	Équipement problématique : Ordinateur HP ProDesk	3 tickets enregistrés pour cet équipement.	Haute	Résolue	1	\N	2026-09-12 22:06:16.827302
2	equipement_problematique	Équipement problématique : Ordinateur HP ProDesk	3 tickets enregistrés pour cet équipement.	Haute	Résolue	1	\N	2026-09-12 22:25:49.90054
3	equipement_problematique	Équipement problématique : Ordinateur HP ProDesk	3 tickets enregistrés pour cet équipement.	Haute	Active	1	\N	2026-09-12 22:25:56.82771
\.


--
-- Data for Name: departments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.departments (id, name, location, description) FROM stdin;
1	Urgences	Bâtiment principal	Service des urgences
2	Réanimation	Bâtiment principal	Service de réanimation
3	Cardiologie	Bâtiment principal	Service de cardiologie
4	Radiologie	Bâtiment principal	Service de radiologie
5	Laboratoire	Bâtiment principal	Laboratoire médical
6	Pédiatrie	Bâtiment principal	Service de pédiatrie
7	Administration	Bâtiment administratif	Service administratif
8	Service Informatique	Bâtiment administratif	Service informatique
\.


--
-- Data for Name: equipment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.equipment (id, inventory_code, name, category, service, brand, model, status, category_id, department_id) FROM stdin;
1	PC-OUJ-001	Ordinateur HP ProDesk	Poste	Informatique	HP	ProDesk 400 G6	En service	2	8
2	PC-OUJ-002	Ordinateur Dell OptiPlex	Poste	Administration	Dell	OptiPlex 7090	En service	2	7
3	PC-TEST-001	PC de test	Ordinateur	Radiologie	\N	\N	Opérationnel	\N	\N
\.


--
-- Data for Name: equipment_categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.equipment_categories (id, name, description) FROM stdin;
1	Équipement médical	Équipements médicaux utilisés dans les services
2	Équipement informatique	Ordinateurs et périphériques informatiques
3	Réseau	Équipements réseau et télécommunications
4	Serveur	Serveurs et équipements de datacenter
5	Imprimante	Imprimantes et équipements d’impression
\.


--
-- Data for Name: incident; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.incident (id, titre, description, priorite, statut, date_signalement, solution, equipment_id, ticket_id, technicien) FROM stdin;
1	Probleme de connexion	Probleme de connexion	Haute	Ouvert	2026-08-29 13:33:51.587663	\N	1	5	salma
2	Probleme de connexion	cccccccc	Haute	Résolu	2026-09-07 18:36:30.125327	\N	2	6	salma
\.


--
-- Data for Name: intervention; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.intervention (id, ticket_id, date_intervention, type_intervention, description, solution, technicien, statut, date_fin, actions, resultat, user_id, department_id) FROM stdin;
3	4	2026-08-31 10:00:00	Maintenance	Vérification du matériel	Diagnostic du problème	Technicien 1	Clôturée	2026-09-02 17:39:37.771628	\N	\N	\N	\N
4	3	2026-06-20 13:35:00	FFFF	FFFF	FFFFFFF	FFFFFFF	Clôturée	2026-09-02 17:48:46.704641	\N	\N	\N	\N
2	4	2026-08-31 10:00:00	Maintenance	Vérification du matériel	vvvvvv	Technicien 1	Terminée	\N	Diagnostic du problème	j123	\N	\N
1	3	2026-08-24 13:42:00	string	TEST HISTORIQUE DESCRIPTION	TEST HISTORIQUE SOLUTION	Technicien informatique	Clôturée	2026-09-02 18:27:18.302753	gggffffffff	gggggggggg	\N	\N
5	11	2026-01-11 09:00:00	Réparation	\N	\N	Karim	En cours	\N	\N	\N	\N	\N
6	12	2026-01-11 09:00:00	Réparation	\N	\N	\N	Clôturée	2026-09-12 23:43:34.616594	\N	\N	\N	\N
8	18	2026-01-11 09:00:00	Réparation	\N	\N	Karim	En cours	\N	\N	\N	\N	\N
9	19	2026-01-11 09:00:00	Réparation	\N	\N	\N	Clôturée	2026-09-12 23:44:50.557015	\N	\N	\N	\N
11	27	2026-01-11 09:00:00	Réparation	\N	\N	Karim	En cours	\N	\N	\N	\N	\N
12	28	2026-01-11 09:00:00	Réparation	\N	\N	\N	Clôturée	2026-09-12 23:46:10.59228	\N	\N	\N	\N
14	36	2026-01-11 09:00:00	Réparation	\N	\N	Karim	En cours	\N	\N	\N	\N	\N
15	37	2026-01-11 09:00:00	Réparation	\N	\N	\N	Clôturée	2026-09-12 23:56:49.42079	\N	\N	\N	\N
\.


--
-- Data for Name: intervention_comment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.intervention_comment (id, intervention_id, commentaire, date_commentaire) FROM stdin;
1	3	Test : intervention vérifiée et matériel fonctionnel.	2026-09-04 14:47:48.826103
2	3	cccccc	2026-09-04 14:57:59.832428
3	3	aaaaaaaaaaaa	2026-09-04 14:58:42.628104
4	2	salma diagnostic	2026-09-04 15:08:54.899703
5	1	Câble d'alimentation remplacé et test du poste effectué	2026-09-04 15:09:10.325401
6	1	2	2026-09-04 15:09:16.86008
7	4	salma	2026-09-04 20:34:59.605512
\.


--
-- Data for Name: intervention_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.intervention_history (id, intervention_id, action, ancien_statut, nouveau_statut, ancien_technicien, nouveau_technicien, date_action, ancienne_description, nouvelle_description, anciennes_actions, nouvelles_actions, ancienne_solution, nouvelle_solution, ancien_resultat, nouveau_resultat) FROM stdin;
1	2	Création de l'intervention	\N	En cours	\N	Technicien 1	2026-08-31 18:42:27.205938	\N	\N	\N	\N	\N	\N	\N	\N
2	3	Création de l'intervention	\N	En cours	\N	Technicien 1	2026-09-02 17:19:04.079921	\N	\N	\N	\N	\N	\N	\N	\N
3	2	Modification du statut	En cours	Terminée	\N	\N	2026-09-02 17:20:59.886328	\N	\N	\N	\N	\N	\N	\N	\N
4	3	Clôture de l'intervention	En cours	Clôturée	\N	\N	2026-09-02 17:39:37.771628	\N	\N	\N	\N	\N	\N	\N	\N
5	4	Création de l'intervention	\N	Terminée	\N	FFFFFFF	2026-09-02 17:44:56.173591	\N	\N	\N	\N	\N	\N	\N	\N
6	4	Clôture de l'intervention	Terminée	Clôturée	\N	\N	2026-09-02 17:48:46.704641	\N	\N	\N	\N	\N	\N	\N	\N
7	1	Clôture de l'intervention	Terminée	Clôturée	\N	\N	2026-09-02 18:27:18.302753	\N	\N	\N	\N	\N	\N	\N	\N
8	1	Modification de la description	\N	\N	\N	\N	2026-09-04 20:42:28.449351	strin	TEST HISTORIQUE DESCRIPTION	\N	\N	\N	\N	\N	\N
9	1	Modification de la solution	\N	\N	\N	\N	2026-09-05 16:08:53.790915	\N	\N	\N	\N	Câble d'alimentation remplacé et test du poste effectué	TEST HISTORIQUE SOLUTION	\N	\N
10	5	Création de l'intervention	\N	En cours	\N	Karim	2026-09-12 23:43:33.93505	\N	\N	\N	\N	\N	\N	\N	\N
11	6	Création de l'intervention	\N	En cours	\N	\N	2026-09-12 23:43:34.600967	\N	\N	\N	\N	\N	\N	\N	\N
12	6	Clôture de l'intervention	En cours	Clôturée	\N	\N	2026-09-12 23:43:34.616594	\N	\N	\N	\N	\N	\N	\N	\N
14	8	Création de l'intervention	\N	En cours	\N	Karim	2026-09-12 23:44:49.770052	\N	\N	\N	\N	\N	\N	\N	\N
15	9	Création de l'intervention	\N	En cours	\N	\N	2026-09-12 23:44:50.541439	\N	\N	\N	\N	\N	\N	\N	\N
16	9	Clôture de l'intervention	En cours	Clôturée	\N	\N	2026-09-12 23:44:50.557015	\N	\N	\N	\N	\N	\N	\N	\N
18	11	Création de l'intervention	\N	En cours	\N	Karim	2026-09-12 23:46:09.84571	\N	\N	\N	\N	\N	\N	\N	\N
19	12	Création de l'intervention	\N	En cours	\N	\N	2026-09-12 23:46:10.570958	\N	\N	\N	\N	\N	\N	\N	\N
20	12	Clôture de l'intervention	En cours	Clôturée	\N	\N	2026-09-12 23:46:10.59228	\N	\N	\N	\N	\N	\N	\N	\N
22	14	Création de l'intervention	\N	En cours	\N	Karim	2026-09-12 23:56:48.65909	\N	\N	\N	\N	\N	\N	\N	\N
23	15	Création de l'intervention	\N	En cours	\N	\N	2026-09-12 23:56:49.401841	\N	\N	\N	\N	\N	\N	\N	\N
24	15	Clôture de l'intervention	En cours	Clôturée	\N	\N	2026-09-12 23:56:49.42079	\N	\N	\N	\N	\N	\N	\N	\N
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (id, name, description) FROM stdin;
1	Administrateur	Accès complet au système
2	Responsable Informatique	Gestion du parc informatique et des interventions
3	Technicien Informatique	Gestion des tickets et interventions techniques
\.


--
-- Data for Name: ticket; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ticket (id, equipment_id, date_signalement, description, priorite, statut, solution, date_resolution, technicien, user_id, department_id) FROM stdin;
4	1	2026-08-29 13:30:00	Probleme de connexion	Critique	Clôturé	jsp	2026-08-30 17:55:19.977273	\N	\N	\N
5	1	2026-08-29 13:33:51.587663	Probleme de connexion	Haute	Ouvert	\N	\N	\N	\N	\N
6	2	2026-09-07 18:36:30.125327	cccccccc	Haute	Ouvert	\N	\N	\N	\N	\N
3	1	2026-08-23 21:00:00	Problème de connexion réseau	string	string	string	2026-09-08 00:46:47.395	\N	\N	\N
7	1	2026-01-10 09:00:00	Ne s'allume plus	Critique	Ouvert	\N	\N	\N	\N	\N
8	1	2026-01-10 09:00:00	Ne s'allume plus	Critique	Clôturé	\N	2026-09-12 23:42:27.265264	\N	\N	\N
9	1	2026-01-10 09:00:00	Lenteur	Moyenne	En cours	\N	\N	Karim	\N	\N
11	1	2026-01-10 09:00:00	Ne s'allume plus	Critique	Ouvert	\N	\N	\N	\N	\N
12	1	2026-01-10 09:00:00	Ne s'allume plus	Critique	Ouvert	\N	\N	\N	\N	\N
13	1	2026-01-10 09:00:00	Ne s'allume plus	Critique	Ouvert	\N	\N	\N	\N	\N
14	1	2026-01-10 09:00:00	Ne s'allume plus	Critique	Ouvert	\N	\N	\N	\N	\N
15	1	2026-01-10 09:00:00	Ne s'allume plus	Critique	Clôturé	\N	2026-09-12 23:43:36.106455	\N	\N	\N
16	1	2026-01-10 09:00:00	Lenteur	Moyenne	En cours	\N	\N	Karim	\N	\N
18	1	2026-01-10 09:00:00	Ne s'allume plus	Critique	Ouvert	\N	\N	\N	\N	\N
19	1	2026-01-10 09:00:00	Ne s'allume plus	Critique	Ouvert	\N	\N	\N	\N	\N
20	1	2026-01-10 09:00:00	Ne s'allume plus	Critique	Ouvert	\N	\N	\N	\N	\N
21	1	2026-01-10 09:00:00	Ne s'allume plus	Critique	Ouvert	\N	\N	\N	\N	\N
22	1	2026-01-10 09:00:00	Ne s'allume plus	Critique	Clôturé	\N	2026-09-12 23:44:51.658529	\N	\N	\N
23	1	2026-01-10 09:00:00	Lenteur	Moyenne	En cours	\N	\N	Karim	\N	\N
25	1	2026-01-10 09:00:00	Panne	Critique	Ouvert	\N	\N	\N	\N	\N
26	1	2026-01-10 09:00:00	Panne	Basse	Résolu	\N	2026-01-11 09:00:00	\N	\N	\N
27	1	2026-01-10 09:00:00	Ne s'allume plus	Critique	Ouvert	\N	\N	\N	\N	\N
28	1	2026-01-10 09:00:00	Ne s'allume plus	Critique	Ouvert	\N	\N	\N	\N	\N
29	1	2026-01-10 09:00:00	Ne s'allume plus	Critique	Ouvert	\N	\N	\N	\N	\N
30	1	2026-01-10 09:00:00	Ne s'allume plus	Critique	Ouvert	\N	\N	\N	\N	\N
31	1	2026-01-10 09:00:00	Ne s'allume plus	Critique	Clôturé	\N	2026-09-12 23:46:11.822829	\N	\N	\N
32	1	2026-01-10 09:00:00	Lenteur	Moyenne	En cours	\N	\N	Karim	\N	\N
34	1	2026-01-10 09:00:00	Panne	Critique	Ouvert	\N	\N	\N	\N	\N
35	1	2026-01-10 09:00:00	Panne	Basse	Résolu	\N	2026-01-11 09:00:00	\N	\N	\N
36	1	2026-01-10 09:00:00	Ne s'allume plus	Critique	Ouvert	\N	\N	\N	\N	\N
37	1	2026-01-10 09:00:00	Ne s'allume plus	Critique	Ouvert	\N	\N	\N	\N	\N
38	1	2026-01-10 09:00:00	Ne s'allume plus	Critique	Ouvert	\N	\N	\N	\N	\N
39	1	2026-01-10 09:00:00	Ne s'allume plus	Critique	Ouvert	\N	\N	\N	\N	\N
40	1	2026-01-10 09:00:00	Ne s'allume plus	Critique	Clôturé	\N	2026-09-12 23:56:50.656731	\N	\N	\N
41	1	2026-01-10 09:00:00	Lenteur	Moyenne	En cours	\N	\N	Karim	\N	\N
\.


--
-- Data for Name: ticket_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ticket_history (id, ticket_id, action, ancien_statut, nouveau_statut, ancienne_priorite, nouvelle_priorite, date_action) FROM stdin;
1	3	Modification du statut	Résolu	En cours	\N	\N	2026-08-30 16:21:23.926438
2	3	Modification du statut	En cours	Résolu	\N	\N	2026-08-30 17:29:58.357065
3	3	Clôture du ticket	Résolu	Clôturé	\N	\N	2026-08-30 17:30:16.765107
4	3	Modification du statut	Clôturé	Ouvert	\N	\N	2026-08-30 17:39:11.178683
5	3	Clôture du ticket	Ouvert	Clôturé	\N	\N	2026-08-30 17:39:24.406284
6	4	Clôture du ticket	Ouvert	Clôturé	\N	\N	2026-08-30 17:55:19.977273
7	3	Modification du statut	Clôturé	string	\N	\N	2026-09-07 23:46:56.185498
8	8	Clôture du ticket	En cours	Clôturé	\N	\N	2026-09-12 23:42:27.265264
9	9	Modification du statut	Ouvert	En cours	\N	\N	2026-09-12 23:42:27.643683
10	15	Clôture du ticket	En cours	Clôturé	\N	\N	2026-09-12 23:43:36.106455
11	16	Modification du statut	Ouvert	En cours	\N	\N	2026-09-12 23:43:36.463745
12	22	Clôture du ticket	En cours	Clôturé	\N	\N	2026-09-12 23:44:51.658529
13	23	Modification du statut	Ouvert	En cours	\N	\N	2026-09-12 23:44:52.022667
14	31	Clôture du ticket	En cours	Clôturé	\N	\N	2026-09-12 23:46:11.822829
15	32	Modification du statut	Ouvert	En cours	\N	\N	2026-09-12 23:46:12.237677
16	40	Clôture du ticket	En cours	Clôturé	\N	\N	2026-09-12 23:56:50.656731
17	41	Modification du statut	Ouvert	En cours	\N	\N	2026-09-12 23:56:51.054178
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, employee_code, first_name, last_name, email, phone, password_hash, role_id, department_id, is_active) FROM stdin;
1	EMP001	Admin	MediAssist	admin@mediassist.local	\N	TEMP_HASH	1	8	t
2	EMP002	Technicien	Informatique	technicien@mediassist.local	\N	TEMP_HASH	3	8	t
3	EMP003	Responsable	Informatique	responsable@mediassist.local	\N	TEMP_HASH	2	8	t
\.


--
-- Name: alert_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.alert_id_seq', 3, true);


--
-- Name: departments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.departments_id_seq', 8, true);


--
-- Name: equipment_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.equipment_categories_id_seq', 5, true);


--
-- Name: equipment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.equipment_id_seq', 3, true);


--
-- Name: incident_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.incident_id_seq', 2, true);


--
-- Name: intervention_comment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.intervention_comment_id_seq', 7, true);


--
-- Name: intervention_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.intervention_history_id_seq', 25, true);


--
-- Name: intervention_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.intervention_id_seq', 16, true);


--
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_id_seq', 3, true);


--
-- Name: ticket_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ticket_history_id_seq', 17, true);


--
-- Name: ticket_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ticket_id_seq', 42, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 3, true);


--
-- Name: alert alert_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alert
    ADD CONSTRAINT alert_pkey PRIMARY KEY (id);


--
-- Name: departments departments_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_name_key UNIQUE (name);


--
-- Name: departments departments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_pkey PRIMARY KEY (id);


--
-- Name: equipment_categories equipment_categories_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipment_categories
    ADD CONSTRAINT equipment_categories_name_key UNIQUE (name);


--
-- Name: equipment_categories equipment_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipment_categories
    ADD CONSTRAINT equipment_categories_pkey PRIMARY KEY (id);


--
-- Name: equipment equipment_inventory_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipment
    ADD CONSTRAINT equipment_inventory_code_key UNIQUE (inventory_code);


--
-- Name: equipment equipment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipment
    ADD CONSTRAINT equipment_pkey PRIMARY KEY (id);


--
-- Name: incident incident_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incident
    ADD CONSTRAINT incident_pkey PRIMARY KEY (id);


--
-- Name: intervention_comment intervention_comment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.intervention_comment
    ADD CONSTRAINT intervention_comment_pkey PRIMARY KEY (id);


--
-- Name: intervention_history intervention_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.intervention_history
    ADD CONSTRAINT intervention_history_pkey PRIMARY KEY (id);


--
-- Name: intervention intervention_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.intervention
    ADD CONSTRAINT intervention_pkey PRIMARY KEY (id);


--
-- Name: roles roles_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_name_key UNIQUE (name);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: ticket_history ticket_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ticket_history
    ADD CONSTRAINT ticket_history_pkey PRIMARY KEY (id);


--
-- Name: ticket ticket_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ticket
    ADD CONSTRAINT ticket_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_employee_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_employee_code_key UNIQUE (employee_code);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: ix_alert_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_alert_id ON public.alert USING btree (id);


--
-- Name: ix_departments_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_departments_id ON public.departments USING btree (id);


--
-- Name: ix_equipment_categories_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_equipment_categories_id ON public.equipment_categories USING btree (id);


--
-- Name: ix_equipment_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_equipment_id ON public.equipment USING btree (id);


--
-- Name: ix_incident_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_incident_id ON public.incident USING btree (id);


--
-- Name: ix_intervention_comment_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_intervention_comment_id ON public.intervention_comment USING btree (id);


--
-- Name: ix_intervention_history_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_intervention_history_id ON public.intervention_history USING btree (id);


--
-- Name: ix_intervention_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_intervention_id ON public.intervention USING btree (id);


--
-- Name: ix_roles_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_roles_id ON public.roles USING btree (id);


--
-- Name: ix_ticket_history_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_ticket_history_id ON public.ticket_history USING btree (id);


--
-- Name: ix_ticket_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_ticket_id ON public.ticket USING btree (id);


--
-- Name: ix_users_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_users_id ON public.users USING btree (id);


--
-- Name: alert alert_equipment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alert
    ADD CONSTRAINT alert_equipment_id_fkey FOREIGN KEY (equipment_id) REFERENCES public.equipment(id);


--
-- Name: alert alert_ticket_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alert
    ADD CONSTRAINT alert_ticket_id_fkey FOREIGN KEY (ticket_id) REFERENCES public.ticket(id);


--
-- Name: equipment fk_equipment_category; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipment
    ADD CONSTRAINT fk_equipment_category FOREIGN KEY (category_id) REFERENCES public.equipment_categories(id);


--
-- Name: equipment fk_equipment_department; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipment
    ADD CONSTRAINT fk_equipment_department FOREIGN KEY (department_id) REFERENCES public.departments(id);


--
-- Name: intervention fk_intervention_department; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.intervention
    ADD CONSTRAINT fk_intervention_department FOREIGN KEY (department_id) REFERENCES public.departments(id);


--
-- Name: intervention fk_intervention_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.intervention
    ADD CONSTRAINT fk_intervention_user FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: ticket fk_ticket_department; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ticket
    ADD CONSTRAINT fk_ticket_department FOREIGN KEY (department_id) REFERENCES public.departments(id);


--
-- Name: ticket fk_ticket_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ticket
    ADD CONSTRAINT fk_ticket_user FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: incident incident_equipment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incident
    ADD CONSTRAINT incident_equipment_id_fkey FOREIGN KEY (equipment_id) REFERENCES public.equipment(id);


--
-- Name: incident incident_ticket_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incident
    ADD CONSTRAINT incident_ticket_id_fkey FOREIGN KEY (ticket_id) REFERENCES public.ticket(id);


--
-- Name: intervention_comment intervention_comment_intervention_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.intervention_comment
    ADD CONSTRAINT intervention_comment_intervention_id_fkey FOREIGN KEY (intervention_id) REFERENCES public.intervention(id);


--
-- Name: intervention_history intervention_history_intervention_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.intervention_history
    ADD CONSTRAINT intervention_history_intervention_id_fkey FOREIGN KEY (intervention_id) REFERENCES public.intervention(id);


--
-- Name: intervention intervention_ticket_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.intervention
    ADD CONSTRAINT intervention_ticket_id_fkey FOREIGN KEY (ticket_id) REFERENCES public.ticket(id);


--
-- Name: ticket ticket_equipment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ticket
    ADD CONSTRAINT ticket_equipment_id_fkey FOREIGN KEY (equipment_id) REFERENCES public.equipment(id);


--
-- Name: ticket_history ticket_history_ticket_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ticket_history
    ADD CONSTRAINT ticket_history_ticket_id_fkey FOREIGN KEY (ticket_id) REFERENCES public.ticket(id);


--
-- Name: users users_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(id);


--
-- Name: users users_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id);


--
-- PostgreSQL database dump complete
--

\unrestrict PUnH7Swqul5tMd2pXC2O36PuVDJ6sfN3zcqSaDxXy0jcX1edCOqKYYIgV7RBuhr

