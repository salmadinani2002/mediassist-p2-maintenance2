--
-- PostgreSQL database dump
--

\restrict gz7rR0viAg7gje49fJX9m4XPZdD5bIkO8UWShx1PuR2YSDC7qJfSe300FvGd4aq

-- Dumped from database version 18.6
-- Dumped by pg_dump version 18.6

-- Started on 2026-09-16 22:52:29

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
-- TOC entry 242 (class 1259 OID 16658)
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
-- TOC entry 241 (class 1259 OID 16657)
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
-- TOC entry 5129 (class 0 OID 0)
-- Dependencies: 241
-- Name: alert_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.alert_id_seq OWNED BY public.alert.id;


--
-- TOC entry 236 (class 1259 OID 16567)
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
-- TOC entry 235 (class 1259 OID 16566)
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
-- TOC entry 5130 (class 0 OID 0)
-- Dependencies: 235
-- Name: departments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.departments_id_seq OWNED BY public.departments.id;


--
-- TOC entry 220 (class 1259 OID 16390)
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
-- TOC entry 240 (class 1259 OID 16614)
-- Name: equipment_categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.equipment_categories (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    description text
);


ALTER TABLE public.equipment_categories OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 16613)
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
-- TOC entry 5131 (class 0 OID 0)
-- Dependencies: 239
-- Name: equipment_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.equipment_categories_id_seq OWNED BY public.equipment_categories.id;


--
-- TOC entry 219 (class 1259 OID 16389)
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
-- TOC entry 5132 (class 0 OID 0)
-- Dependencies: 219
-- Name: equipment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.equipment_id_seq OWNED BY public.equipment.id;


--
-- TOC entry 226 (class 1259 OID 16471)
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
-- TOC entry 225 (class 1259 OID 16470)
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
-- TOC entry 5133 (class 0 OID 0)
-- Dependencies: 225
-- Name: incident_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.incident_id_seq OWNED BY public.incident.id;


--
-- TOC entry 224 (class 1259 OID 16434)
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
-- TOC entry 232 (class 1259 OID 16527)
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
-- TOC entry 231 (class 1259 OID 16526)
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
-- TOC entry 5134 (class 0 OID 0)
-- Dependencies: 231
-- Name: intervention_comment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.intervention_comment_id_seq OWNED BY public.intervention_comment.id;


--
-- TOC entry 230 (class 1259 OID 16510)
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
-- TOC entry 229 (class 1259 OID 16509)
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
-- TOC entry 5135 (class 0 OID 0)
-- Dependencies: 229
-- Name: intervention_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.intervention_history_id_seq OWNED BY public.intervention_history.id;


--
-- TOC entry 223 (class 1259 OID 16432)
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
-- TOC entry 5136 (class 0 OID 0)
-- Dependencies: 223
-- Name: intervention_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.intervention_id_seq OWNED BY public.intervention.id;


--
-- TOC entry 244 (class 1259 OID 16686)
-- Name: report; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.report (
    id integer NOT NULL,
    titre character varying(200) NOT NULL,
    periode_debut timestamp without time zone NOT NULL,
    periode_fin timestamp without time zone NOT NULL,
    total_tickets integer NOT NULL,
    tickets_resolus integer NOT NULL,
    taux_resolution_pourcent integer NOT NULL,
    total_incidents integer NOT NULL,
    total_interventions integer NOT NULL,
    interventions_terminees integer NOT NULL,
    resume text,
    date_generation timestamp without time zone NOT NULL
);


ALTER TABLE public.report OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 16685)
-- Name: report_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.report_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.report_id_seq OWNER TO postgres;

--
-- TOC entry 5137 (class 0 OID 0)
-- Dependencies: 243
-- Name: report_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.report_id_seq OWNED BY public.report.id;


--
-- TOC entry 234 (class 1259 OID 16553)
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    description text
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 16552)
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
-- TOC entry 5138 (class 0 OID 0)
-- Dependencies: 233
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- TOC entry 222 (class 1259 OID 16409)
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
-- TOC entry 228 (class 1259 OID 16493)
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
-- TOC entry 227 (class 1259 OID 16492)
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
-- TOC entry 5139 (class 0 OID 0)
-- Dependencies: 227
-- Name: ticket_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ticket_history_id_seq OWNED BY public.ticket_history.id;


