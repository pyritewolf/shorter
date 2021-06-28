-- +micrate Up
-- SQL in section 'Up' is executed when this migration is applied
ALTER TABLE urls 
  ADD COLUMN is_private BOOLEAN NOT NULL DEFAULT FALSE;
ALTER TABLE urls ALTER COLUMN is_private DROP DEFAULT;

-- +micrate Down
-- SQL section 'Down' is executed when this migration is rolled back
ALTER TABLE urls 
  DROP COLUMN is_private;
