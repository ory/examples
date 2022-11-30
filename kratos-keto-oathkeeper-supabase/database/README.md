## Database testing

If you want to use a Supabase DB, make the following exports

```bash
export SUPABASE_URL=SB_URL/rest/v1
export SUPABASE_KEY=SB_KEY

go test -v -run TestSupa
```

`SB_URL` and `SB_KEY` should be obtained from your `SupaBase` [account](https://app.supabase.com/)