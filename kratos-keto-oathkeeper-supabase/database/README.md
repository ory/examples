## Setting up a Database

This directory contains DB implementations for
- MockDB
- PostgreSQL
- SupaBase

The API shortener service uses one of the above databases to store URLs and Viewer IDs.

### Using a MockDB
MockDB is picked by default. Nothing needs to be done to use it


### Using a PosgreSQL DB
If you want to use a PostgreSQL DB, run a `docker-compose.yml` and make a valid `DSN` export like this:

```bash
export DATABASE_PROVIDER=postgres
export DSN=postgres://user:pass@localhost:5432/shorts?sslmode=disable&max_conns=20&max_idle_conns=4
```


### Using SupaBase DB
If you want to use a Supabase DB, make the following exports

```bash
export DATABASE_PROVIDER=supabase
export SUPABASE_URL=SB_URL/rest/v1
export SUPABASE_KEY=SB_KEY

go test -v -run TestSupa
```

`SB_URL` and `SB_KEY` can be obtained from your `SupaBase` [account](https://app.supabase.com/)

### Runnint tests
`go test -v -run TestMock` - to run a MockDB test
`go test -v -run TestPost` - to run a PostgreSQL test
`go test -v -run TestSupa` - to run a SupaBase test