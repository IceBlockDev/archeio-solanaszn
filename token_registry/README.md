# Token Registry

### To start your Phoenix server

1. use docker compose:

```bash
docker-compose up -d

Starting token_registry_db_1 ... done
Starting token_registry_web_1 ... done
```

2. Now check what's running

```bash

docker ps


e3f10a14b178   postgres:13-alpine   "docker-entrypoint.s…"   16 hours ago   Up 53 seconds   5432/tcp                                    token_registry_db_1
a9f8ce66062e   token_registry_web   "/bin/sh -c 'mix dep…"   17 hours ago   Up 50 seconds   0.0.0.0:4000->4000/tcp, :::4000->4000/tcp   token_registry_web_1
```

3. If you have issues with the web server, you might try - from another terminal - 

```bash
docker-compose run web mix ecto.create 
```


## TO get a developmnent shell

You can use: 

```bash
bash-compose run web bash
```
or 

```bash
docker exec -ti token_registry_web_1 bash
```






Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.




For more on Phoenix and elixir  Please [Phoenix deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
