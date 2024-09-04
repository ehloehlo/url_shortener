# URL Shortener
An example microservice that converts long URLs into short links, redirects requests from short links to their original URLs, and tracks the number of times a URL has been accessed.


## Setup & run

1. Prepare environment (`.envrc`)
```
direnv allow
```

2. Run Postgres
```
docker compose up pg -d
```

3. Fetch dependencies and run migrations
```
mix setup
```

4. Run the server
```
mix phx.server
```
