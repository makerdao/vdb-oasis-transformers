--
-- PostgreSQL database dump
--

-- Dumped from database version 11.6
-- Dumped by pg_dump version 11.6

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
-- Name: oasis; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA oasis;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: goose_db_version; Type: TABLE; Schema: oasis; Owner: -
--

CREATE TABLE oasis.goose_db_version (
    id integer NOT NULL,
    version_id bigint NOT NULL,
    is_applied boolean NOT NULL,
    tstamp timestamp without time zone DEFAULT now()
);


--
-- Name: goose_db_version_id_seq; Type: SEQUENCE; Schema: oasis; Owner: -
--

CREATE SEQUENCE oasis.goose_db_version_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: goose_db_version_id_seq; Type: SEQUENCE OWNED BY; Schema: oasis; Owner: -
--

ALTER SEQUENCE oasis.goose_db_version_id_seq OWNED BY oasis.goose_db_version.id;


--
-- Name: log_bump; Type: TABLE; Schema: oasis; Owner: -
--

CREATE TABLE oasis.log_bump (
    id integer NOT NULL,
    log_id bigint NOT NULL,
    address_id bigint NOT NULL,
    oasis bigint NOT NULL,
    pay_gem bigint NOT NULL,
    buy_gem bigint NOT NULL,
    pay_amt numeric,
    buy_amt numeric,
    offer_id numeric,
    pair character varying(66),
    header_id integer NOT NULL,
    "timestamp" integer
);


--
-- Name: log_bump_id_seq; Type: SEQUENCE; Schema: oasis; Owner: -
--

CREATE SEQUENCE oasis.log_bump_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: log_bump_id_seq; Type: SEQUENCE OWNED BY; Schema: oasis; Owner: -
--

ALTER SEQUENCE oasis.log_bump_id_seq OWNED BY oasis.log_bump.id;


--
-- Name: log_buy_enabled; Type: TABLE; Schema: oasis; Owner: -
--

CREATE TABLE oasis.log_buy_enabled (
    id integer NOT NULL,
    log_id bigint NOT NULL,
    address_id bigint NOT NULL,
    header_id integer NOT NULL,
    is_enabled boolean
);


--
-- Name: log_buy_enabled_id_seq; Type: SEQUENCE; Schema: oasis; Owner: -
--

CREATE SEQUENCE oasis.log_buy_enabled_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: log_buy_enabled_id_seq; Type: SEQUENCE OWNED BY; Schema: oasis; Owner: -
--

ALTER SEQUENCE oasis.log_buy_enabled_id_seq OWNED BY oasis.log_buy_enabled.id;


--
-- Name: log_delete; Type: TABLE; Schema: oasis; Owner: -
--

CREATE TABLE oasis.log_delete (
    id integer NOT NULL,
    log_id bigint NOT NULL,
    address_id bigint NOT NULL,
    keeper bigint NOT NULL,
    offer_id numeric,
    header_id integer NOT NULL
);


--
-- Name: log_delete_id_seq; Type: SEQUENCE; Schema: oasis; Owner: -
--

CREATE SEQUENCE oasis.log_delete_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: log_delete_id_seq; Type: SEQUENCE OWNED BY; Schema: oasis; Owner: -
--

ALTER SEQUENCE oasis.log_delete_id_seq OWNED BY oasis.log_delete.id;


--
-- Name: log_insert; Type: TABLE; Schema: oasis; Owner: -
--

CREATE TABLE oasis.log_insert (
    id integer NOT NULL,
    log_id bigint NOT NULL,
    address_id bigint NOT NULL,
    keeper bigint NOT NULL,
    offer_id numeric,
    header_id integer NOT NULL
);


--
-- Name: log_insert_id_seq; Type: SEQUENCE; Schema: oasis; Owner: -
--

CREATE SEQUENCE oasis.log_insert_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: log_insert_id_seq; Type: SEQUENCE OWNED BY; Schema: oasis; Owner: -
--

ALTER SEQUENCE oasis.log_insert_id_seq OWNED BY oasis.log_insert.id;


--
-- Name: log_item_update; Type: TABLE; Schema: oasis; Owner: -
--

CREATE TABLE oasis.log_item_update (
    id integer NOT NULL,
    log_id bigint NOT NULL,
    address_id bigint NOT NULL,
    header_id integer NOT NULL,
    offer_id numeric
);


--
-- Name: log_item_update_id_seq; Type: SEQUENCE; Schema: oasis; Owner: -
--

CREATE SEQUENCE oasis.log_item_update_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: log_item_update_id_seq; Type: SEQUENCE OWNED BY; Schema: oasis; Owner: -
--

ALTER SEQUENCE oasis.log_item_update_id_seq OWNED BY oasis.log_item_update.id;


--
-- Name: log_kill; Type: TABLE; Schema: oasis; Owner: -
--

CREATE TABLE oasis.log_kill (
    id integer NOT NULL,
    log_id bigint NOT NULL,
    address_id bigint NOT NULL,
    oasis bigint NOT NULL,
    pay_gem bigint NOT NULL,
    buy_gem bigint NOT NULL,
    pay_amt numeric,
    buy_amt numeric,
    offer_id numeric,
    pair character varying(66),
    header_id integer NOT NULL,
    "timestamp" integer
);


--
-- Name: log_kill_id_seq; Type: SEQUENCE; Schema: oasis; Owner: -
--

CREATE SEQUENCE oasis.log_kill_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: log_kill_id_seq; Type: SEQUENCE OWNED BY; Schema: oasis; Owner: -
--

ALTER SEQUENCE oasis.log_kill_id_seq OWNED BY oasis.log_kill.id;


--
-- Name: log_make; Type: TABLE; Schema: oasis; Owner: -
--

CREATE TABLE oasis.log_make (
    id integer NOT NULL,
    log_id bigint NOT NULL,
    address_id bigint NOT NULL,
    oasis bigint NOT NULL,
    pay_gem bigint NOT NULL,
    buy_gem bigint NOT NULL,
    pay_amt numeric,
    buy_amt numeric,
    offer_id numeric,
    pair character varying(66),
    header_id integer NOT NULL,
    "timestamp" integer
);


