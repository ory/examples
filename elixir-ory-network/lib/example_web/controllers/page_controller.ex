defmodule ExampleWeb.PageController do
  use ExampleWeb, :controller

  import ExampleWeb.Helpers, only: [cookies: 1]

  alias Ory.Api.Frontend

  def home(%{assigns: %{session: session}} = conn, _params) when not is_nil(session) do
    # When the user has a session, let's generate a logout url for home.

    {:ok, %Ory.Model.LogoutFlow{logout_url: logout_url}} =
      Frontend.create_browser_logout_flow(Ory.Connection.new(), cookie: cookies(conn))

    render(conn, :home, layout: false, logout_url: logout_url)
  end

  def home(conn, params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end
end
