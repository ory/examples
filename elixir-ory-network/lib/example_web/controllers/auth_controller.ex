defmodule ExampleWeb.AuthController do
  use ExampleWeb, :controller
  use Phoenix.VerifiedRoutes, endpoint: ExampleWeb.Endpoint, router: ExampleWeb.Router

  import ExampleWeb.Helpers, only: [cookies: 1]

  alias Ory.Api.Frontend

  @doc """
  Login pages with pattern-matched parameters to capture flow IDs and return_to parameters
  """
  def login(conn, %{"flow" => id}) do
    case Frontend.get_login_flow(Ory.Connection.new(), id, Cookie: cookies(conn)) do
      {:ok, flow} ->
        IO.inspect(flow)
        render(conn, :login, flow: flow)

      {:ok, %Ory.Model.ErrorGeneric{error: error}} = wrapper ->
        IO.puts("errorno flow flow")
        render(conn, :login, flow: nil, error: error.message)

      {:error, reason} ->
        IO.inspect(reason)
    end
  end

  def login(conn, %{"return_to" => return_to}) do
    {:ok, %{url: url}} =
      Frontend.create_browser_login_flow(Ory.Connection.new(),
        Cookie: cookies(conn),
        return_to: return_to
      )

    redirect(conn, external: url)
  end

  def login(conn, _params) do
    case result = Frontend.create_browser_login_flow(Ory.Connection.new(), Cookie: cookies(conn), aal: "aal1") do
      {:ok, %{url: url}} ->
        IO.puts("redirecting to #{url}")
        redirect(conn, external: url)

      {:ok, %Ory.Model.GenericError{} = error} ->
        IO.inspect(error)
        conn
        |> put_flash(:error, "An error occurred during login")
        |> render(:login, flow: nil)

      {:err, reason} ->
          IO.inspect(reason)
          conn
          |> put_flash(:error, "An error occurred during login")
          |> render(:login, flow: nil)

      _ ->
        IO.puts("oops")
        conn |> render(:login, flow: %{})
    end
  end

  @doc """
  Registration pages with pattern-matched parameters to capture flow IDs and return_to parameters
  """
  def registration(conn, %{"flow" => id}) do
    case Frontend.get_registration_flow(Ory.Connection.new(), id, Cookie: cookies(conn)) do
      {:ok, flow} -> render(conn, :registration, flow: flow)
      {:error, reason} -> IO.inspect(reason)
    end
  end

  def registration(conn, %{"return_to" => return_to}) do
    {:ok, %{url: url}} =
      Frontend.create_browser_registration_flow(Ory.Connection.new(), return_to: return_to)

    redirect(conn, external: url)
  end

  def registration(conn, params) do
    {:ok, %{url: url}} =
      Frontend.create_browser_registration_flow(Ory.Connection.new(),
        return_to: url(conn, ~p"/auth/register")
      )

    redirect(conn, external: url)
  end
end