--
-- Name: log_make_id_seq; Type: SEQUENCE; Schema: oasis; Owner: -
--

CREATE SEQUENCE oasis.log_make_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: log_make_id_seq; Type: SEQUENCE OWNED BY; Schema: oasis; Owner: -
--

ALTER SEQUENCE oasis.log_make_id_seq OWNED BY oasis.log_make.id;


--
-- Name: log_matching_enabled; Type: TABLE; Schema: oasis; Owner: -
--

CREATE TABLE oasis.log_matching_enabled (
    id integer NOT NULL,
    log_id bigint NOT NULL,
    address_id bigint NOT NULL,
    header_id integer NOT NULL,
    is_enabled boolean
);


--
-- Name: log_matching_enabled_id_seq; Type: SEQUENCE; Schema: oasis; Owner: -
--

CREATE SEQUENCE oasis.log_matching_enabled_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: log_matching_enabled_id_seq; Type: SEQUENCE OWNED BY; Schema: oasis; Owner: -
--

ALTER SEQUENCE oasis.log_matching_enabled_id_seq OWNED BY oasis.log_matching_enabled.id;


--
-- Name: log_min_sell; Type: TABLE; Schema: oasis; Owner: -
--

CREATE TABLE oasis.log_min_sell (
    id integer NOT NULL,
    log_id bigint NOT NULL,
    address_id bigint NOT NULL,
    pay_gem bigint NOT NULL,
    min_amount numeric,
    header_id integer NOT NULL
);


--
-- Name: log_min_sell_id_seq; Type: SEQUENCE; Schema: oasis; Owner: -
--

CREATE SEQUENCE oasis.log_min_sell_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: log_min_sell_id_seq; Type: SEQUENCE OWNED BY; Schema: oasis; Owner: -
--

ALTER SEQUENCE oasis.log_min_sell_id_seq OWNED BY oasis.log_min_sell.id;


--
-- Name: log_sorted_offer; Type: TABLE; Schema: oasis; Owner: -
--

CREATE TABLE oasis.log_sorted_offer (
    id integer NOT NULL,
    log_id bigint NOT NULL,
    address_id bigint NOT NULL,
    offer_id numeric,
    header_id integer NOT NULL
);


--
-- Name: log_sorted_offer_id_seq; Type: SEQUENCE; Schema: oasis; Owner: -
--

CREATE SEQUENCE oasis.log_sorted_offer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: log_sorted_offer_id_seq; Type: SEQUENCE OWNED BY; Schema: oasis; Owner: -
--

ALTER SEQUENCE oasis.log_sorted_offer_id_seq OWNED BY oasis.log_sorted_offer.id;


--
-- Name: log_take; Type: TABLE; Schema: oasis; Owner: -
--

CREATE TABLE oasis.log_take (
    id integer NOT NULL,
    log_id bigint NOT NULL,
    address_id bigint NOT NULL,
    oasis bigint NOT NULL,
    pay_gem bigint NOT NULL,
    buy_gem bigint NOT NULL,
    taker bigint NOT NULL,
    take_amt numeric,
    give_amt numeric,
    offer_id numeric,
    pair character varying(66),
    header_id integer NOT NULL,
    "timestamp" integer
);


--
-- Name: log_take_id_seq; Type: SEQUENCE; Schema: oasis; Owner: -
--

CREATE SEQUENCE oasis.log_take_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: log_take_id_seq; Type: SEQUENCE OWNED BY; Schema: oasis; Owner: -
--

ALTER SEQUENCE oasis.log_take_id_seq OWNED BY oasis.log_take.id;


--
-- Name: log_trade; Type: TABLE; Schema: oasis; Owner: -
--

CREATE TABLE oasis.log_trade (
    id integer NOT NULL,
    log_id bigint NOT NULL,
    address_id bigint NOT NULL,
    pay_gem bigint NOT NULL,
    buy_gem bigint NOT NULL,
    pay_amt numeric,
    buy_amt numeric,
    header_id integer NOT NULL
);


--
-- Name: log_trade_id_seq; Type: SEQUENCE; Schema: oasis; Owner: -
--

CREATE SEQUENCE oasis.log_trade_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: log_trade_id_seq; Type: SEQUENCE OWNED BY; Schema: oasis; Owner: -
--

ALTER SEQUENCE oasis.log_trade_id_seq OWNED BY oasis.log_trade.id;


--
-- Name: log_unsorted_offer; Type: TABLE; Schema: oasis; Owner: -
--

CREATE TABLE oasis.log_unsorted_offer (
    id integer NOT NULL,
    log_id bigint NOT NULL,
    address_id bigint NOT NULL,
    offer_id numeric,
    header_id integer NOT NULL
);


--
-- Name: log_unsorted_offer_id_seq; Type: SEQUENCE; Schema: oasis; Owner: -
--

CREATE SEQUENCE oasis.log_unsorted_offer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: log_unsorted_offer_id_seq; Type: SEQUENCE OWNED BY; Schema: oasis; Owner: -
--

ALTER SEQUENCE oasis.log_unsorted_offer_id_seq OWNED BY oasis.log_unsorted_offer.id;


--
-- Name: set_min_sell; Type: TABLE; Schema: oasis; Owner: -
--

CREATE TABLE oasis.set_min_sell (
    id integer NOT NULL,
    log_id bigint NOT NULL,
    address_id bigint NOT NULL,
    pay_gem bigint NOT NULL,
    msg_sender bigint NOT NULL,
    dust numeric,
    header_id integer NOT NULL
);


--
-- Name: set_min_sell_id_seq; Type: SEQUENCE; Schema: oasis; Owner: -
--

CREATE SEQUENCE oasis.set_min_sell_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: set_min_sell_id_seq; Type: SEQUENCE OWNED BY; Schema: oasis; Owner: -
--

ALTER SEQUENCE oasis.set_min_sell_id_seq OWNED BY oasis.set_min_sell.id;


--
-- Name: goose_db_version id; Type: DEFAULT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.goose_db_version ALTER COLUMN id SET DEFAULT nextval('oasis.goose_db_version_id_seq'::regclass);


