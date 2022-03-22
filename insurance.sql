--
-- PostgreSQL database dump
--

-- Dumped from database version 13.3
-- Dumped by pg_dump version 13.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: category; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.category AS ENUM (
    'active',
    'not active'
);


ALTER TYPE public.category OWNER TO postgres;

--
-- Name: gen; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.gen AS ENUM (
    'M',
    'F'
);


ALTER TYPE public.gen OWNER TO postgres;

--
-- Name: group_; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.group_ AS ENUM (
    'private',
    'professional',
    'mixed use'
);


ALTER TYPE public.group_ OWNER TO postgres;

--
-- Name: vehicle_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.vehicle_type AS ENUM (
    'car',
    'motorcycle',
    'track'
);


ALTER TYPE public.vehicle_type OWNER TO postgres;

--
-- Name: categ_contracts(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.categ_contracts() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
begin
	if new.end_date < current_date then
		update contracts set contract_category = 'not active';
		return new;
	else
		update contracts set contract_category = 'active';
		return new;
	end if;
end;
$$;


ALTER FUNCTION public.categ_contracts() OWNER TO postgres;

--
-- Name: p_contracts(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.p_contracts() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
begin
	update contracts 
	set end_date = end_date + interval '1 year'
	where end_date = current_date and contract_group = 'professional';
	return new;
end;
$$;


ALTER FUNCTION public.p_contracts() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: address_info; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.address_info (
    address_id character varying(15) NOT NULL,
    zip_code character varying(20) NOT NULL,
    country character varying(100) NOT NULL,
    city character varying(100) NOT NULL,
    street character varying(200) NOT NULL
);


ALTER TABLE public.address_info OWNER TO postgres;

--
-- Name: contracts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contracts (
    contract_code character varying(50) NOT NULL,
    license_plate character varying(30) NOT NULL,
    contract_group public.group_ NOT NULL,
    cost numeric(100,2) NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    customer_id character varying(10) NOT NULL,
    contract_category public.category,
    CONSTRAINT contracts_check CHECK ((start_date < end_date)),
    CONSTRAINT contracts_cost_check CHECK ((cost > (0)::numeric))
);


ALTER TABLE public.contracts OWNER TO postgres;

--
-- Name: customers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customers (
    customer_id character varying(10) NOT NULL,
    full_name character varying(50) NOT NULL,
    gender public.gen DEFAULT 'M'::public.gen NOT NULL,
    birthday date NOT NULL,
    phone_number character varying(30),
    cell_phone character varying(30),
    email character varying(100),
    address_id character varying(50) NOT NULL,
    CONSTRAINT customers_birthday_check CHECK (((date_part('year'::text, CURRENT_DATE) - date_part('year'::text, birthday)) >= (18)::double precision)),
    CONSTRAINT customers_check CHECK ((((phone_number)::text <> NULL::text) OR ((cell_phone)::text <> NULL::text)))
);


ALTER TABLE public.customers OWNER TO postgres;

--
-- Name: drivers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.drivers (
    license_number character varying(50) NOT NULL,
    license_plate character varying(30) NOT NULL
);


ALTER TABLE public.drivers OWNER TO postgres;

--
-- Name: drivers_info; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.drivers_info (
    license_number character varying(50) NOT NULL,
    full_name character varying(50) NOT NULL,
    gender public.gen DEFAULT 'M'::public.gen NOT NULL,
    birthday date NOT NULL,
    address_id character varying(30) NOT NULL
);


ALTER TABLE public.drivers_info OWNER TO postgres;

--
-- Name: drivers_violations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.drivers_violations (
    violation_id character varying(10) NOT NULL,
    license_number character varying(50) NOT NULL,
    license_plate character varying(30) NOT NULL
);


ALTER TABLE public.drivers_violations OWNER TO postgres;

--
-- Name: vehicles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vehicles (
    license_plate character varying(30) NOT NULL,
    frame_number character(17) NOT NULL,
    model_id character varying(15) NOT NULL,
    color character varying(50) NOT NULL,
    category public.vehicle_type DEFAULT 'car'::public.vehicle_type NOT NULL
);


ALTER TABLE public.vehicles OWNER TO postgres;

--
-- Name: vehicles_info; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vehicles_info (
    model_id character varying(15) NOT NULL,
    model character varying(200) NOT NULL,
    first_release numeric(4,0) NOT NULL,
    brand character varying(50) NOT NULL,
    price integer NOT NULL,
    CONSTRAINT vehicles_info_price_check CHECK ((price > 0))
);


ALTER TABLE public.vehicles_info OWNER TO postgres;

--
-- Name: violations_info; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.violations_info (
    violation_id character varying(10) NOT NULL,
    violation_code character varying(10) NOT NULL,
    date_time timestamp without time zone NOT NULL,
    description character varying(300) NOT NULL
);


ALTER TABLE public.violations_info OWNER TO postgres;

--
-- Data for Name: address_info; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.address_info (address_id, zip_code, country, city, street) FROM stdin;
1	30266	Japan	Okunoya	0623 Hermina Parkway
2	46465	Indonesia	Kapunduk	41480 Esker Way
3	646728	Lebanon	Djounie	10298 Farwell Pass
4	500766	China	Kesheng	3075 Butterfield Alley
5	637388	United States	Pittsburgh	77614 Welch Trail
6	752540	Poland	Garbów	9192 Vernon Plaza
7	149477	Armenia	Argel	85299 Grover Alley
8	27131	Indonesia	Bitobe	93246 Clarendon Center
9	815479	China	Yanglin	767 Fremont Point
10	525786	Iran	Takāb	564 Forster Way
11	854380	China	Yanling	288 1st Junction
12	561529	China	Sanjiang	49 Pepper Wood Park
13	595044	Indonesia	Ongabelen	72 Transport Plaza
14	94892	Canada	Brampton	27736 Colorado Plaza
15	499910	Portugal	Cachadinha	4 Duke Point
16	155002	Malaysia	Kuala Terengganu	530 South Alley
17	701821	Egypt	Al Ḩawāmidīyah	59 Ridge Oak Trail
18	402335	Russia	Tyrnyauz	981 Algoma Junction
19	963208	China	Jiegan	787 Prentice Road
20	365956	Latvia	Ādaži	5182 Grayhawk Crossing
21	943372	Estonia	Mustvee	02 Huxley Point
22	508863	France	Massy	264 Utah Drive
23	899616	Philippines	Bontoc	8 Gina Plaza
24	867064	Chad	Bébédja	43 Sloan Alley
25	994857	Honduras	Tocoa	26 International Road
26	659457	Colombia	Nariño	68081 Dawn Lane
27	830816	Brazil	Araranguá	34653 Mendota Park
28	814614	New Zealand	Foxton	0488 Manley Parkway
29	629080	Peru	Yanac	768 Nova Crossing
30	93583	China	Yingyang	69002 Thompson Point
31	632733	China	Zhourui	9695 Cherokee Circle
32	828080	Finland	Tampere	837 Thompson Place
33	829686	Ivory Coast	Tanda	19613 Hintze Pass
34	678639	Canada	Calmar	634 Fulton Avenue
35	344455	China	Hongshunli	545 Almo Terrace
36	292034	China	Xiaoruo	678 Eggendart Center
37	66647	Cameroon	Kumba	79998 Welch Alley
38	29122	China	Wushan	31 Golden Leaf Circle
39	141068	Iran	Kāshmar	8636 Dottie Way
40	244235	China	Zhenyuan	816 Red Cloud Place
41	460409	South Korea	Samsan	906 Mallard Drive
42	694776	Indonesia	Berbek	65 Kensington Crossing
43	738700	Argentina	San Pedro	94688 Jay Street
44	140462	Kazakhstan	Shashūbay	549 Shasta Plaza
45	556851	China	Datuan	1303 Briar Crest Way
46	769775	Venezuela	San Juan de Manapiare	7 Dakota Way
47	255838	Poland	Mikołów	67 Hooker Court
48	694767	Panama	Quebrada Canoa	06 Marcy Terrace
49	555787	China	Henglu	82 Old Shore Place
50	196714	Portugal	Ourentã	67 Alpine Crossing
51	674178	Philippines	Conel	0 Sugar Avenue
52	772712	Macedonia	Kochani	06242 Onsgard Plaza
53	339918	Russia	Birobidzhan	5730 Caliangt Street
54	441290	China	Baishui	68402 Laurel Trail
55	143377	Ireland	Cluain Meala	9235 Rowland Place
56	148432	China	Tangtu	22821 Carberry Trail
57	131427	Brazil	Irati	8465 Kipling Way
58	986751	Japan	Miyazaki-shi	7 Northridge Trail
59	341376	Indonesia	Sumuragung	5 Brown Junction
60	107916	Sweden	Sundsvall	4661 Oak Park
61	376130	Russia	Chupa	0 Golf Parkway
62	785552	China	Shimen	7143 Badeau Alley
63	808783	China	Yunping	38 Manley Lane
64	274888	Indonesia	Tlogowungu	85 Rusk Lane
65	975360	French Polynesia	Hitiaa	70413 Arrowood Way
66	187607	Russia	Konosha	7633 Kingsford Pass
67	228629	China	Panshi	970 7th Lane
68	826259	Syria	Dhībīn	17708 Mockingbird Park
69	919800	Greece	Vári	73 Nelson Place
70	337973	China	Wangmo	8622 Gale Crossing
71	519271	China	Jiaowei	51 Red Cloud Parkway
72	296335	China	Dangmu	633 Marquette Parkway
73	503016	China	Chengzhong	23 Kinsman Street
74	14875	Portugal	Verdizela	06 Scott Parkway
75	824443	China	Hongchang	5 Arkansas Parkway
76	554815	France	Marseille	82047 Butterfield Alley
77	497192	Sweden	Tibro	0713 Norway Maple Alley
78	109469	China	Jiantian	68283 Gateway Point
79	50585	Finland	Ikaalinen	582 Maryland Junction
80	908203	Canada	Richmond	91 Esker Plaza
81	992832	China	Daping	917 Coolidge Alley
82	736244	China	Jindong	0 Scott Junction
83	421089	Barbados	Four Cross Roads	4043 Packers Pass
84	90829	United States	Fort Worth	193 Service Trail
85	685835	South Africa	Willowmore	27968 Sachtjen Parkway
86	231033	China	Huangnihe	33 Victoria Park
87	496753	China	Hongdun	63 Grim Terrace
88	28648	Philippines	Piñahan	12 Banding Terrace
89	815556	United Kingdom	Leeds	3 Bunker Hill Place
90	189367	Argentina	Tres Arroyos	487 Oxford Way
91	245168	Poland	Szczawno-Zdrój	90 Sunbrook Lane
92	717604	Saudi Arabia	Tanūmah	9535 Sunfield Hill
93	55286	Indonesia	Balengbeng	2330 Delaware Lane
94	725889	Netherlands	Leeuwarden	23 Esch Point
95	62659	Philippines	San Francisco	01 New Castle Junction
96	912344	Paraguay	Altos	7 Vidon Court
97	480133	Thailand	Ban Talat Bueng	4583 Dawn Terrace
98	282459	United States	Annapolis	81 Portage Drive
99	915457	Canada	Wabana	4805 Moland Plaza
100	263887	United States	Baltimore	4136 Kim Park
101	142644	Croatia	Čakovec	9 Melvin Court
102	303433	Philippines	Ambulong	81 Columbus Place
103	350684	Poland	Jednorożec	323 Bay Crossing
104	578249	Russia	Krechevitsy	1 Cody Crossing
105	878597	French Polynesia	Vaitape	2384 Scott Court
106	680528	Indonesia	Biito	2336 Prairieview Plaza
107	730195	Indonesia	Kimakamak	1912 Linden Pass
108	884804	Poland	Radostowice	26 Anhalt Way
109	63163	China	Xiashixiang	40946 Gateway Pass
110	274750	Indonesia	Kuala Bintang	67044 Texas Parkway
111	310767	Guatemala	Senahú	34939 Valley Edge Avenue
112	318783	Philippines	General Luna	3146 Northview Hill
113	466298	Austria	Sankt Lorenzen im Mürztal	816 Pine View Parkway
114	836138	Poland	Janowice	69219 Welch Hill
115	411581	Azerbaijan	Qaxbaş	77 Hayes Road
116	805882	Netherlands	Woerden	79351 Hoffman Park
117	944608	China	Huangzhai	38539 Jana Park
118	734224	Bosnia and Herzegovina	Stupari	00360 Farmco Alley
119	514713	Indonesia	Sindangsari	06119 Crownhardt Parkway
120	646426	Venezuela	San Fernando de Atabapo	99 Shelley Parkway
121	994731	Russia	Georgiyevsk	14 Burning Wood Point
122	947315	Indonesia	Mojogajeh	8 Ilene Terrace
123	14646	Russia	Dmitriyevskoye	81 Bay Court
124	908601	Argentina	Quimilí	78531 South Pass
125	935369	Israel	Azor	2989 Maple Wood Plaza
126	420513	Belarus	Kokhanava	3 Browning Alley
127	857157	Puerto Rico	San Juan	1320 Fulton Lane
128	309617	China	Zhangyelu	01491 Hooker Junction
129	405774	Indonesia	Ambon	741 Rigney Terrace
130	745782	Kazakhstan	Oktyabr’sk	1 Judy Road
131	726104	United States	Salt Lake City	93734 Elmside Lane
132	302080	Portugal	Antas	925 Golf Course Street
133	734099	China	Beiping	436 Judy Road
134	633577	Philippines	Tarangnan	9378 Anhalt Hill
135	529037	Sweden	Haparanda	4916 Esker Point
136	536634	China	Kangshan	20 Trailsway Alley
137	296030	Philippines	Upig	8493 Toban Way
138	238403	Albania	Baz	714 Buhler Trail
139	788736	Sweden	Öjebyn	82 Paget Road
140	173478	China	Xiaoyue	2098 Jana Place
141	72182	Indonesia	Demuk	61480 Sundown Street
142	191131	Hungary	Szombathely	46 Eastwood Park
143	323552	China	Dalang	9663 Bay Road
144	167304	Mexico	Linda Vista	92 Hintze Point
145	179128	Slovenia	Šoštanj	66170 Waxwing Street
146	619333	Argentina	General Levalle	1850 Emmet Alley
147	405350	Syria	Tall Tamr	83347 Bartelt Center
148	500822	Gambia	Sankwia	4051 Declaration Drive
149	174355	China	Mumen	7 Lindbergh Center
150	530276	Tunisia	Tozeur	20961 Anthes Street
151	844663	Indonesia	Ganggawang	0 Lighthouse Bay Drive
152	86532	China	Lijiapu	7 Atwood Plaza
153	29176	Canada	Woodstock	164 Victoria Alley
154	901377	Reunion	Saint-Pierre	775 Mifflin Plaza
155	699618	China	Jianchang	71398 Rockefeller Court
156	392144	Afghanistan	Ḩukūmat-e Shīnkaī	57 Esch Trail
157	556634	Poland	Solec-Zdrój	2 Lakeland Terrace
158	535206	Macedonia	Karbinci	4 Mandrake Pass
159	591323	China	Yumendong	26889 Montana Center
160	206633	Colombia	Cartago	624 Farmco Lane
161	543167	Philippines	Lourdes	3050 Straubel Terrace
162	510382	Albania	Grekan	3 Mcguire Point
163	894450	Czech Republic	Bzenec	67883 Northport Way
164	666143	France	Le Grand-Quevilly	2 Ridge Oak Center
165	405332	Bosnia and Herzegovina	Ilići	3 Clarendon Place
166	984732	Portugal	Serrinha	58 Bunker Hill Way
167	959649	Vietnam	Hoàn Kiếm	72937 Westend Pass
168	987806	Russia	Surkhakhi	4213 Melody Trail
169	596241	France	Voiron	58 Pennsylvania Place
170	560719	Vietnam	Năm Căn	49315 Menomonie Circle
171	355331	Indonesia	Bojongsari	0157 Fulton Drive
172	507670	Mexico	San Juan	66 Oxford Avenue
173	538206	Brazil	Alenquer	60 Stuart Court
174	946818	Italy	Firenze	78652 High Crossing Pass
175	268520	Reunion	Saint-Denis	20463 Onsgard Park
176	550	Uruguay	San Bautista	181 Montana Way
177	427294	Armenia	Gyumri	98 4th Road
178	986787	Portugal	Pigeiros	850 Carpenter Pass
179	394760	Indonesia	Anjirserapat	2 Mallory Hill
180	24487	China	Pu’er	7756 Gerald Terrace
181	491910	Portugal	Selmes	11977 Burning Wood Junction
182	579812	Argentina	Villa Ocampo	324 Pond Circle
183	878655	Guatemala	Santa Lucía Cotzumalguapa	838 Twin Pines Hill
184	468078	China	Tongmuluo	19 Victoria Alley
185	314067	China	Daoxian	57021 Ridgeview Avenue
186	624242	Venezuela	Puerto de Nutrias	66 Hoard Court
187	948912	Vietnam	Kỳ Anh	457 Thackeray Trail
188	987239	Morocco	Adassil	3 Elgar Plaza
189	402258	Cuba	Remedios	0 Orin Court
190	665575	Brazil	Rubiataba	77694 Hauk Way
191	29218	United States	Dearborn	4 Manley Terrace
192	130420	Philippines	Atok	0 Reindahl Drive
193	438124	China	Cennan	2426 Gale Circle
194	869939	Mongolia	Orhon	79470 Golden Leaf Junction
195	917296	Greece	Ouranoupolis	19678 Merrick Hill
196	725716	Niger	Tanout	5 Myrtle Court
197	150009	Colombia	Chía	964 Hazelcrest Park
198	625837	Uganda	Kotido	9686 School Way
199	79906	Japan	Katsuura	0650 Moland Lane
200	558877	Sweden	Borlänge	22 Texas Lane
201	465861	China	Songping	3597 Roth Terrace
202	910747	Malaysia	Kangar	13 Coolidge Lane
203	310808	China	Lümeng	1 Merrick Terrace
204	618863	Greece	Panórama	24668 Longview Road
205	829357	China	Micheng	8 Superior Place
206	681550	Greece	Álimos	36 Esker Plaza
207	311945	Portugal	Refojos de Riba de Ave	86259 Tennessee Plaza
208	968195	China	Xiaping	012 Monica Street
209	668133	Sweden	Lidingö	9 Fairfield Circle
210	760573	Serbia	Bačka Palanka	35 Ridge Oak Point
211	831362	China	Toubao	18414 Orin Terrace
212	73996	China	Shuiyang	94 Waywood Avenue
213	528236	Nigeria	Oyan	2667 Barnett Parkway
214	422855	Indonesia	Jambean	119 Jana Terrace
215	479621	China	Pingshan	264 Ridge Oak Street
216	128525	Philippines	San Fernando	4378 Norway Maple Park
217	135949	China	Payxambabazar	48 Eagle Crest Parkway
218	765408	Canada	Stratford	726 Westport Avenue
219	114965	Poland	Wąpielsk	0604 Trailsway Crossing
220	96042	China	Xinji	3461 Moland Terrace
221	236349	France	Longwy	22 Kinsman Center
222	301385	China	Tangtou	066 Village Green Plaza
223	578461	Belarus	Haradzyeya	8 Algoma Plaza
224	815692	China	Nanlang	8 International Terrace
225	34953	Poland	Hyżne	953 Schlimgen Avenue
226	122911	China	Shengci	24 Rockefeller Place
227	998448	Colombia	Cañasgordas	46077 Mcguire Lane
228	732050	Sweden	Stockholm	123 Tennyson Parkway
229	582730	Poland	Lubasz	763 Bartelt Terrace
230	988507	Thailand	Na Chueak	8 Shoshone Lane
231	135947	Indonesia	Wangkung	7 North Crossing
232	283353	China	Zuocun	69 Waubesa Way
233	183084	Brazil	São Miguel do Iguaçu	108 Gateway Center
234	371701	Colombia	Pelaya	1 Logan Way
235	459611	Indonesia	Kalianyar Selatan	1495 Rigney Center
236	134297	China	Jiwei	43044 Browning Point
237	752002	China	Jishan	9 Thackeray Street
238	480492	China	Fuling	2574 Sundown Lane
239	851627	Ukraine	Usatove	1155 Pennsylvania Pass
240	945602	Indonesia	Borehbangle	8152 Laurel Point
241	701343	Colombia	Caramanta	5948 Sycamore Street
242	677757	Brazil	Iperó	00926 Hoffman Point
243	921384	Bangladesh	Gafargaon	385 Debra Junction
244	112572	Indonesia	Suru	69 Holmberg Plaza
245	458261	United States	Houston	09 Stephen Terrace
246	637713	Belgium	Bouillon	538 Gale Drive
247	743196	China	Wuyun	2417 Doe Crossing Pass
248	769201	Kazakhstan	Sastöbe	288 Dovetail Park
249	61018	China	Jiazhuyuan	5698 Northland Lane
250	877155	Russia	Zaprudnya	7664 Blue Bill Park Alley
251	868295	Mauritius	Arsenal	1681 Main Plaza
252	865860	Portugal	Nelas	20115 Susan Road
253	833802	Indonesia	Curug	4 Michigan Center
254	776792	China	Maqian	0521 Farwell Trail
255	448277	United Kingdom	Belfast	96 Esch Way
256	44279	Portugal	Lagoaça	131 Sutherland Road
257	981486	South Africa	Mtubatuba	69 Texas Terrace
258	312444	United States	Milwaukee	365 Gateway Way
259	129268	Philippines	Iba	828 Ilene Parkway
260	726176	Trinidad and Tobago	Peñal	7 Ilene Place
261	637572	United States	Lancaster	0 Fallview Park
262	295688	Chile	Coronel	557 Orin Circle
263	678798	Indonesia	Telangi Satu	8 Welch Parkway
264	981114	China	Xiashuitou	654 Evergreen Court
265	382467	El Salvador	Nueva Guadalupe	98298 Clyde Gallagher Terrace
266	818600	China	Shimiaozi	443 Emmet Lane
267	864761	China	Huomachong	68997 Dunning Pass
268	276861	Indonesia	Sukasenang	81375 Straubel Avenue
269	378724	Poland	Gierłoż	012 Sunfield Court
270	668972	China	Jintao	742 Lerdahl Trail
271	293059	Peru	Ricardo Palma	4715 Oakridge Alley
272	359117	Indonesia	Batujaran	4098 High Crossing Park
273	361598	China	Kaishantun	68 Helena Street
274	726406	China	Xiuyu	968 Mariners Cove Point
275	112270	Colombia	Sibaté	7 Nancy Way
276	419557	China	Songhe	112 Gale Terrace
277	927862	Poland	Osiek	772 Columbus Way
278	906890	Indonesia	Bodeh	5 Schurz Way
279	467610	China	Luzhou	15665 Transport Hill
280	561783	Finland	Honkajoki	7 Kennedy Junction
281	46220	Philippines	Dado	29882 Sauthoff Way
282	26643	Indonesia	Babakankiray	3517 Westport Park
283	671496	Brazil	Jacareí	2 Ohio Plaza
284	202695	United States	Reno	27748 Fordem Alley
285	737438	Argentina	General Arenales	85 Sommers Center
286	933545	Brazil	Itatiba	6315 Manitowish Parkway
287	918769	Taiwan	Taichung	39712 Moland Road
288	361387	Madagascar	Nosy Varika	908 Florence Circle
289	262688	Tanzania	Misungwi	76946 Rigney Trail
290	720781	Czech Republic	Velké Němčice	8241 Ruskin Center
291	730652	Russia	Torbeyevo	0474 Briar Crest Pass
292	267347	Nigeria	Kaduna	22 Ruskin Crossing
293	273093	Estonia	Võhma	51 Haas Parkway
294	101523	Indonesia	Indramayu	222 Sheridan Alley
295	460356	Russia	Kurchatov	890 Bunting Park
296	199633	Indonesia	Cibolek Kidul	7665 Fulton Lane
297	877861	Palestinian Territory	Kafr Qūd	5 Lukken Junction
298	611290	Poland	Jadowniki Mokre	13456 Oakridge Crossing
299	63950	China	Xicun	09 Russell Road
300	450195	Russia	Kirovgrad	7217 Graedel Parkway
301	446164	Thailand	Sahatsakhan	9 Southridge Terrace
302	609310	Poland	Czarnocin	6 Farmco Point
303	43150	China	Fenglin	6 Hoard Place
304	225163	China	Jinchang	370 Independence Road
305	272042	Sweden	Svenljunga	0842 Dayton Park
306	545545	Spain	Santiago De Compostela	30901 Stone Corner Plaza
307	430181	Poland	Siemiątkowo	817 Spaight Road
308	461204	China	Jiangshan	83 Gulseth Park
309	819922	Philippines	Sumilao	178 Cody Pass
310	518624	China	Zhuangta	2 Boyd Circle
311	914613	China	Meicheng	330 Old Shore Alley
312	264567	Russia	Tekstil’shchiki	519 Eliot Terrace
313	364186	Thailand	Na Khu	0 Hagan Trail
314	994775	Canada	Beaconsfield	8460 Hoepker Lane
315	397439	Indonesia	Pangawaren	26652 Scott Center
316	229444	Nicaragua	Nandaime	3 Brentwood Plaza
317	38020	Indonesia	Pomahan	09 High Crossing Parkway
318	427076	Colombia	Chiquinquirá	8 Bashford Park
319	871209	China	Xiluo	51108 Mandrake Drive
320	320784	Colombia	Granada	708 Arizona Trail
321	174879	France	Les Sables-d'Olonne	02 Raven Center
322	965887	China	Yaojiagou	054 Crowley Lane
323	129053	United States	Fort Worth	1334 Comanche Place
324	70592	Ukraine	Stetseva	31 Summer Ridge Parkway
325	92672	Namibia	Bagani	29511 1st Point
326	732034	Azerbaijan	Quba	90 Havey Way
327	334574	Morocco	Boulemane	527 Eastlawn Parkway
328	519131	Norway	Moss	101 Lindbergh Park
329	662506	Portugal	Ferreira do Zêzere	5356 Green Ridge Crossing
330	983217	Malaysia	Klang	91480 Petterle Street
331	27397	Indonesia	Karangpapak	27 Nobel Plaza
332	766612	Russia	Ossora	88 Toban Court
333	192710	France	Villefranche-sur-Mer	058 Lotheville Center
334	185784	Norway	Moss	531 Goodland Center
335	676858	United Kingdom	Merton	685 Vernon Pass
336	550801	China	Tayang	8480 Merchant Place
337	781345	Sweden	Sundbyberg	37 Park Meadow Road
338	92055	Ukraine	Chornobay	9 International Center
339	489524	Indonesia	Sumberan	9926 Division Parkway
340	367141	Greece	Néa Ionía	04 Pleasure Road
341	462910	Russia	Gornorechenskiy	78 Eagan Road
342	970377	Poland	Maniowy	945 Michigan Way
343	878214	Philippines	Banaybanay	0804 Gale Lane
344	951829	France	Avignon	95688 Mcbride Point
345	574044	Poland	Nekla	7 Onsgard Place
346	401153	Indonesia	Lela	4 Bunker Hill Hill
347	209383	Mexico	San Antonio	478 Village Circle
348	160252	Peru	Pucacaca	54270 Sachs Terrace
349	264599	Mongolia	Ongi	5530 Blaine Junction
350	475736	Mozambique	Lichinga	73 Gerald Street
351	807656	Brazil	Barrinha	2 Jana Trail
352	53733	Brazil	Cataguases	4414 Autumn Leaf Parkway
353	56992	Peru	Morropón	7061 Cardinal Drive
354	227588	Czech Republic	Studénka	20 Summer Ridge Trail
355	513774	Poland	Święciechowa	0 Summit Terrace
356	459367	Russia	Nyagan	5 Anniversary Lane
357	72478	Portugal	Ajuda	54 Graedel Road
358	720498	China	Hongshan	4 Bartillon Trail
359	322679	China	Licun	3871 Troy Crossing
360	809038	Philippines	Agoo	0 Crownhardt Point
361	918543	Peru	Ocoyo	7170 Crest Line Crossing
362	21650	Tunisia	Dar Chabanne	65 Division Alley
363	800974	Mexico	Emiliano Zapata	26910 Granby Way
364	749185	Indonesia	Mantingantengah	539 Garrison Drive
365	736764	Greece	Kanália	1 Canary Pass
366	309859	Sweden	Norrköping	124 Mitchell Center
367	43315	China	Zheyuan	60497 Delaware Parkway
368	190859	China	Chaodi	163 Birchwood Hill
369	866088	China	Da’an	408 Butterfield Drive
370	967593	Tunisia	Jendouba	4 Farmco Crossing
371	822496	Philippines	Simimbaan	4732 Maywood Center
372	38	China	Chuanxi	9 Ilene Street
373	603919	Colombia	Jamundí	4394 Marcy Place
374	694123	Indonesia	Cempa	35 Pond Crossing
375	686078	Cambodia	Paôy Pêt	522 Laurel Circle
376	575136	Uzbekistan	Yaypan	9544 Tennyson Park
377	277588	Myanmar	Kyaiklat	6870 Kensington Drive
378	52750	Philippines	Palanas	3587 Oak Pass
379	52360	Indonesia	Wonosari	07447 Becker Way
380	589299	China	Songzhuang	0 Fair Oaks Avenue
381	675232	Indonesia	Tunggaoen Timur	67 Tony Alley
382	997062	Dominican Republic	Jarabacoa	758 Stephen Trail
383	869683	Somalia	Marka	2 Anhalt Court
384	487438	Mexico	La Palma	2 Morning Crossing
385	859994	China	Chenfangji	358 Merry Way
386	813306	Morocco	Akhfennir	07667 Sachtjen Court
387	865904	Portugal	Casal do Sapo	5909 Ludington Plaza
388	546566	Ireland	Castlebellingham	7437 Elka Way
389	369580	Palestinian Territory	Qarāwat Banī Zayd	617 Logan Terrace
390	40389	Bolivia	Potosí	88 Graedel Terrace
391	741237	Indonesia	Manola	446 Browning Street
392	107558	China	Huangdu	596 Kipling Alley
393	377572	Mongolia	Rashaant	371 Grasskamp Park
394	451807	Egypt	Luxor	8 Towne Street
395	84085	China	Zhongcun	81 Rowland Trail
396	489519	China	Miaoshou	26904 Claremont Street
397	684650	China	Qiaozhen	06807 Elmside Center
398	244903	Pakistan	Kario	9693 Londonderry Point
399	636881	Hong Kong	Central	2 Warner Street
400	756948	Bosnia and Herzegovina	Bileća	380 Cardinal Trail
401	482367	Indonesia	Bajomulyo	67 Memorial Street
402	352884	Indonesia	Kawaliwu	26578 Dennis Court
403	522725	China	Xiqiao	1148 Everett Circle
404	811616	China	Sangzhou	1450 Mariners Cove Crossing
405	457730	Bosnia and Herzegovina	Ljubuški	17287 Walton Parkway
406	953038	Czech Republic	Rokytnice nad Jizerou	0 Sullivan Junction
407	615878	Russia	Neya	82467 Arapahoe Hill
408	135754	Myanmar	Shwebo	732 Mayfield Hill
409	994933	United States	Merrifield	8 Delaware Drive
410	871928	Thailand	Chaiyaphum	769 Katie Trail
411	941900	China	Yingzai	5843 Clemons Trail
412	211243	Thailand	Nong Khae	6 Shoshone Avenue
413	888875	China	Guankou	98526 Moose Court
414	930713	Armenia	Arrap’i	2 Melvin Circle
415	603847	Somalia	Buur Gaabo	9471 Holy Cross Street
416	94389	China	Languan	1 Buell Plaza
417	859363	Philippines	Tobias Fornier	7679 Autumn Leaf Street
418	661244	China	Zhoutian	17777 Ludington Pass
419	525315	Mongolia	Javhlant	53 Butternut Center
420	19186	Indonesia	Soe	1164 Emmet Point
421	266611	South Africa	Frankfort	5 Myrtle Hill
422	781980	Japan	Rumoi	7354 Crowley Court
423	355916	Indonesia	Kokembang	8023 West Terrace
424	837710	Philippines	Sinamar	419 Hallows Trail
425	925487	Philippines	Hanggan	460 Corben Park
426	992983	Indonesia	Buriwutung	696 Talmadge Lane
427	634929	Thailand	Den Chai	463 Schiller Place
428	880002	Belarus	Palykavichy Pyershyya	2828 Declaration Road
429	834554	Philippines	Wañgan	9076 Westport Center
430	411800	Mexico	Emiliano Zapata	14646 Merchant Road
431	979273	Colombia	Herrán	92406 Saint Paul Point
432	59637	China	Leiwang	85849 Briar Crest Circle
433	345433	Czech Republic	Předklášteří	32735 Chinook Trail
434	51695	Peru	La Caleta Culebras	76 Anzinger Junction
435	720668	Mexico	Lindavista	17 Mesta Trail
436	127389	Brazil	Apucarana	4688 Heath Road
437	913302	China	Xidoupu	613 Hanson Terrace
438	334996	Indonesia	Muruy	299 Roxbury Trail
439	646594	Philippines	Tamnag	44050 Elgar Crossing
440	847446	Colombia	San Benito Abad	0 Westend Hill
441	549263	Philippines	Las Piñas	2 Judy Pass
442	287667	Tunisia	Şaqānis	01 International Terrace
443	79029	Yemen	Ḩawf	97 Northport Trail
444	507756	Brazil	Santo Amaro da Imperatriz	7790 Namekagon Lane
445	999215	Bolivia	Oruro	1456 Briar Crest Point
446	908498	Russia	Ostashkov	946 Moland Drive
447	600483	Brazil	São Gabriel	4272 Redwing Place
448	857256	Argentina	Los Cóndores	08 Manufacturers Center
449	112108	Israel	Buqei‘a	4430 Londonderry Lane
450	155834	France	Courtaboeuf	0209 2nd Street
451	99920	Indonesia	Dadiharja	2 Holmberg Pass
452	853764	Russia	Ladozhskaya	0 Morningstar Plaza
453	6108	Indonesia	Ngembak	61955 Bellgrove Court
454	695906	Brazil	Criciúma	8 Mifflin Center
455	610177	Indonesia	Daleman	5 Eastwood Junction
456	259946	Brazil	Igarassu	04 Manitowish Street
457	23674	China	Bacun	717 Carey Terrace
458	933565	Ireland	Muff	4 Wayridge Road
459	915801	China	Haibeitou	619 Corry Parkway
460	116158	Belarus	Ivyanyets	28370 Tennessee Street
461	88913	Ireland	Kilcullen	7 New Castle Pass
462	497928	Peru	Jangas	3750 Texas Hill
463	979894	Portugal	Amieira	9413 Cordelia Terrace
464	673592	Indonesia	Parigi	9 Delladonna Crossing
465	157910	Peru	Curahuasi	0077 Sundown Junction
466	446148	Sierra Leone	Masingbi	19 Grayhawk Place
467	334406	Philippines	Lapi	9030 Summerview Road
468	249835	United States	Wilkes Barre	120 Meadow Vale Junction
469	944201	Canada	Collingwood	71 Graedel Lane
470	686989	Indonesia	Plumbon	1 Hazelcrest Road
471	741677	Russia	Urazovka	2867 Fuller Lane
472	640377	Colombia	Lérida	393 Crest Line Point
473	171908	Indonesia	Sewon	9 Kim Circle
474	168487	France	Bonneville	1 Gulseth Circle
475	576641	Morocco	Taza	2710 Judy Crossing
476	894786	China	Zhongshi	050 Barnett Crossing
477	456191	Ukraine	Balky	5 Maple Wood Lane
478	308550	Russia	Smolenskaya	3327 Myrtle Center
479	582611	Poland	Tarczyn	835 Ridge Oak Circle
480	947312	Ukraine	Lyakhovtsy	86050 Dovetail Pass
481	554221	Papua New Guinea	Kavieng	2 Graceland Street
482	639770	United States	Los Angeles	45 Mockingbird Trail
483	261224	Saudi Arabia	Umm as Sāhik	66175 Autumn Leaf Pass
484	290066	China	Longping	93 Maple Wood Way
485	603661	Argentina	Tío Pujio	081 Lakeland Way
486	753674	Poland	Czarków	8 Bellgrove Drive
487	325100	Gambia	Sabi	28817 Weeping Birch Hill
488	489334	Philippines	Bagumbayan	91239 Independence Road
489	757872	Ukraine	Uman’	61 Debs Way
490	869614	Lebanon	Tyre	01452 Hansons Road
491	631586	Sweden	Askersund	32 Welch Terrace
492	63413	Peru	Lacabamba	1 Kensington Park
493	975201	China	Lezhu	8407 Ryan Pass
494	593751	Poland	Piasek	0 Marquette Point
495	568319	Democratic Republic of the Congo	Mushie	3 Mesta Way
496	458810	Japan	Gōdo	10373 Manitowish Hill
497	720482	Ethiopia	Turmi	325 Burning Wood Parkway
498	619465	China	Baofeng	565 Manley Plaza
499	315809	China	Wengyang	1628 Lotheville Hill
500	659994	Albania	Frashër	6 Pierstorff Trail
501	238142	Sweden	Ludvika	7633 Birchwood Hill
502	293103	Vietnam	Chợ Chu	8423 Namekagon Point
503	779869	Indonesia	Ganggawang	2 Warbler Point
504	132538	France	Caen	79 Claremont Terrace
505	650905	Indonesia	Bunder	4862 Colorado Park
506	877599	Indonesia	Pasarkayu	2 Gale Junction
507	430478	Slovenia	Celje	09 5th Court
508	34512	Philippines	Taguing	0909 Hudson Crossing
509	5591	Sierra Leone	Potoru	3 5th Drive
510	269212	Greece	Ágios Spyrídon	6 Village Green Road
511	889477	Argentina	Villa Regina	30 Golf View Drive
512	782967	Indonesia	Tangerang	85 Fordem Street
513	843157	Czech Republic	Chýnov	09 Butternut Junction
514	438307	Zambia	Kaoma	68830 Carberry Street
515	187547	Brazil	Itaocara	311 John Wall Center
516	897019	Brazil	Miguel Pereira	3 Spenser Lane
517	596529	Ukraine	Kalanchak	859 Charing Cross Point
518	940368	Albania	Bërxull	0875 Shasta Lane
519	572678	Japan	Shiozawa	19514 Lyons Pass
520	12772	Egypt	Zagazig	9 Haas Drive
521	392380	Philippines	Palomoc	5 Onsgard Drive
522	138089	China	Leshan	2 Meadow Ridge Center
523	967732	China	Gongfang	52305 David Center
524	896059	Latvia	Rēzekne	33 Randy Hill
525	696792	Kenya	Lugulu	67699 Mallory Lane
526	231791	Thailand	Khao Kho	15 Mccormick Street
527	963056	Armenia	Karanlukh	6482 Maple Wood Street
528	671086	Indonesia	Sirnasari	0 Moland Court
529	848040	China	Yangjiafang	07449 Little Fleur Lane
530	366400	Sweden	Borås	24 Buena Vista Lane
531	596437	Indonesia	Selajambe Satu	08 Kipling Hill
532	940723	Ethiopia	Asaita	84 Lillian Crossing
533	342545	Argentina	Luján de Cuyo	15663 Lyons Junction
534	587853	China	Wuhe Chengguanzhen	11 4th Circle
535	659937	South Korea	Yangp'yŏng	4177 Porter Lane
536	231718	Indonesia	Kajar	9264 Monterey Way
537	625460	Brazil	Jardim do Seridó	52 Butterfield Parkway
538	504272	France	Auch	0 Laurel Hill
539	532319	Iraq	Ramadi	92776 Crescent Oaks Drive
540	615923	Armenia	Buzhakan	89 Mallory Place
541	402444	Indonesia	Tual	88275 Hagan Junction
542	588423	Argentina	Plottier	3932 Gateway Street
543	362201	Uganda	Moroto	66567 Saint Paul Court
544	544094	Jamaica	Saint Ann’s Bay	8 Dennis Point
545	917483	Russia	Bogovarovo	346 Moose Park
546	734286	Greece	Lékhaio	47028 Manley Place
547	805819	Serbia	Samoš	2376 Bobwhite Way
548	76792	Cuba	Minas	003 Fairfield Junction
549	725598	Russia	Tabaga	48763 Corry Plaza
550	801613	France	Épinal	24209 Shelley Drive
551	24960	Japan	Hasuda	921 Leroy Avenue
552	658430	Portugal	Oliveirinha	1 Sloan Point
553	230725	Venezuela	Carrizal	73787 Ronald Regan Junction
554	316785	China	Tieremu	1 Lawn Terrace
555	471534	Thailand	Ban Phai	12 Hintze Trail
556	835595	Switzerland	Zürich	03 Oak Terrace
557	455808	Philippines	Tubli	1 Bluestem Plaza
558	67270	Indonesia	Getengan	673 Myrtle Hill
559	857262	Indonesia	Cirateun	3 Morningstar Pass
560	368720	Philippines	Napnapan	75848 Brentwood Junction
561	679896	Portugal	Valinhos	423 Macpherson Lane
562	927831	Estonia	Paldiski	8 Lillian Alley
563	557538	China	Zhushan Chengguanzhen	45036 Dakota Alley
564	126246	Brazil	Itagibá	15820 East Plaza
565	450552	Indonesia	Banjar Buahan	04178 Rusk Lane
566	781901	Indonesia	Dukuhsia	81 Grover Terrace
567	780341	Czech Republic	Pustá Polom	62 Reindahl Alley
568	400942	Peru	Pomacanchi	5430 Marcy Circle
569	430394	Indonesia	Dukuhmencek Lor	9650 Stone Corner Junction
570	93510	Syria	Kafr Zaytā	930 Forest Center
571	805838	Tunisia	Banī Ḩassān	30 Elgar Plaza
572	152727	Mayotte	Koungou	39308 Stuart Pass
573	391535	Croatia	Negoslavci	9896 Corscot Way
574	68476	Philippines	Platagata	4211 Hudson Drive
575	240141	Mauritius	Camp Thorel	7 Novick Trail
576	224845	Angola	Caála	02280 Forster Point
577	170042	China	Pangu	87043 Steensland Point
578	996646	Cuba	Matanzas	1 Onsgard Trail
579	557435	Philippines	Perrelos	53 Jackson Plaza
580	120235	Poland	Wodzierady	4252 Brown Road
581	795703	Morocco	Oulmes	207 Summit Hill
582	64532	Greece	Ouranoupolis	5 Havey Plaza
583	677684	Peru	Yaurisque	4559 Marcy Crossing
584	339045	Indonesia	Nanggorak	16 Northwestern Pass
585	328265	Croatia	Soljani	2086 Manufacturers Parkway
586	875971	Thailand	Bua Yai	3664 Fairfield Hill
587	877908	Brazil	Pomerode	1 School Park
588	474006	Croatia	Kuče	81473 Derek Trail
589	14864	China	Hule	40 Waxwing Lane
590	678567	Serbia	Novi Slankamen	8 Transport Center
591	546241	Indonesia	Riangbao	701 Ridge Oak Lane
592	337215	Brazil	Açucena	8 Nevada Circle
593	110651	Cape Verde	Calheta	9385 Monica Street
594	978095	Indonesia	Dlemer	131 Karstens Crossing
595	368604	Tanzania	Matai	4972 Marcy Drive
596	26178	Kenya	Kitale	19633 Jana Lane
597	242425	Indonesia	Dadiharja	59 Mallory Junction
598	505866	China	Guanzhuang	46604 Maywood Plaza
599	759862	Haiti	Gressier	247 Browning Way
600	550379	South Korea	Yŏng-dong	3 Graceland Junction
601	785348	China	Mengyin	97 Muir Center
602	312676	Sweden	Norrahammar	9378 7th Avenue
603	439873	Finland	Tuusula	6426 Westend Alley
604	55810	China	Tiannan	17498 Orin Pass
605	819438	Philippines	San Miguel	1 Jenna Alley
606	549172	China	Kanshan	4281 Waywood Crossing
607	276736	Indonesia	Bengubelan	31 Mendota Trail
608	964764	Indonesia	Cirahab	7 West Junction
609	787897	Canada	Lac La Biche	3619 Michigan Place
610	884850	Indonesia	Kotaagung	2 Westridge Avenue
611	86678	Sweden	Stockholm	45842 Heffernan Crossing
612	718954	Indonesia	Sundawenang	72 Daystar Park
613	877323	Colombia	Landázuri	11187 Mandrake Crossing
614	260229	Guatemala	San Luis Jilotepeque	4 Nova Road
615	779124	Russia	Stan-Bekhtemir	976 Iowa Trail
616	668759	Brazil	Apucarana	2964 Sugar Plaza
617	296897	China	Fengjia	1 Green Ridge Court
618	842326	Indonesia	Kalapadua	66 Carioca Plaza
619	259941	Thailand	Yala	1 International Circle
620	599796	China	Toutai	0 Buell Hill
621	644706	Ecuador	San Lorenzo de Esmeraldas	950 Vera Plaza
622	307396	China	Guanli	73 Mockingbird Way
623	714343	China	Guangning	39077 Portage Center
624	85352	Malawi	Mzimba	7086 Brickson Park Parkway
625	417924	China	Fengpo	581 Dawn Junction
626	392711	United States	Hagerstown	2 Menomonie Pass
627	364013	Portugal	Freiria	73984 Ruskin Crossing
628	870084	Canada	Olds	7 North Place
629	882389	Indonesia	Dalam	23600 Eastwood Trail
630	256114	Indonesia	Mamasa	84 Truax Alley
631	591164	Indonesia	Jambangan	363 Everett Place
632	571794	France	Croix	9531 American Way
633	132753	Serbia	Banatski Dvor	067 Hauk Drive
634	496562	China	Miaotang	6116 Roth Junction
635	720242	Russia	Nevinnomyssk	19 Brentwood Point
636	668351	Czech Republic	Tvrdonice	527 Riverside Trail
637	551981	Russia	Kalanguy	4386 Clarendon Place
638	77791	China	Tuopu	44318 Coleman Point
639	184756	China	Xianrendu	54 Riverside Point
640	994046	China	Hudai	5440 Maple Wood Hill
641	454072	Indonesia	Dampol	091 Armistice Way
642	405269	Marshall Islands	RMI Capitol	94 Arrowood Road
643	57297	Mexico	La Palma	8 7th Way
644	682138	China	Nanhuatang	7984 Dawn Lane
645	46613	Kenya	Keroka	4216 Elka Circle
646	953129	Philippines	Langob	80 Crest Line Way
647	140468	China	Fenshui	6237 Sachs Pass
648	149671	Malaysia	Kuantan	301 Melrose Point
649	409431	China	Sanxi	36 Maple Place
650	258074	Serbia	Ilandža	2766 Victoria Trail
651	255287	Gambia	Somita	31 Texas Road
652	106523	France	Paris 01	77 Goodland Crossing
653	914855	Czech Republic	Nová Cerekev	9831 2nd Center
654	335327	China	Ni’ao	88837 Commercial Plaza
655	238461	Mexico	La Guadalupe	66416 Mariners Cove Center
656	578566	Russia	Ostrov	658 Ramsey Parkway
657	123235	Kenya	Kilifi	3314 Cascade Lane
658	205503	Uzbekistan	Qarshi	1 Waubesa Plaza
659	14907	Ukraine	Novoukrayinka	12 Moose Point
660	420452	Serbia	Gornji Milanovac	6 Randy Hill
661	544796	Indonesia	Cipondok	01484 Springview Parkway
662	860069	Samoa	Falefa	62977 Elgar Street
663	395367	Portugal	Torres Novas	10 Grayhawk Crossing
664	852322	China	Hengshan	3 Ridgeview Alley
665	520801	Mexico	Hidalgo	48 Fairview Pass
666	218261	Indonesia	Bangunharja	87318 Johnson Street
667	350109	Vietnam	Trâu Quỳ	2681 Sage Hill
668	598978	Sweden	Skillingaryd	89 Pine View Place
669	280330	Brazil	Pantanal	321 Clarendon Circle
670	185618	China	Shazhouba	12 Maple Court
671	137652	Portugal	Landim	11 Kropf Court
672	605396	Indonesia	Pomahan	2 Heffernan Pass
673	931393	China	Xilinji	843 Glacier Hill Park
674	188201	China	Motuo	17925 Fremont Alley
675	438115	Brazil	São Sebastião do Paraíso	540 Cardinal Place
676	185280	China	Fengjiang	72 Mariners Cove Center
677	611339	Portugal	Macieira de Rates	50 Lien Avenue
678	99493	France	Aubenas	63700 Sycamore Parkway
679	974014	China	Beidaihehaibin	981 Bowman Crossing
680	646621	Indonesia	Tatebal	9168 Arrowood Trail
681	669224	Indonesia	Jatipamor	469 Mitchell Court
682	248843	Poland	Ruda Śląska	18 Monica Way
683	41059	Laos	Sainyabuli	7233 Garrison Street
684	334916	Pakistan	Batgrām	2 Scott Trail
685	615454	Ireland	Skibbereen	44524 7th Place
686	395083	France	Rungis	21666 Londonderry Drive
687	995206	China	Beixinjie	8822 Welch Drive
688	736625	China	Chengjiao	209 Hudson Lane
689	377366	Canada	Edson	752 Village Green Road
690	626028	China	Shaxi	4 Mcguire Plaza
691	145444	China	Nanqi	1 Cottonwood Crossing
692	716502	South Korea	Kwangyang	9 Leroy Junction
693	77967	Norway	Trondheim	64 Mosinee Plaza
694	192367	Russia	Petrozavodsk	33 Rutledge Plaza
695	118356	Croatia	Vodnjan	79769 Weeping Birch Center
696	122915	China	Fengtai	2 Iowa Lane
697	567440	Pakistan	Toba Tek Singh	22 Jackson Alley
698	229526	Indonesia	Wonosobo	4894 Montana Circle
699	585869	China	Weizheng	24 Gerald Drive
700	434194	Russia	Priyutovo	18 Buhler Place
701	857089	China	Chengxiang	2 Autumn Leaf Road
702	110556	Dominican Republic	Pescadería	38248 Mallard Road
703	748818	Russia	Pochep	2910 Rusk Court
704	891770	Albania	Otllak	39 Clove Terrace
705	962972	Guatemala	La Reforma	9101 Goodland Street
706	652155	Japan	Hasuda	61 Hoard Crossing
707	221133	Solomon Islands	Tulaghi	5 Clemons Crossing
708	511978	Greece	Gýtheio	58695 Hazelcrest Park
709	455387	China	Chenyangzhai	1379 Waywood Way
710	887122	Tunisia	Masākin	0182 Village Green Crossing
711	218433	Philippines	San Joaquin	3 Memorial Drive
712	372353	Tajikistan	Khŭjand	7201 Carioca Junction
713	768579	China	Bingfang	62600 Utah Center
714	288067	Russia	Pavino	9 Debs Court
715	391829	Portugal	Andorinha	3 Dennis Place
716	569156	Poland	Jeziorany	8 Homewood Court
717	192943	Thailand	Ban Phue	0435 Arizona Terrace
718	34172	China	Huazhai	90 5th Avenue
719	261280	China	Ganshui	0 Ridgeway Way
720	297965	Pakistan	Sakrand	6 Logan Street
721	80042	Albania	Mollas	2957 Troy Lane
722	209013	China	Yangsha	061 Clarendon Circle
723	995074	Democratic Republic of the Congo	Masina	07 Memorial Alley
724	618571	Kazakhstan	Almaty	74688 Forster Parkway
725	427601	Philippines	Santiago	2904 Green Center
726	817996	Morocco	Tangier	052 Pennsylvania Road
727	336257	Portugal	Criação Velha	84 Sutteridge Plaza
728	70991	China	Dadukou	7 School Way
729	517282	Russia	Zaplavnoye	65 Forest Dale Junction
730	775237	Serbia	Doljevac	3954 Riverside Road
731	1381	Armenia	Nerk’in Getashen	79 Westerfield Drive
732	798614	Philippines	Irosin	47 Cody Lane
733	815410	Brazil	Soledade	97 Saint Paul Crossing
734	643034	Thailand	Borabue	250 Center Hill
735	633269	Greece	Grevená	39 Little Fleur Alley
736	187860	Philippines	Ungus-Ungus	1 Parkside Road
737	71047	Russia	Chernyshkovskiy	77294 Everett Court
738	650425	Thailand	Nakhon Pathom	6 Manitowish Avenue
739	236157	Poland	Ożarowice	1 Stang Junction
740	27895	Indonesia	Kalianget	25 Porter Center
741	669493	Brazil	Currais Novos	43525 Melvin Way
742	195947	Czech Republic	Rajhrad	01 Roxbury Terrace
743	678681	Indonesia	Kambingan	6 Loftsgordon Parkway
744	898949	Sweden	Karlstad	3 Daystar Junction
745	929060	Mexico	La Cruz	65905 American Alley
746	120589	Philippines	Valencia	9 American Ash Parkway
747	523959	Cuba	Bauta	8744 Donald Trail
748	834817	China	Dalianwan	5 Mesta Point
749	565738	Sweden	Sundsvall	338 Russell Court
750	728331	Greece	Methóni	38 Scofield Hill
751	911183	Poland	Ruda Maleniecka	292 Rigney Plaza
752	638567	Indonesia	Bantawora	8694 Ridgeview Terrace
753	823629	Germany	Lübeck	9201 Pepper Wood Drive
754	474944	China	Magang	45385 Kings Center
755	88605	Japan	Naka	083 Sherman Parkway
756	404714	Philippines	Maticmatic	9 Bluejay Court
757	827041	Poland	Osięciny	5 Ridgeview Court
758	414524	China	Yantan	33 Myrtle Center
759	726114	Peru	Santa	9254 Cambridge Center
760	357122	Russia	Trubchevsk	4079 Magdeline Circle
761	316504	Indonesia	Klutuk	8666 Raven Drive
762	494718	Poland	Nowa Dęba	4386 Meadow Ridge Plaza
763	247455	Malaysia	Melaka	326 Thierer Hill
764	761002	Russia	Grazhdanka	1 Center Plaza
765	42570	China	Shigu	66 Merrick Way
766	30724	Indonesia	Kampungmasjid	6 Kingsford Avenue
767	730838	Indonesia	Malata	9015 Bobwhite Court
768	463136	China	Jiaocun	18 Melrose Pass
769	529305	Kuwait	Salwá	521 Lunder Pass
770	704228	Madagascar	Maintirano	826 Golf Course Park
771	699492	Philippines	Sison	2 Cascade Hill
772	804202	China	Tuojiang	186 Clove Alley
773	181235	Colombia	Guachetá	18 Coolidge Circle
774	789401	China	Erdaohe	0720 Merchant Park
775	714621	China	Baoshan	8 Merrick Alley
776	594528	Indonesia	Cerme Kidul	9812 Mallory Park
777	168825	China	Sanyang	95 Scott Drive
778	519838	Brazil	Cubatão	45030 Bonner Road
779	327776	Russia	Zhiletovo	0 Luster Point
780	72697	Indonesia	Cipari Satu	4616 Coolidge Place
781	803441	Argentina	Ushuaia	119 Bluestem Hill
782	458639	China	Taihe	25189 American Crossing
783	453002	Peru	Pueblo Nuevo	30 Sauthoff Avenue
784	847393	Liberia	Monrovia	8172 Superior Hill
785	141648	Tunisia	Radès	191 Ronald Regan Road
786	679468	China	Danzao	5 Northridge Court
787	364073	China	Yajiang	6641 Clemons Way
788	41745	Bosnia and Herzegovina	Liješnica	535 Everett Center
789	520176	Brazil	Sarandi	2954 Mayfield Crossing
790	581590	Indonesia	Telagasari	777 Everett Center
791	465280	Portugal	Vila Franca das Naves	381 Anzinger Circle
792	4519	Poland	Skulsk	8719 Michigan Avenue
793	294923	Canada	Lorraine	0 Brickson Park Street
794	558203	Indonesia	Cibitung	21868 Raven Trail
795	276651	Philippines	Tingloy	0924 Bonner Court
796	650315	China	Jinping	20341 Pankratz Drive
797	860818	Russia	Prokhorovka	012 Manitowish Way
798	693511	Sweden	Göteborg	01 Oakridge Plaza
799	690557	Indonesia	Rokoy	3 Hanover Lane
800	866726	Philippines	Looc	9 Sunfield Trail
801	872624	China	Youxi	97 Graceland Crossing
802	736516	Russia	Nevinnomyssk	46405 Acker Hill
803	658211	China	Zhujiaqiao	39 Pepper Wood Hill
804	344359	Portugal	Bobadela	9456 Troy Way
805	821672	China	Zhongfeng	17 Moose Street
806	768746	Indonesia	Rejowinangun	24 Haas Crossing
807	470058	Philippines	Dobdoban	3076 Petterle Hill
808	351292	China	Huangli	55 Roxbury Road
809	581870	China	Shuangtang	5001 Eagan Pass
810	186744	Poland	Złotniki	4462 Browning Parkway
811	335819	Slovenia	Koper	0 Sunbrook Avenue
812	193651	Poland	Koszarawa	203 Bultman Plaza
813	994558	Armenia	Dzorastan	472 Delaware Road
814	390709	Egypt	Farshūţ	03 Village Green Crossing
815	2721	Indonesia	Wolowona	13 1st Road
816	530133	Pakistan	Toba Tek Singh	1335 Forest Dale Center
817	799483	Ukraine	Dmytrivka	1 Waxwing Trail
818	38338	Poland	Niedrzwica Duża	75622 Sunbrook Court
819	85586	Colombia	Nocaima	1 Oriole Court
820	307751	China	Liuji	33 Walton Plaza
821	818907	China	Renhe	86 Ruskin Plaza
822	760193	Philippines	San Isidro	7 Randy Court
823	251420	China	Huangtudian	61399 Fairview Alley
824	784282	United States	Springfield	2 Ohio Plaza
825	634299	Netherlands	Amsterdam Westpoort	6037 Green Alley
826	689940	China	Wangjiang	7849 Del Mar Terrace
827	6209	Ukraine	Troyits’ke	1 Dryden Park
828	509737	Tunisia	Gabès	5 Fordem Trail
829	267047	Serbia	Gakovo	787 Mandrake Terrace
830	612880	Cuba	La Habana Vieja	0 Gina Hill
831	141607	Argentina	Venado Tuerto	4401 Nova Road
832	997429	Indonesia	Krajan Suko Kidul	4241 Haas Road
833	641526	Russia	Valuyki	36 Arrowood Plaza
834	660554	Philippines	Sagasa	150 Nobel Parkway
835	730539	Portugal	Jardia	31 Charing Cross Point
836	864986	China	Xiting	8 Mariners Cove Crossing
837	641461	Switzerland	Basel	70 Lakeland Way
838	149502	Norway	Ålesund	56915 Farmco Pass
839	291528	Belarus	Kosava	7422 Montana Parkway
840	142822	Ireland	Tullamore	0958 Reinke Junction
841	410142	Russia	Kuz’minskiye Otverzhki	1109 Calypso Alley
842	664837	China	Mahe	41 Merrick Center
843	992249	Russia	Roslavl’	3 Troy Place
844	78798	Indonesia	Tamanan	147 Everett Road
845	520141	Poland	Leśnica	50 Shelley Pass
846	974781	China	Changchuan	349 Sachs Hill
847	871977	Slovenia	Videm pri Ptuju	36 Messerschmidt Way
848	518727	Indonesia	Cilegi	47 Heath Park
849	559889	Poland	Szamotuły	27249 Novick Center
850	579469	Czech Republic	Včelná	73931 Coolidge Hill
851	458211	China	Shanban	88 Briar Crest Parkway
852	535362	France	Montauban	20 Bonner Trail
853	105346	Somalia	Marka	316 Arkansas Court
854	739000	Portugal	Água de Pau	3912 Victoria Park
855	338060	Indonesia	Pelem	8 Eastwood Center
856	66328	China	Yanmenguan	5689 Gateway Road
857	980927	Russia	Dzhiginka	2328 Hansons Way
858	700369	Portugal	Boucinha	36 Shasta Court
859	307107	Vietnam	Sơn Hà	66240 High Crossing Junction
860	945452	Mayotte	Tsingoni	2708 Twin Pines Drive
861	360561	Mongolia	Höshigiyn-Ar	266 Independence Street
862	421919	Nicaragua	Santo Domingo	949 Green Street
863	715490	South Korea	Moppo	642 Vernon Center
864	827196	Indonesia	Tambakrejo	499 Spohn Junction
865	83877	Poland	Radzyń Chełmiński	98 Del Sol Court
866	763357	Argentina	Bonpland	42859 Cambridge Circle
867	192822	Indonesia	Perbaungan	088 Thierer Place
868	730871	Uganda	Bukomansimbi	88359 Dapin Trail
869	376832	Russia	Siukh	022 Briar Crest Place
870	971757	China	Huanggong	3 Pawling Street
871	805175	Jordan	Amman	803 Ridge Oak Alley
872	167473	Indonesia	Batusangkar	927 Raven Avenue
873	365055	China	Jiangyin	81 Charing Cross Junction
874	977833	Philippines	San Nicolas	466 Prairieview Point
875	765964	Nepal	Tīkāpur	0 Manley Plaza
876	680225	Luxembourg	Ell	448 Sutherland Place
877	487291	Brazil	Encantado	3 Vidon Lane
878	313982	Russia	Kafyr-Kumukh	59739 Kropf Road
879	445444	Greece	Filótion	89120 Canary Drive
880	497811	China	Tongqiao	4100 Dexter Alley
881	503627	Peru	Andarapa	2882 Del Mar Circle
882	136875	Russia	Palana	0 Portage Crossing
883	872208	Belarus	Vidzy	362 Bultman Junction
884	647138	Indonesia	Kasui	2253 Logan Alley
885	808129	Croatia	Markušica	62 Mosinee Parkway
886	226264	Poland	Konin	36595 Summit Road
887	167760	Philippines	Santisimo Rosario	45061 Spaight Alley
888	3774	China	Pingdu	3 Westport Hill
889	567741	China	Leiyang	04 Monument Place
890	690363	Ukraine	Kornyn	029 Sunfield Road
891	758205	Democratic Republic of the Congo	Matadi	559 Lyons Place
892	119666	Indonesia	Karangnongko	194 Carpenter Avenue
893	990995	Nicaragua	Ciudad Darío	54 Sutherland Park
894	31457	China	Qukou	0 Bayside Junction
895	178753	Japan	Iwakura	69146 Lotheville Circle
896	856097	Indonesia	Tenggina Daya	50 Kennedy Trail
897	886327	Indonesia	Bondowoso	436 Moulton Circle
898	690161	China	Taocun	37503 Eastwood Circle
899	832840	Brazil	Leme	71 Jay Crossing
900	83331	Philippines	Alcala	601 Sycamore Street
901	736623	Portugal	Almodôvar	42305 Vidon Court
902	659896	South Africa	Hartswater	735 Hovde Place
903	726524	Colombia	Espinal	89305 Westend Lane
904	335863	China	Yiyang	492 Bobwhite Park
905	538806	Indonesia	Karangasem	3829 Fairview Plaza
906	523152	Indonesia	Karangbaru	3109 Westerfield Avenue
907	251170	Niger	Ayorou	227 Kropf Parkway
908	404471	China	Maopingchang	1 Fordem Park
909	870210	Indonesia	Putun	94 Bellgrove Center
910	978048	United States	Anaheim	067 Northwestern Trail
911	933877	China	Jiwei	134 Cambridge Street
912	181618	Malaysia	Kota Kinabalu	09996 Stoughton Center
913	6204	Indonesia	Sumberan	9749 Lukken Drive
914	878996	China	Jincheng	64 Maywood Pass
915	747774	Botswana	Gaphatshwe	8 Buell Circle
916	305009	South Korea	Waegwan	9322 Thierer Parkway
917	913195	Guatemala	Atescatempa	67750 Northwestern Center
918	966293	Brazil	Casimiro de Abreu	455 Menomonie Point
919	241020	France	Montélimar	69849 Transport Center
920	940010	France	Saint-Lô	5291 Sunnyside Place
921	817582	Mauritius	Triolet	49942 Crescent Oaks Terrace
922	972953	China	Haduohe	2923 Manitowish Junction
923	909206	Colombia	Acacías	7269 Packers Avenue
924	309896	Peru	Namballe	4248 Eastwood Plaza
925	959342	China	Hadayang	19157 Dapin Drive
926	46707	China	Gunziying	0558 Clemons Drive
927	909429	Togo	Aného	1 Orin Terrace
928	655515	Poland	Kórnik	15 Dunning Avenue
929	355915	China	Qintang	31 Northridge Street
930	387106	Latvia	Cesvaine	2117 Helena Street
931	890983	Lebanon	Jdaidet el Matn	0 Schurz Lane
932	473037	Macedonia	Bogovinje	1 Warner Junction
933	616650	China	Damaying	30 School Alley
934	351032	Mexico	Emiliano Zapata	56 Morrow Center
935	758326	Canada	Greater Napanee	73242 Oak Street
936	770868	Indonesia	Wajak	988 Vera Court
937	211812	France	Évry	378 Linden Center
938	769205	China	Guishan	46417 Schiller Lane
939	671036	China	Tazhuang	7339 Autumn Leaf Drive
940	235719	China	Huangbu	52 Sommers Junction
941	545591	Belarus	Korolëv Stan	51382 Karstens Alley
942	330877	Colombia	Sincelejo	56 Carberry Plaza
943	345101	Afghanistan	Sang-e Chārak	18 Macpherson Lane
944	484793	Indonesia	Bilo	10423 Sundown Center
945	302	Paraguay	Tobatí	14 Meadow Vale Plaza
946	649105	Venezuela	Mucumpiz	19 Evergreen Court
947	917610	France	Paris La Défense	32 Knutson Park
948	85213	Philippines	Camias	34834 Loftsgordon Plaza
949	806392	China	Yangshan	26 Hallows Pass
950	563430	Peru	Palca	6 Monica Circle
951	968266	Indonesia	Kebonan	76137 Division Terrace
952	731129	Sweden	Farsta	181 Hallows Way
953	913838	Indonesia	Bendilwungu Lor	09884 Hazelcrest Trail
954	392430	Afghanistan	Kai	5693 Caliangt Court
955	585014	Brazil	Viradouro	49660 Talisman Drive
956	890127	China	Minji	6 Forest Run Street
957	517196	Poland	Niedzica	8308 Paget Terrace
958	259951	Colombia	Ciénaga	54 Charing Cross Plaza
959	804579	Indonesia	Karangharjo	016 Surrey Plaza
960	982756	China	Duancun	03039 Green Ridge Way
961	757165	Greece	Chrysoúpolis	08 Cottonwood Alley
962	427538	Tanzania	Kahama	531 Homewood Lane
963	104983	Greece	Korisós	70438 Portage Hill
964	152742	Paraguay	Guayaybi	34 Atwood Junction
965	653226	China	Dazi	0111 Homewood Crossing
966	427072	Indonesia	Sumberjo	2 Elgar Park
967	244040	Indonesia	Tangkanpulit	0638 Norway Maple Parkway
968	294411	United States	Denver	662 Karstens Junction
969	527685	Venezuela	Santa María de Caparo	478 Crest Line Court
970	205453	Zambia	Mkushi	48 Northland Pass
971	698312	Japan	Kasama	293 Cordelia Trail
972	471854	Czech Republic	Kobeřice	67509 Chive Trail
973	947304	Latvia	Stende	62 Petterle Crossing
974	305926	France	Aubenas	5 Graedel Hill
975	979735	Portugal	Serra de Santa Marinha	3335 Brickson Park Trail
976	980344	Philippines	Puro	25175 Quincy Park
977	528880	Sweden	Stockholm	35 Scoville Hill
978	850831	France	Créteil	5 Ruskin Court
979	82005	Russia	Nakhabino	2 Loomis Plaza
980	781577	France	Tournan-en-Brie	48489 Bluejay Circle
981	872796	Zambia	Kitwe	7 Mosinee Trail
982	351494	Poland	Nowa Sól	96102 Roxbury Avenue
983	799112	Mali	Taoudenni	8776 Sugar Street
984	247723	Armenia	Norashen	72 Portage Avenue
985	459370	Uzbekistan	Kosonsoy	04797 John Wall Alley
986	176200	Macedonia	Desovo	5 Mandrake Point
987	850865	Indonesia	Sukasirna	4 Blackbird Place
988	694818	Vanuatu	Port-Vila	78066 Westerfield Point
989	645547	Mozambique	Nampula	0 Carey Drive
990	402212	Nigeria	Amper	9448 Manley Center
991	122833	Russia	Sarapul	8397 Gerald Park
992	439535	Indonesia	Sendangwaru	66796 Garrison Trail
993	794822	Canada	Sainte-Anne-des-Monts	7826 Buell Hill
994	408951	Indonesia	Banjar Tengah	67 Holy Cross Drive
995	848753	Indonesia	Sonorejo	29 Stone Corner Place
996	151274	Philippines	Calauan	903 Karstens Center
997	348983	China	Anding	8011 Waywood Terrace
998	325770	Chile	Valparaíso	3 Rigney Center
999	966522	China	Yanling	583 Merchant Terrace
1000	335865	France	Vesoul	6 Petterle Lane
\.


--
-- Data for Name: contracts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contracts (contract_code, license_plate, contract_group, cost, start_date, end_date, customer_id, contract_category) FROM stdin;
HLUHQ12087	44-HC56	private	1016.08	2020-08-28	2024-08-28	08379QHHT	active
ONLJB37057	ALG-649	mixed use	2038.90	2019-02-25	2023-02-25	86956MEKE	active
DQOGW75567	0U 0335S	private	2528.98	2019-07-18	2023-07-18	88545LAYL	active
EKQHJ76493	HYK 366	mixed use	3762.07	2018-08-05	2022-08-05	60620NVYL	active
IBWNN86573	465-HCJ	professional	146.72	2019-10-27	2023-10-27	30828RHLO	active
NCUZR89154	N24 2SO	mixed use	2123.33	2018-07-20	2022-07-20	68428OEFB	active
GMMNK51544	15Y 823	private	3228.59	2022-04-21	2026-04-21	67654IKZR	active
WQVID76439	3-58615	mixed use	1043.80	2020-08-04	2024-08-04	81487OAVI	active
OIBTJ51357	5Z 7I0WSV	private	599.36	2018-05-20	2022-05-20	80341OYHN	active
PNNOP75548	GTB 435	mixed use	1757.08	2020-07-21	2024-07-21	60764GEVW	active
BMAGU67900	6127	professional	2353.54	2019-05-11	2023-05-11	23754LFSH	active
JMATX29835	3-13562X	private	1112.64	2017-10-05	2021-10-05	22519SNXK	active
UPDJP20957	7YM4070	professional	873.46	2021-04-15	2025-04-15	65496JTJS	active
MDXVJ25081	767 PJE	private	2357.46	2022-08-21	2026-08-21	59509DURL	active
WFDQC65911	QCY 464	mixed use	1566.20	2020-03-07	2024-03-07	95771UVPS	active
CVGOF72717	28033	mixed use	2839.36	2021-06-01	2025-06-01	33111FIVL	active
TWEKT91443	8BMP479	professional	3104.45	2017-11-27	2021-11-27	72654HUSA	active
XWTFB19078	GRE-025	private	1821.86	2018-09-28	2022-09-28	75753QQCE	active
WEUZR00648	DUQ4085	mixed use	3996.11	2018-01-24	2022-01-24	95040SBVL	active
CTLSX49472	SZU 900	mixed use	3336.39	2021-07-28	2025-07-28	50584GBVS	active
PZALR09788	225 JCO	private	2145.98	2022-08-18	2026-08-18	71777VLNK	active
WVGWV13281	226 WWG	mixed use	3015.92	2022-06-21	2026-06-21	02370YQOZ	active
NIOXF19846	CDC-924	mixed use	2059.40	2022-08-11	2026-08-11	15483UTSS	active
XXVNO91624	LDC6930	professional	2251.92	2021-01-02	2025-01-02	65159HQQP	active
TQZQQ81127	NIP-6327	professional	2503.12	2020-11-12	2024-11-12	51144WGEM	active
IPRUR43160	15-HM06	private	2028.38	2021-02-01	2025-02-01	49638CIFF	active
XTEYI05952	661-IYN	professional	2102.83	2021-12-15	2025-12-15	09733UOWD	active
EZOOO19263	9OD7099	mixed use	168.08	2020-05-29	2024-05-29	71982XHRY	active
EIGUK57167	IRJ4061	mixed use	1110.32	2022-12-02	2026-12-02	98657ZERQ	active
IVEGK63631	QKL-2115	private	1490.25	2021-09-27	2025-09-27	83284DBLF	active
LQBMC61436	2BE79	mixed use	1030.88	2017-09-22	2021-09-22	72610MBZX	active
BXMOZ82428	MDN 148	professional	214.45	2019-02-07	2023-02-07	55484EYRU	active
RGNUG04731	685VJJ	mixed use	807.66	2021-06-13	2025-06-13	59500UIIQ	active
CKUZL34424	6M 8N4WZH	professional	310.80	2017-05-29	2021-05-29	95771UVPS	active
GDXVN22756	0VR1058	professional	2004.92	2022-10-01	2026-10-01	57042LJVM	active
ALJBQ73015	2X CH591	private	2139.09	2020-05-31	2024-05-31	78232DVOC	active
TAYXF81935	HGW-0660	private	1882.02	2018-04-14	2022-04-14	45963BTGS	active
DSKAF93137	577-UTK	mixed use	3100.88	2022-10-14	2026-10-14	74014HHPE	active
IXSFL89525	9GXK 13	private	772.85	2018-06-18	2022-06-18	81978JEUU	active
UVIAH70361	177TCO	professional	2227.43	2022-07-02	2026-07-02	95040SBVL	active
JVFHO61755	2R 88330	professional	2929.03	2022-09-21	2026-09-21	71718MGNI	active
TGVDS59341	9MI 839	mixed use	3931.37	2022-07-29	2026-07-29	44762FKVQ	active
JGRIE70575	3RX4731	private	776.26	2020-04-09	2024-04-09	79723EUNH	active
RJCKZ09503	794-XFB	professional	3536.33	2017-10-06	2021-10-06	32776URIO	active
WUJEP27940	YKH-6327	mixed use	1668.89	2019-08-22	2023-08-22	50789WSEV	active
BYFAJ72889	6DN G71	professional	2565.41	2022-05-08	2026-05-08	91124PCFZ	active
MWZVS86916	304 HPU	professional	3147.73	2018-01-15	2022-01-15	77235BUOB	active
XRZOO05698	YQE3024	professional	2549.87	2017-09-06	2021-09-06	88392OUWV	active
MNZLE36618	I61 6TY	mixed use	905.90	2020-05-15	2024-05-15	10471PBQI	active
IAZWE15572	TV2 2438	private	940.18	2017-06-15	2021-06-15	18388XKVN	active
NQBQZ30170	7B 77677	private	1892.27	2021-07-11	2025-07-11	21171ASDE	active
MMSSJ22344	LIK-145	professional	2840.70	2020-10-29	2024-10-29	79531SQST	active
HFTWJ41884	W99 1LZ	professional	474.22	2017-08-20	2021-08-20	40695OWQR	active
GQQWI17213	TQ5 8063	private	1764.61	2022-09-05	2026-09-05	13604VPXT	active
ROVPU78377	KXX 551	professional	2513.90	2021-08-16	2025-08-16	83780RTBV	active
PGZWV00654	XR 37057	mixed use	204.61	2019-10-06	2023-10-06	42118POCR	active
VILBH56402	09-CG69	private	3167.14	2019-09-10	2023-09-10	06045QDAB	active
EQQLO28207	IZQ 3134	mixed use	2192.11	2021-09-08	2025-09-08	93214WTZW	active
IKQPV86065	51F B29	private	3200.23	2018-11-04	2022-11-04	76649BVYS	active
JJNME47184	AIT 625	mixed use	2380.69	2019-04-21	2023-04-21	80733GLAN	active
XGSDM50839	VB 8529	mixed use	3175.23	2019-06-09	2023-06-09	95531TBRP	active
LQIEI33835	4K089	mixed use	391.27	2019-12-30	2023-12-30	95040SBVL	active
EADTE11813	OX-1985	private	1661.74	2018-01-27	2022-01-27	18630CNPB	active
GEIII66546	57-Y093	mixed use	3664.84	2022-01-25	2026-01-25	67654IKZR	active
ZZTIB72639	QL 5205	mixed use	1270.26	2017-06-24	2021-06-24	79571JNBX	active
SBWTX84382	SEC-295	private	1052.77	2021-12-06	2025-12-06	98849FHWR	active
DDYQZ20462	QDV-8658	mixed use	1027.80	2021-04-12	2025-04-12	23754LFSH	active
PJXJT62954	GQL 281	private	1862.59	2018-11-22	2022-11-22	72032EAOV	active
YGKDM97467	829 CR2	professional	3149.21	2018-11-28	2022-11-28	58699UWMV	active
JDOJC74783	003-CZGF	private	3455.96	2020-06-21	2024-06-21	17136ELGN	active
RKKXY13584	5CR7462	private	3393.48	2022-08-22	2026-08-22	40695OWQR	active
LIPAH32657	05-8899A	mixed use	327.85	2022-03-20	2026-03-20	35764FOIB	active
NDJRI84904	934 OZH	professional	2553.65	2020-12-16	2024-12-16	79150WKYZ	active
ZGZRU50445	IDU 377	professional	3117.33	2020-06-27	2024-06-27	80733GLAN	active
ORIFG64589	8448 ED	mixed use	3699.34	2019-03-06	2023-03-06	56911ZULC	active
HIFMF65641	ABY-4730	private	3114.85	2019-10-17	2023-10-17	24273JCDS	active
OLIRI80639	BW1 3234	professional	1401.51	2020-08-01	2024-08-01	85393JJBI	active
XYZEC02467	IYU-437	mixed use	2423.76	2018-10-02	2022-10-02	77999UXSR	active
RHEHC25907	GQU-8889	professional	1191.82	2022-12-13	2026-12-13	89526MVNF	active
XGCWI08317	7Y 8I7KEQ	professional	3045.13	2022-05-21	2026-05-21	91124PCFZ	active
NMVAG91876	5F TX621	private	3876.34	2018-08-21	2022-08-21	42269XXOE	active
QIRQZ65178	YU-2902	private	498.40	2019-10-26	2023-10-26	54940GODH	active
BYJUN94709	8I UY907	private	2917.42	2017-06-09	2021-06-09	54925RJRY	active
RZWCJ21709	05L•150	private	801.17	2021-04-14	2025-04-14	42627LHYL	active
DOAHK06790	975 LWO	professional	2891.57	2018-02-03	2022-02-03	57734LGNA	active
TULHA28509	9ZR H83	mixed use	3938.82	2023-04-13	2027-04-13	47778WZVI	active
FXXIN77844	4JL 298	private	2383.06	2022-10-04	2026-10-04	83914QDAV	active
XTNIQ99489	K93 5FY	private	1516.40	2021-10-03	2025-10-03	83600WKWC	active
SMNKQ57908	159 YCL	professional	2554.16	2022-11-25	2026-11-25	93214WTZW	active
PZMMM47976	6-66210	professional	2344.07	2022-07-27	2026-07-27	84514WYTX	active
GSIMV71662	575-052	mixed use	2798.49	2021-03-16	2025-03-16	95475BQLW	active
TKEWD03505	367 UY1	professional	1561.20	2023-03-17	2027-03-17	14816AYBJ	active
TLUOB09796	666 HTA	professional	2333.71	2017-12-18	2021-12-18	01659YYEU	active
NRGOR57841	HGJ 783	professional	2035.57	2020-12-01	2024-12-01	60328SAPA	active
PUPQG34743	20-X454	private	329.06	2023-02-20	2027-02-20	35138FFHY	active
DJCUT37071	73B•578	mixed use	1210.39	2019-08-04	2023-08-04	42269XXOE	active
GNHHS24907	RBB 901	professional	169.68	2021-05-13	2025-05-13	77363CFCP	active
ZXQMV71352	KD-2612	professional	1537.26	2022-03-10	2026-03-10	12458QKFX	active
MACEZ12091	H28 9KQ	mixed use	691.39	2019-02-27	2023-02-27	48645NFGV	active
IEKHH00057	324-NPF	mixed use	2111.06	2020-08-28	2024-08-28	18019RBDW	active
IRFDS68677	HNL 498	mixed use	1325.31	2017-10-12	2021-10-12	10769ALVE	active
JWPHS25608	VSX-185	professional	330.52	2022-03-26	2026-03-26	55120LCLY	active
KGTRK42375	3VY 558	professional	3772.17	2022-02-11	2026-02-11	42627LHYL	active
ZONAS08779	981VRC	professional	3807.54	2021-04-20	2025-04-20	64522VYKP	active
FKDBF56481	77LQ8	mixed use	1310.64	2023-03-07	2027-03-07	47778WZVI	active
DVHJG22536	937 IUU	professional	1279.98	2018-03-09	2022-03-09	22979ZPMU	active
TGNPC37740	2557	mixed use	1509.12	2019-07-04	2023-07-04	45963BTGS	active
ZFMEQ20097	LWY 178	private	1408.61	2023-04-20	2027-04-20	18258VTFF	active
FFOUR90718	VSX 302	private	977.79	2018-08-03	2022-08-03	82767MXXC	active
IDRSC64205	9NT56	private	416.91	2022-01-03	2026-01-03	68586FWQU	active
GNZSF67021	LZL-2657	mixed use	3061.99	2022-12-23	2026-12-23	11116WFHA	active
CPMIC41954	VMH 708	private	3115.19	2021-11-07	2025-11-07	42765RSFG	active
RDWSS59430	FIT 684	mixed use	1687.20	2020-10-23	2024-10-23	60620NVYL	active
ODSOP40384	SBG 098	professional	1151.46	2021-11-13	2025-11-13	14816AYBJ	active
RRQHL94722	6PP 383	mixed use	1195.46	2020-03-15	2024-03-15	78690BVFL	active
OUUNQ03933	795 ETO	private	3678.59	2018-02-08	2022-02-08	54653TVUV	active
RJMFP16491	0JE39	private	2821.38	2020-08-13	2024-08-13	49803AKGC	active
KJPEW64310	33-2862W	private	1124.59	2020-10-21	2024-10-21	14404DRGA	active
LMWRP45788	8IY 250	mixed use	3662.71	2020-02-23	2024-02-23	87910RZWT	active
YZYKV69344	4T 58052	private	465.73	2021-02-15	2025-02-15	54925RJRY	active
JVKEA98016	58O PJ3	professional	1566.88	2023-03-23	2027-03-23	32305VJIF	active
ULFDO03642	9562	private	3363.38	2020-07-24	2024-07-24	03552MMGN	active
JUUAX57147	89-A279	mixed use	3822.90	2023-05-12	2027-05-12	68582MPTR	active
MVLLZ00292	326 JFK	mixed use	3044.13	2019-06-25	2023-06-25	02078EQQT	active
MTADL85583	RAD-7016	private	1041.04	2019-12-30	2023-12-30	25434HMPF	active
XWVVA04033	D65 6VU	mixed use	3309.53	2017-08-17	2021-08-17	13891NOSE	active
DZQMM56830	T78 5KR	private	3857.27	2018-12-16	2022-12-16	36255KUID	active
DFSTG19584	CDA-942	mixed use	3081.97	2021-08-30	2025-08-30	56369HXEP	active
KCOIA11752	I09-OBJ	professional	1243.24	2022-08-03	2026-08-03	31128EHQZ	active
GZXVG69754	272 YYR	professional	1237.18	2018-04-04	2022-04-04	43473HAYP	active
BVYOM35425	2VE M49	professional	2232.86	2021-02-04	2025-02-04	46015XQAX	active
MLHLK92605	231 2757	private	3723.67	2018-09-22	2022-09-22	32971HUPL	active
DQNDR93785	53-MO16	professional	681.77	2017-06-16	2021-06-16	61817FIKY	active
JCYRN47061	ALZ 108	mixed use	619.64	2022-06-06	2026-06-06	67654IKZR	active
JRIOQ84607	YKZ 448	private	3568.98	2020-05-15	2024-05-15	01087MZWC	active
CKSSB57666	071-FDW	mixed use	1882.83	2019-10-02	2023-10-02	87603OGLK	active
KNUVR23667	THX 215	mixed use	1580.29	2017-10-21	2021-10-21	29615DGPL	active
BYHRK40522	694 VZ3	professional	153.46	1989-08-06	1993-08-06	49482IBZH	not active
IXVEZ18118	98I T78	professional	3899.28	1996-01-19	2000-01-19	43473HAYP	not active
PPFKV21806	53-N511	professional	2279.54	1981-09-24	1985-09-24	94303JWTD	not active
YQNLW86336	F08 4EV	mixed use	826.12	2001-02-16	2005-02-16	87612BOEV	not active
CCGEV37110	PP 5921	professional	1333.20	1993-08-11	1997-08-11	54925RJRY	not active
VMMWO09824	920 NO9	professional	1778.05	2003-04-22	2007-04-22	57734LGNA	not active
KSFTN44526	WLQ-8090	private	719.62	1988-12-13	1992-12-13	79150WKYZ	not active
OMWCS52928	5UQ 943	private	275.40	1995-08-09	1999-08-09	77966JEXX	not active
BXJWM56577	LYP 869	private	2651.70	1987-07-23	1991-07-23	93214WTZW	not active
CWPLL61205	9EJE 13	professional	3220.92	1985-07-09	1989-07-09	91456OASB	not active
TLEDW79399	BLA-2552	private	2815.28	2001-07-13	2005-07-13	04940PMMY	not active
DMBTH62389	155470	mixed use	3748.88	1983-07-02	1987-07-02	05056UNSA	not active
RXOIB28840	71-5958U	mixed use	1353.37	1997-08-31	2001-08-31	10471PBQI	not active
LHXBW35990	9Z512	professional	3197.54	2001-09-30	2005-09-30	93214WTZW	not active
WLYJH93043	6YT 049	professional	863.35	1988-12-06	1992-12-06	72610MBZX	not active
IPOLC89588	072 4QK	professional	2546.55	1993-05-01	1997-05-01	25935HNYY	not active
EBCXU68412	7K YC112	professional	1196.14	2010-12-25	2014-12-25	10769ALVE	not active
URIKR68112	727 JGD	mixed use	668.21	2012-03-03	2016-03-03	03552MMGN	not active
LEEWR39927	CFZ-382	private	1797.68	2006-10-08	2010-10-08	67383HZVX	not active
FDGJW49296	2LU 363	professional	2881.31	1996-02-16	2000-02-16	92623KQZR	not active
ETDJW02033	82-ME02	private	3910.65	2013-06-28	2017-06-28	57422FUFB	not active
USTOV66656	820 6ND	professional	2712.93	1994-05-08	1998-05-08	81487OAVI	not active
KCBOM35730	BJ6 Y7V	mixed use	504.70	2011-02-13	2015-02-13	98552YSEK	not active
RSHCJ04518	566 JNB	professional	1938.43	2011-08-17	2015-08-17	68586FWQU	not active
WMRCD76320	QSH-5559	professional	729.24	1994-06-23	1998-06-23	34284QPPH	not active
UDOMB42657	759-HKD	professional	2185.33	1989-07-21	1993-07-21	95040SBVL	not active
RGCJU37868	FQS4118	professional	1390.97	1985-08-07	1989-08-07	51549NDPJ	not active
IRPXI92642	QDM-2037	private	2420.78	1988-05-01	1992-05-01	11116WFHA	not active
KTHUG51753	RIU 090	mixed use	2911.38	1984-12-03	1988-12-03	52279JVHF	not active
TLPHW20138	CGU4014	mixed use	2419.92	2006-04-12	2010-04-12	65031CTFS	not active
XEVMD87067	KUM 150	professional	1382.90	2002-12-09	2006-12-09	23373OIZR	not active
ZIBKQ05370	257-AFM	mixed use	3258.80	1985-02-15	1989-02-15	77648HPWS	not active
EOKGV78823	0ZLD 20	professional	2780.16	1994-09-11	1998-09-11	70064RDVI	not active
PGOCN16135	9ND 607	professional	2180.09	1993-11-22	1997-11-22	24273JCDS	not active
ZXLPC70831	60B H04	private	2240.45	1987-03-01	1991-03-01	02370YQOZ	not active
XXADV11290	RK-4506	private	1704.92	1992-01-31	1996-01-31	69115KDSM	not active
AEYUR04959	UJN-843	professional	359.99	2011-09-13	2015-09-13	42765RSFG	not active
UPVCQ79127	MBR 586	mixed use	1442.66	2005-10-20	2009-10-20	84514WYTX	not active
DYZQU54375	3TD 621	private	2273.13	1996-09-14	2000-09-14	78104LNZA	not active
MJBLK52655	938 QHJ	mixed use	2449.80	1992-07-25	1996-07-25	65159HQQP	not active
CXBNG94637	122 FYK	private	280.26	2013-08-09	2017-08-09	69408PZCQ	not active
QWDAY22295	760-MKBU	private	2695.09	2014-05-31	2018-05-31	25434HMPF	not active
JIMNU21015	267 JQV	professional	1469.25	1983-04-17	1987-04-17	09591PDXE	not active
LCQIU32217	7UYR078	professional	2047.42	1982-08-21	1986-08-21	44609WILJ	not active
CNDFQ36759	052 1561	mixed use	1122.31	1996-10-11	2000-10-11	57531HHOE	not active
ANWNO96326	O 923797	private	2041.94	2012-02-09	2016-02-09	46639TZPG	not active
EJGZB15757	LGN-1306	private	3251.48	1981-03-03	1985-03-03	43212TDKJ	not active
XAGAK98893	846 4924	professional	729.00	2007-02-14	2011-02-14	73157LIPH	not active
LPYUJ83003	374 TK2	professional	650.21	1994-01-17	1998-01-17	89695FAMD	not active
HBFPW61771	E55 3KP	professional	2344.18	1991-11-26	1995-11-26	36136GDUV	not active
ISALC38453	VN 90470	mixed use	3624.25	1984-05-23	1988-05-23	76606GSJC	not active
RWGYH78646	U95-83Z	mixed use	212.53	1988-02-07	1992-02-07	49638CIFF	not active
DPFZK22689	AQL4744	private	2423.85	1981-06-11	1985-06-11	54653TVUV	not active
FVNVW52371	502-XPD	private	1451.96	2003-09-12	2007-09-12	42013QHIR	not active
MAORB48650	693M	mixed use	124.78	2016-07-28	2020-07-28	43426DRZZ	not active
TZIGJ03675	PV5 4900	private	3120.46	2005-10-19	2009-10-19	19717MIGS	not active
YVQBU46167	1-89256	private	3278.50	2003-06-25	2007-06-25	82477VGEO	not active
TTPOM28156	BEB1897	professional	930.81	2003-07-10	2007-07-10	76566VEGI	not active
SUBDF66417	IUH-070	mixed use	1716.78	2005-11-22	2009-11-22	31447GNHE	not active
RMVLB00754	H 717865	private	268.18	1989-08-19	1993-08-19	79875HUWC	not active
ELSOA95239	OIE-8689	professional	3593.12	2003-11-01	2007-11-01	42765RSFG	not active
LDIER63828	PY 1470	mixed use	3106.12	2002-02-22	2006-02-22	60328SAPA	not active
TABLR68172	HPM8644	professional	3688.23	1985-05-23	1989-05-23	67284EJED	not active
QPLNA85203	8C 7R6MFX	professional	446.13	2005-04-14	2009-04-14	09733UOWD	not active
IBKVG70566	9-30884	professional	2786.66	1990-07-03	1994-07-03	13891NOSE	not active
MEHBT80865	IUM 377	professional	3461.05	2012-02-07	2016-02-07	14404DRGA	not active
YLBHE92725	ORA-886	mixed use	1586.80	1980-08-29	1984-08-29	35138FFHY	not active
RPIMF73462	226 0FR	mixed use	1809.38	2007-11-10	2011-11-10	92891DPPY	not active
ZZMPS13826	FR0 2492	professional	945.15	1998-11-16	2002-11-16	51118DLYY	not active
BFRVO20231	VPY1682	private	211.75	1987-11-27	1991-11-27	92891DPPY	not active
SWGZC30234	KIL 377	professional	2280.61	2003-11-15	2007-11-15	14772ZJQH	not active
VJVTT76597	929-XJT	professional	3334.91	2006-08-01	2010-08-01	91343ITWF	not active
UHZWI79948	D 548591	mixed use	2100.53	2013-11-17	2017-11-17	73860ZFXZ	not active
SYMQN66005	6-89908	mixed use	1611.58	2003-08-07	2007-08-07	00822FKFK	not active
TXVLU68511	5OR T08	private	503.23	2002-08-11	2006-08-11	34307LQXI	not active
LMBJG13570	8SWU 92	professional	527.70	1992-11-11	1996-11-11	41784LILU	not active
LIGIV58152	Q18 0AF	mixed use	3298.41	1981-01-22	1985-01-22	88254BLBN	not active
MPYOP88797	0S A1011	private	3981.24	2010-04-28	2014-04-28	62057CFRB	not active
DVLIT87648	VJY 943	private	3274.19	1988-11-17	1992-11-17	71982XHRY	not active
MLKXE01371	UDT 336	private	863.56	1982-11-13	1986-11-13	52058LYKU	not active
AWQJU95594	XKG-9136	professional	2644.64	1991-12-14	1995-12-14	77363CFCP	not active
TVHXY51109	7-Q9517	private	3599.60	2000-05-01	2004-05-01	99370FKWO	not active
UOEPQ60993	574-AOZ	private	2193.45	2011-03-04	2015-03-04	84292DHIB	not active
FIDIB33812	0IB 803	mixed use	2578.31	2010-10-20	2014-10-20	77097DUZP	not active
AAIWZ17012	RFL-2957	private	3969.13	1993-11-04	1997-11-04	70298ZUZH	not active
ICIWF52756	M19-91N	professional	2300.67	1996-06-19	2000-06-19	77235BUOB	not active
KRQAY81560	3QB45	professional	1935.99	2006-03-09	2010-03-09	98849FHWR	not active
HEQLR61605	0-Z0625	private	290.06	2007-12-24	2011-12-24	94444SGVC	not active
TYYWN52704	YEA-468	professional	3618.84	2016-10-21	2020-10-21	04940PMMY	not active
UJELM55630	6XX 116	mixed use	1445.21	1991-12-20	1995-12-20	55103ZPSB	not active
ZYQWW96820	4-46616N	private	3637.59	2008-03-04	2012-03-04	12655ULTD	not active
JQHUA72434	9ZO P33	private	1147.45	2015-02-15	2019-02-15	85599NPEB	not active
AEQKH51425	TBD-688	mixed use	701.12	1981-09-03	1985-09-03	18019RBDW	not active
CHDYO41580	LJU S70	mixed use	105.66	2002-06-05	2006-06-05	83284DBLF	not active
OYPHL25250	623 5388	mixed use	787.35	1996-10-25	2000-10-25	72610MBZX	not active
TMNUY01440	MAS-641	professional	828.61	2008-04-18	2012-04-18	86956MEKE	not active
ZDRPM08960	FTF-8420	professional	966.36	2006-07-10	2010-07-10	55229VVKR	not active
ORUEH59776	Z44 3DF	mixed use	3807.71	2004-02-03	2008-02-03	43512YVLG	not active
GPIRB68692	SUR 995	professional	3014.18	1992-03-02	1996-03-02	32305VJIF	not active
UCIVE39534	7BP 881	private	3004.63	1995-06-18	1999-06-18	43473HAYP	not active
ITKBL92494	0B E6144	private	2889.46	2004-11-12	2008-11-12	36154QQBW	not active
WCTWI15230	1BQ 169	professional	2679.81	1987-10-02	1991-10-02	36239MGOR	not active
FWCVT48162	370-AMF	private	2171.58	2002-05-27	2006-05-27	98043QMRH	not active
AINRD69764	75LM5	mixed use	1859.04	1986-08-15	1990-08-15	01087MZWC	not active
AFMFN48101	NLB-4427	mixed use	3637.24	1986-08-18	1990-08-18	47778WZVI	not active
GGZLN44282	416 YTP	private	3244.00	2000-09-10	2004-09-10	05056UNSA	not active
LKNJX19959	MOK 536	private	3908.71	2011-03-27	2015-03-27	76743DMGG	not active
NPXBU83328	5K 8L0QYM	private	137.95	1989-04-21	1993-04-21	18388XKVN	not active
PRLHW85500	LNY3441	mixed use	3708.35	2015-07-24	2019-07-24	67176RPBA	not active
WXCNN54579	2-61359G	professional	457.24	2006-02-01	2010-02-01	59905KSHU	not active
WSQOR16967	36D JT4	private	3217.50	2001-09-03	2005-09-03	37698CHVT	not active
NSADX36353	ZZR 318	mixed use	1355.47	1996-06-11	2000-06-11	05941YUVA	not active
UBASX04432	OQE N74	professional	371.60	1990-07-31	1994-07-31	58699UWMV	not active
JUMFI04053	74Y M17	private	432.81	1993-12-23	1997-12-23	32971HUPL	not active
LFAPH11237	1S XY951	private	3977.47	2014-02-18	2018-02-18	58175VDBX	not active
IRTCG94867	HSZ-6396	private	272.67	2002-05-10	2006-05-10	82923NARG	not active
ASJTL75607	XY1 2439	mixed use	660.59	2011-07-23	2015-07-23	35898FCNM	not active
SVTHN41016	LYS 352	professional	1754.55	1996-11-22	2000-11-22	21364FPLG	not active
TWTPI86104	26A W31	private	1704.87	1998-07-22	2002-07-22	11764FIVH	not active
WSAPT97891	13I L66	professional	2241.30	2002-09-30	2006-09-30	93974BAZZ	not active
VTJDW18541	04-J541	private	1612.30	1984-07-13	1988-07-13	61961BNWO	not active
LPUPQ82249	T99-KBC	mixed use	1560.91	1997-02-17	2001-02-17	46386XMYL	not active
JBRWN56169	68-1035A	professional	2017.81	2011-08-09	2015-08-09	63920BTFS	not active
WWVHW61830	189 HFU	professional	2467.75	2005-02-01	2009-02-01	22979ZPMU	not active
XUXLJ37466	41CU041	professional	2284.83	1981-10-29	1985-10-29	76743DMGG	not active
CIFIV75894	2C 67350	mixed use	2617.26	2015-04-13	2019-04-13	79531SQST	not active
VYNDY45721	1-L0164	mixed use	2435.96	1986-06-17	1990-06-17	49941YHBD	not active
HSWFM65408	GDZ0926	private	2872.52	1999-10-09	2003-10-09	35764FOIB	not active
IXZES43017	2V139	mixed use	2301.95	1993-05-01	1997-05-01	53911OCJM	not active
XWMPF89686	4961 IV	professional	3819.21	2010-06-27	2014-06-27	83780RTBV	not active
HUMRG61974	4WEJ 70	mixed use	3515.13	1985-09-14	1989-09-14	37189JWSC	not active
OFBGA31867	401AW	private	3139.91	1997-08-14	2001-08-14	18258VTFF	not active
LGOQP41952	LKB 959	professional	343.98	2006-11-07	2010-11-07	42438YADB	not active
XTIGR69040	QB-6655	mixed use	1432.69	1984-04-11	1988-04-11	82767MXXC	not active
EBJRY07137	5M DX778	private	1773.81	1994-03-02	1998-03-02	25935HNYY	not active
JHAYV35194	2S 9Q8TCY	private	2750.13	1999-09-28	2003-09-28	68582MPTR	not active
TEHJX73292	1MUT 21	professional	1954.57	1991-01-02	1995-01-02	94211GXXU	not active
JAEUA79500	KGN 691	mixed use	1279.59	2015-06-17	2019-06-17	02078EQQT	not active
SDGEB92173	96QA623	private	2049.32	2000-11-05	2004-11-05	95531TBRP	not active
KNYTK72055	TIX-774	mixed use	2283.97	2004-07-11	2008-07-11	68586FWQU	not active
TNAOE22694	ICQ 879	private	200.21	1993-04-10	1997-04-10	44421IHHW	not active
CEVZR28873	JHM-238	mixed use	3570.95	1996-01-29	2000-01-29	50300NKLM	not active
DMZFJ71953	3VN45	professional	716.13	2013-05-25	2017-05-25	77648HPWS	not active
KHYXU66587	0UB5012	private	3184.82	2012-04-21	2016-04-21	54411TIYF	not active
DAMBW43132	75U V05	private	3110.45	2006-02-23	2010-02-23	74333REJG	not active
LKRXC90162	YW 21591	mixed use	692.74	1997-10-28	2001-10-28	66094VTVF	not active
ROEYL53173	CBQ4730	professional	1566.84	1984-09-04	1988-09-04	27325QHFP	not active
TUJFF64534	2K TJ446	private	3332.83	2006-04-27	2010-04-27	78104LNZA	not active
FWLKI31099	DST 217	mixed use	378.96	1987-09-02	1991-09-02	69408PZCQ	not active
NFIOG21414	1DJ X06	professional	3795.53	1987-08-08	1991-08-08	25434HMPF	not active
TFWGG41515	RQQ 703	professional	3898.51	2015-11-01	2019-11-01	30828RHLO	not active
ETAEE57221	568 BOL	private	3631.13	2014-02-08	2018-02-08	09591PDXE	not active
WIELX32337	894KK	private	2938.83	2013-03-16	2017-03-16	95475BQLW	not active
FTITM82719	BEE 770	professional	3392.60	2005-01-29	2009-01-29	38804LVKL	not active
BQHCO70194	XX8 T1G	professional	1484.05	2010-08-04	2014-08-04	78690BVFL	not active
HBUJH90109	HCI 343	private	2404.40	1998-01-27	2002-01-27	90636SXTS	not active
RNOXF84987	511 RWL	mixed use	1272.54	2011-06-26	2015-06-26	54048BMBC	not active
ADYVD18665	8-86297P	private	2575.56	1997-04-01	2001-04-01	77098AYAB	not active
VFITQ26675	4AB0480	professional	2028.30	2016-06-13	2020-06-13	42013QHIR	not active
RPALS05504	574 JIM	mixed use	1087.97	2016-11-19	2020-11-19	68428OEFB	not active
OSZVL46853	7925 VH	private	1771.68	1991-12-22	1995-12-22	44762FKVQ	not active
WDDAM87738	32N G07	private	3054.32	1980-06-25	1984-06-25	39381PFJJ	not active
RYGAM44347	6PR 858	mixed use	2062.00	1986-08-14	1990-08-14	49803AKGC	not active
NTOHN43689	672 5MR	professional	2462.18	2001-05-11	2005-05-11	19717MIGS	not active
VUDNV97734	HQF 124	private	1435.82	1998-12-13	2002-12-13	58217LNYS	not active
SFKNL20905	4SS 130	mixed use	2748.23	1991-06-08	1995-06-08	13891NOSE	not active
RNGRG17824	BTN-572	private	3944.09	2008-10-14	2012-10-14	05913SDIU	not active
RGTWF68982	538-HLN	mixed use	348.47	1983-02-28	1987-02-28	77999UXSR	not active
ARTGM26369	088-JED	mixed use	2341.21	1983-01-26	1987-01-26	45464WSJG	not active
AGYKI94185	5-C5151	professional	3739.57	1991-03-01	1995-03-01	17337TFTU	not active
ZPMMU64412	925 UXM	mixed use	2794.33	1987-07-10	1991-07-10	98911THJQ	not active
EDFFL17617	16K 993	mixed use	3057.01	1999-07-24	2003-07-24	22176FNDT	not active
TTXUK42120	544	mixed use	1888.26	1990-12-23	1994-12-23	79596YHKE	not active
XFSST30388	PMY-3580	mixed use	1891.57	1997-09-30	2001-09-30	35138FFHY	not active
XJCBW03466	WFT 351	private	127.86	1984-11-24	1988-11-24	92891DPPY	not active
AVJJY82828	0FUI 92	mixed use	2255.83	2010-09-18	2014-09-18	89526MVNF	not active
UMZEP70031	ENL-8366	professional	1926.87	1990-07-31	1994-07-31	80341OYHN	not active
WOMPU32195	4IZ R94	professional	3105.20	2008-09-26	2012-09-26	82119ZXLO	not active
IXMNB36194	85-9958S	private	3257.21	2002-07-28	2006-07-28	00822FKFK	not active
VTQKM76743	52J Q78	professional	1850.86	2004-11-18	2008-11-18	62816IIBX	not active
PTJII32128	199 0QS	private	484.94	2003-05-21	2007-05-21	52058LYKU	not active
RYCST94898	MGN 374	mixed use	592.02	1990-02-15	1994-02-15	06976BQRC	not active
NEFZX33895	984 WZZ	private	1254.27	1995-03-01	1999-03-01	79571JNBX	not active
UZHPO77804	920 LGZ	mixed use	310.10	1991-06-14	1995-06-14	77097DUZP	not active
VZFEH37755	IXG-3377	mixed use	1432.19	2017-05-07	2021-05-07	17239JEWQ	not active
TAGMZ11848	GA 2048	private	1159.85	1998-02-16	2002-02-16	70298ZUZH	not active
LOYJM27597	HSS 135	professional	3091.75	1996-01-16	2000-01-16	98849FHWR	not active
JGDDR98261	5HKQ 97	mixed use	896.77	1987-01-05	1991-01-05	23754LFSH	not active
FQFOI87246	29W B12	mixed use	1685.67	1992-12-07	1996-12-07	30848FGKT	not active
PUISY77777	73-28679	mixed use	3728.23	2012-03-02	2016-03-02	22164JXUR	not active
LKPUK85528	3KJF834	mixed use	1832.71	2014-10-14	2018-10-14	10769ALVE	not active
TADWP53458	876 BMI	professional	2461.00	2008-08-17	2012-08-17	82191YHWV	not active
NAZFF04462	JRG 190	private	1289.15	1984-05-21	1988-05-21	42627LHYL	not active
MUALZ88297	ZGU-170	professional	2729.51	1987-04-19	1991-04-19	64522VYKP	not active
OEHBC88216	609 BEW	professional	1621.78	2004-01-10	2008-01-10	93887GIPN	not active
HMPHJ85324	12-J856	private	1579.11	2003-11-19	2007-11-19	87603OGLK	not active
HUGVB71643	9V 0E7TFM	professional	1579.78	1998-08-15	2002-08-15	22900FXDM	not active
OJNJG81132	39-4352N	mixed use	2322.14	1982-06-11	1986-06-11	47778WZVI	not active
TQVER48289	729-ZOG	mixed use	2447.38	2000-03-23	2004-03-23	46015XQAX	not active
NJFVX87173	0CT E37	professional	3646.52	2009-02-16	2013-02-16	05056UNSA	not active
OLMSU69153	BA-8605	professional	1090.48	1998-01-23	2002-01-23	10471PBQI	not active
RASJJ79078	GD-2434	professional	2804.12	2002-02-27	2006-02-27	18388XKVN	not active
ALWTM45377	MAE 821	mixed use	2184.60	1983-12-16	1987-12-16	65496JTJS	not active
TQGLD49215	5JE6549	private	889.31	2015-10-15	2019-10-15	59905KSHU	not active
VMXNG51588	035DR	professional	1538.10	1984-05-08	1988-05-08	17108GILE	not active
LLHKI44269	EG6 T4J	professional	2342.42	2006-01-21	2010-01-21	21858YONA	not active
VJHES83421	427-AKK	private	1316.73	2007-03-29	2011-03-29	67284EJED	not active
ZRSAF44718	UX 6663	mixed use	3636.15	1983-10-08	1987-10-08	05941YUVA	not active
GSYFP76412	65-L073	private	170.21	2012-05-19	2016-05-19	59509DURL	not active
RULVZ54089	L76-44F	mixed use	690.56	1997-03-23	2001-03-23	58699UWMV	not active
ULEYK26596	6IX04	mixed use	1698.02	1984-06-16	1988-06-16	36981SZFS	not active
CYELF85321	YAI9366	mixed use	2392.79	1989-11-25	1993-11-25	21364FPLG	not active
WODLS30195	7I BO383	professional	1243.13	2003-04-02	2007-04-02	83600WKWC	not active
IKAZP23320	127 MOD	mixed use	3356.91	1996-08-08	2000-08-08	93974BAZZ	not active
SCDOX45732	276 NHZ	mixed use	648.01	2006-12-01	2010-12-01	71165ADJK	not active
EJXRW42111	W39-HNO	professional	2768.29	2010-11-25	2014-11-25	79506QNVR	not active
TZXHI72082	D78-89Y	professional	3017.03	2005-08-26	2009-08-26	99566JOFM	not active
TLHQD39860	X12-42Y	private	3840.93	2009-04-11	2013-04-11	22979ZPMU	not active
BNWGL70920	YRD-6112	mixed use	2652.42	1986-10-08	1990-10-08	33111FIVL	not active
TFXXP22400	780-107	private	649.35	1993-03-27	1997-03-27	85805GHFL	not active
JINNE39952	921-NNIU	professional	2164.39	1998-10-10	2002-10-10	27025MYJS	not active
ZWKXL55536	XVX-1687	professional	2432.96	1993-12-04	1997-12-04	40695OWQR	not active
PFNNO00796	FS 4755	professional	2418.81	1998-07-09	2002-07-09	79893GQEE	not active
EMBPC11355	886 FKO	mixed use	1173.02	2007-05-30	2011-05-30	75753QQCE	not active
IMEOR95077	ISV 533	professional	1540.63	2000-12-12	2004-12-12	49941YHBD	not active
UEHTO43539	495 ISP	professional	2914.32	1989-08-01	1993-08-01	35764FOIB	not active
DGNMJ69831	743-KJS	professional	1464.03	2005-11-14	2009-11-14	92623KQZR	not active
LDIZC11606	KKG 293	mixed use	617.42	1981-10-29	1985-10-29	42438YADB	not active
EGTTH29959	8MB71	professional	2653.33	2000-12-06	2004-12-06	29615DGPL	not active
LAODV62665	EPI4806	mixed use	2630.18	1989-01-24	1993-01-24	38630HZNZ	not active
VCTFP05286	63-97656	mixed use	179.39	1999-07-26	2003-07-26	68582MPTR	not active
FGUPB62892	LM 24090	professional	2491.91	2000-09-05	2004-09-05	80733GLAN	not active
ZINWO59530	BHS-5622	mixed use	2456.01	1984-04-24	1988-04-24	95531TBRP	not active
GFAWI45452	NBQ-4863	mixed use	331.32	2006-07-03	2010-07-03	68586FWQU	not active
RYVQZ67683	9F F2690	professional	2438.61	2010-10-23	2014-10-23	34284QPPH	not active
KRNIT67129	AOS-829	private	3210.29	1999-12-16	2003-12-16	34451YCKS	not active
FQXWK44448	70C W31	professional	1122.98	2006-08-07	2010-08-07	00532WKFG	not active
UVXLP95821	2XY3473	private	1963.26	1982-11-23	1986-11-23	88545LAYL	not active
LYJOL13642	1F 78928	mixed use	2345.82	2013-09-14	2017-09-14	11116WFHA	not active
NAIVR48964	809 UBB	mixed use	1732.84	1984-04-10	1988-04-10	52279JVHF	not active
WLZAS53475	WCI 038	private	3840.17	2007-11-18	2011-11-18	50300NKLM	not active
EMCWZ30150	FOP-4832	private	3883.90	1981-11-10	1985-11-10	70064RDVI	not active
WELGQ63144	2401 DR	private	3196.67	2015-09-25	2019-09-25	69115KDSM	not active
MWLGF82320	BHX 924	private	3399.70	2011-04-08	2015-04-08	15483UTSS	not active
BZWJO72976	U98 6YR	mixed use	3953.91	1983-01-27	1987-01-27	27325QHFP	not active
YOTYB17215	181 BFU	mixed use	1391.36	2017-02-04	2021-02-04	84514WYTX	not active
FUIVK42320	106 YIJ	mixed use	3247.28	1986-09-04	1990-09-04	78104LNZA	not active
UHJUI69246	ADU-732	private	2622.53	2000-11-29	2004-11-29	17101QTEN	not active
CZTLQ53462	68R•376	mixed use	2950.97	1984-08-31	1988-08-31	16730ZVIA	not active
SJHNC26497	I56 5DY	professional	1257.83	1984-10-21	1988-10-21	85393JJBI	not active
WIAVB30616	60U Z91	mixed use	2550.79	1990-02-21	1994-02-21	62745BDVN	not active
MYEJG26732	220-FIX	professional	3054.14	2008-10-07	2012-10-07	43212TDKJ	not active
MUUOZ08454	84-WC27	professional	3731.16	2014-12-09	2018-12-09	54653TVUV	not active
VAUYW45856	800 PML	mixed use	3405.84	2012-04-03	2016-04-03	42013QHIR	not active
DDDGW37718	302FBQ	private	3531.82	1983-07-25	1987-07-25	43426DRZZ	not active
ISJXG69819	939 7924	professional	3952.21	1994-11-07	1998-11-07	39381PFJJ	not active
QTUDT90060	179LU	mixed use	2390.30	2004-11-08	2008-11-08	41202VRAI	not active
TZSQB89257	MXS 588	private	3081.40	1984-03-28	1988-03-28	58217LNYS	not active
OOYKE10137	ORH 676	professional	2318.84	2012-11-06	2016-11-06	76566VEGI	not active
IJRED44603	802 FV7	mixed use	1652.87	2010-04-04	2014-04-04	13891NOSE	not active
ESAKZ85727	281 PZZ	private	3082.28	1999-03-29	2003-03-29	67654IKZR	not active
GTRYO02141	7G 8649R	professional	3347.60	1980-11-20	1984-11-20	77999UXSR	not active
GRVJR16794	ZXS5691	mixed use	1688.18	2007-10-22	2011-10-22	45464WSJG	not active
GSWWA29515	224 NGD	mixed use	872.08	1998-12-23	2002-12-23	62283VGAV	not active
ECAGA47527	107-VDR	professional	3195.63	1997-05-05	2001-05-05	79596YHKE	not active
YZBVO89862	7-J6658	mixed use	1128.84	2003-07-29	2007-07-29	92891DPPY	not active
KBTAS43103	140-BAL	mixed use	3041.06	2016-08-30	2020-08-30	51118DLYY	not active
ZSBDQ04872	575 VZ6	mixed use	741.18	1981-11-03	1985-11-03	91343ITWF	not active
EZNLQ93201	94-DW79	mixed use	958.56	2011-11-13	2015-11-13	85721RGLG	not active
OLNPE61974	EEF 010	mixed use	2741.18	2007-06-20	2011-06-20	62816IIBX	not active
HFTCU79428	3FW8336	professional	2949.42	2011-11-28	2015-11-28	41784LILU	not active
DIILS78523	22-R524	professional	880.84	2001-08-08	2005-08-08	56369HXEP	not active
WRBIF41400	2652 XG	private	2720.24	2000-03-04	2004-03-04	31447GNHE	not active
LTFVM39065	226 QZB	private	876.76	2003-08-15	2007-08-15	42269XXOE	not active
USJTL90060	241 RCC	private	1682.52	1997-05-13	2001-05-13	00498FQFV	not active
BYDTJ31413	7NE W68	private	907.80	1996-05-15	2000-05-15	62057CFRB	not active
HFXES82467	6QY I45	professional	950.04	2002-04-20	2006-04-20	71982XHRY	not active
NPRFB01101	ZYP 005	mixed use	3266.24	2002-12-25	2006-12-25	98657ZERQ	not active
TJWMZ42969	GEX4534	mixed use	3703.16	1990-09-17	1994-09-17	06976BQRC	not active
SSJMW06413	MGS 805	private	3390.41	2016-03-23	2020-03-23	54940GODH	not active
SULGV41295	6D363	professional	3045.81	1989-09-18	1993-09-18	54589MPFN	not active
ZDYSP06260	VE0 P9A	mixed use	3924.70	1991-03-12	1995-03-12	79571JNBX	not active
NJTYR47451	829-221	professional	1874.60	1993-03-30	1997-03-30	63331UQLD	not active
TWIZM78004	1NT N25	professional	2023.87	2004-10-01	2008-10-01	12458QKFX	not active
RCYPX66846	7-29887	professional	1472.92	2003-11-10	2007-11-10	04940PMMY	not active
RJKZL11020	GDB 326	mixed use	3471.85	2014-09-10	2018-09-10	16276AZBH	not active
GLUOO95947	HRA 075	professional	1348.94	2016-06-19	2020-06-19	55103ZPSB	not active
CDNTK20153	08E RK3	professional	3983.12	1995-12-12	1999-12-12	85599NPEB	not active
FKNKF28325	814 9RX	private	3060.64	2005-05-11	2009-05-11	83284DBLF	not active
HJFIH98288	775-LAO	private	769.21	1983-03-23	1987-03-23	10769ALVE	not active
VYSPE44377	6PM3715	mixed use	1536.21	1996-12-30	2000-12-30	82191YHWV	not active
BKRRH00525	463 4811	private	1011.02	2013-06-14	2017-06-14	55120LCLY	not active
BXDYP27430	SLF-681	mixed use	1420.70	2004-03-03	2008-03-03	64522VYKP	not active
MHLQD78314	WCM 529	private	2515.55	1985-03-13	1989-03-13	32305VJIF	not active
YUQTW48047	4JT Q75	private	734.49	2007-05-02	2011-05-02	36154QQBW	not active
TJHIA33396	964 IP3	professional	2409.46	1984-09-14	1988-09-14	57734LGNA	not active
DQIKI31196	4Q D4822	mixed use	3985.92	1999-04-05	2003-04-05	98043QMRH	not active
ILVOI73024	04Z 2157	mixed use	1138.26	2006-08-17	2010-08-17	87603OGLK	not active
SDFRL01987	H96 7QF	private	1826.82	1987-01-31	1991-01-31	47778WZVI	not active
EDTDX32037	QBV C27	private	2484.14	1994-02-11	1998-02-11	46015XQAX	not active
BDRTZ14423	HSH 428	professional	547.55	1983-04-06	1987-04-06	05056UNSA	not active
MFVHJ12003	8V 7131S	mixed use	3280.50	2012-08-15	2016-08-15	83914QDAV	not active
PSHTQ83029	5HGH 47	professional	3518.91	2013-12-22	2017-12-22	67176RPBA	not active
ZYDJY72686	879-UCD	private	2771.86	2007-12-05	2011-12-05	21858YONA	not active
WBKBQ15234	MDV-5677	private	624.65	1992-06-22	1996-06-22	31022IRDF	not active
IWVYD83631	732-WLK	professional	1065.17	2005-03-24	2009-03-24	67284EJED	not active
XLCXJ65645	3LZR577	professional	1937.43	1985-04-29	1989-04-29	59500UIIQ	not active
HNRWC10257	9Z 1026N	professional	230.57	2006-07-06	2010-07-06	95771UVPS	not active
KAGCL74830	ULI-9187	mixed use	1887.19	2009-10-25	2013-10-25	32971HUPL	not active
REDGN97013	580-XRQ	private	705.83	1997-07-07	2001-07-07	19266KLPA	not active
URREW75306	UOS 611	private	3404.19	2009-10-28	2013-10-28	35898FCNM	not active
JEISE24827	NXN2628	private	535.64	1985-10-23	1989-10-23	19355NNLF	not active
IZPZN22809	4O 96624	private	1213.51	1989-08-26	1993-08-26	11764FIVH	not active
VLNSQ81226	GZD-0194	professional	1820.25	1981-05-31	1985-05-31	61708LDCY	not active
VKSGD72869	5-B4621	private	2736.94	1986-02-25	1990-02-25	93974BAZZ	not active
CGNCJ12353	F47-ZQW	professional	648.27	1981-06-22	1985-06-22	79506QNVR	not active
ZMMCH47095	741 1KT	mixed use	1563.65	2000-04-12	2004-04-12	21241CENG	not active
TLPFK70926	82-94022	professional	1368.36	2014-10-30	2018-10-30	17136ELGN	not active
KJHWX58142	OHP 597	private	2478.65	1982-08-03	1986-08-03	22979ZPMU	not active
GWQPV63884	QUO 439	mixed use	2618.93	1991-05-08	1995-05-08	45963BTGS	not active
YUWMR42016	6WUL 89	private	246.06	1980-10-22	1984-10-22	91031YVBD	not active
RXMXV49127	9-5756R	mixed use	1671.44	1989-08-08	1993-08-08	74014HHPE	not active
DEFEY04672	8NE 465	mixed use	2432.55	2002-04-27	2006-04-27	85805GHFL	not active
KXWNH84161	51KH4	mixed use	652.54	1984-03-06	1988-03-06	75753QQCE	not active
YZHND29596	7113 FH	mixed use	2808.36	1988-02-26	1992-02-26	53911OCJM	not active
IHIDG43014	3IN S20	professional	1224.04	2012-06-17	2016-06-17	62475MAXH	not active
FJNQJ69549	185 8AV	professional	2640.06	2004-01-06	2008-01-06	49482IBZH	not active
LKKHD78077	OAB 115	mixed use	2286.48	2004-03-15	2008-03-15	86195RUXM	not active
XQHCN98617	OPT-567	professional	1554.31	2016-03-31	2020-03-31	73298ITQO	not active
JNTJU00484	SEJ 2186	professional	3996.23	1990-09-07	1994-09-07	61686XOZR	not active
RSRQW09437	5-3602I	professional	2639.75	1989-09-13	1993-09-13	16533LUQD	not active
QUSFA91037	U47-ZFZ	mixed use	3162.66	1983-10-23	1987-10-23	41342DTQK	not active
TIDVE09324	264-FFN	private	2357.47	2000-03-14	2004-03-14	03552MMGN	not active
GBDAE79535	42U E17	private	1857.41	1993-05-02	1997-05-02	67383HZVX	not active
ILARQ64839	6V272	professional	1619.02	1992-07-11	1996-07-11	42438YADB	not active
XYWDM35536	998 UEB	professional	2127.51	2014-01-07	2018-01-07	87934XNJG	not active
IUNPE97232	F57-DQU	private	2889.88	1998-07-10	2002-07-10	38630HZNZ	not active
QMAYQ87474	WFV 438	professional	2883.65	1996-05-31	2000-05-31	68582MPTR	not active
WQQWH82541	7NV 317	professional	2813.34	2013-08-17	2017-08-17	81978JEUU	not active
AUPFX14788	12G 734	mixed use	1090.06	1981-04-04	1985-04-04	02078EQQT	not active
JMBZH38877	XDR 244	professional	1827.82	1986-06-07	1990-06-07	32669QAMY	not active
PACLI42148	900-ZHA	private	2097.97	2000-07-18	2004-07-18	11116WFHA	not active
IMSQD49146	0F 6036O	private	172.38	1997-04-12	2001-04-12	52279JVHF	not active
ZGINF01281	7401 UA	private	2609.13	1991-06-02	1995-06-02	23373OIZR	not active
ZFXCW64183	ZVT-099	private	511.91	2000-12-18	2004-12-18	70064RDVI	not active
OVBZA73292	249-BUW	professional	648.66	2009-01-11	2013-01-11	54411TIYF	not active
GPTCU31070	508U	mixed use	759.83	2012-07-03	2016-07-03	72935ZOEP	not active
NNZDA30695	793 OJT	professional	206.32	1990-10-28	1994-10-28	15483UTSS	not active
DBFVQ19842	AQ9 H1X	professional	3715.67	2013-12-19	2017-12-19	70133LXRT	not active
OFPWR05850	3393	private	2825.59	1995-09-18	1999-09-18	16730ZVIA	not active
GCOUI77164	2-94366I	professional	2353.31	2014-05-12	2018-05-12	30828RHLO	not active
MBAIV18468	A56-HII	mixed use	766.92	1986-02-25	1990-02-25	85393JJBI	not active
RLDHZ26879	3-54356V	professional	776.14	2013-01-20	2017-01-20	44609WILJ	not active
PPTKW23223	9-79815	private	2296.33	1985-10-16	1989-10-16	46639TZPG	not active
RNSFU01802	DNB O58	private	1567.82	1982-11-10	1986-11-10	62745BDVN	not active
HHHEO13552	841-JFAT	mixed use	2200.16	2008-09-21	2012-09-21	73157LIPH	not active
WSMPX32359	8L 9X9FLZ	private	227.12	2014-04-01	2018-04-01	89695FAMD	not active
DULXD01466	XLN4969	professional	1833.18	1994-11-07	1998-11-07	42013QHIR	not active
KHIXX46200	QIH 409	professional	3669.08	2008-03-02	2012-03-02	68428OEFB	not active
YRVPJ07722	LKM 657	professional	2574.96	2006-10-08	2010-10-08	43426DRZZ	not active
CZUGS23792	749ONN	mixed use	3692.36	2012-06-21	2016-06-21	60328SAPA	not active
XORNB03790	9OO 663	professional	2768.25	1994-12-15	1998-12-15	79723EUNH	not active
UMCTA18044	618HNP	private	3822.14	1997-09-28	2001-09-28	84374PPKA	not active
QPEOW07577	U81 3VZ	private	2987.04	1982-04-09	1986-04-09	49803AKGC	not active
KPAWJ69658	JRM 387	private	1720.95	1998-10-06	2002-10-06	41202VRAI	not active
OEORM40436	FDF1234	professional	3352.18	2016-04-25	2020-04-25	19717MIGS	not active
QVOWH20585	63DL626	mixed use	1425.50	2005-04-01	2009-04-01	82477VGEO	not active
LVGAL83226	ISN 788	professional	1328.84	1983-06-07	1987-06-07	58217LNYS	not active
TNCGE55636	561H0	mixed use	3445.66	1990-06-06	1994-06-06	77999UXSR	not active
FOFJO45681	BU-6680	private	2343.28	2000-07-14	2004-07-14	50789WSEV	not active
LZYCU62481	927 5XR	mixed use	371.07	1992-12-18	1996-12-18	51118DLYY	not active
NRFHL09800	0-5724W	professional	3497.83	2008-12-10	2012-12-10	51682FSWG	not active
DQKLY83223	347 CY4	professional	3935.81	1995-09-28	1999-09-28	36255KUID	not active
CDJPC64806	97-86218	professional	2611.80	2015-04-12	2019-04-12	91343ITWF	not active
WAVPE63983	9295	private	3873.21	2013-12-04	2017-12-04	73860ZFXZ	not active
XUJHM13017	509 UVM	private	3429.38	1990-03-19	1994-03-19	56369HXEP	not active
MSUIU96691	531AJG	mixed use	3043.29	1999-03-28	2003-03-28	88254BLBN	not active
JGZCK23755	MKO-9627	mixed use	337.69	2011-04-06	2015-04-06	87910RZWT	not active
GYNAN46993	HJC 040	professional	1375.22	1990-09-28	1994-09-28	62057CFRB	not active
AGHVL03200	24E T56	professional	681.92	2003-06-27	2007-06-27	52058LYKU	not active
IJORH56949	ZOB-9687	mixed use	1197.42	1981-03-10	1985-03-10	54940GODH	not active
JXLWA70455	844-IEF	professional	461.72	2014-02-20	2018-02-20	77363CFCP	not active
BQAUP35437	QHM 493	professional	1820.94	1990-02-27	1994-02-27	99370FKWO	not active
PXUNT26045	93-DJ50	professional	2356.97	2014-05-29	2018-05-29	84292DHIB	not active
JKDOC70926	TGC 358	private	3454.92	2010-12-04	2014-12-04	17239JEWQ	not active
FZCRQ66756	150 ZIG	professional	350.70	1998-10-22	2002-10-22	63331UQLD	not active
LZHZM15910	KFC 617	professional	1564.26	2007-10-26	2011-10-26	70298ZUZH	not active
ISCFL20103	319-TIH	mixed use	2802.79	1990-06-18	1994-06-18	31128EHQZ	not active
CGMTK21080	885 9SN	private	1530.91	1985-08-02	1989-08-02	79875HUWC	not active
BFLVO81806	23HE5	private	3004.67	2001-05-30	2005-05-30	85599NPEB	not active
BLNLP31774	7-9762N	mixed use	1618.04	1989-10-18	1993-10-18	55229VVKR	not active
BODXW71269	0X 8U0BCJ	professional	957.24	2012-01-25	2016-01-25	55120LCLY	not active
TRXRX64025	301 YOS	private	1991.45	1991-11-26	1995-11-26	18388XKVN	not active
CHDXD14952	4-A2654	mixed use	3281.97	2012-04-11	2016-04-11	83914QDAV	not active
APWYV48338	HMI-3217	professional	1060.26	1987-09-07	1991-09-07	21171ASDE	not active
PAGIL26287	9ZU 177	mixed use	2057.26	2005-10-18	2009-10-18	67176RPBA	not active
ZHUOZ14572	456 BUU	private	1885.33	2003-05-24	2007-05-24	59905KSHU	not active
ZWZYD73114	8BR 346	mixed use	3610.31	2013-02-21	2017-02-21	06282MHGC	not active
ZJZKR18039	806-IYA	private	2321.00	1998-04-30	2002-04-30	05941YUVA	not active
AJUUQ43701	34-TB96	mixed use	2934.32	2010-03-05	2014-03-05	59509DURL	not active
CHDLR61769	382Q	mixed use	2758.25	2011-10-11	2015-10-11	58175VDBX	not active
PNBXQ53017	4J 70004	mixed use	3122.78	2005-03-27	2009-03-27	82923NARG	not active
KTZXN64764	W20-KPT	professional	782.67	2011-06-24	2015-06-24	21364FPLG	not active
ZIZSI41940	QEI-0537	private	2158.46	1994-04-17	1998-04-17	11764FIVH	not active
QPGJO80954	JGM-3687	professional	2014.57	1984-09-19	1988-09-19	61708LDCY	not active
BGYPH92656	9-3689U	mixed use	358.61	1985-03-11	1989-03-11	61817FIKY	not active
GSSOZ45551	562-882	professional	1345.02	1989-01-16	1993-01-16	93974BAZZ	not active
OAURR79991	79P 8449	private	2451.24	1994-02-23	1998-02-23	61961BNWO	not active
EPDTT07866	TZS 355	professional	2255.11	2013-06-04	2017-06-04	21241CENG	not active
GNLJC98991	TXP 119	mixed use	1004.18	2008-10-13	2012-10-13	63785XOAR	not active
HAIAI36958	GO2 A1M	professional	585.09	1980-07-07	1984-07-07	60305DOQS	not active
OIEGW48506	5V 20870	mixed use	294.03	2016-01-23	2020-01-23	39505HHYG	not active
EJZPL00728	4XU T07	professional	276.43	2002-05-05	2006-05-05	45963BTGS	not active
EJSBZ99819	3-29745B	private	236.94	1988-07-13	1992-07-13	76743DMGG	not active
KCBWX85740	IDG3512	mixed use	2255.85	2016-11-13	2020-11-13	85805GHFL	not active
WOVDJ92225	463 HCR	mixed use	3200.60	1991-05-12	1995-05-12	22761GKIH	not active
FKMGW32147	5K 9958I	mixed use	3805.68	1986-10-07	1990-10-07	70413RVBO	not active
TTQLG80989	131407	private	1766.70	1996-04-14	2000-04-14	53911OCJM	not active
MBNNA04186	630 RYU	mixed use	2662.53	2006-04-15	2010-04-15	62475MAXH	not active
KIYMC91661	7-93686	professional	286.62	2017-04-12	2021-04-12	98217TVPW	not active
MEJDK03402	181 IOX	professional	578.28	1991-07-02	1995-07-02	27947XAKE	not active
JCRYA34416	76H 074	mixed use	642.25	1988-06-17	1992-06-17	07678YBBR	not active
UQMQT32144	JBU-719	private	1128.60	1995-11-29	1999-11-29	86195RUXM	not active
LKVNK85756	260 0787	professional	391.45	1989-06-12	1993-06-12	38502VNJP	not active
XZFCB08337	FKS5798	professional	2193.61	1982-09-29	1986-09-29	42118POCR	not active
CJBSM83416	XMM 522	private	3882.20	2012-03-24	2016-03-24	14386YXAV	not active
OFIKX80448	672 XTW	private	3465.60	2012-04-05	2016-04-05	01892JAZK	not active
SJUME83675	38EE0	mixed use	2611.53	2007-07-05	2011-07-05	64642EJWA	not active
YSZJE18520	8XH D17	professional	2434.07	2017-01-10	2021-01-10	92623KQZR	not active
JMRAL56689	013 GQW	professional	957.96	1998-11-18	2002-11-18	67383HZVX	not active
MNBHF56531	KIT-7646	private	2313.97	1989-12-22	1993-12-22	42438YADB	not active
CEDFC68081	3HI 498	private	1650.91	1990-09-25	1994-09-25	29615DGPL	not active
ADYAP09496	953CAG	private	1535.43	2010-02-04	2014-02-04	25935HNYY	not active
VKEDC89103	UFA6995	private	1803.42	2002-10-29	2006-10-29	27271BNGN	not active
BKTDS25774	1J 5086X	mixed use	910.21	2008-03-01	2012-03-01	68582MPTR	not active
NDMOZ95808	47Z 6497	professional	2122.41	2014-05-23	2018-05-23	02078EQQT	not active
CMGZW99763	6TG2820	professional	425.35	2005-10-06	2009-10-06	95531TBRP	not active
UDEPE13950	126-NTO	mixed use	1389.80	1988-06-25	1992-06-25	34284QPPH	not active
DPXEP85431	ZHL 199	mixed use	854.37	2002-07-07	2006-07-07	44421IHHW	not active
QTJKH58142	FJF 835	mixed use	135.51	2015-12-16	2019-12-16	95040SBVL	not active
VKBGD19741	252 JNU	private	124.60	1990-01-26	1994-01-26	51549NDPJ	not active
AAHPR85928	78-OS09	mixed use	3521.27	1990-09-18	1994-09-18	88545LAYL	not active
ARAXU11969	OVI V67	professional	1562.62	1983-02-11	1987-02-11	52279JVHF	not active
JKUVM51567	H79 1HA	professional	1258.48	1986-07-06	1990-07-06	50300NKLM	not active
IONUP55907	GAB-6707	professional	2774.55	2015-01-31	2019-01-31	23373OIZR	not active
PITMW11211	2K 5J6SHE	mixed use	1801.47	1994-03-21	1998-03-21	71777VLNK	not active
BLVDR83879	606-DYS	private	672.17	2012-09-28	2016-09-28	02370YQOZ	not active
CHNHO67967	9-95446	mixed use	1334.13	2007-07-14	2011-07-14	15483UTSS	not active
XIDRZ43628	AHY-8188	mixed use	1186.70	1996-12-28	2000-12-28	66094VTVF	not active
FZJHP98728	031-WWS	private	1914.38	2003-01-06	2007-01-06	27325QHFP	not active
HLXMU17159	OPZ-371	mixed use	2791.57	2003-09-26	2007-09-26	84514WYTX	not active
SKZEQ63310	LXS-2300	mixed use	2299.86	1993-10-04	1997-10-04	70133LXRT	not active
UPAZA24825	MLN 363	mixed use	521.14	1987-10-21	1991-10-21	25434HMPF	not active
PYEAG00967	QXE 489	private	2621.60	2014-10-14	2018-10-14	86627NLLZ	not active
OCNKJ79965	773 VBA	professional	3779.83	2000-02-08	2004-02-08	09591PDXE	not active
JDHHA31544	7KG5595	professional	3931.89	1996-06-26	2000-06-26	38804LVKL	not active
MTRXV51539	04UV0	professional	705.22	1983-06-23	1987-06-23	34273SJIT	not active
QCWSD80420	GBZ 8738	mixed use	711.76	1990-01-18	1994-01-18	73157LIPH	not active
MLJAA14307	G23-RSI	professional	2846.27	1993-01-17	1997-01-17	89695FAMD	not active
FEOCN05109	55N G71	private	154.96	1988-12-28	1992-12-28	36136GDUV	not active
ZCLWI58087	734 JXY	mixed use	2225.40	1993-08-27	1997-08-27	01659YYEU	not active
NBVCT89981	647BJT	professional	3928.48	1986-01-04	1990-01-04	49638CIFF	not active
EMYWE96840	97Y Z17	private	636.06	2006-01-11	2010-01-11	54653TVUV	not active
JPHRA54982	QXX2513	private	154.22	1986-05-12	1990-05-12	77098AYAB	not active
QXUXM12664	740E	mixed use	959.51	1983-12-09	1987-12-09	68428OEFB	not active
KFTWO35272	0PH R91	professional	2862.94	2010-06-23	2014-06-23	84374PPKA	not active
YMBMZ89693	578-ZIG	private	1657.79	2002-10-09	2006-10-09	82477VGEO	not active
VJCDQ01196	0281 HA	mixed use	3657.40	2004-04-16	2008-04-16	58217LNYS	not active
KBVCO42264	6-Z8779	private	2253.56	1982-10-17	1986-10-17	76566VEGI	not active
QWHYP81137	0K 3Z9TWZ	mixed use	2743.36	2009-10-04	2013-10-04	07986OOYY	not active
VEEBY03946	586 WMG	professional	216.84	1981-12-05	1985-12-05	17337TFTU	not active
OVBOW39501	0-0073G	private	2939.07	1986-05-15	1990-05-15	14404DRGA	not active
WLECN90014	CCA 785	mixed use	2732.81	1991-01-30	1995-01-30	98911THJQ	not active
HSZXM46369	DPQ-862	mixed use	1622.22	1992-01-23	1996-01-23	22176FNDT	not active
FJZKZ46826	3-2260K	private	2017.21	2012-06-11	2016-06-11	35138FFHY	not active
ORDJF34230	E80-MLA	private	761.09	1984-06-30	1988-06-30	51118DLYY	not active
WFPTJ89346	OMQ-0373	professional	3279.85	1995-12-27	1999-12-27	51682FSWG	not active
NYEHD44593	6UEH 81	mixed use	502.73	2000-06-16	2004-06-16	36255KUID	not active
LSNQT20331	5Q 8041F	private	3532.47	2007-12-27	2011-12-27	91343ITWF	not active
WXLTK99018	196-IJH	private	3335.05	2011-08-09	2015-08-09	73860ZFXZ	not active
SYBRN07849	371 TSX	professional	2437.20	2003-07-15	2007-07-15	62816IIBX	not active
NCDVO61984	297-059	professional	516.07	1995-07-25	1999-07-25	41784LILU	not active
RLGCI94282	7N U0957	private	213.87	1995-11-21	1999-11-21	56369HXEP	not active
GYFPR27369	65-XC64	professional	3883.83	2016-07-17	2020-07-17	88254BLBN	not active
UDSQG43007	7-1694W	private	3979.84	1987-01-19	1991-01-19	87910RZWT	not active
PEJRO51727	487-TDM	mixed use	3414.73	1988-02-09	1992-02-09	98657ZERQ	not active
ETSGG89277	686 FMH	professional	2339.40	2014-04-29	2018-04-29	52058LYKU	not active
KVGCC91922	9T 72900	mixed use	3522.52	1998-03-22	2002-03-22	54589MPFN	not active
ZRCZV56467	378 3HL	private	3679.29	1982-05-20	1986-05-20	49028DURP	not active
IZETS06628	C15 4EE	professional	140.21	2014-12-26	2018-12-26	77235BUOB	not active
PDBIZ63425	01A 9646	professional	2432.87	1992-09-18	1996-09-18	98849FHWR	not active
ICLLW47322	916 NUU	private	2775.56	2016-04-28	2020-04-28	04940PMMY	not active
NJERC45154	G70 3WW	mixed use	1027.41	1980-07-09	1984-07-09	16276AZBH	not active
NCSOT45906	21HT781	mixed use	3902.19	1989-02-06	1993-02-06	30848FGKT	not active
WVRCF25491	7CZT129	mixed use	3195.33	1984-05-21	1988-05-21	85599NPEB	not active
HUBUO57427	WQY 234	professional	919.61	1996-12-09	2000-12-09	83284DBLF	not active
QIOGC36167	LD 15596	mixed use	1032.55	2008-01-26	2012-01-26	09100UMKS	not active
YCUCI66325	146-GLZ	private	1213.87	1991-10-04	1995-10-04	72610MBZX	not active
FUHAR33073	BNU F71	mixed use	2454.37	2009-08-12	2013-08-12	10769ALVE	not active
ZMVAK10443	2-92597	professional	3414.94	2015-05-04	2019-05-04	72032EAOV	not active
HKFIU14425	KLI 161	private	1624.45	1988-02-05	1992-02-05	55229VVKR	not active
LTIKF14795	853X	mixed use	2256.03	1997-10-18	2001-10-18	36239MGOR	not active
BMRII50299	4C T7368	mixed use	1326.69	1985-06-05	1989-06-05	77959SEHI	not active
SRUFZ48985	ABV-999	private	3637.58	1986-07-31	1990-07-31	10471PBQI	not active
MKRCI39277	MDG-2298	professional	2783.43	2008-12-10	2012-12-10	55484EYRU	not active
UAOOU94658	0KG M67	mixed use	3435.66	2003-03-03	2007-03-03	31022IRDF	not active
NRYAJ42395	91L•279	professional	613.57	1999-11-12	2003-11-12	80917GKVX	not active
CDLNH30557	IJO-087	professional	3672.11	1983-05-08	1987-05-08	59509DURL	not active
BKQKY33425	626 JMF	professional	1043.55	2014-03-06	2018-03-06	58699UWMV	not active
VFQDW01119	IDE Q02	private	151.62	2012-03-14	2016-03-14	19266KLPA	not active
VKFXE06963	AVO-8514	private	3177.75	2001-04-23	2005-04-23	36981SZFS	not active
FRTLL30812	MFN 112	private	3418.91	1993-08-30	1997-08-30	84721EHSZ	not active
LCXFZ69670	457 OGY	professional	1145.75	1989-05-25	1993-05-25	80628UDTO	not active
GEWLM94304	733-DBS	private	682.93	1988-05-21	1992-05-21	33563HAHM	not active
OELTM44935	HUX5388	professional	3737.58	2005-05-21	2009-05-21	11764FIVH	not active
PNCOH79965	111-KOY	private	1793.30	1987-12-04	1991-12-04	61817FIKY	not active
UTTCE54436	981 ZYJ	professional	3613.94	2016-11-08	2020-11-08	93974BAZZ	not active
YTDPE04120	ZDQ 601	professional	3783.75	2016-03-02	2020-03-02	73397VCQJ	not active
WHYFQ63103	LGO 446	private	2038.08	1982-07-23	1986-07-23	61961BNWO	not active
EJTZF75263	KBY 511	private	320.21	2007-09-09	2011-09-09	17136ELGN	not active
LMXBP83021	DZT 883	professional	1579.78	1991-07-13	1995-07-13	63785XOAR	not active
YSYHM14462	715-ZRY	mixed use	2668.72	1983-08-22	1987-08-22	57042LJVM	not active
ZOJWJ54205	3RM K37	mixed use	2750.38	2001-02-05	2005-02-05	46386XMYL	not active
NMVIF06576	JFK4635	private	1153.86	2014-09-23	2018-09-23	99566JOFM	not active
BTRSD55961	15-F068	professional	3628.53	2014-06-20	2018-06-20	63920BTFS	not active
QGPRF94784	566-NQN	private	3739.00	1990-12-23	1994-12-23	94914KLGC	not active
VBBAQ55792	6-8996Z	mixed use	1436.84	2008-08-14	2012-08-14	74014HHPE	not active
MONHU82805	2A 3C0PYJ	mixed use	2106.84	2001-01-23	2005-01-23	78225BDOQ	not active
KBVNL62928	95-S381	private	3976.31	2009-05-31	2013-05-31	19131ZQOE	not active
SYZXQ39833	SCY 097	professional	2040.56	1996-12-13	2000-12-13	70413RVBO	not active
NZKMT75956	NKU6307	professional	3689.95	1999-07-01	2003-07-01	53911OCJM	not active
KSPRZ84742	L01 9CC	professional	3134.30	1992-11-13	1996-11-13	83780RTBV	not active
VRRJA04888	201 0SP	professional	3108.18	2007-02-17	2011-02-17	91946CVVN	not active
SRQRC20807	VX 65339	private	2049.84	2015-03-13	2019-03-13	86195RUXM	not active
FPTTE55347	3LH0223	professional	3686.84	1996-02-28	2000-02-28	67383HZVX	not active
DSKXN86623	A04 3IE	mixed use	384.33	1985-01-18	1989-01-18	82767MXXC	not active
JMTWH48064	IQM-226	mixed use	619.31	1994-12-30	1998-12-30	87934XNJG	not active
UIVDZ97318	DP 0811	mixed use	2397.27	1999-09-22	2003-09-22	25935HNYY	not active
SQODH32809	B74-EMZ	professional	485.72	1981-04-24	1985-04-24	38630HZNZ	not active
UWAJG25941	355 8EA	private	1296.59	1982-12-25	1986-12-25	68582MPTR	not active
WUSLD50444	598 AZC	private	1814.52	1999-05-08	2003-05-08	98552YSEK	not active
SYHJH04033	M93-93F	mixed use	1396.54	1989-08-15	1993-08-15	95531TBRP	not active
YTUBK64102	0NJ 213	private	1047.56	2010-09-30	2014-09-30	87647XQNQ	not active
IITAV25434	58JP0	professional	589.35	2006-10-15	2010-10-15	34284QPPH	not active
ANRRX40545	438029	professional	134.30	1988-05-13	1992-05-13	88545LAYL	not active
TDREN32758	5-76967	mixed use	1332.09	1986-05-28	1990-05-28	11116WFHA	not active
UMLMS28577	UOU-842	private	3248.48	2001-01-14	2005-01-14	52279JVHF	not active
OPFUJ07797	OU2 M5A	mixed use	3056.10	1991-02-14	1995-02-14	97024ACRA	not active
XPNIA11846	3TN B66	private	2705.88	1984-10-27	1988-10-27	50300NKLM	not active
TDIVU25733	900-YHQ	mixed use	2443.64	2013-12-19	2017-12-19	70064RDVI	not active
YEQMZ49035	923-GJDP	professional	1440.47	1998-09-13	2002-09-13	24273JCDS	not active
CKTDL34270	Z97-UJS	professional	1205.57	1993-08-05	1997-08-05	60620NVYL	not active
ZPINH64802	8F713	private	1399.07	2010-10-10	2014-10-10	65159HQQP	not active
QXQYE02502	NFW-9627	private	1930.08	2006-04-17	2010-04-17	17101QTEN	not active
HPGMZ26987	5-1620E	professional	726.17	2016-02-17	2020-02-17	16730ZVIA	not active
EJFKE84308	87I 572	mixed use	597.65	2016-09-30	2020-09-30	69408PZCQ	not active
PKZEE43479	706 3600	professional	3416.17	2006-06-17	2010-06-17	38804LVKL	not active
HOHJT85887	251 MRD	private	1624.32	2008-01-19	2012-01-19	71718MGNI	not active
CGPTJ61025	3JV 444	mixed use	2686.12	1984-02-13	1988-02-13	46639TZPG	not active
ZKMIY30142	505 TXG	professional	2455.74	2005-01-17	2009-01-17	90636SXTS	not active
DMOZY53923	75OC6	private	1694.39	1992-11-10	1996-11-10	00568MWGV	not active
NQCMO02024	C03 2XV	professional	3662.73	1992-10-31	1996-10-31	42013QHIR	not active
IYGYP20412	0OC 603	professional	3700.19	2012-09-16	2016-09-16	68428OEFB	not active
ROQOL05060	2-49570	professional	2919.76	1994-04-19	1998-04-19	58217LNYS	not active
WPTIS08744	384 UOI	mixed use	105.21	2015-09-07	2019-09-07	32776URIO	not active
VBIYI16612	6I 30651	professional	1779.44	2015-12-05	2019-12-05	05913SDIU	not active
GZTEX91713	5OA 432	professional	833.85	1995-05-17	1999-05-17	45464WSJG	not active
MNRDN83978	7AO 606	private	3116.01	1994-09-05	1998-09-05	14404DRGA	not active
DJWSV61389	464L	mixed use	2143.28	1995-08-29	1999-08-29	22176FNDT	not active
ICZMN77031	0-P8239	mixed use	2423.58	2005-08-03	2009-08-03	92891DPPY	not active
UCXYT36500	L18 9BR	professional	3417.02	1986-12-18	1990-12-18	51118DLYY	not active
MYTDC79709	KLW 747	professional	802.81	1981-12-31	1985-12-31	89526MVNF	not active
NXURX24679	660 3DC	private	2043.83	1996-04-12	2000-04-12	80341OYHN	not active
UEBKE62521	1-K7220	private	2239.01	2011-03-01	2015-03-01	91124PCFZ	not active
OMKVR34264	LYM 191	private	2364.76	2007-04-06	2011-04-06	51682FSWG	not active
MFEHG52603	NGE-8186	private	2558.77	1981-05-31	1985-05-31	36255KUID	not active
JHOOD13975	396-UNI	mixed use	1882.87	2000-01-24	2004-01-24	13859MSJF	not active
BAOVA36281	7-0261X	professional	1556.80	1984-10-13	1988-10-13	73860ZFXZ	not active
ZWLQE27587	F 996293	professional	1977.29	1997-08-10	2001-08-10	85721RGLG	not active
YSMGZ74468	NIQ-0296	private	263.70	2013-11-15	2017-11-15	62816IIBX	not active
JAXJP46946	788 6NV	mixed use	384.47	1991-10-25	1995-10-25	41784LILU	not active
OIRQM60377	515 5161	mixed use	496.31	2009-03-01	2013-03-01	71982XHRY	not active
VKMGC54519	0Z 05228	mixed use	3732.79	2017-03-20	2021-03-20	52058LYKU	not active
VRBAQ76709	QJT C42	mixed use	1111.75	2002-01-08	2006-01-08	54940GODH	not active
LADGT80701	HUI 057	professional	3046.15	2011-06-25	2015-06-25	54589MPFN	not active
OSUHU33543	QK8 2563	private	3987.21	2006-01-07	2010-01-07	78883ARZJ	not active
PELQN07945	182M	private	219.32	1997-03-16	2001-03-16	49028DURP	not active
OKGHH94669	STY-507	private	2818.15	2011-07-29	2015-07-29	79571JNBX	not active
JYDHL89937	EXU-1189	professional	1057.71	1993-03-12	1997-03-12	77097DUZP	not active
CROAQ14457	46-7254L	mixed use	1034.11	1995-11-06	1999-11-06	63331UQLD	not active
DJZBD83045	OH 4374	mixed use	2384.31	2002-09-10	2006-09-10	54925RJRY	not active
RUANG38458	XSQ 940	professional	393.47	2015-03-04	2019-03-04	98849FHWR	not active
EKJZK88392	V 678591	mixed use	2514.79	1988-08-31	1992-08-31	23754LFSH	not active
VCRFP29460	1QCZ466	professional	166.40	2017-02-09	2021-02-09	83284DBLF	not active
YKMJV33184	BGT-8561	private	240.24	1993-07-22	1997-07-22	86956MEKE	not active
ZNNSY70160	701747	mixed use	3276.01	1980-06-21	1984-06-21	55229VVKR	not active
KZASJ09276	4-18231P	mixed use	1001.79	2006-12-19	2010-12-19	43512YVLG	not active
DFSWL27254	F33 0BX	private	1747.48	1990-03-12	1994-03-12	36239MGOR	not active
FBYUA13208	870EW	mixed use	1928.60	1991-09-07	1995-09-07	88392OUWV	not active
WJMTE13420	AGG8389	professional	3438.63	1998-08-18	2002-08-18	77959SEHI	not active
PPYLF15815	10GW101	private	3868.73	2016-12-22	2020-12-22	87603OGLK	not active
LGEDB83918	5-6003A	private	1084.29	2008-04-22	2012-04-22	22900FXDM	not active
TEVEB30478	535 IK2	mixed use	1567.63	2012-02-07	2016-02-07	46015XQAX	not active
DEDRS49491	612 JSE	private	378.40	1997-09-24	2001-09-24	65496JTJS	not active
JUKRW02374	EX2 9328	mixed use	3448.21	2006-03-29	2010-03-29	15154ZGCE	not active
UHSIP40781	93C 2845	professional	2917.85	1982-06-07	1986-06-07	59905KSHU	not active
DBVLL12677	W21 7IC	private	2722.65	2008-06-19	2012-06-19	37698CHVT	not active
HQDZJ81099	73-AR24	private	566.12	2007-12-24	2011-12-24	70056ATSQ	not active
PULOS02974	172 LQS	professional	2490.65	2003-08-18	2007-08-18	21858YONA	not active
VAQRD13199	CQ 88787	private	2789.71	1991-01-10	1995-01-10	55484EYRU	not active
UUJAB55931	QOJ 407	mixed use	3262.92	1996-11-11	2000-11-11	80917GKVX	not active
ELMXP90275	L98 2ER	professional	3562.33	2005-01-10	2009-01-10	59500UIIQ	not active
HSUQR25004	2520 WF	mixed use	1785.12	2010-04-17	2014-04-17	95771UVPS	not active
TAVZE04373	221-LKD	private	2000.90	2013-09-26	2017-09-26	32971HUPL	not active
RRYFK21741	H13 6QA	private	403.62	2006-04-20	2010-04-20	19266KLPA	not active
OWXCZ54540	ZLF 641	mixed use	2520.39	2015-04-11	2019-04-11	36981SZFS	not active
DHZMK46848	SZJ 592	mixed use	639.40	1983-04-26	1987-04-26	82923NARG	not active
ZFZAX99707	H84 5NZ	mixed use	1460.52	1998-11-07	2002-11-07	21364FPLG	not active
BRQON04857	268-718	mixed use	1681.67	1989-10-07	1993-10-07	83600WKWC	not active
UWMZF47486	9XP E52	private	1071.06	2011-02-08	2015-02-08	11764FIVH	not active
LZSDZ35830	951 NCT	mixed use	1854.42	2007-09-24	2011-09-24	61708LDCY	not active
IVBXB06317	6-11208	mixed use	120.61	2010-04-12	2014-04-12	73397VCQJ	not active
EUKJY67982	8380	private	590.69	2012-03-18	2016-03-18	71165ADJK	not active
MAYGM07564	05-J219	mixed use	2575.13	1994-10-06	1998-10-06	61961BNWO	not active
FCCXT08315	0WN V61	mixed use	934.29	2005-07-27	2009-07-27	79506QNVR	not active
VIFRS25740	54QX5	professional	1016.31	1991-11-23	1995-11-23	70982PIUM	not active
NFEWK12086	643 APQ	professional	3699.04	1994-03-18	1998-03-18	21241CENG	not active
ZWFRG95159	1OU8194	private	1773.43	1994-04-07	1998-04-07	17136ELGN	not active
XEDUD67998	0DX5658	mixed use	1537.95	1997-07-16	2001-07-16	46386XMYL	not active
YDFMW61376	6G P8070	private	2755.33	1996-07-30	2000-07-30	33111FIVL	not active
VDFED40214	150-AIT	private	283.29	1984-04-21	1988-04-21	72654HUSA	not active
RDZQJ18175	ALK 807	mixed use	2505.41	1982-02-27	1986-02-27	27025MYJS	not active
HWQUD57178	6-W9864	private	3422.14	1999-03-06	2003-03-06	40695OWQR	not active
JVXYV74160	721 EGT	private	3112.80	1995-08-03	1999-08-03	75753QQCE	not active
UFBCK36372	TLB 614	mixed use	2254.59	1980-12-15	1984-12-15	35764FOIB	not active
WKAKF12589	KJJ 310	mixed use	705.80	2009-04-08	2013-04-08	19131ZQOE	not active
HVLHI94215	5YOQ 35	professional	1760.72	1989-01-31	1993-01-31	70413RVBO	not active
PSORQ98339	025 0PJ	private	2647.32	1995-10-27	1999-10-27	49482IBZH	not active
FMPLU99171	918 XET	mixed use	1450.18	1997-12-25	2001-12-25	07678YBBR	not active
VEBEV74136	MCO 747	mixed use	3540.96	1989-05-03	1993-05-03	67383HZVX	not active
ALAZF12253	967 XAQ	mixed use	154.76	1993-11-01	1997-11-01	76649BVYS	not active
WOZYP56673	7QY8840	professional	2989.61	1997-05-09	2001-05-09	29615DGPL	not active
JVCMF63573	50K 0105	mixed use	3113.41	1984-08-19	1988-08-19	25935HNYY	not active
ZPERS93666	6HWY 41	private	2557.56	2016-12-02	2020-12-02	27271BNGN	not active
LFWGJ18306	315YCH	professional	891.81	1982-12-28	1986-12-28	38630HZNZ	not active
KAWVT07762	HAB 064	professional	1521.28	2015-03-06	2019-03-06	94211GXXU	not active
ITUNC16485	086 VYW	mixed use	3278.72	1981-01-19	1985-01-19	80733GLAN	not active
QGIXE16344	43-19624	mixed use	1954.44	1997-03-14	2001-03-14	98552YSEK	not active
WAEOA46611	TIR 293	professional	585.76	1992-05-13	1996-05-13	02078EQQT	not active
DHZBC70308	VVT-313	mixed use	2962.11	2017-01-21	2021-01-21	34451YCKS	not active
QMRNG81813	3517	private	1471.18	1980-09-19	1984-09-19	51549NDPJ	not active
BAJBF18075	BJ 72028	professional	1126.80	2002-07-09	2006-07-09	32669QAMY	not active
IKTXI92966	1BG S96	professional	3547.37	1999-11-12	2003-11-12	97024ACRA	not active
JCSCO39680	033DT	professional	1108.62	2015-12-27	2019-12-27	50300NKLM	not active
UUEPG85068	4V L9931	mixed use	1857.62	2004-08-29	2008-08-29	56911ZULC	not active
TANKF07300	YLX-3258	mixed use	1407.03	2013-01-05	2017-01-05	77648HPWS	not active
TEMGC13695	5KH 922	private	1242.37	2013-04-21	2017-04-21	54411TIYF	not active
CSANK45471	05-IF75	mixed use	362.42	1987-07-31	1991-07-31	71777VLNK	not active
QTOPA74903	08R 559	private	2769.88	1988-12-08	1992-12-08	99217SYRA	not active
KLKCB62481	4N 04973	private	150.30	1996-04-10	2000-04-10	15483UTSS	not active
ENITE11703	3641	private	3514.53	2000-03-22	2004-03-22	65159HQQP	not active
VRKMP75861	86-7374J	professional	1551.73	2005-11-20	2009-11-20	17101QTEN	not active
FAVPW85124	36-LF56	professional	3402.97	2000-04-04	2004-04-04	95475BQLW	not active
XBWQF85267	YJU-467	professional	3559.79	2005-01-05	2009-01-05	85393JJBI	not active
GRQZW84091	B60-VWJ	professional	792.08	2016-04-28	2020-04-28	62745BDVN	not active
BAGAL20366	24K 730	professional	3996.42	2016-08-25	2020-08-25	43212TDKJ	not active
PBSFY20294	S73-88B	professional	3332.14	2015-06-30	2019-06-30	73157LIPH	not active
UGJNQ26266	012 9681	mixed use	3492.45	2009-08-12	2013-08-12	01659YYEU	not active
PAXIT88027	F87-94C	mixed use	2078.48	1998-04-13	2002-04-13	54048BMBC	not active
WTHVF34010	079Z3	mixed use	1540.16	1994-05-07	1998-05-07	04597IGNA	not active
QHKWJ15296	076 6339	mixed use	3042.20	2015-04-07	2019-04-07	49638CIFF	not active
CEQEW06273	1799	mixed use	3561.86	1989-10-15	1993-10-15	77098AYAB	not active
TAVUS48622	886 RWI	professional	3452.09	1997-12-18	2001-12-18	68428OEFB	not active
UFXEA42958	578-FYHM	professional	2154.93	1997-07-08	2001-07-08	43426DRZZ	not active
CYLPN66315	00R P09	mixed use	3010.84	2016-11-25	2020-11-25	79723EUNH	not active
GLEIH87767	35-67079	mixed use	388.76	1994-12-05	1998-12-05	19717MIGS	not active
MHBKZ11894	907 YRF	professional	454.55	1993-01-07	1997-01-07	82477VGEO	not active
ISWVH52995	818-EAG	professional	3678.79	1982-11-29	1986-11-29	32776URIO	not active
YZMYY54063	229KIZ	mixed use	3125.59	1997-11-19	2001-11-19	13891NOSE	not active
XKURV25998	B 272001	professional	587.55	1990-02-28	1994-02-28	07986OOYY	not active
OVWAZ16379	015 IRX	professional	3887.25	2015-01-24	2019-01-24	77999UXSR	not active
TIOXW00199	2-50287	professional	2932.72	1997-12-17	2001-12-17	45464WSJG	not active
LMQOC77660	77N 596	mixed use	2363.56	2000-11-03	2004-11-03	50789WSEV	not active
UNADN00208	3NW U44	professional	2078.35	1980-06-30	1984-06-30	51682FSWG	not active
WZUUV76204	8BB9830	mixed use	3599.09	1993-08-16	1997-08-16	82119ZXLO	not active
ARCUW68701	31K J90	mixed use	1844.99	2009-11-20	2013-11-20	13859MSJF	not active
XKUZT49172	959 PPU	professional	779.40	2014-12-23	2018-12-23	73860ZFXZ	not active
HZHJU60593	CEG-7377	professional	1958.67	1997-04-17	2001-04-17	85721RGLG	not active
ZPQMG72252	BPL-883	professional	3848.32	1985-03-20	1989-03-20	62816IIBX	not active
NILNX85166	VHU-560	mixed use	503.52	1988-09-23	1992-09-23	56369HXEP	not active
GGMZP47595	YWZ 595	mixed use	1810.61	2014-09-29	2018-09-29	42269XXOE	not active
MJHWG54989	0H 98955	professional	1257.29	2005-09-07	2009-09-07	88254BLBN	not active
EFIWY83162	0NM0292	mixed use	2258.08	2016-03-11	2020-03-11	62057CFRB	not active
VITSE04438	78-K824	mixed use	2492.20	1985-08-13	1989-08-13	98657ZERQ	not active
XRPJE66132	EHE 4075	professional	1164.24	1993-09-05	1997-09-05	52058LYKU	not active
OKHQZ96636	543 GNR	professional	2955.69	1987-03-22	1991-03-22	06976BQRC	not active
TPGIL46087	NJG-6665	private	216.07	2016-07-18	2020-07-18	54940GODH	not active
CRVOR56438	MVY 713	professional	3833.02	2009-07-31	2013-07-31	54589MPFN	not active
IWDVW50160	036K1	mixed use	2066.55	1991-10-27	1995-10-27	99370FKWO	not active
ZTXYI82892	AI 6935	mixed use	972.18	1986-06-29	1990-06-29	49028DURP	not active
GFCNH44397	N 788808	mixed use	1180.71	1997-08-31	2001-08-31	79571JNBX	not active
WGIOU42003	3-66051	private	3540.35	1983-08-17	1987-08-17	63331UQLD	not active
ZQTKO62088	YY4 2288	professional	2801.74	1982-10-19	1986-10-19	70298ZUZH	not active
SNBWD03430	095 FQZ	private	2420.55	2005-01-25	2009-01-25	77235BUOB	not active
CCFJQ04843	I74 4OC	private	2500.01	2003-05-14	2007-05-14	98849FHWR	not active
CTJSW15940	6RW6048	private	2714.18	2004-07-11	2008-07-11	48645NFGV	not active
UAXYB50964	D93-TNA	mixed use	2588.26	1995-04-05	1999-04-05	91456OASB	not active
RAYMA22615	021IYI	professional	762.85	1986-12-18	1990-12-18	55103ZPSB	not active
BWZTU88022	769-699	professional	1814.48	2014-06-25	2018-06-25	22519SNXK	not active
STLFT43859	SVA-1631	mixed use	1592.49	2016-12-29	2020-12-29	72610MBZX	not active
UFCFM51613	86AX2	private	1079.87	2010-12-29	2014-12-29	82191YHWV	not active
LCKDT85766	9BM89	mixed use	1949.84	1989-08-14	1993-08-14	86956MEKE	not active
NMOEH43998	SMO 815	private	1819.92	1982-03-04	1986-03-04	43512YVLG	not active
VFCFC04028	7Z 6929X	professional	3230.67	1996-12-09	2000-12-09	43473HAYP	not active
JOEOZ17414	ZXT 321	mixed use	678.33	1981-01-10	1985-01-10	36239MGOR	not active
GPBHW85425	785 TDP	professional	371.85	2010-06-25	2014-06-25	88392OUWV	not active
YRXVF11230	333HLE	mixed use	1859.57	2003-09-08	2007-09-08	98043QMRH	not active
OKTSB56720	GEB-2708	private	1523.76	1981-08-21	1985-08-21	20818UVVJ	not active
QIXWZ30720	T 783124	professional	3047.10	1985-06-03	1989-06-03	22900FXDM	not active
XLMHQ26329	5B539	mixed use	1054.71	2004-06-27	2008-06-27	47778WZVI	not active
HFYRV02990	PHI-4177	mixed use	2989.47	1985-11-27	1989-11-27	67176RPBA	not active
ONRIK90033	ZYA 530	mixed use	2580.79	1993-12-16	1997-12-16	10196JLKV	not active
EAYGH95419	0P 8570L	mixed use	2161.18	2016-07-18	2020-07-18	06282MHGC	not active
VBXMZ78417	JGG-6535	private	1506.47	2005-01-07	2009-01-07	70056ATSQ	not active
BXTFN68488	25O 4226	private	845.37	2012-06-28	2016-06-28	21858YONA	not active
KWVMN37182	556 FJQ	professional	1060.21	2009-10-30	2013-10-30	31022IRDF	not active
FAXAV85105	2978 GK	professional	598.67	1987-11-24	1991-11-24	80917GKVX	not active
SVHAY51328	ZZA 815	private	3318.72	2016-06-23	2020-06-23	59500UIIQ	not active
WLYYQ76383	398LNJ	professional	3767.16	2005-12-21	2009-12-21	05941YUVA	not active
VRSPH86882	267 NZR	private	3096.52	1989-01-28	1993-01-28	58175VDBX	not active
FLEBB04425	SFX 795	mixed use	2498.79	1988-02-25	1992-02-25	80628UDTO	not active
KQLSQ10682	359 DEQ	private	268.95	2012-04-20	2016-04-20	33563HAHM	not active
ZUUMT32154	891 VLG	professional	3545.93	1998-03-14	2002-03-14	21364FPLG	not active
TRAHS65318	1GZ Q60	private	3230.94	1993-06-02	1997-06-02	61708LDCY	not active
IVJFZ77979	RBP-661	mixed use	1834.47	2004-10-20	2008-10-20	71165ADJK	not active
HSDBH86624	670 WNA	private	3085.31	2007-09-26	2011-09-26	17136ELGN	not active
NBTRH36234	YVC-494	mixed use	999.38	1994-01-01	1998-01-01	39505HHYG	not active
NZONJ20498	64-4925J	mixed use	2035.28	1980-11-16	1984-11-16	22979ZPMU	not active
EFWOP03929	H72 2YK	private	1195.08	2006-03-09	2010-03-09	45963BTGS	not active
ORFYX78970	34M•017	mixed use	809.04	1984-01-05	1988-01-05	91031YVBD	not active
MOKQX26843	455277	private	294.12	1999-12-25	2003-12-25	74014HHPE	not active
ECIYX53283	MA7 4057	private	275.97	2015-08-15	2019-08-15	27025MYJS	not active
BKEGK90981	O46-QGQ	professional	1324.59	1996-08-19	2000-08-19	40695OWQR	not active
VYJZG23937	LGW-976	professional	1790.50	1998-10-09	2002-10-09	78225BDOQ	not active
NZDLK14258	MVE 979	professional	1030.65	1992-10-07	1996-10-07	75753QQCE	not active
GZAWE57973	070-VWK	private	848.71	1986-02-06	1990-02-06	62475MAXH	not active
FIIYM26357	31-FK94	professional	1595.33	2012-08-26	2016-08-26	98217TVPW	not active
RYMON11135	LYI 915	professional	3970.32	2013-01-26	2017-01-26	27947XAKE	not active
DVSMP89664	MFU S87	private	1691.27	2017-03-17	2021-03-17	91946CVVN	not active
TKUHD92050	ZIP 864	mixed use	387.06	2004-08-21	2008-08-21	73298ITQO	not active
JMWXM97356	902W	mixed use	112.96	2012-08-03	2016-08-03	93214WTZW	not active
ULXWN75495	TDQ-793	private	2442.96	2015-09-27	2019-09-27	87612BOEV	not active
DCZNJ28361	1NLF 30	private	417.52	2000-03-15	2004-03-15	67383HZVX	not active
HVPLN48944	7Z 3534Q	professional	2875.16	2010-11-06	2014-11-06	29615DGPL	not active
SKFRX30061	VFO-811	mixed use	2192.66	2001-08-23	2005-08-23	87934XNJG	not active
VNBFX76945	EJD 803	professional	353.25	1989-10-18	1993-10-18	25935HNYY	not active
FQGQJ67780	238 TNK	professional	918.61	1991-10-04	1995-10-04	93591RHQB	not active
DFLIP17107	781 1FW	mixed use	787.70	1996-12-08	2000-12-08	27271BNGN	not active
UCVMP34346	DRJ 830	private	2229.56	1984-05-24	1988-05-24	38630HZNZ	not active
EALDE47111	575 1HP	professional	2198.16	2003-06-08	2007-06-08	95531TBRP	not active
TAYTB93859	4GT X73	professional	1961.38	2004-09-07	2008-09-07	87647XQNQ	not active
HESHJ27518	3JQ 654	private	2600.32	1988-02-02	1992-02-02	34284QPPH	not active
ZOMMB76901	941 KNO	private	1276.60	1984-06-29	1988-06-29	44421IHHW	not active
BATYQ34532	40-6718N	mixed use	107.04	2011-05-09	2015-05-09	51549NDPJ	not active
HTCLW89465	BDO8119	private	2552.60	1997-02-03	2001-02-03	00532WKFG	not active
RBPFT59032	RWO-7493	private	3259.42	1992-09-21	1996-09-21	52279JVHF	not active
ORNAG14746	HPR-2951	professional	1976.21	1986-10-01	1990-10-01	65031CTFS	not active
DBTKV56600	845 MNG	professional	1903.77	2007-06-27	2011-06-27	50300NKLM	not active
PPHWA16453	EAR 714	mixed use	3201.38	1996-01-09	2000-01-09	50584GBVS	not active
PQPQC25348	UEL-550	private	2737.84	2014-12-13	2018-12-13	70064RDVI	not active
CJGRF10475	ZT-5655	mixed use	763.49	1991-12-14	1995-12-14	54411TIYF	not active
DKMPR03062	844 2KO	mixed use	1373.38	2004-10-13	2008-10-13	71777VLNK	not active
LCPIX72117	07W YE1	mixed use	3656.24	2008-02-17	2012-02-17	42765RSFG	not active
KXCHH45921	6I PI469	professional	2635.06	1996-10-02	2000-10-02	15483UTSS	not active
DMKHJ32326	GBT6744	professional	3411.99	1997-02-08	2001-02-08	60620NVYL	not active
LZJKM38287	AJY-9891	private	2691.64	1983-02-19	1987-02-19	27325QHFP	not active
HFEGO53497	EXF6194	private	3271.85	2007-08-15	2011-08-15	84514WYTX	not active
FZSFS78265	4VAX385	professional	3807.04	1986-03-28	1990-03-28	65159HQQP	not active
FAXME10497	617-206	mixed use	2133.21	1997-09-26	2001-09-26	70133LXRT	not active
TYLAR90666	016W	private	456.23	2010-07-14	2014-07-14	69408PZCQ	not active
SVNTQ16383	CFP-340	mixed use	1410.97	2005-05-10	2009-05-10	30828RHLO	not active
WJNMQ08821	047EM	private	1529.99	2014-02-27	2018-02-27	86627NLLZ	not active
BHLUF32625	84A 238	professional	738.36	1988-03-14	1992-03-14	34273SJIT	not active
DYBQF69909	X51 1HP	professional	3988.74	2004-09-26	2008-09-26	44609WILJ	not active
FGBOR72959	HLU 274	professional	2246.32	2012-08-05	2016-08-05	46639TZPG	not active
YIMUM67520	351 WMT	private	2024.60	1990-10-06	1994-10-06	36136GDUV	not active
RBFGR40285	0IL3153	professional	2497.12	2008-12-27	2012-12-27	90636SXTS	not active
LPVEU48228	BUX7525	mixed use	2204.80	1981-08-03	1985-08-03	04597IGNA	not active
ZBSTV40540	SZE-9965	mixed use	1002.52	2000-01-09	2004-01-09	42013QHIR	not active
BMVJX34771	Y 653696	private	695.02	2015-09-03	2019-09-03	39381PFJJ	not active
LASWV10040	VT7 Y2W	professional	3016.34	2003-05-25	2007-05-25	84374PPKA	not active
TBTLW92754	420-OYK	private	1692.92	2001-11-15	2005-11-15	41202VRAI	not active
ODVSL08549	XVE-0881	private	2764.33	2003-08-24	2007-08-24	19717MIGS	not active
NTRZY16184	179-NLE	professional	2968.38	2012-06-14	2016-06-14	32776URIO	not active
HBBYN21395	57W•489	private	1883.93	2010-07-01	2014-07-01	67654IKZR	not active
VCGYN70925	816-ZUF	professional	3856.65	1999-05-28	2003-05-28	17337TFTU	not active
YPAIO65218	701 0KB	mixed use	2431.56	2011-05-05	2015-05-05	62283VGAV	not active
DUQGA50316	N09-CVL	mixed use	2542.79	2015-08-31	2019-08-31	98911THJQ	not active
LWHMG76600	LGE-9000	professional	3555.80	1991-12-08	1995-12-08	79596YHKE	not active
UWZYM38365	ALH-469	mixed use	2192.31	2003-04-24	2007-04-24	35138FFHY	not active
YEHKN51300	46J QC4	mixed use	1960.65	2004-11-08	2008-11-08	80341OYHN	not active
YBFMT98859	SSX 149	private	3255.56	2004-09-13	2008-09-13	51682FSWG	not active
KJFQC57589	740 GOJ	professional	3911.05	2017-03-25	2021-03-25	91343ITWF	not active
EKKPT80483	4Y705	mixed use	3063.16	1980-08-31	1984-08-31	13859MSJF	not active
OMBZF89042	625-ZXA	professional	3265.47	1984-11-03	1988-11-03	73860ZFXZ	not active
BAQRM17844	73D 529	private	1787.31	1981-05-11	1985-05-11	42269XXOE	not active
OQEJL22205	O14-56N	professional	254.02	2013-09-09	2017-09-09	87910RZWT	not active
VSQFE54130	1OA J97	mixed use	815.97	2002-12-07	2006-12-07	98657ZERQ	not active
OVLDQ29613	50I 0130	mixed use	2987.07	2010-05-21	2014-05-21	77363CFCP	not active
IXPQA35144	69EZ893	mixed use	3493.39	1988-06-22	1992-06-22	49028DURP	not active
NOFYT75527	MQY-242	mixed use	658.13	1999-02-19	2003-02-19	94444SGVC	not active
ZEYTF10319	450 VVZ	mixed use	978.92	1995-07-12	1999-07-12	04940PMMY	not active
LFYQH66705	UTW-6872	mixed use	403.90	1981-05-11	1985-05-11	79875HUWC	not active
BQIKS27632	7-1470B	mixed use	3864.61	2012-06-29	2016-06-29	16276AZBH	not active
QDQHB75248	0OA Y11	professional	2210.30	2013-02-04	2017-02-04	22519SNXK	not active
VJPTE32825	4JL 679	private	317.35	2001-07-28	2005-07-28	10769ALVE	not active
YWLRF45590	702XP	private	3825.39	1993-12-17	1997-12-17	82191YHWV	not active
XONIG77334	817K	mixed use	944.05	2006-06-27	2010-06-27	86956MEKE	not active
QCDLV64085	958 6408	private	3355.91	1995-04-23	1999-04-23	55229VVKR	not active
PYKCO14291	8-I0181	private	3874.70	1997-03-08	2001-03-08	64522VYKP	not active
TQUTS75161	HP8 C7F	private	3305.23	2004-01-01	2008-01-01	32305VJIF	not active
DPTUX00954	FBP 349	private	2766.42	2016-12-13	2020-12-13	36154QQBW	not active
UITIW79791	VGQ 530	mixed use	3121.16	1986-05-20	1990-05-20	57734LGNA	not active
MIKCG65466	P84 0AC	mixed use	1274.75	1997-10-15	2001-10-15	36239MGOR	not active
KMVQM35756	CWU-1443	private	1964.52	1985-02-05	1989-02-05	77959SEHI	not active
VJUQL63345	064 8XT	professional	3295.69	1989-09-27	1993-09-27	87603OGLK	not active
RXDQL33500	UV 4166	mixed use	1743.69	1980-10-11	1984-10-11	22900FXDM	not active
TZSMC55293	KQI-137	professional	737.41	1994-02-07	1998-02-07	47778WZVI	not active
HJCNA63298	0AS 085	mixed use	3008.04	1985-11-21	1989-11-21	10471PBQI	not active
XYROP70818	367 SER	private	610.45	1995-07-15	1999-07-15	83914QDAV	not active
JWRVQ93283	9VM O50	professional	1779.03	2006-03-30	2010-03-30	15154ZGCE	not active
QEHVD02005	TQF-695	private	3472.15	2010-04-09	2014-04-09	21171ASDE	not active
NONWH32827	167-IQP	mixed use	1885.72	2009-03-19	2013-03-19	70056ATSQ	not active
BBEYA89330	982 EWJ	professional	1865.65	2011-04-28	2015-04-28	55484EYRU	not active
PVITQ86704	WD-4200	professional	569.40	1987-02-10	1991-02-10	31022IRDF	not active
TDFCJ06222	TY 5461	mixed use	214.75	2016-08-03	2020-08-03	67284EJED	not active
TUCPD07896	685 QZR	mixed use	3682.96	1990-08-22	1994-08-22	05941YUVA	not active
PWENQ37806	R50 1NH	professional	2329.90	1998-08-17	2002-08-17	59509DURL	not active
WOGCQ32319	898T6	professional	1398.10	2006-07-15	2010-07-15	95771UVPS	not active
ANMWQ83854	725H	professional	1229.73	2004-06-27	2008-06-27	58175VDBX	not active
LDJRW51662	3KM 696	mixed use	3639.93	1983-08-27	1987-08-27	35898FCNM	not active
SEOVY50379	K80-ZXB	mixed use	1306.13	1986-06-25	1990-06-25	19355NNLF	not active
QAHOB24346	AYV 369	professional	1436.69	1984-07-31	1988-07-31	33563HAHM	not active
RKNDD90719	542-MTZ	mixed use	2968.16	2006-12-12	2010-12-12	21364FPLG	not active
QEXVU58642	LDR 808	professional	525.89	1988-11-25	1992-11-25	79506QNVR	not active
SGYCB25899	028-BAQL	mixed use	3092.22	1990-09-03	1994-09-03	70982PIUM	not active
ENVCN24267	YFF-665	mixed use	2137.84	1982-03-04	1986-03-04	17136ELGN	not active
LRQVF28065	4-45012A	private	2820.13	1986-04-11	1990-04-11	60305DOQS	not active
BZUOX33407	HS 3074	private	570.85	2016-07-23	2020-07-23	46386XMYL	not active
UVAID26464	9T589	mixed use	3079.05	2012-01-01	2016-01-01	78232DVOC	not active
NTOBN36020	9-F8654	professional	2238.83	1986-07-02	1990-07-02	45963BTGS	not active
DGESO61064	2-M4064	mixed use	860.96	2004-02-16	2008-02-16	85805GHFL	not active
LLBQF88305	V58 2EN	private	1105.11	2000-09-14	2004-09-14	72654HUSA	not active
UVFTZ00931	LNA 574	mixed use	3377.74	2013-01-16	2017-01-16	40695OWQR	not active
SEQFG04943	40G 6406	professional	3230.04	2012-08-13	2016-08-13	35764FOIB	not active
IOVNL62676	RPJ 8340	professional	3762.53	1990-08-17	1994-08-17	19131ZQOE	not active
USYZE83418	ZXG 094	mixed use	125.67	2004-08-23	2008-08-23	70413RVBO	not active
IFXPT47699	994-CWF	private	1108.91	2009-11-02	2013-11-02	27947XAKE	not active
MWLIJ66446	MRT 516	professional	326.69	2009-04-18	2013-04-18	07678YBBR	not active
HWVTD27540	ZMD 044	professional	2343.02	2006-03-26	2010-03-26	14386YXAV	not active
KXGFH72139	ESX 218	professional	3899.29	1986-12-27	1990-12-27	59784RNYP	not active
JUJEV60568	23C WU4	mixed use	1805.48	2021-03-10	2025-03-10	49941YHBD	active
HMWJQ41732	02-S856	professional	3942.43	2022-02-17	2026-02-17	53911OCJM	active
\.


--
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customers (customer_id, full_name, gender, birthday, phone_number, cell_phone, email, address_id) FROM stdin;
18258VTFF	Derward Helder	M	2003-01-21	918-676-2536	3922675932	dhelder0@dyndns.org	5
08481WBBK	Julee Halkyard	F	1962-02-18	286-262-9943	5745510833	jhalkyard1@fda.gov	7
94303JWTD	Joeann Pfeuffer	F	1994-05-07	718-818-0133	\N	\N	12
93214WTZW	Cyndi Grinsted	F	1995-07-09	874-873-8835	2958634349	cgrinsted3@ibm.com	14
87612BOEV	Marni MacCall	F	1948-04-22	838-313-2791	1247221643	mmaccall4@squarespace.com	19
03552MMGN	Staford Lindeman	M	1980-07-18	912-160-1373	8828699739	slindeman5@npr.org	20
92623KQZR	Jere Ingarfill	M	1963-03-09	619-412-5184	4682707587	jingarfill6@wikipedia.org	23
67383HZVX	Chic Measor	M	1971-07-22	799-383-6834	4128882184	cmeasor7@wikia.com	26
42438YADB	Conroy Di Ruggiero	M	1949-12-13	294-383-1799	6916394849	cdi8@timesonline.co.uk	30
82767MXXC	Bob Ravelus	M	1980-09-16	589-689-2808	1402153844	bravelus9@zdnet.com	31
76649BVYS	Happy Deeks	F	1967-09-27	114-293-1852	4378385600	hdeeksa@freewebs.com	32
29615DGPL	Michaeline Polon	F	1987-07-21	237-653-2222	2926849918	mpolonb@canalblog.com	33
87934XNJG	Uta Buckenham	F	1968-03-20	756-275-9893	4236410341	ubuckenhamc@home.pl	34
25935HNYY	Fayre Cantos	F	1986-07-17	187-365-9229	4959614635	fcantosd@canalblog.com	40
93591RHQB	Dino MacLure	M	1988-10-21	374-216-6166	8625227428	dmacluree@bbc.co.uk	42
27271BNGN	Jdavie Ruegg	M	1993-12-26	739-683-7713	\N	\N	44
38630HZNZ	Bird Redfield	F	1953-07-25	867-414-6820	1175802507	bredfieldg@epa.gov	45
68582MPTR	Mada Craigmyle	F	1978-11-29	808-891-9739	2636477766	mcraigmyleh@nhs.uk	47
81978JEUU	Marta Lanegran	F	1995-06-01	650-366-1084	1552937309	mlanegrani@archive.org	51
94211GXXU	Wylie Rocco	M	1993-03-27	203-663-9272	8138108733	wroccoj@vk.com	53
80733GLAN	Israel Gainsbury	M	1964-12-06	730-117-9058	7745081727	igainsburyk@ask.com	54
98552YSEK	Perry Fulloway	F	1961-09-28	487-653-8267	7733367687	pfullowayl@adobe.com	57
02078EQQT	Garrard Gimbrett	M	1979-07-21	715-677-0891	\N	\N	60
95531TBRP	Erie Rowes	M	1984-06-27	487-570-1278	6109290689	erowesn@typepad.com	64
68586FWQU	Kelsy Olivari	F	2000-10-29	710-265-4373	\N	\N	69
87647XQNQ	Yoshiko Davydkov	F	1997-06-17	587-442-6074	\N	\N	70
34284QPPH	Gian Gilby	M	1979-11-19	728-685-5723	\N	\N	73
44421IHHW	Patton Tolan	M	1984-02-03	760-585-7848	\N	\N	80
34451YCKS	Martie Ciciura	M	1951-11-30	478-163-9879	5094883199	mciciuras@squidoo.com	86
95040SBVL	Jillene Comino	F	1966-06-01	131-431-1080	\N	\N	88
51549NDPJ	Raleigh Skeen	M	1996-01-08	188-263-2880	6263863988	rskeenu@google.com.au	94
00532WKFG	Ahmad Vondrys	M	1976-10-18	771-491-1714	8905546960	avondrysv@etsy.com	100
88545LAYL	Matteo Hurn	M	1985-07-25	963-520-7206	\N	\N	108
18630CNPB	Jandy Crosgrove	F	1973-06-25	630-602-6492	3283195441	jcrosgrovex@techcrunch.com	111
32669QAMY	Orlando Viegas	M	1989-04-06	494-376-1016	\N	\N	116
11116WFHA	Gar Sawer	M	1988-09-05	444-931-0187	\N	\N	117
52279JVHF	Terri-jo Richard	F	1960-12-26	120-825-3419	8258378795	trichard10@mail.ru	120
97024ACRA	Alexandra Georgeson	F	1983-06-05	152-182-0783	3524461959	ageorgeson11@comsenz.com	122
65031CTFS	Blaine Danilyak	M	1960-12-19	437-910-3036	6085703933	bdanilyak12@blogtalkradio.com	124
50300NKLM	Brandon Ferran	M	1958-08-07	781-811-1455	2752970288	bferran13@hc360.com	125
23373OIZR	Artemus Rapson	M	1964-08-21	634-184-8175	7312408642	arapson14@reuters.com	126
56911ZULC	Marcellina Halcro	F	2001-05-18	409-315-0719	\N	\N	128
77648HPWS	Trace Chark	M	1991-01-06	551-445-3241	8788484932	tchark16@slideshare.net	133
50584GBVS	Minni Brosi	F	1959-06-30	275-446-0568	1046453954	mbrosi17@accuweather.com	134
70064RDVI	Ethelbert Escudier	M	1995-03-22	278-716-2623	2566795687	eescudier18@slashdot.org	135
24273JCDS	Minnnie Nuccitelli	F	1953-12-18	454-906-7294	7847126481	mnuccitelli19@scribd.com	137
54411TIYF	Shelley Aguirrezabala	M	1959-01-21	663-462-0239	\N	\N	139
98969JMFS	Sapphire McClounan	F	1990-04-19	269-452-0732	6153863418	smcclounan1b@blogs.com	141
71777VLNK	Margalo Sergison	F	1952-12-15	835-705-2106	2507304678	msergison1c@washingtonpost.com	142
02370YQOZ	Gerda Grayham	F	1947-07-13	554-913-1437	8586042046	ggrayham1d@google.it	143
72935ZOEP	Sadella Laxon	F	1946-01-06	645-141-3011	\N	\N	145
69115KDSM	Ivory Ekless	F	1966-07-18	559-361-6966	9285664664	iekless1f@netvibes.com	146
99217SYRA	Bartholemy Stout	M	2003-02-13	920-963-2960	9128038357	bstout1g@wix.com	147
74333REJG	Amargo Revett	F	1956-09-14	575-836-9179	5539819944	arevett1h@ca.gov	148
42765RSFG	Lola Auger	F	1962-04-22	695-692-6454	5731202030	lauger1i@oracle.com	151
15483UTSS	Rolph Caldicott	M	1966-06-14	452-624-0028	1591143608	rcaldicott1j@usda.gov	152
66094VTVF	Marita MacDearmont	F	1961-09-26	817-768-6000	4203247819	mmacdearmont1k@exblog.jp	157
60620NVYL	Beitris Wasson	F	1967-05-23	598-818-5505	9155984129	bwasson1l@salon.com	159
27325QHFP	Urbain Grunnell	M	1947-05-07	145-698-8688	3108118142	ugrunnell1m@army.mil	160
84514WYTX	Casandra McGragh	F	1959-11-09	874-727-0855	9851678001	cmcgragh1n@icq.com	162
78104LNZA	Olga Assender	F	1945-09-23	134-399-6211	7639107501	oassender1o@cloudflare.com	164
65159HQQP	Kessiah Dyshart	F	1988-03-13	607-506-9011	\N	\N	165
17101QTEN	Wilek Rodder	M	1954-04-20	225-132-5267	9228103412	wrodder1q@live.com	167
70133LXRT	Norbie De Ferraris	M	1946-03-03	814-763-7666	2707532393	nde1r@constantcontact.com	168
16730ZVIA	Avie McKevin	F	1962-08-08	836-578-1778	7991426384	amckevin1s@tripadvisor.com	169
69408PZCQ	Brandice Heinel	F	1978-08-14	696-995-8782	4432643850	bheinel1t@lycos.com	171
25434HMPF	Rozamond Smaridge	F	1952-04-16	896-635-3129	4619761007	rsmaridge1u@youtu.be	172
30828RHLO	Linnie Conor	F	1993-07-18	172-559-5639	\N	\N	174
86627NLLZ	Buddy Sennett	M	1947-07-19	446-183-3712	4473027494	bsennett1w@imgur.com	176
09591PDXE	Kasey Zealey	F	1997-04-12	412-712-7188	5784581446	kzealey1x@hubpages.com	179
95905WUFF	Alvy Thewless	M	2001-09-17	278-335-9984	3431359436	athewless1y@mayoclinic.com	182
51144WGEM	Meredeth Faunch	M	1959-03-20	386-209-6094	5851846013	mfaunch1z@feedburner.com	183
14567ZGIE	Leonardo Duggleby	M	2002-07-28	349-708-9477	9632212786	lduggleby20@tripod.com	184
95475BQLW	Onfre Maciocia	M	2003-02-16	235-461-3933	8382389123	omaciocia21@tmall.com	185
38804LVKL	Janis Heakey	F	1978-05-13	577-801-0416	\N	\N	187
85393JJBI	Zena Peeter	F	1998-11-23	350-351-0961	7259501690	zpeeter23@huffingtonpost.com	188
71718MGNI	Corry Stanlake	F	1996-07-01	926-875-3880	4204032813	cstanlake24@sun.com	191
34273SJIT	Verge De la Yglesias	M	1978-10-20	211-329-8960	\N	\N	193
44609WILJ	Twila Storry	F	1959-06-07	179-910-2526	\N	\N	195
14816AYBJ	Tiena Ecclestone	F	1945-09-30	681-181-3947	9757025999	tecclestone27@infoseek.co.jp	200
57531HHOE	Margette Clawson	F	1957-11-09	291-222-9537	6706999152	mclawson28@weebly.com	205
46639TZPG	Jory Tittletross	M	1945-07-05	786-479-2344	5789123876	jtittletross29@addthis.com	206
62745BDVN	Jacinda Fassan	F	1995-06-01	217-788-7970	\N	\N	208
43212TDKJ	Swen Monckton	M	1953-12-30	358-939-1773	4894844912	smonckton2b@wp.com	209
78690BVFL	Trace Hegden	M	1986-09-16	557-902-8348	5023498608	thegden2c@amazon.com	212
73157LIPH	Devland Legging	M	1992-01-09	802-320-2226	\N	\N	213
89695FAMD	Gabie Ardley	M	1993-11-08	452-854-3135	2512196008	gardley2e@blogs.com	218
36136GDUV	Tanney Bakesef	M	1990-02-06	490-834-5745	9272018311	tbakesef2f@cnet.com	222
90636SXTS	Mart Reeman	M	1970-10-05	937-492-6217	6972682777	mreeman2g@soundcloud.com	223
76606GSJC	Cheston Pavett	M	1979-05-27	365-228-2910	2781415965	cpavett2h@ca.gov	224
01659YYEU	Bambi Whalebelly	F	1963-11-22	885-104-1098	8553772098	bwhalebelly2i@mapquest.com	225
54048BMBC	Saree McKaile	F	1965-02-14	797-237-5827	7059930029	smckaile2j@state.gov	227
04597IGNA	Cherilyn Kneeshaw	F	1946-06-25	194-993-1307	5134723047	ckneeshaw2k@wordpress.com	229
49638CIFF	Jinny Labbey	F	1968-01-05	442-715-7206	9646470918	jlabbey2l@wikipedia.org	232
54653TVUV	Raeann Collister	F	1992-08-03	494-319-4698	5229832062	rcollister2m@pinterest.com	233
00568MWGV	Nealy Ticic	M	1961-07-29	700-712-4673	7547992234	nticic2n@google.com.au	235
77098AYAB	Cherilynn Pashbee	F	1983-02-11	945-591-5705	2507287009	cpashbee2o@bravesites.com	236
42013QHIR	Renate Carlow	F	1947-12-20	678-764-9953	1266074814	rcarlow2p@businesswire.com	239
68428OEFB	Field Adey	M	1987-08-28	389-862-5558	5182085271	fadey2q@artisteer.com	240
44762FKVQ	August Cossom	M	1974-04-09	339-867-9374	6045460104	acossom2r@technorati.com	242
43426DRZZ	Wilfred Minor	M	1981-06-08	810-244-8458	1976996335	wminor2s@cbc.ca	245
60328SAPA	Natale McCray	M	1978-06-18	253-351-5108	8231505866	nmccray2t@histats.com	246
39381PFJJ	Miguel Jouanot	M	1948-04-10	519-790-6607	3909956791	mjouanot2u@archive.org	247
79723EUNH	Pincas Eastlake	M	1953-01-17	473-861-1212	\N	\N	250
84374PPKA	Carmine Wylder	M	1967-08-26	999-638-7383	2514866747	cwylder2w@cam.ac.uk	252
49803AKGC	Glenine Adamovicz	F	1960-04-01	465-773-2942	6307218758	gadamovicz2x@apache.org	255
41202VRAI	Marysa Ferrillio	F	1956-05-06	123-735-1540	9498872782	mferrillio2y@csmonitor.com	261
19717MIGS	Aurea Treves	F	1957-10-14	761-702-1492	\N	\N	262
82477VGEO	Sigmund Escalero	M	1995-03-11	306-253-5442	9202384865	sescalero30@uiuc.edu	263
58217LNYS	Johna Perutto	F	1990-11-24	714-774-8481	\N	\N	264
09733UOWD	Berte Kinkade	F	1994-07-27	546-890-0324	9403167290	bkinkade32@bbb.org	265
32776URIO	Lisle Sly	M	1955-10-07	642-583-9620	7676480531	lsly33@huffingtonpost.com	266
76566VEGI	Aveline Wartnaby	F	2000-05-11	654-521-4601	9253397542	awartnaby34@soundcloud.com	267
13891NOSE	Jacquelyn Wheowall	F	1968-05-30	482-213-1556	\N	\N	268
67654IKZR	Adriano Sparkwell	M	1960-11-05	991-348-6227	9392467550	asparkwell36@g.co	270
57422FUFB	Ardath Ilyinykh	F	1988-01-17	665-224-6348	8551341631	ailyinykh37@sitemeter.com	275
07986OOYY	Saudra Kiltie	F	1997-07-26	276-964-1748	4588442688	skiltie38@networkadvertising.org	276
84630GIWW	Rosalind Billham	F	1981-01-10	333-841-1086	1079269418	rbillham39@tmall.com	277
81487OAVI	Ivar Fairall	M	1955-03-09	499-876-8499	3079961158	ifairall3a@shutterfly.com	280
05913SDIU	Blanca Ridgley	F	1956-10-24	238-366-5560	7149203690	bridgley3b@earthlink.net	281
77999UXSR	Cookie Candie	F	1949-10-15	211-730-3514	1432402900	ccandie3c@ocn.ne.jp	282
45464WSJG	Coralyn Brummitt	F	1948-10-17	291-211-5341	6152650265	cbrummitt3d@dmoz.org	287
14772ZJQH	Alexi Eastop	F	1986-10-31	823-412-2982	7026877063	aeastop3e@rediff.com	289
17337TFTU	Skylar Woofinden	M	1979-04-08	281-161-6650	4121366925	swoofinden3f@ustream.tv	292
62283VGAV	Kellie Cornfoot	F	1971-01-20	725-329-7409	3971697960	kcornfoot3g@google.pl	293
50789WSEV	Travers Ansill	M	1998-02-09	123-615-9351	6948081115	tansill3h@time.com	2
14404DRGA	Carly Merill	F	1980-01-25	319-257-4320	\N	\N	10
98911THJQ	Ronnie Shitliffe	M	1958-10-12	808-106-3994	5713487677	rshitliffe3j@stumbleupon.com	11
22176FNDT	Reinold Brockwell	M	1945-09-03	360-611-4941	6697238393	rbrockwell3k@4shared.com	13
79596YHKE	Junia Fearneley	F	1956-09-04	300-195-1608	\N	\N	17
35138FFHY	Priscilla Buten	F	1985-08-28	726-672-4118	4177199439	pbuten3m@java.com	18
92891DPPY	Coreen Adiscot	F	1996-06-05	847-597-6989	6215414180	cadiscot3n@about.me	19
51118DLYY	Danie Chessun	M	1982-04-29	232-359-2331	9529794174	dchessun3o@1688.com	24
89526MVNF	Tallie Bellenie	M	1950-03-28	441-976-6165	7146671353	tbellenie3p@mapquest.com	25
80341OYHN	Florrie Muncer	F	1957-03-28	834-152-3697	4332512521	fmuncer3q@devhub.com	32
91124PCFZ	Evangelia Cockshutt	F	1996-01-19	221-655-7914	2862045098	ecockshutt3r@salon.com	36
51682FSWG	Rockey Danhel	M	1958-09-05	194-669-7647	6089234415	rdanhel3s@devhub.com	38
36255KUID	Coralie Gonnel	F	1964-09-30	773-384-4077	\N	\N	45
91343ITWF	Bentley Cozzi	M	1990-02-07	630-625-1693	1484404330	bcozzi3u@abc.net.au	53
82119ZXLO	Phillip Barnett	M	1990-11-02	278-272-6004	\N	\N	54
13859MSJF	Wainwright Regus	M	1952-04-19	805-466-0384	8914061975	wregus3w@mapy.cz	57
73860ZFXZ	Moritz Medland	M	1977-07-04	825-322-0131	5454974790	mmedland3x@comsenz.com	58
85721RGLG	Olivero Napoli	M	1959-03-05	216-919-0722	9874080163	onapoli3y@skype.com	61
00822FKFK	Jerome Pownall	M	1953-10-24	291-127-0655	4762105818	jpownall3z@shinystat.com	64
34307LQXI	Talbert Kenaway	M	1957-03-15	109-467-7818	7186547353	tkenaway40@narod.ru	65
62816IIBX	Angie Skudder	M	1989-10-14	342-589-8736	6134075806	askudder41@npr.org	67
41784LILU	Ronalda Verdy	F	1952-11-12	330-829-7641	\N	\N	68
56369HXEP	Trixy Garmanson	F	1977-12-21	516-722-6284	\N	\N	70
31447GNHE	Giavani Antoszczyk	M	1947-02-02	838-273-1857	2516566884	gantoszczyk44@360.cn	71
42269XXOE	Selig Wren	M	1992-10-24	679-620-4237	\N	\N	73
00498FQFV	Johny Dimbylow	M	1983-09-20	565-172-1214	7096810517	jdimbylow46@bbc.co.uk	80
88254BLBN	Angelina Bridgen	F	1987-08-24	119-250-1440	9427580655	abridgen47@princeton.edu	81
87910RZWT	Lemmy Horlock	M	2002-01-28	666-995-1994	4028880484	lhorlock48@1und1.de	82
62057CFRB	Sabra Purton	F	1971-01-25	439-898-3953	8527893121	spurton49@yandex.ru	85
71982XHRY	Bren Westberg	F	1958-05-20	824-881-9800	2037340953	bwestberg4a@webs.com	86
98657ZERQ	Roley Mcasparan	M	2003-03-31	289-951-0573	3459256883	rmcasparan4b@indiatimes.com	88
52058LYKU	Berkley Wimmer	M	1976-01-10	892-654-1510	2449823127	bwimmer4c@facebook.com	92
06976BQRC	Albert Tremouille	M	1977-12-12	873-675-3754	5066180401	atremouille4d@indiatimes.com	95
54940GODH	Dona Kop	F	1951-09-16	368-141-4185	6366494065	dkop4e@msu.edu	96
54589MPFN	Pamela MacGill	F	1954-12-21	842-658-1629	1369396784	pmacgill4f@archive.org	97
78883ARZJ	Mommy Tizard	F	1952-02-05	630-878-6532	2083440650	mtizard4g@theatlantic.com	99
77363CFCP	Pamella Ablitt	F	1947-03-13	968-583-3720	5873131419	pablitt4h@nsw.gov.au	105
99370FKWO	Vincenty Gudgion	M	1998-12-30	625-521-2070	4171168533	vgudgion4i@clickbank.net	108
49028DURP	Major Gabbetis	M	1982-05-25	515-776-7652	4106835950	mgabbetis4j@bloglines.com	110
84292DHIB	Lind Harmson	F	1986-03-10	420-931-4488	8482744316	lharmson4k@thetimes.co.uk	113
79571JNBX	Cecil Kubanek	M	1971-02-20	537-955-5001	6303197111	ckubanek4l@ucoz.com	120
60764GEVW	Lyndel Shovlar	F	1985-09-27	848-712-9219	\N	\N	121
77097DUZP	Beverly Delacoste	F	1963-11-03	839-153-3175	4022686175	bdelacoste4n@google.ca	124
17239JEWQ	Keslie Hardaker	F	1994-01-02	912-122-3536	\N	\N	125
63331UQLD	Joy Cumine	F	1955-06-09	976-364-0632	1743918141	jcumine4p@youtu.be	127
70298ZUZH	Nola Lummis	F	1958-10-31	801-306-4238	9046000690	nlummis4q@berkeley.edu	132
54925RJRY	Eziechiele Shireff	M	1979-09-16	223-169-2488	3392283659	eshireff4r@yellowbook.com	134
77235BUOB	Lorelle Moyne	F	1957-10-13	650-137-7947	7802488335	lmoyne4s@furl.net	140
31128EHQZ	Janenna O' Molan	F	1949-04-22	658-592-1187	1764130542	jo4t@bloomberg.com	141
12458QKFX	Rickie Cheney	M	2002-11-24	111-247-7724	9444075302	rcheney4u@quantcast.com	143
98849FHWR	Louisa Barrie	F	1971-03-19	123-758-4688	3523849010	lbarrie4v@archive.org	145
94444SGVC	Des Philippault	M	1968-08-10	360-819-3724	\N	\N	146
48645NFGV	Pip Barlee	M	1953-04-28	673-131-5333	3286320035	pbarlee4x@bing.com	148
23754LFSH	Seamus Hurrion	M	1959-02-02	561-575-7237	3537564567	shurrion4y@weibo.com	149
91456OASB	Koren Broader	F	1971-12-28	731-375-2222	1694025798	kbroader4z@delicious.com	150
04940PMMY	Vern Salmoni	M	1946-10-03	910-733-5481	7631531816	vsalmoni50@amazonaws.com	151
79875HUWC	Shannan Dimelow	M	1972-09-09	508-573-4914	\N	\N	152
16276AZBH	Muffin Georgius	M	1992-10-22	828-225-7040	1915658525	mgeorgius52@fotki.com	155
55103ZPSB	Gertie Meritt	F	1969-04-25	246-772-4842	5877225982	gmeritt53@zdnet.com	156
30848FGKT	Glenn Longhorne	M	1997-03-08	834-853-4862	5492529667	glonghorne54@nationalgeographic.com	161
12655ULTD	Alexis Gorler	F	1999-03-07	169-654-2556	4464490216	agorler55@tripod.com	163
85599NPEB	Laurette Hullett	F	1993-08-12	321-162-0929	6946562342	lhullett56@weibo.com	166
18019RBDW	Irv Lacotte	M	1991-12-26	908-991-3725	8173688683	ilacotte57@harvard.edu	167
83284DBLF	Octavius Loomis	M	1979-02-23	188-665-4864	1103908131	oloomis58@phpbb.com	169
22164JXUR	Maxim Maggiore	M	1982-10-22	415-771-9957	\N	\N	173
09100UMKS	Lorianna Lambeth	F	1957-10-05	916-771-7829	6898155627	llambeth5a@miitbeian.gov.cn	175
22519SNXK	Tremaine Godbold	M	2000-06-24	772-249-0391	6619748992	tgodbold5b@paginegialle.it	178
72610MBZX	Krissy Larvor	F	1954-10-18	145-829-0531	5812025453	klarvor5c@sciencedirect.com	181
10769ALVE	Valma Thornhill	F	1969-05-27	857-135-8481	4346472222	vthornhill5d@msn.com	188
72032EAOV	Ethelred MacGinney	M	1980-01-10	455-760-7313	8358365291	emacginney5e@canalblog.com	189
82191YHWV	Albina Morais	F	1981-06-23	349-828-1540	9587942407	amorais5f@cdc.gov	190
86956MEKE	Sayres Luscombe	M	1949-09-08	277-296-3918	\N	\N	192
55229VVKR	Melosa Pryce	F	1953-12-19	139-207-4078	3819720736	mpryce5h@hud.gov	193
43512YVLG	Noellyn Denty	F	1981-09-16	114-205-6451	2085136348	ndenty5i@mysql.com	197
55120LCLY	Byrom Manifold	M	1966-04-26	650-668-6763	3533883616	bmanifold5j@ted.com	199
42627LHYL	Joye Jaime	F	1976-01-20	229-433-9590	\N	\N	200
64522VYKP	Consuela McIan	F	1985-07-23	583-214-8375	9626178408	cmcian5l@jugem.jp	202
32305VJIF	Cherida MacKissack	F	1988-08-23	987-429-5702	5631312288	cmackissack5m@house.gov	203
93887GIPN	Beilul Attwoul	F	1959-06-12	932-577-3143	6632073970	battwoul5n@slideshare.net	205
43473HAYP	Shurlock Linstead	M	1956-08-30	965-777-7803	9073377845	slinstead5o@discuz.net	206
36154QQBW	Warner Kilbee	M	1988-08-29	835-211-9964	5835581271	wkilbee5p@squarespace.com	207
57734LGNA	Arron Dallicoat	M	1951-07-06	620-544-7283	2951639865	adallicoat5q@cpanel.net	208
36239MGOR	Belva Dovermann	F	1993-10-03	930-538-6860	1343041917	bdovermann5r@sohu.com	210
88392OUWV	Valerye Gueny	F	1953-02-09	798-407-1136	2662952352	vgueny5s@lulu.com	212
98043QMRH	Agosto Leitche	M	1954-03-19	630-834-7122	7214399901	aleitche5t@etsy.com	216
21429UKNW	Cherin Shrieves	F	1963-02-02	381-563-5362	4787431788	cshrieves5u@reverbnation.com	224
01087MZWC	Claudell Geockle	M	1977-06-19	591-330-5704	8976718323	cgeockle5v@joomla.org	225
77959SEHI	Demott Overel	M	1989-05-10	502-663-3647	7554572996	doverel5w@washingtonpost.com	226
20818UVVJ	Audrie de Banke	F	1961-12-05	178-933-3326	8247738477	ade5x@ucoz.com	229
87603OGLK	Bruis Trythall	M	1979-10-15	208-904-5173	1776070112	btrythall5y@google.fr	230
22900FXDM	Lotty Bygraves	F	1979-05-05	698-428-1717	6289839165	lbygraves5z@linkedin.com	231
47778WZVI	Gaylene Boxill	F	2000-12-22	561-571-1181	1904267829	gboxill60@house.gov	233
46015XQAX	Georges Franzetti	M	1950-12-17	661-144-5805	3873973541	gfranzetti61@newsvine.com	239
05056UNSA	Lacie Budleigh	F	1964-04-20	863-594-5160	3947863648	lbudleigh62@livejournal.com	240
10471PBQI	Riccardo Atcock	M	1968-09-29	255-186-6775	4619541077	ratcock63@spotify.com	242
48452PJNW	Giovanna Armatidge	F	1968-04-20	604-712-8860	5738075263	garmatidge64@jugem.jp	248
18388XKVN	Robinett Sneddon	F	1992-12-29	630-811-0906	6364555202	rsneddon65@wix.com	251
65496JTJS	David Eastope	M	1969-07-21	769-423-4015	1755338482	deastope66@desdev.cn	255
83914QDAV	Peggie Manklow	F	1999-03-16	205-529-1830	2905928841	pmanklow67@merriam-webster.com	259
15154ZGCE	Sly Paulillo	M	1965-06-15	257-336-6654	2562623041	spaulillo68@discovery.com	260
21171ASDE	Chrissie Manuello	F	1996-11-20	419-587-2591	8573565055	cmanuello69@sitemeter.com	274
29518NYSP	Horatio Timmins	M	1967-03-02	734-882-9222	7912751019	htimmins6a@dmoz.org	275
67176RPBA	Cecilius Crix	M	1967-04-15	839-735-6487	1911643468	ccrix6b@google.ca	279
59905KSHU	Sheilah Willgrass	F	1984-09-07	123-429-3191	7147099296	swillgrass6c@linkedin.com	283
37698CHVT	Weider Artiss	M	1997-10-20	368-661-6828	6523200331	wartiss6d@abc.net.au	286
10196JLKV	Lona Hedlestone	F	1957-03-04	234-863-4399	9176237986	lhedlestone6e@cnbc.com	290
06282MHGC	Renault Jeskins	M	1992-12-03	839-130-2126	3345657759	rjeskins6f@fc2.com	292
70056ATSQ	Tani Hassur	F	1957-10-01	587-634-7018	7796052317	thassur6g@craigslist.org	298
17108GILE	Adan Sallows	F	1986-04-03	519-406-3439	\N	\N	301
21858YONA	Marin Spyby	F	1960-01-13	402-752-1043	4917389946	mspyby6i@skyrock.com	302
55484EYRU	Wilek Simmings	M	1980-03-14	775-580-4758	5672756365	wsimmings6j@ucoz.com	304
31022IRDF	Winfred Cocke	M	1947-07-21	769-615-8908	\N	\N	308
67284EJED	Brantley Nuccii	M	1995-08-28	966-406-6672	1324051239	bnuccii6l@drupal.org	310
80917GKVX	Eloise Cafe	F	1991-04-28	467-984-0354	\N	\N	311
59500UIIQ	Hyacinthe Hanson	F	2000-01-18	166-822-2818	2329089642	hhanson6n@toplist.cz	315
05941YUVA	Tamiko Gratton	F	1956-08-05	179-924-3462	6797149623	tgratton6o@fema.gov	316
59509DURL	Tybalt Pitman	M	1960-03-26	671-194-5606	3268787849	tpitman6p@paypal.com	318
95771UVPS	Nita Evesque	F	2002-01-15	686-432-1961	8744972646	nevesque6q@irs.gov	319
58699UWMV	Madalyn Salsbury	F	1958-12-28	784-536-8161	\N	\N	324
32971HUPL	Clayson Klimkiewich	M	1959-01-11	697-307-1865	6392044172	cklimkiewich6s@nps.gov	325
58175VDBX	Maurits Seebright	M	1966-06-27	858-530-1443	1783105426	mseebright6t@dagondesign.com	326
19266KLPA	Aksel Rozzier	M	1951-04-03	546-435-1904	\N	\N	327
36981SZFS	Bellanca Boatwright	F	1981-03-06	440-298-9341	8631118335	bboatwright6v@hugedomains.com	331
84721EHSZ	Paddy Tersay	M	1992-01-17	849-970-0850	4798042098	ptersay6w@about.com	334
80628UDTO	Esmeralda Bonny	F	1982-11-21	202-932-1549	5287737707	ebonny6x@surveymonkey.com	342
82923NARG	Maxie Segebrecht	F	1998-01-15	814-239-8032	\N	\N	9
35898FCNM	Marion Djurdjevic	M	1964-05-10	577-715-4919	9913251428	mdjurdjevic6z@princeton.edu	10
19355NNLF	Cam Glackin	F	1964-06-07	706-849-6574	1461975717	cglackin70@marketwatch.com	11
33563HAHM	Lucian Marklew	M	1957-09-12	514-401-9612	1397018094	lmarklew71@usa.gov	12
21364FPLG	Hal McLeish	M	1946-12-10	641-969-5446	8481812917	hmcleish72@webmd.com	13
83600WKWC	Parrnell Etock	M	1989-03-15	634-675-5929	6481101739	petock73@odnoklassniki.ru	14
11764FIVH	Nicola Blannin	M	1986-01-29	573-395-9244	3602450931	nblannin74@oaic.gov.au	19
61708LDCY	Elton Couronne	M	1958-06-15	303-608-4872	9741975531	ecouronne75@patch.com	20
61817FIKY	Obediah Lumpkin	M	2000-12-03	641-800-6464	2702975865	olumpkin76@ask.com	23
93974BAZZ	Shermie Benedick	M	1962-03-13	596-291-6971	6571716680	sbenedick77@g.co	24
73397VCQJ	Orbadiah Androck	M	1958-10-26	940-217-3949	2314397389	oandrock78@drupal.org	25
71165ADJK	Marybelle Matteuzzi	F	1975-09-13	336-999-7005	5558955936	mmatteuzzi79@blog.com	28
61961BNWO	Ekaterina Brownsill	F	1983-09-22	572-896-4291	7259983172	ebrownsill7a@zimbio.com	36
79506QNVR	Massimo Pfeiffer	M	1949-08-02	240-994-1586	9343371785	mpfeiffer7b@google.pl	38
70982PIUM	Luciana Lambie	F	1967-03-16	496-711-5268	7728518330	llambie7c@wp.com	39
21241CENG	Seumas Meale	M	1979-02-14	977-627-1610	\N	\N	40
17136ELGN	Benni Skerme	F	1997-04-07	566-154-2122	1517337314	bskerme7e@alexa.com	45
63785XOAR	Alonso Tommen	M	1993-03-22	778-307-6707	1281193095	atommen7f@webmd.com	48
60305DOQS	Roxy McGaughie	F	2002-12-06	368-827-7900	3375271331	rmcgaughie7g@aboutads.info	50
57042LJVM	Demetris Trowbridge	M	1955-10-04	109-329-4865	5604134266	dtrowbridge7h@webmd.com	51
39505HHYG	Hildy Mizzen	F	1989-08-31	117-610-8852	7508975448	hmizzen7i@nhs.uk	52
46386XMYL	Anatollo Pardon	M	1986-04-17	449-250-0558	\N	\N	56
99566JOFM	Wallas Mouat	M	1994-12-31	658-548-9279	3092789819	wmouat7k@over-blog.com	58
78232DVOC	Lexy Matevushev	F	1986-01-25	628-533-0253	7374076384	lmatevushev7l@barnesandnoble.com	59
63920BTFS	Adelina Donovin	F	1963-03-04	315-361-9840	8634019147	adonovin7m@soup.io	61
22979ZPMU	Anestassia Scrauniage	F	1947-05-04	865-232-8729	2712328982	ascrauniage7n@go.com	62
45963BTGS	Myranda Shyre	F	1980-01-05	863-593-8351	\N	\N	67
91031YVBD	Salome Birkenhead	F	1988-05-29	919-336-4006	5346660801	sbirkenhead7p@pinterest.com	73
76743DMGG	Lilia Mackiewicz	F	1947-05-10	278-746-2272	8626672858	lmackiewicz7q@unicef.org	74
79531SQST	Donnie De Paoli	F	1961-09-12	215-885-8183	6606255178	dde7r@infoseek.co.jp	75
94914KLGC	Nicolea Creffeild	F	1957-10-20	691-324-0608	7761278200	ncreffeild7s@icq.com	76
74014HHPE	Marieann Mosson	F	1977-03-08	863-630-1713	\N	\N	78
33111FIVL	Kermit Sheards	M	1968-11-06	836-592-1789	9792092035	ksheards7u@sbwire.com	79
85805GHFL	Carroll McKeever	M	1981-06-10	851-537-0130	7918619659	cmckeever7v@discovery.com	81
72654HUSA	Daryle Rafe	M	1948-05-28	746-638-5043	3198844760	drafe7w@linkedin.com	83
27025MYJS	Antonie Dyhouse	F	1951-09-03	341-272-0864	9414312068	adyhouse7x@phpbb.com	87
40695OWQR	Sholom McGrill	M	1945-11-16	517-825-6173	8143993451	smcgrill7y@foxnews.com	93
79893GQEE	Curtice Easun	M	1956-07-28	504-398-4198	9142665859	ceasun7z@pbs.org	95
78225BDOQ	Brad Mellodey	M	1991-10-28	753-261-9077	9481949145	bmellodey80@cam.ac.uk	96
75753QQCE	Felix Straneo	M	1999-03-29	751-869-8684	6029632270	fstraneo81@narod.ru	97
49941YHBD	Gaby Rayner	F	1989-10-28	655-467-0696	1468325667	grayner82@wired.com	100
35764FOIB	Jeremias O'Sheerin	M	1992-07-21	991-432-2913	5086807114	josheerin83@yellowbook.com	101
22761GKIH	Owen McCosh	M	1973-08-16	987-447-6669	5341840464	omccosh84@domainmarket.com	108
19131ZQOE	Eydie Probet	F	1980-04-23	607-978-9104	7488329001	eprobet85@diigo.com	109
70413RVBO	Marybeth Negro	F	1978-06-27	293-260-2240	3053662394	mnegro86@smh.com.au	111
53911OCJM	Harry Spendley	M	1989-08-23	636-359-6328	\N	\N	114
62475MAXH	Kassey Barclay	F	1959-07-04	922-357-3350	2986818266	kbarclay88@msu.edu	115
49482IBZH	Maryanne Dowdall	F	1959-07-12	623-678-5947	7473138700	mdowdall89@over-blog.com	117
98217TVPW	Sargent Simoncello	M	1990-10-20	868-784-8520	\N	\N	118
27947XAKE	Brynn Drinnan	F	1983-09-09	419-940-9925	8072207182	bdrinnan8b@cpanel.net	119
07678YBBR	Hodge Haglington	M	1970-04-15	136-933-2502	6498164320	hhaglington8c@yelp.com	120
13604VPXT	Edd McAlpine	M	1981-04-14	808-344-4511	3198063726	emcalpine8d@blogspot.com	121
83780RTBV	Ugo Mellor	M	1952-04-17	202-333-3182	2406920918	umellor8e@delicious.com	124
91946CVVN	Vasili Hawkswood	M	1990-10-20	149-186-7471	9119918840	vhawkswood8f@delicious.com	127
86195RUXM	Bowie Manifould	M	1969-05-05	638-350-5347	4659756833	bmanifould8g@nationalgeographic.com	128
38502VNJP	Rice McOwan	M	1961-02-26	875-543-1963	4135231401	rmcowan8h@pinterest.com	130
73298ITQO	Rutledge Raeside	M	2000-09-23	306-525-5524	9871482648	rraeside8i@vk.com	139
42118POCR	Maximilianus McDougald	M	1970-08-13	376-454-9785	7459532889	mmcdougald8j@artisteer.com	143
14386YXAV	Veronika Mullan	F	1999-01-07	907-534-1476	\N	\N	146
59784RNYP	Cornelia Leif	F	1962-08-11	891-450-0708	7482375086	cleif8l@e-recht24.de	150
79150WKYZ	Renie Twort	F	1976-12-04	652-530-5782	7812198517	rtwort8m@constantcontact.com	151
77966JEXX	Zebadiah Althrope	M	1955-05-23	710-317-7329	1841537966	zalthrope8n@narod.ru	158
01892JAZK	Roy Tesche	M	1996-03-06	399-517-8448	3874480830	rtesche8o@mapy.cz	163
64642EJWA	Rozanne Pittoli	F	1960-12-02	644-366-9012	6566103667	rpittoli8p@nasa.gov	167
61686XOZR	Helaine Ascrofte	F	1972-06-27	921-669-2092	8451943127	hascrofte8q@twitter.com	169
08379QHHT	Josee Henken	F	1959-03-03	857-251-2427	8138367458	jhenken8r@icq.com	172
37189JWSC	Uriah Wehden	M	1984-05-12	845-776-5510	4098965848	uwehden8s@geocities.jp	174
06045QDAB	Kent Siehard	M	1955-02-15	440-909-5665	6135768821	ksiehard8t@bizjournals.com	176
22013BSGT	Wake Towriss	M	1963-01-23	194-887-2123	\N	\N	177
16533LUQD	Kaspar Winstone	M	1968-06-01	483-190-7366	\N	\N	178
72000REJR	Vlad Perl	M	1994-01-03	552-936-0208	8133703077	vperl8w@macromedia.com	179
41342DTQK	Flor Morbey	F	1989-01-24	298-957-8900	2442244482	fmorbey8x@goo.ne.jp	183
48995ZQLU	Shoshanna Hadkins	F	1969-11-12	420-160-3106	1245044814	shadkins8y@privacy.gov.au	184
27906MKXX	Peadar Benoiton	M	1968-08-28	546-296-0403	5776762700	pbenoiton8z@amazonaws.com	186
79909AJWD	Agnese Tomas	F	1962-01-22	922-584-1949	7099497794	atomas90@phpbb.com	187
24382ZEWD	Wenda Oxbury	F	1983-04-04	990-923-4349	6588814270	woxbury91@earthlink.net	191
89297YLLV	Leonore Edrich	F	1969-03-27	521-872-3432	4404899896	ledrich92@deliciousdays.com	192
73119SFAZ	Ritchie McCallum	M	2002-04-05	136-280-3985	9124841247	rmccallum93@psu.edu	198
41769PMVP	Deane Brick	F	1957-01-17	689-742-5160	9624962323	dbrick94@buzzfeed.com	199
71963UHFJ	Allayne Simonnin	M	1958-07-27	160-817-0350	6757445985	asimonnin95@theglobeandmail.com	203
98938KVEI	Humfrey Pyser	M	1946-02-15	220-835-6523	4106523228	hpyser96@whitehouse.gov	204
86417VRYN	Finlay Risbridge	M	1977-01-21	640-210-5658	4959160631	frisbridge97@imdb.com	205
92182ENKE	Marietta Wakerley	F	1972-12-22	509-605-7085	2482750644	mwakerley98@bloomberg.com	210
33295ENRL	Friedrich Rogeon	M	1959-11-16	575-345-0242	1721342285	frogeon99@istockphoto.com	211
36152KTBO	Cosetta Lilley	F	2002-01-04	298-780-6395	6634565342	clilley9a@harvard.edu	215
93970GSUK	Kaspar Northey	M	1965-03-12	684-269-4939	6784205207	knorthey9b@barnesandnoble.com	216
67785BHOR	Duff Pope	M	1963-06-15	143-915-0907	8289749454	dpope9c@wp.com	217
71356WULP	Jordan Schubuser	F	1961-03-01	264-786-6734	4152209028	jschubuser9d@networkadvertising.org	220
80933IALO	Ermentrude Etheridge	F	1978-12-31	542-696-5239	1416259605	eetheridge9e@wordpress.com	221
87693PSWS	Oriana O'Cullinane	F	1954-03-31	295-865-8479	7136679169	oocullinane9f@microsoft.com	222
24249VLWZ	Shaine Battell	M	1990-04-13	120-144-3471	\N	\N	223
21183BRWB	Nerte Balf	F	1954-01-26	143-586-5261	\N	\N	225
64059ERGP	Zahara Ianelli	F	1979-12-20	984-472-1286	3898773298	zianelli9i@mail.ru	230
92458NOHK	Caz Seagrove	M	1970-06-22	448-535-5265	8617796360	cseagrove9j@weebly.com	235
12223ODGO	Gretchen Hayhow	F	1959-04-23	979-606-3799	6932724193	ghayhow9k@independent.co.uk	238
31109UHKG	Gerty Trengove	F	2002-02-02	620-717-0847	9263297958	gtrengove9l@howstuffworks.com	239
83476KYQB	Josiah Kernley	M	1981-01-18	131-762-4708	3081748655	jkernley9m@gmpg.org	243
51254FNBB	Ingaberg Currom	F	1950-01-29	876-225-1507	7548554970	icurrom9n@forbes.com	244
49267ZSPV	Nigel Dent	M	1964-11-08	319-687-7633	1937350124	ndent9o@europa.eu	246
74068RRSR	Hillard Kenrick	M	1982-02-05	928-143-8627	9934603103	hkenrick9p@myspace.com	247
16165MRZT	Orsola Bearblock	F	1967-05-06	747-729-8763	2784632714	obearblock9q@cam.ac.uk	248
38571QUXX	Florina Stowgill	F	1948-05-02	919-627-8660	\N	\N	250
10794BXVF	Ines Dunnaway	F	1954-10-28	380-168-6167	7117816664	idunnaway9s@unc.edu	254
92090YNZN	Tamma Pauli	F	1953-06-22	491-542-9268	9651991629	tpauli9t@wikipedia.org	257
17258LZCK	Gustavo Barzen	M	1974-04-21	271-118-5213	6135951884	gbarzen9u@constantcontact.com	258
58562BCOI	Ginevra Stratten	F	1985-06-16	778-738-3218	5593410124	gstratten9v@microsoft.com	260
62064BFRI	Trude Mulran	F	1963-03-21	226-258-8163	1359713113	tmulran9w@free.fr	261
74971HQPL	Casey Bondley	F	1946-03-20	954-280-9856	7227708444	cbondley9x@de.vu	262
35152GBUG	Dar Kolyagin	M	1971-01-29	973-468-0944	1418166180	dkolyagin9y@edublogs.org	265
35294BLLH	Somerset Brimilcome	M	1950-10-15	755-211-3477	5238731229	sbrimilcome9z@ustream.tv	266
49378BCDG	Hermine Dauber	F	1949-03-07	273-302-3234	\N	\N	268
28192MGKN	Charlotte Finnes	F	1951-09-28	980-756-1425	1989048081	cfinnesa1@chicagotribune.com	269
36381ZRWX	Fernando Kohrsen	M	1979-12-03	709-757-9758	8411896077	fkohrsena2@bravesites.com	271
54862DTGW	Lin Fryd	F	2002-10-13	134-562-4798	1344388575	lfryda3@symantec.com	274
90979DFAD	Noah Boeter	M	2000-05-18	199-229-2892	1291580900	nboetera4@tumblr.com	277
75912KMYK	Florina Willock	F	1996-05-20	344-266-9308	6752798511	fwillocka5@shop-pro.jp	279
71087GAZM	Belle Tuxill	F	1990-10-04	392-364-0278	\N	\N	280
14909MPTF	Adeline Couch	F	1974-09-05	137-765-1782	9543697538	acoucha7@zdnet.com	281
31838UIJX	Jodee Danaher	F	1975-03-29	823-372-9769	\N	\N	283
76729GHEA	Gert Eliassen	F	1990-07-22	831-492-5460	1369736921	geliassena9@walmart.com	285
13328VDUR	Shantee Broyd	F	1996-05-05	928-529-6821	6521781348	sbroydaa@fastcompany.com	286
69603OJCH	Jody Littlechild	M	1957-12-15	820-455-8247	4702871459	jlittlechildab@nifty.com	289
35856WLHI	Dannye Sonley	F	1968-06-13	552-345-3832	\N	\N	295
92242MDAM	Jake Wickliffe	M	1994-01-31	153-153-2210	9105369352	jwickliffead@nasa.gov	298
04267MABB	Brennan Shewon	M	1970-04-12	439-983-3006	1992711136	bshewonae@surveymonkey.com	299
68393IDDG	Killy Colquite	M	1963-07-06	394-489-6310	6894768424	kcolquiteaf@nymag.com	3
92617THVH	Stephie Galer	F	1962-09-28	160-277-8147	8259243493	sgalerag@earthlink.net	4
67166SXFG	Richmond Lis	M	1972-05-19	636-820-0795	\N	\N	8
77877GJPT	Brant Wimms	M	1988-11-17	112-822-1105	6918132363	bwimmsai@mayoclinic.com	10
84566SKPN	Frederico Agglio	M	2002-04-22	215-111-5775	4891696217	fagglioaj@list-manage.com	17
12052YSZJ	Sherm Symonds	M	1969-03-21	277-255-7789	5553389787	ssymondsak@domainmarket.com	19
06235KEOC	Levon Anten	M	1972-09-30	544-931-1462	4889548218	lantenal@purevolume.com	21
17852PDWG	Sarajane Marklin	F	1971-12-28	875-959-9917	\N	\N	23
75475CRWJ	Hamlen Romi	M	1988-10-21	786-575-5791	8054642032	hromian@taobao.com	26
93608LXXP	Jilly Okenden	F	1986-03-29	394-262-6503	1472272760	jokendenao@gov.uk	28
65347UUAK	Aura O'Lennachain	F	1993-12-05	375-842-4155	\N	\N	32
42016VOVT	Layne Hadden	F	1953-04-28	517-349-3060	\N	\N	37
66928NLBI	Gar Trowsdale	M	2001-11-20	592-476-6778	\N	\N	38
91317XLNV	Franz MacNamara	M	1960-11-30	293-431-9585	2555745300	fmacnamaraas@comsenz.com	39
30442BPWA	Pauli Elflain	F	1958-07-06	232-312-3143	7605818959	pelflainat@phoca.cz	40
24934JXDV	Inglebert Given	M	1990-08-05	613-397-5731	8088994648	igivenau@topsy.com	42
14097MFUI	Jan Klaessen	M	1989-11-22	662-364-3103	6465916171	jklaessenav@nature.com	43
43353CAJU	Felizio Wellen	M	1995-05-09	246-413-6306	9141373187	fwellenaw@flickr.com	44
69044OMLF	Rosamond Lattin	F	1996-03-01	318-236-6133	4732245751	rlattinax@latimes.com	47
80104MLXD	Kiel Legerwood	M	1967-02-22	898-487-5800	4665300824	klegerwooday@sun.com	49
32940QMMN	Waylen Oats	M	1967-07-17	818-407-7327	\N	\N	53
21180MLIS	Farrell Huge	M	1961-09-29	993-536-0876	4434529268	fhugeb0@mail.ru	57
24267VKCJ	Eugenie Thaw	F	1972-09-16	399-390-8062	7147444752	ethawb1@intel.com	59
42221MBQV	Norrie Castagneri	M	1979-05-01	702-703-7809	3044034351	ncastagnerib2@rambler.ru	63
11529EDOW	Willy Hallahan	M	1975-09-27	336-346-0082	9173323575	whallahanb3@51.la	64
33863WYGL	Haydon Laskey	M	1973-06-21	476-301-2893	1336369179	hlaskeyb4@oracle.com	74
08706DXVD	Augustine Endersby	M	1983-06-02	916-185-6283	\N	\N	76
65391DZQH	Gracie Martynikhin	F	1956-05-02	300-752-5551	1855709879	gmartynikhinb6@ted.com	82
60010VKYQ	Cheslie Ambrodi	F	1996-04-04	612-240-7778	3776490152	cambrodib7@hhs.gov	86
17174PBQZ	Doralynn Newson	F	1953-10-12	829-923-2610	9492191130	dnewsonb8@nifty.com	88
91903MEYF	Hamlen Pitkaithly	M	1965-05-29	785-728-5376	7041469304	hpitkaithlyb9@hostgator.com	92
60517HNHE	Stacee Iles	F	1967-07-14	812-636-5907	9715131936	silesba@hud.gov	95
89798AEKP	Concettina Duferie	F	1963-12-17	174-710-1677	5682726831	cduferiebb@tinypic.com	98
18028AOSD	Gilbertina Coneybeare	F	1971-06-14	524-407-3755	8348401453	gconeybearebc@i2i.jp	100
40415JIZG	Linzy Godber	F	1965-07-05	700-893-1628	\N	\N	103
47102IPES	Osbourne Macconachy	M	1967-04-22	795-293-6180	4051390153	omacconachybe@yellowpages.com	104
05452KZVF	Beatrix Vardie	F	1964-12-31	939-927-3123	2643918207	bvardiebf@go.com	105
59018ZBNH	Debra Barrett	F	1954-10-29	862-278-9111	3837140101	dbarrettbg@google.com.br	107
75765WBRV	Alejandrina Hawney	F	1991-08-23	531-437-1512	6313709232	ahawneybh@paginegialle.it	108
00706NKUQ	Benetta Cotty	F	1997-12-03	166-579-4354	4254550035	bcottybi@princeton.edu	110
18795TIZU	Selina Fellis	F	2002-05-16	588-144-9660	\N	\N	112
20846UOUS	Daren Despenser	M	1950-02-15	426-692-5565	4282827118	ddespenserbk@myspace.com	116
65297YJKJ	Brendon Quye	M	1970-04-09	149-966-3138	5095777014	bquyebl@photobucket.com	118
86709GXWE	Tommie Terry	M	1960-08-07	844-606-8907	3394605722	tterrybm@biblegateway.com	119
40660VFCF	Anni Etchingham	F	1971-04-11	333-499-0060	4779149054	aetchinghambn@mapquest.com	120
73786USCX	Humfrid Gulliford	M	1946-05-02	223-178-8808	3921731242	hgullifordbo@nsw.gov.au	124
32253EPSG	Durand Kinsella	M	1993-09-01	103-485-7716	5871449700	dkinsellabp@example.com	125
32754UYPU	Fay Hugnet	F	2001-11-15	580-161-1025	\N	\N	129
05509QFZD	Jasmine Schoular	F	1963-06-14	113-263-9386	5419617083	jschoularbr@comsenz.com	133
74503LFIR	Logan Oliveras	M	1997-01-01	924-743-1794	6904638829	loliverasbs@sciencedirect.com	134
50234UJJP	Dane Lembrick	M	1956-04-25	626-451-9675	5467297183	dlembrickbt@themeforest.net	137
54817SDXS	Ignacius Causer	M	1997-01-22	647-927-6368	9715196780	icauserbu@seesaa.net	142
66526NDMX	Arnoldo Mees	M	1973-03-30	875-499-1281	\N	\N	145
47432CFIU	Ekaterina MacBain	F	1955-12-31	273-449-3582	2155238408	emacbainbw@wikimedia.org	146
75625KKVR	Pavlov Goney	M	1997-09-22	837-236-7023	2836633776	pgoneybx@dailymail.co.uk	149
67909JLHM	Sayers Goldthorp	M	1972-01-22	324-835-0011	\N	\N	151
85473GDTY	Tabbitha Ludlom	F	1955-04-03	401-223-7781	\N	\N	154
39511HCTU	Kirby Gallop	F	1995-03-25	578-254-2810	2206778821	kgallopc0@163.com	155
70689ZNHG	Stewart Goadbie	M	2000-01-19	478-970-1181	1269332574	sgoadbiec1@slideshare.net	156
25514HPSV	Zerk Duggan	M	1986-02-15	787-496-1538	1157514094	zdugganc2@purevolume.com	157
14418TTXO	Grover Barrack	M	1981-08-25	974-483-6033	2343605678	gbarrackc3@chronoengine.com	162
61157TFCR	Mindy Pitone	F	1950-12-16	618-203-4351	7366611233	mpitonec4@umn.edu	163
34132MNFY	Giselbert Geddes	M	1947-04-01	210-785-4033	\N	\N	164
05849VUYI	Florence Greenman	F	1958-11-08	111-774-0868	4898046272	fgreenmanc6@nifty.com	170
98684VUGE	Marinna Thebeau	F	1989-03-23	862-556-4753	4845270366	mthebeauc7@myspace.com	171
69840JNYI	Sharona Greenall	F	1957-01-19	271-155-3727	3261877440	sgreenallc8@nature.com	172
76799FDBM	Reyna Lomasna	F	1989-06-04	938-782-0631	7265504132	rlomasnac9@edublogs.org	173
57556RHBE	Papageno Chong	M	1979-06-27	253-386-5166	9607272054	pchongca@google.co.jp	174
91537KHUN	Joey Fellgate	F	1957-05-19	252-506-8254	\N	\N	178
44973TZBB	Adrian Bartle	M	1959-01-08	649-858-3427	\N	\N	180
13284NKZQ	Gideon Whybrow	M	1957-01-25	740-474-9788	1292203479	gwhybrowcd@statcounter.com	182
80033CTYE	Marthena Golden	F	1957-07-02	318-203-3358	\N	\N	184
78321KMMD	Franklin Kik	M	1965-02-26	475-609-6595	7718617439	fkikcf@yale.edu	185
67035FYSY	Adriena Elington	F	1973-02-21	927-405-5625	8041972600	aelingtoncg@alexa.com	189
45414DCHL	Meggi Cancelier	F	1953-10-10	314-785-3178	6035360042	mcancelierch@wikispaces.com	192
81121SPUE	Antonella McGuff	F	1996-09-03	428-136-6180	1338266501	amcguffci@redcross.org	197
91586RDOZ	Ashleigh Medgewick	F	2002-09-13	120-685-8365	3521500023	amedgewickcj@psu.edu	202
90735VTFB	Karen Raw	F	1981-07-11	219-634-8870	2393292607	krawck@ft.com	206
36525JUMP	Ettie Tolman	F	1954-09-11	228-427-3704	1529365655	etolmancl@si.edu	207
43234SWYH	Darice Narraway	F	1956-10-20	773-580-8498	2224462205	dnarrawaycm@umn.edu	214
10062UZEF	Harriott Balffye	F	1946-02-01	966-764-8683	\N	\N	218
13355FUXD	Rennie Teece	F	1991-04-28	103-958-4013	\N	\N	220
35147PDQU	Tammy Towers	F	1957-01-08	177-979-1170	3953606953	ttowerscp@istockphoto.com	222
11842GRNS	Claudell Damant	M	2002-07-18	248-366-7067	\N	\N	224
71473PUDQ	Thurstan Ellcome	M	1946-10-16	790-840-5489	3159521069	tellcomecr@omniture.com	226
92913YELB	Guendolen Edmundson	F	1950-09-13	737-169-0915	9843820127	gedmundsoncs@facebook.com	227
16545VOVI	Harwilll Cromblehome	M	1946-04-12	262-468-1206	7901204282	hcromblehomect@i2i.jp	228
56332BQBY	Kirbie Speachley	F	1972-02-12	644-964-3687	9873907949	kspeachleycu@ucoz.ru	231
63748DVZQ	Boycie D'Acth	M	1980-06-24	404-911-2285	8577131027	bdacthcv@mail.ru	235
21785ILWG	Sharon McGlade	F	1967-04-24	904-512-6509	\N	\N	236
22877XGCU	Korey Branwhite	M	1954-04-24	287-714-9582	\N	\N	237
01125SOUH	Marthena McCarver	F	1968-11-19	177-107-5687	4339582785	mmccarvercy@geocities.com	239
18059QSOI	Brenn Rollins	F	1985-04-19	262-939-0025	7961819520	brollinscz@uol.com.br	241
20732GZMN	Toni Carlett	F	1988-01-17	518-823-7188	8584941565	tcarlettd0@yahoo.co.jp	242
83623BVPB	Cristobal Shout	M	1990-10-06	635-219-9128	\N	\N	244
88584SXGB	Sammy Goodbourn	F	1955-05-03	951-737-0222	3033613069	sgoodbournd2@imgur.com	247
50907BHPV	Hedwiga Joseff	F	1981-11-25	668-141-5109	\N	\N	248
97005ILMC	Korella Machen	F	1950-03-15	128-787-8579	3964487744	kmachend4@eventbrite.com	250
17733LXVO	Genvieve Danzey	F	1977-08-06	243-826-9792	7145290440	gdanzeyd5@smugmug.com	251
27807CGBG	Waite Bertenshaw	M	1987-01-30	371-285-7176	8561659746	wbertenshawd6@alexa.com	252
67495MQIL	Chelsea Duncanson	F	1975-01-06	517-270-6335	7433940775	cduncansond7@jiathis.com	254
19852JHLO	Shirley Gerald	F	1974-08-23	422-605-4918	5438105410	sgeraldd8@auda.org.au	255
15994QOWO	Bren Meeron	F	1971-11-19	188-376-0104	8888087670	bmeerond9@springer.com	261
15373BFZL	Rene McMakin	F	1993-01-06	593-724-8239	2349798861	rmcmakinda@prweb.com	262
59756GUIC	Sammy Guiden	M	1961-03-01	708-287-1807	7953904209	sguidendb@squarespace.com	263
56053UXNB	Addison Braksper	M	2001-08-18	635-297-0345	9334936089	abraksperdc@soundcloud.com	265
18965JBUY	Barbabas Darte	M	1980-12-24	776-809-8770	9539610538	bdartedd@admin.ch	266
07374MACA	Lavena Martini	F	1949-12-02	585-869-1776	9534548394	lmartinide@mlb.com	268
87246VINN	Jaimie Venturoli	M	1946-12-05	661-912-4852	7386752138	jventurolidf@privacy.gov.au	270
58552RINX	Sharl Melburg	F	2002-06-18	943-879-0511	\N	\N	271
01358ZZJA	Englebert List	M	1995-07-04	370-688-1041	\N	\N	273
53208IZFO	Boigie Lampel	M	1989-08-25	144-897-4395	2669482358	blampeldi@booking.com	274
88468YEHS	Eduino McIlvenna	M	1953-08-06	704-410-4842	6435648328	emcilvennadj@tuttocitta.it	276
23561ACGZ	Daniele Berthomier	F	1998-03-25	784-282-1945	4887613991	dberthomierdk@tumblr.com	277
61630BSFH	Bradan Moseby	M	1998-05-07	137-694-7600	3087481403	bmosebydl@phoca.cz	278
17984IZAD	Hortense Klezmski	F	1988-03-25	236-844-4372	2623508684	hklezmskidm@miibeian.gov.cn	279
06062OWPW	Teddie Saywood	M	1951-02-27	495-188-5616	6725357105	tsaywooddn@is.gd	281
77619IJAR	Robinet Baglow	F	2002-03-05	260-562-1284	3039309118	rbaglowdo@boston.com	282
04240BZAT	Melesa Hekkert	F	1981-09-07	942-962-1615	3166225886	mhekkertdp@yolasite.com	283
08040VBRE	Barby Hayselden	F	1992-03-03	361-682-5046	\N	\N	286
27815DPZN	Shepard Pyett	M	2002-01-23	632-365-2084	6117091505	spyettdr@paypal.com	289
58426RDSE	Luisa Rubi	F	1953-12-29	198-217-1123	\N	\N	292
52616VMJG	Tobin Durrans	M	1949-01-10	995-912-3098	6832076916	tdurransdt@printfriendly.com	296
30692HSAJ	Natalie Aldwick	F	1954-04-18	111-748-9590	2072370045	naldwickdu@scribd.com	298
81666WEGO	Isaiah Le Monnier	M	1976-01-14	968-725-1479	\N	\N	299
29605WYLT	Cesaro Provost	M	1950-06-30	524-755-8858	7665611000	cprovostdw@bloomberg.com	1
84711WKXD	Randie Clitherow	F	1956-06-02	982-110-3019	5041582544	rclitherowdx@shutterfly.com	2
37150JPSX	Corrie Hum	M	1988-07-19	609-269-3537	3866355859	chumdy@shareasale.com	5
34717FCAB	Billy Bigland	M	1994-11-11	455-407-2956	5042609735	bbiglanddz@pbs.org	6
12019CTEK	Ezekiel Keyser	M	1985-09-25	886-381-5155	\N	\N	7
41953OCVC	Nikita Reymers	M	1971-09-10	997-512-4872	4367226154	nreymerse1@delicious.com	11
90522YFGU	Dean Ellett	M	1958-04-08	417-725-3845	9948029567	dellette2@sfgate.com	14
54609YWHB	Giavani Duddell	M	1967-02-12	238-789-4843	5476611382	gduddelle3@friendfeed.com	19
02626VQXG	Charles McMains	M	1949-06-09	136-696-2013	1574193857	cmcmainse4@shop-pro.jp	22
16656CZKM	Celina Burkwood	F	1995-02-08	745-855-9564	4325113830	cburkwoode5@wunderground.com	25
86406BBKJ	Felice De Leek	M	1945-08-04	683-230-6825	6412208122	fdee6@surveymonkey.com	26
44197WLWG	Gav Fortnon	M	1964-03-27	626-983-7924	9281695902	gfortnone7@hud.gov	27
60543UOVL	Hester Brittian	F	1996-02-05	693-525-4935	8162462800	hbrittiane8@ucoz.com	32
98331KMKF	Chelsey Trusty	F	1988-02-01	865-741-3365	6873824904	ctrustye9@lulu.com	33
32013LLYG	Akim Perott	M	1957-12-28	624-134-0508	4078460849	aperottea@twitter.com	34
18627EFGZ	Enrica Silverston	F	1977-03-09	858-942-7630	9786641245	esilverstoneb@answers.com	37
32998CXLA	Lisa Gumbrell	F	1991-07-05	840-489-1456	5015843884	lgumbrellec@gnu.org	45
92641GDKM	Allison Schrader	F	1984-02-28	730-292-8606	\N	\N	47
56806CTUU	Ronnie Desson	M	1962-05-29	631-874-9580	5931674118	rdessonee@upenn.edu	48
14637WOMC	Eleni Cawthorn	F	1979-08-17	682-260-0966	7239279903	ecawthornef@vimeo.com	49
10437ZZXR	Arliene Luttger	F	1952-11-14	742-136-1234	\N	\N	50
42060CLIH	Engelbert Wroe	M	1947-10-11	571-982-7937	8188907428	ewroeeh@indiatimes.com	52
34519ZLVI	Brina Johnston	F	1986-11-23	365-401-5654	9615054523	bjohnstonei@dell.com	63
74750XHNX	Desi Pengelley	M	1946-05-20	759-521-1217	\N	\N	66
60765OOCN	Eartha Dwelly	F	1948-01-03	181-478-8580	8179413566	edwellyek@economist.com	67
69348BZYU	Mechelle Jadczak	F	1947-02-09	979-613-7452	7851854515	mjadczakel@163.com	69
11361HBJR	Bartholomew Franscioni	M	1966-07-27	517-317-8225	6108169877	bfranscioniem@is.gd	71
06318AZBM	Ferdy MacShane	M	1976-09-23	825-790-1616	5197168874	fmacshaneen@w3.org	72
34884AXTV	Syd Kirke	M	1982-10-18	409-341-4649	9554866865	skirkeeo@nymag.com	73
08900KZIM	Nealson Banstead	M	1960-02-01	805-243-7105	4881835074	nbansteadep@dyndns.org	75
69634FPSC	Melvin Whitloe	M	1954-04-03	784-531-7301	\N	\N	76
48077BSBZ	Perrine Longshaw	F	1994-04-22	178-299-8092	\N	\N	79
52321NNZX	Patti Longfut	F	1984-01-09	531-256-7282	\N	\N	81
09779GLJA	Abdul Shelliday	M	1977-06-19	688-712-6144	3465394569	ashellidayet@cyberchimps.com	90
99116OLPW	Atalanta Carriage	F	2001-02-10	869-422-1170	8754575311	acarriageeu@gravatar.com	92
62592AIEC	Susann Denisot	F	1947-09-22	968-154-4171	9255328482	sdenisotev@jimdo.com	94
07443TZSO	Normand Cousens	M	1987-07-04	633-641-5014	4696883879	ncousensew@tamu.edu	95
49174BVUI	Raina Burgum	F	1964-05-28	930-172-9348	8147392163	rburgumex@merriam-webster.com	101
83625YNJH	Min Bowshire	F	1949-03-23	656-757-9675	9795870505	mbowshireey@com.com	102
68798KKAM	Mozelle Myring	F	1991-02-14	106-287-1348	4045411153	mmyringez@hp.com	103
76461UMTY	Cleo Pittham	F	1975-04-18	157-978-6977	8912554408	cpitthamf0@domainmarket.com	105
52989XPME	Leda Bysouth	F	1952-03-15	770-767-3240	\N	\N	106
92698QZCK	Cordie Ridgewell	M	1997-05-24	728-954-8584	4902037205	cridgewellf2@apache.org	107
44251WUVD	Meryl Trowel	M	1968-12-07	303-203-8389	9315660470	mtrowelf3@who.int	109
20212UDXQ	Barbee Vanyutin	F	1987-09-12	699-184-5597	8308062478	bvanyutinf4@microsoft.com	113
50803IVEB	Christye McLane	F	1949-11-29	802-748-0686	9039353460	cmclanef5@oaic.gov.au	114
52043ANNH	Germain Kniveton	M	1992-08-23	725-974-8910	\N	\N	117
10525GGAI	Allina Tremoulet	F	1948-10-23	990-642-1575	6097370215	atremouletf7@csmonitor.com	118
18763LFJL	Fred Goakes	F	1983-07-27	934-431-8965	4996888879	fgoakesf8@ustream.tv	120
86891MVQK	Giorgia McWhin	F	1963-11-17	634-190-9651	8967530276	gmcwhinf9@upenn.edu	124
03148EOSW	Madlen Grumbridge	F	1978-04-01	358-139-7069	3566453255	mgrumbridgefa@flavors.me	127
71930XNLT	Julie Halworth	F	2000-08-07	383-891-0585	4037063600	jhalworthfb@cisco.com	128
10245GVTM	Redd Fordy	M	1953-09-13	903-772-8796	3834826692	rfordyfc@pinterest.com	132
31063IEZS	Monte Stilldale	M	1947-05-10	714-462-5021	7964258807	mstilldalefd@hc360.com	134
34466XMBF	Barnabe Mainstone	M	1999-07-02	283-231-0418	8745298067	bmainstonefe@dion.ne.jp	135
56623PRAZ	Alfreda O'Bradden	F	1958-09-24	403-345-2792	\N	\N	141
34345BEPJ	Jeri Aron	F	1993-04-12	756-131-8266	6648898757	jaronfg@icio.us	142
53460GGXY	Sonnie Crate	M	1948-04-30	152-127-0426	6064288666	scratefh@oracle.com	144
18300BWXP	Gram Strathern	M	1988-07-28	222-435-0318	8519933931	gstrathernfi@zimbio.com	146
72697FPIQ	Tommy Pietri	F	1983-08-14	168-526-6209	6683070576	tpietrifj@narod.ru	151
66075CYTI	Fitz Eastam	M	1970-04-28	159-657-3522	\N	\N	155
44848KAKI	Karin Lewsley	F	1995-03-07	684-729-1186	\N	\N	156
77754OEIF	Aurore Mullane	F	1980-02-21	965-118-9855	4498641356	amullanefm@clickbank.net	157
67383VPQR	Roxanna Carty	F	1995-02-05	549-500-2668	\N	\N	161
22141QCKU	Terrell Wenban	M	1994-03-22	116-529-8878	\N	\N	163
00015ADTC	Wakefield Gready	M	1992-12-25	171-674-1738	\N	\N	164
90149WBJE	Westbrooke Easen	M	1968-09-07	715-820-6776	1179218605	weasenfq@live.com	167
38152MZFC	Aubree McArd	F	1947-07-25	894-976-8711	2945465665	amcardfr@hugedomains.com	169
23879KMVM	Isabelle Janatka	F	1946-12-27	448-562-4197	\N	\N	174
64550WPIX	Christoffer Domenget	M	1971-09-15	332-476-2102	1427029068	cdomengetft@nhs.uk	175
62601MBWE	Arley Vanyarkin	M	1974-03-28	878-624-3493	\N	\N	177
66651RBDL	Alanah Carncross	F	1983-04-10	688-787-6602	9134680993	acarncrossfv@skyrock.com	178
33474RLKN	Kennett Tidball	M	1977-08-05	853-685-6164	1277120555	ktidballfw@businesswire.com	181
49685YWOP	Bard Tittershill	M	1980-01-26	537-350-3293	2678925919	btittershillfx@networksolutions.com	182
78183NMUG	Muire Wassung	F	1983-09-26	144-854-7283	\N	\N	183
81509FCNC	Heall Battrum	M	1990-07-28	707-637-8661	9275836193	hbattrumfz@reuters.com	187
52984QILZ	Valli Anthes	F	2002-03-19	863-680-7971	\N	\N	192
82274CQNR	Javier Minchinden	M	1961-10-14	507-275-4734	3946030885	jminchindeng1@timesonline.co.uk	193
54518IWZD	Lion Bonsall	M	1950-01-25	881-977-6128	6724552500	lbonsallg2@google.com.au	201
78074IHEV	Herbie Cunney	M	1993-07-08	947-376-0606	7021464278	hcunneyg3@e-recht24.de	205
03273DPNA	Agnola Lindop	F	2001-03-09	600-933-2337	3458063266	alindopg4@google.nl	206
18045IMZW	Nancey Trousdell	F	1997-04-03	142-309-5721	4238449215	ntrousdellg5@google.co.jp	210
18706XVBQ	Winona Troctor	F	1996-08-28	441-738-2377	3431821902	wtroctorg6@reverbnation.com	211
22025NSNZ	Hestia Constantine	F	1993-09-20	651-752-4543	\N	\N	213
22085IGFQ	Winnie Basill	M	1964-03-06	868-292-2213	6033136840	wbasillg8@bbb.org	214
77407FJST	Allene Dilley	F	1984-11-19	488-108-3768	7914664664	adilleyg9@digg.com	216
75192SVFI	Jarid Dewett	M	1978-05-25	923-500-1390	3442624745	jdewettga@csmonitor.com	220
45317CFBF	Bryce Cornehl	M	2000-04-29	923-679-3746	7483364852	bcornehlgb@unblog.fr	221
91122IOKT	Gwyn Oldroyde	F	1971-05-31	399-540-8510	5899553076	goldroydegc@miitbeian.gov.cn	224
90903ETEK	Chery Twizell	F	1970-07-16	816-683-1416	\N	\N	225
81194JQNX	Athene Laverack	F	1968-03-23	885-214-4768	9407277865	alaverackge@weibo.com	227
17693KREQ	Lian Tomczykiewicz	F	1974-01-10	416-687-4172	7609437329	ltomczykiewiczgf@msn.com	231
60423WJTM	Grove Rosenblath	M	1959-08-11	665-802-1885	3147503556	grosenblathgg@sakura.ne.jp	234
02326QGAF	Veronica Giacobo	F	1950-05-04	930-638-9530	7922361672	vgiacobogh@abc.net.au	240
09809SNJP	Vanni Brittan	F	2003-05-13	705-969-6815	2394651073	vbrittangi@smugmug.com	241
06463NIUU	Emmy Maxwaile	F	2002-12-07	962-375-1884	2904107948	emaxwailegj@lulu.com	249
89252VTQU	Sharon Youens	F	1955-09-10	681-384-9706	5768852222	syouensgk@amazonaws.com	255
95141DYBF	Tucky Willavoys	M	1978-06-20	172-390-8952	\N	\N	256
18549HRNA	Trenna Bedham	F	1959-07-22	192-837-0029	5324459148	tbedhamgm@msu.edu	259
55240DULH	Madella Cloute	F	1988-08-22	292-433-1706	3035607246	mcloutegn@arizona.edu	261
27477OXBC	Nicola Schrinel	M	1989-03-13	127-697-3190	9926048792	nschrinelgo@qq.com	263
59456UOWP	Clerissa Jindracek	F	1996-05-13	451-595-8248	3011549374	cjindracekgp@seesaa.net	267
17742VPCJ	Hewett Sibylla	M	1949-10-04	275-457-8986	4506303588	hsibyllagq@twitpic.com	272
77672WPBN	Read Kenvin	M	1977-10-30	318-786-1751	\N	\N	274
49070ZEMP	Dorette Gouldeby	F	1979-02-17	199-268-7819	\N	\N	281
55635LAXB	Fletcher Inseal	M	1988-04-16	592-904-5055	5103238361	finsealgt@cafepress.com	283
96286JHVL	Nancie Dredge	F	1994-07-05	698-639-6740	7767767608	ndredgegu@biblegateway.com	285
50825XDFH	Madlen Grouvel	F	1981-12-03	537-394-0294	\N	\N	290
24808DTTP	Aleksandr Innerstone	M	1959-09-17	955-472-2009	8301373542	ainnerstonegw@ebay.co.uk	300
26525GPLN	Angelle Robinson	F	1980-05-17	370-420-6524	7661301617	arobinsongx@webeden.co.uk	301
55045YXSQ	Noby Vasyutochkin	M	1966-07-26	564-337-7900	2804498203	nvasyutochkingy@blinklist.com	306
69886NIKU	Cherri Pieter	F	1976-07-12	206-491-7799	7639498193	cpietergz@ed.gov	307
82641OVIC	Aaren Leftbridge	F	1969-08-26	248-836-1533	7513766069	aleftbridgeh0@statcounter.com	309
42155EPST	Valida Miklem	F	1973-06-17	480-315-3319	9965055618	vmiklemh1@ow.ly	310
86667EVRQ	Mannie Heinl	M	1947-10-05	316-172-4656	3529162887	mheinlh2@dell.com	311
79746WEKE	Jeane Mullender	F	1961-12-23	365-813-8245	9178963997	jmullenderh3@ed.gov	312
48219SZCJ	Bobbie Legate	F	1946-09-23	269-784-6999	8525495236	blegateh4@nifty.com	313
21357VSMC	Tarrance Rockwill	M	1998-04-09	110-851-6847	8348599802	trockwillh5@flavors.me	322
19976MHMT	Stacy Ramet	M	1961-02-17	638-501-5730	5129626536	srameth6@soup.io	327
77906SABA	Anabelle Biasioni	F	1980-11-26	225-145-1361	5657915762	abiasionih7@people.com.cn	328
83763QXNP	Colas Templar	M	1981-10-11	824-706-0578	1353111029	ctemplarh8@1688.com	332
00976VFNW	Clarine Jindracek	F	1970-04-11	987-294-5403	6822747374	cjindracekh9@whitehouse.gov	334
74888NUMN	Yevette Farnes	F	1976-09-07	945-483-1568	9783901565	yfarnesha@adobe.com	335
20654PUCB	Tasha Inman	F	1971-05-21	492-595-4960	8544361435	tinmanhb@google.it	340
01532MPUA	Isiahi Hartrick	M	1986-10-10	538-608-1210	\N	\N	343
24153FJPK	Orbadiah Lacasa	M	1988-05-25	345-969-3603	5738205033	olacasahd@typepad.com	1
46792MFNV	Ansell Eyton	M	1992-02-17	899-577-4587	\N	\N	2
98825TXTS	Torey De Vere	F	1976-03-26	989-256-8725	7189528788	tdehf@java.com	4
70579IBJO	Herschel Cheers	M	1994-05-11	584-803-4482	\N	\N	5
05720EUIX	Wakefield Mertel	M	1989-04-20	144-993-3000	8817456613	wmertelhh@homestead.com	6
09611UZOR	Valaria Assender	F	1975-05-27	866-603-9776	5098120653	vassenderhi@scientificamerican.com	8
18265CRQR	Sonny Birkwood	F	1947-08-02	487-109-2101	\N	\N	10
87647XBBV	Daryn Milillo	F	1992-09-13	701-769-2585	3148068825	dmilillohk@shinystat.com	13
75999BOIV	Allina Dawidman	F	1967-06-29	581-134-4435	6906472913	adawidmanhl@addthis.com	16
89538LESS	Lucina Valentin	F	1977-04-21	657-705-8435	1446452645	lvalentinhm@wikia.com	17
66858UWDV	Meade Akaster	M	1963-10-18	120-179-9304	7959944491	makasterhn@symantec.com	18
92938SGDZ	Marcia Peoples	F	1949-11-19	748-868-1568	7381724186	mpeoplesho@google.ca	27
11001AOBW	Moore Roney	M	1995-12-05	957-889-6435	1485412201	mroneyhp@ycombinator.com	33
85637ZOIU	Guy Klimashevich	M	1999-10-30	927-711-4779	5235542104	gklimashevichhq@mapy.cz	34
19725IPCA	Dolores Giberd	F	1981-07-24	966-748-4071	3611088391	dgiberdhr@acquirethisname.com	36
46914JBYX	Winona Sainsbury	F	1961-05-06	244-226-4505	1133736479	wsainsburyhs@prlog.org	37
91330BWSI	Wiley Shemilt	M	1971-02-26	844-918-3768	\N	\N	38
58943OTIJ	Humfrey Cesaric	M	1993-10-08	214-669-4401	2193360219	hcesarichu@twitter.com	47
31170LUSD	Delmor Luard	M	1958-03-29	813-238-0756	8278115273	dluardhv@privacy.gov.au	48
79956DZYL	Dwayne Keetch	M	1972-01-31	463-851-8813	4395415294	dkeetchhw@cafepress.com	50
18665VCPT	Lane Wonfar	F	1970-11-30	336-490-7083	8818789187	lwonfarhx@histats.com	52
63200JNWF	Sibbie Dyott	F	1950-08-30	342-368-4960	3154434649	sdyotthy@posterous.com	55
63138LMZE	Jourdain Domerque	M	1954-09-05	518-743-1044	\N	\N	56
67180RNGX	Pail Rennocks	M	1960-10-07	371-938-6972	6313893468	prennocksi0@artisteer.com	57
22213YECD	Vida Willatt	F	1972-08-16	456-302-3771	6267934969	vwillatti1@1und1.de	58
42077OGNW	Hilarius Waiton	M	1990-10-02	398-458-6471	\N	\N	60
54256LAXJ	Percy O'Gormley	M	1983-09-17	348-194-9217	8303375437	pogormleyi3@discuz.net	63
17929EZPD	Ricca Jezard	F	1963-08-13	881-348-9680	1579207609	rjezardi4@jiathis.com	66
96312KARQ	Ashlin Wadeson	M	1985-05-02	493-697-7295	8687170232	awadesoni5@sun.com	67
05727EFGZ	York Cappleman	M	1976-03-27	148-757-1085	\N	\N	70
16472VRYW	Jorge Fussell	M	1973-07-11	329-688-8939	9944112194	jfusselli7@blogspot.com	71
97421LXZN	Doralyn Kelwaybamber	F	1973-05-10	672-860-0853	9229181889	dkelwaybamberi8@businessweek.com	72
91336NMQW	Quent Brittain	M	1952-12-28	998-219-5100	6719994380	qbrittaini9@networksolutions.com	78
41510YHLE	Lisha Tolwood	F	1981-11-22	256-797-5020	8343394581	ltolwoodia@usnews.com	80
10191TGDE	Boris McCreadie	M	1970-01-17	928-117-1841	3803260190	bmccreadieib@patch.com	81
80538UNMK	Jeannine Wilkins	F	1957-12-08	872-606-6912	7377706325	jwilkinsic@sciencedaily.com	86
19820IJRJ	Anstice Newlyn	F	1960-05-05	661-101-6506	9042092157	anewlynid@lycos.com	90
80679KROD	Lacee Holtom	F	1992-08-22	811-384-0272	\N	\N	94
24317XZLL	Adriano Lisimore	M	1998-07-14	880-858-7147	2317178499	alisimoreif@admin.ch	98
99981UASO	Verena Smallpeice	F	1945-11-16	306-452-3816	\N	\N	99
90084IIHR	Riannon Pye	F	1972-09-12	333-843-2283	6926325347	rpyeih@qq.com	100
60693ZBCX	Garvy Hale	M	1983-03-29	317-865-5931	\N	\N	101
84682YSXP	Oralie Baron	F	1950-04-01	241-217-1091	6723063880	obaronij@newyorker.com	102
60630NFSA	Marjory Linde	F	1978-02-12	396-166-9757	1343824130	mlindeik@miibeian.gov.cn	103
46826JHJW	Gloria Jorge	F	1991-08-06	854-879-3954	5129504218	gjorgeil@opensource.org	104
51302ULGF	Elwin Bourner	M	1987-06-19	828-453-0115	7492760131	ebournerim@harvard.edu	106
00947GODH	Leoine Nellis	F	1994-07-12	849-931-8696	7621259677	lnellisin@stumbleupon.com	108
03441VGRI	Blakeley Druce	F	1996-12-29	480-585-1472	7352406201	bdruceio@hud.gov	113
96642TDIH	Kayle Ingray	F	1962-12-09	514-331-0459	3058115740	kingrayip@smugmug.com	115
94949WRDC	Laurette Joskowitz	F	1953-03-01	240-437-3449	5102414272	ljoskowitziq@usda.gov	116
31743KDYQ	Elbertine Linwood	F	1989-07-08	122-350-7875	3606547663	elinwoodir@4shared.com	117
57536VFAV	Ephrayim Jayne	M	1960-09-01	100-324-0755	3755703741	ejayneis@devhub.com	120
63959SHNW	Filmore Bleasby	M	2001-05-27	532-393-3241	\N	\N	121
18562SXYE	Garwood Curado	M	1982-08-23	514-529-8854	3996324718	gcuradoiu@sogou.com	129
55692QSGY	Levi Huitson	M	1958-04-30	159-870-4968	6314449200	lhuitsoniv@home.pl	130
96217MPQO	Theresa Millins	F	1984-08-05	577-465-6857	3297241734	tmillinsiw@infoseek.co.jp	133
19487BTQH	Rufe Perring	M	1994-12-06	249-829-2305	8891987653	rperringix@un.org	135
05890UKZO	Audre Rayne	F	1989-08-31	418-568-3441	\N	\N	136
45165QNRT	Sam Domoney	F	1951-11-24	133-842-2855	3075665764	sdomoneyiz@youtube.com	137
17244TFJT	Paolina Cominoli	F	1999-12-13	785-190-0932	9042410280	pcominolij0@tamu.edu	139
91172YJAT	Skip Cuerdall	M	1992-03-16	118-864-0077	8541494780	scuerdallj1@zimbio.com	141
40225WAVA	Ruperta Skitteral	F	1962-04-30	343-231-3188	2637048986	rskitteralj2@usda.gov	143
54969UPXU	Blayne Spriggin	M	2002-12-12	189-324-1458	3458886957	bsprigginj3@cdc.gov	144
88292EDIE	Gustav Bragger	M	1974-11-16	568-151-2200	5251618070	gbraggerj4@simplemachines.org	145
64934ASGG	Michele Neeves	M	1950-06-17	309-473-5101	8866736777	mneevesj5@newsvine.com	148
69306YLBR	Calv Stanway	M	1955-02-25	883-853-9290	8838358209	cstanwayj6@google.com.au	153
65208PVDL	Henrietta Lethley	F	1990-10-11	491-324-2735	5835080482	hlethleyj7@apple.com	154
76126DMXO	Tilda Pennuzzi	F	1973-05-10	388-558-9629	8854140355	tpennuzzij8@alibaba.com	155
53124ZWJS	Andie Riccard	F	1968-07-30	755-722-7038	1232712182	ariccardj9@bing.com	156
78669GUOV	Ellen MacParlan	F	1967-10-26	482-315-5691	5703480132	emacparlanja@sfgate.com	157
20272FENQ	Coralyn Gallop	F	1995-11-27	439-708-5569	2167544913	cgallopjb@archive.org	158
31246DEGM	Denney Carley	M	1977-04-01	797-625-8764	\N	\N	160
66472KDPL	Lenette Lord	F	1982-02-21	131-263-7903	1778262028	llordjd@oakley.com	161
63770UPLY	Base Lamyman	M	1969-12-20	455-663-5785	\N	\N	165
24621MXHR	Vasili Bouts	M	1967-12-18	325-181-4724	9385887369	vboutsjf@ow.ly	170
99207UDUQ	Barnaby Turle	M	1962-09-29	997-655-3778	6483305970	bturlejg@miibeian.gov.cn	172
46968YZHS	Aldric Boughton	M	1986-11-17	652-783-3358	7965611702	aboughtonjh@hubpages.com	179
58949DPYD	Amalia Picken	F	1969-10-17	519-500-9132	8107808767	apickenji@uol.com.br	183
18279GPAI	Cecilio Charrette	M	1990-02-01	952-736-0807	8882642317	ccharrettejj@biglobe.ne.jp	184
92656JFDD	Griffith Sivil	M	1970-09-02	309-209-7722	5546600808	gsiviljk@unicef.org	186
05389SBDY	Wallace Pimmocke	M	1969-06-15	867-831-4465	4297914401	wpimmockejl@ocn.ne.jp	187
97171WXZU	Beitris Burgill	F	1966-06-22	174-455-0334	3368573462	bburgilljm@foxnews.com	188
57203KZKN	Avie Rickets	F	1957-08-27	728-510-4409	1106571930	aricketsjn@msn.com	192
21322VHUT	Basilius Pryke	M	1946-11-05	769-399-6320	\N	\N	193
72287LWTO	Massimiliano Giovanizio	M	1950-12-27	474-914-0413	7058473696	mgiovaniziojp@archive.org	194
86585UFTO	Sax Toulson	M	1973-10-01	864-371-3695	8127486047	stoulsonjq@amazon.co.uk	195
02883PITG	Faydra Ailward	F	1951-08-22	495-104-0049	\N	\N	196
34316LTXO	Baxter Ondrus	M	1950-10-23	567-268-0000	7526131721	bondrusjs@apache.org	198
73717GUXD	Dedie Hocking	F	1980-03-05	621-321-0009	5009396247	dhockingjt@cocolog-nifty.com	199
48693UCHR	Missie Marzella	F	2000-08-31	178-597-0817	8862171839	mmarzellaju@tuttocitta.it	203
60124TAXO	Jewelle Whetson	F	1955-03-07	691-383-6714	9732023600	jwhetsonjv@state.tx.us	206
17005YGLQ	Gina Marielle	F	1967-09-18	998-906-3317	9867040106	gmariellejw@spiegel.de	209
68326THER	Maryl Lefley	F	1998-04-21	259-383-6771	6631936886	mlefleyjx@liveinternet.ru	210
22392GONW	Jamesy Frankling	M	1985-03-11	864-188-5160	9895095344	jfranklingjy@amazon.de	213
39821PNOF	Una Baversor	F	1954-11-23	962-807-1216	\N	\N	214
62977XMXI	Luisa Towsie	F	1982-05-19	549-571-4122	5595681421	ltowsiek0@digg.com	216
94511DPVH	Murdoch Eberle	M	1979-05-03	314-279-0540	6129170788	meberlek1@disqus.com	217
78383TJHN	Hobie Kubiak	M	2002-02-14	613-854-8600	5296266629	hkubiakk2@columbia.edu	218
87271NILH	Hillier Degenhardt	M	1953-11-21	396-719-4185	6864761729	hdegenhardtk3@ucoz.com	219
72839JEMG	Aldo Ive	M	1961-07-25	115-584-5941	5007210752	aivek4@dedecms.com	221
16706WSAX	Dorelia Guest	F	1956-10-07	122-257-8835	1351803803	dguestk5@artisteer.com	226
74726TPTH	Ephraim Brimble	M	1985-12-25	280-449-1082	9348837719	ebrimblek6@illinois.edu	228
69134NJKV	Buckie Torre	M	1970-12-18	612-203-3957	4927782603	btorrek7@webmd.com	231
75726KFSZ	Ambur Pinching	F	2000-04-01	779-400-1941	1712208886	apinchingk8@skyrock.com	232
63044QPGV	Joyous Ginni	F	1953-10-16	163-219-1061	2634174069	jginnik9@squarespace.com	234
94679AYOL	Monte Dumphy	M	1986-03-05	536-160-3562	9421244249	mdumphyka@yolasite.com	235
35343LCNQ	Glennis Holdworth	F	1960-12-10	597-313-5424	3889723054	gholdworthkb@hp.com	242
10983SAMA	Zerk Mullineux	M	2000-04-08	372-328-2372	\N	\N	243
60391FNPR	Kort Ivashkov	M	1978-12-30	272-730-6840	7444175567	kivashkovkd@creativecommons.org	244
07476HHJC	Deloria McCloud	F	1948-08-05	683-879-1712	8753331821	dmccloudke@paginegialle.it	246
86282IUAF	Maje Bengal	M	1978-02-07	747-384-1549	9289479810	mbengalkf@chronoengine.com	248
42916BBHR	Benjy Hayfield	M	1979-06-12	930-799-0329	\N	\N	249
64717PXGD	Panchito Nolton	M	1965-07-15	619-163-9169	8495636520	pnoltonkh@bbc.co.uk	253
42297DQOF	Omero Josilevich	M	1945-07-05	629-567-0640	1366219799	ojosilevichki@is.gd	254
21610YJRL	Bobina Hughlock	F	1965-02-09	886-646-3182	4747183678	bhughlockkj@google.ca	255
68186UIJW	Angeline Smith	F	1982-12-26	701-581-2647	9494679193	asmithkk@unblog.fr	262
69380XXJR	Mable Lamont	F	1959-06-19	730-309-1661	8352617312	mlamontkl@liveinternet.ru	264
94065KESV	Malvin Ansill	M	1951-12-19	381-785-9925	6671786755	mansillkm@ezinearticles.com	265
39050SHWX	Rouvin Stabler	M	1967-11-11	780-815-5495	6194914045	rstablerkn@soundcloud.com	266
83711WIJZ	Astrid Fortune	F	1967-01-17	110-194-7066	7548041020	afortuneko@bbb.org	268
21792ODMC	Nathanil Keri	M	1984-12-14	413-400-5409	\N	\N	269
87975QJMR	Chelsea Frankham	F	1952-09-13	317-441-6517	6297353113	cfrankhamkq@tiny.cc	273
30353XMEM	Neill MacPaike	M	1979-04-10	212-482-5541	9621182783	nmacpaikekr@yahoo.co.jp	275
92293UWSF	Des Schimpke	M	1983-09-25	221-126-8548	\N	\N	281
19734WSBQ	Sabine Wilkowski	F	1984-02-11	447-524-3377	2677261206	swilkowskikt@merriam-webster.com	288
54262DCFK	Francisco Velez	M	1954-08-31	791-382-2657	\N	\N	2
29357TDPM	Timmy Stephenson	M	1966-12-29	512-187-5097	9106184170	tstephensonkv@csmonitor.com	3
49803NKJR	Nicholle Moody	F	1971-12-22	730-647-3578	8428761384	nmoodykw@mac.com	4
93402BBKH	Gaspard Cammidge	M	1961-03-29	142-323-1023	\N	\N	5
07804TAFU	Dianemarie O'Callaghan	F	1997-08-15	494-339-7409	\N	\N	7
22406KMEH	Clarita Korbmaker	F	1959-02-26	196-145-1294	6854153989	ckorbmakerkz@state.tx.us	9
02098BFMN	Sebastian Fullwood	M	1976-08-22	469-424-9161	2447467790	sfullwoodl0@technorati.com	12
75872TZCN	Karina Swyre	F	1945-11-22	417-165-4368	9842263583	kswyrel1@google.com.hk	18
75765MQNM	Franciska Marty	F	1974-03-29	764-691-0460	3513979767	fmartyl2@networkadvertising.org	19
10519JFTE	Hy Cowderoy	M	1977-09-28	475-953-2812	2539705179	hcowderoyl3@dailymail.co.uk	21
83128KGUR	Dollie Stenet	F	1974-10-10	153-202-1856	1781429288	dstenetl4@about.com	22
53212LSUM	Jess Moret	M	1983-07-05	196-531-3464	8835694447	jmoretl5@psu.edu	25
59041GLUK	Archibold Frushard	M	1979-07-09	279-230-7437	9615862441	afrushardl6@parallels.com	32
46110OJEW	Daniela Greensall	F	1987-04-27	359-287-9518	7916116921	dgreensalll7@paginegialle.it	33
08913WEWY	Horatio Nettles	M	1993-05-21	105-763-0954	\N	\N	35
35941RADO	Jade Payton	F	1998-01-15	838-582-3757	\N	\N	36
77214GJDR	Cesare Aimer	M	1990-09-17	529-507-4921	3613567590	caimerla@state.gov	37
72945RKZS	Carmine Avramchik	M	1988-01-03	703-506-5306	2682858117	cavramchiklb@google.com	39
93325PXGJ	Valentino Weddeburn - Scrimgeour	M	1964-09-10	130-922-4651	5706509601	vweddeburnlc@economist.com	41
20038HYTS	Hugibert Ennew	M	1945-10-22	902-203-3773	7406504037	hennewld@barnesandnoble.com	42
39523XDZB	Jonathon De Beneditti	M	1951-03-21	801-323-8728	1499271830	jdele@oracle.com	45
63971NCPL	Rip Wilmore	M	1968-03-23	294-155-8419	\N	\N	49
45975HKVN	Lorie Coll	F	1960-07-01	967-299-3221	8116286209	lcolllg@uiuc.edu	55
84567OKZO	Dacia Willstrop	F	1991-10-20	311-442-9054	\N	\N	58
58247KZNA	Giacobo Causey	M	1963-02-15	574-669-3670	3982163241	gcauseyli@sitemeter.com	62
82311UVEF	Renault Combe	M	2001-10-05	402-764-9558	9974085828	rcombelj@who.int	63
25385JHQV	Deina Hazlegrove	F	1952-03-18	391-236-6998	1932722358	dhazlegrovelk@youtube.com	64
58842VIVP	Petrina Barreau	F	1951-03-18	864-846-2975	5117650819	pbarreaull@forbes.com	66
44953PELZ	Karalynn Stopper	F	1977-01-11	885-170-5628	1069608099	kstopperlm@hao123.com	68
31250JRMU	Lem Satterthwaite	M	1974-12-20	688-492-4846	1333583249	lsatterthwaiteln@facebook.com	70
08565PXLN	Fax Antoniades	M	1954-04-23	472-483-6576	7347317222	fantoniadeslo@engadget.com	72
14640VHVQ	Far Heggadon	M	1957-05-02	636-136-1638	3416020702	fheggadonlp@un.org	78
14808LCLN	Frasier Green	M	1949-02-20	205-113-7160	9298457522	fgreenlq@networkadvertising.org	79
33037DHIZ	Joel Konert	M	2000-09-10	758-577-8663	4664101832	jkonertlr@globo.com	81
24976HJOF	Kenny Reese	M	1963-10-06	306-519-0949	1707532117	kreesels@patch.com	86
12712YOLV	Cassondra Whitney	F	1972-10-13	209-926-2523	3187753378	cwhitneylt@go.com	88
40403SSKQ	Jamill Beat	M	1984-01-22	536-695-0285	\N	\N	91
68767NXNZ	Martica Daish	F	1954-11-05	832-420-5878	4288616712	mdaishlv@creativecommons.org	95
48874LJLJ	Fleming Atley	M	1983-04-28	252-925-2461	8809722924	fatleylw@vistaprint.com	96
32361XCHF	Haywood Teml	M	1992-02-04	237-179-4889	\N	\N	97
64330DZQD	Marco Thurstance	M	1985-02-25	703-325-3578	\N	\N	103
13237BBTT	Muffin Renn	F	1983-06-10	650-667-4960	6843003273	mrennlz@smugmug.com	106
93073RTAJ	Lothario Hatherall	M	1994-08-22	736-574-6166	2372960441	lhatherallm0@com.com	107
40737QDZU	Wakefield Hollyard	M	1955-07-12	857-605-5372	8362530859	whollyardm1@umn.edu	108
30147BFGU	Taylor Laughrey	M	1949-01-27	512-715-6085	2124894276	tlaughreym2@dyndns.org	109
00619JSMH	Byrann Pretti	M	1994-11-23	901-994-5543	1501324806	bprettim3@ed.gov	114
65216MKMO	Flemming Papierz	M	1971-02-06	772-497-6530	2175022715	fpapierzm4@yahoo.com	116
55613MJNV	Lil MacWhirter	F	1960-01-01	482-665-7065	6981515835	lmacwhirterm5@addthis.com	118
87032WUXB	Eyde Witnall	F	1978-08-03	622-841-8128	8775649898	ewitnallm6@indiatimes.com	119
26525HBJI	Marlee Linsay	F	2000-11-02	898-120-8983	6146354757	mlinsaym7@jimdo.com	121
24245HGEX	Georgena Plascott	F	1994-09-17	444-287-3253	\N	\N	122
38988KSYZ	Sterling Featherstone	M	1997-12-27	877-206-7073	\N	\N	123
52656WLRL	Vic Greyes	M	2001-03-31	696-129-9185	6463630394	vgreyesma@constantcontact.com	128
90164UHZS	Corabella Westphalen	F	1981-02-18	742-176-4803	8996258230	cwestphalenmb@illinois.edu	129
91115LJSC	West Desport	M	1964-09-13	300-685-8834	\N	\N	130
24456CLTZ	Johnny Saxby	M	1974-11-04	343-756-7801	4298850397	jsaxbymd@mashable.com	132
54987ZYAU	Mary Baudins	F	1968-02-29	305-810-3574	\N	\N	134
75043CWWO	Dene Deane	M	1986-06-24	981-651-1089	\N	\N	135
14687YYJN	Gerrie Godsil	M	1981-02-12	375-407-8048	4054445515	ggodsilmg@dagondesign.com	137
79787OGRG	Fredric Eastes	M	1993-02-12	568-200-0782	6999994763	feastesmh@biglobe.ne.jp	138
03629DIXY	Jessa Albasiny	F	1992-04-12	339-901-3987	3355835517	jalbasinymi@admin.ch	140
60292UZSH	Eddie Byforth	M	1954-07-22	492-550-9229	7827698019	ebyforthmj@mozilla.org	141
86039JHGJ	Rickie Dalbey	M	1947-11-21	544-790-8988	9341246106	rdalbeymk@hubpages.com	142
74560BZMH	Bea Chilcott	F	1987-05-23	493-318-7992	5015975808	bchilcottml@gravatar.com	144
61541GAJS	Wynn Conboy	M	2003-01-30	222-835-3338	1823580834	wconboymm@ask.com	146
13944SLOY	Muire Antoney	F	1950-07-17	250-591-4489	7105009333	mantoneymn@freewebs.com	147
03582ESML	Werner Wilber	M	1991-01-26	781-507-7573	8731214562	wwilbermo@arstechnica.com	151
49490TNQR	Merv Flinders	M	1989-03-04	460-429-6650	8517655360	mflindersmp@issuu.com	152
51969IYSH	Nevil Upston	M	1970-06-23	369-719-1627	\N	\N	153
22321EPPF	Morrie Monnery	M	1991-03-16	995-151-8639	\N	\N	156
39508ZCPF	Tomasine Ebrall	F	1950-12-07	850-460-6831	5206146093	tebrallms@chron.com	157
55785XGUE	Valma Fitchet	F	1978-03-17	889-776-0786	6784877390	vfitchetmt@reuters.com	160
93845OCYC	Immanuel Leader	M	1970-10-09	230-874-5681	9061026052	ileadermu@usatoday.com	164
81197VDCD	Trefor O'Dee	M	1950-01-09	588-151-6111	1642719664	todeemv@slideshare.net	165
05974RBYS	Mortie Lintin	M	1998-09-19	962-843-9429	\N	\N	170
61703XRFJ	Phylys Devanny	F	1976-09-18	622-355-5013	6629370531	pdevannymx@blogtalkradio.com	171
98510VPBG	Harrie Coghlan	F	1977-03-16	314-714-6683	3524372512	hcoghlanmy@51.la	173
77171BGSM	Kara-lynn Ketch	F	2001-03-27	516-996-8842	5059477056	kketchmz@mysql.com	178
83072LQSO	Catharine Czaja	F	1951-02-24	440-744-8097	5181823117	cczajan0@sohu.com	186
30016VFCO	Clive Chritchley	M	1953-03-01	852-170-5104	5517875068	cchritchleyn1@chron.com	188
86484VKKP	Porty Ballantyne	M	1987-03-02	143-543-0374	\N	\N	191
50386FVMX	Philbert Dohrmann	M	1947-12-14	605-565-0941	4458197239	pdohrmannn3@youtube.com	193
63851FVSR	Cori Albrecht	M	1966-04-25	709-859-6449	\N	\N	195
43939YFZE	Jarid Botton	M	1972-11-21	457-500-6445	9334857517	jbottonn5@tiny.cc	196
02902ERRI	Margette Bellocht	F	1955-12-04	131-493-6008	6529259782	mbellochtn6@umn.edu	197
34399OYYP	Dionis Dobbinson	F	1952-11-30	150-980-6017	3912488379	ddobbinsonn7@twitpic.com	200
96213WUZU	Letta Vairow	F	1978-04-04	159-831-2223	7172948341	lvairown8@goodreads.com	202
78202GNLC	Ashlen Harvey	F	1956-06-29	493-709-1897	3268892613	aharveyn9@google.com.hk	203
67992AIIF	Wynn Spall	M	1970-03-23	268-742-6551	\N	\N	206
44474GUTY	Donetta Hissie	F	1989-10-23	718-578-5074	5934532103	dhissienb@people.com.cn	207
95612BHFH	Lek Wearn	M	1991-05-08	185-273-4163	9288649774	lwearnnc@instagram.com	213
70895DANL	Nico Clewlowe	M	1999-02-27	527-810-8902	2293264504	nclewlowend@ustream.tv	214
03161CKXF	Grove Buntine	M	1990-02-24	147-778-2545	3936146663	gbuntinene@storify.com	216
05323QSUQ	Germayne Duiged	M	1952-06-07	243-946-9086	6881265027	gduigednf@parallels.com	217
06559CNUQ	Liliane Tranmer	F	1962-04-08	329-350-8560	3016702103	ltranmerng@wikimedia.org	218
83316KJNM	Alden Fawdrey	M	1960-04-01	311-192-5005	9917126345	afawdreynh@irs.gov	223
88068BTZY	Hakim Kinchley	M	1983-11-04	393-253-9661	1684241146	hkinchleyni@marketwatch.com	225
56352ZDJQ	Torre Gionettitti	M	1978-08-14	718-851-0803	9772140963	tgionettittinj@feedburner.com	226
70697GKDM	Laurent Gallie	M	1972-02-22	238-177-4862	2195258052	lgallienk@infoseek.co.jp	231
74720QSWF	Dinny Brind	F	1978-03-31	147-589-2221	2783916364	dbrindnl@mozilla.com	233
76584BXVA	Des Campbell-Dunlop	M	1985-11-12	890-387-4045	5282356048	dcampbelldunlopnm@nyu.edu	234
97553APUO	Dinny Gilmore	F	1945-08-01	892-311-2501	1637711753	dgilmorenn@amazon.de	236
29423AYCV	Risa Mennear	F	1972-06-11	861-526-4514	3696604348	rmennearno@hatena.ne.jp	239
72312UHCA	Joellyn Du Fray	F	1970-12-31	876-433-8747	2542039448	jdunp@vk.com	240
34304WEPK	Wally Marte	M	1986-05-08	392-574-7411	\N	\N	242
51791XWMI	Rebekkah Sycamore	F	1963-09-06	913-594-3511	6083482744	rsycamorenr@xinhuanet.com	244
33385TNIS	Lauren Boulding	M	1994-07-26	720-358-6469	3419950503	lbouldingns@edublogs.org	247
50808RZDH	Pavia Dillow	F	1983-01-16	390-336-3135	2384482748	pdillownt@google.com.hk	251
37225URZD	Massimo Arlott	M	1947-08-23	466-954-7936	8276676792	marlottnu@usda.gov	252
54346YAEL	Hube MacCarlich	M	1949-05-26	879-424-5349	1783480057	hmaccarlichnv@nationalgeographic.com	255
97187WKRL	Borden Beevens	M	1984-04-13	287-787-1261	2146052051	bbeevensnw@cnn.com	256
11262EQSP	Bartram Salan	M	1995-08-05	523-309-4437	\N	\N	258
49361XYND	Hewie Phillcox	M	1947-04-11	718-707-6771	9595305965	hphillcoxny@pcworld.com	263
35081ASWV	Jordan Hayball	M	1977-01-19	974-362-7417	6495078799	jhayballnz@hubpages.com	264
60411FCMJ	Beverie Wordington	F	1996-06-06	511-115-3021	1103496725	bwordingtono0@51.la	266
25392JESL	Gregory Puttan	M	1992-01-23	650-183-5406	5685107038	gputtano1@pinterest.com	267
08958UYKL	Bev Grandisson	M	1978-06-03	555-475-5583	1122435064	bgrandissono2@google.co.jp	270
35426DFVH	Derward Hixson	M	1959-10-23	134-796-9783	8922217573	dhixsono3@naver.com	271
93804UMZY	Oriana Gaskall	F	1964-10-28	991-698-8705	9119702029	ogaskallo4@google.com	275
12396SEHI	Carmen Wethers	F	1961-07-02	608-363-9900	5213708024	cwetherso5@google.ru	276
95368VEVI	Hersch Leeves	M	1991-03-26	411-465-6577	\N	\N	282
48360RTQY	Bradney Garrad	M	1988-12-26	752-636-9299	1996411510	bgarrado7@alexa.com	283
59206LSJV	Rich Carthew	M	1955-07-31	134-249-8549	1908541497	rcarthewo8@jimdo.com	284
16413RGXY	Janel Brettelle	F	1999-12-01	232-934-2110	2258925037	jbrettelleo9@goodreads.com	285
67030QXYQ	Othello Shimmings	M	1995-01-29	157-649-1964	6784082248	oshimmingsoa@psu.edu	287
46780NFYB	Lena Crummey	F	1946-05-17	575-725-5081	3119521824	lcrummeyob@woothemes.com	1
40776TFFR	Kim Bourdas	M	1999-03-12	994-189-4995	5914042626	kbourdasoc@imgur.com	6
55002WPCD	Jereme Brownell	M	1947-07-08	133-729-6361	8714535015	jbrownellod@smh.com.au	11
85622VKBX	Christye Giacopazzi	F	1999-10-30	153-396-3892	\N	\N	19
11165EVEO	Link Laffranconi	M	1991-04-12	376-504-4193	8789840447	llaffranconiof@ifeng.com	22
50714TYYA	Chico Austins	M	1949-03-21	939-551-4200	6552382663	caustinsog@nba.com	30
39828YKCH	Warren Pessold	M	1995-07-08	352-466-4916	\N	\N	36
93994DXVB	Stevana Sinkin	F	1979-10-11	278-363-0221	4664905973	ssinkinoi@springer.com	37
82878UKGO	Tamarra Tweedie	F	1992-11-28	904-689-7767	\N	\N	41
26981GTTS	Tony D'Antuoni	M	1993-12-07	381-625-7333	3039746216	tdantuoniok@joomla.org	43
13058IJMK	Milli Magnay	F	1998-06-01	753-529-7677	\N	\N	45
10284VVZP	Samuele Berndt	M	1951-12-03	697-512-9199	8684587369	sberndtom@icq.com	49
84230PYIY	Crawford Aguirrezabal	M	1993-05-12	582-689-7426	3513848157	caguirrezabalon@wikispaces.com	52
59687ZSFQ	Orin Compston	M	1967-09-22	808-643-1557	7143101296	ocompstonoo@youtu.be	55
95424JVNX	Fax Melpuss	M	1984-03-06	357-885-1232	\N	\N	57
80522DQGF	Frederique Fright	F	1948-11-06	753-651-3347	5362536395	ffrightoq@vistaprint.com	59
24766FIYN	Odelinda Hellcat	F	1999-12-16	876-177-0035	7689066567	ohellcator@youtube.com	67
86730XJCB	Melony Brayshay	F	1999-01-25	904-930-9634	1867229775	mbrayshayos@spotify.com	68
42401MDAG	Brittani McEntegart	F	2001-08-21	308-820-2793	8663868965	bmcentegartot@blog.com	72
87348CFQT	Rochell Finkle	F	1963-08-31	382-251-6822	\N	\N	78
53929HPNL	Tatiana Rabjohns	F	1956-07-03	333-445-7156	4882425495	trabjohnsov@furl.net	82
60034TGDO	Lura Chadbourne	F	1955-07-12	338-746-3127	1026847070	lchadbourneow@cnbc.com	83
82197BDSL	Kelsey Hellwig	M	1974-09-14	346-880-7327	5349033506	khellwigox@bbb.org	88
62472DUFM	Tanny Gallahue	M	1965-09-15	836-183-1464	6548848339	tgallahueoy@walmart.com	89
27994ZTYP	Damara Carrabot	F	1993-10-02	822-228-5823	9381109699	dcarrabotoz@squarespace.com	90
99936IYUN	Maris Kasting	F	1983-02-20	617-423-5425	4069882936	mkastingp0@edublogs.org	91
78455IHLB	Vanya Lembrick	F	1957-06-23	779-188-5245	5559573693	vlembrickp1@umn.edu	92
98540GCOB	Ryon Syer	M	1995-05-24	456-377-6780	4883855330	rsyerp2@fda.gov	95
36424WPSP	Rocky Celiz	M	1984-11-21	243-166-1367	3334795625	rcelizp3@ed.gov	98
04681BNYH	Celestine Yakovliv	F	1979-10-07	850-678-4347	7057833017	cyakovlivp4@statcounter.com	99
82928TFCA	Jeannette Freund	F	1964-05-20	553-637-0614	9142939432	jfreundp5@google.com	102
73238ZXCX	Delia Kettley	F	1978-10-18	336-383-3288	7075897128	dkettleyp6@mapquest.com	104
59081JRDF	Tate Poundford	F	1946-09-15	367-407-9526	\N	\N	105
60112LHBE	Delaney Ells	M	1962-05-20	904-886-6789	1454106959	dellsp8@examiner.com	107
74250NVBC	Fifine Symondson	F	1950-04-05	302-426-9778	1661581322	fsymondsonp9@princeton.edu	108
18772KBIE	Lesya Gutridge	F	1982-03-03	422-388-1832	8554484684	lgutridgepa@feedburner.com	110
78754AXTH	Carlynn Sharkey	F	1987-01-20	468-590-3517	2157232114	csharkeypb@cbsnews.com	113
93326PHAO	Carolyn Amburgy	F	1999-03-26	745-545-3444	1849038473	camburgypc@yahoo.com	116
52959IFMB	Gabey Giacopello	F	1955-09-23	726-942-2946	2452627701	ggiacopellopd@fda.gov	117
27828NLUG	Nonnah Pardoe	F	1970-11-17	501-685-8467	\N	\N	118
18317IDGU	Bourke Andreone	M	1956-02-17	203-547-9682	3125634981	bandreonepf@slideshare.net	119
07724TNDJ	Halley Knightly	F	1995-05-03	672-872-3607	\N	\N	120
61846YGES	Luis Lube	M	1986-04-28	494-910-1738	1833845204	llubeph@nhs.uk	124
60043JETS	Adah Arnely	F	1999-03-08	447-210-5626	\N	\N	126
93575HSTH	Arlina Lilford	F	1963-03-14	381-193-5979	\N	\N	127
56866KCUB	Bryn Hawkswell	M	1975-01-14	832-864-0647	4246953016	bhawkswellpk@gizmodo.com	133
39496WZCX	Fionnula Garatty	F	1979-12-01	748-485-2645	\N	\N	134
97715SYFH	Isa Pattini	M	1946-03-31	512-198-3431	7295415226	ipattinipm@businessweek.com	135
77248IJYF	Ed Verrechia	M	1989-09-05	147-422-7043	\N	\N	137
33027XWHR	Brynn Boyes	F	1947-12-01	134-612-3340	8599224278	bboyespo@howstuffworks.com	138
56426VNSP	Tadeas Kinnen	M	1971-09-10	832-191-6120	6209720823	tkinnenpp@quantcast.com	141
22230RBTS	Nealon Yurenin	M	2001-07-05	298-126-0517	5796426547	nyureninpq@behance.net	142
00588XUMP	Lonny Pitceathly	M	1966-09-22	783-463-5773	4214736602	lpitceathlypr@google.com.au	145
39894AGBO	Kristina Klimas	F	1997-09-21	275-184-9826	6776100502	kklimasps@networkadvertising.org	147
04385HCST	Loren Lewsam	M	1974-06-27	403-771-7559	\N	\N	149
89310FQIP	Khalil Sagerson	M	1951-03-15	389-354-9529	5262920066	ksagersonpu@wp.com	151
56552BBSH	Lowell Wastall	M	1968-03-25	947-816-7962	\N	\N	155
72277KGXB	Laural Baptie	F	1977-07-08	231-317-1749	9881240018	lbaptiepw@bing.com	159
60422IQID	Gladi Moneti	F	1946-02-14	611-438-0341	9193181135	gmonetipx@hibu.com	160
14952KMMT	Rosetta Buckleigh	F	1981-05-09	507-755-7539	9757177209	rbuckleighpy@ox.ac.uk	164
87379SRPN	Lacee Sowerbutts	F	1969-12-15	103-142-2477	1979482322	lsowerbuttspz@telegraph.co.uk	165
90469FNZZ	Mohandas Minnis	M	1958-05-11	884-943-1127	1592455993	mminnisq0@si.edu	168
32224OKYC	Kaine Powlesland	M	1963-11-10	739-165-7061	\N	\N	169
93367YZHI	Poppy Whitlaw	F	1987-11-27	702-860-7811	7284714986	pwhitlawq2@cdbaby.com	170
50630VINA	Kort Gillibrand	M	1948-03-30	663-142-8812	4502724250	kgillibrandq3@symantec.com	174
64948XSGB	Jillane Emmott	F	1970-09-27	329-246-0790	8861726813	jemmottq4@china.com.cn	176
50790NQOP	Jere Westpfel	F	1949-04-04	481-359-8337	2659833032	jwestpfelq5@cnbc.com	178
80533HGTT	Dallis Vlasin	M	1951-07-28	670-581-1698	6759323914	dvlasinq6@springer.com	181
61405UMPL	Shalne McDonogh	F	1978-04-03	664-820-5149	7729314999	smcdonoghq7@fastcompany.com	183
55261UPZX	Milly Hosier	F	1959-03-22	715-174-6909	8314990842	mhosierq8@theatlantic.com	184
35608EJLD	Christa Ericssen	F	1956-03-01	902-387-2129	8983025971	cericssenq9@whitehouse.gov	186
91493VDDP	Hilda Stonbridge	F	1964-05-21	338-857-7199	\N	\N	188
27688XCOI	Martguerita Minett	F	1951-09-29	672-261-5922	2715514007	mminettqb@mozilla.org	189
78872OOSZ	Emiline Danihelka	F	1968-07-21	608-787-1847	9151488555	edanihelkaqc@huffingtonpost.com	190
11786OHTZ	Gusella Vest	F	1974-01-04	498-591-9099	5909780857	gvestqd@apple.com	191
65482KFQJ	Bob Billam	M	1978-10-24	596-218-9389	6116607246	bbillamqe@phoca.cz	192
81317NDEE	Jasmin Martill	F	1971-02-16	430-633-5460	\N	\N	195
10899WTNY	Carey Roswarn	F	1949-01-22	457-284-3151	1684507833	croswarnqg@cdbaby.com	196
70019SNXZ	Bennie Epple	F	1977-12-28	427-640-0418	7341473044	beppleqh@ameblo.jp	198
51810FNRT	Dud Hasted	M	1951-06-24	672-918-4619	2535433150	dhastedqi@ucsd.edu	200
01645CCZD	Ellynn Barchrameev	F	1983-11-26	230-257-1597	\N	\N	204
73657XSCL	Oneida Fullerlove	F	1977-06-03	839-595-0314	\N	\N	214
15845IDJD	Claus Lytlle	M	1960-10-13	117-661-5715	7832912892	clytlleql@hao123.com	219
22823GWMJ	Prent Stanesby	M	1968-05-22	483-904-3082	5535234197	pstanesbyqm@51.la	221
07988RKUW	Clerc Dilnot	M	1962-03-26	976-289-8988	8048689622	cdilnotqn@earthlink.net	222
16259JEGS	Davie Nazair	M	1959-12-02	268-382-1948	5967076436	dnazairqo@is.gd	223
22569AOUX	Kessia Haslewood	F	1957-05-08	603-391-8656	8899269664	khaslewoodqp@epa.gov	225
20240KTQG	Chastity Senussi	F	1980-11-28	352-890-0416	6146331153	csenussiqq@bandcamp.com	226
43020SOQX	Brennen Neames	M	1962-04-05	810-810-3461	4961945282	bneamesqr@booking.com	228
59721YWJG	Giselbert Wardhaw	M	2001-03-28	518-547-7370	6432805611	gwardhawqs@craigslist.org	235
84358JOSY	Malvin Arnald	M	1948-02-11	762-120-4731	4892232040	marnaldqt@phpbb.com	239
17259XFMD	Conant Hartop	M	1999-12-19	590-496-0913	2142776176	chartopqu@flavors.me	240
06446CDFK	Sharyl Ingarfill	F	1989-07-26	610-183-6029	5466618122	singarfillqv@rakuten.co.jp	241
90310ZNIC	Der Toseland	M	1966-11-18	455-556-3959	7585638291	dtoselandqw@g.co	243
72712QUEG	Ambrosio Stancer	M	1948-03-09	284-374-6742	1524714869	astancerqx@gravatar.com	246
34230UOEV	De witt Kalb	M	1992-03-03	655-209-2925	8985749581	dwittqy@slideshare.net	247
67999ZVJZ	Ber Raspison	M	1964-07-23	937-133-8988	3251096699	braspisonqz@cam.ac.uk	248
76720UBNG	Carly Garvey	M	1964-01-13	329-142-4459	\N	\N	249
50160OKNO	Bruce Walling	M	1948-06-13	374-521-2689	6803028512	bwallingr1@jalbum.net	253
42031SUYR	Maurice Thebe	M	1984-01-17	975-554-6530	7952309320	mtheber2@lulu.com	256
23347QHTS	Laurens McNeilly	M	1988-11-12	541-839-3851	2442828998	lmcneillyr3@tmall.com	260
95175ZFPU	Paxton Burnel	M	1999-03-02	710-963-3795	1883575227	pburnelr4@tripod.com	262
39946DXOX	Sharlene Gaither	F	1972-04-12	850-931-5725	3206466335	sgaitherr5@shareasale.com	263
23315NTPM	Romola Goodlud	F	1985-05-25	638-782-3812	8864443475	rgoodludr6@google.com.hk	264
60643TOPK	Ruperto Tilly	M	1990-05-15	876-610-2736	7821049246	rtillyr7@eepurl.com	265
90579LYTV	Ladonna Lavrick	F	1989-09-09	740-894-2254	6462843911	llavrickr8@artisteer.com	266
71710FHWI	Mendie Appleby	M	1996-11-27	513-854-2363	3898978989	mapplebyr9@qq.com	267
67470TCVG	Bel Wyche	F	1979-06-15	935-151-2598	9158356429	bwychera@booking.com	270
10711HZSK	Ame Thirlwall	F	1952-07-31	370-748-8822	1403180010	athirlwallrb@google.fr	271
40855YKUQ	Cecilius Mallatratt	M	1963-10-04	130-159-1013	\N	\N	272
66385AJCL	Lisbeth Bloxham	F	1955-02-16	350-756-0182	8576681692	lbloxhamrd@sciencedirect.com	273
95840FXYH	Tiphani Petett	F	1952-07-01	229-276-8950	8536519234	tpetettre@scribd.com	279
96595OHCG	Binni Phette	F	1960-04-05	283-248-8888	\N	\N	280
55088GNKQ	Cayla De Vaux	F	1973-06-29	903-371-2046	3657277232	cderg@homestead.com	282
16463SLWC	Addi O'Driscoll	F	1976-12-13	259-132-2729	4806579159	aodriscollrh@ucla.edu	285
05169NMGX	Emmie Biddleston	F	1982-10-11	962-148-0495	8644823021	ebiddlestonri@techcrunch.com	287
77612EZBQ	Jo-ann Aiskrigg	F	1969-04-17	488-383-0781	2759911654	jaiskriggrj@chronoengine.com	288
99554GPDU	Eduardo Lembcke	M	1951-02-14	792-458-9229	8314386394	elembckerk@nydailynews.com	289
42484CHAL	Leandra Maddaford	F	1958-02-17	149-856-3623	3831975707	lmaddafordrl@about.com	292
07415XWEI	Adelle Diggle	F	1968-04-20	396-782-4716	3639116358	adigglerm@ftc.gov	294
76778MNQG	Marcellus Dalla	M	2000-08-28	321-134-1898	4905065054	mdallarn@a8.net	299
46368AQQY	Katha Cragoe	F	1971-06-06	415-212-1960	5376921039	kcragoero@cisco.com	300
03948TOZT	Temple Berthon	M	1991-02-20	821-698-8677	3127410752	tberthonrp@hatena.ne.jp	301
66175TMAP	Shanie Escreet	F	1979-02-13	855-574-8238	8693737448	sescreetrq@wiley.com	305
13201GLAS	Fitzgerald Lafontaine	M	1959-08-10	226-810-4294	\N	\N	306
\.


--
-- Data for Name: drivers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.drivers (license_number, license_plate) FROM stdin;
1459716828	9Z512
58959772	727 JGD
4528930905	2LU 363
1466699002	CFZ-382
8338410957	072 4QK
6997303792	BJ6 Y7V
5081036892	566 JNB
420783266	QSH-5559
6103775793	759-HKD
2429545014	FQS4118
4676274503	0U 0335S
8088856438	QDM-2037
3930469445	RIU 090
1772392824	CGU4014
7967786385	KUM 150
5997162104	257-AFM
1487391158	0ZLD 20
2546797455	9ND 607
7595560145	60B H04
9876465884	RK-4506
4012915395	UJN-843
2303564684	HYK 366
4932089967	MBR 586
4932820612	3TD 621
5566286209	938 QHJ
9286293005	122 FYK
8356732001	760-MKBU
9926144611	465-HCJ
9575754613	267 JQV
7856208707	7UYR078
6064194711	052 1561
1476992639	O 923797
4648159575	LGN-1306
7528627015	846 4924
5948807290	374 TK2
6373682386	E55 3KP
5022233691	VN 90470
883631466	U95-83Z
476170832	AQL4744
8796604725	502-XPD
3263271429	N24 2SO
9138367757	693M
8665505928	PV5 4900
2789420264	1-89256
1858983270	8C 7R6MFX
7473551270	BEB1897
6142671172	9-30884
884844920	15Y 823
2894713422	IUM 377
3422253034	ORA-886
2452892844	226 0FR
2578130768	FR0 2492
1159738206	5Z 7I0WSV
6393833308	929-XJT
6371094633	D 548591
335669174	6-89908
6830340144	5OR T08
2461250409	8SWU 92
6074985303	Q18 0AF
180019321	0S A1011
9486924781	VJY 943
9085377153	UDT 336
7577536311	XKG-9136
8473725481	7-Q9517
8501017618	574-AOZ
2733625201	GTB 435
2259767954	0IB 803
7276364644	RFL-2957
3530133295	M19-91N
5262035914	3QB45
2421418534	0-Z0625
1251818586	6127
9976367840	YEA-468
6498661786	6XX 116
6610414206	4-46616N
4825420472	9ZO P33
2370991386	TBD-688
379817950	LJU S70
787565187	3-13562X
1804154393	623 5388
7526293725	MAS-641
5026093530	FTF-8420
7361665685	Z44 3DF
8522013978	SUR 995
7160146	7BP 881
3839557577	0B E6144
8882947224	1BQ 169
9798775759	370-AMF
965270194	75LM5
4374363265	NLB-4427
126192716	416 YTP
1810788575	5K 8L0QYM
4025235663	7YM4070
7702084276	LNY3441
732776564	2-61359G
8708228336	36D JT4
7133693442	ZZR 318
130597914	767 PJE
279405538	QCY 464
1152340118	OQE N74
3379040124	74Y M17
2999591912	1S XY951
5465674670	HSZ-6396
5862567248	XY1 2439
5235392775	LYS 352
3378571562	26A W31
2403811561	13I L66
4146207898	04-J541
88755701	T99-KBC
8857634189	68-1035A
864035941	189 HFU
9450326055	41CU041
774018388	2C 67350
1131481063	28033
9454182811	8BMP479
2400834682	GRE-025
322630381	1-L0164
9439906248	GDZ0926
9444920339	2V139
7311757212	694 VZ3
3294114737	4961 IV
5935103349	WLQ-8090
6200017793	5UQ 943
7410093140	44-HC56
9822909160	4WEJ 70
1459716828	401AW
58959772	53-N511
9276619450	LYP 869
1466699002	F08 4EV
913536434	LKB 959
420783266	QB-6655
3642508404	THX 215
941216632	5M DX778
8707151370	2S 9Q8TCY
6330409863	1MUT 21
7293373731	KGN 691
8381437774	96QA623
8299278290	TIX-774
3930469445	ICQ 879
5625375383	DUQ4085
4838095613	JHM-238
2910680909	3VN45
7595560145	SZU 900
9876465884	0UB5012
2078972523	225 JCO
2939791739	226 WWG
4012915395	75U V05
2303564684	CDC-924
4932820612	YW 21591
5566286209	CBQ4730
3195507526	2K TJ446
470582014	LDC6930
1342108625	DST 217
1880381729	1DJ X06
7775650608	RQQ 703
7856208707	568 BOL
2207904355	NIP-6327
3655765005	894KK
448952745	BEE 770
5948807290	XX8 T1G
476170832	HCI 343
8796604725	511 RWL
3263271429	15-HM06
6142671172	8-86297P
884844920	4AB0480
2894713422	574 JIM
6393833308	7925 VH
6371094633	32N G07
7787343294	6PR 858
2461250409	672 5MR
6074985303	HQF 124
7441937126	661-IYN
9085377153	4SS 130
2259767954	ALZ 108
5684721851	82-ME02
6534683275	820 6ND
4763498514	BTN-572
2679076606	538-HLN
6073273942	088-JED
2421418534	5-C5151
3364096073	925 UXM
3724276361	16K 993
2764402554	544
6498661786	PMY-3580
4825420472	WFT 351
379817950	0FUI 92
787565187	ENL-8366
1804154393	4IZ R94
7526293725	85-9958S
5427979566	52J Q78
8522013978	IUH-070
6347139126	9OD7099
2335691649	IRJ4061
3839557577	199 0QS
8882947224	MGN 374
9537618009	984 WZZ
6559591227	920 LGZ
9798775759	IXG-3377
965270194	GA 2048
1810788575	HSS 135
8410715214	5HKQ 97
732776564	H 717865
1453385195	29W B12
8708228336	QKL-2115
8019125386	73-28679
6584123888	2BE79
3461209265	3KJF834
4736184751	876 BMI
6377673199	JRG 190
802290981	ZGU-170
3379040124	609 BEW
2894173575	12-J856
372664422	9V 0E7TFM
1696605212	39-4352N
5465674670	729-ZOG
8310140181	0CT E37
5862567248	BA-8605
3378571562	GD-2434
340640279	MAE 821
2405963163	5JE6549
5423426045	035DR
3009273310	EG6 T4J
3527198547	MDN 148
1322742292	427-AKK
8829116478	685VJJ
4655980665	UX 6663
2967237942	65-L073
9450326055	6M 8N4WZH
5102878846	L76-44F
1329966052	6IX04
35638473	YAI9366
5834492576	7I BO383
4732874142	127 MOD
2400834682	276 NHZ
8623673715	W39-HNO
8678128651	0VR1058
8368649018	D78-89Y
322630381	2X CH591
9439906248	X12-42Y
5859254607	HGW-0660
3121032579	MOK 536
9444920339	577-UTK
7311757212	YRD-6112
5935103349	780-107
4704499976	921-NNIU
6017495036	XVX-1687
7688490905	FS 4755
2542775326	886 FKO
4321294542	ISV 533
2085585714	495 ISP
9276619450	743-KJS
913536434	KKG 293
4502284517	8MB71
941216632	EPI4806
2784926685	63-97656
8381437774	9GXK 13
2930274072	LM 24090
3930469445	BHS-5622
5625375383	NBQ-4863
1772392824	9F F2690
4838095613	AOS-829
2612606326	177TCO
1128842781	70C W31
9412159266	2XY3473
2910680909	1F 78928
5119996624	809 UBB
2078972523	WCI 038
4012915395	FOP-4832
9286293005	2401 DR
1342108625	BHX 924
9575754613	U98 6YR
1880381729	181 BFU
7775650608	106 YIJ
7856208707	ADU-732
7142683736	68R•376
2621194249	I56 5DY
8226190121	2R 88330
7528627015	60U Z91
5022233691	220-FIX
9611758250	84-WC27
883631466	800 PML
8249163834	9MI 839
3263271429	302FBQ
5565959293	939 7924
3171217627	3RX4731
4553118554	179LU
8665505928	MXS 588
2789420264	794-XFB
6190058432	ORH 676
2452892844	802 FV7
2578130768	281 PZZ
1933291552	7G 8649R
1159738206	ZXS5691
6393833308	224 NGD
7787343294	YKH-6327
6074985303	107-VDR
1289040145	7-J6658
9486924781	140-BAL
9157972870	6DN G71
7577536311	575 VZ6
2733625201	94-DW79
5583024379	EEF 010
3530133295	3FW8336
6534683275	22-R524
4763498514	2652 XG
4661920872	226 QZB
2679076606	241 RCC
7270241175	7NE W68
5262035914	6QY I45
6073273942	ZYP 005
6282869318	GEX4534
3364096073	MGS 805
9976367840	6D363
6498661786	VE0 P9A
4825420472	829-221
379817950	304 HPU
787565187	1NT N25
1804154393	7-29887
8135751658	GDB 326
5026093530	HRA 075
4897644477	08E RK3
4468550394	814 9RX
5427979566	775-LAO
3839557577	6PM3715
9537618009	463 4811
9798775759	SLF-681
9146996311	WCM 529
4025235663	4JT Q75
5123615695	964 IP3
1453385195	YQE3024
8708228336	4Q D4822
8019125386	04Z 2157
9503473457	H96 7QF
7229017149	QBV C27
4736184751	HSH 428
3290782544	I61 6TY
9227040883	TV2 2438
4444840236	8V 7131S
802290981	7B 77677
8743228739	5HGH 47
3379040124	879-UCD
2999591912	MDV-5677
3044741010	732-WLK
1696605212	3LZR577
5465674670	9Z 1026N
5248740590	ULI-9187
5235392775	580-XRQ
2637178822	UOS 611
2432047308	NXN2628
88755701	4O 96624
1322742292	GZD-0194
8829116478	5-B4621
6619103017	F47-ZQW
9142343103	741 1KT
5102878846	82-94022
774018388	OHP 597
5834492576	QUO 439
9161773093	6WUL 89
3347955749	LIK-145
6902300103	9-5756R
4732874142	8NE 465
2400834682	W99 1LZ
3353679220	51KH4
8324074356	7113 FH
1043488309	3IN S20
9580907936	185 8AV
7024211517	TQ5 8063
3121032579	KXX 551
7311757212	OAB 115
2792693333	OPT-567
4307758206	XR 37057
3702710686	SEJ 2186
4571600449	09-CG69
9425780349	5-3602I
6469958684	U47-ZFZ
9276619450	IZQ 3134
1466699002	264-FFN
6997303792	42U E17
420783266	6V272
5173959718	51F B29
2429545014	998 UEB
8299278290	F57-DQU
3930469445	WFV 438
1772392824	7NV 317
5997162104	AIT 625
4838095613	12G 734
7595560145	VB 8529
5119996624	4K089
6518682926	OX-1985
3447539783	XDR 244
2303564684	900-ZHA
4932820612	0F 6036O
5566286209	7401 UA
8356732001	ZVT-099
1880381729	249-BUW
1542285077	508U
8226190121	793 OJT
4648159575	AQ9 H1X
7528627015	3393
6251675679	2-94366I
5948807290	A56-HII
5022233691	3-54356V
9611758250	9-79815
8796604725	DNB O58
3263271429	841-JFAT
4553118554	8L 9X9FLZ
5908988613	XLN4969
2789420264	QIH 409
9655273399	LKM 657
6190058432	749ONN
1858983270	9OO 663
7473551270	618HNP
4092795269	U81 3VZ
884844920	JRM 387
1933291552	FDF1234
5123711356	63DL626
6393833308	ISN 788
2461250409	57-Y093
7441937126	561H0
1289040145	BU-6680
8019686818	VPY1682
9486924781	927 5XR
9157972870	0-5724W
5398650693	347 CY4
7577536311	97-86218
8473725481	9295
8501017618	509 UVM
5583024379	531AJG
7857918801	MKO-9627
3993497972	HJC 040
2259767954	24E T56
2967021206	ZOB-9687
2489902354	844-IEF
3530133295	QHM 493
4763498514	93-DJ50
5262035914	QL 5205
6073273942	TGC 358
2421418534	150 ZIG
1251818586	KFC 617
2764402554	PP 5921
2370991386	319-TIH
1804154393	SEC-295
5026093530	QDV-8658
7361665685	9EJE 13
2335691649	BLA-2552
3839557577	885 9SN
6559591227	23HE5
9146996311	6YT 049
126192716	7K YC112
732776564	GQL 281
8019125386	ALG-649
9503473457	7-9762N
7133693442	0X 8U0BCJ
6584123888	98I T78
7229017149	920 NO9
4736184751	YKZ 448
6398653847	071-FDW
9227040883	155470
4444840236	71-5958U
8340849477	301 YOS
3379040124	4-A2654
3353910459	HMI-3217
372664422	9ZU 177
3044741010	456 BUU
1696605212	8BR 346
8310140181	806-IYA
5862567248	34-TB96
2405963163	829 CR2
3805259730	382Q
5423426045	4J 70004
2432047308	W20-KPT
4146207898	QEI-0537
88755701	JGM-3687
8857634189	9-3689U
3527198547	562-882
8364776548	79P 8449
1322742292	TZS 355
8829116478	003-CZGF
4655980665	TXP 119
9450326055	GO2 A1M
774018388	5V 20870
35638473	4XU T07
1131481063	3-29745B
892464372	IDG3512
5410788200	5CR7462
4732874142	05-8899A
1043488309	463 HCR
322630381	5K 9958I
9444920339	131407
7311757212	630 RYU
905981696	7-93686
5935103349	181 IOX
4704499976	76H 074
4307758206	JBU-719
9375503471	260 0787
9822909160	FKS5798
4763613033	XMM 522
3702710686	934 OZH
4571600449	672 XTW
1747069123	38EE0
1416717128	8XH D17
58959772	013 GQW
9276619450	KIT-7646
1466699002	3HI 498
8338410957	953CAG
6997303792	UFA6995
420783266	1J 5086X
3642508404	IDU 377
4502284517	47Z 6497
6103775793	6TG2820
7293373731	126-NTO
4676274503	ZHL 199
608794417	FJF 835
5625375383	252 JNU
7967786385	78-OS09
5997162104	OVI V67
1487391158	H79 1HA
2612606326	GAB-6707
1128842781	8448 ED
7595560145	ABY-4730
9876465884	2K 5J6SHE
2078972523	606-DYS
6518682926	OIE-8689
3447539783	9-95446
2939791739	AHY-8188
4932089967	031-WWS
2462977319	OPZ-371
9605355644	LXS-2300
8356732001	MLN 363
3195507526	QXE 489
9575754613	773 VBA
7856208707	7KG5595
7142683736	BW1 3234
448952745	04UV0
6985190702	GBZ 8738
2621194249	G23-RSI
4648159575	55N G71
7528627015	734 JXY
898257721	647BJT
5948807290	97Y Z17
5022233691	QXX2513
476170832	740E
8796604725	PY 1470
4553118554	0PH R91
8665505928	578-ZIG
5908988613	0281 HA
9655273399	6-Z8779
6190058432	0K 3Z9TWZ
7473551270	3-58615
4092795269	IYU-437
3422253034	586 WMG
2452892844	0-0073G
1159738206	CCA 785
6371094633	DPQ-862
6830340144	3-2260K
180019321	E80-MLA
8019686818	GQU-8889
9486924781	7Y 8I7KEQ
9157972870	OMQ-0373
7577536311	6UEH 81
2733625201	5Q 8041F
5583024379	196-IJH
3993497972	371 TSX
5684721851	297-059
2489902354	7N U0957
7270241175	5F TX621
6282869318	65-XC64
3364096073	7-1694W
2764402554	487-TDM
4825420472	686 FMH
1804154393	YU-2902
8135751658	9T 72900
7526293725	378 3HL
5026093530	8I UY907
7160146	C15 4EE
9537618009	01A 9646
9798775759	916 NUU
126192716	G70 3WW
8410715214	21HT781
732776564	7CZT129
3644703085	WQY 234
9503473457	LD 15596
130597914	146-GLZ
9227040883	BNU F71
1420011588	2-92597
937846573	KLI 161
8340849477	05L•150
8743228739	975 LWO
3379040124	853X
3353910459	4C T7368
5248740590	9ZR H83
1764028876	ABV-999
8310140181	4JL 298
5862567248	MDG-2298
7852182166	0KG M67
5235392775	HPM8644
340640279	91L•279
2405963163	IJO-087
2637178822	626 JMF
5423426045	IDE Q02
7489059204	AVO-8514
3009273310	MFN 112
2432047308	457 OGY
5270148403	733-DBS
864035941	K93 5FY
8829116478	HUX5388
5424884955	111-KOY
9142343103	981 ZYJ
1329966052	ZDQ 601
9947134092	LGO 446
892464372	KBY 511
5410788200	DZT 883
2400834682	715-ZRY
8678128651	3RM K37
1043488309	JFK4635
322630381	15-F068
5859254607	566-NQN
3121032579	6-8996Z
7311757212	2A 3C0PYJ
2792693333	95-S381
5870273012	SCY 097
905981696	NKU6307
5935103349	L01 9CC
4704499976	201 0SP
9375503471	VX 65339
4528930905	159 YCL
913536434	3LH0223
5173959718	A04 3IE
3642508404	IQM-226
8707151370	DP 0811
2784926685	B74-EMZ
2429545014	355 8EA
3179826307	598 AZC
6734329635	M93-93F
8381437774	0NJ 213
4676274503	58JP0
8088856438	438029
608794417	5-76967
3930469445	UOU-842
5625375383	OU2 M5A
1772392824	3TN B66
1128842781	900-YHQ
9412159266	923-GJDP
2910680909	Z97-UJS
7595560145	6-66210
5119996624	8F713
2939791739	NFW-9627
4012915395	5-1620E
4932820612	87I 572
3195507526	575-052
470582014	706 3600
9575754613	251 MRD
2477662299	367 UY1
2207904355	3JV 444
6970264341	505 TXG
6064194711	666 HTA
8226190121	75OC6
4648159575	C03 2XV
7528627015	0OC 603
5948807290	HGJ 783
5022233691	2-49570
7101990878	384 UOI
5310232395	6I 30651
3263271429	5OA 432
9138367757	KIL 377
3171217627	7AO 606
4553118554	464L
8665505928	20-X454
1858983270	0-P8239
4092795269	L18 9BR
6142671172	KLW 747
884844920	660 3DC
2894713422	1-K7220
3422253034	LYM 191
2452892844	NGE-8186
2578130768	396-UNI
1933291552	7-0261X
1159738206	F 996293
7787343294	NIQ-0296
6074985303	788 6NV
180019321	73B•578
1289040145	515 5161
7577536311	0Z 05228
3476963805	QJT C42
8473725481	HUI 057
8501017618	QK8 2563
7857918801	RBB 901
5684721851	182M
4763498514	STY-507
4661920872	EXU-1189
2679076606	46-7254L
7270241175	OH 4374
6073273942	KD-2612
9976367840	XSQ 940
3724276361	H28 9KQ
2764402554	V 678591
6610414206	324-NPF
8135751658	1QCZ466
4468550394	HNL 498
5427979566	BGT-8561
2335691649	701747
7160146	4-18231P
2864288118	VSX-185
3839557577	3VY 558
126192716	981VRC
1810788575	F33 0BX
9709892916	870EW
1453385195	AGG8389
1269480706	10GW101
7133693442	5-6003A
130597914	77LQ8
3461209265	535 IK2
7229017149	612 JSE
3290782544	EX2 9328
802290981	93C 2845
2894173575	W21 7IC
3353910459	73-AR24
372664422	172 LQS
2999591912	CQ 88787
3044741010	QOJ 407
7928177958	L98 2ER
8310140181	2520 WF
2405963163	221-LKD
2637178822	H13 6QA
7489059204	ZLF 641
3009273310	SZJ 592
2403811561	H84 5NZ
4146207898	268-718
88755701	9XP E52
3527198547	951 NCT
864035941	6-11208
8829116478	8380
4655980665	05-J219
9142343103	0WN V61
1329966052	54QX5
774018388	643 APQ
35638473	1OU8194
1131481063	0DX5658
9454182811	937 IUU
892464372	2557
5410788200	6G P8070
1043488309	150-AIT
322630381	ALK 807
6686857667	6-W9864
7024211517	721 EGT
9439906248	TLB 614
3121032579	KJJ 310
7311757212	5YOQ 35
5870273012	025 0PJ
905981696	918 XET
1459716828	LWY 178
4528930905	MCO 747
6997303792	VSX 302
5081036892	967 XAQ
5173959718	7QY8840
941216632	50K 0105
3179826307	6HWY 41
4676274503	315YCH
8299278290	HAB 064
8088856438	086 VYW
5625375383	43-19624
1772392824	TIR 293
4838095613	9NT56
2612606326	VVT-313
1128842781	3517
2546797455	BJ 72028
9412159266	LZL-2657
5119996624	1BG S96
3447539783	033DT
2939791739	4V L9931
4012915395	YLX-3258
7816643612	5KH 922
2303564684	05-IF75
4932820612	08R 559
7381244233	VMH 708
7775650608	4N 04973
448952745	FIT 684
6064194711	3641
8226190121	86-7374J
4231155602	36-LF56
5948807290	YJU-467
6373682386	SBG 098
9611758250	B60-VWJ
8796604725	24K 730
5310232395	6PP 383
5565959293	S73-88B
3171217627	012 9681
894661436	F87-94C
8665505928	079Z3
5908988613	076 6339
884844920	795 ETO
2452892844	1799
2578130768	886 RWI
5123711356	578-FYHM
335669174	00R P09
2949004285	0JE39
3418908647	35-67079
180019321	907 YRF
9085377153	818-EAG
9157972870	229KIZ
7577536311	B 272001
7962255301	015 IRX
8473725481	2-50287
8501017618	77N 596
2259767954	33-2862W
7276364644	3NW U44
2967021206	8BB9830
5684721851	31K J90
2489902354	959 PPU
3530133295	CEG-7377
4776207527	BPL-883
450381012	VHU-560
4661920872	YWZ 595
2679076606	0H 98955
7270241175	8IY 250
6683105100	0NM0292
3530147190	78-K824
3724276361	EHE 4075
2764402554	543 GNR
6498661786	NJG-6665
6610414206	MVY 713
6339881175	036K1
787565187	AI 6935
5026093530	N 788808
4468550394	3-66051
7361665685	YY4 2288
8522013978	4T 58052
7160146	095 FQZ
9537618009	I74 4OC
6559591227	6RW6048
126192716	D93-TNA
1810788575	021IYI
7702084276	769-699
9709892916	SVA-1631
732776564	86AX2
8708228336	9BM89
1269480706	SMO 815
9503473457	58O PJ3
3461209265	7Z 6929X
4444840236	ZXT 321
802290981	785 TDP
1152340118	333HLE
8743228739	GEB-2708
2894173575	T 783124
3353910459	5B539
8231770303	PHI-4177
1696605212	ZYA 530
1764028876	0P 8570L
340640279	JGG-6535
7489059204	25O 4226
3009273310	556 FJQ
2636116469	2978 GK
8857634189	ZZA 815
3527198547	398LNJ
8364776548	267 NZR
864035941	SFX 795
4655980665	359 DEQ
2967237942	891 VLG
9450326055	1GZ Q60
5424884955	RBP-661
6619103017	670 WNA
5102878846	YVC-494
1329966052	64-4925J
9947134092	H72 2YK
774018388	34M•017
5410788200	455277
4732874142	MA7 4057
3353679220	O46-QGQ
8623673715	LGW-976
8368649018	MVE 979
3121032579	070-VWK
9444920339	31-FK94
905981696	LYI 915
6200017793	MFU S87
4704499976	ZIP 864
1459716828	902W
1466699002	TDQ-793
8338410957	9562
420783266	1NLF 30
5173959718	7Z 3534Q
2784926685	VFO-811
8088856438	EJD 803
2930274072	238 TNK
608794417	781 1FW
3930469445	DRJ 830
5625375383	89-A279
2612606326	326 JFK
2546797455	575 1HP
7713355859	4GT X73
9876465884	3JQ 654
2078972523	941 KNO
2939791739	40-6718N
4012915395	BDO8119
4932820612	RWO-7493
9605355644	HPR-2951
9286293005	845 MNG
3195507526	EAR 714
9926144611	UEL-550
1342108625	ZT-5655
7775650608	844 2KO
3655765005	07W YE1
448952745	6I PI469
6985190702	GBT6744
6970264341	AJY-9891
1476992639	EXF6194
8226190121	4VAX385
4648159575	617-206
4231155602	016W
6251675679	RAD-7016
5022233691	CFP-340
883631466	047EM
8249163834	84A 238
8796604725	X51 1HP
5565959293	HLU 274
3171217627	351 WMT
4553118554	0IL3153
5908988613	BUX7525
2789420264	SZE-9965
4092795269	Y 653696
3422253034	VT7 Y2W
2452892844	420-OYK
1933291552	XVE-0881
1159738206	179-NLE
7787343294	D65 6VU
6830340144	57W•489
2949004285	816-ZUF
7441937126	701 0KB
1289040145	N09-CVL
8019686818	LGE-9000
9486924781	ALH-469
9157972870	46J QC4
3476963805	SSX 149
7962255301	T78 5KR
8473725481	740 GOJ
2733625201	4Y705
5583024379	625-ZXA
7857918801	CDA-942
2259767954	73D 529
7276364644	O14-56N
2967021206	1OA J97
4776207527	50I 0130
6534683275	69EZ893
450381012	I09-OBJ
4763498514	MQY-242
7413059307	450 VVZ
7270241175	UTW-6872
6683105100	7-1470B
6073273942	0OA Y11
3364096073	4JL 679
9976367840	702XP
2764402554	817K
6498661786	958 6408
6610414206	8-I0181
2370991386	HP8 C7F
6339881175	272 YYR
379817950	FBP 349
7526293725	VGQ 530
4897644477	P84 0AC
4468550394	CWU-1443
3289700877	064 8XT
8522013978	UV 4166
2335691649	KQI-137
8882947224	2VE M49
9146996311	0AS 085
126192716	367 SER
4025235663	9VM O50
7702084276	TQF-695
9709892916	167-IQP
8410715214	982 EWJ
8019125386	WD-4200
1269480706	TY 5461
7133693442	685 QZR
130597914	R50 1NH
4736184751	898T6
9589372090	231 2757
1420011588	725H
4444840236	3KM 696
802290981	K80-ZXB
1152340118	AYV 369
8340849477	542-MTZ
3353910459	53-MO16
2999591912	LDR 808
5465674670	028-BAQL
5248740590	YFF-665
5235392775	4-45012A
3378571562	HS 3074
340640279	9T589
2405963163	9-F8654
3805259730	2-M4064
4146207898	V58 2EN
88755701	LNA 574
2636116469	23C WU4
8857634189	40G 6406
8829116478	RPJ 8340
4655980665	ZXG 094
5102878846	02-S856
774018388	994-CWF
1131481063	MRT 516
3347955749	ZMD 044
6161457669	ESX 218
\.


--
-- Data for Name: drivers_info; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.drivers_info (license_number, full_name, gender, birthday, address_id) FROM stdin;
1459716828	Elie Quipp	F	1975-07-14	1
1416717128	Nicholas Slaight	M	2002-07-12	4
58959772	Morgan Askell	M	1985-02-17	5
4528930905	Kristine Deverock	F	1971-05-27	7
9276619450	Cynthie Roobottom	F	2000-12-16	14
1466699002	Jillian Dimock	F	1966-12-11	15
8338410957	Guthrie Smye	M	1986-11-11	17
6997303792	Julianna Osichev	F	1951-05-03	18
5081036892	Byron Piecha	M	1974-01-07	24
913536434	Ray Connor	M	1960-12-01	30
420783266	Marianne Cocksedge	F	1962-04-26	32
5173959718	Damita Riccardo	F	1955-05-14	34
3642508404	Elysee Zapater	F	1983-01-06	35
4502284517	Teodoor Tydd	M	1955-07-21	39
941216632	Angus Cradick	M	1977-01-12	40
8707151370	Adolf Matschke	M	1982-12-20	41
6330409863	Harmony Coping	F	1990-05-25	46
6103775793	Brandie Vear	F	1942-06-06	51
2251899789	Jed Menico	M	1974-05-13	53
2784926685	Pace Khalid	M	1991-06-12	54
2429545014	Garald Halsted	M	1952-10-13	55
3179826307	Mariana Sharman	F	1944-01-22	56
6734329635	Flem Hardiman	M	2001-05-03	59
7293373731	Farley Adenet	M	1985-06-21	61
8381437774	Solomon Blakeman	M	1945-01-24	62
4676274503	Dmitri Laird-Craig	M	1959-01-18	63
8299278290	Isidro MacNish	M	1998-01-29	64
8088856438	Murvyn Budd	M	1968-08-15	66
2930274072	Adelaide Storres	F	1976-10-06	70
608794417	Bob Kluger	M	1977-10-13	71
3930469445	Augusta Longhirst	F	1949-06-12	73
5625375383	Alejoa McNelis	M	1997-07-17	77
1772392824	Arlin Pendre	M	1946-07-05	78
7967786385	Chevy Kleine	M	1980-03-20	79
5997162104	Myrlene Preshaw	F	1948-09-03	80
1487391158	Kally Lovelock	F	1994-06-17	83
4838095613	Charo De Bischof	F	1961-05-19	85
2612606326	Paxton Landis	M	1970-11-21	87
1128842781	Mireille Galero	F	2000-08-25	89
2546797455	Jareb Arnoll	M	1969-09-22	90
9412159266	Marve Marrows	M	1977-07-30	91
2910680909	Lorry Dunmore	M	1947-01-16	98
7713355859	Sven Moralas	M	1944-11-08	100
7595560145	Rolfe Haversum	M	1990-04-23	101
9876465884	Sigismundo Lavarack	M	1996-09-05	102
5119996624	Salomo Normanvell	M	1985-05-09	106
2078972523	Margeaux Simonich	F	1973-12-27	107
6518682926	Barrett Bucksey	M	1991-08-05	112
3447539783	Eve Gabbidon	F	1957-09-04	115
2939791739	Patin Louch	M	1996-01-28	117
5095740959	Dorrie Mary	F	1962-05-14	120
4012915395	Garv Winsper	M	1994-02-26	121
7816643612	Reginauld Frye	M	1983-03-18	122
2303564684	Ronica Spring	F	1987-01-20	124
4932089967	Rickard Goddard	M	2000-01-22	125
4932820612	Hanny Lambirth	F	1991-09-24	126
2462977319	Flint Murdy	M	1988-12-18	127
9605355644	Geri Van Der Straaten	M	1945-06-28	135
5566286209	Ardella Collman	F	1998-07-13	139
9286293005	Kellen Woltering	F	1986-03-17	145
2810726432	Brittney Nesby	F	1955-12-07	146
8356732001	Fayth Lawrenson	F	1983-08-28	150
3195507526	Alick Tyght	M	1983-08-20	156
9926144611	Gayel Sangar	F	2002-04-02	160
470582014	Nowell Jenken	M	2001-02-19	161
7381244233	Evy Bernardotti	F	1946-08-07	162
1342108625	Crawford Eppson	M	1971-05-29	165
9575754613	Ross Bresner	M	1958-05-23	167
1880381729	Brittni Richardon	F	1964-05-20	168
7775650608	Archibald Myhill	M	1960-04-19	173
2477662299	Lucine Bromage	F	1981-01-31	177
7856208707	Jarrad Buxy	M	2002-10-14	179
2207904355	Osbourn Gilliland	M	1943-02-26	182
7142683736	Ardenia Yashanov	F	1942-03-03	183
3655765005	Damiano Brosoli	M	1961-06-29	184
448952745	Mycah Cortese	M	1983-12-30	185
6985190702	Rudy Haggith	M	1980-11-28	188
6970264341	Wolf Spore	M	1971-02-13	191
6064194711	Oren Remnant	M	1949-04-01	194
2621194249	Carlina Duffree	F	1991-12-10	197
1542285077	Alejandrina Petty	F	1967-12-27	198
1476992639	Howard Aish	M	1987-11-16	202
8226190121	Richart Dresser	M	1968-04-02	206
4648159575	Timi Mengue	F	1980-05-22	208
7528627015	Christoper Yacobsohn	M	1996-03-14	209
4231155602	Heddi Mowle	F	1967-09-28	210
6251675679	Barbie Goddard	F	1976-04-26	214
898257721	Quinton Bonnyson	M	1959-07-11	215
5948807290	Kitti Bagg	F	1981-05-11	217
6373682386	Donella Balassi	F	1944-07-22	219
5022233691	Cirillo Ballintyne	M	1963-11-03	220
9611758250	Ransom Swalwel	M	1979-07-02	222
883631466	Leanna Darcey	F	1987-04-25	227
8249163834	Camel Huggan	F	1947-08-18	231
476170832	Northrop Pideon	M	1990-08-04	234
8796604725	Cordula Fox	F	1969-08-29	235
7101990878	Dennie Moncreiff	M	1947-04-13	240
5310232395	Parker Turland	M	1967-11-07	241
3263271429	Brigg Ramlot	M	1945-07-04	242
5565959293	Kain Goodburn	M	1963-09-25	243
217626543	Zoe Begg	F	1990-06-25	244
9138367757	Izabel Trematick	F	1991-06-17	245
3171217627	Ursa Gerg	F	1987-01-21	247
4553118554	Tiffy Spellacey	F	1958-05-16	248
894661436	Webster Clohisey	M	1996-07-09	249
8665505928	Blair Meale	F	1990-04-14	250
5908988613	Wyndham Terney	M	1972-08-01	252
2789420264	Dale Mauvin	M	1984-09-23	254
9655273399	Dannie Kennington	M	1951-04-18	256
6190058432	Lay Guiot	M	1999-03-05	259
1858983270	Aubrie Lipscombe	F	1948-02-24	262
7473551270	Petunia Folder	F	1975-07-25	270
4092795269	Royce Mourgue	M	1980-08-26	272
6142671172	Berkley Prahm	M	1963-02-03	273
884844920	Lawton Crosi	M	1948-10-27	275
2894713422	Rodrick McAless	M	1951-04-03	277
3422253034	Hart Maddie	M	1950-11-03	279
2452892844	Emylee Lewty	F	1975-08-23	280
2578130768	Annamaria Scones	F	1948-12-10	281
1933291552	Dennie Mogra	M	1960-11-16	284
1159738206	Budd Potte	M	1976-04-24	285
5123711356	Sharl Gatehouse	F	1946-11-28	287
6393833308	Nada Winspire	F	1942-09-15	294
6371094633	Selestina Southerns	F	1969-04-06	302
335669174	Noell Gerritzen	F	1961-09-24	304
7787343294	Fabian Callinan	M	1986-12-26	3
6830340144	Chrissie Gland	F	1998-10-24	6
2461250409	Frederik Northwood	M	1980-03-10	7
6074985303	Andrew Vallentin	M	1946-06-19	9
2949004285	Ab Berthon	M	1974-04-29	12
3418908647	Britt Ference	M	1992-04-16	15
180019321	Paten Giovannacci	M	1977-02-16	16
7848827357	Katharina Cornfield	F	1944-10-23	17
7441937126	Morey Kilday	M	1942-10-13	18
1289040145	Merry Halstead	F	1943-08-23	19
8019686818	Osbourne Concklin	M	1946-03-03	20
9486924781	Peri Grahamslaw	F	1940-06-17	21
9085377153	Valencia Dwyer	F	1968-04-20	23
9157972870	Georgie Bromley	F	1946-07-07	26
5398650693	Dalis Venny	M	1972-08-16	27
7577536311	Lanny Nelligan	F	1995-08-12	31
3476963805	Noellyn Marzelli	F	1946-02-21	32
7962255301	Tucker Pinel	M	1983-12-07	33
8473725481	Eulalie Benzie	F	1986-07-25	34
8501017618	Chickie Henker	M	1983-11-11	36
2733625201	Allyn Hastings	M	1998-04-08	37
5583024379	Leona Bridewell	F	1998-06-15	41
7857918801	Ki Kynton	F	1957-12-22	43
3993497972	Dru Quantrill	F	1950-07-27	46
2259767954	Marrilee Mountcastle	F	1962-10-16	47
7276364644	Rriocard Defew	M	1954-09-29	52
2967021206	Burl Cuncliffe	M	1980-09-03	53
5684721851	Minnie Matovic	F	1977-01-10	54
2489902354	Elsinore Pitfield	F	1981-12-20	62
3530133295	Roscoe Machan	M	1970-06-11	66
4776207527	Isidoro Yurivtsev	M	2002-04-15	69
6534683275	Arie Frazer	M	1979-11-15	70
450381012	Emalee Glassman	F	1984-12-24	72
4763498514	Jo-ann Baseke	F	1982-06-15	78
4661920872	Maure Dahlman	F	1949-04-25	79
2679076606	Egor Bigglestone	M	1995-03-02	80
7413059307	Mella Habbergham	F	1965-06-23	82
7270241175	Desdemona Bontein	F	1984-12-27	92
5262035914	Millisent Giannoni	F	1971-04-24	93
6683105100	Sharai Salazar	F	1985-11-22	94
6073273942	Far Grelik	M	1991-05-04	96
2421418534	Zulema Durnian	F	1989-05-29	99
3530147190	Cecilia Klimshuk	F	1963-12-26	103
6282869318	Cahra Clemmensen	F	1962-05-18	106
1251818586	Gasparo Whieldon	M	1979-08-29	110
3364096073	Gussie Minney	F	1969-04-23	111
9976367840	Chrystal Jarad	F	1945-04-14	116
3724276361	Bastien Cypler	M	1960-04-25	119
2764402554	Jen Sture	F	1969-04-25	123
6498661786	Alvera Sharnock	F	1995-11-05	125
6610414206	Giacopo Frackiewicz	M	1941-11-10	126
4825420472	Debbie Jee	F	1967-02-23	131
2370991386	Carrol McCarroll	M	1974-07-10	134
6339881175	Eziechiele Cregeen	M	1950-11-22	137
379817950	Arnold Parley	M	1967-09-06	140
787565187	Emmye Mephan	F	1986-01-05	146
1804154393	Reade Roulston	M	1989-05-23	148
8135751658	Jarvis Drayton	M	1948-02-28	151
7526293725	Philippa Pratt	F	1954-04-30	152
5026093530	Jammie Gimbrett	F	1949-05-12	158
4897644477	Natala Stearnes	F	1970-01-21	159
4468550394	Anetta Kirkman	F	1967-01-10	164
7361665685	Doralia Kops	F	1997-01-15	166
3289700877	Leona Millyard	F	1952-04-16	170
5427979566	Petronella Yusupov	F	1990-03-02	171
8522013978	Elsa Peterkin	F	1976-08-28	173
6347139126	Dinnie Highton	F	1967-12-05	174
2335691649	Bunny Searby	F	1967-09-10	175
7160146	Roley Fontenot	M	1997-08-12	177
2864288118	Dwight Ingreda	M	1982-04-24	178
3839557577	Kelsey Chittenden	F	1987-10-05	180
8882947224	Wilton Bouldstridge	M	1976-08-07	182
9537618009	Bertram Drewett	M	1945-08-22	184
6559591227	Gerianne Hafford	F	1970-08-29	186
9798775759	Jenilee Hammerberg	F	1944-09-23	188
9146996311	Dottie Rooksby	F	1991-08-13	189
965270194	Vevay Yeldham	F	1942-12-29	191
4374363265	Damita Humbey	F	1952-07-23	192
126192716	Petey Hearsum	M	1981-04-10	193
1810788575	Cornela Rubi	F	1974-04-14	194
4025235663	Brooks Chalcot	F	1976-03-09	195
5123615695	Freddi Legonidec	F	1950-04-01	198
7702084276	Billi Haydock	F	1972-08-13	199
9709892916	Augustine Fenby	F	1970-02-17	201
8410715214	Hamel Bauduin	M	1945-11-03	202
732776564	Cobby Bewfield	M	1974-07-30	204
3644703085	Theresita Ropcke	F	1966-10-14	206
1453385195	Viv Pencot	F	1983-04-14	210
8708228336	Candida Deer	F	1957-07-21	212
8019125386	Esra Deboo	M	1972-10-28	213
1269480706	Saxon Minillo	M	1996-12-06	214
9503473457	Shari Lantiff	F	1999-01-19	217
7133693442	Janot Casel	F	1960-09-09	218
6584123888	Emmett Nickell	M	1968-10-30	222
130597914	Dominic Cerro	M	1957-11-10	224
3461209265	Marcelo Slavin	M	1947-08-19	228
7229017149	Gill Twigg	M	1976-03-06	232
4736184751	Corella Simmonite	F	1941-01-27	234
3290782544	Pooh Romayne	F	1983-03-26	236
279405538	Neddy Caldicott	M	1946-12-30	237
6398653847	Reggis Ellwand	M	1983-03-31	241
9589372090	Dalton Robardley	M	1964-08-24	243
9227040883	Jacquelynn Bellini	F	1964-06-14	244
1420011588	Clyde Benet	M	1996-03-13	245
937846573	Idelle Massot	F	1959-01-26	247
6377673199	Nowell Pinnere	M	2002-11-24	249
4444840236	Elysee Struis	F	1959-09-05	252
802290981	Charisse Teresa	F	1994-06-11	258
1152340118	Kipper Habard	M	1982-03-11	264
8340849477	Silvester Laden	M	1980-03-22	267
8743228739	Imelda Augie	F	1974-12-20	271
3379040124	Matt Gilleson	M	1970-01-04	272
2894173575	Norman Robjant	M	1962-08-25	273
3353910459	Kennett Antonchik	M	1950-03-04	275
372664422	Monah Hinrichsen	F	1976-03-25	276
8231770303	Deb Bourtoumieux	F	1987-07-13	277
2999591912	Madeline Collman	F	1999-08-11	280
3044741010	Lina Lackinton	F	1986-06-25	281
1696605212	Kayley Remmers	F	1970-09-05	283
5465674670	Delila Dougharty	F	1983-10-09	284
7928177958	Arri Huckett	M	1954-11-30	285
5248740590	Alfy Guerro	F	1974-10-14	286
1764028876	West Auton	M	1988-12-31	287
8310140181	Daven Carlsson	M	1954-04-15	290
5862567248	Maryanne Gracey	F	1959-11-12	292
7852182166	Sande Willbond	F	1976-10-23	3
5235392775	Guy McGruar	M	1992-09-05	7
3378571562	Nadean Pellingar	F	1951-09-14	9
340640279	Kaine Geddis	M	1952-07-14	14
2405963163	Jazmin Druce	F	1991-12-07	16
2637178822	Lelia Sommerlie	F	1960-03-30	17
3805259730	Olenka Harrowing	F	1942-04-09	22
5423426045	Pancho Cape	M	1947-06-15	23
7489059204	Jarvis Lambdean	M	1976-09-13	24
3009273310	Marie-jeanne Guterson	F	1967-04-05	27
2432047308	Philis Moir	F	1949-08-03	30
2403811561	Sherwin McManamen	M	1997-05-31	37
4146207898	Ivan Frigot	M	1948-03-16	39
88755701	Giffy Alen	M	1958-05-23	40
2636116469	Gianni Keely	M	1949-03-24	41
8857634189	Wynnie Esilmon	F	1980-06-03	42
3527198547	Cassandra Cousins	F	2003-04-24	45
5270148403	Lindsay Oakly	F	2001-05-06	49
4774880830	Simmonds Weigh	M	1994-02-09	50
8364776548	Jere Tuff	F	1963-01-14	56
1322742292	Asia Borthe	F	1998-05-26	58
864035941	Tracie Ardron	F	1944-05-07	59
8829116478	Sollie Vasilenko	M	1989-01-14	60
4655980665	Vaughan Novkovic	M	1944-02-09	61
2967237942	Leonanie Burgum	F	1947-12-24	62
9450326055	Fan Salomon	F	1963-05-11	66
5424884955	Ninetta Jacquot	F	1990-01-06	72
6619103017	Demetris Dene	F	1984-06-19	76
9142343103	Niven Board	M	1951-10-27	77
5102878846	Hilda Spikeings	F	1992-07-12	81
1329966052	Harmonia Bresland	F	1966-11-02	83
9947134092	Meir Wittke	M	1985-11-09	84
774018388	Hasty Gethings	M	1975-10-20	86
35638473	Germayne Thorold	M	1973-07-31	88
1131481063	Claus Moreland	M	2001-02-15	93
5834492576	Babita Adrienne	F	1949-02-18	94
9454182811	Edmund Meltetal	M	1978-06-04	99
892464372	Theresita Croutear	F	1954-07-08	103
5410788200	Manfred Emeline	M	1988-12-09	106
9161773093	Maxy Gribbon	M	1945-04-20	108
3347955749	Wadsworth Vogeller	M	1946-12-07	117
6161457669	Dominique Sorby	F	1978-12-11	118
6902300103	Tanney Gooders	M	1972-07-06	120
4732874142	Blakeley Ambrois	F	1957-01-18	121
2400834682	Norri Pickthorn	F	1996-05-22	122
3353679220	Corrine Butland	F	1990-05-13	123
8623673715	Arch Valti	M	1991-05-11	124
8678128651	Ulrich Braxton	M	1953-06-13	125
8324074356	Dan Bielfeldt	M	1960-08-05	127
1043488309	Bibi Gammidge	F	1959-08-11	129
8368649018	Heddi Skeates	F	1958-01-18	130
9580907936	Christoffer Whiten	M	1971-01-20	132
322630381	Brandice Chatin	F	1987-05-28	135
6686857667	Abagail Leethem	F	1969-08-23	137
7024211517	Doralynn Wolfenden	F	1969-10-14	138
9439906248	Lockwood MacKinnon	M	2002-04-26	140
5859254607	Bob McGuirk	M	1995-03-08	142
3121032579	Madge Beams	F	1988-10-04	147
9444920339	Marlena Franiak	F	1999-02-07	153
7311757212	Donn Dysart	M	1951-02-17	154
2792693333	Leone Fleet	F	1957-11-06	156
5870273012	Rivalee Errey	F	1965-09-15	158
905981696	Derby Mingauld	M	1975-05-25	159
3294114737	Lesley Plank	M	1993-07-08	160
5935103349	Florella Orteaux	F	1963-05-15	162
6200017793	Ardella Rucklesse	F	1971-08-20	165
4704499976	Toiboid McKinless	M	1952-12-08	169
4307758206	Leora Keson	F	1996-06-29	171
7410093140	Auberta Beddis	F	1974-04-30	175
9375503471	Micaela Milligan	F	1965-04-11	176
9822909160	Giles Farleigh	M	1987-02-12	177
4763613033	Diarmid Chaise	M	1974-12-04	179
3702710686	Hernando Orwell	M	1991-03-15	185
4571600449	Jenica Eam	F	1955-08-13	187
6846316921	Jacquelyn Stickings	F	1946-10-25	191
1747069123	Katuscha Hackwell	F	1941-02-26	192
5825073089	Cullen Eannetta	M	1988-10-09	193
6552147740	Valery Maasze	F	1961-06-02	197
6367520132	Issie MacFarlane	F	1969-11-15	200
3974226192	Broddy Fardell	M	1943-05-14	201
9425780349	Lana Snoden	F	1941-07-12	202
6469958684	Muire Itshak	F	1972-12-22	204
8552045724	Quintilla Camelia	F	1986-07-14	205
8773693820	Charline Blinco	F	1950-10-08	208
6017495036	Melli Cruce	F	1970-05-22	211
7688490905	Allin Mellonby	M	1997-08-07	213
5822776989	Deana Van Niekerk	F	1970-07-02	214
2542775326	Noemi Pollett	F	1961-12-19	217
3719755295	Cass Grimster	M	1962-09-18	220
6470493301	Durand Saffon	M	1985-03-15	221
4321294542	Sonny Gooders	M	1973-05-27	222
2085585714	Ursuline Skeffington	F	1979-06-11	223
5993522031	Ashby Jailler	M	1990-03-31	225
756802539	Hally Morin	F	1968-03-01	227
9173857812	Michele Korneichuk	M	1987-06-09	228
7670247424	Ilse Hulcoop	F	1982-05-08	229
563800014	Irwin Scarlin	M	1988-04-20	231
1696678275	Dianemarie Paunsford	F	1961-08-25	235
2568355083	Mel Mounsey	M	1998-07-24	236
8884510619	Ingeborg Lisciandri	F	1957-11-20	244
8251543769	Rog Attack	M	1998-10-09	245
577979995	Kym Aneley	F	1977-07-15	248
4297457895	Karina Linfoot	F	1940-07-05	250
9738647368	Rubetta Goodbairn	F	1992-10-13	251
9902281331	Derek Pietruszka	M	1998-08-04	254
8423870210	Sigmund Eckly	M	1981-08-17	256
1181125315	Delbert Harly	M	1946-03-25	260
7934520923	Balduin Jodlkowski	M	1953-04-28	261
2764789593	Joe Figgen	M	1976-06-22	263
1952006027	Rourke Arundale	M	1943-03-20	266
8011953517	Dylan Temperley	M	1978-02-05	268
6101057236	Ruthanne Kwietak	F	1942-12-26	279
957731499	Kipp Lynn	F	1979-06-09	281
9191839173	Pauletta Cogman	F	1953-12-23	286
3094918934	Maye Cristoforetti	F	1953-07-17	291
4968307833	Lyndy Trapp	F	1961-07-07	292
989896450	Tadd Spondley	M	1949-06-06	293
804996499	Bennie Horsley	F	1982-08-30	298
8543159550	Jaquenette Moncreiffe	F	1957-11-17	299
2002766320	Fraze Djurdjevic	M	1971-03-08	301
2646738182	Zola Varnam	F	1978-05-30	304
4800186983	Vail Fellon	M	1964-10-02	306
5438413847	Audrie Blow	F	1994-05-01	308
5686799666	Oralie Schuricke	F	1941-09-12	312
249847771	Archie Vinau	M	1968-12-19	313
2649969926	Avie Harmon	F	1955-12-17	3
4838882816	Alina Bowick	F	1984-07-08	4
3089061145	Massimo Hallums	M	1997-07-22	12
9322691843	Alexandrina Dyneley	F	1968-06-09	17
6982982534	Alejandro Sharrard	M	1974-09-03	20
4508933690	Nicolea MacVean	F	1992-06-21	22
5371397855	Bowie Pritty	M	2002-01-19	26
9539029278	Andonis Pagitt	M	1994-08-30	27
7110082730	Winna Denzey	F	1963-11-19	30
8729771940	Crin Ellwand	F	1946-02-23	31
5216220909	Horst Rahill	M	1970-04-18	33
6701862559	Danyette Kingdom	F	1974-10-13	34
5222179661	Agustin Gatchell	M	1983-10-01	39
1836223838	Maddie Summergill	F	1991-08-25	40
6721350826	Maggi Tirrell	F	1988-06-20	43
5009761117	Rustie Radki	M	1974-08-30	44
7381714748	Ricky Jennings	F	1964-11-14	48
6575365429	Brockie MacMaykin	M	1977-05-05	50
1784052334	Norbert Bridell	M	1990-03-13	51
9843583684	Ilise Stucke	F	1961-04-26	53
6037109210	Moyra Purton	F	1945-09-13	56
6446665001	Bill Essex	M	2000-12-19	57
389887010	Worthy Rodenburg	M	1955-07-14	64
5322555125	Jerrome Bode	M	1969-07-26	65
5243217903	Locke Snelson	M	1941-05-26	71
2388078186	Zelma Tootal	F	1974-12-05	74
5478743382	Brenna Hartell	F	1959-01-19	75
3732704829	Robyn Bisco	F	1959-10-30	78
3332722575	York Baggallay	M	1944-09-12	79
1081714249	Ronalda Deetlof	F	1941-06-07	84
2214983081	Gwenny Hazeldine	F	1943-04-07	91
3141189482	Maryjo Exelby	F	1957-04-16	94
4408392659	Karrie Bodicam	F	1940-12-11	99
6339986818	Ezra Lehrmann	M	1959-01-06	102
9616409389	Deane Meffen	M	1989-02-13	103
2682001240	Vanda Membry	F	1952-07-28	110
1132770605	Ab Cardenas	M	1965-05-12	113
9856158584	Genovera Kidwell	F	1998-10-05	114
1390810621	Micheline Guidoni	F	1985-06-10	115
4152306260	Robbi Ceillier	F	1977-12-06	116
314729982	Benedetta Earingey	F	1972-05-01	118
1047321739	Ira Spurden	F	1960-09-08	121
8565139121	Allin Wann	M	1949-06-29	122
3749439461	Shirley Goreisr	F	1972-08-06	123
6434474389	Dredi Doll	F	1965-08-16	125
6592769558	Lynelle Blodg	F	1940-10-21	129
8392658272	Beniamino Rowen	M	1990-07-02	130
9581933943	Faber Rahlof	M	1960-11-16	131
127367233	Zacharias Luna	M	1962-11-20	134
5536165982	Wells Ollivierre	M	1968-08-30	136
6267108624	Germaine Kivlehan	M	1943-12-15	139
1923913752	Barn Duinkerk	M	2001-07-30	141
4120753100	Mitchael Connerly	M	2003-01-31	142
1394412786	Arleen Robertacci	F	1996-06-20	145
6360681210	Jolyn Benedite	F	1970-11-29	149
494026191	Halsey Le Borgne	M	1953-03-02	152
116769727	Yancey Inger	M	1970-01-23	154
4199116452	Mattias Osban	M	1984-10-22	157
1711235175	Rhodie Fagence	F	1949-06-04	159
9823873169	Felicio Coldman	M	1950-08-23	160
3415879917	Freddie Treleaven	M	1988-11-10	161
9515921624	Janet Franciottoi	F	1962-12-30	165
8185797260	Artair Benko	M	1988-02-24	168
83130796	Kerrie Gabbat	F	1941-11-30	169
4315784435	Sterling Passby	M	1985-08-24	178
6843808460	Erinna Knowlden	F	1947-10-03	179
3806382305	Kippie Mackrill	F	1952-03-14	180
1569635919	Karoline Covotto	F	1985-11-21	181
8723599154	Ardis Goulstone	F	1955-05-02	186
1312346459	Eugine Pavkovic	F	1953-10-04	192
4062211951	Deanna De Mattia	F	1972-10-21	194
7638191760	Maryrose Milbourn	F	1978-06-06	197
7688788887	Alfons Leddie	M	1990-07-07	198
3144033844	Tiena Skocroft	F	1972-07-08	200
3134829276	Burty Stidworthy	M	1961-10-03	203
3393639720	Adolph Burdis	M	1980-06-01	204
2626675012	Griff Roddam	M	1982-03-15	206
8749508744	Siffre Halvorsen	M	1998-05-18	208
525221223	Gil Gilphillan	M	1977-03-25	213
7484068903	Shandee Aburrow	F	1943-05-17	214
8230731523	Harald Grishin	M	1952-09-15	215
3967075986	Ford Menichini	M	1988-08-26	220
7045654110	Thaddus McGeorge	M	1963-12-05	222
1824604956	Katlin De Cleen	F	1953-08-22	223
6957794530	Jillie Djokovic	F	1965-01-21	226
6978597544	Brock Lawlor	M	1946-12-25	227
8809156121	Rayna Thaxton	F	1967-05-07	229
3419749517	Marne Tukesby	F	1984-01-13	230
4173108027	Pryce Lefwich	M	1975-11-05	232
9391921193	Brewer Garlick	M	1982-04-11	233
2405718902	Alis Malsher	F	1999-09-12	235
8677600492	Verile Ligerton	F	1955-03-06	236
3881900755	Fabio Burkert	M	1967-02-21	238
8323871519	Ulrick Layfield	M	1962-09-21	242
9134299525	Lauraine Van Hove	F	2003-04-26	245
2211802485	Gideon Serridge	M	1957-11-15	247
1830125070	Gay Linner	F	1969-03-09	249
8253235249	Emma Rowson	F	1958-12-08	251
9898798337	Giorgi Smith	M	1989-03-13	252
6514066475	Cassey Sanz	F	1993-11-24	253
3733288817	Otho Romagnosi	M	1971-02-03	255
3244503724	Celinda Wardel	F	1952-01-06	256
7194701715	Gage Jilliss	M	1965-07-14	258
8271160708	Hewitt Dowzell	M	1948-01-05	259
8054758127	Siegfried Hinchon	M	1944-07-11	260
6954609718	Austen Hubbart	M	1977-08-15	264
3487070618	Bertie Doorly	M	1976-07-15	267
7490381061	Foster Balassa	M	2003-01-03	269
7665822652	Josephina Bilston	F	1943-05-01	275
6118285448	Debee Franschini	F	1941-05-24	277
7930360586	Whitby Grassot	M	2000-03-26	279
3853955643	Ronny Rowbottom	F	1951-07-24	280
7134260216	Zach Elsey	M	1942-03-21	281
6065473773	Maxwell Rawstorne	M	1970-04-29	282
9098643011	Buddie Sherlaw	M	2003-05-14	283
274713534	Patrick Howsego	M	1999-05-27	287
3266500245	Sarina Finch	F	1953-03-20	288
8505300624	Harmon Chesher	M	1998-01-05	291
1212722357	Orton Lethby	M	1994-01-20	292
1008692572	Sandra Gravell	F	1990-12-30	293
5467497226	Abba Grenshields	M	1978-05-23	296
3985190717	Patton Pearn	M	1950-04-18	299
802148736	Verna Zanicchelli	F	1987-07-26	302
3989551988	Alyda Dodman	F	1960-01-06	304
1341805365	Bing Rustedge	M	1996-10-26	305
797126781	Solomon Chapelhow	M	1963-02-27	1
3650541019	Cazzie Pablo	M	1987-05-07	9
8117381011	Desiri Roddick	F	2002-07-20	10
3993405154	Kriste Scarr	F	1975-11-22	15
5742860592	Torrence Cassy	M	1999-04-19	18
5411163869	Ozzie MacAskie	M	1973-01-22	19
2522956589	Maryellen Fordyce	F	1967-03-12	21
9244961839	Jeralee Housaman	F	1978-03-24	22
132838731	Giusto Durbin	M	1978-03-05	23
7439412934	Osbourne Capelen	M	1961-03-11	24
3625850217	Anderson Jinkinson	M	1962-02-04	25
1819014007	Langston Gilchrist	M	1998-06-17	28
5002695237	Codi Stolle	F	1986-08-23	29
6817035386	Ari Eslie	M	1943-02-06	31
6914855985	Shurwood Mulrooney	M	1980-12-03	32
6967581856	Diann Sutherby	F	1978-10-30	33
6660166408	Hoebart Bendelow	M	1950-07-06	34
1162241086	Anatol Irvine	M	1954-09-18	37
686582584	Fionnula Ascroft	F	1995-11-05	41
9760080188	Sosanna Midgley	F	1953-05-15	47
1886931341	Royce Axston	M	1969-03-20	48
2070272362	Aldous Wiersma	M	1964-05-07	50
3953003232	Fidelity Nield	F	1942-09-04	52
6164163247	Alica Pawlett	F	1980-07-20	54
3861095360	Jannelle Santoro	F	1985-01-01	58
5184831604	Galvin Dobbison	M	1970-07-04	59
4031974284	Sabina Lettuce	F	1965-09-18	60
8308148141	Dom Sheircliffe	M	1979-07-12	63
1737783490	Cello Rudloff	M	1961-02-08	65
2718613712	Malachi Winkless	M	1951-08-29	68
5785784758	Emilee Dubs	F	1942-10-01	72
926141658	Derby Boss	M	1979-07-19	73
1319879640	Izabel Skells	F	1989-08-17	75
9264598956	Marianna Schult	F	1999-06-15	76
8646252790	Angie McAllan	M	1972-05-31	77
8280779595	Nannette Follet	F	1941-02-14	78
2476509469	Horten Duddy	M	1969-07-11	80
7391871222	Johannes Sandyfirth	M	1981-08-26	82
7159783227	Rudie Verdie	M	1951-05-15	87
5390176909	Dolli MacKeague	F	1991-03-08	89
7961832281	Ave Lubbock	M	1951-06-21	91
9309873080	Ange Haitlie	M	1970-12-14	93
1369867195	Nestor Moss	M	1966-12-23	96
7229366777	Noella Pinson	F	1941-07-30	101
9405614629	Martelle Brideoke	F	1967-01-05	102
512843460	Asa Eberz	M	1944-11-01	104
9956642448	Howie Consterdine	M	1987-03-01	105
3933759543	Karlen Scrammage	F	1998-03-29	109
6712723805	Felisha Sandercroft	F	1984-11-17	110
3668948102	Sammy Woollam	M	1942-07-14	111
6662873004	Ced Dymick	M	1994-04-09	113
5556060998	Nichole Bythway	F	1958-08-25	114
6741357379	Fonsie Shieber	M	1987-03-17	116
4064601319	Nolie Macak	F	1985-10-19	120
3114016024	Mattheus Giorgielli	M	1957-06-04	121
2979757612	Rhiamon Willgress	F	1977-12-03	124
3761118381	Bethina Koppel	F	1956-04-21	127
6810347532	Katharine Surgenor	F	1978-06-04	133
7119468476	Sansone Shank	M	1984-01-20	134
7188239631	Roseanne Gilbee	F	1946-11-27	135
4979522415	Josi Di Biagio	F	1989-07-01	136
9125533797	Wyn Bettles	M	1950-08-19	137
1687145554	Duffy Pybworth	M	1948-12-15	141
8969338160	Tiena Woodruffe	F	1998-09-22	146
1169741707	Augy Armitage	M	2000-02-05	150
807539109	Jenifer Valentino	F	1976-11-29	154
6327033349	Frieda Culcheth	F	1965-10-19	156
6390421912	Elli Ranns	F	1940-11-05	157
7796172598	Verna Khotler	F	1967-05-09	164
1959878339	Forbes Burgher	M	1995-01-21	167
3217091326	Phillipp Choak	M	1981-01-11	172
7193229013	Sal Gilmartin	F	1984-09-17	175
4983064446	Monro MacInherney	M	1953-08-09	179
7716387873	Pepillo McDermid	M	1961-03-30	187
6463688528	Gerri Pattisson	F	1997-08-22	189
2769684530	Tallie Bownd	M	1990-04-09	190
6602199797	Trueman Menego	M	1978-05-06	193
9873594496	Richart Iddins	M	1952-03-05	197
499625358	Beale Hammel	M	1963-12-22	199
9603710155	Miguelita Moulsdale	F	1968-02-04	200
3468323699	Seka Murrison	F	1986-01-10	201
3341960075	Janetta Gubbin	F	1942-12-15	207
9006355838	Jessika Vakhlov	F	1953-04-08	208
4892521471	Tamas Sobczak	M	1992-06-03	209
7030903319	Mireielle Sanford	F	1941-12-02	210
7958041707	Dulci Lamberth	F	1961-04-22	213
9328950969	Cathleen Croci	F	1953-06-26	214
123148753	Padgett Dronsfield	M	1950-06-30	215
9508547129	Tabby Lehrer	M	1982-01-13	216
6209341005	Nathan Thurstan	M	1946-03-25	217
4535922360	Quint Batting	M	1993-05-22	219
6996913971	Sheeree Mountstephen	F	1992-05-10	221
3429983315	Pattie Pettet	M	1961-11-09	222
4990232675	Allix Hadaway	F	1981-09-17	225
4540228582	Clair Barthelemy	F	1999-09-26	227
525568238	Stoddard Elkins	F	1966-02-03	234
5476189754	Flemming Goor	M	1956-09-14	238
8892249105	Cindelyn Werndly	F	1995-01-10	240
5210340613	Gothart Heninghem	M	1948-11-06	243
2066430137	Bary Hattiff	M	1958-07-11	244
2640789081	Maryjo Dudding	F	1942-12-06	245
9420509316	Dorella Wherrit	F	1957-02-12	249
5538910282	Kahlil Johnsee	M	1992-09-03	252
7250401151	Tami Eagan	F	1965-05-26	256
3758199209	Leigh Felten	M	1982-11-19	257
281310645	Reta Glowacki	F	1991-05-05	258
2611262652	Toma Mein	F	1990-06-25	259
184708181	Jackquelin Punchard	F	1984-01-03	262
3722506039	Davine Sigfrid	F	1989-01-25	263
768877838	Lucy Torrie	F	2003-02-12	264
6584389738	Carolus Sparling	M	1971-05-18	266
5356585379	Andrej Corbett	M	1969-10-25	268
6061435197	Jamie Castanie	M	1987-08-04	270
744249636	Bartlet Drummond	M	1999-06-19	271
1018627716	Wayland Buckmaster	M	1986-10-24	272
2768086881	Elisha Peake	M	1987-10-04	273
3349759839	Mariann Human	F	1948-09-24	275
4550160350	Gaston Westphal	M	1984-03-31	276
2154071283	Jamie Stell	F	1978-04-10	282
2642450886	Dorolice Cantopher	F	1960-03-20	283
2612782714	Vonnie Tugman	F	1961-07-28	288
3689321219	Emmett Kendrew	M	1961-01-30	293
311235075	Gradeigh Rowatt	M	1946-09-15	294
4018384707	Nana Thiese	F	1945-11-20	296
6906743514	Alia Nissle	F	1993-09-16	302
7983193169	Tonie Stinchcombe	F	1961-08-22	1
2419787447	Pavlov Fifield	M	1985-07-12	7
3627904359	Kimmie Hawtrey	F	1946-05-26	12
7640242371	Thorndike Iacopo	M	1971-01-10	15
2894175644	Vergil Algy	M	1957-12-12	16
6253442685	Brantley Turfin	M	1992-03-17	17
3150688890	Aluino de Tocqueville	M	1973-08-13	30
3233875209	Antonius Heimann	M	1966-05-28	31
8502192373	Trixie Shawcroft	F	1996-05-28	33
6242652768	Annadiane Brookton	F	1959-04-23	36
8418158120	Gard Burnard	M	1974-10-23	38
4646681059	Rosetta Marklin	F	1984-05-11	41
4318198660	Juliana Dykins	F	1953-10-16	47
3841215079	Far Allbon	M	1948-03-14	48
7222279160	Reinald Lamborne	M	1994-07-02	49
4106976997	Stacee Toderini	F	1993-05-12	51
7413982327	Crystie Cumberlidge	F	1978-10-07	53
9810221765	Blane Climpson	M	1970-04-26	55
1149768243	Tedda Forryan	F	1986-07-21	59
612370847	Rustie Rodden	M	1975-03-08	60
3058262343	Talia Charlwood	F	1992-07-26	62
5373453567	Carlotta Offiler	F	1955-03-02	64
1887012695	Kathleen Binton	F	1981-03-25	65
1280525734	Giselbert Brompton	M	1995-10-08	68
246515569	Kleon Ixer	M	2001-05-14	69
4034103019	Rebekah Hambers	F	1990-02-25	70
1070845553	Tamma Bettridge	F	1986-10-21	71
7030060247	Hurlee Videan	M	1968-06-03	72
5674190244	Craggie Grzegorczyk	M	2002-05-06	73
2005810528	Bernadette Aldam	F	1961-10-31	74
1073707307	Chev Aberhart	M	1981-10-25	75
1441720750	Addia Hewins	F	1970-02-18	78
1174843032	Richie Gavigan	M	1991-09-12	79
6693698031	Lutero Stickley	M	1941-08-20	84
8056121500	Ainslie Dupree	F	1960-05-23	89
3421852210	Fletcher Sherlaw	M	1945-05-31	90
2638917486	Doroteya Coleby	F	1977-12-23	91
1781064434	Adore Coot	F	1942-11-29	92
7779119916	Gibby Hawkin	M	1952-01-21	93
2431399123	Norbert Morden	M	1960-08-24	95
1892426939	Simeon Massey	M	1949-09-27	99
958615690	Aldis Belleny	M	1993-10-25	102
4507156461	Vicki Gommes	F	1949-10-09	109
8675752895	Danya Richardes	M	1955-05-14	112
7275405563	Shani Antonoyev	F	1975-10-07	115
1439302769	Imogene Spinella	F	1993-05-12	119
2733441411	Wally Reisin	M	1992-10-12	121
334707848	Darelle Ledbury	F	2002-02-02	122
6562698505	Devy Brideoke	M	1970-12-26	124
9507455260	Dre Abelevitz	F	1992-11-19	127
477169592	Leroy Mattheus	M	1946-03-31	128
8007929594	Winfred O'Deegan	M	1989-02-04	130
6113294526	Jess Eldershaw	F	1959-06-05	134
339090452	Bernard Parkhouse	M	1942-11-28	137
8556651282	Wallace Rushworth	M	1984-12-21	139
2491942519	Abie Giacubbo	M	1976-06-11	140
6198207272	Lavinie Gainforth	F	1947-03-02	146
9601992688	Laryssa Perfitt	F	1963-08-31	147
6863972475	Bartolomeo Barton	M	2000-02-13	148
3406594362	Barnett Chitty	M	2002-10-18	151
6901829747	Nicoli MacGilmartin	F	1970-10-15	153
1754318383	Orsa Luisetti	F	1962-02-01	154
1103384683	Martino Nund	M	1940-11-20	158
9153610844	Bidget Shere	F	2001-05-09	159
8552518470	Rosa Glandfield	F	1998-12-31	160
9722955579	Elga Bennedsen	F	1996-08-21	162
7456424605	Charlotta Patten	F	1978-11-08	163
1776330171	Haywood Corpes	M	1942-06-09	167
4755135026	Elke Popworth	F	1966-07-12	168
8854987260	Rosette Mingauld	F	1945-10-21	169
6396916041	Clywd Searchwell	M	1974-09-17	170
7808979617	Nessa Coupe	F	1976-10-28	174
4677850142	Devi Bruniges	F	1969-03-30	175
509204483	Sophia Girvin	F	1993-06-27	179
9585600406	Nananne Bollans	F	1987-07-19	182
5702564314	Georgi Gayle	M	1993-03-18	183
1542132574	Tish Cunde	F	1956-09-07	190
3134639891	Muffin Barus	F	1995-03-22	191
5214112085	Roxanna Boshier	F	1988-05-22	192
3189914851	Arabela Simcoe	F	1940-08-18	193
1555216245	Candace Ambrosini	F	1961-12-28	195
4250253578	Stinky Oxbe	M	1980-03-24	199
9602727590	Gaynor Kabsch	F	2002-06-09	206
7989477082	Ignace Prophet	M	1975-03-13	207
1515756020	Curry Stamper	M	1998-12-17	210
1772494792	Jayme Willmott	F	1967-08-19	211
1401670131	Judas Lynd	M	1980-08-22	212
4115671212	Adelbert Bassill	M	1942-05-15	214
1140819132	Lauryn Jacmar	F	1982-03-13	216
5289618018	Lyon Ivison	M	1989-03-27	218
8595829966	Cybill Lawton	F	1954-11-11	224
1308500796	Verena Cattow	F	1974-09-17	226
8825914574	Lauryn Tingey	F	1986-04-04	227
101532580	Raleigh Eagleston	M	1976-12-10	229
6209865328	Mozelle Gunter	F	1943-08-25	231
6492016807	Kirbie Fasler	F	1958-11-22	234
2959900214	Elmira McGinnell	F	1968-10-11	235
1076425379	Gibb Brann	M	1957-09-10	237
7358735873	Baryram Southerton	M	1949-07-13	238
7391336510	Pieter Kivelle	M	1959-03-06	241
1959291302	Ludovico Labrum	M	1969-03-25	243
4195999491	Katerine Balassi	F	1944-12-01	247
1617729901	Peria Catterson	F	1983-05-02	248
3143542330	Camile Dyers	F	1994-11-20	253
5235736736	Leigha Skermer	F	1944-11-30	254
1586823393	Belicia Farnill	F	1952-06-13	255
3657576585	Conrado Sabin	M	1984-02-11	257
6693751858	Twila Ugoni	F	1946-11-02	258
3881602929	Cyrill Holbie	M	1967-07-30	265
8090515028	Dore Pettegre	M	1942-09-03	269
2308572443	Wynn Stapels	M	1965-11-06	270
3367984260	Lonnard Toothill	M	1956-07-22	273
3049339776	Abramo Corsar	M	1981-06-03	274
6858659400	Dredi Camings	F	1993-12-31	275
7600517301	Carmon Maken	F	1991-11-25	276
9278442350	Kayle Ganter	F	1951-02-23	279
5665305958	Land Pendlebury	M	1973-07-19	284
6785851499	Davidson Kirsz	M	1981-09-09	285
692226546	Rand Wittman	M	1978-09-06	290
9529057962	Conway Greguoli	M	1989-03-08	293
7797638343	Lynnell Wennam	F	1989-11-04	294
4416069104	Filbert Kitchener	M	1998-01-21	296
5563900111	Josie Biles	F	1949-04-17	297
4401973607	Cari O'Bradain	F	1972-09-09	302
3306088217	Starlin Jefferson	F	1999-03-19	303
3388171975	Kenn Arnhold	M	1965-11-07	6
4196176805	Kirstyn Ealam	F	1942-05-23	8
4905662059	Aubrette Romanin	F	1990-01-28	9
9877308010	Nancey Scolland	F	1941-08-18	10
9067660155	Sela Pullinger	F	1944-04-13	12
305102843	Josee Pestor	F	1977-05-10	20
4774026260	Dael Medd	F	1960-07-11	21
6091115496	Michele Trickett	M	1990-06-29	22
1769505267	Alena Estick	F	1974-06-22	24
3152716130	Garvey Mugg	M	1994-09-06	31
5611626865	Carroll Node	F	1952-06-30	32
5747217987	Curtis Chivrall	M	1942-04-22	33
3231313073	Chad Bontoft	M	1977-12-26	34
6088501370	Rosene Faldoe	F	1980-11-27	36
8668622913	Janith Thorndale	F	1982-08-21	37
2542696850	Wallace Venning	M	1977-09-22	39
5849847568	Giovanna Kem	F	1985-02-23	40
9895640438	Tallia Kroon	F	1969-02-13	43
2195364258	Lina Whaites	F	1988-08-04	44
4596354014	Shirl Vasyutochkin	F	1998-01-19	46
3218225509	Estrella Esson	F	1994-04-01	49
1042855648	Heidie Doneld	F	1964-04-17	52
5478358820	Quincey Taillard	M	1991-04-10	55
9579476014	Rona Cufflin	F	1960-12-31	56
5857000049	Sawyere Chesman	M	1951-05-20	58
3107568675	Edd Matthesius	M	1943-03-24	61
8142180750	Ash MacGinley	M	1956-06-13	62
6753103241	Angelina McQuillan	F	1973-12-27	63
2505411226	Ethelbert Treasure	M	1995-04-26	66
4795342600	Harrison Tosney	M	1953-05-04	67
5958424508	Merridie Greig	F	1962-06-28	68
3560878269	Tresa Hillum	F	1966-02-04	73
3904196939	Christiana Aleswell	F	1989-03-30	75
8632564943	Randene Axton	F	1996-02-11	78
1905048446	Babita Genders	F	1991-02-16	80
4472147097	Trixy Heineke	F	1994-04-24	84
6179319520	Rafaellle Plom	M	1965-04-10	85
2309067070	Gary Wards	M	1961-07-16	86
3243349926	Denis Fetters	M	1949-11-20	89
5858214197	Jean McManus	M	1988-10-16	93
9504628634	Happy Tillyer	F	1948-07-02	96
1507265808	Daveta Tinniswood	F	1975-06-03	97
668906409	Jordon Smerdon	M	1968-09-07	99
7824777079	Yard Chadbourn	M	1987-02-09	102
7028433307	Nettle Yter	F	1968-05-17	103
2272696413	Tripp Ashburner	M	1941-07-23	106
957415897	Jaclin Laurenson	F	1942-10-15	111
9031677900	Lynelle Mabb	F	1968-01-08	113
1206035350	Alessandro Kenryd	M	1993-03-09	115
3962533795	Berny Dunster	M	1949-02-08	116
5096325516	Flore Midner	F	1953-08-07	121
8731603620	Ruthie Gainseford	F	1973-11-29	123
2292782476	Ginni Rolph	F	1946-05-15	125
3470999246	Myrlene Bernhart	F	1956-04-05	126
2755428645	Glennis Oddy	F	1989-02-17	129
7516778358	Drucill Bolzmann	F	1948-08-25	132
2533678206	Hamilton Grave	M	1968-08-02	133
382863400	Lowrance Wolver	M	1990-04-16	135
6314502776	Jethro Siddons	M	1965-12-14	139
5997125860	Eleonora Farrans	F	1960-12-11	141
9631271888	Mannie Jerrold	M	1944-04-05	142
8044640951	Dianne MacGilmartin	F	1991-05-14	143
8469482318	Bethany Goodredge	F	1973-12-08	148
3877241713	Ianthe Kyngdon	F	1977-04-23	150
1558671936	Michaela Finlan	F	1958-09-12	152
4604137516	Forrester Brodie	M	1963-03-04	156
7120104062	Malory Budgeon	F	1983-06-07	160
6848191790	Lyn Johansen	M	1948-12-18	161
3620081610	Francesco Kohrding	M	1943-08-09	162
7218490051	Tannie Aynold	M	1960-06-15	165
9455731737	Dosi Haccleton	F	1951-02-05	169
2333259684	Natale Cawsy	M	2000-03-04	172
4910567170	Etienne Balasin	M	1983-12-21	174
3860881554	Franny Rochell	M	1951-09-29	175
3855252058	Ashlie Kellie	F	1954-02-02	177
3614016031	Adolph Dowthwaite	M	1967-06-30	179
2771515792	Pierson Brogden	M	2002-09-03	181
8663519056	Tessi Trumper	F	1947-12-13	185
637427741	Legra Slowgrove	F	1984-02-22	186
5946188824	Burk Dews	M	1945-11-24	187
9656960290	Meta Kaubisch	F	1970-06-26	194
5849273973	Frederico Bamforth	M	1958-10-06	195
6026449359	Brocky Kirkbride	M	1956-10-05	197
5159095325	Robinson Ghiron	M	1962-03-14	201
1780017287	Shane Schuster	F	1944-07-08	205
7621066092	Lanette Leech	F	1965-01-27	209
4104165556	Zulema Lantiffe	F	1970-08-21	210
2595478608	Melba Rhodef	F	1997-12-11	215
2029184025	Bibbye Weatherburn	F	1975-04-23	217
7652940423	Bar Monteith	M	1959-12-18	218
3079338762	Samantha Malden	F	1942-10-11	221
7557342061	Feliks Eldridge	M	2000-05-05	223
2344203558	Joel Lewendon	M	1955-07-02	224
1420549769	Ailee Colman	F	1959-05-23	226
9858493062	Brit Pickle	M	1958-09-06	230
7667956620	Danie Mariel	M	1968-05-07	231
6553467549	Karlotte Kenefick	F	1986-05-27	232
9275439483	Meridith Mason	F	1973-03-16	233
2099521250	Rutledge Whiting	M	1940-05-29	235
8352311742	Tonya Mutch	F	1978-08-22	238
6161664413	Conn Blondin	M	1962-05-09	241
2088988114	Ulric Dewdney	M	1997-12-02	243
6208384852	Dall Hamilton	M	1967-12-21	244
8238793274	Fanny Waything	F	1962-10-03	246
8499501173	Rozalie Ygoe	F	1965-10-22	247
5714100968	Duff McLay	M	1947-09-07	252
6267964293	Sally Harbron	F	1966-07-23	253
9871220299	Britta Stanhope	F	1971-06-28	257
3378491024	Verne Cawthorne	M	1967-10-24	258
4312906809	Leila Segge	F	1949-12-01	261
302780305	Thacher Dunston	M	1981-04-12	262
6338636823	Carmina Posse	F	1979-06-24	263
4663797894	Delano Matyja	M	1978-08-17	265
2607106726	Davon Firby	M	1978-09-06	268
9883665212	Artair Mealham	M	1996-08-03	271
7105870153	Isahella Snar	F	1953-05-06	274
8112763752	Pauline Burdikin	F	1977-04-24	275
3180999025	Georgeta Pavlata	F	1996-12-15	276
4707991551	Lin Getten	F	1998-02-27	283
8281262464	Christalle Jaulme	F	1980-11-03	285
5361729100	Cosetta Opy	F	1982-08-13	288
8822666699	Samaria Mallam	F	1996-12-09	291
4349100247	Wallace Arnoud	M	1985-03-15	293
3399350924	Moselle Broadfoot	F	1991-03-03	294
5817093694	Cyb Tingle	F	1949-12-13	295
328652352	Wilton Ramard	M	1996-07-10	5
3798278387	Mose Rake	M	1997-07-18	11
5816286405	Sigrid Busain	F	1984-01-12	12
6886486967	Prent Doneld	M	2001-02-01	15
8624304404	Claybourne Zink	M	1960-04-12	17
5404819842	Frans Bourdon	M	1947-05-08	19
685911482	Alameda Rundall	F	1994-12-26	20
4652713723	Berkley Jerams	M	1953-09-05	22
8988477556	Rozalie Goldstein	F	1946-04-30	23
3470992286	Konstantine Snuggs	M	1951-10-06	24
4317310075	Silvia Fyndon	F	1990-11-08	25
4638600180	Katee Lanham	F	1956-12-24	28
6121402980	Reinwald Kyllford	M	1940-11-18	29
9577461236	Eadie Vigors	F	1992-05-20	33
9841552798	Essie Embleton	F	1997-07-02	34
9775300436	Tabatha Wharf	F	1968-01-18	35
8243751507	Myrvyn Gulk	M	2003-03-14	39
8061611479	Normand McLoney	M	1993-02-06	46
3666144670	Radcliffe Rookledge	M	1962-08-08	47
9157482080	Curry Twelftree	M	1971-09-15	52
56165573	Adora Meaddowcroft	F	1966-06-25	54
8703289571	Marcel Royal	M	1941-03-24	57
2486401016	Edwina Glentz	F	1974-10-30	58
2507630361	Isabel Matthews	F	2001-09-21	59
6277599406	Katy Bedbrough	F	1975-09-01	61
7066707828	Ximenes Neligan	M	1967-06-08	65
9871252614	Lurline Rolfini	F	1973-11-25	73
6440227761	Federica Blucher	F	1941-01-03	77
779401380	Cordie Hartus	F	2002-09-09	81
2776066120	Claire Rosenberg	M	1963-11-19	85
7433332349	Clemens Chettoe	M	1942-09-27	86
6405324361	Jocelyn Maseyk	F	1952-10-01	90
7783466889	Rozalin Gallimore	F	1943-07-16	95
8065658703	Lynelle Garfield	F	1944-03-01	97
4080684697	Rahel Goudie	F	1965-02-21	100
894065428	Bettina Halgarth	F	1963-06-05	103
8683724253	Newton Barby	M	1946-09-15	104
4241628491	Merrily Burdis	F	1992-06-26	108
6849094824	Ari Aps	M	1963-12-11	110
9164057515	Saundra Sperring	M	1941-07-13	115
1860633800	Bethina Kynston	F	1986-11-23	121
1836674924	Jasmina Sims	F	1993-08-25	123
7499738646	Brady McCluin	M	1941-03-06	125
8282298976	Jeff Sarl	M	1992-01-26	127
1886360475	Lilith Goldstein	F	1942-03-04	128
811917479	Alleyn Castree	M	1942-12-29	138
1484169486	Adolphus Jeynes	M	1949-07-24	139
2818551474	Orsola Mcwhinnie	F	2000-04-13	142
4471974793	Merrill Gilbert	M	1969-10-21	145
4007895510	Ruthann Jon	F	1983-11-28	147
2780964109	Simmonds Scranney	M	1963-03-25	148
8945458758	Melicent Olivari	F	1985-11-02	155
794101424	Wallie Appleford	F	1945-11-29	156
791433446	Karen McGeachy	F	1970-04-16	157
6102629324	Mellisa Ede	F	1972-03-16	164
8104338603	Hi Brabbs	M	1971-12-09	167
4741345278	Daryl Ambrosi	M	1972-09-27	170
241086447	Tish Billett	F	1993-06-14	174
9922830266	Erv Mattussevich	M	1988-07-24	175
9925576156	Etty Stollenbeck	F	1950-02-25	176
5246143849	Ware Lintill	M	2000-10-14	179
8427538359	Anthia Muttitt	F	1948-07-30	182
9550015273	Justen Rawles	M	1973-03-20	185
7989278240	Dayle Pfeffle	F	1968-02-18	199
2234372262	Kahaleel Pettingall	M	1972-03-17	203
5557336453	Piggy Davidofski	M	1942-02-27	204
9782357861	Carole Frude	F	1946-01-17	205
4162692215	Alard Billham	M	1979-06-22	206
7865091707	Raimondo Cleeton	M	1958-12-31	208
8976949532	Eduino Deere	M	1980-01-17	209
5013102904	Janice Bramer	F	1950-07-08	212
3785797044	Keenan McPhee	M	1981-03-01	213
2772851050	Prent Halahan	M	1947-08-15	214
2146845145	Dena Collopy	F	1996-12-14	221
3803332837	Aime Freckelton	F	1945-12-01	226
9074345888	Linzy Louche	F	1964-11-06	228
8927082196	Fanchon Gonsalvez	F	1997-05-31	230
3690431141	Jeffry Astill	M	1994-08-18	232
1463135925	Franny Fraczkiewicz	M	1952-09-10	233
6141342830	Dennet Bohlmann	M	1954-01-04	236
8628308430	Darius Beams	M	1988-03-12	243
5640674892	Nickolas Kinneir	M	1989-07-15	246
3228114198	Merline Chamley	F	1993-05-23	247
4303343735	Clint Philippou	M	1950-02-11	252
7680802882	Mignon Bellay	F	1982-03-26	257
3076557535	Magdalena Yakubowicz	F	1971-08-30	261
5412720409	Leland Imos	F	1956-07-17	267
9387406737	Hilary Mattschas	M	1984-07-31	268
6470000586	Britni Hamshaw	F	1971-09-11	269
620408285	Clevie Wringe	M	1979-01-27	272
9654521916	Jordanna Casini	F	1982-11-14	273
5390377607	Nilson Mullord	M	2001-12-01	274
4943580287	Claybourne De Laci	M	1945-11-23	275
9812216939	Athene McGarvie	F	1996-04-09	278
253730896	Thaddeus Jurca	M	1988-01-29	281
7038865727	Johannes Father	M	1959-01-27	282
1401114039	Tildie Billett	F	1952-08-15	283
6149969677	Danila Cheasman	F	1961-04-07	285
7364334029	Kent Dobbings	M	1971-06-20	286
3769969180	Germayne Stebbings	M	1993-11-14	288
3269906400	Anatola Gaggen	F	1955-04-01	296
5659707373	Heywood Brabender	M	1986-06-26	298
6932730143	Leora Waleworke	F	1954-07-04	300
6672221516	Drusy Blackston	F	1981-03-27	301
1386673675	Wildon Roughley	M	1979-03-18	302
2206013851	Jareb Yelden	M	1999-09-11	303
7277058645	Yelena Schimaschke	F	2003-02-16	305
6464723704	Aldrich Bryden	M	1945-12-01	308
2951439174	Glennis Redhills	F	1957-09-01	309
1401842589	Cristian Youngs	M	1953-06-02	311
1641526414	Tessa Jozwik	F	1959-07-05	313
1545471214	Hermione Kinnier	F	1946-09-23	314
2888823446	Katheryn Sammes	F	1986-01-31	316
3715275035	Kameko Castillou	F	1993-02-27	317
3508836201	Jerrome MacCarroll	M	1988-12-01	318
7036628595	Helene Camilletti	F	1976-01-16	319
9617617345	Claus Rihosek	M	1985-02-08	321
1352040827	Skippie Clews	M	1946-03-19	323
8807064634	Vassily Jeffryes	M	1977-04-16	324
6468892068	Dulcia Vannikov	F	1984-07-23	325
9999122396	Edgar Gilsthorpe	M	1993-10-04	327
1527771583	Janot Flucks	F	1944-02-28	333
564969763	Gilberto McWhinnie	M	1945-08-02	334
5654878129	Melisa Aloshkin	F	1968-07-06	335
8311656793	Gates De la Eglise	F	1943-07-19	336
\.


--
-- Data for Name: drivers_violations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.drivers_violations (violation_id, license_number, license_plate) FROM stdin;
9068USLR	1459716828	9Z512
0659DUWY	58959772	727 JGD
3051JAUH	4528930905	2LU 363
2959FNMR	1466699002	CFZ-382
0671BNMM	8338410957	072 4QK
9050DPSZ	6997303792	BJ6 Y7V
2292PZFD	5081036892	566 JNB
9662PQMH	420783266	QSH-5559
0555KZDH	6103775793	759-HKD
5788TEWX	2429545014	FQS4118
0238OTKQ	4676274503	0U 0335S
8482CESG	8088856438	QDM-2037
6070UMKH	3930469445	RIU 090
1726UEUU	1772392824	CGU4014
7254JYLZ	7967786385	KUM 150
6731ZVRX	5997162104	257-AFM
1535HBLH	1487391158	0ZLD 20
3349ZIAK	2546797455	9ND 607
7625FOSQ	7595560145	60B H04
2413CPXZ	9876465884	RK-4506
2629IBDZ	4012915395	UJN-843
8048YWRO	2303564684	HYK 366
9326PSIW	4932089967	MBR 586
9407AZSX	4932820612	3TD 621
3777TOSQ	5566286209	938 QHJ
4019LVIF	9286293005	122 FYK
8045WWCM	8356732001	760-MKBU
3845FPGE	9926144611	465-HCJ
0461YBIT	9575754613	267 JQV
1893JVVW	7856208707	7UYR078
4091YQNW	6064194711	052 1561
2290KXVE	1476992639	O 923797
3616CYGA	4648159575	LGN-1306
9974TYBR	7528627015	846 4924
1413TYSR	5948807290	374 TK2
1562RIFC	6373682386	E55 3KP
7404DNVC	5022233691	VN 90470
9068USLR	883631466	U95-83Z
0659DUWY	476170832	AQL4744
4901PXJJ	8796604725	502-XPD
0671BNMM	3263271429	N24 2SO
2292PZFD	9138367757	693M
9662PQMH	8665505928	PV5 4900
0555KZDH	2789420264	1-89256
5788TEWX	1858983270	8C 7R6MFX
0238OTKQ	7473551270	BEB1897
8482CESG	6142671172	9-30884
1726UEUU	884844920	15Y 823
6731ZVRX	2894713422	IUM 377
1535HBLH	3422253034	ORA-886
3349ZIAK	2452892844	226 0FR
7625FOSQ	2578130768	FR0 2492
2413CPXZ	1159738206	5Z 7I0WSV
2374RNRL	6393833308	929-XJT
2629IBDZ	6371094633	D 548591
7579YDEH	335669174	6-89908
8048YWRO	6830340144	5OR T08
9326PSIW	2461250409	8SWU 92
9407AZSX	6074985303	Q18 0AF
3777TOSQ	180019321	0S A1011
9175MPUE	9486924781	VJY 943
4019LVIF	9085377153	UDT 336
8045WWCM	7577536311	XKG-9136
3845FPGE	8473725481	7-Q9517
0461YBIT	8501017618	574-AOZ
1893JVVW	2733625201	GTB 435
4091YQNW	2259767954	0IB 803
3895PLZD	7276364644	RFL-2957
2290KXVE	3530133295	M19-91N
3616CYGA	5262035914	3QB45
9974TYBR	2421418534	0-Z0625
1413TYSR	1251818586	6127
7404DNVC	9976367840	YEA-468
2065PCXC	6498661786	6XX 116
9068USLR	6610414206	4-46616N
0659DUWY	4825420472	9ZO P33
3051JAUH	2370991386	TBD-688
0671BNMM	379817950	LJU S70
9050DPSZ	787565187	3-13562X
2292PZFD	1804154393	623 5388
9662PQMH	7526293725	MAS-641
5788TEWX	5026093530	FTF-8420
8482CESG	7361665685	Z44 3DF
6731ZVRX	8522013978	SUR 995
3349ZIAK	7160146	7BP 881
7625FOSQ	3839557577	0B E6144
2413CPXZ	8882947224	1BQ 169
2374RNRL	9798775759	370-AMF
2629IBDZ	965270194	75LM5
7579YDEH	4374363265	NLB-4427
8048YWRO	126192716	416 YTP
9326PSIW	1810788575	5K 8L0QYM
9407AZSX	4025235663	7YM4070
3777TOSQ	7702084276	LNY3441
9175MPUE	732776564	2-61359G
4019LVIF	8708228336	36D JT4
8045WWCM	7133693442	ZZR 318
1893JVVW	130597914	767 PJE
4091YQNW	279405538	QCY 464
3895PLZD	1152340118	OQE N74
5057WCLD	3379040124	74Y M17
2290KXVE	2999591912	1S XY951
3616CYGA	5465674670	HSZ-6396
9974TYBR	5862567248	XY1 2439
1562RIFC	5235392775	LYS 352
5991PXCD	3378571562	26A W31
7404DNVC	2403811561	13I L66
1359XNKA	4146207898	04-J541
2065PCXC	88755701	T99-KBC
3491QDIE	8857634189	68-1035A
6580GSFC	864035941	189 HFU
9068USLR	9450326055	41CU041
0659DUWY	774018388	2C 67350
3051JAUH	1131481063	28033
4901PXJJ	9454182811	8BMP479
0671BNMM	2400834682	GRE-025
9050DPSZ	322630381	1-L0164
2292PZFD	9439906248	GDZ0926
9662PQMH	9444920339	2V139
0555KZDH	7311757212	694 VZ3
5788TEWX	3294114737	4961 IV
0238OTKQ	5935103349	WLQ-8090
8482CESG	6200017793	5UQ 943
6070UMKH	7410093140	44-HC56
6731ZVRX	9822909160	4WEJ 70
3349ZIAK	1459716828	401AW
7625FOSQ	58959772	53-N511
2413CPXZ	9276619450	LYP 869
7579YDEH	1466699002	F08 4EV
8048YWRO	913536434	LKB 959
9326PSIW	420783266	QB-6655
3777TOSQ	3642508404	THX 215
9175MPUE	941216632	5M DX778
4019LVIF	8707151370	2S 9Q8TCY
8045WWCM	6330409863	1MUT 21
3845FPGE	7293373731	KGN 691
0461YBIT	8381437774	96QA623
1893JVVW	8299278290	TIX-774
4091YQNW	3930469445	ICQ 879
3895PLZD	5625375383	DUQ4085
5433QFAY	4838095613	JHM-238
5057WCLD	2910680909	3VN45
2290KXVE	7595560145	SZU 900
9974TYBR	9876465884	0UB5012
1413TYSR	2078972523	225 JCO
1562RIFC	2939791739	226 WWG
5991PXCD	4012915395	75U V05
1359XNKA	2303564684	CDC-924
9068USLR	4932820612	YW 21591
0659DUWY	5566286209	CBQ4730
3051JAUH	3195507526	2K TJ446
4901PXJJ	470582014	LDC6930
2959FNMR	1342108625	DST 217
9050DPSZ	1880381729	1DJ X06
2292PZFD	7775650608	RQQ 703
0555KZDH	7856208707	568 BOL
5788TEWX	2207904355	NIP-6327
8482CESG	3655765005	894KK
6070UMKH	448952745	BEE 770
1726UEUU	5948807290	XX8 T1G
7254JYLZ	476170832	HCI 343
1535HBLH	8796604725	511 RWL
3349ZIAK	3263271429	15-HM06
7625FOSQ	6142671172	8-86297P
2413CPXZ	884844920	4AB0480
2374RNRL	2894713422	574 JIM
2629IBDZ	6393833308	7925 VH
7579YDEH	6371094633	32N G07
8048YWRO	7787343294	6PR 858
9326PSIW	2461250409	672 5MR
9407AZSX	6074985303	HQF 124
3777TOSQ	7441937126	661-IYN
9175MPUE	9085377153	4SS 130
4019LVIF	2259767954	ALZ 108
3845FPGE	5684721851	82-ME02
0461YBIT	6534683275	820 6ND
4091YQNW	4763498514	BTN-572
3895PLZD	2679076606	538-HLN
5433QFAY	6073273942	088-JED
5057WCLD	2421418534	5-C5151
2290KXVE	3364096073	925 UXM
3616CYGA	3724276361	16K 993
9974TYBR	2764402554	544
1413TYSR	6498661786	PMY-3580
1562RIFC	4825420472	WFT 351
9068USLR	379817950	0FUI 92
0659DUWY	787565187	ENL-8366
3051JAUH	1804154393	4IZ R94
4901PXJJ	7526293725	85-9958S
2959FNMR	5427979566	52J Q78
0671BNMM	8522013978	IUH-070
2292PZFD	6347139126	9OD7099
9662PQMH	2335691649	IRJ4061
0555KZDH	3839557577	199 0QS
5788TEWX	8882947224	MGN 374
0238OTKQ	9537618009	984 WZZ
8482CESG	6559591227	920 LGZ
6070UMKH	9798775759	IXG-3377
1726UEUU	965270194	GA 2048
7254JYLZ	1810788575	HSS 135
6731ZVRX	8410715214	5HKQ 97
1535HBLH	732776564	H 717865
3349ZIAK	1453385195	29W B12
7625FOSQ	8708228336	QKL-2115
2413CPXZ	8019125386	73-28679
2374RNRL	6584123888	2BE79
2629IBDZ	3461209265	3KJF834
7579YDEH	4736184751	876 BMI
8048YWRO	6377673199	JRG 190
9407AZSX	802290981	ZGU-170
3777TOSQ	3379040124	609 BEW
9175MPUE	2894173575	12-J856
4019LVIF	372664422	9V 0E7TFM
8045WWCM	1696605212	39-4352N
3845FPGE	5465674670	729-ZOG
0461YBIT	8310140181	0CT E37
3895PLZD	5862567248	BA-8605
5433QFAY	3378571562	GD-2434
2290KXVE	340640279	MAE 821
3616CYGA	2405963163	5JE6549
9974TYBR	5423426045	035DR
1413TYSR	3009273310	EG6 T4J
9068USLR	3527198547	MDN 148
0659DUWY	1322742292	427-AKK
3051JAUH	8829116478	685VJJ
4901PXJJ	4655980665	UX 6663
2959FNMR	2967237942	65-L073
0671BNMM	9450326055	6M 8N4WZH
9050DPSZ	5102878846	L76-44F
2292PZFD	1329966052	6IX04
9662PQMH	35638473	YAI9366
0555KZDH	5834492576	7I BO383
0238OTKQ	4732874142	127 MOD
8482CESG	2400834682	276 NHZ
6070UMKH	8623673715	W39-HNO
1726UEUU	8678128651	0VR1058
7254JYLZ	8368649018	D78-89Y
6731ZVRX	322630381	2X CH591
1535HBLH	9439906248	X12-42Y
3349ZIAK	5859254607	HGW-0660
2374RNRL	3121032579	MOK 536
2629IBDZ	9444920339	577-UTK
7579YDEH	7311757212	YRD-6112
8048YWRO	5935103349	780-107
9175MPUE	4704499976	921-NNIU
4019LVIF	6017495036	XVX-1687
3845FPGE	7688490905	FS 4755
0461YBIT	2542775326	886 FKO
1893JVVW	4321294542	ISV 533
4091YQNW	2085585714	495 ISP
3895PLZD	9276619450	743-KJS
5433QFAY	913536434	KKG 293
5057WCLD	4502284517	8MB71
2290KXVE	941216632	EPI4806
3616CYGA	2784926685	63-97656
9974TYBR	8381437774	9GXK 13
1413TYSR	2930274072	LM 24090
1562RIFC	3930469445	BHS-5622
7404DNVC	5625375383	NBQ-4863
9068USLR	1772392824	9F F2690
3051JAUH	4838095613	AOS-829
4901PXJJ	2612606326	177TCO
2959FNMR	1128842781	70C W31
9050DPSZ	9412159266	2XY3473
2292PZFD	2910680909	1F 78928
9662PQMH	5119996624	809 UBB
0555KZDH	2078972523	WCI 038
5788TEWX	4012915395	FOP-4832
0238OTKQ	9286293005	2401 DR
8482CESG	1342108625	BHX 924
1726UEUU	9575754613	U98 6YR
7254JYLZ	1880381729	181 BFU
3349ZIAK	7775650608	106 YIJ
7625FOSQ	7856208707	ADU-732
2413CPXZ	7142683736	68R•376
2374RNRL	2621194249	I56 5DY
2629IBDZ	8226190121	2R 88330
7579YDEH	7528627015	60U Z91
9326PSIW	5022233691	220-FIX
9407AZSX	9611758250	84-WC27
3777TOSQ	883631466	800 PML
9175MPUE	8249163834	9MI 839
4019LVIF	3263271429	302FBQ
8045WWCM	5565959293	939 7924
0461YBIT	3171217627	3RX4731
1893JVVW	4553118554	179LU
4091YQNW	8665505928	MXS 588
3895PLZD	2789420264	794-XFB
2290KXVE	6190058432	ORH 676
3616CYGA	2452892844	802 FV7
9974TYBR	2578130768	281 PZZ
1562RIFC	1933291552	7G 8649R
5991PXCD	1159738206	ZXS5691
7404DNVC	6393833308	224 NGD
1359XNKA	7787343294	YKH-6327
3491QDIE	6074985303	107-VDR
6580GSFC	1289040145	7-J6658
6489LABM	9486924781	140-BAL
8223JORF	9157972870	6DN G71
9421DZOJ	7577536311	575 VZ6
\.


--
-- Data for Name: vehicles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vehicles (license_plate, frame_number, model_id, color, category) FROM stdin;
9Z512	5TDBY5G10ES769759	40164WNEOG	Blue	motorcycle
727 JGD	5NPDH4AE1DH121155	53378QJKHO	Green	car
2LU 363	5XYKT3A13CG401677	23451TJCEZ	Puce	track
CFZ-382	WAUPFAFM1AA112019	01113NKLFK	Purple	track
072 4QK	WAUKC68D61A340935	60463ILRGE	Orange	car
BJ6 Y7V	WAUEFAFL3AN215188	37248SVQFP	Red	motorcycle
566 JNB	WAUKFAFL8EN066432	56414TXOMM	Orange	track
QSH-5559	1G6AX5S3XF0606342	96905DGNXV	Goldenrod	car
759-HKD	JA32X8HW8DU972423	02228NOJUO	Goldenrod	track
FQS4118	3C3CFFER8FT289943	28607PJGVG	Mauv	track
0U 0335S	WA1CGAFE9BD098324	18796ERGBK	Indigo	motorcycle
QDM-2037	1GYS3FEJ9BR330488	91840ABVMY	Indigo	track
RIU 090	5UXFH0C55BL445005	92744LJUVI	Fuscia	motorcycle
CGU4014	2T1KU4EE2CC798634	84468GNBMX	Red	track
KUM 150	1G6DK8E39C0221875	01632YTQRY	Aquamarine	motorcycle
257-AFM	WA1CV94L59D159944	20001CNUCM	Puce	track
0ZLD 20	SCBFU7ZA7EC145533	08632RNFSU	Orange	motorcycle
9ND 607	5GNRNGEEXA8735545	10730DSLOA	Teal	motorcycle
60B H04	2T1BU4EE4DC219466	01069YZYOM	Red	motorcycle
RK-4506	WBAPH5G56BN002361	93631DXDQC	Puce	motorcycle
UJN-843	1GYS3MKJ9FR793276	71238ESJEJ	Green	car
HYK 366	1G6D05EGXA0764995	34023FWZNL	Red	track
MBR 586	2HNYD2H24DH763613	28811ZYSRG	Pink	car
3TD 621	1GYFK43888R860579	96500CPHGX	Mauv	car
938 QHJ	WBAKF5C59DJ644217	59647CBAND	Turquoise	motorcycle
122 FYK	KMHHT6KD8EU731848	60338HTOHB	Green	car
760-MKBU	2G4GK5EX0E9098239	81920YVSAE	Crimson	motorcycle
465-HCJ	SCFAB42341K991367	49477YFEAB	Orange	car
267 JQV	5UMBT93537L901668	23876VQUMS	Mauv	track
7UYR078	WAULT68E43A089008	38793DFDZW	Blue	track
052 1561	JTDZN3EU2EJ635857	79980VVMYB	Teal	motorcycle
O 923797	4A4AP3AU5DE846712	56779CCSNT	Indigo	car
LGN-1306	JTEBU4BF2DK987020	97911PYRMW	Green	car
846 4924	JA32X8HW4AU159155	71631FGPBA	Orange	car
374 TK2	WAUXL58E35A170516	98550RDWNQ	Indigo	motorcycle
E55 3KP	WBAHN03597D690505	07267DLTLH	Mauv	track
VN 90470	1GYFC332X9R083875	67338SQJJE	Yellow	track
U95-83Z	3N1AB6AP1CL847164	17155CLUQS	Fuscia	motorcycle
AQL4744	1FTWW3B50AE706910	05321NYVGE	Puce	motorcycle
502-XPD	WBA5A7C53FD623940	34875VFWSA	Orange	motorcycle
N24 2SO	5J6TF1H36FL972218	51518DIAML	Fuscia	track
693M	1G4CW54K554853901	01714QMQHX	Khaki	track
PV5 4900	WAUDF78E96A170589	15822YJLBV	Yellow	motorcycle
1-89256	WBA3B9C52FJ203295	83776IGTGU	Khaki	car
8C 7R6MFX	WBANV9C56AC086317	69434QYOWH	Purple	car
BEB1897	1G6AR5S35E0857455	27879YNWWM	Pink	track
9-30884	WAUWFAFR0AA486502	93608NWYHE	Indigo	motorcycle
15Y 823	1G6AH5S35F0997994	69035FZZMK	Aquamarine	motorcycle
IUM 377	WAUXL58E35A519741	48718CCRSJ	Pink	car
ORA-886	JHMZE2H52DS656570	81530MDQXF	Turquoise	track
226 0FR	WBSKG9C55DE397545	89750MWNEU	Green	motorcycle
FR0 2492	1G6DN57S740900474	29840EVFVM	Khaki	motorcycle
5Z 7I0WSV	2T2BK1BA9CC920200	14002KPACE	Teal	motorcycle
929-XJT	1G6DK5EG3A0700386	77217ASFFK	Orange	car
D 548591	1G6DM5ED8B0444599	17544BCCTL	Khaki	track
6-89908	WBAYF8C51ED198785	53430LBGSB	Violet	motorcycle
5OR T08	WA1CGBFE4CD054366	26215FUNML	Red	car
8SWU 92	WAUEFAFL4FA157543	88568FGBBK	Green	motorcycle
Q18 0AF	1C4SDJCT3FC056451	35636YSGBO	Turquoise	track
0S A1011	WAUSH74F67N045429	25464WPLFL	Khaki	motorcycle
VJY 943	1N6AA0CJXDN978873	34124DGLIB	Maroon	motorcycle
UDT 336	WBANB335X5C832845	62596JFYYZ	Teal	track
XKG-9136	1D4RE5GG4BC603675	58957MHLES	Maroon	car
7-Q9517	2G4WC562751300617	96699ZLXZH	Puce	motorcycle
574-AOZ	1C3CDFBB0FD621022	73053NCNHC	Red	car
GTB 435	WAUBNAFBXAN163586	56166TDASC	Maroon	track
0IB 803	WBALL5C59FP111121	93627VLEBL	Mauv	car
RFL-2957	3GYT4LEF4CG652999	68606YKXRE	Turquoise	car
M19-91N	1FTSX2A55AE142310	99911CRPDM	Puce	motorcycle
3QB45	1FTWW3DY5AE766060	38409WIKNY	Orange	track
0-Z0625	JTDKN3DP7E3883166	24420EITWE	Red	car
6127	3VW507AT7FM423491	04264CAJBV	Violet	motorcycle
YEA-468	JH4CW2H52DC211260	43058OCOIQ	Teal	motorcycle
6XX 116	3N1BC1AP1BL504454	39641ZUOIF	Crimson	track
4-46616N	WBABD33434J237432	97059ZMQPM	Goldenrod	motorcycle
9ZO P33	SCFEBBCF0CG984503	61651XANQI	Maroon	car
TBD-688	5NPDH4AE6EH465338	59215SXHHX	Teal	motorcycle
LJU S70	SCFEBBEL0DG333828	26638YQZKL	Pink	track
3-13562X	1D7CE2GK5AS521499	88149HIAOX	Mauv	track
623 5388	WA1YD64B05N310529	66764WWWJX	Violet	track
MAS-641	WAUVT58E72A427034	24888OHNWO	Goldenrod	track
FTF-8420	3D7TP2CT3BG705051	76134WVQWH	Indigo	car
Z44 3DF	3GYFNGE34DS312712	01816IQQXB	Mauv	track
SUR 995	WUALNAFG6EN952703	22460KMGLF	Crimson	track
7BP 881	WBAVB335X6P423660	34838ATQWJ	Fuscia	track
0B E6144	5UXWX9C51D0775896	26117IVOWV	Indigo	motorcycle
1BQ 169	W04GP5EC5B1796665	30270OTWAZ	Pink	track
370-AMF	2G4GP5EX7E9974628	80426XMFNQ	Goldenrod	car
75LM5	SCBBP93W59C164657	99443FNBMC	Green	car
NLB-4427	2C4RRGAGXDR260578	17938VKVHW	Fuscia	motorcycle
416 YTP	WBA3R5C58EF486551	21214JLXTG	Khaki	motorcycle
5K 8L0QYM	5N1AA0ND0FN916911	52316ODVUI	Aquamarine	track
7YM4070	JN1BJ0HR7EM069599	36354QYTKE	Teal	car
LNY3441	5FRYD3H21EB504286	98264UNIZW	Aquamarine	car
2-61359G	1G6DW67V290805938	40636CIOKK	Aquamarine	car
36D JT4	2HNYD28628H326332	38812NDHMB	Pink	car
ZZR 318	1GKS1AE00CR223082	90228VRHSD	Goldenrod	track
767 PJE	WBAAX13414P170544	11227TZKBE	Fuscia	track
QCY 464	JH4NA21653T740243	62216RPJRT	Goldenrod	track
OQE N74	3FADP4AJ6EM362291	51696DPHDB	Teal	track
74Y M17	JN1CV6FE8CM391032	77209FYEAY	Indigo	track
1S XY951	2G61R5S34F9428976	98366HVUNT	Pink	motorcycle
HSZ-6396	1G6DN57S540029428	96926WJPQG	Orange	car
XY1 2439	1GYFC26249R308023	96412CDNHL	Khaki	track
LYS 352	3N1AB7AP1FY832029	92659KLGRG	Aquamarine	motorcycle
26A W31	WAUVT58E75A049480	90327VJIXZ	Green	track
13I L66	3VW507ATXFM914900	97312OCMVK	Yellow	track
04-J541	WUARL48H99K142156	89496WYPEF	Purple	track
T99-KBC	3C6TD5JTXCG062309	18086MDFGS	Goldenrod	car
68-1035A	19UYA42431A095061	79597KCPEF	Purple	track
189 HFU	1G4HF5EM0AU612702	03760TBJHC	Orange	motorcycle
41CU041	3C3CFFDR8FT560243	98261WJIOX	Red	motorcycle
2C 67350	1G6KS54Y84U679453	74600EMJHG	Teal	motorcycle
28033	WAUJC68E74A340239	61812ZTTXW	Pink	car
8BMP479	JN8AE2KP0D9638895	22341UYFKA	Teal	car
GRE-025	19XFB4F28DE796675	69256QAEGN	Blue	car
1-L0164	1G6KS54YX2U312230	64195GRKOT	Pink	car
GDZ0926	WBSWL93548P874537	17985LGROF	Violet	motorcycle
2V139	WBAVA37588N345892	42516QUOZQ	Goldenrod	car
694 VZ3	YV1902MC3F1975659	79679IYBAE	Pink	track
4961 IV	TRUTC28NX31426458	98202NZZPA	Puce	car
WLQ-8090	1N6AF0LX3FN556968	81808MJGXE	Goldenrod	motorcycle
5UQ 943	2B3CA9CV0AH603356	41154DWFZS	Goldenrod	track
44-HC56	WAUEG74F76N182541	99586HDGOW	Puce	car
4WEJ 70	JN1BJ0HP7FM194120	04949HVCNU	Yellow	car
401AW	WBAGL634X2D449038	53378QJKHO	Teal	car
53-N511	1GYEC63888R648124	23451TJCEZ	Teal	car
LYP 869	WBAHN835X6D872355	62766JSYLC	Aquamarine	motorcycle
F08 4EV	1G4HG5EMXAU791568	66271XGYSA	Fuscia	track
LKB 959	3GTU2YEJ4DG705266	56414TXOMM	Turquoise	motorcycle
QB-6655	2C3CCAST8CH968563	91840ABVMY	Purple	car
THX 215	JH4CU2F66CC302063	35092HVVHN	Orange	car
5M DX778	WBA4B1C54FG647555	47106DGXAW	Yellow	motorcycle
2S 9Q8TCY	2C3CCASG6DH217367	90807DLJUO	Pink	track
1MUT 21	5NPDH4AE4FH126174	74669OTCAS	Blue	car
KGN 691	WBANE73576C708077	83458QDVDE	Red	car
96QA623	1G6AM5S39F0742955	08632RNFSU	Green	track
TIX-774	SALFP2BNXBH010381	12614ZCXKU	Maroon	motorcycle
ICQ 879	4T1BF3EK4BU998230	94575NAUET	Indigo	car
DUQ4085	3D7TT2HTXAG222059	10730DSLOA	Purple	track
JHM-238	1G4HR54K74U426392	15202DNKVY	Mauv	track
3VN45	JN1AZ4EH6FM592413	73312ULUTY	Turquoise	motorcycle
SZU 900	WA1CGBFE4CD077145	59647CBAND	Green	car
0UB5012	5UXFG8C5XBL895735	37467VPAWA	Crimson	track
225 JCO	1FTEW1CFXFF041698	60338HTOHB	Goldenrod	motorcycle
226 WWG	1G6AP5SX1F0831476	99103NUVEJ	Blue	motorcycle
75U V05	1C3BC1FB4BN012886	05760HYIEE	Yellow	track
CDC-924	JN8AS5MT9DW593607	38793DFDZW	Yellow	car
YW 21591	WAUKG94F86N026930	73286WMKRD	Puce	motorcycle
CBQ4730	JM1CR2W34A0816856	12633KZZMC	Blue	car
2K TJ446	5TFCY5F1XCX841564	73042PEHKW	Teal	motorcycle
LDC6930	5GAEV237X8J180848	71631FGPBA	Indigo	motorcycle
DST 217	1N6AD0CU6FN314669	98550RDWNQ	Puce	car
1DJ X06	WAUFGBFCXEN013963	67338SQJJE	Blue	motorcycle
RQQ 703	1FTEX1CM2BK088401	51518DIAML	Aquamarine	motorcycle
568 BOL	WBAKB83519C856912	01714QMQHX	Purple	motorcycle
NIP-6327	WBAPM7C50AE753046	58104HOATM	Puce	car
894KK	19UUA65595A554582	69829RLUQU	Red	car
BEE 770	1G6KD57Y59U657388	18821PMCLI	Green	car
XX8 T1G	WAUAFAFC4CN034716	69434QYOWH	Yellow	car
HCI 343	WDDEJ7GB2AA387087	93608NWYHE	Maroon	motorcycle
511 RWL	3D4PG5FV2AT938700	69035FZZMK	Goldenrod	motorcycle
15-HM06	1FTSX2A56AE396303	29840EVFVM	Pink	car
8-86297P	1HGCR2E70EA417044	64856ZCAXS	Orange	car
4AB0480	4A31K3DT9BE198570	17544BCCTL	Khaki	motorcycle
574 JIM	3N1AB6AP7CL028465	94539KOZBG	Maroon	motorcycle
7925 VH	JTHBK1GGXE2924919	53430LBGSB	Red	motorcycle
32N G07	2HNYD18202H170564	09569XHRII	Yellow	car
6PR 858	WA19FAFL6DA917046	09790NICKX	Red	motorcycle
672 5MR	W04GN5EC8B1494356	25464WPLFL	Indigo	motorcycle
HQF 124	WBAEK73425B151292	81271PUFQU	Maroon	motorcycle
661-IYN	WBAWL73588P614635	27608ETLDK	Blue	car
4SS 130	WAUBGBFC8CN620553	96699ZLXZH	Goldenrod	track
ALZ 108	WBA3B5C53EF560351	48748VTWRF	Green	motorcycle
82-ME02	4T3BA3BB8FU787287	36792DRGYA	Turquoise	car
820 6ND	WAUML44D92N638828	93627VLEBL	Turquoise	track
BTN-572	SCFAD02A75G131375	68436EWCFD	Turquoise	track
538-HLN	1GYS3HEF5DR192541	15304TERJH	Yellow	track
088-JED	5TFCY5F10CX565668	04264CAJBV	Yellow	motorcycle
5-C5151	WBAPN73589A699706	07764LBAXP	Puce	track
925 UXM	JH4DB75571S086212	26638YQZKL	Indigo	motorcycle
16K 993	JN1CV6AR8FM342959	88149HIAOX	Blue	motorcycle
544	KMHTC6ADXFU611840	22157EXBKO	Blue	track
PMY-3580	2T1BURHE9FC806841	66764WWWJX	Orange	track
WFT 351	3TMJU4GN5EM638878	18956MZLME	Red	car
0FUI 92	1GYFK46818R087062	54168EHJTJ	Teal	track
ENL-8366	1FTMF1C88AK040689	30270OTWAZ	Violet	motorcycle
4IZ R94	2C3CDZFJ5FH324804	02990FMDIG	Teal	car
85-9958S	4T1BD1FK6EU217883	77967BWOSE	Pink	motorcycle
52J Q78	1N6AF0LY7FN488490	21214JLXTG	Aquamarine	car
IUH-070	2C3CCAEG6EH203207	05712RDYPD	Blue	motorcycle
9OD7099	WA1LFBFP4EA863634	59209BOWWM	Green	car
IRJ4061	2G4WS52J851649401	38812NDHMB	Crimson	car
199 0QS	WBAYG6C54FD439824	11227TZKBE	Maroon	track
MGN 374	WBAPT73539C686632	68599NGPQV	Turquoise	track
984 WZZ	WBASN2C55CC824945	51696DPHDB	Fuscia	car
920 LGZ	1GYS4JKJ6FR113832	32507VMQCD	Khaki	track
IXG-3377	WAUAVAFD9BN110876	57372EXCNW	Crimson	car
GA 2048	2T2BK1BA9FC768908	96926WJPQG	Teal	motorcycle
HSS 135	WAULT68E52A167472	96412CDNHL	Khaki	track
5HKQ 97	WBASN2C57DC859715	41591FUGWU	Teal	car
H 717865	1G4GC5GGXAF961771	64439FBUIU	Puce	track
29W B12	1B3CB3HA1BD400782	46617WKRYE	Crimson	motorcycle
QKL-2115	1N4AL2AP6CN572089	59568WVYAE	Khaki	motorcycle
73-28679	1N6AA0EC5FN357302	87520JSKOK	Pink	track
2BE79	1G6DM5EY7B0015909	98261WJIOX	Goldenrod	track
3KJF834	1GYS3BKJXFR886540	91252GQRXA	Yellow	car
876 BMI	WBAEN33445E935911	74600EMJHG	Pink	motorcycle
JRG 190	2HNYD18644H795488	63662IFOJF	Teal	track
ZGU-170	5J8TB4H33DL263635	61446CYJBC	Fuscia	motorcycle
609 BEW	WA1MYBFE8AD630880	96167IROLX	Aquamarine	motorcycle
12-J856	WAUVFAFR0AA967569	69256QAEGN	Maroon	track
9V 0E7TFM	WAUKFAFL4BA217561	64195GRKOT	Blue	track
39-4352N	1G4HP54K04U379373	17571VNOGX	Crimson	motorcycle
729-ZOG	WAUAH94F38N440984	57227AUYBC	Fuscia	motorcycle
0CT E37	2T1BURHE1FC872574	17985LGROF	Purple	car
BA-8605	WBA5A7C59FG143609	42516QUOZQ	Teal	car
GD-2434	WBADS33422G233428	91168FCHXU	Indigo	motorcycle
MAE 821	1C3CDWEAXCD620748	28429ZCQES	Yellow	motorcycle
5JE6549	SCFEBBAK0DG668102	98084DMXQT	Puce	motorcycle
035DR	1C4RDHEG5FC054613	81808MJGXE	Khaki	motorcycle
EG6 T4J	WBAFR1C50BD569582	41154DWFZS	Crimson	track
MDN 148	WDDJK7DA4EF813085	60417RCEVK	Fuscia	track
427-AKK	WAUKD98P69A167373	15474YOVSW	Violet	motorcycle
685VJJ	5LMJJ2H51EE692883	68583ZYSKW	Violet	track
UX 6663	1G6AZ5SX7E0279216	33102PHOIM	Indigo	motorcycle
65-L073	WAUEF98E46A038615	88510XJWMX	Yellow	motorcycle
6M 8N4WZH	KMHGH4JHXDU316163	04949HVCNU	Blue	motorcycle
L76-44F	JN1CV6EK7EM315537	30907AMLTS	Khaki	track
6IX04	JHMZF1C61FS555577	51377UQXMC	Purple	motorcycle
YAI9366	5TDDK4CCXAS031537	49116MQVGU	Indigo	car
7I BO383	3D7LP2ET9BG037978	33720BJLTM	Pink	track
127 MOD	2G4WB52K331929183	63396QOWDA	Green	car
276 NHZ	WAUFFAFL0FA668316	72825NDMVB	Aquamarine	car
W39-HNO	WBA5M4C50ED378180	97482YMHVP	Red	car
0VR1058	WBAYM1C57ED452450	22404YMKJW	Indigo	motorcycle
D78-89Y	WAUVT58E55A797211	43080XPCVY	Puce	car
2X CH591	1G6DV1EP8F0057170	25562YBEZK	Indigo	motorcycle
X12-42Y	1N6BF0KM8FN923469	88501GNESF	Pink	motorcycle
HGW-0660	2G61N5S33E9531638	58526FDCYO	Maroon	track
MOK 536	TRUDD38J981275043	51094WUYQY	Mauv	track
577-UTK	JTDKN3DP0E3587373	10539ORYGN	Violet	track
YRD-6112	1FMEU7EE0AU403177	27011KAEQZ	Turquoise	motorcycle
780-107	2B3CJ5DT7AH609841	75474OOKVH	Crimson	track
921-NNIU	WUAW2BFC1EN302489	64621VPIRZ	Khaki	car
XVX-1687	JN8AF5MR7BT677920	30119DODWC	Violet	car
FS 4755	JA32U2FUXEU917612	47631HDOFH	Teal	motorcycle
886 FKO	JTEBU5JR1C5093556	54539UOJVL	Yellow	car
ISV 533	3D73M3HL8BG514247	61999TAPVB	Teal	motorcycle
495 ISP	2C3CDYCJ7EH327393	22749FVMPP	Yellow	motorcycle
743-KJS	WBA3A5C55CF333209	88961BJIGE	Pink	car
KKG 293	3D73M4HL2AG824009	52571YLJFU	Teal	car
8MB71	3VW8S7AT3FM120196	23451TJCEZ	Mauv	motorcycle
EPI4806	1G6KD57Y97U864637	34013MTQYK	Indigo	car
63-97656	2G4GZ5GV3B9782981	47957FTOBQ	Goldenrod	motorcycle
9GXK 13	WBAKB4C56BC658566	66271XGYSA	Blue	track
LM 24090	WBAUP3C59BV461044	37248SVQFP	Goldenrod	track
BHS-5622	WBAKP9C59FD056842	90881GOCUV	Mauv	motorcycle
NBQ-4863	WAUKD98P79A872778	51749SILVI	Green	car
9F F2690	1G6AB5RX5F0221844	01632YTQRY	Mauv	motorcycle
AOS-829	2G61N5S30F9505838	90807DLJUO	Maroon	car
177TCO	3D73M3CL5BG597658	12614ZCXKU	Puce	car
70C W31	WAUEH74F26N897174	11938CGKFN	Turquoise	track
2XY3473	JM1BL1L38D1004034	93631DXDQC	Red	car
1F 78928	WAULT58E75A392104	15202DNKVY	Orange	track
809 UBB	WAU4GAFB9BN467075	53938BPNVP	Khaki	track
WCI 038	KNDMG4C7XE6761314	34023FWZNL	Aquamarine	motorcycle
FOP-4832	19UUA56733A296521	56971JUPOT	Red	track
2401 DR	WDBWK5EA5BF885913	96500CPHGX	Puce	motorcycle
BHX 924	WBAUN1C59AV584819	27790KOSNK	Mauv	car
U98 6YR	SAJWA4EC5FM252119	63845HVNUO	Maroon	car
181 BFU	JA32U2FU1DU680345	53445WMUWS	Yellow	track
106 YIJ	W04GR5EC1B1675223	53501DTTML	Mauv	motorcycle
ADU-732	1G6DF5EY7B0012860	99103NUVEJ	Violet	motorcycle
68R•376	WAUJC58E83A234682	58150ECHGM	Red	car
I56 5DY	1FBSS3BL7AD648412	44246YGGDA	Fuscia	car
2R 88330	1N4AA5APXEC139672	62384EEUIG	Pink	car
60U Z91	1G6AE5SX6F0413159	12633KZZMC	Khaki	motorcycle
220-FIX	WBAVT13516K080882	73042PEHKW	Teal	car
84-WC27	3C6JR6CT8DG182249	79980VVMYB	Teal	track
800 PML	WAUVC58E35A387765	32382YAGEK	Maroon	track
9MI 839	1G6DK5E3XC0927817	31204PBPPA	Violet	car
302FBQ	2C4RDGBG6CR596580	64065XJOTH	Khaki	car
939 7924	WAUAH74F48N981515	71631FGPBA	Purple	car
3RX4731	WVWED7AJ0DW696825	67338SQJJE	Aquamarine	motorcycle
179LU	1FAHP2DW4AG012921	67182SLEUT	Orange	motorcycle
MXS 588	1G6DX67D990527253	69829RLUQU	Pink	motorcycle
794-XFB	WBAKG1C5XDJ664191	27879YNWWM	Pink	track
ORH 676	WBAPH73589E977312	89750MWNEU	Violet	track
802 FV7	WA1BY94L27D965174	29840EVFVM	Pink	motorcycle
281 PZZ	5N1AN0NW8EN689357	77217ASFFK	Goldenrod	motorcycle
7G 8649R	5N1AA0ND8FN403924	66847QIYAY	Crimson	track
ZXS5691	1GYS4CKJXFR572244	61532OTXET	Green	motorcycle
224 NGD	5TDBK3EH3DS542781	76371HDKVB	Indigo	car
YKH-6327	5N1BA0NE2FN718800	79258MWPGL	Red	motorcycle
107-VDR	WAUGL98EX8A244235	34124DGLIB	Goldenrod	track
7-J6658	JM1DE1KY9C0032574	27608ETLDK	Yellow	track
140-BAL	JTHBE5C20B5757618	22400QHOPO	Fuscia	motorcycle
6DN G71	5GAKVCED4CJ849815	28302GONOA	Aquamarine	motorcycle
575 VZ6	2G4GU5GV7C9903611	96719TNKCJ	Maroon	track
94-DW79	WBAEJ13413A078399	08928BWYJT	Maroon	car
EEF 010	KL4CJHSB1EB436868	48748VTWRF	Turquoise	car
3FW8336	3C63DPNL3CG054073	36792DRGYA	Fuscia	motorcycle
22-R524	WBAKE5C53CE338737	56166TDASC	Purple	track
2652 XG	WBAAV33431F173805	91086FMREO	Crimson	track
226 QZB	WBAYP9C50FD131938	99911CRPDM	Crimson	motorcycle
241 RCC	WBA3A9C58FF156652	24420EITWE	Crimson	track
7NE W68	1N6AA0CJ1EN820262	15304TERJH	Mauv	track
6QY I45	1GYS3EEJ2DR357836	04264CAJBV	Yellow	car
ZYP 005	1G6AJ1RX1F0284418	97059ZMQPM	Goldenrod	motorcycle
GEX4534	3D73M4EL5BG616910	59215SXHHX	Goldenrod	track
MGS 805	WAUAFAFH4CN425523	19710KVIIA	Green	car
6D363	WBAEV33414P963717	61895CJJUJ	Orange	motorcycle
VE0 P9A	3FA6P0SU4FR254797	26638YQZKL	Crimson	car
829-221	19UUA66246A672657	86098ZUNMR	Crimson	motorcycle
304 HPU	2G4GL5EX0F9494573	93438LYKFO	Goldenrod	motorcycle
1NT N25	KNAFK4A6XF5884049	01816IQQXB	Crimson	motorcycle
7-29887	3GYFK52239G950453	22460KMGLF	Yellow	track
GDB 326	JN8AF5MR1BT990025	34838ATQWJ	Orange	car
HRA 075	WAUMGAFLXAA771465	26117IVOWV	Teal	track
08E RK3	WA1YD64B64N755016	54168EHJTJ	Violet	car
814 9RX	WAULT58EX5A670171	80426XMFNQ	Khaki	track
775-LAO	WAUDH94F28N717041	99443FNBMC	Aquamarine	car
6PM3715	JH4DC548X6S556012	77967BWOSE	Crimson	car
463 4811	WAUNF98P37A752058	21214JLXTG	Puce	car
SLF-681	SCFBF04B28G580679	05712RDYPD	Goldenrod	car
WCM 529	WBAAN37491N621593	59209BOWWM	Red	track
4JT Q75	1VWAP7A37EC606268	86489LGGLR	Indigo	track
964 IP3	5N1AN0NW2EN016306	40064ONBBL	Pink	track
YQE3024	3VW517AT4EM847125	62216RPJRT	Crimson	track
4Q D4822	KM8JT3AF3EU074217	27952AFDKS	Indigo	car
04Z 2157	JTHBF5C25D5107358	32507VMQCD	Turquoise	track
H96 7QF	WA1VMBFE1AD547355	57372EXCNW	Puce	car
QBV C27	JH4CU2F86DC441869	77209FYEAY	Crimson	motorcycle
HSH 428	JN8AS5MT1AW345380	96412CDNHL	Red	motorcycle
I61 6TY	19XFB2F56EE899710	79597KCPEF	Crimson	motorcycle
TV2 2438	1N6AA0CC2EN843745	59568WVYAE	Green	motorcycle
8V 7131S	1FTWW3A58AE972435	90148LJONU	Green	car
7B 77677	5UMCN93412L079094	74600EMJHG	Puce	track
5HGH 47	1N6BF0KL7FN818347	63662IFOJF	Teal	car
879-UCD	5TDBK3EH2DS558146	50487BOUSJ	Fuscia	track
MDV-5677	YV4902BZ0C1670075	22341UYFKA	Maroon	motorcycle
732-WLK	JH4CU2F68EC780925	31154MILFA	Orange	motorcycle
3LZR577	WAUBVAFA6AN419276	17571VNOGX	Khaki	car
9Z 1026N	1YVHZ8BH0A5530171	26549MRDPI	Maroon	car
ULI-9187	5TFBY5F11AX123524	17985LGROF	Indigo	track
580-XRQ	5J6TF1H39CL762823	36970UEOWD	Puce	track
UOS 611	WAUWFAFL8CA551840	79679IYBAE	Purple	track
NXN2628	5UXFB53564L765936	28429ZCQES	Purple	car
4O 96624	1G6DN57P790978255	90007HVZZC	Indigo	track
GZD-0194	WBA4C9C53FD767683	81808MJGXE	Orange	track
5-B4621	WBA3N3C55FF063038	41154DWFZS	Aquamarine	motorcycle
F47-ZQW	4T1BK3DB8AU921727	11492FUWAO	Khaki	motorcycle
741 1KT	WAUVC68E45A658807	68583ZYSKW	Yellow	motorcycle
82-94022	WBAKG1C50CJ075018	99586HDGOW	Puce	car
OHP 597	JM1CW2BL5C0136739	33102PHOIM	Violet	car
QUO 439	19XFA1E69AE780177	70447EUQNV	Puce	car
6WUL 89	KL4CJFSB1FB046858	88510XJWMX	Mauv	car
LIK-145	WAUBF78E77A148745	04949HVCNU	Aquamarine	track
9-5756R	WBAEN33493E880823	30907AMLTS	Teal	motorcycle
8NE 465	WAUDFAFL0FN642380	10519ECDXP	Fuscia	track
W99 1LZ	5N1AA0NC0FN141775	24362GAAMP	Goldenrod	motorcycle
51KH4	5XYKT3A64EG285291	71475FWVQK	Yellow	track
7113 FH	WAUDG98E05A085499	76895SOEJY	Teal	track
3IN S20	1N6BF0KLXFN420517	72825NDMVB	Blue	motorcycle
185 8AV	WUARL48H78K868905	35898LSIFX	Violet	motorcycle
TQ5 8063	1N6AA0CH5FN080326	35134XPIWK	Indigo	car
KXX 551	1GKS2GEJ3CR229130	55526YCNNL	Teal	motorcycle
OAB 115	2B3CM5CT3BH703077	94067FKYKZ	Yellow	car
OPT-567	1D7RW3GK1BS847508	43080XPCVY	Maroon	track
XR 37057	WAUJC68E35A795297	25562YBEZK	Puce	motorcycle
SEJ 2186	SCBZB25EX2C065587	88501GNESF	Mauv	motorcycle
09-CG69	KNDMG4C79B6726596	58526FDCYO	Pink	motorcycle
5-3602I	WAU4GAFB9AN292406	27011KAEQZ	Turquoise	motorcycle
U47-ZFZ	WAUSH78EX8A041930	75474OOKVH	Blue	car
IZQ 3134	WAUVT68E82A489127	47957FTOBQ	Goldenrod	motorcycle
264-FFN	1FBAX2CM2FK452346	62766JSYLC	Goldenrod	car
42U E17	WAUVVAFR6AA969376	01113NKLFK	Mauv	motorcycle
6V272	JM1NC2SF7F0341463	66271XGYSA	Crimson	car
51F B29	JTEBU5JR6B5079151	37248SVQFP	Green	car
998 UEB	WBAYF8C58FD054037	56414TXOMM	Teal	track
F57-DQU	WDDLJ6HBXFA404953	96905DGNXV	Red	car
WFV 438	JHMGE8G20AC691888	02228NOJUO	Purple	car
7NV 317	3D73Y4CL4BG593952	18796ERGBK	Orange	track
AIT 625	2T1BURHEXEC294165	90881GOCUV	Pink	motorcycle
12G 734	2G4WD582791572164	92744LJUVI	Red	car
VB 8529	1G6DV57V380242278	51749SILVI	Aquamarine	car
4K089	3C6LD5ATXCG893955	35092HVVHN	Maroon	track
OX-1985	JTDBT4K38A1912210	84468GNBMX	Orange	track
XDR 244	1FTKR1AD2BP706318	01632YTQRY	Puce	track
900-ZHA	KL4CJESB7DB654441	74669OTCAS	Khaki	track
0F 6036O	JN8AZ1MU9CW964728	60202OATAC	Teal	car
7401 UA	JTHBE5C25D5281207	08632RNFSU	Blue	motorcycle
ZVT-099	2T2BK1BA1CC379031	10730DSLOA	Violet	motorcycle
249-BUW	1HGCP2E70BA202989	11938CGKFN	Crimson	motorcycle
508U	1G6KS54Y94U629449	01069YZYOM	Violet	track
793 OJT	1FA6P0G78F5629824	53938BPNVP	Yellow	car
AQ9 H1X	WA1GFCFS7FR651308	71238ESJEJ	Teal	track
3393	SCBLF34F84C418454	34023FWZNL	Crimson	motorcycle
2-94366I	1GD020CGXBF669066	75794KDEYY	Aquamarine	car
A56-HII	5GAKRBKD3EJ562469	65431BGUOK	Crimson	car
3-54356V	YV440MBK0F1871312	27790KOSNK	Green	track
9-79815	YV1982BW5A1481463	63845HVNUO	Puce	motorcycle
DNB O58	1FMCU0C72AK178436	59647CBAND	Teal	motorcycle
841-JFAT	WAUPEBFM3DA250478	40292GLJYO	Crimson	track
8L 9X9FLZ	WAUAFAFLXBN834094	53445WMUWS	Yellow	track
XLN4969	WBADT53403C844754	60338HTOHB	Blue	track
QIH 409	5N1AA0ND1EN685211	81920YVSAE	Goldenrod	track
LKM 657	4T1BF1FK8EU828332	08961QQSUB	Green	motorcycle
749ONN	5GAKVDKDXDJ725138	23876VQUMS	Goldenrod	car
9OO 663	SCFKDCEP9EG581244	05760HYIEE	Mauv	track
618HNP	WAUHGAFC4EN201591	62384EEUIG	Maroon	track
U81 3VZ	1G6DL8EY5B0636683	31204PBPPA	Red	car
JRM 387	1B3CB5HA7BD484229	56779CCSNT	Green	motorcycle
FDF1234	1GYEK63NX3R870360	39648CFKHY	Aquamarine	track
63DL626	JN1EY1AP0DM669757	71631FGPBA	Mauv	track
ISN 788	WBA3C3C52DF328663	98550RDWNQ	Blue	track
57-Y093	WAUKF78E68A343852	67338SQJJE	Goldenrod	motorcycle
561H0	WAULD64BX3N257915	32209PLLVW	Yellow	track
BU-6680	5FRYD3H20EB006533	01714QMQHX	Mauv	car
VPY1682	2C3CDZAT6FH101793	15822YJLBV	Red	motorcycle
927 5XR	YV4612HK4F1855261	83776IGTGU	Pink	car
0-5724W	KMHDB8AE4AU198480	93608NWYHE	Maroon	car
347 CY4	3D73Y4EL6BG933437	29840EVFVM	Blue	car
97-86218	1C4NJCBA2FD978463	64856ZCAXS	Fuscia	motorcycle
9295	WBABN53431J866015	17544BCCTL	Yellow	motorcycle
509 UVM	3C3CFFCR6FT857142	94539KOZBG	Puce	track
531AJG	SCBCC41N39C372324	53430LBGSB	Aquamarine	car
MKO-9627	5GADX23L06D863320	26215FUNML	Turquoise	track
HJC 040	4A4AP3AU8FE414537	76371HDKVB	Yellow	motorcycle
24E T56	1FTWW3B51AE707080	88568FGBBK	Turquoise	motorcycle
ZOB-9687	JN1CV6AP7AM776040	79258MWPGL	Aquamarine	car
844-IEF	5N1AR1NB2BC986199	09790NICKX	Purple	motorcycle
QHM 493	WBAUC735X8V836810	25464WPLFL	Yellow	car
93-DJ50	WBA3D5C50FK668221	13459QZFNX	Yellow	car
QL 5205	WAUGGAFC9DN480529	58957MHLES	Yellow	track
TGC 358	1FTWW3B51AE350029	22400QHOPO	Violet	track
150 ZIG	1G6KD57Y14U071957	28302GONOA	Violet	motorcycle
KFC 617	1GYS4BKJ8FR712821	96699ZLXZH	Indigo	track
PP 5921	1FTMF1CW3AF055916	73053NCNHC	Teal	car
319-TIH	WAUKG78E76A239087	96719TNKCJ	Khaki	car
SEC-295	4T1BD1FK5EU329476	68606YKXRE	Pink	motorcycle
QDV-8658	WAUAFAFL9CN538226	12692VPJYK	Goldenrod	track
9EJE 13	1G6DM8EV5A0381485	24420EITWE	Turquoise	car
BLA-2552	WA1LFAFP2DA286207	15304TERJH	Red	car
885 9SN	WAUGL98E08A650511	97059ZMQPM	Blue	car
23HE5	WAULC68E63A960538	61651XANQI	Violet	car
6YT 049	WAUHFAFL3BA986577	61895CJJUJ	Violet	motorcycle
7K YC112	1YVHZ8BH9B5687165	26516PSQAC	Khaki	motorcycle
GQL 281	JM1BL1H35A1200114	88149HIAOX	Yellow	track
ALG-649	WBA6B2C53ED761335	30260LXSQG	Turquoise	car
7-9762N	1FTSW2A55AE558182	93438LYKFO	Aquamarine	car
0X 8U0BCJ	2HNYD18223H819881	76134WVQWH	Yellow	track
98I T78	1J4PN2GK4BW556874	22460KMGLF	Purple	car
920 NO9	4JGCB2FB1AA530707	34838ATQWJ	Red	track
YKZ 448	WDDHF2EB7BA231150	26117IVOWV	Khaki	car
071-FDW	WBADT63433C392398	18956MZLME	Goldenrod	car
155470	WAUSH78EX8A754827	03012EEHXC	Green	motorcycle
71-5958U	1GYS3JEF8BR613480	54168EHJTJ	Teal	track
301 YOS	3C4PDCBB8CT699307	02990FMDIG	Turquoise	track
4-A2654	WAUML44D92N342806	80426XMFNQ	Green	motorcycle
HMI-3217	WAUEH94F98N159029	17938VKVHW	Orange	track
9ZU 177	WAUMFBFL1BN958239	21214JLXTG	Puce	car
456 BUU	3VW507AT3FM208531	59209BOWWM	Blue	car
8BR 346	1G6YV36A685520971	36354QYTKE	Fuscia	motorcycle
806-IYA	WAUDG74F45N791919	40636CIOKK	Mauv	motorcycle
34-TB96	JN1CV6EK8CM401968	13805BGLCX	Fuscia	car
829 CR2	5N1AA0NE2FN813420	57372EXCNW	Yellow	car
382Q	2HNYD2H84DH122918	65719NVUNR	Red	track
4J 70004	WBXPA73464W376419	77209FYEAY	Goldenrod	motorcycle
W20-KPT	2C3CDXDT5CH747709	96926WJPQG	Yellow	track
QEI-0537	WAUMFAFH1FN669597	41591FUGWU	Goldenrod	motorcycle
JGM-3687	1GT02ZCG4EF953189	64439FBUIU	Pink	track
9-3689U	1G6KD57Y21U497300	90327VJIXZ	Puce	car
562-882	SALWR2VF4FA937650	79597KCPEF	Blue	car
79P 8449	WBA3B9C51EP394283	98261WJIOX	Orange	motorcycle
TZS 355	1HGCP2E77BA297647	91252GQRXA	Crimson	track
003-CZGF	1FTEW1CW2AK881801	61812ZTTXW	Fuscia	track
TXP 119	2G4GL5EX6F9486817	50487BOUSJ	Khaki	motorcycle
GO2 A1M	JH4CL96856C913090	61446CYJBC	Maroon	track
5V 20870	19UUA66267A380736	96167IROLX	Fuscia	car
4XU T07	2FMDK3AK9DB403081	69256QAEGN	Maroon	car
3-29745B	1GD11ZCG3DF060626	11280NIIMM	Indigo	car
IDG3512	3C4PDCDG5ET574485	26549MRDPI	Green	car
5CR7462	2G4WS52J111242921	57227AUYBC	Yellow	car
05-8899A	1C3CCBAB3CN195314	17985LGROF	Aquamarine	motorcycle
463 HCR	WAUVT68E35A301182	04580SGTWO	Yellow	car
5K 9958I	2T1BU4EE4BC179936	36970UEOWD	Mauv	car
131407	4A4AP3AU0FE237966	79679IYBAE	Green	car
630 RYU	SALAG2D41DA176332	98202NZZPA	Orange	car
7-93686	1G4HR54K624400024	28429ZCQES	Teal	track
181 IOX	3N1CN7AP3EK003559	90007HVZZC	Mauv	car
76H 074	4USBU335X7L311881	27601ACGVR	Aquamarine	track
JBU-719	1G6AJ5SX6F0185983	15474YOVSW	Mauv	track
260 0787	3N1CN7AP1DL682210	28617NGTFX	Aquamarine	car
FKS5798	WAUCFAFC1DN238061	68583ZYSKW	Puce	motorcycle
XMM 522	3FAHP0HA2AR715865	70447EUQNV	Goldenrod	car
934 OZH	WAUDH78E56A014219	82191KQKGZ	Blue	motorcycle
672 XTW	5GAKVDED9CJ175537	04949HVCNU	Indigo	motorcycle
38EE0	1G6DM5EG6A0641361	06475DZHFU	Blue	motorcycle
8XH D17	5FRYD3H49FB298931	21385PZSXE	Orange	car
013 GQW	JTDKDTB35E1200640	40164WNEOG	Red	car
KIT-7646	JN8CS1MU2DM359279	01113NKLFK	Purple	motorcycle
3HI 498	3D7TT2CT0BG754090	10706QTEGV	Yellow	car
953CAG	JM1NC2JF2D0740490	66271XGYSA	Indigo	car
UFA6995	JH4CL95876C260344	37248SVQFP	Indigo	motorcycle
1J 5086X	JHMFB4F27CS074074	96905DGNXV	Red	track
IDU 377	WAUKF78E86A544018	28607PJGVG	Crimson	motorcycle
47Z 6497	WBA4B3C58FD909588	27944JPSLB	Orange	motorcycle
6TG2820	19UUA96259A281765	92744LJUVI	Mauv	car
126-NTO	WAUCVAFR5BA372521	62599TDXPF	Indigo	track
ZHL 199	1GTC5MF97C8647786	35092HVVHN	Maroon	motorcycle
FJF 835	1GYFC53289R173618	01632YTQRY	Blue	car
252 JNU	4USBT33493L625168	47106DGXAW	Orange	car
78-OS09	3G5DA03E44S108780	20001CNUCM	Maroon	motorcycle
OVI V67	2D4RN4DE8AR885192	12614ZCXKU	Mauv	motorcycle
H79 1HA	5N1AT2ML9EC492511	15202DNKVY	Turquoise	car
GAB-6707	SCBFC7ZA1EC850055	34023FWZNL	Violet	motorcycle
8448 ED	WBALW3C5XCC485753	73312ULUTY	Goldenrod	track
ABY-4730	WA1YL54BX5N693635	27790KOSNK	Purple	track
2K 5J6SHE	5UXWX7C5XEL913388	60338HTOHB	Mauv	motorcycle
606-DYS	1FTEW1CM6EF748214	81920YVSAE	Teal	motorcycle
OIE-8689	WUADU78E68N990247	10286GPFAJ	Purple	track
9-95446	JH4KC1F57EC751187	49477YFEAB	Crimson	motorcycle
AHY-8188	2C4RDGEG0DR607215	53501DTTML	Khaki	track
031-WWS	WBA5M4C50FD497994	99103NUVEJ	Orange	car
OPZ-371	5N1AA0NC4AN111235	58150ECHGM	Orange	motorcycle
LXS-2300	WBABS53472J714183	23876VQUMS	Turquoise	motorcycle
MLN 363	WAUGL78E67A094806	44246YGGDA	Crimson	motorcycle
QXE 489	JN8AS5MT5BW949113	22434JOWKH	Purple	motorcycle
773 VBA	1VWAH7A31CC833336	62384EEUIG	Puce	car
7KG5595	KMHCM3AC2BU434021	38793DFDZW	Indigo	car
BW1 3234	TRUWT28N231591918	73286WMKRD	Turquoise	car
04UV0	5N1AR1NB3CC384686	10045HFDKS	Goldenrod	track
GBZ 8738	WBALM53509E136065	31204PBPPA	Khaki	car
G23-RSI	WAULC68E12A193745	95651NOXXZ	Mauv	track
55N G71	WAUJT58E83A657844	71631FGPBA	Khaki	motorcycle
734 JXY	3A4GY5F92AT543245	67338SQJJE	Pink	car
647BJT	1GYUCCEF9AR414425	67182SLEUT	Violet	motorcycle
97Y Z17	1HGCP2E41AA845713	05321NYVGE	Purple	motorcycle
QXX2513	WAUK2AFD5FN652642	83776IGTGU	Indigo	motorcycle
740E	1N6AA0CH6DN865984	69434QYOWH	Crimson	track
PY 1470	WAULFAFR9DA448015	32822OQGAB	Indigo	track
0PH R91	JTDKDTB36D1811629	93608NWYHE	Puce	track
578-ZIG	SCFFDAAE2AG440326	48718CCRSJ	Pink	motorcycle
0281 HA	WBAWB73559P395248	81530MDQXF	Violet	track
6-Z8779	5UXFG83589L945039	66847QIYAY	Goldenrod	motorcycle
0K 3Z9TWZ	1GTN1TEH5FZ194905	26215FUNML	Yellow	car
3-58615	WBANN73546C079250	61532OTXET	Goldenrod	track
IYU-437	WA1DGAFE1BD654243	79258MWPGL	Fuscia	motorcycle
586 WMG	1G4HD5EM7AU181555	35636YSGBO	Maroon	car
0-0073G	WAUEFAFLXCN010518	09790NICKX	Indigo	car
CCA 785	WA1LMBFE0ED624987	79602JNQWY	Yellow	car
DPQ-862	WAUKF68E25A342462	81271PUFQU	Crimson	track
3-2260K	WBAAV534X1J212849	13459QZFNX	Red	car
E80-MLA	5GAKRAKDXEJ300216	48748VTWRF	Goldenrod	motorcycle
GQU-8889	4T1BD1FK5FU000522	36792DRGYA	Crimson	car
7Y 8I7KEQ	5NPDH4AE5CH263023	56166TDASC	Turquoise	car
OMQ-0373	3D7LP2ET7BG232266	93627VLEBL	Goldenrod	car
6UEH 81	NM0KS7AN0AT490233	68606YKXRE	Puce	track
5Q 8041F	VNKKTUD32FA610603	91086FMREO	Crimson	motorcycle
196-IJH	JN1CV6EL6EM261933	12692VPJYK	Yellow	track
371 TSX	JN8AS5MT9CW474549	75380KXMRY	Turquoise	car
297-059	5N1BA0ND7FN453041	39641ZUOIF	Khaki	track
7N U0957	WAUHF98P88A693703	97059ZMQPM	Puce	car
5F TX621	5GAKVBKD6FJ359895	61651XANQI	Purple	motorcycle
65-XC64	1G6DC67AX90294081	88149HIAOX	Maroon	track
7-1694W	JTMHY7AJ1A4696213	90187SQARJ	Crimson	motorcycle
487-TDM	5UMDU93446L522206	66764WWWJX	Yellow	motorcycle
686 FMH	YV1612FH6E1018000	08844VWKAR	Goldenrod	car
YU-2902	1C3BCBEB6EN284626	24888OHNWO	Goldenrod	car
9T 72900	WAUCVAFR0AA948014	76134WVQWH	Teal	motorcycle
378 3HL	19UYA42763A545282	01816IQQXB	Green	track
8I UY907	W04G05GV0B1811687	03012EEHXC	Khaki	car
C15 4EE	WVWAN7AN8EE314997	99443FNBMC	Khaki	motorcycle
01A 9646	1N6AA0CC8FN929160	46067GSLFZ	Maroon	car
916 NUU	1G6DK67V280747811	17938VKVHW	Pink	motorcycle
G70 3WW	1G6DC1E39E0589643	21214JLXTG	Blue	track
21HT781	5J6TF1H33FL898840	05712RDYPD	Aquamarine	car
7CZT129	1FTWW3B5XAE569779	59209BOWWM	Khaki	car
WQY 234	WBADT33413G602200	36354QYTKE	Mauv	track
LD 15596	WBSDE93412C432337	40636CIOKK	Pink	motorcycle
146-GLZ	2C4RDGDG9CR827971	90228VRHSD	Green	track
BNU F71	WA1CKBFP1AA424297	86489LGGLR	Violet	track
2-92597	5N1AA0ND8FN762190	62216RPJRT	Blue	track
KLI 161	5FNRL5H24CB480700	51696DPHDB	Maroon	track
05L•150	WAUGL98E98A343662	32507VMQCD	Violet	car
975 LWO	WBAEW53435P895947	57372EXCNW	Teal	car
853X	JN1CV6EL9FM824006	77209FYEAY	Teal	track
4C T7368	WAUHFAFL3AA889300	41591FUGWU	Teal	track
9ZR H83	WA1CFAFPXBA393969	92659KLGRG	Pink	motorcycle
ABV-999	JN1CV6AP6BM189779	64439FBUIU	Teal	motorcycle
4JL 298	1FMEU2DE5AU067370	14709DXNZN	Orange	motorcycle
MDG-2298	SCFBF04B68G965419	18086MDFGS	Aquamarine	car
0KG M67	1G4HP57M89U115337	49046RWQRA	Orange	car
HPM8644	WBA5A5C50ED472879	98261WJIOX	Turquoise	motorcycle
91L•279	KM8JT3AC9AU718562	90148LJONU	Blue	motorcycle
IJO-087	1N4AA5AP8DC629901	91252GQRXA	Indigo	motorcycle
626 JMF	WBA3B9G51FN374915	74600EMJHG	Puce	motorcycle
IDE Q02	WBAYA6C57FD711994	50487BOUSJ	Puce	car
AVO-8514	1GYS4AEF5ER248273	22341UYFKA	Khaki	car
MFN 112	WBAPM7C57AA006504	96167IROLX	Fuscia	motorcycle
457 OGY	4T1BF3EK8AU796585	69256QAEGN	Mauv	motorcycle
733-DBS	2T1BU4EE4DC639602	94189TSEVP	Crimson	motorcycle
K93 5FY	WAUAF98E47A516709	13893BSZNE	Violet	motorcycle
HUX5388	1FTEW1CF4FK843445	26549MRDPI	Yellow	track
111-KOY	WAUGFAFR9DA815836	36970UEOWD	Orange	track
981 ZYJ	WVGAV3AX7DW867249	98202NZZPA	Pink	car
ZDQ 601	WA1DGAFEXBD214229	28429ZCQES	Crimson	car
LGO 446	1G6DM57T170038627	81808MJGXE	Violet	track
KBY 511	2HNYD18662H042591	41154DWFZS	Orange	track
DZT 883	WVGAV3AX3EW244230	27601ACGVR	Khaki	motorcycle
715-ZRY	5FRYD3H23EB350440	60417RCEVK	Orange	track
3RM K37	1J4PN2GK3AW237139	18394GHJXY	Pink	car
JFK4635	JTEBU5JR9F5721576	33102PHOIM	Crimson	motorcycle
15-F068	3G5DA03E35S268358	70447EUQNV	Pink	car
566-NQN	3N1CN7AP0EL134426	42152KRUMN	Mauv	motorcycle
6-8996Z	WAUWGBFB6BN439510	30907AMLTS	Maroon	motorcycle
2A 3C0PYJ	1FAHP2D84EG951221	51377UQXMC	Pink	motorcycle
95-S381	19UUB2F51FA753888	49116MQVGU	Orange	track
SCY 097	1G6DW677260340123	66675VNMUO	Mauv	track
NKU6307	3N1AB7AP0FL110564	76895SOEJY	Khaki	track
L01 9CC	5UMBT93528L466627	72825NDMVB	Indigo	car
201 0SP	3VW517AT9EM748459	09892OETEV	Aquamarine	car
VX 65339	WAUVT68E25A267235	97482YMHVP	Aquamarine	motorcycle
159 YCL	1FTEX1E88AK407492	84427PGRZG	Blue	track
3LH0223	19VDE1F7XEE496767	52571YLJFU	Yellow	car
A04 3IE	WDDNG7DB0DA170290	47957FTOBQ	Teal	track
IQM-226	1N4AL3AP6DC003939	01113NKLFK	Goldenrod	track
DP 0811	SCBDR3ZA6BC440555	66271XGYSA	Red	motorcycle
B74-EMZ	SALSF2D47CA605981	56414TXOMM	Turquoise	motorcycle
355 8EA	WVGAV7AX7FW157598	02228NOJUO	Yellow	car
598 AZC	2FMHK6DTXAB756268	14852RMILI	Khaki	car
M93-93F	JN8AS5MT4CW219159	18796ERGBK	Maroon	car
0NJ 213	JN1BJ0HR7FM310305	90807DLJUO	Blue	motorcycle
58JP0	1FMJK1J54AE468129	20001CNUCM	Red	motorcycle
438029	JTHCL5EF5F5375942	74669OTCAS	Violet	motorcycle
5-76967	1FMJK1H5XCE312184	60202OATAC	Purple	motorcycle
UOU-842	2GKALMEK6D6749528	12614ZCXKU	Khaki	car
OU2 M5A	5N1BA0NC0FN944820	94575NAUET	Crimson	motorcycle
3TN B66	19UUA65625A560555	76788TRVDY	Goldenrod	track
900-YHQ	1FM5K7B84FG697662	71238ESJEJ	Puce	motorcycle
923-GJDP	JN1EY1AP7EM336232	28811ZYSRG	Blue	car
Z97-UJS	WVWAP7AN3DE129250	73312ULUTY	Puce	track
6-66210	JM1NC2EF3A0819561	27790KOSNK	Goldenrod	track
8F713	WBAYP9C59DD674704	37467VPAWA	Turquoise	motorcycle
NFW-9627	19XFA1E31BE374465	53445WMUWS	Indigo	track
5-1620E	5UXFG8C59DL302112	60338HTOHB	Mauv	motorcycle
87I 572	WAULT58E82A077923	81920YVSAE	Turquoise	car
575-052	WUATNAFG2CN000200	44246YGGDA	Maroon	motorcycle
706 3600	JN1CV6FE0FM380210	62384EEUIG	Pink	car
251 MRD	SAJWJ0FF9F8054282	38793DFDZW	Purple	motorcycle
367 UY1	TRUB3AFK0C1163993	73286WMKRD	Violet	track
3JV 444	YV4902DZ8D2163451	79980VVMYB	Blue	motorcycle
505 TXG	SCBCP73W38C615012	31204PBPPA	Green	motorcycle
666 HTA	WVWAN7AN0EE716982	56779CCSNT	Blue	car
75OC6	1YVHZ8BH5D5484874	95651NOXXZ	Orange	car
C03 2XV	2C3CCAAG1CH606322	39648CFKHY	Turquoise	track
0OC 603	2C3CCAJG7EH317450	71631FGPBA	Blue	car
HGJ 783	5N1AA0NC5FN483254	98550RDWNQ	Blue	motorcycle
2-49570	WAUEL74F35N167089	07267DLTLH	Pink	track
384 UOI	WA1AM74L99D676081	67182SLEUT	Khaki	track
6I 30651	1J4NF1FB2AD183389	32209PLLVW	Indigo	motorcycle
5OA 432	WP0CB2A83CS481359	34875VFWSA	Indigo	track
KIL 377	WAULFAFH9EN711234	58104HOATM	Teal	motorcycle
7AO 606	JA32U1FU5DU140815	18821PMCLI	Crimson	motorcycle
464L	1FTFW1E81AF118020	32822OQGAB	Purple	car
20-X454	1C4RDHEG3FC860031	93608NWYHE	Purple	track
0-P8239	4USDU53407L284203	48718CCRSJ	Pink	car
L18 9BR	JA32U1FU7AU397521	75203HECSL	Green	car
KLW 747	1GYS4LKJ7FR040403	81530MDQXF	Teal	track
660 3DC	WAUDK78TX8A942661	17544BCCTL	Khaki	car
1-K7220	JM1DE1KY9E0190660	53430LBGSB	Mauv	motorcycle
LYM 191	JH4NA21691T628347	26215FUNML	Mauv	motorcycle
NGE-8186	WVGAV3AX4DW064303	79258MWPGL	Pink	motorcycle
396-UNI	WAUKF78E27A052876	35636YSGBO	Puce	motorcycle
7-0261X	WBA3B3G51EN330439	25464WPLFL	Goldenrod	motorcycle
F 996293	1G6AE1R36F0351872	73053NCNHC	Indigo	car
NIQ-0296	3C4PDCBB1CT429349	48748VTWRF	Aquamarine	motorcycle
788 6NV	JTEBU5JR9A5375344	93627VLEBL	Fuscia	motorcycle
73B•578	2FMGK5B84EB128281	12692VPJYK	Purple	track
515 5161	KMHGC4DE8AU512775	39641ZUOIF	Red	car
0Z 05228	3N1CE2CP0EL554333	61651XANQI	Yellow	track
QJT C42	3GYFNAE30DS279740	07764LBAXP	Goldenrod	motorcycle
HUI 057	WAUJF98K39N949505	26638YQZKL	Green	car
QK8 2563	SCBZK22E02C010604	86098ZUNMR	Mauv	track
RBB 901	3VWF17AT5FM432126	66764WWWJX	Turquoise	track
182M	1GD12ZCG3BF119040	80404UNYAY	Puce	track
STY-507	JN8AF5MR1ET541870	93438LYKFO	Indigo	motorcycle
EXU-1189	1FMJK1JT3FE387662	24888OHNWO	Violet	track
46-7254L	KNALU4D46F6508238	80426XMFNQ	Crimson	car
OH 4374	WA1DGBFP0DA120646	99443FNBMC	Goldenrod	track
KD-2612	WAUDF48HX7A251255	17938VKVHW	Teal	motorcycle
XSQ 940	WAUAT48H55K391832	21214JLXTG	Orange	car
H28 9KQ	1G4GG5E30CF663429	05712RDYPD	Green	car
V 678591	WBABD33435P247148	59209BOWWM	Green	track
324-NPF	WAUHFBFL3AN925534	52316ODVUI	Turquoise	motorcycle
1QCZ466	WAUGL98E67A643402	98264UNIZW	Yellow	car
HNL 498	1G6AB5SX7E0472793	38812NDHMB	Teal	track
BGT-8561	WA1CV74L57D556491	90228VRHSD	Crimson	car
701747	2G4GU5GV8C9141874	11227TZKBE	Khaki	motorcycle
4-18231P	WDDGF5EB7AA545523	86489LGGLR	Puce	car
VSX-185	WAUAVAFD6CN186718	40064ONBBL	Orange	car
3VY 558	KNDJT2A11B7187628	51696DPHDB	Puce	track
981VRC	1GD422CG5EF926037	57372EXCNW	Goldenrod	motorcycle
F33 0BX	JTDKN3DPXE3667943	77209FYEAY	Red	motorcycle
870EW	3D7JB1EP4AG437285	98366HVUNT	Green	track
AGG8389	2C3CDXFG8FH623289	96926WJPQG	Goldenrod	motorcycle
10GW101	3VW1K7AJ4BM424745	96412CDNHL	Orange	motorcycle
5-6003A	1G4GC5G31FF561845	64439FBUIU	Violet	track
77LQ8	ZHWGU6AU8CL907063	90327VJIXZ	Purple	track
535 IK2	1N6AA0CC3DN935011	14709DXNZN	Khaki	car
612 JSE	WBADW3C51DJ067261	18086MDFGS	Turquoise	car
EX2 9328	3D73Y4HL0BG757352	49046RWQRA	Puce	track
93C 2845	1GTN2TEHXFZ051154	59568WVYAE	Yellow	track
W21 7IC	WAULC58EX2A189526	87520JSKOK	Fuscia	car
73-AR24	2C3CDXCT1CH298885	74600EMJHG	Red	track
172 LQS	WAUVT58EX3A275719	61446CYJBC	Red	car
CQ 88787	1GYEK63N12R402063	22341UYFKA	Yellow	motorcycle
QOJ 407	JTHKD5BH9C2513672	96167IROLX	Puce	motorcycle
L98 2ER	JTEBU5JR7B5056915	64195GRKOT	Pink	car
2520 WF	WVGAV7AXXAW578661	13893BSZNE	Violet	car
221-LKD	WAUCH74F49N871221	26549MRDPI	Yellow	track
H13 6QA	WBAEP33422P391600	04580SGTWO	Khaki	motorcycle
ZLF 641	JH4KB16608C935208	36970UEOWD	Green	track
SZJ 592	3FA6P0D95DR725491	79679IYBAE	Turquoise	motorcycle
H84 5NZ	1N4AL2AP5BN205652	91168FCHXU	Mauv	car
268-718	1GYEE637390838405	98202NZZPA	Turquoise	track
9XP E52	WAUGVAFR8CA515254	28429ZCQES	Goldenrod	track
951 NCT	3C4PDDEG6ET668914	98084DMXQT	Goldenrod	track
6-11208	YV4902DZ0D2604439	65799IZDMX	Yellow	car
8380	2FMDK3GC0AB463939	81808MJGXE	Violet	motorcycle
05-J219	JH4DC53895S057184	41154DWFZS	Teal	track
0WN V61	1C6RD6FK7CS429630	11492FUWAO	Puce	track
54QX5	WAUAKAFB0AN605408	68583ZYSKW	Red	track
643 APQ	WA1LMBFE7ED333354	42152KRUMN	Maroon	car
1OU8194	WBASN4C59AC090559	30907AMLTS	Indigo	track
0DX5658	WBAAV33471F680481	06475DZHFU	Teal	track
937 IUU	1C3CDZBG2EN229682	49116MQVGU	Red	motorcycle
2557	JM3KE2BE9E0723181	71475FWVQK	Violet	track
6G P8070	1GKS1HE05DR558090	76895SOEJY	Khaki	track
150-AIT	1FTEW1CM6CF294267	33720BJLTM	Pink	motorcycle
ALK 807	WBAUP7C56AV652944	46712WLLKG	Maroon	motorcycle
6-W9864	WP0CB2A83CS796565	00326DAIRN	Turquoise	track
721 EGT	1G6DA8EG0A0702911	35898LSIFX	Red	track
TLB 614	WDBSK7BA6CF242406	22404YMKJW	Crimson	motorcycle
KJJ 310	1G6DK5EV6A0136747	94067FKYKZ	Green	track
5YOQ 35	1C3CDFBB2FD490546	43080XPCVY	Teal	track
025 0PJ	1D4PT5GK9BW797300	25562YBEZK	Red	motorcycle
918 XET	JH4DC53033C924712	82668RTLKW	Pink	track
LWY 178	WAUEFAFL4BA470926	21385PZSXE	Goldenrod	car
MCO 747	5N1AA0NCXCN074694	40164WNEOG	Aquamarine	track
VSX 302	4T1BK3DB6BU079598	88961BJIGE	Pink	car
967 XAQ	WA1DGAFP7EA158502	52571YLJFU	Aquamarine	car
7QY8840	1G4GA5GC7BF484320	23451TJCEZ	Indigo	motorcycle
50K 0105	WBAYF8C57FD395865	47957FTOBQ	Khaki	track
6HWY 41	YV4952CY9C1743595	01113NKLFK	Pink	car
315YCH	1N6AA0CHXFN814989	10706QTEGV	Aquamarine	motorcycle
HAB 064	WA1WKBFP2BA598314	37248SVQFP	Fuscia	track
086 VYW	5N1AA0NE5EN367889	02228NOJUO	Fuscia	motorcycle
43-19624	WA1EY74L48D719777	27944JPSLB	Green	track
TIR 293	WAUJC68E05A754366	91840ABVMY	Green	track
9NT56	WAUKF98E26A618870	92744LJUVI	Fuscia	track
VVT-313	3D7JB1EK4AG160125	47106DGXAW	Orange	motorcycle
3517	WAUEV94F98N758716	08632RNFSU	Teal	track
BJ 72028	1G6DP577960028596	11938CGKFN	Green	track
LZL-2657	WAUFFAFL9AN472098	01069YZYOM	Goldenrod	motorcycle
1BG S96	WAUJT54B03N215743	93631DXDQC	Teal	track
033DT	JTHBP5C27C5408628	56483FSLNP	Green	motorcycle
4V L9931	2G4GV5GV4D9943837	15202DNKVY	Orange	car
YLX-3258	WP1AE2A25EL999637	34023FWZNL	Fuscia	car
5KH 922	1FTKR1AD5AP780914	28811ZYSRG	Aquamarine	car
05-IF75	2C3CDYCJ1EH491111	75794KDEYY	Khaki	track
08R 559	WAU4FAFL5BA599026	73312ULUTY	Teal	track
VMH 708	1G6DP577950730075	56971JUPOT	Orange	track
4N 04973	5N1AA0ND1FN692967	59647CBAND	Violet	motorcycle
FIT 684	WBAKF9C55CE653284	37467VPAWA	Goldenrod	car
3641	4A4AP3AU1EE405855	53445WMUWS	Fuscia	track
86-7374J	3C3CFFDR9FT875178	10286GPFAJ	Violet	motorcycle
36-LF56	SALAB2V65FA924484	53501DTTML	Pink	track
YJU-467	3VWML7AJXEM508888	99103NUVEJ	Red	track
SBG 098	1N6AF0KYXFN003261	58150ECHGM	Purple	car
B60-VWJ	ZHWGU5BZ6DL840906	23876VQUMS	Puce	car
24K 730	1LNHL9DR6CG515843	22434JOWKH	Green	car
6PP 383	WDDEJ9EB7EA186631	62384EEUIG	Goldenrod	track
S73-88B	WA1LGAFEXDD846369	38793DFDZW	Blue	car
012 9681	JTHBE5C21C5764983	12633KZZMC	Crimson	car
F87-94C	WBA5B1C59ED745159	73042PEHKW	Puce	car
079Z3	WAUKFAFL0CN304982	79980VVMYB	Turquoise	motorcycle
076 6339	19UUA8F2XCA396945	31204PBPPA	Crimson	car
795 ETO	WBSDE93483C505513	56779CCSNT	Maroon	car
1799	2LMHJ5AR4AB948461	95651NOXXZ	Orange	car
886 RWI	WAUHFBFL6AN351866	39648CFKHY	Mauv	motorcycle
578-FYHM	5J8TB3H59EL308560	07267DLTLH	Red	car
00R P09	2G61R5S3XD9930226	67182SLEUT	Indigo	track
0JE39	WAUHGAFC0CN126143	05321NYVGE	Orange	motorcycle
35-67079	3VW4A7AT6DM758988	01714QMQHX	Fuscia	motorcycle
907 YRF	JHMFA3F28AS601338	83776IGTGU	Turquoise	car
818-EAG	1GYS3FEJ1BR946489	18821PMCLI	Yellow	car
229KIZ	SCBBB7ZH8DC041617	69035FZZMK	Crimson	track
B 272001	2G61S5S31F9022223	48718CCRSJ	Indigo	car
015 IRX	JM1BL1K56B1961133	89750MWNEU	Purple	track
2-50287	19UYA42592A198740	14002KPACE	Puce	car
77N 596	SALFR2BN3BH563545	77217ASFFK	Aquamarine	car
33-2862W	1GYS4CKJ2FR945308	94539KOZBG	Puce	track
3NW U44	1GD312CG8EF432897	88568FGBBK	Indigo	motorcycle
8BB9830	1C3CDFBB9FD576419	35636YSGBO	Indigo	car
31K J90	YV1612FS5E1070245	62596JFYYZ	Aquamarine	motorcycle
959 PPU	SALWR2TF7FA062941	13459QZFNX	Aquamarine	motorcycle
CEG-7377	JN1AZ4EH2BM058660	58957MHLES	Aquamarine	car
BPL-883	4T1BD1EB1EU273120	22400QHOPO	Puce	motorcycle
VHU-560	5N1AR2MM7FC337724	96699ZLXZH	Indigo	track
YWZ 595	3D73M3HL2AG735874	96719TNKCJ	Indigo	motorcycle
0H 98955	1G6KD57Y39U373581	08928BWYJT	Pink	car
8IY 250	WAUHE78P08A247603	48748VTWRF	Yellow	car
0NM0292	JN1CV6AP5CM241940	36792DRGYA	Blue	car
78-K824	1GYS4CKJ1FR257378	56166TDASC	Khaki	track
EHE 4075	2G4GS5EV4D9160173	68606YKXRE	Indigo	car
543 GNR	4T3BA3BB6EU123634	99911CRPDM	Puce	motorcycle
NJG-6665	3N1AB6AP2AL318691	68436EWCFD	Maroon	car
MVY 713	JN1BJ0HR3DM589328	43058OCOIQ	Green	car
036K1	SCFEBBAC6AG228678	97059ZMQPM	Aquamarine	track
AI 6935	4A31K5DF9CE871185	59215SXHHX	Maroon	car
N 788808	JN8AS5MT3CW997890	19710KVIIA	Purple	car
3-66051	1HGCP2E79AA521077	26638YQZKL	Red	track
YY4 2288	SCBFC7ZA6EC628482	22157EXBKO	Khaki	car
4T 58052	WBAKA83529C924444	30260LXSQG	Teal	car
095 FQZ	3VWF17AT2FM551946	08844VWKAR	Goldenrod	track
I74 4OC	1G4HR57Y86U606631	76134WVQWH	Maroon	motorcycle
6RW6048	1N6AA0CC1AN739242	18956MZLME	Mauv	car
D93-TNA	3D4PG9FV9AT176697	54168EHJTJ	Teal	track
021IYI	KM8JT3AF7EU835685	30270OTWAZ	Purple	track
769-699	SALAC2D46AA430012	80426XMFNQ	Violet	motorcycle
SVA-1631	WA1WGAFP2EA666174	99443FNBMC	Goldenrod	motorcycle
86AX2	JTHBF5C25D5690966	77967BWOSE	Indigo	track
9BM89	3GYFNCE37FS521843	17938VKVHW	Puce	car
SMO 815	1G4PR5SK8D4029790	05712RDYPD	Crimson	car
58O PJ3	WAUZL64B01N294580	98264UNIZW	Pink	track
7Z 6929X	1N6BF0KX5FN606582	40636CIOKK	Purple	car
ZXT 321	5LMJJ3H54AE213162	90228VRHSD	Aquamarine	car
785 TDP	2GKALMEK1F6936999	68599NGPQV	Puce	car
333HLE	1FTWW3DY8AE364582	13805BGLCX	Purple	track
GEB-2708	1C4RDHAG3FC643147	32507VMQCD	Aquamarine	car
T 783124	1D7RE3BK1AS917453	57372EXCNW	Yellow	motorcycle
5B539	WAUVT68E44A614451	98366HVUNT	Teal	motorcycle
PHI-4177	WAUHF98P78A397717	96926WJPQG	Green	motorcycle
ZYA 530	3VWJX7AJ7AM604351	60508FPBTK	Maroon	track
0P 8570L	WVWAP7AN8EE440822	92659KLGRG	Goldenrod	motorcycle
JGG-6535	JTEBU5JRXC5205044	46617WKRYE	Puce	motorcycle
25O 4226	WAUYGAFC8DN862250	79597KCPEF	Crimson	track
556 FJQ	WDDGF4HB9ER645877	49046RWQRA	Goldenrod	motorcycle
2978 GK	1FTEW1CW4AK318409	59568WVYAE	Goldenrod	car
ZZA 815	WAUAH78E48A712388	87520JSKOK	Violet	car
398LNJ	4T1BF1FK9FU072141	91252GQRXA	Green	track
267 NZR	1G4CU541724737768	08402WNPSZ	Crimson	car
SFX 795	JHMZE2H36CS547610	61812ZTTXW	Blue	motorcycle
359 DEQ	WAUDFAFL1EN487501	50487BOUSJ	Pink	car
891 VLG	3C3CFFAR1FT740426	61446CYJBC	Violet	motorcycle
1GZ Q60	JHMGE8G31DC863097	22341UYFKA	Orange	track
RBP-661	1G6AC5S39E0772796	96167IROLX	Purple	track
670 WNA	5J8TB4H72GL254416	64195GRKOT	Turquoise	car
YVC-494	5UXFA93504L263112	54774CYHDL	Puce	car
64-4925J	1GYS3JEF8DR347543	17985LGROF	Green	track
H72 2YK	WBAPH5G57BN312812	66576OBXWU	Teal	car
34M•017	WAUBVAFA0AN233782	79679IYBAE	Blue	track
455277	5FNRL5H25FB824037	91168FCHXU	Green	motorcycle
MA7 4057	WBAYE4C54FD685475	34970FMAHF	Violet	car
O46-QGQ	SCBGU3ZA8DC259021	98202NZZPA	Mauv	car
LGW-976	YV1612FHXE1396840	28429ZCQES	Green	motorcycle
MVE 979	1G6AB5SX3D0005336	90007HVZZC	Goldenrod	track
070-VWK	SCBFT7ZA9FC720722	98084DMXQT	Indigo	car
31-FK94	WVWAB7AJ3CW519687	60417RCEVK	Green	motorcycle
LYI 915	WBA6A0C51ED147486	18394GHJXY	Red	track
MFU S87	KM8JT3ACXAU689914	11492FUWAO	Purple	car
ZIP 864	1FTWW3A59AE763267	68583ZYSKW	Fuscia	motorcycle
902W	WAUKG98E76A430729	21385PZSXE	Mauv	track
TDQ-793	2C4RDGEG7CR800735	40164WNEOG	Indigo	motorcycle
9562	SALWR2VF5FA150724	84427PGRZG	Fuscia	car
1NLF 30	1C3CCBAB1CN157323	52571YLJFU	Goldenrod	track
7Z 3534Q	1N6BF0KX6FN918636	23451TJCEZ	Blue	car
VFO-811	5GAKRBKD4EJ796751	34013MTQYK	Puce	car
EJD 803	1N4AB7AP1DN771178	01113NKLFK	Turquoise	track
238 TNK	WDDLJ7DB3DA859233	10706QTEGV	Crimson	motorcycle
781 1FW	WA1CFAFP0FA783985	60463ILRGE	Teal	car
DRJ 830	5N1AA0ND9FN483475	56414TXOMM	Khaki	car
89-A279	WUADUAFG4CN443861	96905DGNXV	Crimson	track
326 JFK	2G4WS52J321982746	02228NOJUO	Green	car
575 1HP	KL4CJFSB4EB429594	28607PJGVG	Turquoise	track
4GT X73	3D4PH9FG1BT792331	27944JPSLB	Pink	track
3JQ 654	WBSPM93579E491934	62599TDXPF	Maroon	motorcycle
941 KNO	WBA5M6C58ED289842	35092HVVHN	Puce	motorcycle
40-6718N	5FRYD3H9XGB251372	20001CNUCM	Maroon	track
BDO8119	5GALVBED5AJ483567	83458QDVDE	Puce	motorcycle
RWO-7493	WBSDE93473C652504	08632RNFSU	Purple	car
HPR-2951	JH4CU2F62AC908764	94575NAUET	Turquoise	car
845 MNG	1FAHP2D88DG743194	10730DSLOA	Mauv	track
EAR 714	1FBAX2CM1FK085083	01069YZYOM	Indigo	track
UEL-550	1VWAH7A32EC669291	15202DNKVY	Turquoise	track
ZT-5655	JTDZN3EU2FJ781306	65431BGUOK	Indigo	car
844 2KO	JM1GJ1T66E1223517	63845HVNUO	Crimson	motorcycle
07W YE1	WA1MKBFP5AA269404	59647CBAND	Orange	track
6I PI469	1VWAH7A30DC859220	53501DTTML	Blue	track
GBT6744	1N6AA0CC5AN833110	99103NUVEJ	Goldenrod	track
AJY-9891	WUARU78E77N614340	22434JOWKH	Goldenrod	motorcycle
EXF6194	WAUVC58E95A437231	12633KZZMC	Puce	car
4VAX385	5J6TF1H30CL425795	27672EORLJ	Goldenrod	track
617-206	2G61S5S3XF9621248	32382YAGEK	Purple	motorcycle
016W	KMHTC6ADXDU693565	31204PBPPA	Red	car
RAD-7016	5FNRL3H23AB377012	56779CCSNT	Mauv	car
CFP-340	JTDKN3DU6B0568989	97911PYRMW	Yellow	motorcycle
047EM	5FRYD3H96GB104000	64065XJOTH	Goldenrod	car
84A 238	3C6TD5ET1CG005376	07267DLTLH	Maroon	car
X51 1HP	3C4PDCDG0ET476285	67338SQJJE	Puce	motorcycle
HLU 274	1N6AA0EK6FN585879	05321NYVGE	Puce	track
351 WMT	SALAB2V67FA592032	51518DIAML	Orange	motorcycle
0IL3153	1G4GC5EC2BF146935	83776IGTGU	Crimson	motorcycle
BUX7525	1GD21XEG2FZ825395	69829RLUQU	Mauv	car
SZE-9965	WBAWL7C51AP707146	69434QYOWH	Pink	track
Y 653696	3C3CFFAR2FT857397	27879YNWWM	Teal	track
VT7 Y2W	JN8AZ1MU9EW659619	93608NWYHE	Maroon	motorcycle
420-OYK	5FRYD3H62FB910808	69035FZZMK	Violet	motorcycle
XVE-0881	KMHGH4JH3EU796676	48718CCRSJ	Crimson	motorcycle
179-NLE	WBAFR7C53CC361173	75203HECSL	Aquamarine	car
D65 6VU	2HNYD18946H159117	14002KPACE	Pink	track
57W•489	1G6DJ577880433790	77217ASFFK	Puce	car
816-ZUF	JTJHY7AX3F4504122	94539KOZBG	Pink	track
701 0KB	WBAEK73465B596943	53430LBGSB	Khaki	car
N09-CVL	WAULT68EX3A489767	76371HDKVB	Mauv	car
LGE-9000	3N1AB7AP4FY408800	88568FGBBK	Yellow	motorcycle
ALH-469	1C6RD7HT8CS455522	09569XHRII	Teal	track
46J QC4	4T3BA3BB7FU519976	81271PUFQU	Teal	car
SSX 149	SAJWA0FB0BL489650	13459QZFNX	Puce	motorcycle
T78 5KR	WAUBF78E57A523130	22400QHOPO	Green	track
740 GOJ	1B3CB9HA1AD388585	73053NCNHC	Turquoise	car
4Y705	JN8AZ1FY8CW215919	68606YKXRE	Aquamarine	motorcycle
625-ZXA	SALWR2VF6FA772751	91086FMREO	Khaki	motorcycle
CDA-942	5N1AZ2MH3FN027500	12692VPJYK	Pink	track
73D 529	WBALX5C54CC318068	38409WIKNY	Pink	car
O14-56N	3N1CE2CP7FL062545	65614ELRCG	Fuscia	motorcycle
1OA J97	19VDE3F74EE492614	15304TERJH	Aquamarine	car
50I 0130	1GTN1TEX9BZ463232	39641ZUOIF	Maroon	car
69EZ893	WAUJC68E62A811990	59215SXHHX	Khaki	car
I09-OBJ	1G6AG5RX6D0656130	61895CJJUJ	Indigo	motorcycle
MQY-242	WA1YD64B12N086599	26638YQZKL	Blue	track
450 VVZ	4USBU33537L001765	88149HIAOX	Puce	car
UTW-6872	3N1CE2CP3FL527547	30260LXSQG	Turquoise	car
7-1470B	KMHEC4A48EA398805	86098ZUNMR	Aquamarine	car
0OA Y11	1N6AA0EJ4FN442422	80404UNYAY	Indigo	motorcycle
4JL 679	5J6YH1H34BL179719	76134WVQWH	Red	motorcycle
702XP	3VWC17AU3FM541213	66483RELJD	Aquamarine	car
817K	WAUDG98E76A484458	73414MLVAY	Mauv	motorcycle
958 6408	3GYFNFE32CS959134	34838ATQWJ	Goldenrod	track
8-I0181	1G6YX36D675765000	26117IVOWV	Orange	car
HP8 C7F	JHMZF1C47DS900087	03012EEHXC	Purple	track
272 YYR	W04GT5GC8B1354293	54168EHJTJ	Aquamarine	car
FBP 349	WA1DGBFE5ED042377	02990FMDIG	Green	car
VGQ 530	WAUBFAFL0CA736592	21214JLXTG	Crimson	motorcycle
P84 0AC	1G6DP5E36D0444280	05712RDYPD	Mauv	motorcycle
CWU-1443	5TDBCRFH7FS090691	59209BOWWM	Crimson	track
064 8XT	1N4AA5AP8AC208661	40636CIOKK	Purple	motorcycle
UV 4166	WAUCFAFH7DN131785	90228VRHSD	Green	car
KQI-137	3D7JV1EPXBG572716	86489LGGLR	Purple	motorcycle
2VE M49	1G6DD8E37E0382111	40064ONBBL	Khaki	track
0AS 085	JTJBC1BA2C2112073	68599NGPQV	Yellow	car
367 SER	WA1CV74L07D998272	13805BGLCX	Goldenrod	car
9VM O50	JM1GJ1T59E1928674	27952AFDKS	Khaki	track
TQF-695	SALGS2EF0EA926801	32507VMQCD	Yellow	track
167-IQP	1G4HD57278U721086	57372EXCNW	Mauv	motorcycle
982 EWJ	SCBZB25E22C219791	96926WJPQG	Turquoise	track
WD-4200	2LMHJ5AT1FB157842	90327VJIXZ	Purple	motorcycle
TY 5461	1FMEU8DEXAU625734	97312OCMVK	Crimson	track
685 QZR	1FTEW1C80AK884214	89496WYPEF	Crimson	car
R50 1NH	3GYEK62N55G946037	14709DXNZN	Purple	track
898T6	WAU3FAFR8CA573134	63662IFOJF	Turquoise	motorcycle
231 2757	19XFA1F32AE433990	61446CYJBC	Orange	track
725H	WVGAV7AX2CW729298	13893BSZNE	Puce	car
3KM 696	YV1672MW8B2815340	11280NIIMM	Aquamarine	motorcycle
K80-ZXB	1G6DK8EG7A0267396	31154MILFA	Goldenrod	track
AYV 369	JA4AD3A35FZ161588	54774CYHDL	Pink	track
542-MTZ	1N6AD0CU3CC161109	26549MRDPI	Purple	track
53-MO16	19XFB4F27FE705799	17985LGROF	Crimson	motorcycle
LDR 808	1N6AA0CC7EN219651	04580SGTWO	Red	motorcycle
028-BAQL	WAULC68E53A315508	66576OBXWU	Goldenrod	motorcycle
YFF-665	WVWED7AJXCW644312	79679IYBAE	Goldenrod	car
4-45012A	1G6AB5RA0E0889898	98202NZZPA	Indigo	track
HS 3074	JH4DB75641S875796	90007HVZZC	Green	motorcycle
9T589	1N6AF0LYXFN284251	98084DMXQT	Turquoise	track
9-F8654	SAJWJ0FF5F8141032	41154DWFZS	Blue	car
2-M4064	WA1CMAFE2ED955046	27601ACGVR	Mauv	car
V58 2EN	1GD312CGXBF500368	11492FUWAO	Blue	motorcycle
LNA 574	3GYFNDEY1AS858406	68583ZYSKW	Indigo	car
23C WU4	3GTU2YEJ9BG655719	88510XJWMX	Mauv	track
40G 6406	JTDKDTB30D1025714	30907AMLTS	Goldenrod	motorcycle
RPJ 8340	5GAKRAKD1EJ950567	51377UQXMC	Blue	motorcycle
ZXG 094	2G4WS52JX11716185	06475DZHFU	Teal	car
02-S856	WAUPEAFM9BA755447	24362GAAMP	Teal	track
994-CWF	WA1WMBFE7FD003907	49116MQVGU	Purple	motorcycle
MRT 516	3D4PG9FV5AT381269	66675VNMUO	Green	track
ZMD 044	3FADP4AJ6BM442881	71475FWVQK	Green	track
ESX 218	SAJWA1EK8EM378821	00326DAIRN	Puce	motorcycle
\.


--
-- Data for Name: vehicles_info; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vehicles_info (model_id, model, first_release, brand, price) FROM stdin;
21385PZSXE	Suburban 1500	2007	Chevrolet	443973
40164WNEOG	Safari	2005	GMC	351316
88961BJIGE	MX-5	1997	Mazda	476846
53378QJKHO	Town Car	1999	Lincoln	78847
84427PGRZG	Sedona	2011	Kia	138475
52571YLJFU	Safari	1995	GMC	267771
23451TJCEZ	Cutlass	1998	Oldsmobile	163246
34013MTQYK	Expo	1992	Mitsubishi	154134
47957FTOBQ	SLK-Class	2000	Mercedes-Benz	448517
62766JSYLC	Charger	2007	Dodge	362675
01113NKLFK	Grand Prix	1997	Pontiac	65815
10706QTEGV	Suburban 1500	1995	Chevrolet	60036
60463ILRGE	Suburban 1500	2006	Chevrolet	8174
66271XGYSA	3-Sep	2003	Saab	220620
37248SVQFP	H1	2001	Hummer	241369
56414TXOMM	Mark VII	1984	Lincoln	434151
96905DGNXV	VUE	2005	Saturn	278958
02228NOJUO	Corvette	1988	Chevrolet	278210
28607PJGVG	Scoupe	1994	Hyundai	444927
14852RMILI	Maxima	1995	Nissan	22948
27944JPSLB	GranTurismo	2010	Maserati	291045
18796ERGBK	Navigator	2000	Lincoln	124712
90881GOCUV	3-Sep	2009	Saab	9422
91840ABVMY	Sidekick	1997	Suzuki	441164
92744LJUVI	Grand Prix	1990	Pontiac	216934
62599TDXPF	Viper	2003	Dodge	349483
51749SILVI	Silverado 3500	2008	Chevrolet	366170
35092HVVHN	CX-7	2011	Mazda	108914
84468GNBMX	TundraMax	2012	Toyota	172474
01632YTQRY	H3T	2010	Hummer	243666
47106DGXAW	300TE	1992	Mercedes-Benz	218896
90807DLJUO	S-Type	2001	Jaguar	63680
20001CNUCM	MR2	1985	Toyota	123025
74669OTCAS	Sephia	1999	Kia	399232
83458QDVDE	Astro	1992	Chevrolet	182687
60202OATAC	LeMans	1968	Pontiac	265374
08632RNFSU	Town Car	1995	Lincoln	152532
12614ZCXKU	Regal	1999	Buick	471208
94575NAUET	New Yorker	1994	Chrysler	115354
10730DSLOA	Outlander	2012	Mitsubishi	134414
11938CGKFN	Alero	2003	Oldsmobile	333507
01069YZYOM	X5	2009	BMW	394786
76788TRVDY	Insight	2005	Honda	168580
93631DXDQC	100	1992	Audi	283221
56483FSLNP	Millenia	2000	Mazda	111984
15202DNKVY	Dakota	2007	Dodge	340286
53938BPNVP	Suburban 2500	1995	GMC	481856
71238ESJEJ	Neon	2005	Dodge	185009
34023FWZNL	SL-Class	1999	Mercedes-Benz	331131
28811ZYSRG	Amigo	1999	Isuzu	419256
75794KDEYY	XLR-V	2008	Cadillac	5171
65431BGUOK	Suburban 2500	2005	Chevrolet	35222
73312ULUTY	Sebring	2005	Chrysler	401311
56971JUPOT	Bonneville	1999	Pontiac	178322
96500CPHGX	Pajero	2002	Mitsubishi	398849
27790KOSNK	Sonoma	1992	GMC	35883
63845HVNUO	Mountaineer	2001	Mercury	13275
59647CBAND	Rally Wagon 3500	1993	GMC	365794
40292GLJYO	Ram 2500 Club	1995	Dodge	29332
37467VPAWA	Astro	1995	Chevrolet	79249
53445WMUWS	Town Car	2005	Lincoln	372722
60338HTOHB	G-Class	2002	Mercedes-Benz	283754
81920YVSAE	Cabriolet	1997	Audi	301547
08961QQSUB	Space	1993	Isuzu	346367
10286GPFAJ	Sable	2003	Mercury	407532
49477YFEAB	Grand Vitara	2000	Suzuki	56583
53501DTTML	Swift	2001	Suzuki	392692
99103NUVEJ	Aerostar	1993	Ford	313472
58150ECHGM	G6	2006	Pontiac	123712
23876VQUMS	Eclipse	1995	Mitsubishi	447309
44246YGGDA	F450	2008	Ford	159848
22434JOWKH	Endeavor	2008	Mitsubishi	248440
05760HYIEE	GTO	1971	Pontiac	356949
62384EEUIG	XJ Series	2001	Jaguar	161592
38793DFDZW	Express 2500	1996	Chevrolet	115117
73286WMKRD	Gallardo	2011	Lamborghini	368925
12633KZZMC	57	2012	Maybach	165043
73042PEHKW	Q	2002	Infiniti	347547
27672EORLJ	F250	2006	Ford	294406
79980VVMYB	V8 Vantage	2009	Aston Martin	221928
10045HFDKS	G6	2006	Pontiac	346399
32382YAGEK	Express 1500	1998	Chevrolet	419486
31204PBPPA	DBS	2010	Aston Martin	416105
56779CCSNT	Ram Van 3500	1996	Dodge	78044
97911PYRMW	Phaeton	2005	Volkswagen	121374
95651NOXXZ	Club Wagon	1996	Ford	416661
64065XJOTH	Nubira	2000	Daewoo	374628
39648CFKHY	Festiva	1991	Ford	275084
71631FGPBA	Crossfire	2005	Chrysler	256283
98550RDWNQ	Cooper	2010	MINI	185052
07267DLTLH	Passat	2001	Volkswagen	20585
67338SQJJE	Tracer	1988	Mercury	434646
67182SLEUT	Raider	2009	Mitsubishi	313052
17155CLUQS	3500	2012	Ram	208668
05321NYVGE	Challenger	2008	Dodge	109189
32209PLLVW	R-Class	2007	Mercedes-Benz	83584
34875VFWSA	Yukon XL 1500	2011	GMC	126509
51518DIAML	Avalon	2000	Toyota	396749
01714QMQHX	5-Sep	2011	Saab	41841
15822YJLBV	LX	2013	Lexus	436490
83776IGTGU	900	1988	Saab	135007
58104HOATM	Suburban 2500	1992	GMC	393774
69829RLUQU	Viper	1999	Dodge	58458
18821PMCLI	C70	2013	Volvo	178751
78545RJKWQ	Express 1500	2007	Chevrolet	324345
69434QYOWH	Swift	1991	Suzuki	342335
27879YNWWM	Passat	2010	Volkswagen	172388
32822OQGAB	Tacoma Xtra	1998	Toyota	453510
93608NWYHE	Regal	2002	Buick	226147
69035FZZMK	Tahoe	2000	Chevrolet	458777
48718CCRSJ	Protege	1992	Mazda	123438
75203HECSL	A4	2001	Audi	214704
81530MDQXF	Safari	2001	GMC	482976
89750MWNEU	Golf III	1994	Volkswagen	30428
29840EVFVM	Vibe	2007	Pontiac	312052
14002KPACE	5 Series	2007	BMW	26262
64856ZCAXS	GS	2013	Lexus	146122
77217ASFFK	Caravan	2005	Dodge	498823
66847QIYAY	Regal	1999	Buick	237816
17544BCCTL	Intrepid	1993	Dodge	128521
94539KOZBG	Corolla	1997	Toyota	278305
53430LBGSB	Silverado 2500	2012	Chevrolet	25699
26215FUNML	Impreza	1994	Subaru	461803
61532OTXET	Savana 3500	2008	GMC	27003
76371HDKVB	Regal	2000	Buick	357434
88568FGBBK	Enclave	2009	Buick	217679
79258MWPGL	Cherokee	2001	Jeep	224255
09569XHRII	Silverado	2011	Chevrolet	400338
35636YSGBO	Mustang	1983	Ford	250638
09790NICKX	X-Type	2002	Jaguar	328439
25464WPLFL	Explorer	1996	Ford	256400
34124DGLIB	Express	2009	Chevrolet	65407
79602JNQWY	Firebird	2002	Pontiac	343384
81271PUFQU	Cressida	1992	Toyota	92769
62596JFYYZ	Suburban 2500	1999	Chevrolet	471443
13459QZFNX	Ram 2500	2001	Dodge	244848
27608ETLDK	Bonneville	1991	Pontiac	403806
58957MHLES	Rally Wagon G2500	1995	GMC	351756
22400QHOPO	Avenger	2012	Dodge	136405
28302GONOA	Venture	2003	Chevrolet	158527
96699ZLXZH	Capri	1994	Mercury	229795
73053NCNHC	Cougar	2000	Mercury	46230
96719TNKCJ	ZX2	2001	Ford	329259
08928BWYJT	Thunderbird	1987	Ford	455983
48748VTWRF	240	1992	Volvo	92391
36792DRGYA	Discovery	1995	Land Rover	80654
56166TDASC	Spectra	2000	Kia	455120
93627VLEBL	Cutlass	1997	Oldsmobile	400651
68606YKXRE	S60	2012	Volvo	274444
91086FMREO	350Z	2009	Nissan	476859
99911CRPDM	Park Avenue	2003	Buick	306394
68436EWCFD	S80	2008	Volvo	433996
12692VPJYK	Tredia	1987	Mitsubishi	454102
38409WIKNY	Firebird	1990	Pontiac	97399
65614ELRCG	Rendezvous	2005	Buick	424664
75380KXMRY	Crown Victoria	2002	Ford	447028
24420EITWE	Defender	1994	Land Rover	448908
15304TERJH	Patriot	2010	Jeep	178626
04264CAJBV	8 Series	1994	BMW	298334
43058OCOIQ	Discovery	2006	Land Rover	422932
39641ZUOIF	Summit	1992	Eagle	276556
97059ZMQPM	Grand Prix	1975	Pontiac	72713
61651XANQI	ES	1994	Lexus	167226
59215SXHHX	Corvette	1961	Chevrolet	404072
19710KVIIA	Fusion	2008	Ford	343967
61895CJJUJ	XC90	2013	Volvo	435773
07764LBAXP	Range Rover Sport	2009	Land Rover	420687
26516PSQAC	XT	1985	Subaru	425227
26638YQZKL	S10 Blazer	1992	Chevrolet	407435
88149HIAOX	Ranger	1998	Ford	498299
22157EXBKO	Prizm	1995	Geo	151654
90187SQARJ	Brat	1987	Subaru	16425
30260LXSQG	Gran Sport	2006	Maserati	274826
86098ZUNMR	Tercel	1997	Toyota	422527
66764WWWJX	L-Series	2001	Saturn	43942
80404UNYAY	Esperante	2007	Panoz	473840
08844VWKAR	XLR	2009	Cadillac	7969
93438LYKFO	CX	1974	Citroën	221597
24888OHNWO	Sedona	2004	Kia	213867
76134WVQWH	Savana 1500	2005	GMC	163061
66483RELJD	Sonic	2012	Chevrolet	140814
01816IQQXB	V8 Vantage	2009	Aston Martin	437532
22460KMGLF	Cressida	1992	Toyota	435782
73414MLVAY	Regal	1998	Buick	101013
34838ATQWJ	Prowler	1999	Plymouth	174758
26117IVOWV	1500	1996	GMC	89706
18956MZLME	2500	2012	Ram	379096
03012EEHXC	Passat	2001	Volkswagen	75712
41072FNGJX	Sentra	2010	Nissan	398301
54168EHJTJ	Town & Country	2003	Chrysler	205228
30270OTWAZ	Brougham	1992	Cadillac	46090
02990FMDIG	Spider	1992	Alfa Romeo	234620
80426XMFNQ	Escort ZX2	2003	Ford	106479
99443FNBMC	Voyager	1994	Plymouth	446874
46067GSLFZ	Chariot	1992	Mitsubishi	314958
77967BWOSE	Corvette	2003	Chevrolet	43765
17938VKVHW	California	2010	Ferrari	26518
21214JLXTG	QX	2005	Infiniti	219590
05712RDYPD	MR2	1995	Toyota	88251
59209BOWWM	QX	2004	Infiniti	425508
52316ODVUI	Ion	2005	Saturn	273318
36354QYTKE	Econoline E250	1995	Ford	18862
98264UNIZW	LS	2009	Lexus	172018
40636CIOKK	LR2	2010	Land Rover	357263
38812NDHMB	C70	1999	Volvo	274035
90228VRHSD	650	2006	BMW	136259
11227TZKBE	Cobalt	2007	Chevrolet	225878
86489LGGLR	Maxima	2011	Nissan	36445
40064ONBBL	Escape	2013	Ford	221325
68599NGPQV	XK	2012	Jaguar	100964
62216RPJRT	Legacy	1998	Subaru	340729
51696DPHDB	Continental	1992	Lincoln	147084
13805BGLCX	LS	2009	Lexus	142831
30324SIUIM	Fusion	2008	Ford	305728
27952AFDKS	Grand Prix	1967	Pontiac	255511
82986VJCKO	Villager	1993	Mercury	29043
32507VMQCD	Escalade ESV	2006	Cadillac	132154
57372EXCNW	Tacoma	2010	Toyota	249662
65719NVUNR	Yukon XL 2500	2010	GMC	166204
77209FYEAY	Grand Prix	1986	Pontiac	401777
98366HVUNT	Escort	1986	Ford	89926
96926WJPQG	Murano	2007	Nissan	242611
60508FPBTK	C8	2006	Spyker	351016
96412CDNHL	Esteem	1999	Suzuki	89326
41591FUGWU	XC60	2011	Volvo	434673
92659KLGRG	Pathfinder	2006	Nissan	116194
90323WJNEJ	Corvette	1968	Chevrolet	66796
64439FBUIU	Mazda6	2011	Mazda	43799
90327VJIXZ	5000S	1988	Audi	279640
97312OCMVK	FX	2010	Infiniti	319721
89496WYPEF	Odyssey	1996	Honda	414429
46617WKRYE	Pilot	2012	Honda	224625
14709DXNZN	Explorer Sport	2003	Ford	311337
18086MDFGS	Passat	1991	Volkswagen	374868
79597KCPEF	B-Series	2003	Mazda	370167
49046RWQRA	F150	2012	Ford	80454
59568WVYAE	Rendezvous	2007	Buick	372630
87520JSKOK	Vibe	2009	Pontiac	447404
03760TBJHC	Fortwo	2012	Smart	132752
98261WJIOX	Regal	1987	Buick	237640
90148LJONU	Grand Caravan	1994	Dodge	411794
91252GQRXA	XK Series	1999	Jaguar	414603
74600EMJHG	X3	2005	BMW	146024
08402WNPSZ	Sienna	2003	Toyota	320842
63662IFOJF	Diamante	2004	Mitsubishi	15598
61812ZTTXW	G35	2007	Infiniti	458037
50487BOUSJ	Tundra	2005	Toyota	457792
61446CYJBC	F250	1984	Ford	358621
22341UYFKA	Courier	1986	Ford	100833
96167IROLX	330	2006	BMW	263808
69256QAEGN	3-Sep	2012	Saab	82266
94189TSEVP	Montero Sport	1997	Mitsubishi	41249
64195GRKOT	Cayenne	2009	Porsche	487677
13893BSZNE	Cougar	1995	Mercury	458449
11280NIIMM	MKS	2012	Lincoln	211247
31154MILFA	Accent	2005	Hyundai	402522
54774CYHDL	Swift	2000	Suzuki	392764
17571VNOGX	Protege	2003	Mazda	66843
26549MRDPI	Sequoia	2012	Toyota	80408
57227AUYBC	MR2	1992	Toyota	59524
17985LGROF	CR-V	1997	Honda	129888
04580SGTWO	GranTurismo	2012	Maserati	76434
66576OBXWU	Express 1500	1999	Chevrolet	78448
42516QUOZQ	Fit	2009	Honda	458943
36970UEOWD	Swift	1998	Suzuki	19485
79679IYBAE	Frontier	2002	Nissan	101852
91168FCHXU	V8 Vantage S	2012	Aston Martin	216141
34970FMAHF	3 Series	2010	BMW	53037
98202NZZPA	Yukon	2008	GMC	123513
28429ZCQES	T100 Xtra	1996	Toyota	365234
90007HVZZC	Aurora	1998	Oldsmobile	15440
98084DMXQT	5 Series	2006	BMW	166604
65799IZDMX	Corvette	1988	Chevrolet	13891
81808MJGXE	Elise	2004	Lotus	248716
41154DWFZS	Allante	1992	Cadillac	3671
27601ACGVR	Sidekick	1992	Suzuki	107944
60417RCEVK	LX	2009	Lexus	301947
18394GHJXY	Murciélago	2008	Lamborghini	270804
15474YOVSW	Golf III	1995	Volkswagen	345434
11492FUWAO	VUE	2007	Saturn	209895
28617NGTFX	G8	2009	Pontiac	69669
68583ZYSKW	F-Series	1985	Ford	368455
99586HDGOW	6000	1987	Pontiac	200177
33102PHOIM	Murciélago	2006	Lamborghini	126303
70447EUQNV	ZDX	2012	Acura	377342
88510XJWMX	Grand Cherokee	2004	Jeep	493742
82191KQKGZ	Tribeca	2008	Subaru	95175
04949HVCNU	i-290	2007	Isuzu	415495
42152KRUMN	Venza	2013	Toyota	482653
30907AMLTS	X6 M	2013	BMW	123757
10519ECDXP	Silverado 1500	2004	Chevrolet	382162
51377UQXMC	Explorer	1995	Ford	130073
06475DZHFU	Mustang	1973	Ford	212504
24362GAAMP	Crown Victoria	1998	Ford	445145
49116MQVGU	Rapide	2012	Aston Martin	387040
45188BVVQQ	3500	1997	GMC	159372
66675VNMUO	9000	1996	Saab	360425
71475FWVQK	2500	1998	Chevrolet	289203
76895SOEJY	XC90	2012	Volvo	335846
33720BJLTM	Suburban 1500	1992	Chevrolet	330586
63396QOWDA	Tribute	2003	Mazda	441030
46712WLLKG	Cutlass	1998	Oldsmobile	330355
72825NDMVB	Sebring	2002	Chrysler	492720
09892OETEV	Focus	2001	Ford	86179
97482YMHVP	164	1993	Alfa Romeo	467247
00326DAIRN	EXP	1986	Ford	432629
35898LSIFX	Escalade ESV	2004	Cadillac	289482
35134XPIWK	SC	1995	Lexus	236064
80899WSCNJ	Spirit	1995	Dodge	62132
55526YCNNL	Galant	1995	Mitsubishi	469196
22404YMKJW	Silhouette	1998	Oldsmobile	148255
94067FKYKZ	Grand Marquis	1985	Mercury	210309
43080XPCVY	Sierra 3500	2009	GMC	367520
25562YBEZK	Prelude	1995	Honda	17790
82668RTLKW	Civic	1985	Honda	211811
88501GNESF	Grand Prix	1974	Pontiac	125619
58526FDCYO	Ram 2500 Club	1995	Dodge	127749
36743TPMKI	ES	1999	Lexus	210764
51094WUYQY	F350	1996	Ford	488571
01828EUPTT	F250	2002	Ford	39780
10539ORYGN	Countryman	2012	MINI	355989
27011KAEQZ	Outback	2012	Subaru	201098
79311ODKCP	Thunderbird	1955	Ford	152736
56969KTUUU	Uplander	2007	Chevrolet	90855
75474OOKVH	Diamante	1994	Mitsubishi	187862
64621VPIRZ	Astra	2008	Saturn	382433
35559LFPRG	Maxima	1998	Nissan	176461
30119DODWC	Town & Country	1994	Chrysler	467289
47631HDOFH	626	1991	Mazda	454290
59610LNZOM	Mustang	2010	Ford	121095
92057NUFNZ	Daewoo Kalos	2005	Pontiac	48568
54539UOJVL	Rainier	2004	Buick	479870
69224NNZRT	Cavalier	2002	Chevrolet	99917
61999TAPVB	LeSabre	1995	Buick	284224
22749FVMPP	F350	1996	Ford	475297
15029HWKFE	Lumina	1998	Chevrolet	482270
81729JDGVG	Maxima	2009	Nissan	493390
38031LDJQK	DBS	2011	Aston Martin	404447
71674XHSXT	Suburban 1500	2002	Chevrolet	371799
80880WASYK	Monte Carlo	1995	Chevrolet	156554
47026MNXPV	Jetta	1985	Volkswagen	207005
47837RJVPW	Lancer	2005	Mitsubishi	72367
45520BPZBR	Tracer	1989	Mercury	438227
03292MOARD	Murano	2004	Nissan	293409
72108DPSJV	Festiva	1991	Ford	454152
64156CFSHL	Accord	1997	Honda	297501
09492YYWYI	4Runner	1996	Toyota	7004
74442LFLSP	Eclipse	1997	Mitsubishi	171742
18880OUCPV	Parisienne	1985	Pontiac	460019
36626BPCEG	Tracker	2004	Chevrolet	29719
48664ODVNQ	S2000	2002	Honda	362639
53112CWCXE	Mirage	1997	Mitsubishi	179994
41575MFRIQ	F-Series	2007	Ford	83252
58029OUURY	Avalon	1995	Toyota	9198
28401AOLZC	Wrangler	1997	Jeep	180539
10494AJMSP	Legacy	1997	Subaru	433817
65211ONPGA	Suburban 2500	2008	Chevrolet	363400
06072LQONZ	Envoy	2002	GMC	214490
14727CKDRT	Tundra	2000	Toyota	40032
74490MHLPB	Neon	1995	Plymouth	33473
86571YHSLU	Sierra 3500	2001	GMC	348067
83937OILKE	CLK-Class	2006	Mercedes-Benz	258198
69419XNWXX	Tracker	1994	Geo	128707
20659JUCNS	Yukon XL 1500	2007	GMC	396729
52430LKBSQ	Crosstour	2012	Honda	463745
62072JHOYG	Baja	2006	Subaru	369245
49033MRMAT	Quest	1999	Nissan	191379
31082BLAHM	W201	1985	Mercedes-Benz	465925
76617VKMAM	Sonata	2001	Hyundai	475550
10521XJCDA	Vanagon	1984	Volkswagen	63771
82496ZBJRE	Breeze	2000	Plymouth	159272
79979XAZPE	Prowler	2000	Plymouth	254960
53472SDJWW	Swift	2006	Suzuki	109548
57733MKQSQ	Outlander	2003	Mitsubishi	322511
93947BDOGV	Aurora	1998	Oldsmobile	269946
51523SDAJE	Jimmy	1994	GMC	197823
82537WTZYP	Shadow	1993	Dodge	203479
11061SFMMW	Grand Prix	1980	Pontiac	361764
05906UZZPF	LeSabre	1988	Buick	46697
46539LYRXI	Stylus	1992	Isuzu	195844
47517EWAIY	Aztek	2004	Pontiac	294054
71326LACBS	Pajero	1987	Mitsubishi	122359
78629PMKEO	Viper	2003	Dodge	317979
46015TXAUG	E-Class	1995	Mercedes-Benz	370027
14091QUTGZ	XLR	2006	Cadillac	285034
00941KIDBB	Blazer	1995	Chevrolet	407211
83973RDTLI	Ram 1500 Club	1997	Dodge	114817
58502YSVVQ	Grand Marquis	1989	Mercury	471597
37325WUWCL	Vision	1995	Eagle	134882
96144AFWOD	Allroad	2002	Audi	284630
34680FDDBU	DBS	2009	Aston Martin	363957
94538WKLCH	Swift	1999	Suzuki	456837
24195WGEJF	Mighty Max Macro	1994	Mitsubishi	48518
52900NWKYV	Prowler	2001	Chrysler	288048
58347SEHDB	Range Rover	1989	Land Rover	155141
83999OYQSN	Sidekick	1993	Suzuki	383560
18412REKOD	Sportage	1998	Kia	290511
09915IKGIG	GX	2009	Lexus	364204
95877NATAE	Accord	2012	Honda	68868
31260HPYRL	Monte Carlo	2002	Chevrolet	395679
99160KKWVG	PT Cruiser	2004	Chrysler	63385
34986JCITJ	Explorer Sport Trac	2000	Ford	410359
77518MYLDH	Escape	2009	Ford	357803
82870DZBTI	Mazda3	2004	Mazda	97715
98153DYFMZ	Paseo	1995	Toyota	337927
09304JJUWR	900	1999	Saab	73780
91671TODMF	Challenger	2002	Mitsubishi	201344
51465ZXUYJ	Rainier	2007	Buick	342966
53132PQROL	Tracker	1994	Geo	159162
29362AHQZD	5 Series	1992	BMW	327734
26200NBWJO	HHR	2009	Chevrolet	479846
39677EVEGE	Alcyone SVX	1993	Subaru	408008
66565JHAGP	Fusion	2011	Ford	81636
35448RVDHZ	M-Class	2006	Mercedes-Benz	482451
93843KMOAD	Econoline E250	1992	Ford	432149
80374WPTPY	Spyder	2003	Maserati	350076
61422DMBIC	Park Avenue	2001	Buick	136325
87942BYXHB	XT	1987	Subaru	72344
89439OWUVU	Murciélago	2006	Lamborghini	475271
04374ZSZIP	Daewoo Lacetti	2008	Suzuki	85627
30013PKDXA	Truck	1985	Mitsubishi	260055
56309HISCX	Solara	2002	Toyota	163498
94147ATZUE	SL-Class	1987	Mercedes-Benz	184629
77658NTBTH	V50	2011	Volvo	105153
21950KIGTH	Avenger	2008	Dodge	255470
70570FNGOV	LR2	2011	Land Rover	201733
59963VFYHX	Taurus	1992	Ford	340568
92487JWUEG	Quattroporte	2006	Maserati	482173
82410LKJHF	Suburban 2500	2007	Chevrolet	192262
92253FOXTE	Esprit	1992	Lotus	235117
08564GQKAI	Caravan	2003	Dodge	450229
16778EJYYT	Sidekick	1997	Suzuki	362722
50708ESFTL	Rapide	2012	Aston Martin	156587
64552UQITZ	A6	1998	Audi	43167
75880NRECW	911	1989	Porsche	28071
74017ZDXOP	E-Series	1988	Ford	276891
80101CTIGA	Swift	1995	Suzuki	468519
37406KLDAN	S10	1993	Chevrolet	353074
80464ZDVOD	Tempo	1993	Ford	155095
92569WZHKG	Ram 3500	2004	Dodge	160417
13436FAYAP	STS	2009	Cadillac	16882
98450DCQIU	Quattroporte	2010	Maserati	238403
13733CJKRF	Savana 2500	2010	GMC	326729
98263ZJICO	Tacoma	2012	Toyota	201069
98968BULEO	Sienna	2008	Toyota	38740
02306WJFXH	Ranger	1987	Ford	280265
17194OAYYQ	V40	2002	Volvo	269664
28697GIODY	Rio	2012	Kia	218204
17551ZXQKZ	SLK-Class	1998	Mercedes-Benz	62788
01319DFOCJ	RX-8	2006	Mazda	253636
93102WFJNJ	Accord	1994	Honda	457763
57676PBBLV	Explorer	1996	Ford	49033
55419TJGXI	Sebring	2002	Chrysler	226399
55417FUBNB	Grand Marquis	1994	Mercury	494949
67317PIYJD	Justy	1990	Subaru	218329
26803CTNGL	Maxima	1996	Nissan	398381
23777HOIMK	Lanos	1999	Daewoo	26507
72667JALEE	LHS	1996	Chrysler	155961
50972LKOCT	Ram 1500	1999	Dodge	364503
39148EJXGV	Grand Prix	1979	Pontiac	388508
90579QPEGR	Yukon	2001	GMC	185498
18438VEIDE	62	2012	Maybach	254850
59291JBSJQ	Taurus	2013	Ford	177797
50408NXCJX	F250	2001	Ford	159575
26824UZGUJ	300CE	1993	Mercedes-Benz	444915
05140HTMJJ	Esteem	1996	Suzuki	124450
94464MSAXV	Mazda6 5-Door	2006	Mazda	113945
96001XYMYP	Range Rover	1996	Land Rover	276526
55065SCYZO	S80	2004	Volvo	398558
75666EFYKA	Tacoma	2000	Toyota	172599
98326ZKMZO	E250	1984	Ford	207290
44780FKATF	Corolla	2010	Toyota	397419
78573IHAYW	Fit	2008	Honda	412659
50873UBMSV	Mark VIII	1996	Lincoln	275161
18135BKPVC	Aerostar	1996	Ford	295953
28730BKJRK	1 Series	2008	BMW	115763
17986NROLX	Milan	2006	Mercury	281330
57358EKBAB	EX	2008	Infiniti	119381
25472UHQOE	RX	2001	Lexus	314365
58593EAZGE	Montero Sport	1998	Mitsubishi	297078
77769MQJGK	Highlander	2006	Toyota	17435
79511VXFUL	Diamante	1998	Mitsubishi	214581
86855IIXOC	Econoline E350	1993	Ford	497971
66244NOEIP	911	1999	Porsche	290663
16974RKOGH	B-Series	1991	Mazda	102979
00623ICIPY	Ram	1994	Dodge	109800
36047JUMTB	B-Series	1988	Mazda	185917
34239JUNRC	Outlander	2004	Mitsubishi	404503
63899BWVPJ	Tundra	2005	Toyota	16577
87170HHSYK	Echo	2001	Toyota	363718
98635KZUXV	S4	2013	Audi	374278
91306FJDJZ	A4	2007	Audi	164337
81619OLIUU	Rendezvous	2007	Buick	335767
41022ABHPN	Tiburon	2009	Hyundai	139257
82952SWWYB	Malibu	2011	Chevrolet	237278
20335FWKOI	V40	2003	Volvo	226921
89274NGSJE	riolet	1996	Audi	175046
54204QZSNS	Venza	2012	Toyota	282793
52164GWZTU	Eurovan	2001	Volkswagen	448533
83911ZYYOH	E-Series	2011	Ford	406441
26240TNOYF	GS	2001	Lexus	494025
99839RRPNB	900	1988	Saab	124643
90413GAUBU	Range Rover	2007	Land Rover	114939
27029TUQLW	Sentra	2007	Nissan	455393
25524AJAKA	Grand Prix	1984	Pontiac	212786
56621PFUBS	Torrent	2008	Pontiac	105452
04519UHVQH	Century	1986	Buick	170467
43706EMVJG	Type 2	1991	Volkswagen	400849
09882LPMIL	Camry Solara	2006	Toyota	327429
93557WKWLF	Type 2	1989	Volkswagen	15818
90776QDDMI	Town Car	2004	Lincoln	45298
03344EGFIT	Samurai	1994	Suzuki	96250
46411LNRKV	Cherokee	1992	Jeep	174410
66589PNIBD	CLK-Class	2007	Mercedes-Benz	473263
14170LFHSA	911	1986	Porsche	93772
47352OLVTL	MKS	2009	Lincoln	99521
35399XCDWG	Azure	2007	Bentley	50979
17988EJTCY	Yukon Denali	2000	GMC	461975
32032FPCDD	Passport	1994	Honda	99459
61832VAZAO	Corolla	2004	Toyota	10502
33254LIUXG	Dakota	2000	Dodge	63701
87060TFBDM	Oasis	1998	Isuzu	310340
03007FRWZD	Paseo	1995	Toyota	346133
37010HTFYL	5000CS Quattro	1986	Audi	287706
39796JKVDC	LR3	2005	Land Rover	484199
33153ALSOR	Legend	1987	Acura	390061
30934ZWLPT	LR3	2006	Land Rover	283308
65736IBGFY	Pilot	2007	Honda	457876
66312DEYWY	V70	2006	Volvo	357920
88965WXSEE	Grand Vitara	1999	Suzuki	251484
94051JCNCB	Legend	1993	Acura	216129
18450GUDZW	IS-F	2011	Lexus	395141
87665MRIVK	Quattroporte	2005	Maserati	166685
33593KGPER	Ciera	1992	Oldsmobile	412990
43805YNLBP	1500	1995	GMC	42417
97448WZVNJ	H3T	2010	Hummer	102435
20647OPAOV	Starion	1986	Mitsubishi	186151
84443RWKCH	Intrepid	2001	Dodge	454365
36668HAIQP	ES	2000	Lexus	297980
99578WWEXL	Suburban 2500	1994	Chevrolet	388853
19016JTDLH	Suburban 2500	2011	Chevrolet	389646
55010OIDFH	E-Class	2011	Mercedes-Benz	424091
24521OZZBS	Odyssey	1996	Honda	80355
44308QTPJZ	M5	2006	BMW	294054
60593TQLIM	Accord	2004	Honda	32340
01532WCVPV	Spectra	2002	Kia	310614
75226PRUSX	Mazda3	2010	Mazda	379962
52032JSAZF	Cougar	1985	Mercury	159554
72996JOBDT	G	2005	Infiniti	176621
04078OCXVT	Mustang	1984	Ford	356261
90422GVMZI	Savana 2500	2002	GMC	279085
97818FHCGA	Ram 1500	1999	Dodge	380995
92975UZUWZ	Q5	2011	Audi	126869
20484SKCBE	Mazda6 Sport	2006	Mazda	255081
64925ECKCD	Express 1500	2011	Chevrolet	421331
38280IVXFM	Stratus	1999	Dodge	112125
56381OFLJL	62	2007	Maybach	306554
88922FXPGI	Impala	2002	Chevrolet	354532
58864XQAMD	Rally Wagon G3500	1996	GMC	394491
87832GQOTF	Crossfire	2005	Chrysler	77946
08250ZNHWB	LTD Crown Victoria	1989	Ford	458095
83412ADYMM	Accord	1991	Honda	283949
33791YJCAG	Milan	2007	Mercury	360628
18156SWSFR	Azure T	2010	Bentley	68987
51981IPUCX	DBS	2010	Aston Martin	106150
88059FEYKS	Sprinter	2010	Mercedes-Benz	233047
68518ABXUI	Soul	2012	Kia	360349
47411NEWEY	Somerset	1985	Buick	11103
29267VDUXW	Sunbird	1985	Pontiac	235535
07679SYGWK	i-280	2006	Isuzu	493782
01548KAQJU	Mustang	1979	Ford	287974
79886FVQSY	Viper	1997	Dodge	435218
06945QIUVE	CR-V	1998	Honda	457283
22555EAKIA	F350	1997	Ford	453508
22348KBZDW	Range Rover Sport	2010	Land Rover	257908
41179VMNTH	Alero	2000	Oldsmobile	417972
45386LEKDV	Tiburon	2006	Hyundai	404446
10697FSGVL	B-Series	2001	Mazda	306103
86997EHJLI	Golf	1985	Volkswagen	103572
39565QHVUX	Montero	2002	Mitsubishi	193342
22969HYMFK	Ram Van 1500	2002	Dodge	65014
04949VDTTD	Savana 1500	1997	GMC	344216
95569ZSINY	Legacy	2000	Subaru	10233
20106JLOHA	Expedition	1998	Ford	85984
18209NQAEE	S80	2000	Volvo	319242
46477ZSBMJ	Vega	1971	Chevrolet	58456
71763BRGIH	Suburban 2500	1995	Chevrolet	92369
78412MADDE	Integra	2000	Acura	462187
61705MEYNV	Sunfire	2002	Pontiac	346942
89873AYUTF	929	1994	Mazda	384741
80841RANTO	Grand Cherokee	1993	Jeep	166567
44719ISBDU	Impala SS	1995	Chevrolet	293627
87383SMMJP	STS	2006	Cadillac	117138
87601EZWIZ	GS	1993	Lexus	372283
16568VLPFN	Lanos	2000	Daewoo	32450
41314YUJMH	Caliber	2010	Dodge	419604
17457YYMEA	G6	2009	Pontiac	286910
72349HTXSO	Venza	2013	Toyota	266051
12908UMWJM	S40	2011	Volvo	373481
19830MIIVI	LR2	2011	Land Rover	48404
17697YXHFP	Z4	2012	BMW	370837
70237YXKGL	DBS	2010	Aston Martin	240127
56118JWQYC	HS	2010	Lexus	153446
76767FGIPX	Seville	2002	Cadillac	15500
43759QJBHF	GTI	1989	Volkswagen	353146
53573IOOQH	Riviera	1993	Buick	454301
78898SLWZR	Spyder	1991	Maserati	110862
96195IXSNV	Insight	2005	Honda	236930
85931GHKMZ	325	2005	BMW	88290
41226KXNQT	Passat	1990	Volkswagen	194514
48380RGJSL	Laser	1989	Plymouth	223356
58732FNFYS	Impreza	1996	Subaru	73781
54500WAHBI	Galant	2005	Mitsubishi	6629
41760ZJBTB	RL	1996	Acura	238313
09488TJHLH	Nubira	2002	Daewoo	483639
16930WOHGJ	New Beetle	2006	Volkswagen	405247
54622PMOOV	S-Class	2006	Mercedes-Benz	201689
14634UVOYV	Park Avenue	2000	Buick	333964
29728LYBMP	Voyager	1993	Plymouth	13249
92277HORKE	Supra	1998	Toyota	238483
33064KUTQQ	Achieva	1992	Oldsmobile	279218
98780OPNKW	525	2006	BMW	368308
07109PJTSV	Suburban 1500	2003	Chevrolet	328589
73035EDAFW	Expedition	2007	Ford	340573
11711NMGUC	F-Series	1994	Ford	407003
95088LXOVX	458 Italia	2011	Ferrari	356887
94725ZTXON	240SX	1992	Nissan	155860
61399ZWBZL	Dakota Club	1995	Dodge	266531
04701ZOLDB	Camaro	1971	Chevrolet	168503
92213DLKXD	Stratus	2002	Dodge	249587
08419QVPWS	Esprit	1994	Lotus	463143
74689PIGJQ	Ram 1500 Club	1999	Dodge	438844
28139BNNAV	Grand Voyager	1993	Plymouth	374060
30459UONYL	Savana 1500	1997	GMC	364566
79012GRPLQ	Impala	1995	Chevrolet	480812
05978KDOVL	Ridgeline	2008	Honda	12807
18596GENIP	New Yorker	1994	Chrysler	235887
01494OVQWH	Camry	1996	Toyota	280455
48344WXMAY	GranTurismo	2010	Maserati	108542
43770XSTOR	Silverado 1500	2011	Chevrolet	60738
48079RDLFW	Z4	2006	BMW	187115
54590TMBJX	Navajo	1994	Mazda	264123
94309WRZWU	Accord	2011	Honda	107584
68583FAKRX	Pathfinder	2005	Nissan	378048
14287UDVJD	Milan	2007	Mercury	329680
48197QRCSV	Coupe GT	1986	Audi	487638
88775RIWSI	325	2005	BMW	335513
10194EHAQV	Durango	2004	Dodge	413213
92304UNEDD	Colorado	2010	Chevrolet	202468
08359UDDJH	Integra	1988	Acura	133854
32274PSSME	M3	2011	BMW	323574
56315HBJDL	Relay	2007	Saturn	79351
99455DOILE	Caliber	2012	Dodge	186231
12472VXVFN	Achieva	1998	Oldsmobile	360393
13490GDTEG	Hombre	1997	Isuzu	314900
62844ELAII	Hombre Space	1998	Isuzu	279990
17880OXUIX	550	2006	BMW	2037
27000GMUIY	ES	2001	Lexus	492455
72167KSBLV	Grand Prix	1964	Pontiac	367030
01723VPLVF	Escalade EXT	2003	Cadillac	281304
75989CDGPP	Dakota Club	1994	Dodge	255450
95762FRNWC	H1	1994	Hummer	301561
98288DNISJ	Mazda2	2011	Mazda	499783
97894PKFPJ	Thunderbird	1965	Ford	395733
15518EXJBF	Town Car	2004	Lincoln	88407
79693HGBRI	EXP	1986	Ford	348667
78892WMMQS	Camaro	1978	Chevrolet	155597
58369APSCZ	MDX	2007	Acura	169560
26539DFUEH	Thunderbird	1993	Ford	124704
10898CFMBN	Silverado 3500HD	2006	Chevrolet	457129
38844QFCKD	Capri	1986	Mercury	421552
20811BADAX	Rio	2008	Kia	457512
14214WWKAC	Range Rover	2007	Land Rover	378185
56522DAXMJ	Suburban 1500	1994	Chevrolet	235364
62893KFNYK	Rodeo	1998	Isuzu	17802
06393UYURW	Insight	2011	Honda	420087
34984QQONX	F250	1984	Ford	288069
05124GMHLP	Neon	1999	Plymouth	313994
39041VVQQY	Escort	2002	Ford	408483
43909YTJOR	Mustang	2006	Ford	135578
16803SSUXO	Ion	2005	Saturn	84538
03597BEPFP	Parisienne	1985	Pontiac	464206
16274PMMTW	900	1996	Saab	260290
37917PBSQA	Voyager	2001	Chrysler	162997
00211KNHPY	Regal	2000	Buick	462327
15779TJRDG	Carrera GT	2005	Porsche	86577
37860UREZL	Aspen	1976	Dodge	398635
94748HAFWV	GTI	2001	Volkswagen	49185
44477YGYGE	Aerostar	1989	Ford	289658
29096NSMAS	Escape	2004	Ford	489817
91105IBPZP	Malibu	2007	Chevrolet	460529
92709ZIIDQ	A5	2011	Audi	499012
94914NJOIB	Econoline E250	1994	Ford	319898
18805CMUUQ	S6	2003	Audi	2930
29654ZBZUE	MX-5	1991	Mazda	248140
37247NHEMJ	80	1991	Audi	413383
28187WECJU	Precis	1990	Mitsubishi	10112
90995EAZAC	XL-7	2004	Suzuki	323952
42286DUHRO	Focus	2011	Ford	483901
28880MLRCX	Grand Voyager	1994	Plymouth	276367
76437IDXEN	LR3	2007	Land Rover	338641
80837MMFJJ	Grand Cherokee	1993	Jeep	237982
22166ZNXXW	CL	2003	Acura	498599
62717IRTCU	Impala	1996	Chevrolet	372425
54183ISXOI	MR2	1995	Toyota	372592
18665HQEWK	S80	2000	Volvo	124580
16591BTVDV	Phaeton	2005	Volkswagen	210745
95415BBDGU	Silverado 1500	2006	Chevrolet	479325
23973RYGSX	Vantage	2009	Aston Martin	402157
04063YNFDY	Corolla	1995	Toyota	341622
08072KUDMX	Bonneville	1987	Pontiac	368833
87187LTFRI	Custom Cruiser	1992	Oldsmobile	420712
48273GCDBO	Voyager	1992	Plymouth	475673
76647IXEYL	CX-7	2010	Mazda	109073
23314YLVAG	Land Cruiser	1997	Toyota	200020
95281CBWSG	LUV	1979	Chevrolet	440549
80781MFHHB	Vandura 3500	1994	GMC	232195
78245SQVCC	Escort	1987	Ford	373652
39394UMBCW	NSX	1997	Acura	323848
20051SESHR	SL-Class	2008	Mercedes-Benz	51109
01431IAKBT	3-Sep	2007	Saab	450085
87272JHHZY	Legacy	2011	Subaru	299042
94471RXMZL	Falcon	1967	Ford	463493
69920WSWLY	525	2005	BMW	382690
89969KILEX	MKS	2010	Lincoln	46798
27944IERWQ	M3	2001	BMW	33307
41009SAJBG	E-Series	1996	Ford	456713
28142RWGUX	Capri	1986	Mercury	156639
98984KWNJS	Jetta	1988	Volkswagen	160723
08979AJCTN	Voyager	1992	Plymouth	25332
18069JEKZX	Jetta	2004	Volkswagen	400556
02213CMVHW	Avalanche	2007	Chevrolet	31703
30883QKOAI	CR-X	1988	Honda	432275
94612GXBPD	MX-5	1990	Mazda	234488
24818NFWSM	SL-Class	2002	Mercedes-Benz	332441
75648HSRCU	Leone	1986	Subaru	165859
43918YTPGK	Pajero	2005	Mitsubishi	308418
77252CWIVP	Xterra	2007	Nissan	462128
48349KGRQN	Monte Carlo	1995	Chevrolet	168607
75039RRBIM	Avanti	1964	Studebaker	263376
87542KDGRF	Lanos	1999	Daewoo	446448
76826FRPWL	Yaris	2012	Toyota	72637
15885NMYNU	2500	1995	Chevrolet	217939
96680YMJEE	2500 Club Coupe	1992	GMC	45874
63009WSORQ	HS	2010	Lexus	484173
43745YXLQF	Econoline E150	1999	Ford	310418
04951DZBOV	Freelander	2001	Land Rover	121872
82463SLBQJ	Millenia	1995	Mazda	206530
45106TTLUI	Eclipse	2007	Mitsubishi	199187
34606UJZUX	Firebird	1991	Pontiac	386032
86816TVFKY	Yukon XL 1500	2006	GMC	345655
32900UKOAR	E-350 Super Duty	2006	Ford	102474
43426GNHSZ	Phantom	2009	Rolls-Royce	304705
77897OLOUH	IS F	2011	Lexus	197663
27183UCYYK	Crown Victoria	2003	Ford	364197
69883QWJIB	Quattroporte	1984	Maserati	39303
05990MHHPQ	X5	2005	BMW	259184
91792ZKQEY	Crown Victoria	2007	Ford	305658
48782KYYPX	Legacy	2003	Subaru	215591
18817XCOVL	Patriot	2010	Jeep	356101
40420IIGXR	Esperante	2005	Panoz	47768
15160UWRDK	MDX	2005	Acura	283929
51719WOCFX	9000	1999	Saab	155347
75659CANUI	Avalon	2009	Toyota	278705
91228XYFEF	F-250 Super Duty	2006	Ford	203099
77339QGDRT	Dakota Club	2006	Dodge	214105
32934YFHPX	SLX	1997	Acura	301962
89812KYRBN	IS-F	2012	Lexus	157160
38846OCLNS	PT Cruiser	2005	Chrysler	281584
91714PMWGZ	RDX	2008	Acura	126901
16680LBWDS	Elantra	2006	Hyundai	436775
45039SFQZZ	Crossfire	2005	Chrysler	288824
78644ARPBB	Daewoo Magnus	2006	Suzuki	208384
40941RUNTD	Grand Marquis	2000	Mercury	392244
50448QTDFA	Tacoma	2011	Toyota	463884
16854NROKX	300TE	1992	Mercedes-Benz	377789
54754UZWQC	Rondo	2007	Kia	83376
05765BIIWK	Corvette	1986	Chevrolet	491309
09861AHOKU	SLR McLaren	2005	Mercedes-Benz	428680
12315JMLKQ	Protege	1996	Mazda	376937
38185EWOVY	CTS	2005	Cadillac	364061
35127WPVDE	X5	2012	BMW	291454
24364UXSMY	A6	1999	Audi	476456
57906JHDZC	Defender	1993	Land Rover	359166
06842FUCZP	Suburban 2500	1999	Chevrolet	171660
54726CSUMP	Eclipse	2000	Mitsubishi	155578
07978HJDFF	Galant	2010	Mitsubishi	381208
61541OEBVQ	H1	2000	Hummer	39664
34124MHRPZ	Passat	1988	Volkswagen	326549
38252QRMBD	XC70	2005	Volvo	72789
94687ZQHAL	Navigator L	2009	Lincoln	227644
21165KTCQU	Continental	2009	Bentley	466299
21016WZHPY	TL	1999	Acura	376103
35420VGDSQ	MKX	2011	Lincoln	157699
92010YINZZ	GTI	1992	Volkswagen	206542
32561TDJXX	Focus	2008	Ford	470005
49461RMATA	Rally Wagon 2500	1994	GMC	274548
51326EZNTE	Sentra	2012	Nissan	424574
52669QCYCQ	F-Series	1995	Ford	394165
17548PIQQJ	Grand Vitara	2008	Suzuki	35913
12970UARGZ	Bronco II	1990	Ford	65531
07615MWEEQ	SL-Class	1987	Mercedes-Benz	199007
98913KMPIU	Sonata	1995	Hyundai	96229
42116HUHNN	S8	2001	Audi	477934
21411PUYKY	Quest	2002	Nissan	129857
59762ZHSFL	Element	2009	Honda	383255
87004INLXL	Grand Caravan	1995	Dodge	399334
69307AWTRL	Stylus	1992	Isuzu	108453
11785NAGDJ	57	2011	Maybach	382109
96172KKDAZ	X5	2001	BMW	89112
78422ZNJQW	F250	1998	Ford	131838
97718LHOOR	S10	2003	Chevrolet	461045
08005RQFKH	Passat	2009	Volkswagen	405922
14481MBKRC	Ranger	2007	Ford	163463
29876NPJSR	Venture	1999	Chevrolet	401549
81446BMZDP	Passat	2000	Volkswagen	408466
15061HYBKU	Tucson	2011	Hyundai	193981
53984EIGXS	Swift	1993	Suzuki	424279
56739BDJCN	LS	2002	Lexus	64063
65212QFVHM	Tracker	1994	Geo	350897
64066IWZIF	Explorer Sport Trac	2000	Ford	51351
85723AKFLJ	745	2004	BMW	410354
34096NEIPP	IS	2005	Lexus	307451
37589RLYFX	Voyager	2000	Plymouth	321012
79336NCUYK	Touareg	2010	Volkswagen	157850
25851WCQLQ	Boxster	2013	Porsche	63817
64053MMDSL	X5 M	2010	BMW	198485
34800GVUXT	Talon	1995	Eagle	466059
75492PVPZW	E250	2004	Ford	339623
32101LKMGP	Bronco II	1989	Ford	339664
42421FYLXR	E250	2009	Ford	375246
29093DXEOB	LX	2000	Lexus	75771
27979ARDYX	GT350	1969	Shelby	415840
55337ROFVF	944	1986	Porsche	445347
45598IXMVE	Phaeton	2004	Volkswagen	166863
50608XUYQU	F-Series	1985	Ford	392282
95547USQVK	Impreza	1994	Subaru	359300
97408KSKJJ	Civic	1997	Honda	321184
34592YLXLI	Stealth	1995	Dodge	186009
45152QOKVW	Endeavor	2005	Mitsubishi	93668
89312KGPJO	Tempo	1992	Ford	292494
62922YKQAJ	NSX	1995	Acura	361001
43970IVQAJ	Galant	1997	Mitsubishi	329082
06320XSJSS	Discovery Series II	2000	Land Rover	324006
76661OTDDR	Suburban 1500	2006	Chevrolet	25356
70958RBZLX	Esprit	1995	Lotus	189442
06001NKLAN	Escalade EXT	2009	Cadillac	9600
25250UTYYV	Range Rover Sport	2007	Land Rover	484260
01406KUXVD	Fury	1964	Plymouth	70317
17778IMUPL	Taurus	1992	Ford	345087
35653BQZOA	Grand Caravan	2007	Dodge	324324
78718XQEYB	Eclipse	1989	Mitsubishi	207363
44233ZFMEZ	GTO	1995	Mitsubishi	468157
12816PBYDA	Sunbird	1989	Pontiac	147572
79863DFUHL	Cirrus	1997	Chrysler	147019
60975CMNNU	Econoline E350	1993	Ford	227793
79316GUIGF	5 Series	2001	BMW	400692
68270OVIHG	E250	2003	Ford	391806
86460CEEXS	Mountaineer	2003	Mercury	448791
68873DZUXK	Forester	2007	Subaru	369575
70830HDXGC	Ram 3500 Club	1997	Dodge	488862
17457YNWTJ	9000	1990	Saab	389467
96133JTYFG	Accent	1998	Hyundai	7186
07754EHINO	Rio	2001	Kia	45790
58141UTZEH	Expedition	2009	Ford	277849
00194RJOQO	Econoline E150	1999	Ford	173261
69745KKKEJ	Caprice	1996	Chevrolet	195827
25099CVDEF	Colorado	2010	Chevrolet	414548
31893VCKAU	Sable	2002	Mercury	54806
50861VIENB	STS	2009	Cadillac	412784
03480MQMUN	DTS	2011	Cadillac	296515
21786AHTKC	626	1995	Mazda	2817
64388YZZQA	Maxima	1992	Nissan	23824
01971CLJDS	Accord	2001	Honda	412669
85766REUMB	Yukon XL 2500	2013	GMC	5667
52511OLPQU	Lancer Evolution	2003	Mitsubishi	361647
60680TXCDF	Tundra	2007	Toyota	195424
82313TZCPT	Town Car	1993	Lincoln	101626
94827JFOVX	Civic	2011	Honda	465887
70233OOOAE	Esprit	1996	Lotus	69985
52287RALGB	Quest	1996	Nissan	1417
15288KTJBB	LeSabre	1990	Buick	42663
62739OFJPR	Sebring	2010	Chrysler	134084
30944RLAHF	Tacoma Xtra	2000	Toyota	88591
71096VUOPL	Galant	1986	Mitsubishi	208246
17090OGHKW	Cruze	2013	Chevrolet	312976
31114DBJWW	Reliant	1981	Plymouth	271797
62157LPZBI	Cabriolet	1998	Audi	430635
77514ACBAX	5-Sep	2004	Saab	375629
47420GYNCQ	612 Scaglietti	2008	Ferrari	179086
67000KMRJA	SLS-Class	2012	Mercedes-Benz	283671
47325DVSWX	Savana 2500	2010	GMC	467553
44803EDBAM	V50	2007	Volvo	383434
00149ZQTFT	Fifth Ave	1992	Chrysler	361433
30975YMEQZ	Freelander	2002	Land Rover	493143
18858HXRFF	H2	2009	Hummer	142712
57622SGJCI	100	1990	Audi	122986
07227UANOL	Cooper	2006	MINI	136188
31562IMFKA	Expo	1993	Mitsubishi	140252
37147KJKIX	Truck	1993	Mitsubishi	342094
53742KMRUH	XC70	2005	Volvo	240502
32574TJMMG	Quest	2008	Nissan	125928
18028AGRHJ	Ram 2500	1994	Dodge	71317
52779OGEKM	Sierra	2011	GMC	353999
27048QIXDY	Cougar	1995	Mercury	156884
76320LTCKR	Raider	2008	Mitsubishi	254528
61110PXRTD	Endeavor	2007	Mitsubishi	18827
79146KCSRV	Ram Van 2500	1998	Dodge	3657
91424KGOPU	Express 1500	2001	Chevrolet	146757
39025MSWST	CR-V	2008	Honda	121315
66676ABBQD	LS	2005	Lexus	218638
37048AJURW	Altima	2010	Nissan	241718
95453IULQJ	Pajero	1998	Mitsubishi	167018
69602ZSOFV	Safari	1989	Pontiac	69624
55516XKPBY	Colorado	2010	Chevrolet	183570
07114RBHSB	Bravada	1998	Oldsmobile	286185
20176SJBTL	TT	2008	Audi	184532
14411GBHIL	A4	2005	Audi	487228
05678EMILP	Escape	2009	Ford	267757
75070QUKOJ	Milan	2006	Mercury	209712
50914AAFXV	Liberty	2003	Jeep	270969
08353WWAVJ	Prizm	1998	Chevrolet	427465
67389RHKTM	Thunderbird	1985	Ford	34828
34857YMOPT	Discovery	1997	Land Rover	119497
91190HQQOM	Focus	2011	Ford	126832
34638IMJLQ	Windstar	1998	Ford	134507
56379EQLSP	A6	2004	Audi	251182
93180YZCWD	Familia	1985	Mazda	265595
34485NKMIT	PT Cruiser	2006	Chrysler	5090
28652SQBDI	TL	1997	Acura	256634
19365QRDVU	J	1997	Infiniti	139280
48380OBGCZ	IS-F	2011	Lexus	395568
57009CZJJJ	Terraza	2005	Buick	413001
87702WZDAG	QX56	2007	Infiniti	282603
36744QMDVN	APV	1992	Chevrolet	115011
39907ZJBLI	Quattro	1992	Audi	233529
46241SBHLZ	Sportage	2001	Kia	101762
73297IWFBR	F350	2012	Ford	74954
99575WFAFO	Magnum	2008	Dodge	112106
00852BHAZY	CR-V	2005	Honda	1461
40741ESNZG	F350	2001	Ford	149306
32115VCKZK	H2	2006	Hummer	350611
75192JUNUF	5000S	1986	Audi	254960
96218ABRBF	Capri	1992	Mercury	217230
80223VUJGC	Arnage	2006	Bentley	36940
53146TNJBD	Mirage	2000	Mitsubishi	173205
14026XGOFB	Leaf	2012	Nissan	170768
16417SRTUC	Town & Country	2006	Chrysler	308239
61995KODCA	SL-Class	1989	Mercedes-Benz	379731
46977GOJVX	Prius	2006	Toyota	327070
38084AKFTF	Regal	1986	Buick	427285
79649PZNSS	S2000	2005	Honda	159795
57642CRHVA	Sienna	2010	Toyota	189199
92416FQEFH	R-Class	2010	Mercedes-Benz	174094
24506HXHSH	B2000	1985	Mazda	254609
94108XOHKJ	Quattroporte	1984	Maserati	282078
11011IBKDW	Impala SS	1994	Chevrolet	138081
47691HYGWN	Raider	2006	Mitsubishi	28799
44496EOWRH	SLK-Class	2012	Mercedes-Benz	406039
49720XLQEU	Quattroporte	2011	Maserati	400587
91144USBXX	88	1996	Oldsmobile	12836
31735HBFSI	900	1984	Saab	218215
34467HGPWD	Windstar	2003	Ford	241363
12103LAZLK	SSR	2006	Chevrolet	250529
09012NUHML	Explorer	2010	Ford	355367
58399NLBKE	Tiburon	1998	Hyundai	396645
22756DBYLX	944	1983	Porsche	175596
15185HWTBA	F250	2004	Ford	484746
75815TGSVU	Festiva	1990	Ford	166352
85912KVZJF	C-Class	2001	Mercedes-Benz	382494
88195RMUEX	H1	2001	Hummer	463094
59077SNJIY	Yaris	2008	Toyota	351559
22021ULYJS	Yukon XL 1500	2005	GMC	87400
88472VTJEC	Mystique	2000	Mercury	211440
97001TLQPC	Avalon	2002	Toyota	270477
58325ORUAZ	G	2009	Infiniti	163471
81147MDQYB	Touareg	2007	Volkswagen	274223
28801SZPDC	Expedition	2002	Ford	471511
81081BCDTT	Ciera	1996	Oldsmobile	232623
24649UCDHO	Range Rover Evoque	2012	Land Rover	102071
03600ITRRM	Express	2008	Chevrolet	467291
48571KRBNJ	Wrangler	1995	Jeep	116363
86958OHKFR	Millenia	1998	Mazda	271136
49862FABJQ	C8	2006	Spyker	188284
18703MNTLG	G	2002	Infiniti	80187
32132GZVSJ	Suburban 1500	2003	Chevrolet	356747
70804JELWG	New Beetle	2005	Volkswagen	200098
03087EBXCQ	Electra	1989	Buick	90041
28612DXLPK	280ZX	1979	Nissan	17554
98461HXEDT	Genesis Coupe	2011	Hyundai	457872
33408HONDG	APV	1992	Chevrolet	436151
67549LCARX	Sierra	2009	GMC	163781
71603QBWCX	Avalon	2011	Toyota	328719
80854GBORP	SLK-Class	2002	Mercedes-Benz	89023
82959JEJNO	Windstar	1998	Ford	143837
82330AQIWO	Esprit	1992	Lotus	80832
39756OXHCY	Fleetwood	1993	Cadillac	17391
31608DVPAE	Expedition	2006	Ford	429581
78299EZWYS	Bronco	1989	Ford	124947
94552SOOMQ	Raider	2008	Mitsubishi	315982
\.


--
-- Data for Name: violations_info; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.violations_info (violation_id, violation_code, date_time, description) FROM stdin;
9068USLR	326	2020-11-07 00:00:00	Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.
0659DUWY	357	1995-11-02 00:00:00	Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.
3051JAUH	55	2019-12-16 00:00:00	Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.
4901PXJJ	239	2016-01-16 00:00:00	Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.
2959FNMR	69	2014-08-16 00:00:00	Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.
0671BNMM	426	1999-11-28 00:00:00	In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.
9050DPSZ	135	1995-05-19 00:00:00	Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.
2292PZFD	131	2012-10-24 00:00:00	Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.
9662PQMH	7	2009-03-24 00:00:00	Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.
0555KZDH	328	1994-01-23 00:00:00	Phasellus in felis. Donec semper sapien a libero. Nam dui.
5788TEWX	280	1993-04-08 00:00:00	Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.
0238OTKQ	191	2000-01-09 00:00:00	Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.
8482CESG	198	1996-11-01 00:00:00	Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.
6070UMKH	483	2003-08-29 00:00:00	In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.
1726UEUU	450	2013-11-29 00:00:00	In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.
7254JYLZ	31	1991-08-31 00:00:00	Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.
6731ZVRX	27	2015-11-23 00:00:00	Sed ante. Vivamus tortor. Duis mattis egestas metus.
1535HBLH	398	2012-12-02 00:00:00	Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.
3349ZIAK	424	2011-05-07 00:00:00	Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.
7625FOSQ	494	1997-10-19 00:00:00	Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.
2413CPXZ	38	1992-08-28 00:00:00	In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.
2374RNRL	245	1997-11-19 00:00:00	Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.
2629IBDZ	477	1994-03-10 00:00:00	Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.
7579YDEH	148	2001-06-30 00:00:00	Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.
8048YWRO	310	2013-12-14 00:00:00	Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.
9326PSIW	228	2016-12-21 00:00:00	Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.
9407AZSX	118	2014-10-22 00:00:00	Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.
3777TOSQ	164	2017-12-11 00:00:00	Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.
9175MPUE	479	1991-02-26 00:00:00	Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.
4019LVIF	187	2000-02-06 00:00:00	Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.
8045WWCM	462	2013-12-05 00:00:00	Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.
3845FPGE	78	2010-01-15 00:00:00	Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.
0461YBIT	377	2016-08-06 00:00:00	Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.
1893JVVW	252	2019-11-03 00:00:00	In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.
4091YQNW	266	2002-06-24 00:00:00	Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.
3895PLZD	410	1996-04-06 00:00:00	Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.
5433QFAY	315	1993-07-11 00:00:00	Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.
5057WCLD	103	1997-06-29 00:00:00	Fusce consequat. Nulla nisl. Nunc nisl.
2290KXVE	276	2003-01-29 00:00:00	Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.
3616CYGA	180	2009-06-07 00:00:00	Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.
9974TYBR	146	2012-06-05 00:00:00	Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.
1413TYSR	466	2013-12-02 00:00:00	Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.
1562RIFC	346	2010-05-20 00:00:00	Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.
5991PXCD	443	2009-12-09 00:00:00	Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.
7404DNVC	489	2012-03-03 00:00:00	Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.
1359XNKA	436	2008-01-03 00:00:00	Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.
2065PCXC	109	2007-09-09 00:00:00	Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.
3491QDIE	204	2018-01-07 00:00:00	Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.
6580GSFC	476	2001-05-29 00:00:00	Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.
6489LABM	18	2003-04-23 00:00:00	Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.
8223JORF	140	2000-09-18 00:00:00	Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.
9421DZOJ	353	2018-11-05 00:00:00	Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.
4448UGTW	367	1993-12-26 00:00:00	Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.
6823FBOX	98	2008-03-25 00:00:00	Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.
8321LELY	191	2016-07-22 00:00:00	Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.
8130AMCQ	423	1990-12-24 00:00:00	Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.
7652TXQZ	69	2007-07-08 00:00:00	Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.
1283PUDF	82	2000-08-25 00:00:00	Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.
7948XAZF	216	2015-01-02 00:00:00	Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.
7141ZTFU	240	2001-05-07 00:00:00	Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.
8957ERZG	189	2007-04-05 00:00:00	Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.
7810PLKO	408	2002-07-26 00:00:00	Sed ante. Vivamus tortor. Duis mattis egestas metus.
6839ZQLK	323	2003-04-15 00:00:00	Phasellus in felis. Donec semper sapien a libero. Nam dui.
0064CWLR	109	2016-03-15 00:00:00	Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.
7114ENQC	136	2001-01-31 00:00:00	Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.
0184ALBR	158	2008-03-06 00:00:00	Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.
1084UFDM	341	2011-11-16 00:00:00	Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.
4199QEVB	234	2010-09-21 00:00:00	Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.
5022PEJJ	328	1994-01-29 00:00:00	Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.
3484BOHR	431	2021-05-11 00:00:00	Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.
7415CISJ	114	2016-02-07 00:00:00	Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.
2067KZVP	244	2014-01-25 00:00:00	Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.
8960DSRL	50	2014-02-10 00:00:00	In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.
4854BWQI	148	2020-06-29 00:00:00	Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.
6325WESN	416	1997-10-03 00:00:00	Phasellus in felis. Donec semper sapien a libero. Nam dui.
4415NHWV	54	2014-03-11 00:00:00	Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.
4046MOGY	242	1999-01-15 00:00:00	Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.
5355STDC	321	2014-02-06 00:00:00	Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.
1527ENOB	358	2009-03-13 00:00:00	Sed ante. Vivamus tortor. Duis mattis egestas metus.
7250FCWL	315	2006-04-02 00:00:00	Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.
0823BRBK	123	1996-05-05 00:00:00	Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.
4179YVDG	211	1998-06-02 00:00:00	Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.
8937UMUG	131	2009-05-25 00:00:00	Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.
6020UMBM	239	2016-04-11 00:00:00	Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.
9194LYKX	437	2001-09-10 00:00:00	Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.
1727VJHG	37	2010-10-18 00:00:00	Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.
7094ZVMA	247	1994-12-07 00:00:00	Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.
4470NNFI	7	1990-09-05 00:00:00	In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.
2856XISN	427	2012-02-20 00:00:00	Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.
7795SHZY	499	1999-12-01 00:00:00	Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.
8521XSHX	259	2015-04-26 00:00:00	Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.
5035XJPQ	113	1999-08-18 00:00:00	Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.
2521YZCW	279	2006-07-28 00:00:00	Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.
3771NBPT	473	2002-01-16 00:00:00	Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.
1637DZNG	258	1998-03-31 00:00:00	Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.
7328MUIX	458	2018-06-13 00:00:00	Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.
6146JKQM	411	1992-03-04 00:00:00	Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.
2553YSGV	100	2004-12-14 00:00:00	Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.
9400MLLL	168	2020-12-15 00:00:00	Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.
1648NINM	292	2015-12-19 00:00:00	In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.
1390BRMQ	225	1992-07-17 00:00:00	Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.
4343PSFE	433	2013-07-22 00:00:00	Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.
2384EGNT	383	1997-06-27 00:00:00	Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.
5471LLEH	58	2017-12-14 00:00:00	In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.
9829DVVO	338	2007-08-01 00:00:00	Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.
2559PIGC	257	2011-06-13 00:00:00	Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.
4065MCQO	437	1998-09-30 00:00:00	Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.
2892XFSE	364	2018-03-15 00:00:00	Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.
3024TNNG	71	1993-10-01 00:00:00	Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.
7442XCQB	28	1991-04-30 00:00:00	Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.
0728YAKW	53	2007-05-01 00:00:00	Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.
0995OCET	209	2014-05-17 00:00:00	Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.
6443BMOS	370	1991-04-14 00:00:00	Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.
6644EQQC	222	2004-02-06 00:00:00	In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.
9296JFCF	316	2006-04-18 00:00:00	Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.
0666PERQ	139	2001-03-05 00:00:00	Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.
1685KUWT	87	2007-02-07 00:00:00	Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.
3069KIQQ	126	2007-11-27 00:00:00	Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.
9115OWGB	38	2006-11-29 00:00:00	Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.
7268MYJJ	191	1997-01-24 00:00:00	Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.
8247TKCV	59	2001-02-28 00:00:00	Sed ante. Vivamus tortor. Duis mattis egestas metus.
8036FCMP	2	1995-08-22 00:00:00	Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.
3388KOFD	22	2010-01-22 00:00:00	Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.
4501EGFO	441	2005-09-20 00:00:00	Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.
5149XUFY	419	2011-12-01 00:00:00	Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.
7890WITN	421	2007-01-07 00:00:00	Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.
5732ZGRX	198	1996-12-25 00:00:00	Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.
5046INZE	330	2006-01-01 00:00:00	Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.
7364RMTM	391	2005-02-13 00:00:00	Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.
1896JYTD	116	2006-06-24 00:00:00	Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.
3203LOYP	477	1996-05-16 00:00:00	Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.
5312ZZHV	12	1992-11-08 00:00:00	Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.
5569OKKA	476	2020-04-01 00:00:00	Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.
3214TXVU	115	1992-12-28 00:00:00	Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.
5394PUOB	105	2009-05-07 00:00:00	Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.
1361PSEG	500	2008-05-18 00:00:00	Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.
4930JFKQ	468	2016-01-26 00:00:00	Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.
9214EDWU	184	2018-11-05 00:00:00	Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.
2166VFJU	199	2007-03-13 00:00:00	Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.
3215WHVF	104	2002-11-26 00:00:00	Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.
4306ZKCZ	494	2021-04-26 00:00:00	Fusce consequat. Nulla nisl. Nunc nisl.
3966RKOT	201	2005-03-24 00:00:00	Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.
0951ZSVH	378	1999-09-01 00:00:00	Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.
8946PCSN	107	2020-11-01 00:00:00	Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.
9426WQBR	388	2020-05-10 00:00:00	In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.
4948XVNH	497	2019-11-10 00:00:00	Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.
2314UALQ	245	2007-05-22 00:00:00	Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.
5695TOTK	495	1990-11-15 00:00:00	Phasellus in felis. Donec semper sapien a libero. Nam dui.
8276WVXH	274	2016-04-18 00:00:00	Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.
1173POBG	1	2000-11-14 00:00:00	Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.
9320HHVY	162	2009-01-07 00:00:00	Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.
1607IVRY	3	2014-09-21 00:00:00	Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.
8763ZGKO	264	2012-01-26 00:00:00	Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.
9934DARE	14	1999-08-11 00:00:00	In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.
9813EBYL	281	2000-04-12 00:00:00	Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.
1686PIWD	43	2003-07-29 00:00:00	Phasellus in felis. Donec semper sapien a libero. Nam dui.
5143PJGP	121	1992-03-16 00:00:00	Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.
4895TLHS	249	1992-10-22 00:00:00	Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.
1145MJAD	204	2002-06-30 00:00:00	Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.
1884CADN	410	1993-10-20 00:00:00	Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.
3216KFLR	452	1993-08-09 00:00:00	Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.
3730MUQC	314	2005-01-20 00:00:00	Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.
2170LUVV	493	1992-11-04 00:00:00	Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.
4509QBPZ	379	2013-09-01 00:00:00	Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.
1073UFSP	261	2001-12-07 00:00:00	In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.
3792DJJI	404	2013-05-30 00:00:00	Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.
6143IIIV	350	2014-10-20 00:00:00	Sed ante. Vivamus tortor. Duis mattis egestas metus.
0274DHOC	255	1996-02-18 00:00:00	Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.
6594KDKF	14	1993-06-04 00:00:00	Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.
8093USIO	351	2001-09-16 00:00:00	Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.
3113WDHD	134	1999-11-20 00:00:00	Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.
0387AWEB	499	1991-04-25 00:00:00	Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.
0469CWHF	392	2017-12-19 00:00:00	Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.
3796NMRI	386	2004-12-04 00:00:00	Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.
5828QGCL	384	2013-07-04 00:00:00	Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.
5172EMFR	288	2015-09-05 00:00:00	Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.
5174PTKY	233	2002-01-29 00:00:00	Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.
4883QZPH	440	2012-03-13 00:00:00	Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.
6147UNBF	162	2013-09-01 00:00:00	In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.
4573ESVM	239	2019-10-11 00:00:00	Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.
9985FPSA	488	2005-08-06 00:00:00	Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.
7645RPDI	450	2020-03-11 00:00:00	Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.
0632FHTZ	312	2003-03-17 00:00:00	Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.
3830IVIB	374	1998-08-25 00:00:00	Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.
2019EGQI	423	1990-09-20 00:00:00	Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.
5279BSLS	228	2019-02-09 00:00:00	Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.
6363SEGZ	479	2013-10-24 00:00:00	Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.
2878ILCZ	284	2019-12-22 00:00:00	Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.
8519PBGH	478	2016-02-04 00:00:00	Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.
8326HVAG	92	2017-06-01 00:00:00	In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.
5624OQGO	399	2008-05-01 00:00:00	Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.
4419YTUB	442	2012-04-29 00:00:00	Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.
8088VIZX	35	1999-08-11 00:00:00	Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.
2232MIMW	67	2003-12-26 00:00:00	Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.
1147JCNM	277	2016-09-22 00:00:00	Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.
3439MCZA	13	2006-03-09 00:00:00	Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.
3993BWHM	146	2003-12-12 00:00:00	Sed ante. Vivamus tortor. Duis mattis egestas metus.
2910SJNZ	25	2009-04-28 00:00:00	Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.
7675HELL	389	2016-05-01 00:00:00	Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.
1873GYIQ	173	2002-08-14 00:00:00	Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.
5766SCAQ	11	2018-09-21 00:00:00	Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.
8673HUGK	361	2016-06-18 00:00:00	Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.
4272YARX	251	2002-04-28 00:00:00	Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.
0965UABW	163	2012-10-24 00:00:00	Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.
2137QMTD	110	2004-12-26 00:00:00	Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.
1006DOUE	126	2004-08-14 00:00:00	Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.
9430OBVL	487	1995-09-04 00:00:00	Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.
8374AYVM	426	2020-01-23 00:00:00	Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.
4790UUQJ	123	2012-11-23 00:00:00	Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.
1321ALRM	274	2017-06-18 00:00:00	In congue. Etiam justo. Etiam pretium iaculis justo.
3869FOKZ	157	2018-12-20 00:00:00	Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.
3407PQTR	479	1992-03-10 00:00:00	Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.
6310ZWHA	77	2011-08-19 00:00:00	Fusce consequat. Nulla nisl. Nunc nisl.
2854BAQW	308	2003-08-11 00:00:00	Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.
8919SYHE	47	1994-02-16 00:00:00	Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.
3704LSXV	334	2011-12-26 00:00:00	Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.
4630JUQP	56	2002-06-05 00:00:00	Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.
0508CEJN	23	2014-07-12 00:00:00	Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.
8978RIEM	370	2001-12-20 00:00:00	Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.
5026ACFP	449	1991-11-30 00:00:00	In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.
1666NPXT	203	1991-09-10 00:00:00	Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.
1854CIBG	277	2019-03-14 00:00:00	In congue. Etiam justo. Etiam pretium iaculis justo.
7523IGYY	495	2018-05-10 00:00:00	Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.
7866KLDM	223	1992-04-05 00:00:00	In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.
5664QUHI	140	1992-09-09 00:00:00	Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.
2813ACPV	95	1997-02-04 00:00:00	Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.
2006KBOK	94	2009-07-30 00:00:00	Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.
3609HHEL	366	2020-12-27 00:00:00	Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.
1528LYXM	214	2017-06-20 00:00:00	Fusce consequat. Nulla nisl. Nunc nisl.
4323TTIR	256	2008-04-20 00:00:00	Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.
9608OQFO	4	2002-05-08 00:00:00	Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.
3721CEOF	267	2009-05-27 00:00:00	Phasellus in felis. Donec semper sapien a libero. Nam dui.
4979YSQD	407	2014-11-18 00:00:00	Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.
5256CTOB	389	2009-11-16 00:00:00	In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.
4044GPJI	275	2004-04-11 00:00:00	Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.
3784GZUY	91	2008-07-11 00:00:00	Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.
6074CMCF	60	1995-10-03 00:00:00	In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.
6634HCOS	449	2004-02-15 00:00:00	Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.
3431BDCD	190	2003-06-18 00:00:00	Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.
7649BZRC	10	2004-08-21 00:00:00	Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.
6037AASE	105	2000-07-28 00:00:00	Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.
5339LXZK	297	2000-12-26 00:00:00	Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.
9302THDL	175	2011-02-21 00:00:00	Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.
5664TDBI	297	2012-02-12 00:00:00	Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.
4589JKLT	39	2006-05-12 00:00:00	Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.
5780EFDT	226	1993-06-19 00:00:00	Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.
3470URHZ	498	1993-10-02 00:00:00	Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.
7187QAFG	192	1998-08-23 00:00:00	Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.
9562DSMR	244	1996-04-12 00:00:00	Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.
2443LYLY	463	2004-04-12 00:00:00	Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.
1911WXQR	292	1993-01-06 00:00:00	Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.
5672BKOP	114	2010-02-22 00:00:00	Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.
7643PFVI	466	1997-08-21 00:00:00	Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.
8994IGAO	134	2020-03-30 00:00:00	Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.
5594IKKF	37	2011-02-13 00:00:00	Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.
3574YARX	224	2018-04-04 00:00:00	In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.
2209QEZL	349	2009-11-01 00:00:00	Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.
7020YRLE	466	2004-07-24 00:00:00	Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.
2899AXIX	156	2012-06-06 00:00:00	Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.
6932LGPT	170	1997-01-15 00:00:00	Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.
3600DAJZ	102	2019-06-16 00:00:00	Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.
5409YUMJ	121	1994-08-29 00:00:00	Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.
8838OWVI	75	2003-08-13 00:00:00	In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.
8925MOIJ	481	1998-07-19 00:00:00	Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.
7961FXIY	136	2004-11-02 00:00:00	Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.
5031BECQ	97	2001-05-21 00:00:00	Phasellus in felis. Donec semper sapien a libero. Nam dui.
3936EVUZ	169	1993-10-30 00:00:00	Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.
3077XYHR	283	2004-06-10 00:00:00	Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.
6159XJLQ	212	2018-12-16 00:00:00	In congue. Etiam justo. Etiam pretium iaculis justo.
8905JRBU	312	2019-01-26 00:00:00	Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.
6690YMFI	421	1997-12-08 00:00:00	Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.
9502WVED	270	2000-07-06 00:00:00	Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.
2108JFOZ	427	2013-11-10 00:00:00	Fusce consequat. Nulla nisl. Nunc nisl.
3339GFEH	228	2001-11-21 00:00:00	Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.
0322KWFN	428	2012-10-08 00:00:00	Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.
2678HPOX	235	1997-09-02 00:00:00	Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.
7371SHGX	265	2012-07-27 00:00:00	Phasellus in felis. Donec semper sapien a libero. Nam dui.
3788SPZE	2	2003-04-08 00:00:00	Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.
4075OPKI	126	2006-10-16 00:00:00	Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.
0400AUZG	288	2016-07-27 00:00:00	In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.
5474TQGL	351	1998-04-29 00:00:00	Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.
0913TIDW	133	1999-10-08 00:00:00	Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.
1130TTBP	207	2018-01-02 00:00:00	Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.
2444QFVI	280	1993-05-02 00:00:00	Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.
5460EZWN	438	2011-07-13 00:00:00	Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.
8982WZXV	310	2016-05-31 00:00:00	Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.
8906KVKS	87	1991-09-01 00:00:00	Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.
2780QIOB	410	2018-12-29 00:00:00	Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.
9276TMIT	362	1995-07-29 00:00:00	Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.
2148YIHA	426	2017-09-03 00:00:00	Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.
8758GEAT	217	2018-03-26 00:00:00	Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.
2330WTWV	436	1998-09-12 00:00:00	Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.
7639JEGR	193	1996-02-23 00:00:00	Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.
4067NRAY	484	1997-01-06 00:00:00	Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.
4479NZCD	364	1994-06-28 00:00:00	In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.
7726PTQF	44	2017-03-06 00:00:00	Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.
7792EUGU	84	2009-04-27 00:00:00	Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.
9857VSZO	341	2010-08-04 00:00:00	Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.
7704ZDFZ	223	2020-05-22 00:00:00	Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.
2274TEJX	46	1998-03-12 00:00:00	In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.
\.


--
-- Name: address_info address_info_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.address_info
    ADD CONSTRAINT address_info_pkey PRIMARY KEY (address_id);


--
-- Name: contracts contracts_license_plate_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contracts
    ADD CONSTRAINT contracts_license_plate_key UNIQUE (license_plate);


--
-- Name: contracts contracts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contracts
    ADD CONSTRAINT contracts_pkey PRIMARY KEY (contract_code);


--
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (customer_id);


--
-- Name: drivers_info drivers_info_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.drivers_info
    ADD CONSTRAINT drivers_info_pkey PRIMARY KEY (license_number);


--
-- Name: drivers drivers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.drivers
    ADD CONSTRAINT drivers_pkey PRIMARY KEY (license_number, license_plate);


--
-- Name: drivers_violations drivers_violations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.drivers_violations
    ADD CONSTRAINT drivers_violations_pkey PRIMARY KEY (violation_id, license_number, license_plate);


--
-- Name: vehicles vehicles_frame_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vehicles
    ADD CONSTRAINT vehicles_frame_number_key UNIQUE (frame_number);


--
-- Name: vehicles_info vehicles_info_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vehicles_info
    ADD CONSTRAINT vehicles_info_pkey PRIMARY KEY (model_id);


--
-- Name: vehicles vehicles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vehicles
    ADD CONSTRAINT vehicles_pkey PRIMARY KEY (license_plate);


--
-- Name: violations_info violations_info_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.violations_info
    ADD CONSTRAINT violations_info_pkey PRIMARY KEY (violation_id);


--
-- Name: contracts check_date; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER check_date AFTER INSERT OR DELETE ON public.contracts FOR EACH ROW EXECUTE FUNCTION public.categ_contracts();


--
-- Name: contracts update_p_contracts; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_p_contracts AFTER INSERT OR DELETE ON public.contracts FOR EACH ROW EXECUTE FUNCTION public.p_contracts();


--
-- Name: contracts contracts_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contracts
    ADD CONSTRAINT contracts_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id) ON DELETE CASCADE;


--
-- Name: contracts contracts_license_plate_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contracts
    ADD CONSTRAINT contracts_license_plate_fkey FOREIGN KEY (license_plate) REFERENCES public.vehicles(license_plate) ON DELETE CASCADE;


--
-- Name: customers customers_address_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_address_id_fkey FOREIGN KEY (address_id) REFERENCES public.address_info(address_id) ON DELETE CASCADE;


--
-- Name: drivers_info drivers_info_address_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.drivers_info
    ADD CONSTRAINT drivers_info_address_id_fkey FOREIGN KEY (address_id) REFERENCES public.address_info(address_id) ON DELETE CASCADE;


--
-- Name: drivers drivers_license_number_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.drivers
    ADD CONSTRAINT drivers_license_number_fkey FOREIGN KEY (license_number) REFERENCES public.drivers_info(license_number) ON DELETE CASCADE;


--
-- Name: drivers drivers_license_plate_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.drivers
    ADD CONSTRAINT drivers_license_plate_fkey FOREIGN KEY (license_plate) REFERENCES public.vehicles(license_plate) ON DELETE CASCADE;


--
-- Name: drivers drivers_license_plate_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.drivers
    ADD CONSTRAINT drivers_license_plate_fkey1 FOREIGN KEY (license_plate) REFERENCES public.contracts(license_plate) ON DELETE CASCADE;


--
-- Name: drivers_violations drivers_violations_license_plate_license_number_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.drivers_violations
    ADD CONSTRAINT drivers_violations_license_plate_license_number_fkey FOREIGN KEY (license_plate, license_number) REFERENCES public.drivers(license_plate, license_number) ON DELETE CASCADE;


--
-- Name: drivers_violations drivers_violations_violation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.drivers_violations
    ADD CONSTRAINT drivers_violations_violation_id_fkey FOREIGN KEY (violation_id) REFERENCES public.violations_info(violation_id) ON DELETE CASCADE;


--
-- Name: vehicles vehicles_model_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vehicles
    ADD CONSTRAINT vehicles_model_id_fkey FOREIGN KEY (model_id) REFERENCES public.vehicles_info(model_id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