--
-- TOC entry 221 (class 1259 OID 16407)
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
-- TOC entry 5140 (class 0 OID 0)
-- Dependencies: 221
-- Name: ticket_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ticket_id_seq OWNED BY public.ticket.id;


--
-- TOC entry 238 (class 1259 OID 16581)
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
-- TOC entry 237 (class 1259 OID 16580)
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
-- TOC entry 5141 (class 0 OID 0)
-- Dependencies: 237
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 4881 (class 2604 OID 16661)
-- Name: alert id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alert ALTER COLUMN id SET DEFAULT nextval('public.alert_id_seq'::regclass);


--
-- TOC entry 4878 (class 2604 OID 16570)
-- Name: departments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments ALTER COLUMN id SET DEFAULT nextval('public.departments_id_seq'::regclass);


--
-- TOC entry 4870 (class 2604 OID 16393)
-- Name: equipment id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipment ALTER COLUMN id SET DEFAULT nextval('public.equipment_id_seq'::regclass);


--
-- TOC entry 4880 (class 2604 OID 16617)
-- Name: equipment_categories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipment_categories ALTER COLUMN id SET DEFAULT nextval('public.equipment_categories_id_seq'::regclass);


--
-- TOC entry 4873 (class 2604 OID 16474)
-- Name: incident id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incident ALTER COLUMN id SET DEFAULT nextval('public.incident_id_seq'::regclass);


--
-- TOC entry 4872 (class 2604 OID 16437)
-- Name: intervention id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.intervention ALTER COLUMN id SET DEFAULT nextval('public.intervention_id_seq'::regclass);


--
-- TOC entry 4876 (class 2604 OID 16530)
-- Name: intervention_comment id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.intervention_comment ALTER COLUMN id SET DEFAULT nextval('public.intervention_comment_id_seq'::regclass);


--
-- TOC entry 4875 (class 2604 OID 16513)
-- Name: intervention_history id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.intervention_history ALTER COLUMN id SET DEFAULT nextval('public.intervention_history_id_seq'::regclass);


--
-- TOC entry 4882 (class 2604 OID 16689)
-- Name: report id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report ALTER COLUMN id SET DEFAULT nextval('public.report_id_seq'::regclass);


--
-- TOC entry 4877 (class 2604 OID 16556)
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- TOC entry 4871 (class 2604 OID 16413)
-- Name: ticket id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ticket ALTER COLUMN id SET DEFAULT nextval('public.ticket_id_seq'::regclass);


--
-- TOC entry 4874 (class 2604 OID 16496)
-- Name: ticket_history id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ticket_history ALTER COLUMN id SET DEFAULT nextval('public.ticket_history_id_seq'::regclass);


--
-- TOC entry 4879 (class 2604 OID 16584)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 5121 (class 0 OID 16658)
-- Dependencies: 242
-- Data for Name: alert; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.alert (id, type, titre, message, severite, statut, equipment_id, ticket_id, date_creation) FROM stdin;
\.


--
-- TOC entry 5115 (class 0 OID 16567)
-- Dependencies: 236
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
-- TOC entry 5099 (class 0 OID 16390)
-- Dependencies: 220
-- Data for Name: equipment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.equipment (id, inventory_code, name, category, service, brand, model, status, category_id, department_id) FROM stdin;
1	PC-OUJ-001	Ordinateur HP ProDesk	Poste	Informatique	HP	ProDesk 400 G6	En service	2	8
2	PC-OUJ-002	Ordinateur Dell OptiPlex	Poste	Administration	Dell	OptiPlex 7090	En service	2	7
3	PC-TEST-001	PC de test	Ordinateur	Radiologie	\N	\N	Opérationnel	\N	\N
4	EQ-URG-001	PC accueil urgences	Équipement informatique	Urgences	Dell	OptiPlex 7090	Opérationnel	2	1
5	EQ-ADM-002	Imprimante administrative	Imprimante	Administration	HP	LaserJet Pro	Opérationnel	5	7
6	EQ-RAD-003	Poste radiologie DICOM	Équipement informatique	Radiologie	Lenovo	ThinkStation P340	Opérationnel	2	4
7	EQ-SRV-008	Serveur applicatif	Serveur	Service Informatique	Cisco	UCS C220 M5	Opérationnel	4	8
8	EQ-REA-004	Moniteur patient réanimation	Équipement médical	Réanimation	Philips	IntelliVue MX450	En panne	1	2
\.