--
-- Name: log_bump id; Type: DEFAULT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_bump ALTER COLUMN id SET DEFAULT nextval('oasis.log_bump_id_seq'::regclass);


--
-- Name: log_buy_enabled id; Type: DEFAULT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_buy_enabled ALTER COLUMN id SET DEFAULT nextval('oasis.log_buy_enabled_id_seq'::regclass);


--
-- Name: log_delete id; Type: DEFAULT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_delete ALTER COLUMN id SET DEFAULT nextval('oasis.log_delete_id_seq'::regclass);


--
-- Name: log_insert id; Type: DEFAULT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_insert ALTER COLUMN id SET DEFAULT nextval('oasis.log_insert_id_seq'::regclass);


--
-- Name: log_item_update id; Type: DEFAULT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_item_update ALTER COLUMN id SET DEFAULT nextval('oasis.log_item_update_id_seq'::regclass);


--
-- Name: log_kill id; Type: DEFAULT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_kill ALTER COLUMN id SET DEFAULT nextval('oasis.log_kill_id_seq'::regclass);


--
-- Name: log_make id; Type: DEFAULT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_make ALTER COLUMN id SET DEFAULT nextval('oasis.log_make_id_seq'::regclass);


--
-- Name: log_matching_enabled id; Type: DEFAULT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_matching_enabled ALTER COLUMN id SET DEFAULT nextval('oasis.log_matching_enabled_id_seq'::regclass);


--
-- Name: log_min_sell id; Type: DEFAULT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_min_sell ALTER COLUMN id SET DEFAULT nextval('oasis.log_min_sell_id_seq'::regclass);


--
-- Name: log_sorted_offer id; Type: DEFAULT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_sorted_offer ALTER COLUMN id SET DEFAULT nextval('oasis.log_sorted_offer_id_seq'::regclass);


--
-- Name: log_take id; Type: DEFAULT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_take ALTER COLUMN id SET DEFAULT nextval('oasis.log_take_id_seq'::regclass);


--
-- Name: log_trade id; Type: DEFAULT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_trade ALTER COLUMN id SET DEFAULT nextval('oasis.log_trade_id_seq'::regclass);


--
-- Name: log_unsorted_offer id; Type: DEFAULT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_unsorted_offer ALTER COLUMN id SET DEFAULT nextval('oasis.log_unsorted_offer_id_seq'::regclass);


--
-- Name: set_min_sell id; Type: DEFAULT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.set_min_sell ALTER COLUMN id SET DEFAULT nextval('oasis.set_min_sell_id_seq'::regclass);


--
-- Name: goose_db_version goose_db_version_pkey; Type: CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.goose_db_version
    ADD CONSTRAINT goose_db_version_pkey PRIMARY KEY (id);


--
-- Name: log_bump log_bump_header_id_log_id_key; Type: CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_bump
    ADD CONSTRAINT log_bump_header_id_log_id_key UNIQUE (header_id, log_id);


--
-- Name: log_bump log_bump_pkey; Type: CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_bump
    ADD CONSTRAINT log_bump_pkey PRIMARY KEY (id);


--
-- Name: log_buy_enabled log_buy_enabled_header_id_log_id_key; Type: CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_buy_enabled
    ADD CONSTRAINT log_buy_enabled_header_id_log_id_key UNIQUE (header_id, log_id);


--
-- Name: log_buy_enabled log_buy_enabled_pkey; Type: CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_buy_enabled
    ADD CONSTRAINT log_buy_enabled_pkey PRIMARY KEY (id);


--
-- Name: log_delete log_delete_header_id_log_id_key; Type: CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_delete
    ADD CONSTRAINT log_delete_header_id_log_id_key UNIQUE (header_id, log_id);


--
-- Name: log_delete log_delete_pkey; Type: CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_delete
    ADD CONSTRAINT log_delete_pkey PRIMARY KEY (id);


--
-- Name: log_insert log_insert_header_id_log_id_key; Type: CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_insert
    ADD CONSTRAINT log_insert_header_id_log_id_key UNIQUE (header_id, log_id);


--
-- Name: log_insert log_insert_pkey; Type: CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_insert
    ADD CONSTRAINT log_insert_pkey PRIMARY KEY (id);


--
-- Name: log_item_update log_item_update_header_id_log_id_key; Type: CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_item_update
    ADD CONSTRAINT log_item_update_header_id_log_id_key UNIQUE (header_id, log_id);


--
-- Name: log_item_update log_item_update_pkey; Type: CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_item_update
    ADD CONSTRAINT log_item_update_pkey PRIMARY KEY (id);


--
-- Name: log_kill log_kill_header_id_log_id_key; Type: CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_kill
    ADD CONSTRAINT log_kill_header_id_log_id_key UNIQUE (header_id, log_id);


--
-- Name: log_kill log_kill_pkey; Type: CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_kill
    ADD CONSTRAINT log_kill_pkey PRIMARY KEY (id);


--
-- Name: log_make log_make_header_id_log_id_key; Type: CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_make
    ADD CONSTRAINT log_make_header_id_log_id_key UNIQUE (header_id, log_id);


--
-- Name: log_make log_make_pkey; Type: CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_make
    ADD CONSTRAINT log_make_pkey PRIMARY KEY (id);


--
-- Name: log_matching_enabled log_matching_enabled_header_id_log_id_key; Type: CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_matching_enabled
    ADD CONSTRAINT log_matching_enabled_header_id_log_id_key UNIQUE (header_id, log_id);


--
-- Name: log_matching_enabled log_matching_enabled_pkey; Type: CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_matching_enabled
    ADD CONSTRAINT log_matching_enabled_pkey PRIMARY KEY (id);


--
-- Name: log_min_sell log_min_sell_header_id_log_id_key; Type: CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_min_sell
    ADD CONSTRAINT log_min_sell_header_id_log_id_key UNIQUE (header_id, log_id);


--
-- Name: log_min_sell log_min_sell_pkey; Type: CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_min_sell
    ADD CONSTRAINT log_min_sell_pkey PRIMARY KEY (id);


--
-- Name: log_sorted_offer log_sorted_offer_header_id_log_id_key; Type: CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_sorted_offer
    ADD CONSTRAINT log_sorted_offer_header_id_log_id_key UNIQUE (header_id, log_id);


