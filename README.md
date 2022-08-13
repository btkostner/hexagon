# Hexagon

A package server for your organization.

## How to run

This project is still under very active development. You can view a development instance of it running at <https://hexagon.fly.dev>, or simply launch the included `Dockerfile`. You will need a persistent directory to hold your database and store your packages.

## What this is

A simple to get running hex repository designed for a single organization or enterprise.

## What this is not

This _is not_ a SaaS framework or something you would want multiple entities to have access to.

## Todo

- [X] Basic authentication (`mix phx.gen.auth`)
  - [ ] Teams
  - [ ] Tokens not restricted to user (by team?)
- [ ] Elixir packages
- [ ] NPM packages?
- [ ] Postgres database support (optional vs sqlite)
- [ ] GCP bucket storage

## Inspiration

A lot of the initial code was taken from [Dashbit's Bytepack project](https://github.com/dashbitco/bytepack_archive), `mix phx.gen.auth`, and [Tailwind UI](https://tailwindui.com/). Check them out!

## License

[MIT](LICENSE).
