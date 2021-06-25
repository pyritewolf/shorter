# Shorter

I wanted to try some shit out in Crystal & Svelte. Sue me.

## Wanna run it locally?

- Clone the repo
- Copy `.env.sample` to an `.env` file at the root of the project and add your Google auth keys
- From the root of the project, run `./dev-setup.sh`
- Run `docker-compose up`
- Visit http://localhost:5000 (or http://ui.shorter.lvh.me:5000 if you're using [dockerdev](https://github.com/waj/dockerdev))!

## Development

### Migrations

The project has [Micrate](https://github.com/amberframework/micrate) set up because clear's migrations weren't documented enough for me to work them out. Mixing frameworks, yey!

- Create migrations with `docker-compose run --rm api crystal db/micrate.cr scaffold your_migration_name`
  - Edit them in `db/migrations`
- Run migrations with `docker-compose run --rm api crystal db/micrate.cr up`
- Revert migrations with `docker-compose run --rm api crystal db/micrate.cr down`
