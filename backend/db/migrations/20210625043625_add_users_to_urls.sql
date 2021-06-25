-- +micrate Up
-- SQL in section 'Up' is executed when this migration is applied
ALTER TABLE urls 
  ADD COLUMN user_id INTEGER NOT NULL DEFAULT 1
  REFERENCES users (id);
ALTER TABLE urls ALTER COLUMN user_id DROP DEFAULT;

-- +micrate Down
-- SQL section 'Down' is executed when this migration is rolled back
ALTER TABLE urls 
  DROP COLUMN user_id;
