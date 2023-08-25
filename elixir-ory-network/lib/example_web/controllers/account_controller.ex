defmodule ExampleWeb.AccountController do
  use ExampleWeb, :controller

  import ExampleWeb.Helpers, only: [cookies: 1]

  alias Ory.Api.Frontend

  def settings(conn, %{"flow" => id}) do
    {:ok, %Ory.Model.LogoutFlow{logout_url: logout_url}} =
      Frontend.create_browser_logout_flow(Ory.Connection.new(), cookie: cookies(conn))

    {:ok, settings_flow} =
      Frontend.get_settings_flow(Ory.Connection.new(), id, Cookie: cookies(conn))

    IO.inspect(settings_flow)
    render(conn, :settings, flow: settings_flow, logout_url: logout_url)
  end

  def settings(conn, _params) do
    {:ok, %{url: url} = settings_flow} =
      Frontend.create_browser_settings_flow(Ory.Connection.new(), Cookie: cookies(conn))

    redirect(conn, external: url)
  end
end
