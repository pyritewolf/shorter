-- +micrate Up
-- SQL in section 'Up' is executed when this migration is applied
CREATE TABLE urls(
  id SERIAL PRIMARY KEY,
  path varchar(256) NOT NULL UNIQUE,
  redirect_to text NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now()
);

CREATE INDEX urls_path_idx ON urls (path);

-- +micrate Down
-- SQL section 'Down' is executed when this migration is rolled back
DROP INDEX urls_path_idx;
DROP TABLE urls;
