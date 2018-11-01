# IWT Elm Phoenix Example

## Getting Started

### Prerequisites

[Install Docker](https://docs.docker.com/install/)

[Install Elixir](https://elixir-lang.org/install.html)

[Install Node.js/npm](https://nodejs.org/en/download/)

Install Hex (Elixir package manager):

    mix local.hex

Install Phoenix:

    mix archive.install https://github.com/phoenixframework/archives/raw/master/phx_new.ez

Install npx (if you don't already have it):

    npm i -g npx

### Initial setup
* Prep the DB
```
    docker run
      --name reliable-prototype
      --publish 5432:5432
      -e POSTGRES_PASSWORD=reliable
      -d postgres
    mix ecto.create
```

### Every time you develop

    # TODO: Move this stuff to package.json dev script.
    npx elm-graphql http://localhost:5000/graphql --output frontend/src # TODO: Move to start/watch script.
    cd backend # TODO: Move mix.exs to top-level project folder.
    mix deps.get # In case someone else added deps.
    mix ecto.migrate # Is this necessary? Is this done on mix phx.server?
    mix run priv/repo/seeds.exs # Is this necessary? Is this done on mix phx.server?
    cd .. && npm start

Open psql

    docker exec -it reliable-prototype psql -U postgres

## Example workflow

When creating prototypes, a quick feedback loop is important. Here's an example of how you might work on a new feature.

      /--> (start) Define data structure ----\
     /                                        \
    /                                          |
    |                                          v
    |                                    Update query
    |                                          |
     \                                        /
      \                                      /
       \----------- Update view <-----------/  

### Create Patient/patients schema

Create the model, a migration and updates the database.

    cd backend # TODO: Move mix.exs to top-level project folder.
    mix phx.gen.schema Patient patients firstName:string lastName:string mrn:string dateOfBirth:date
    mix ecto.migrate

GraphQL Query:

    {
      query {
        allPatients {
          nodes {
             firstName
          }
        }
      }
    }

### Update frontend GraphQL API

For now, this is a manual step. I'm investigating how to automatically run elm-graphql on schema change.

    npx elm-graphql http://localhost:5000/graphql --output frontend/src # TODO: Move to start/watch script.
