-- +goose Up
CREATE TABLE oasis.log_make
(
    id         serial primary key,
    log_id     bigint  not null references public.event_logs (id) on delete cascade,
    address_id bigint  not null references public.addresses (id) on delete cascade,
    oasis      bigint  not null references public.addresses (id) on delete cascade,
    pay_gem    bigint  not null references public.addresses (id) on delete cascade,
    buy_gem    bigint  not null references public.addresses (id) on delete cascade,
    pay_amt    numeric,
    buy_amt    numeric,
    offer_id   numeric,
    pair       character varying(66),
    header_id  integer not null references public.headers (id) on delete cascade,
    timestamp  integer,
    UNIQUE (header_id, log_id)
);

CREATE INDEX log_make_header_index
    ON oasis.log_make (header_id);
CREATE INDEX log_make_log_index
    ON oasis.log_make (log_id);
CREATE INDEX log_make_address_index
    ON oasis.log_make (address_id);
CREATE INDEX log_make_oasis_index
    ON oasis.log_make (oasis);
CREATE INDEX log_make_pay_gem_index
    ON oasis.log_make (pay_gem);
CREATE INDEX log_make_buy_gem_index
    ON oasis.log_make (buy_gem);

-- +goose Down
DROP TABLE oasis.log_make;