-- +micrate Up
-- SQL in section 'Up' is executed when this migration is applied
CREATE TABLE users(
  id SERIAL PRIMARY KEY,
  google_id varchar(256) NOT NULL UNIQUE,
  first_name text NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now()
);


-- +micrate Down
-- SQL section 'Down' is executed when this migration is rolled back
DROP TABLE users;
