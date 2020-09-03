-- +goose Up
CREATE TABLE oasis.log_kill
(
    id         SERIAL PRIMARY KEY,
    log_id     BIGINT  NOT NULL REFERENCES public.event_logs (id) ON DELETE CASCADE,
    address_id BIGINT  NOT NULL REFERENCES public.addresses (id) ON DELETE CASCADE,
    oasis      BIGINT  NOT NULL REFERENCES public.addresses (id) ON DELETE CASCADE,
    pay_gem    BIGINT  NOT NULL REFERENCES public.addresses (id) ON DELETE CASCADE,
    buy_gem    BIGINT  NOT NULL REFERENCES public.addresses (id) ON DELETE CASCADE,
    pay_amt    NUMERIC,
    buy_amt    NUMERIC,
    offer_id   NUMERIC,
    pair       CHARACTER VARYING(66),
    header_id  INTEGER NOT NULL REFERENCES public.headers (id) ON DELETE CASCADE,
    timestamp  INTEGER,
    UNIQUE (header_id, log_id)
);

CREATE INDEX log_kill_index
    ON oasis.log_kill (log_id);
CREATE INDEX log_kill_header_index
    ON oasis.log_kill (header_id);
CREATE INDEX log_kill_address_index
    ON oasis.log_kill (address_id);
CREATE INDEX log_kill_oasis_index
    ON oasis.log_kill (oasis);
CREATE INDEX log_kill_pay_gem_index
    ON oasis.log_kill (pay_gem);
CREATE INDEX log_kill_buy_gem_index
    ON oasis.log_kill (buy_gem);

-- +goose Down
DROP TABLE oasis.log_kill;