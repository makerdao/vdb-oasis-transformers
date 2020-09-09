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


--
-- Name: diff_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.diff_status AS ENUM (
    'new',
    'transformed',
    'unrecognized',
    'noncanonical',
    'unwatched'
);


--
-- Name: create_back_filled_diff(bigint, bytea, bytea, bytea, bytea, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.create_back_filled_diff(block_height bigint, block_hash bytea, address bytea, storage_key bytea, storage_value bytea, eth_node_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    last_storage_value  BYTEA := (
        SELECT storage_diff.storage_value
        FROM public.storage_diff
        WHERE storage_diff.block_height <= create_back_filled_diff.block_height
          AND storage_diff.address = create_back_filled_diff.address
          AND storage_diff.storage_key = create_back_filled_diff.storage_key
        ORDER BY storage_diff.block_height DESC
        LIMIT 1
    );
    empty_storage_value BYTEA := (
        SELECT '\x0000000000000000000000000000000000000000000000000000000000000000'::BYTEA
    );
BEGIN
    IF last_storage_value = create_back_filled_diff.storage_value THEN
        RETURN;
    END IF;
    IF last_storage_value is null and create_back_filled_diff.storage_value = empty_storage_value THEN
        RETURN;
    END IF;
    INSERT INTO public.storage_diff (block_height, block_hash, address, storage_key, storage_value,
                                     eth_node_id, from_backfill)
    VALUES (create_back_filled_diff.block_height, create_back_filled_diff.block_hash,
            create_back_filled_diff.address, create_back_filled_diff.storage_key,
            create_back_filled_diff.storage_value, create_back_filled_diff.eth_node_id, true)
    ON CONFLICT DO NOTHING;
    RETURN;
END
$$;


--
-- Name: FUNCTION create_back_filled_diff(block_height bigint, block_hash bytea, address bytea, storage_key bytea, storage_value bytea, eth_node_id integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.create_back_filled_diff(block_height bigint, block_hash bytea, address bytea, storage_key bytea, storage_value bytea, eth_node_id integer) IS '@omit';


--
-- Name: get_or_create_header(bigint, character varying, jsonb, numeric, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_or_create_header(block_number bigint, hash character varying, raw jsonb, block_timestamp numeric, eth_node_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    matching_header_id    INTEGER := (
        SELECT id
        FROM public.headers
        WHERE headers.block_number = get_or_create_header.block_number
          AND headers.hash = get_or_create_header.hash
    );
    nonmatching_header_id INTEGER := (
        SELECT id
        FROM public.headers
        WHERE headers.block_number = get_or_create_header.block_number
          AND headers.hash != get_or_create_header.hash
    );
    max_block_number      BIGINT  := (
        SELECT MAX(headers.block_number)
        FROM public.headers
    );
    inserted_header_id    INTEGER;
BEGIN
    IF matching_header_id != 0 THEN
        RETURN matching_header_id;
    END IF;
    IF nonmatching_header_id != 0 AND block_number <= max_block_number - 15 THEN
        RETURN nonmatching_header_id;
    END IF;
    IF nonmatching_header_id != 0 AND block_number > max_block_number - 15 THEN
        DELETE FROM public.headers WHERE id = nonmatching_header_id;
    END IF;
    INSERT INTO public.headers (hash, block_number, raw, block_timestamp, eth_node_id)
    VALUES (get_or_create_header.hash, get_or_create_header.block_number, get_or_create_header.raw,
            get_or_create_header.block_timestamp, get_or_create_header.eth_node_id)
    RETURNING id INTO inserted_header_id;
    RETURN inserted_header_id;
END
$$;


--
-- Name: FUNCTION get_or_create_header(block_number bigint, hash character varying, raw jsonb, block_timestamp numeric, eth_node_id integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.get_or_create_header(block_number bigint, hash character varying, raw jsonb, block_timestamp numeric, eth_node_id integer) IS '@omit';


--
-- Name: set_event_log_updated(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.set_event_log_updated() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated = NOW();
    RETURN NEW;
END;
$$;


--
-- Name: set_header_updated(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.set_header_updated() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated = NOW();
    RETURN NEW;
END;
$$;


--
-- Name: set_receipt_updated(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.set_receipt_updated() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated = NOW();
    RETURN NEW;
END;
$$;


--
-- Name: set_storage_updated(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.set_storage_updated() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated = NOW();
    RETURN NEW;
END;
$$;


--
-- Name: set_transaction_updated(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.set_transaction_updated() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated = NOW();
    RETURN NEW;
END;
$$;


SET default_tablespace = '';

SET default_with_oids = false;

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
-- Name: addresses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.addresses (
    id bigint NOT NULL,
    address character varying(42)
);


--
-- Name: addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.addresses_id_seq OWNED BY public.addresses.id;


--
-- Name: checked_headers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.checked_headers (
    id integer NOT NULL,
    header_id integer NOT NULL
);


--
-- Name: checked_headers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.checked_headers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: checked_headers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.checked_headers_id_seq OWNED BY public.checked_headers.id;


--
-- Name: eth_nodes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.eth_nodes (
    id integer NOT NULL,
    client_name character varying,
    genesis_block character varying(66),
    network_id numeric,
    eth_node_id character varying(128)
);


--
-- Name: eth_nodes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.eth_nodes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: eth_nodes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.eth_nodes_id_seq OWNED BY public.eth_nodes.id;


--
-- Name: event_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.event_logs (
    id bigint NOT NULL,
    header_id integer NOT NULL,
    address bigint NOT NULL,
    topics bytea[],
    data bytea,
    block_number bigint,
    block_hash character varying(66),
    tx_hash character varying(66),
    tx_index integer,
    log_index integer,
    raw jsonb,
    transformed boolean DEFAULT false NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: event_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.event_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: event_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.event_logs_id_seq OWNED BY public.event_logs.id;


--
-- Name: goose_db_version; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.goose_db_version (
    id integer NOT NULL,
    version_id bigint NOT NULL,
    is_applied boolean NOT NULL,
    tstamp timestamp without time zone DEFAULT now()
);


--
-- Name: goose_db_version_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.goose_db_version_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: goose_db_version_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.goose_db_version_id_seq OWNED BY public.goose_db_version.id;


--
-- Name: headers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.headers (
    id integer NOT NULL,
    hash character varying(66) NOT NULL,
    block_number bigint NOT NULL,
    raw jsonb,
    block_timestamp numeric,
    check_count integer DEFAULT 0 NOT NULL,
    eth_node_id integer NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: headers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.headers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: headers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.headers_id_seq OWNED BY public.headers.id;


--
-- Name: receipts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.receipts (
    id integer NOT NULL,
    transaction_id integer NOT NULL,
    header_id integer NOT NULL,
    contract_address_id bigint NOT NULL,
    cumulative_gas_used numeric,
    gas_used numeric,
    state_root character varying(66),
    status integer,
    tx_hash character varying(66),
    rlp bytea,
    created timestamp without time zone DEFAULT now() NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: receipts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.receipts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: receipts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.receipts_id_seq OWNED BY public.receipts.id;


--
-- Name: storage_diff; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_diff (
    id bigint NOT NULL,
    address bytea,
    block_height bigint,
    block_hash bytea,
    storage_key bytea,
    storage_value bytea,
    eth_node_id integer NOT NULL,
    status public.diff_status DEFAULT 'new'::public.diff_status NOT NULL,
    from_backfill boolean DEFAULT false NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: storage_diff_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.storage_diff_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: storage_diff_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.storage_diff_id_seq OWNED BY public.storage_diff.id;


--
-- Name: transactions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.transactions (
    id integer NOT NULL,
    header_id integer NOT NULL,
    hash character varying(66) NOT NULL,
    gas_limit numeric,
    gas_price numeric,
    input_data bytea,
    nonce numeric,
    raw bytea,
    tx_from character varying(44),
    tx_index integer,
    tx_to character varying(44),
    value numeric,
    created timestamp without time zone DEFAULT now() NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.transactions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.transactions_id_seq OWNED BY public.transactions.id;


--
-- Name: watched_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.watched_logs (
    id integer NOT NULL,
    contract_address character varying(42),
    topic_zero character varying(66)
);


--
-- Name: watched_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.watched_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: watched_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.watched_logs_id_seq OWNED BY public.watched_logs.id;


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
-- Name: addresses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.addresses ALTER COLUMN id SET DEFAULT nextval('public.addresses_id_seq'::regclass);


--
-- Name: checked_headers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.checked_headers ALTER COLUMN id SET DEFAULT nextval('public.checked_headers_id_seq'::regclass);


--
-- Name: eth_nodes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.eth_nodes ALTER COLUMN id SET DEFAULT nextval('public.eth_nodes_id_seq'::regclass);


--
-- Name: event_logs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_logs ALTER COLUMN id SET DEFAULT nextval('public.event_logs_id_seq'::regclass);


--
-- Name: goose_db_version id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.goose_db_version ALTER COLUMN id SET DEFAULT nextval('public.goose_db_version_id_seq'::regclass);


--
-- Name: headers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.headers ALTER COLUMN id SET DEFAULT nextval('public.headers_id_seq'::regclass);


--
-- Name: receipts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.receipts ALTER COLUMN id SET DEFAULT nextval('public.receipts_id_seq'::regclass);


--
-- Name: storage_diff id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_diff ALTER COLUMN id SET DEFAULT nextval('public.storage_diff_id_seq'::regclass);


--
-- Name: transactions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transactions ALTER COLUMN id SET DEFAULT nextval('public.transactions_id_seq'::regclass);


--
-- Name: watched_logs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.watched_logs ALTER COLUMN id SET DEFAULT nextval('public.watched_logs_id_seq'::regclass);


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
-- Name: addresses addresses_address_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT addresses_address_key UNIQUE (address);


--
-- Name: addresses addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (id);


--
-- Name: checked_headers checked_headers_header_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.checked_headers
    ADD CONSTRAINT checked_headers_header_id_key UNIQUE (header_id);


--
-- Name: checked_headers checked_headers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.checked_headers
    ADD CONSTRAINT checked_headers_pkey PRIMARY KEY (id);


--
-- Name: eth_nodes eth_nodes_genesis_block_network_id_eth_node_id_client_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.eth_nodes
    ADD CONSTRAINT eth_nodes_genesis_block_network_id_eth_node_id_client_name_key UNIQUE (genesis_block, network_id, eth_node_id, client_name);


--
-- Name: eth_nodes eth_nodes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.eth_nodes
    ADD CONSTRAINT eth_nodes_pkey PRIMARY KEY (id);


--
-- Name: event_logs event_logs_header_id_tx_index_log_index_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_logs
    ADD CONSTRAINT event_logs_header_id_tx_index_log_index_key UNIQUE (header_id, tx_index, log_index);


--
-- Name: event_logs event_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_logs
    ADD CONSTRAINT event_logs_pkey PRIMARY KEY (id);


--
-- Name: goose_db_version goose_db_version_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.goose_db_version
    ADD CONSTRAINT goose_db_version_pkey PRIMARY KEY (id);


--
-- Name: headers headers_block_number_eth_node_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.headers
    ADD CONSTRAINT headers_block_number_eth_node_id_key UNIQUE (block_number, eth_node_id);


--
-- Name: headers headers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.headers
    ADD CONSTRAINT headers_pkey PRIMARY KEY (id);


--
-- Name: receipts receipts_header_id_transaction_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.receipts
    ADD CONSTRAINT receipts_header_id_transaction_id_key UNIQUE (header_id, transaction_id);


--
-- Name: receipts receipts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.receipts
    ADD CONSTRAINT receipts_pkey PRIMARY KEY (id);


--
-- Name: storage_diff storage_diff_block_height_block_hash_address_storage_key_st_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_diff
    ADD CONSTRAINT storage_diff_block_height_block_hash_address_storage_key_st_key UNIQUE (block_height, block_hash, address, storage_key, storage_value);


--
-- Name: storage_diff storage_diff_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_diff
    ADD CONSTRAINT storage_diff_pkey PRIMARY KEY (id);


--
-- Name: transactions transactions_hash_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_hash_key UNIQUE (hash);


--
-- Name: transactions transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (id);


--
-- Name: watched_logs watched_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.watched_logs
    ADD CONSTRAINT watched_logs_pkey PRIMARY KEY (id);


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
-- Name: event_logs_address; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX event_logs_address ON public.event_logs USING btree (address);


--
-- Name: event_logs_transaction; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX event_logs_transaction ON public.event_logs USING btree (tx_hash);


--
-- Name: event_logs_untransformed; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX event_logs_untransformed ON public.event_logs USING btree (transformed) WHERE (transformed = false);


--
-- Name: headers_block_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX headers_block_number ON public.headers USING btree (block_number);


--
-- Name: headers_block_timestamp_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX headers_block_timestamp_index ON public.headers USING btree (block_timestamp);


--
-- Name: headers_check_count; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX headers_check_count ON public.headers USING btree (check_count);


--
-- Name: headers_eth_node; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX headers_eth_node ON public.headers USING btree (eth_node_id);


--
-- Name: receipts_contract_address; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX receipts_contract_address ON public.receipts USING btree (contract_address_id);


--
-- Name: receipts_transaction; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX receipts_transaction ON public.receipts USING btree (transaction_id);


--
-- Name: storage_diff_eth_node; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_diff_eth_node ON public.storage_diff USING btree (eth_node_id);


--
-- Name: storage_diff_new_status_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_diff_new_status_index ON public.storage_diff USING btree (status) WHERE (status = 'new'::public.diff_status);


--
-- Name: storage_diff_unrecognized_status_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_diff_unrecognized_status_index ON public.storage_diff USING btree (status) WHERE (status = 'unrecognized'::public.diff_status);


--
-- Name: transactions_header; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX transactions_header ON public.transactions USING btree (header_id);


--
-- Name: event_logs event_log_updated; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER event_log_updated BEFORE UPDATE ON public.event_logs FOR EACH ROW EXECUTE PROCEDURE public.set_event_log_updated();


--
-- Name: headers header_updated; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER header_updated BEFORE UPDATE ON public.headers FOR EACH ROW EXECUTE PROCEDURE public.set_header_updated();


--
-- Name: receipts receipt_updated; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER receipt_updated BEFORE UPDATE ON public.receipts FOR EACH ROW EXECUTE PROCEDURE public.set_receipt_updated();


--
-- Name: storage_diff storage_updated; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER storage_updated BEFORE UPDATE ON public.storage_diff FOR EACH ROW EXECUTE PROCEDURE public.set_storage_updated();


--
-- Name: transactions transaction_updated; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER transaction_updated BEFORE UPDATE ON public.transactions FOR EACH ROW EXECUTE PROCEDURE public.set_transaction_updated();


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
-- Name: checked_headers checked_headers_header_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.checked_headers
    ADD CONSTRAINT checked_headers_header_id_fkey FOREIGN KEY (header_id) REFERENCES public.headers(id) ON DELETE CASCADE;


--
-- Name: event_logs event_logs_address_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_logs
    ADD CONSTRAINT event_logs_address_fkey FOREIGN KEY (address) REFERENCES public.addresses(id) ON DELETE CASCADE;


--
-- Name: event_logs event_logs_header_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_logs
    ADD CONSTRAINT event_logs_header_id_fkey FOREIGN KEY (header_id) REFERENCES public.headers(id) ON DELETE CASCADE;


--
-- Name: event_logs event_logs_tx_hash_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_logs
    ADD CONSTRAINT event_logs_tx_hash_fkey FOREIGN KEY (tx_hash) REFERENCES public.transactions(hash) ON DELETE CASCADE;


--
-- Name: headers headers_eth_node_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.headers
    ADD CONSTRAINT headers_eth_node_id_fkey FOREIGN KEY (eth_node_id) REFERENCES public.eth_nodes(id) ON DELETE CASCADE;


--
-- Name: receipts receipts_contract_address_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.receipts
    ADD CONSTRAINT receipts_contract_address_id_fkey FOREIGN KEY (contract_address_id) REFERENCES public.addresses(id) ON DELETE CASCADE;


--
-- Name: receipts receipts_header_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.receipts
    ADD CONSTRAINT receipts_header_id_fkey FOREIGN KEY (header_id) REFERENCES public.headers(id) ON DELETE CASCADE;


--
-- Name: receipts receipts_transaction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.receipts
    ADD CONSTRAINT receipts_transaction_id_fkey FOREIGN KEY (transaction_id) REFERENCES public.transactions(id) ON DELETE CASCADE;


--
-- Name: storage_diff storage_diff_eth_node_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_diff
    ADD CONSTRAINT storage_diff_eth_node_id_fkey FOREIGN KEY (eth_node_id) REFERENCES public.eth_nodes(id) ON DELETE CASCADE;


--
-- Name: transactions transactions_header_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_header_id_fkey FOREIGN KEY (header_id) REFERENCES public.headers(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

