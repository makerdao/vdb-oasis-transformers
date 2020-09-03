-- +goose Up
CREATE TABLE oasis.log_take
(
    id         serial primary key,
    log_id     bigint  not null references public.event_logs (id) on delete cascade,
    address_id bigint  not null references public.addresses (id) on delete cascade,
    oasis      bigint  not null references public.addresses (id) on delete cascade,
    pay_gem    bigint  not null references public.addresses (id) on delete cascade,
    buy_gem    bigint  not null references public.addresses (id) on delete cascade,
    taker      bigint  not null references public.addresses (id) on delete cascade,
    take_amt   numeric,
    give_amt   numeric,
    offer_id   numeric,
    pair       character varying(66),
    header_id  integer not null references public.headers (id) on delete cascade,
    timestamp  integer,
    UNIQUE (header_id, log_id)
);

CREATE INDEX log_take_header_index
    ON oasis.log_take (header_id);
CREATE INDEX log_take_log_index
    ON oasis.log_take (log_id);
CREATE INDEX log_take_address_index
    ON oasis.log_take (address_id);
CREATE INDEX log_take_oasis_index
    ON oasis.log_take (oasis);
CREATE INDEX log_take_pay_gem_index
    ON oasis.log_take (pay_gem);
CREATE INDEX log_take_buy_gem_index
    ON oasis.log_take (buy_gem);
CREATE INDEX log_take_taker_index
    ON oasis.log_take (taker);

-- +goose Down
DROP TABLE oasis.log_take;