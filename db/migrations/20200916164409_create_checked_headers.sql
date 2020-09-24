-- +goose Up
CREATE TABLE oasis.checked_headers
(
    id          SERIAL PRIMARY KEY,
    check_count INTEGER,
    header_id   INTEGER NOT NULL REFERENCES public.headers (id) ON DELETE CASCADE,
    UNIQUE (header_id)
);

CREATE INDEX checked_headers_header_index
    ON oasis.checked_headers (header_id);
CREATE INDEX checked_headers_check_count
    ON oasis.checked_headers (check_count);

-- +goose Down
DROP TABLE oasis.checked_headers;
