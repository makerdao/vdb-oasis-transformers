-- +goose Up
CREATE TABLE oasis.log_bump
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

CREATE INDEX log_bump_header_index
    ON oasis.log_bump (header_id);
CREATE INDEX log_bump_log_index
    ON oasis.log_bump (log_id);
CREATE INDEX log_bump_address_index
    ON oasis.log_bump (address_id);
CREATE INDEX log_bump_oasis_index
    ON oasis.log_bump (oasis);
CREATE INDEX log_bump_pay_gem_index
    ON oasis.log_bump (pay_gem);
CREATE INDEX log_bump_buy_gem_index
    ON oasis.log_bump (buy_gem);

-- +goose Down
DROP TABLE oasis.log_bump;