# Example using Ory Cloud and Supabase

## Develop

### Prerequisites

- Free [Ory Cloud Account](https://console.ory.sh/registration) 
- Free [Supabase Account](https://app.supabase.com/)
- [Ory CLI](https://www.ory.sh/docs/guides/cli/installation)

#### Create database & tables

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

### Run locally

#### Backend

Running ory proxy

```bash
   export ORY_SDK_URL=https://projectid.projects.oryapis.com
   ory proxy http://127.0.0.1:8090
```

Running the backend

```bash
   export SUPABASE_KEY=... # Please add your key
   export SUPABASE_URL=... # Please add your url
   export KRATOS_API_URL=http://127.0.0.1:4000/.ory
   export KRATOS_URL=http://127.0.0.1:4000/.ory/ui
   go run cmd/shorts/main.go
```

#### Frontend

```bash
   cd client
   npm i
   export KRATOS_API_URL=http://127.0.0.1:4000/.ory
   export KRATOS_URL=http://127.0.0.1:4000/.ory/ui
   export API_URL=http://127.0.0.1:4000
   npm run dev
```

## Contribute

Feel free to [open a discussion](https://github.com/ory/examples/discussions/new) to provide feedback or talk about ideas, or [open an issue](https://github.com/ory/examples/issues/new) if you want to add your example to the repository or encounter a bug.
You can contribute to Ory in many ways, see the [Ory Contributing Guidelines](https://www.ory.sh/docs/ecosystem/contributing) for more information.