--
-- Name: log_sorted_offer log_sorted_offer_pkey; Type: CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_sorted_offer
    ADD CONSTRAINT log_sorted_offer_pkey PRIMARY KEY (id);


--
-- Name: log_take log_take_header_id_log_id_key; Type: CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_take
    ADD CONSTRAINT log_take_header_id_log_id_key UNIQUE (header_id, log_id);


--
-- Name: log_take log_take_pkey; Type: CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_take
    ADD CONSTRAINT log_take_pkey PRIMARY KEY (id);


--
-- Name: log_trade log_trade_header_id_log_id_key; Type: CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_trade
    ADD CONSTRAINT log_trade_header_id_log_id_key UNIQUE (header_id, log_id);


--
-- Name: log_trade log_trade_pkey; Type: CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_trade
    ADD CONSTRAINT log_trade_pkey PRIMARY KEY (id);


--
-- Name: log_unsorted_offer log_unsorted_offer_header_id_log_id_key; Type: CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_unsorted_offer
    ADD CONSTRAINT log_unsorted_offer_header_id_log_id_key UNIQUE (header_id, log_id);


--
-- Name: log_unsorted_offer log_unsorted_offer_pkey; Type: CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_unsorted_offer
    ADD CONSTRAINT log_unsorted_offer_pkey PRIMARY KEY (id);


--
-- Name: set_min_sell set_min_sell_header_id_log_id_key; Type: CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.set_min_sell
    ADD CONSTRAINT set_min_sell_header_id_log_id_key UNIQUE (header_id, log_id);


--
-- Name: set_min_sell set_min_sell_pkey; Type: CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.set_min_sell
    ADD CONSTRAINT set_min_sell_pkey PRIMARY KEY (id);


--
-- Name: log_bump_address_index; Type: INDEX; Schema: oasis; Owner: -
--

CREATE INDEX log_bump_address_index ON oasis.log_bump USING btree (address_id);


--
-- Name: log_bump_buy_gem_index; Type: INDEX; Schema: oasis; Owner: -
--

CREATE INDEX log_bump_buy_gem_index ON oasis.log_bump USING btree (buy_gem);


--
-- Name: log_bump_header_index; Type: INDEX; Schema: oasis; Owner: -
--

CREATE INDEX log_bump_header_index ON oasis.log_bump USING btree (header_id);


--
-- Name: log_bump_log_index; Type: INDEX; Schema: oasis; Owner: -
--

CREATE INDEX log_bump_log_index ON oasis.log_bump USING btree (log_id);


--
-- Name: log_bump_oasis_index; Type: INDEX; Schema: oasis; Owner: -
--

CREATE INDEX log_bump_oasis_index ON oasis.log_bump USING btree (oasis);


--
-- Name: log_bump_pay_gem_index; Type: INDEX; Schema: oasis; Owner: -
--

CREATE INDEX log_bump_pay_gem_index ON oasis.log_bump USING btree (pay_gem);


--
-- Name: log_buy_enabled_address_index; Type: INDEX; Schema: oasis; Owner: -
--

CREATE INDEX log_buy_enabled_address_index ON oasis.log_buy_enabled USING btree (address_id);


--
-- Name: log_buy_enabled_header_index; Type: INDEX; Schema: oasis; Owner: -
--

CREATE INDEX log_buy_enabled_header_index ON oasis.log_buy_enabled USING btree (header_id);


--
-- Name: log_buy_enabled_log_index; Type: INDEX; Schema: oasis; Owner: -
--

CREATE INDEX log_buy_enabled_log_index ON oasis.log_buy_enabled USING btree (log_id);


--
-- Name: log_delete_address_index; Type: INDEX; Schema: oasis; Owner: -
--

CREATE INDEX log_delete_address_index ON oasis.log_delete USING btree (address_id);


--
-- Name: log_delete_header_index; Type: INDEX; Schema: oasis; Owner: -
--

CREATE INDEX log_delete_header_index ON oasis.log_delete USING btree (header_id);


--
-- Name: log_delete_keeper_index; Type: INDEX; Schema: oasis; Owner: -
--

CREATE INDEX log_delete_keeper_index ON oasis.log_delete USING btree (keeper);


--
-- Name: log_delete_log_index; Type: INDEX; Schema: oasis; Owner: -
--

CREATE INDEX log_delete_log_index ON oasis.log_delete USING btree (log_id);


--
-- Name: log_insert_address_index; Type: INDEX; Schema: oasis; Owner: -
--

CREATE INDEX log_insert_address_index ON oasis.log_insert USING btree (address_id);


--
-- Name: log_insert_header_index; Type: INDEX; Schema: oasis; Owner: -
--

CREATE INDEX log_insert_header_index ON oasis.log_insert USING btree (header_id);


--
-- Name: log_insert_keeper_index; Type: INDEX; Schema: oasis; Owner: -
--

CREATE INDEX log_insert_keeper_index ON oasis.log_insert USING btree (keeper);


--
-- Name: log_insert_log_index; Type: INDEX; Schema: oasis; Owner: -
--

CREATE INDEX log_insert_log_index ON oasis.log_insert USING btree (log_id);


--
-- Name: log_item_update_address_index; Type: INDEX; Schema: oasis; Owner: -
--

CREATE INDEX log_item_update_address_index ON oasis.log_item_update USING btree (address_id);


--
-- Name: log_item_update_header_index; Type: INDEX; Schema: oasis; Owner: -
--

CREATE INDEX log_item_update_header_index ON oasis.log_item_update USING btree (header_id);


--
-- Name: log_item_update_log_index; Type: INDEX; Schema: oasis; Owner: -
--

CREATE INDEX log_item_update_log_index ON oasis.log_item_update USING btree (log_id);


--
-- Name: log_kill_address_index; Type: INDEX; Schema: oasis; Owner: -
--

CREATE INDEX log_kill_address_index ON oasis.log_kill USING btree (address_id);


--
-- Name: log_kill_buy_gem_index; Type: INDEX; Schema: oasis; Owner: -
--

CREATE INDEX log_kill_buy_gem_index ON oasis.log_kill USING btree (buy_gem);


