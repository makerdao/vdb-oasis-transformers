-- +goose Up
CREATE TABLE oasis.log_item_update
(
    id         SERIAL PRIMARY KEY,
    log_id     BIGINT  NOT NULL REFERENCES public.event_logs (id) ON DELETE CASCADE,
    address_id BIGINT  NOT NULL REFERENCES public.addresses (id) ON DELETE CASCADE,
    header_id  INTEGER NOT NULL REFERENCES public.headers (id) ON DELETE CASCADE,
    offer_id   NUMERIC,
    UNIQUE (header_id, log_id)
);

CREATE INDEX log_item_update_header_index
    ON oasis.log_item_update (header_id);
CREATE INDEX log_item_update_log_index
    ON oasis.log_item_update (log_id);
CREATE INDEX log_item_update_address_index
    ON oasis.log_item_update (address_id);

-- +goose Down
DROP TABLE oasis.log_item_update;
