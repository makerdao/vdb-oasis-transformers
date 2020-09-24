-- +goose Up
CREATE TABLE oasis.log_trade
(
    id         serial primary key,
    log_id     bigint  not null references public.event_logs (id) on delete cascade,
    address_id bigint  not null references public.addresses (id) on delete cascade,
    pay_gem    bigint  not null references public.addresses (id) on delete cascade,
    buy_gem    bigint  not null references public.addresses (id) on delete cascade,
    pay_amt    numeric,
    buy_amt    numeric,
    header_id  integer not null references public.headers (id) on delete cascade,
    UNIQUE (header_id, log_id)
);

CREATE INDEX log_trade_header_index
    ON oasis.log_trade (header_id);
CREATE INDEX log_trade_log_index
    ON oasis.log_trade (log_id);
CREATE INDEX log_trade_address_index
    ON oasis.log_trade (address_id);
CREATE INDEX log_trade_pay_gem_index
    ON oasis.log_trade (pay_gem);
CREATE INDEX log_trade_buy_gem_index
    ON oasis.log_trade (buy_gem);

-- +goose Down
DROP TABLE oasis.log_trade;