--
-- Name: log_kill_header_index; Type: INDEX; Schema: oasis; Owner: -
--

CREATE INDEX log_kill_header_index ON oasis.log_kill USING btree (header_id);


--
-- Name: log_kill_index; Type: INDEX; Schema: oasis; Owner: -
--

CREATE INDEX log_kill_index ON oasis.log_kill USING btree (log_id);


--
-- Name: log_kill_oasis_index; Type: INDEX; Schema: oasis; Owner: -
--

CREATE INDEX log_kill_oasis_index ON oasis.log_kill USING btree (oasis);


--
-- Name: log_kill_pay_gem_index; Type: INDEX; Schema: oasis; Owner: -
--

CREATE INDEX log_kill_pay_gem_index ON oasis.log_kill USING btree (pay_gem);


--
-- Name: log_make_address_index; Type: INDEX; Schema: oasis; Owner: -
--

CREATE INDEX log_make_address_index ON oasis.log_make USING btree (address_id);


--
-- Name: log_make_buy_gem_index; Type: INDEX; Schema: oasis; Owner: -
--

CREATE INDEX log_make_buy_gem_index ON oasis.log_make USING btree (buy_gem);


--
-- Name: log_make_header_index; Type: INDEX; Schema: oasis; Owner: -
--

CREATE INDEX log_make_header_index ON oasis.log_make USING btree (header_id);


--
-- Name: log_make_log_index; Type: INDEX; Schema: oasis; Owner: -
--

CREATE INDEX log_make_log_index ON oasis.log_make USING btree (log_id);


--
-- Name: log_make_oasis_index; Type: INDEX; Schema: oasis; Owner: -
--

CREATE INDEX log_make_oasis_index ON oasis.log_make USING btree (oasis);


--
-- Name: log_make_pay_gem_index; Type: INDEX; Schema: oasis; Owner: -
--

CREATE INDEX log_make_pay_gem_index ON oasis.log_make USING btree (pay_gem);


--
-- Name: log_matching_enabled_address_index; Type: INDEX; Schema: oasis; Owner: -
--

CREATE INDEX log_matching_enabled_address_index ON oasis.log_matching_enabled USING btree (address_id);


--
-- Name: log_matching_enabled_header_index; Type: INDEX; Schema: oasis; Owner: -
--

CREATE INDEX log_matching_enabled_header_index ON oasis.log_matching_enabled USING btree (header_id);


--
-- Name: log_matching_enabled_log_index; Type: INDEX; Schema: oasis; Owner: -
--

CREATE INDEX log_matching_enabled_log_index ON oasis.log_matching_enabled USING btree (log_id);


--
-- Name: log_min_sell_address_index; Type: INDEX; Schema: oasis; Owner: -
--

CREATE INDEX log_min_sell_address_index ON oasis.log_min_sell USING btree (address_id);


--
-- Name: log_min_sell_header_index; Type: INDEX; Schema: oasis; Owner: -
--

CREATE INDEX log_min_sell_header_index ON oasis.log_min_sell USING btree (header_id);


--
-- Name: log_min_sell_log_index; Type: INDEX; Schema: oasis; Owner: -
--

CREATE INDEX log_min_sell_log_index ON oasis.log_min_sell USING btree (log_id);


--
-- Name: log_min_sell_pay_gem_index; Type: INDEX; Schema: oasis; Owner: -
--

CREATE INDEX log_min_sell_pay_gem_index ON oasis.log_min_sell USING btree (pay_gem);


--
-- Name: log_sorted_offer_address_index; Type: INDEX; Schema: oasis; Owner: -
--

CREATE INDEX log_sorted_offer_address_index ON oasis.log_sorted_offer USING btree (address_id);


--
-- Name: log_sorted_offer_header_index; Type: INDEX; Schema: oasis; Owner: -
--

CREATE INDEX log_sorted_offer_header_index ON oasis.log_sorted_offer USING btree (header_id);


--
-- Name: log_sorted_offer_log_index; Type: INDEX; Schema: oasis; Owner: -
--

CREATE INDEX log_sorted_offer_log_index ON oasis.log_sorted_offer USING btree (log_id);


--
-- Name: log_take_address_index; Type: INDEX; Schema: oasis; Owner: -
--

CREATE INDEX log_take_address_index ON oasis.log_take USING btree (address_id);


--
-- Name: log_take_buy_gem_index; Type: INDEX; Schema: oasis; Owner: -
--

CREATE INDEX log_take_buy_gem_index ON oasis.log_take USING btree (buy_gem);


--
-- Name: log_take_header_index; Type: INDEX; Schema: oasis; Owner: -
--

CREATE INDEX log_take_header_index ON oasis.log_take USING btree (header_id);


--
-- Name: log_take_log_index; Type: INDEX; Schema: oasis; Owner: -
--

CREATE INDEX log_take_log_index ON oasis.log_take USING btree (log_id);


--
-- Name: log_take_oasis_index; Type: INDEX; Schema: oasis; Owner: -
--

CREATE INDEX log_take_oasis_index ON oasis.log_take USING btree (oasis);


--
-- Name: log_take_pay_gem_index; Type: INDEX; Schema: oasis; Owner: -
--

CREATE INDEX log_take_pay_gem_index ON oasis.log_take USING btree (pay_gem);


--
-- Name: log_take_taker_index; Type: INDEX; Schema: oasis; Owner: -
--

CREATE INDEX log_take_taker_index ON oasis.log_take USING btree (taker);


--
-- Name: log_trade_address_index; Type: INDEX; Schema: oasis; Owner: -
--

CREATE INDEX log_trade_address_index ON oasis.log_trade USING btree (address_id);


--
-- Name: log_trade_buy_gem_index; Type: INDEX; Schema: oasis; Owner: -
--

CREATE INDEX log_trade_buy_gem_index ON oasis.log_trade USING btree (buy_gem);


--
-- Name: log_trade_header_index; Type: INDEX; Schema: oasis; Owner: -
--

CREATE INDEX log_trade_header_index ON oasis.log_trade USING btree (header_id);


--
-- Name: log_trade_log_index; Type: INDEX; Schema: oasis; Owner: -
--

