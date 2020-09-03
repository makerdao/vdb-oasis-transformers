-- +goose Up
CREATE TABLE oasis.log_sorted_offer
(
    id         SERIAL PRIMARY KEY,
    log_id     BIGINT  NOT NULL REFERENCES public.event_logs (id) ON DELETE CASCADE,
    address_id BIGINT  NOT NULL REFERENCES public.addresses (id) ON DELETE CASCADE,
    offer_id   NUMERIC,
    header_id  INTEGER NOT NULL REFERENCES public.headers (id) ON DELETE CASCADE,
    UNIQUE (header_id, log_id)
);

CREATE INDEX log_sorted_offer_header_index
    ON oasis.log_sorted_offer (header_id);
CREATE INDEX log_sorted_offer_log_index
    ON oasis.log_sorted_offer (log_id);
CREATE INDEX log_sorted_offer_address_index
    ON oasis.log_sorted_offer (address_id);

-- +goose Down
DROP TABLE oasis.log_sorted_offer;
