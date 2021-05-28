# Shorter

I wanted to try some shit out in @crystal-lang & @sveltejs.

## Wanna run it locally?

- Clone the repo
- Copy `.env.sample` to an `.env` file at the root of the project and add your Google auth keys
- From the root of the project, run `./dev-setup.sh`
- Go to `/backend/db/migrations`
  - :warning: Micrate is not working for some reason, I'm using it just to create the migration files
  - Copy the "up" part of each file and run that in the DB:
    ```zsh
    # before running anything
    docker-compose up -d db

    # for each sentence you want to run:
    docker-compose exec -e PGPASSWORD=$POSTGRES_PASSWORD db psql -h db -U $POSTGRES_USER -d postgres -c "The SQL you want to run!"

    # after you've run all the sentences
    docker-compose stop
    ```
  - I know, it's ugly af

You should be able to run `docker-compose up` after all that jazz!