--
-- TOC entry 5119 (class 0 OID 16614)
-- Dependencies: 240
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
-- TOC entry 5105 (class 0 OID 16471)
-- Dependencies: 226
-- Data for Name: incident; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.incident (id, titre, description, priorite, statut, date_signalement, solution, equipment_id, ticket_id, technicien) FROM stdin;
3	Écran figé - poste accueil urgences	Écran figé au démarrage, plus aucune réaction au clavier	Haute	Ouvert	2026-09-10 08:15:00	\N	4	43	Sara kaddouri
4	Panne moniteur patient	Moniteur ne s'allume plus, alarme sonore continue	Critique	Ouvert	2026-09-13 22:05:00	\N	8	45	\N
5	Ralentissement serveur	Ralentissement anormal des temps de réponse	Critique	Nouveau	2026-08-05 16:00:00	\N	7	\N	\N
6	Ralentissement serveur	Ralentissement anormal des temps de réponse	Critique	Nouveau	2026-09-02 11:20:00	\N	7	\N	\N
\.


--
-- TOC entry 5103 (class 0 OID 16434)
-- Dependencies: 224
-- Data for Name: intervention; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.intervention (id, ticket_id, date_intervention, type_intervention, description, solution, technicien, statut, date_fin, actions, resultat, user_id, department_id) FROM stdin;
17	43	2026-09-10 09:00:00	Diagnostic matériel	Vérification alimentation et barrettes RAM	\N	Sara kaddouri	En cours	\N	\N	\N	\N	\N
18	44	2026-08-20 13:00:00	Réparation	Bourrage papier répété	\N	Youssef El amrani	Clôturée	2026-08-20 14:30:00	Nettoyage complet du chemin papier, remplacement du rouleau	Imprimante fonctionnelle, testée sur 20 pages sans incident	\N	\N
\.


--
-- TOC entry 5111 (class 0 OID 16527)
-- Dependencies: 232
-- Data for Name: intervention_comment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.intervention_comment (id, intervention_id, commentaire, date_commentaire) FROM stdin;
\.


--
-- TOC entry 5109 (class 0 OID 16510)
-- Dependencies: 230
-- Data for Name: intervention_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.intervention_history (id, intervention_id, action, ancien_statut, nouveau_statut, ancien_technicien, nouveau_technicien, date_action, ancienne_description, nouvelle_description, anciennes_actions, nouvelles_actions, ancienne_solution, nouvelle_solution, ancien_resultat, nouveau_resultat) FROM stdin;
\.


--
-- TOC entry 5123 (class 0 OID 16686)
-- Dependencies: 244
-- Data for Name: report; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.report (id, titre, periode_debut, periode_fin, total_tickets, tickets_resolus, taux_resolution_pourcent, total_incidents, total_interventions, interventions_terminees, resume, date_generation) FROM stdin;
1	Rapport septembre 2026	2026-09-01 00:00:00	2026-09-30 23:59:59	2	0	0	3	1	0	Sur la période du 01/09/2026 au 30/09/2026, 2 ticket(s) signalé(s), dont 0 résolu(s) (0%). 3 incident(s) déclaré(s) et 1 intervention(s) réalisée(s), dont 0 clôturée(s).	2026-09-15 21:11:20.8109
\.


--
-- TOC entry 5113 (class 0 OID 16553)
-- Dependencies: 234
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (id, name, description) FROM stdin;
1	Administrateur	Accès complet au système
2	Responsable Informatique	Gestion du parc informatique et des interventions
3	Technicien Informatique	Gestion des tickets et interventions techniques
\.


