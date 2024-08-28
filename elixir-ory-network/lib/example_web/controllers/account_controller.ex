defmodule ExampleWeb.AccountController do
  use ExampleWeb, :controller

  import ExampleWeb.Helpers, only: [cookies: 1]

  alias Ory.Api.Frontend

  @doc """
  Verify page from flow parameters with optional code pre-filling
  """

  def verify(conn, %{"flow" => flow, "code" => code}) do
    case Frontend.get_verification_flow(Ory.Connection.new(), flow, cookie: cookies(conn)) do
      {:ok, %Ory.Model.VerificationFlow{} = flow} ->
        render(conn, :verify, flow: flow)

      {:ok, %Ory.Model.ErrorGeneric{} = error} ->
        IO.inspect(error)
        render(conn, :verify, flow: nil)

      _ ->
        IO.puts("oops")
    end
  end

  def verify(conn, %{"flow" => id}) do
    case Frontend.get_verification_flow(Ory.Connection.new(), id, cookie: cookies(conn)) do
      {:ok, %Ory.Model.VerificationFlow{} = flow} ->
        render(conn, :verify, flow: flow)

      {:ok, %Ory.Model.ErrorGeneric{}} ->
        render(conn, :verify, flow: nil)

      _ ->
        IO.puts("oops")
    end
  end

  def verify(%{assigns: %{session: session}} = conn, %{return_to: return_to}) do
    IO.inspect(session)

    {:ok, %{url: url}} =
      Frontend.create_browser_verification_flow(Ory.Connection.new(), return_to: return_to)

    redirect(conn, external: url)
  end

  def verify(%{assigns: %{session: session}} = conn, _params) do
    IO.inspect(session)

    # TODO(@tobbbles): Check for verified session(s)

    {:ok, %{url: url}} = Frontend.create_browser_verification_flow(Ory.Connection.new())
    redirect(conn, external: url)
  end

  # Redirect on no-session
  def verify(conn, _params) do
    redirect(conn, to: ~p"/account/settings")
  end

  @doc """
    Settings controller
  """

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
