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
  - [ ] Teams?
  - [ ] API Tokens
  - [ ] Tokens not restricted to user (by team?)
- [ ] Elixir packages
  - [ ] Namespaces (hex organization like)?
- [ ] NPM packages?
  - [ ] Namespaces (npm org scope like)?
- [ ] Postgres database support (optional vs sqlite)
- [ ] GCP bucket storage

## Inspiration

A lot of the initial code was taken from the _many_ other hex package managers:
- [Bytepack](https://github.com/dashbitco/bytepack_archive)
- [mini_repo](https://github.com/wojtekmach/mini_repo)
- [urepo](https://github.com/kobil-systems/urepo)

as well as `mix phx.gen.auth`, and [Tailwind UI](https://tailwindui.com/). Check them out!

## License

[MIT](LICENSE).