--
-- TOC entry 5101 (class 0 OID 16409)
-- Dependencies: 222
-- Data for Name: ticket; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ticket (id, equipment_id, date_signalement, description, priorite, statut, solution, date_resolution, technicien, user_id, department_id) FROM stdin;
43	4	2026-09-10 08:30:00	Écran figé au démarrage, plus aucune réaction au clavier	Haute	En cours	\N	\N	Sara kaddouri	\N	\N
44	5	2026-08-20 10:00:00	Bourrage papier récurrent sur le bac principal	Basse	Résolu	Nettoyage du bac et remplacement du rouleau d'entraînement	2026-08-20 14:30:00	Youssef El amrani	\N	\N
45	8	2026-09-13 22:10:00	Moniteur ne s'allume plus, alarme sonore continue	Critique	Ouvert	\N	\N	\N	\N	\N
\.


--
-- TOC entry 5107 (class 0 OID 16493)
-- Dependencies: 228
-- Data for Name: ticket_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ticket_history (id, ticket_id, action, ancien_statut, nouveau_statut, ancienne_priorite, nouvelle_priorite, date_action) FROM stdin;
\.


--
-- TOC entry 5117 (class 0 OID 16581)
-- Dependencies: 238
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, employee_code, first_name, last_name, email, phone, password_hash, role_id, department_id, is_active) FROM stdin;
1	EMP001	Admin	MediAssist	admin@mediassist.local	\N	TEMP_HASH	1	8	t
2	EMP002	Technicien	Informatique	technicien@mediassist.local	\N	TEMP_HASH	3	8	t
3	EMP003	Responsable	Informatique	responsable@mediassist.local	\N	TEMP_HASH	2	8	t
\.


--
-- TOC entry 5142 (class 0 OID 0)
-- Dependencies: 241
-- Name: alert_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.alert_id_seq', 3, true);


--
-- TOC entry 5143 (class 0 OID 0)
-- Dependencies: 235
-- Name: departments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.departments_id_seq', 8, true);


--
-- TOC entry 5144 (class 0 OID 0)
-- Dependencies: 239
-- Name: equipment_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.equipment_categories_id_seq', 5, true);


--
-- TOC entry 5145 (class 0 OID 0)
-- Dependencies: 219
-- Name: equipment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.equipment_id_seq', 8, true);


--
-- TOC entry 5146 (class 0 OID 0)
-- Dependencies: 225
-- Name: incident_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.incident_id_seq', 6, true);


--
-- TOC entry 5147 (class 0 OID 0)
-- Dependencies: 231
-- Name: intervention_comment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.intervention_comment_id_seq', 7, true);


--
-- TOC entry 5148 (class 0 OID 0)
-- Dependencies: 229
-- Name: intervention_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.intervention_history_id_seq', 25, true);


--
-- TOC entry 5149 (class 0 OID 0)
-- Dependencies: 223
-- Name: intervention_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.intervention_id_seq', 18, true);


--
-- TOC entry 5150 (class 0 OID 0)
-- Dependencies: 243
-- Name: report_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.report_id_seq', 1, true);


--
-- TOC entry 5151 (class 0 OID 0)
-- Dependencies: 233
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_id_seq', 3, true);


--
-- TOC entry 5152 (class 0 OID 0)
-- Dependencies: 227
-- Name: ticket_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ticket_history_id_seq', 17, true);


--
-- TOC entry 5153 (class 0 OID 0)
-- Dependencies: 221
-- Name: ticket_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ticket_id_seq', 45, true);


--
-- TOC entry 5154 (class 0 OID 0)
-- Dependencies: 237
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 3, true);


--
-- TOC entry 4929 (class 2606 OID 16672)
-- Name: alert alert_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alert
    ADD CONSTRAINT alert_pkey PRIMARY KEY (id);


--
-- TOC entry 4912 (class 2606 OID 16578)
-- Name: departments departments_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_name_key UNIQUE (name);


--
-- TOC entry 4914 (class 2606 OID 16576)
-- Name: departments departments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_pkey PRIMARY KEY (id);


--
-- TOC entry 4924 (class 2606 OID 16625)
-- Name: equipment_categories equipment_categories_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipment_categories
    ADD CONSTRAINT equipment_categories_name_key UNIQUE (name);


--
-- TOC entry 4926 (class 2606 OID 16623)
-- Name: equipment_categories equipment_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipment_categories
    ADD CONSTRAINT equipment_categories_pkey PRIMARY KEY (id);


