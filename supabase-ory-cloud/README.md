# Ory cloud and Supabase Database example

## Creating Supabase project and tables

1. From your [Supabase dashboard](https://app.supabase.io/) , click New project.
1. Enter a Name for your Supabase project.
1. Enter a secure Database Password.
1. Select the Region you want.
1. Click Create new project.
1. Open table editor.
1. Click on SQL editor on sidebar.
1. Insert SQL table definition(see the code below)
1. Click Run to create tables.

```sql
CREATE TABLE IF NOT EXISTS url (
	id SERIAL PRIMARY KEY,
	url VARCHAR(255) NOT NULL DEFAULT '',
	hash varchar(10) NOT NULL DEFAULT '',
	created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
	expired_at TIMESTAMP WITH TIME ZONE,
	owner_id VARCHAR(36) NOT NULL DEFAULT ''
);

CREATE UNIQUE INDEX idx_url_hash ON url(hash);

CREATE TABLE IF NOT EXISTS url_view (
	id SERIAL PRIMARY KEY,
	referer VARCHAR(255) NOT NULL DEFAULT '',
	url_id INT NOT NULL,
	CONSTRAINT fk_url_view FOREIGN KEY(url_id) REFERENCES url(id)
);
```

## Creating Ory Cloud project

You can follow the official [documentation](https://www.ory.sh/docs/guides/console/create-project) to create your project

## Installing Ory CLI

You can follow the official [documentation](https://www.ory.sh/docs/guides/cli/installation) to install ory CLI

## Running the backend

Running ory proxy
```
   export ORY_SDK_URL=https://projectid.projects.oryapis.com
   ory proxy http://127.0.0.1:8090
```

Running the backend

```
   export SUPABASE_KEY=... # Please add your key
   export SUPABASE_URL=... # Please add your url
   export KRATOS_API_URL=http://127.0.0.1:4000/.ory
   export KRATOS_URL=http://127.0.0.1:4000/.ory/ui
   go run cmd/shorts/main.go
```

## Running the frontend

```
   cd client
   npm i
   export KRATOS_API_URL=http://127.0.0.1:4000/.ory
   export KRATOS_URL=http://127.0.0.1:4000/.ory/ui
   export API_URL=http://127.0.0.1:4000
   npm run dev
```


