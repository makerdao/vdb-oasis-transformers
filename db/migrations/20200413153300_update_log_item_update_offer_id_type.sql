-- +goose Up
ALTER TABLE oasis.log_item_update
    ALTER COLUMN offer_id TYPE NUMERIC;

-- +goose Down

ALTER TABLE oasis.log_item_update
    ALTER COLUMN offer_id TYPE INT;