--
-- TOC entry 4884 (class 2606 OID 16405)
-- Name: equipment equipment_inventory_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipment
    ADD CONSTRAINT equipment_inventory_code_key UNIQUE (inventory_code);


--
-- TOC entry 4886 (class 2606 OID 16403)
-- Name: equipment equipment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipment
    ADD CONSTRAINT equipment_pkey PRIMARY KEY (id);


--
-- TOC entry 4895 (class 2606 OID 16485)
-- Name: incident incident_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incident
    ADD CONSTRAINT incident_pkey PRIMARY KEY (id);


--
-- TOC entry 4904 (class 2606 OID 16538)
-- Name: intervention_comment intervention_comment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.intervention_comment
    ADD CONSTRAINT intervention_comment_pkey PRIMARY KEY (id);


--
-- TOC entry 4901 (class 2606 OID 16519)
-- Name: intervention_history intervention_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.intervention_history
    ADD CONSTRAINT intervention_history_pkey PRIMARY KEY (id);


--
-- TOC entry 4892 (class 2606 OID 16446)
-- Name: intervention intervention_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.intervention
    ADD CONSTRAINT intervention_pkey PRIMARY KEY (id);


--
-- TOC entry 4933 (class 2606 OID 16704)
-- Name: report report_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report
    ADD CONSTRAINT report_pkey PRIMARY KEY (id);


--
-- TOC entry 4908 (class 2606 OID 16564)
-- Name: roles roles_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_name_key UNIQUE (name);


--
-- TOC entry 4910 (class 2606 OID 16562)
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- TOC entry 4899 (class 2606 OID 16502)
-- Name: ticket_history ticket_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ticket_history
    ADD CONSTRAINT ticket_history_pkey PRIMARY KEY (id);


--
-- TOC entry 4890 (class 2606 OID 16425)
-- Name: ticket ticket_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ticket
    ADD CONSTRAINT ticket_pkey PRIMARY KEY (id);


--
-- TOC entry 4918 (class 2606 OID 16600)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 4920 (class 2606 OID 16598)
-- Name: users users_employee_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_employee_code_key UNIQUE (employee_code);


--
-- TOC entry 4922 (class 2606 OID 16596)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 4930 (class 1259 OID 16683)
-- Name: ix_alert_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_alert_id ON public.alert USING btree (id);


--
-- TOC entry 4915 (class 1259 OID 16579)
-- Name: ix_departments_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_departments_id ON public.departments USING btree (id);


--
-- TOC entry 4927 (class 1259 OID 16626)
-- Name: ix_equipment_categories_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_equipment_categories_id ON public.equipment_categories USING btree (id);


--
-- TOC entry 4887 (class 1259 OID 16406)
-- Name: ix_equipment_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_equipment_id ON public.equipment USING btree (id);


--
-- TOC entry 4896 (class 1259 OID 16491)
-- Name: ix_incident_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_incident_id ON public.incident USING btree (id);


--
-- TOC entry 4905 (class 1259 OID 16544)
-- Name: ix_intervention_comment_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_intervention_comment_id ON public.intervention_comment USING btree (id);


--
-- TOC entry 4902 (class 1259 OID 16525)
-- Name: ix_intervention_history_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_intervention_history_id ON public.intervention_history USING btree (id);


--
-- TOC entry 4893 (class 1259 OID 16452)
-- Name: ix_intervention_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_intervention_id ON public.intervention USING btree (id);


--
-- TOC entry 4931 (class 1259 OID 16705)
-- Name: ix_report_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_report_id ON public.report USING btree (id);


--
-- TOC entry 4906 (class 1259 OID 16565)
-- Name: ix_roles_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_roles_id ON public.roles USING btree (id);


--
-- TOC entry 4897 (class 1259 OID 16508)
-- Name: ix_ticket_history_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_ticket_history_id ON public.ticket_history USING btree (id);


--
-- TOC entry 4888 (class 1259 OID 16431)
-- Name: ix_ticket_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_ticket_id ON public.ticket USING btree (id);