CREATE INDEX log_trade_log_index ON oasis.log_trade USING btree (log_id);


--
-- Name: log_trade_pay_gem_index; Type: INDEX; Schema: oasis; Owner: -
--

CREATE INDEX log_trade_pay_gem_index ON oasis.log_trade USING btree (pay_gem);


--
-- Name: log_unsorted_offer_address_index; Type: INDEX; Schema: oasis; Owner: -
--

CREATE INDEX log_unsorted_offer_address_index ON oasis.log_unsorted_offer USING btree (address_id);


--
-- Name: log_unsorted_offer_header_index; Type: INDEX; Schema: oasis; Owner: -
--

CREATE INDEX log_unsorted_offer_header_index ON oasis.log_unsorted_offer USING btree (header_id);


--
-- Name: log_unsorted_offer_log_index; Type: INDEX; Schema: oasis; Owner: -
--

CREATE INDEX log_unsorted_offer_log_index ON oasis.log_unsorted_offer USING btree (log_id);


--
-- Name: set_min_sell_address_index; Type: INDEX; Schema: oasis; Owner: -
--

CREATE INDEX set_min_sell_address_index ON oasis.set_min_sell USING btree (address_id);


--
-- Name: set_min_sell_header_index; Type: INDEX; Schema: oasis; Owner: -
--

CREATE INDEX set_min_sell_header_index ON oasis.set_min_sell USING btree (header_id);


--
-- Name: set_min_sell_log_index; Type: INDEX; Schema: oasis; Owner: -
--

CREATE INDEX set_min_sell_log_index ON oasis.set_min_sell USING btree (log_id);


--
-- Name: set_min_sell_msg_sender; Type: INDEX; Schema: oasis; Owner: -
--

CREATE INDEX set_min_sell_msg_sender ON oasis.set_min_sell USING btree (msg_sender);


--
-- Name: set_min_sell_pay_gem_index; Type: INDEX; Schema: oasis; Owner: -
--

CREATE INDEX set_min_sell_pay_gem_index ON oasis.set_min_sell USING btree (pay_gem);


--
-- Name: log_bump log_bump_address_id_fkey; Type: FK CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_bump
    ADD CONSTRAINT log_bump_address_id_fkey FOREIGN KEY (address_id) REFERENCES public.addresses(id) ON DELETE CASCADE;


--
-- Name: log_bump log_bump_buy_gem_fkey; Type: FK CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_bump
    ADD CONSTRAINT log_bump_buy_gem_fkey FOREIGN KEY (buy_gem) REFERENCES public.addresses(id) ON DELETE CASCADE;


--
-- Name: log_bump log_bump_header_id_fkey; Type: FK CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_bump
    ADD CONSTRAINT log_bump_header_id_fkey FOREIGN KEY (header_id) REFERENCES public.headers(id) ON DELETE CASCADE;


--
-- Name: log_bump log_bump_log_id_fkey; Type: FK CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_bump
    ADD CONSTRAINT log_bump_log_id_fkey FOREIGN KEY (log_id) REFERENCES public.event_logs(id) ON DELETE CASCADE;


--
-- Name: log_bump log_bump_oasis_fkey; Type: FK CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_bump
    ADD CONSTRAINT log_bump_oasis_fkey FOREIGN KEY (oasis) REFERENCES public.addresses(id) ON DELETE CASCADE;


--
-- Name: log_bump log_bump_pay_gem_fkey; Type: FK CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_bump
    ADD CONSTRAINT log_bump_pay_gem_fkey FOREIGN KEY (pay_gem) REFERENCES public.addresses(id) ON DELETE CASCADE;


--
-- Name: log_buy_enabled log_buy_enabled_address_id_fkey; Type: FK CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_buy_enabled
    ADD CONSTRAINT log_buy_enabled_address_id_fkey FOREIGN KEY (address_id) REFERENCES public.addresses(id) ON DELETE CASCADE;


--
-- Name: log_buy_enabled log_buy_enabled_header_id_fkey; Type: FK CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_buy_enabled
    ADD CONSTRAINT log_buy_enabled_header_id_fkey FOREIGN KEY (header_id) REFERENCES public.headers(id) ON DELETE CASCADE;


--
-- Name: log_buy_enabled log_buy_enabled_log_id_fkey; Type: FK CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_buy_enabled
    ADD CONSTRAINT log_buy_enabled_log_id_fkey FOREIGN KEY (log_id) REFERENCES public.event_logs(id) ON DELETE CASCADE;


--
-- Name: log_delete log_delete_address_id_fkey; Type: FK CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_delete
    ADD CONSTRAINT log_delete_address_id_fkey FOREIGN KEY (address_id) REFERENCES public.addresses(id) ON DELETE CASCADE;


--
-- Name: log_delete log_delete_header_id_fkey; Type: FK CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_delete
    ADD CONSTRAINT log_delete_header_id_fkey FOREIGN KEY (header_id) REFERENCES public.headers(id) ON DELETE CASCADE;


--
-- Name: log_delete log_delete_keeper_fkey; Type: FK CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_delete
    ADD CONSTRAINT log_delete_keeper_fkey FOREIGN KEY (keeper) REFERENCES public.addresses(id) ON DELETE CASCADE;


--
-- Name: log_delete log_delete_log_id_fkey; Type: FK CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_delete
    ADD CONSTRAINT log_delete_log_id_fkey FOREIGN KEY (log_id) REFERENCES public.event_logs(id) ON DELETE CASCADE;


--
-- Name: log_insert log_insert_address_id_fkey; Type: FK CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_insert
    ADD CONSTRAINT log_insert_address_id_fkey FOREIGN KEY (address_id) REFERENCES public.addresses(id) ON DELETE CASCADE;


--
-- Name: log_insert log_insert_header_id_fkey; Type: FK CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_insert
    ADD CONSTRAINT log_insert_header_id_fkey FOREIGN KEY (header_id) REFERENCES public.headers(id) ON DELETE CASCADE;


--
-- Name: log_insert log_insert_keeper_fkey; Type: FK CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_insert
    ADD CONSTRAINT log_insert_keeper_fkey FOREIGN KEY (keeper) REFERENCES public.addresses(id) ON DELETE CASCADE;


