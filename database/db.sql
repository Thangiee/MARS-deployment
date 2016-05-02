--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.2
-- Dumped by pg_dump version 9.5.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: postgres; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON DATABASE postgres IS 'default administrative connection database';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: account; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE account (
    net_id character varying(128) NOT NULL,
    username character varying(128) NOT NULL,
    passwd character varying(128) NOT NULL,
    role character varying(128) NOT NULL,
    create_time timestamp without time zone NOT NULL,
    approve boolean DEFAULT false NOT NULL
);


--
-- Name: assistant; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE assistant (
    net_id character varying(128) NOT NULL,
    rate double precision NOT NULL,
    email character varying(128) NOT NULL,
    job character varying(128) NOT NULL,
    department character varying(128) NOT NULL,
    last_name character varying(128) NOT NULL,
    first_name character varying(128) NOT NULL,
    employee_id character varying(128) NOT NULL,
    title character varying(128) NOT NULL,
    title_code character varying(128) NOT NULL,
    threshold double precision NOT NULL
);


--
-- Name: clock_in_out_record; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE clock_in_out_record (
    id integer NOT NULL,
    net_id character varying(128) NOT NULL,
    in_time timestamp without time zone NOT NULL,
    out_time timestamp without time zone,
    in_computer_id character varying(128),
    out_computer_id character varying(128)
);


--
-- Name: clock_in_out_record_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE clock_in_out_record_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clock_in_out_record_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE clock_in_out_record_id_seq OWNED BY clock_in_out_record.id;


--
-- Name: face_image; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE face_image (
    id character varying(128) NOT NULL,
    net_id character varying(128) NOT NULL,
    face_id character varying(128) NOT NULL
);


--
-- Name: instructor; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE instructor (
    net_id character varying(128) NOT NULL,
    email character varying(128) NOT NULL,
    last_name character varying(128) NOT NULL,
    first_name character varying(128) NOT NULL
);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY clock_in_out_record ALTER COLUMN id SET DEFAULT nextval('clock_in_out_record_id_seq'::regclass);


--
-- Data for Name: account; Type: TABLE DATA; Schema: public; Owner: -
--

COPY account (net_id, username, passwd, role, create_time, approve) FROM stdin;
abc123	admin	$2a$10$C8yw3NspH6xI/xw5sO6mZuA8krUrAqMNdFHXDr2y9UrsaTatVGE3K	admin	2015-12-31 11:31:10.262897	t
\.


--
-- Data for Name: assistant; Type: TABLE DATA; Schema: public; Owner: -
--

COPY assistant (net_id, rate, email, job, department, last_name, first_name, employee_id, title, title_code, threshold) FROM stdin;
\.


--
-- Data for Name: clock_in_out_record; Type: TABLE DATA; Schema: public; Owner: -
--

COPY clock_in_out_record (id, net_id, in_time, out_time, in_computer_id, out_computer_id) FROM stdin;
\.


--
-- Name: clock_in_out_record_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('clock_in_out_record_id_seq', 1, true);


--
-- Data for Name: face_image; Type: TABLE DATA; Schema: public; Owner: -
--

COPY face_image (id, net_id, face_id) FROM stdin;
\.


--
-- Data for Name: instructor; Type: TABLE DATA; Schema: public; Owner: -
--

COPY instructor (net_id, email, last_name, first_name) FROM stdin;
abc123	utamars2015@gmail.com	Admin	Admin
\.


--
-- Name: account_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY account
    ADD CONSTRAINT account_pkey PRIMARY KEY (net_id);


--
-- Name: assistant_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY assistant
    ADD CONSTRAINT assistant_pkey PRIMARY KEY (net_id);


--
-- Name: clock_in_out_record_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY clock_in_out_record
    ADD CONSTRAINT clock_in_out_record_pkey PRIMARY KEY (id);


--
-- Name: face_image_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY face_image
    ADD CONSTRAINT face_image_pkey PRIMARY KEY (id);


--
-- Name: instructor_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY instructor
    ADD CONSTRAINT instructor_pkey PRIMARY KEY (net_id);


--
-- Name: account_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX account_idx ON account USING btree (username);


--
-- Name: assistant_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX assistant_idx ON assistant USING btree (email);


--
-- Name: instructor_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX instructor_idx ON instructor USING btree (email);


--
-- Name: assistant_net_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY assistant
    ADD CONSTRAINT assistant_net_id_fkey FOREIGN KEY (net_id) REFERENCES account(net_id) ON DELETE CASCADE;


--
-- Name: clock_in_out_record_net_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY clock_in_out_record
    ADD CONSTRAINT clock_in_out_record_net_id_fkey FOREIGN KEY (net_id) REFERENCES assistant(net_id);


--
-- Name: face_image_net_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY face_image
    ADD CONSTRAINT face_image_net_id_fkey FOREIGN KEY (net_id) REFERENCES assistant(net_id);


--
-- Name: instructor_net_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY instructor
    ADD CONSTRAINT instructor_net_id_fkey FOREIGN KEY (net_id) REFERENCES account(net_id) ON DELETE CASCADE;


--
-- Name: public; Type: ACL; Schema: -; Owner: -
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

