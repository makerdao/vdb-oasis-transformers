-- +goose Up
CREATE TABLE oasis.log_delete
(
    id         serial primary key,
    log_id     bigint  not null references public.event_logs (id) on delete cascade,
    address_id bigint  not null references public.addresses (id) on delete cascade,
    keeper     bigint  not null references public.addresses (id) on delete cascade,
    offer_id   numeric,
    header_id  integer not null references public.headers (id) on delete cascade,
    UNIQUE (header_id, log_id)
);

CREATE INDEX log_delete_header_index
    ON oasis.log_delete (header_id);
CREATE INDEX log_delete_log_index
    ON oasis.log_delete (log_id);
CREATE INDEX log_delete_address_index
    ON oasis.log_delete (address_id);
CREATE INDEX log_delete_keeper_index
    ON oasis.log_delete (keeper);

-- +goose Down
DROP TABLE oasis.log_delete;