--
-- Name: log_insert log_insert_log_id_fkey; Type: FK CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_insert
    ADD CONSTRAINT log_insert_log_id_fkey FOREIGN KEY (log_id) REFERENCES public.event_logs(id) ON DELETE CASCADE;


--
-- Name: log_item_update log_item_update_address_id_fkey; Type: FK CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_item_update
    ADD CONSTRAINT log_item_update_address_id_fkey FOREIGN KEY (address_id) REFERENCES public.addresses(id) ON DELETE CASCADE;


--
-- Name: log_item_update log_item_update_header_id_fkey; Type: FK CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_item_update
    ADD CONSTRAINT log_item_update_header_id_fkey FOREIGN KEY (header_id) REFERENCES public.headers(id) ON DELETE CASCADE;


--
-- Name: log_item_update log_item_update_log_id_fkey; Type: FK CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_item_update
    ADD CONSTRAINT log_item_update_log_id_fkey FOREIGN KEY (log_id) REFERENCES public.event_logs(id) ON DELETE CASCADE;


--
-- Name: log_kill log_kill_address_id_fkey; Type: FK CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_kill
    ADD CONSTRAINT log_kill_address_id_fkey FOREIGN KEY (address_id) REFERENCES public.addresses(id) ON DELETE CASCADE;


--
-- Name: log_kill log_kill_buy_gem_fkey; Type: FK CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_kill
    ADD CONSTRAINT log_kill_buy_gem_fkey FOREIGN KEY (buy_gem) REFERENCES public.addresses(id) ON DELETE CASCADE;


--
-- Name: log_kill log_kill_header_id_fkey; Type: FK CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_kill
    ADD CONSTRAINT log_kill_header_id_fkey FOREIGN KEY (header_id) REFERENCES public.headers(id) ON DELETE CASCADE;


--
-- Name: log_kill log_kill_log_id_fkey; Type: FK CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_kill
    ADD CONSTRAINT log_kill_log_id_fkey FOREIGN KEY (log_id) REFERENCES public.event_logs(id) ON DELETE CASCADE;


--
-- Name: log_kill log_kill_oasis_fkey; Type: FK CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_kill
    ADD CONSTRAINT log_kill_oasis_fkey FOREIGN KEY (oasis) REFERENCES public.addresses(id) ON DELETE CASCADE;


--
-- Name: log_kill log_kill_pay_gem_fkey; Type: FK CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_kill
    ADD CONSTRAINT log_kill_pay_gem_fkey FOREIGN KEY (pay_gem) REFERENCES public.addresses(id) ON DELETE CASCADE;


--
-- Name: log_make log_make_address_id_fkey; Type: FK CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_make
    ADD CONSTRAINT log_make_address_id_fkey FOREIGN KEY (address_id) REFERENCES public.addresses(id) ON DELETE CASCADE;


--
-- Name: log_make log_make_buy_gem_fkey; Type: FK CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_make
    ADD CONSTRAINT log_make_buy_gem_fkey FOREIGN KEY (buy_gem) REFERENCES public.addresses(id) ON DELETE CASCADE;


--
-- Name: log_make log_make_header_id_fkey; Type: FK CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_make
    ADD CONSTRAINT log_make_header_id_fkey FOREIGN KEY (header_id) REFERENCES public.headers(id) ON DELETE CASCADE;


--
-- Name: log_make log_make_log_id_fkey; Type: FK CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_make
    ADD CONSTRAINT log_make_log_id_fkey FOREIGN KEY (log_id) REFERENCES public.event_logs(id) ON DELETE CASCADE;


--
-- Name: log_make log_make_oasis_fkey; Type: FK CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_make
    ADD CONSTRAINT log_make_oasis_fkey FOREIGN KEY (oasis) REFERENCES public.addresses(id) ON DELETE CASCADE;


--
-- Name: log_make log_make_pay_gem_fkey; Type: FK CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_make
    ADD CONSTRAINT log_make_pay_gem_fkey FOREIGN KEY (pay_gem) REFERENCES public.addresses(id) ON DELETE CASCADE;


--
-- Name: log_matching_enabled log_matching_enabled_address_id_fkey; Type: FK CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_matching_enabled
    ADD CONSTRAINT log_matching_enabled_address_id_fkey FOREIGN KEY (address_id) REFERENCES public.addresses(id) ON DELETE CASCADE;


--
-- Name: log_matching_enabled log_matching_enabled_header_id_fkey; Type: FK CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_matching_enabled
    ADD CONSTRAINT log_matching_enabled_header_id_fkey FOREIGN KEY (header_id) REFERENCES public.headers(id) ON DELETE CASCADE;


--
-- Name: log_matching_enabled log_matching_enabled_log_id_fkey; Type: FK CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_matching_enabled
    ADD CONSTRAINT log_matching_enabled_log_id_fkey FOREIGN KEY (log_id) REFERENCES public.event_logs(id) ON DELETE CASCADE;


--
-- Name: log_min_sell log_min_sell_address_id_fkey; Type: FK CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_min_sell
    ADD CONSTRAINT log_min_sell_address_id_fkey FOREIGN KEY (address_id) REFERENCES public.addresses(id) ON DELETE CASCADE;


--
-- Name: log_min_sell log_min_sell_header_id_fkey; Type: FK CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_min_sell
    ADD CONSTRAINT log_min_sell_header_id_fkey FOREIGN KEY (header_id) REFERENCES public.headers(id) ON DELETE CASCADE;


--
-- Name: log_min_sell log_min_sell_log_id_fkey; Type: FK CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_min_sell
    ADD CONSTRAINT log_min_sell_log_id_fkey FOREIGN KEY (log_id) REFERENCES public.event_logs(id) ON DELETE CASCADE;


--
-- Name: log_min_sell log_min_sell_pay_gem_fkey; Type: FK CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_min_sell
    ADD CONSTRAINT log_min_sell_pay_gem_fkey FOREIGN KEY (pay_gem) REFERENCES public.addresses(id) ON DELETE CASCADE;