--
-- TOC entry 4916 (class 1259 OID 16611)
-- Name: ix_users_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_users_id ON public.users USING btree (id);


--
-- TOC entry 4949 (class 2606 OID 16673)
-- Name: alert alert_equipment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alert
    ADD CONSTRAINT alert_equipment_id_fkey FOREIGN KEY (equipment_id) REFERENCES public.equipment(id);


--
-- TOC entry 4950 (class 2606 OID 16678)
-- Name: alert alert_ticket_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alert
    ADD CONSTRAINT alert_ticket_id_fkey FOREIGN KEY (ticket_id) REFERENCES public.ticket(id);


--
-- TOC entry 4934 (class 2606 OID 16627)
-- Name: equipment fk_equipment_category; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipment
    ADD CONSTRAINT fk_equipment_category FOREIGN KEY (category_id) REFERENCES public.equipment_categories(id);


--
-- TOC entry 4935 (class 2606 OID 16632)
-- Name: equipment fk_equipment_department; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipment
    ADD CONSTRAINT fk_equipment_department FOREIGN KEY (department_id) REFERENCES public.departments(id);


--
-- TOC entry 4939 (class 2606 OID 16652)
-- Name: intervention fk_intervention_department; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.intervention
    ADD CONSTRAINT fk_intervention_department FOREIGN KEY (department_id) REFERENCES public.departments(id);


--
-- TOC entry 4940 (class 2606 OID 16647)
-- Name: intervention fk_intervention_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.intervention
    ADD CONSTRAINT fk_intervention_user FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 4936 (class 2606 OID 16642)
-- Name: ticket fk_ticket_department; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ticket
    ADD CONSTRAINT fk_ticket_department FOREIGN KEY (department_id) REFERENCES public.departments(id);


--
-- TOC entry 4937 (class 2606 OID 16637)
-- Name: ticket fk_ticket_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ticket
    ADD CONSTRAINT fk_ticket_user FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 4942 (class 2606 OID 16486)
-- Name: incident incident_equipment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incident
    ADD CONSTRAINT incident_equipment_id_fkey FOREIGN KEY (equipment_id) REFERENCES public.equipment(id);


--
-- TOC entry 4943 (class 2606 OID 16547)
-- Name: incident incident_ticket_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incident
    ADD CONSTRAINT incident_ticket_id_fkey FOREIGN KEY (ticket_id) REFERENCES public.ticket(id);


--
-- TOC entry 4946 (class 2606 OID 16539)
-- Name: intervention_comment intervention_comment_intervention_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.intervention_comment
    ADD CONSTRAINT intervention_comment_intervention_id_fkey FOREIGN KEY (intervention_id) REFERENCES public.intervention(id);


--
-- TOC entry 4945 (class 2606 OID 16520)
-- Name: intervention_history intervention_history_intervention_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.intervention_history
    ADD CONSTRAINT intervention_history_intervention_id_fkey FOREIGN KEY (intervention_id) REFERENCES public.intervention(id);


--
-- TOC entry 4941 (class 2606 OID 16447)
-- Name: intervention intervention_ticket_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.intervention
    ADD CONSTRAINT intervention_ticket_id_fkey FOREIGN KEY (ticket_id) REFERENCES public.ticket(id);


--
-- TOC entry 4938 (class 2606 OID 16426)
-- Name: ticket ticket_equipment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ticket
    ADD CONSTRAINT ticket_equipment_id_fkey FOREIGN KEY (equipment_id) REFERENCES public.equipment(id);


--
-- TOC entry 4944 (class 2606 OID 16503)
-- Name: ticket_history ticket_history_ticket_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ticket_history
    ADD CONSTRAINT ticket_history_ticket_id_fkey FOREIGN KEY (ticket_id) REFERENCES public.ticket(id);


--
-- TOC entry 4947 (class 2606 OID 16606)
-- Name: users users_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(id);


--
-- TOC entry 4948 (class 2606 OID 16601)
-- Name: users users_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id);


-- Completed on 2026-09-16 22:52:30

--
-- PostgreSQL database dump complete
--

\unrestrict gz7rR0viAg7gje49fJX9m4XPZdD5bIkO8UWShx1PuR2YSDC7qJfSe300FvGd4aq