--
-- Name: log_sorted_offer log_sorted_offer_address_id_fkey; Type: FK CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_sorted_offer
    ADD CONSTRAINT log_sorted_offer_address_id_fkey FOREIGN KEY (address_id) REFERENCES public.addresses(id) ON DELETE CASCADE;


--
-- Name: log_sorted_offer log_sorted_offer_header_id_fkey; Type: FK CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_sorted_offer
    ADD CONSTRAINT log_sorted_offer_header_id_fkey FOREIGN KEY (header_id) REFERENCES public.headers(id) ON DELETE CASCADE;


--
-- Name: log_sorted_offer log_sorted_offer_log_id_fkey; Type: FK CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_sorted_offer
    ADD CONSTRAINT log_sorted_offer_log_id_fkey FOREIGN KEY (log_id) REFERENCES public.event_logs(id) ON DELETE CASCADE;


--
-- Name: log_take log_take_address_id_fkey; Type: FK CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_take
    ADD CONSTRAINT log_take_address_id_fkey FOREIGN KEY (address_id) REFERENCES public.addresses(id) ON DELETE CASCADE;


--
-- Name: log_take log_take_buy_gem_fkey; Type: FK CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_take
    ADD CONSTRAINT log_take_buy_gem_fkey FOREIGN KEY (buy_gem) REFERENCES public.addresses(id) ON DELETE CASCADE;


--
-- Name: log_take log_take_header_id_fkey; Type: FK CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_take
    ADD CONSTRAINT log_take_header_id_fkey FOREIGN KEY (header_id) REFERENCES public.headers(id) ON DELETE CASCADE;


--
-- Name: log_take log_take_log_id_fkey; Type: FK CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_take
    ADD CONSTRAINT log_take_log_id_fkey FOREIGN KEY (log_id) REFERENCES public.event_logs(id) ON DELETE CASCADE;


--
-- Name: log_take log_take_oasis_fkey; Type: FK CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_take
    ADD CONSTRAINT log_take_oasis_fkey FOREIGN KEY (oasis) REFERENCES public.addresses(id) ON DELETE CASCADE;


--
-- Name: log_take log_take_pay_gem_fkey; Type: FK CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_take
    ADD CONSTRAINT log_take_pay_gem_fkey FOREIGN KEY (pay_gem) REFERENCES public.addresses(id) ON DELETE CASCADE;


--
-- Name: log_take log_take_taker_fkey; Type: FK CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_take
    ADD CONSTRAINT log_take_taker_fkey FOREIGN KEY (taker) REFERENCES public.addresses(id) ON DELETE CASCADE;


--
-- Name: log_trade log_trade_address_id_fkey; Type: FK CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_trade
    ADD CONSTRAINT log_trade_address_id_fkey FOREIGN KEY (address_id) REFERENCES public.addresses(id) ON DELETE CASCADE;


--
-- Name: log_trade log_trade_buy_gem_fkey; Type: FK CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_trade
    ADD CONSTRAINT log_trade_buy_gem_fkey FOREIGN KEY (buy_gem) REFERENCES public.addresses(id) ON DELETE CASCADE;


--
-- Name: log_trade log_trade_header_id_fkey; Type: FK CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_trade
    ADD CONSTRAINT log_trade_header_id_fkey FOREIGN KEY (header_id) REFERENCES public.headers(id) ON DELETE CASCADE;


--
-- Name: log_trade log_trade_log_id_fkey; Type: FK CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_trade
    ADD CONSTRAINT log_trade_log_id_fkey FOREIGN KEY (log_id) REFERENCES public.event_logs(id) ON DELETE CASCADE;


--
-- Name: log_trade log_trade_pay_gem_fkey; Type: FK CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_trade
    ADD CONSTRAINT log_trade_pay_gem_fkey FOREIGN KEY (pay_gem) REFERENCES public.addresses(id) ON DELETE CASCADE;


--
-- Name: log_unsorted_offer log_unsorted_offer_address_id_fkey; Type: FK CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_unsorted_offer
    ADD CONSTRAINT log_unsorted_offer_address_id_fkey FOREIGN KEY (address_id) REFERENCES public.addresses(id) ON DELETE CASCADE;


--
-- Name: log_unsorted_offer log_unsorted_offer_header_id_fkey; Type: FK CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_unsorted_offer
    ADD CONSTRAINT log_unsorted_offer_header_id_fkey FOREIGN KEY (header_id) REFERENCES public.headers(id) ON DELETE CASCADE;


--
-- Name: log_unsorted_offer log_unsorted_offer_log_id_fkey; Type: FK CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.log_unsorted_offer
    ADD CONSTRAINT log_unsorted_offer_log_id_fkey FOREIGN KEY (log_id) REFERENCES public.event_logs(id) ON DELETE CASCADE;


--
-- Name: set_min_sell set_min_sell_address_id_fkey; Type: FK CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.set_min_sell
    ADD CONSTRAINT set_min_sell_address_id_fkey FOREIGN KEY (address_id) REFERENCES public.addresses(id) ON DELETE CASCADE;


--
-- Name: set_min_sell set_min_sell_header_id_fkey; Type: FK CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.set_min_sell
    ADD CONSTRAINT set_min_sell_header_id_fkey FOREIGN KEY (header_id) REFERENCES public.headers(id) ON DELETE CASCADE;


--
-- Name: set_min_sell set_min_sell_log_id_fkey; Type: FK CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.set_min_sell
    ADD CONSTRAINT set_min_sell_log_id_fkey FOREIGN KEY (log_id) REFERENCES public.event_logs(id) ON DELETE CASCADE;


--
-- Name: set_min_sell set_min_sell_msg_sender_fkey; Type: FK CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.set_min_sell
    ADD CONSTRAINT set_min_sell_msg_sender_fkey FOREIGN KEY (msg_sender) REFERENCES public.addresses(id) ON DELETE CASCADE;


--
-- Name: set_min_sell set_min_sell_pay_gem_fkey; Type: FK CONSTRAINT; Schema: oasis; Owner: -
--

ALTER TABLE ONLY oasis.set_min_sell
    ADD CONSTRAINT set_min_sell_pay_gem_fkey FOREIGN KEY (pay_gem) REFERENCES public.addresses(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

