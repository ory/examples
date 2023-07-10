defmodule ExampleWeb.Authentication do
  use ExampleWeb, :controller

  import ExampleWeb.Helpers, only: [cookies: 1]

  alias Ory.Api.Frontend

  def init(opts), do: []

  def call(conn, opts) do
    # TODO(@tobbbles): Look at expiration and optionally refresh the session
    if Map.has_key?(conn.assigns, :session) do
      conn
    else
      case Frontend.to_session(Ory.Connection.new(), Cookie: cookies(conn)) do
        {:ok, %Ory.Model.Session{} = session} ->
          assign(conn, :session, session)

        _ ->
          assign(conn, :session, nil)
      end
    end
  end

  def has_session(conn, opts) do
    if conn.assigns[:session] do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in")
      |> redirect(to: ~p"/auth/login")
      |> halt()
    end
  end

  @doc """
  Ensures a user's session identity has all emails verified, redirects to verification if not.
  """
  def is_verified(%{assigns: %{session: session}} = conn, opts) do
    IO.puts("checking if user is verified")

    has_unverified =
      session.identity.verifiable_addresses
      |> Enum.filter(&unverified_address/1)
      |> Enum.any?()

    if has_unverified do
      conn |> redirect(to: ~p"/account/verify") |> halt()
    else
      conn
    end

    conn
  end

  @spec unverified_address(Ory.Model.VerifiableIdentityAddress.t()) :: boolean()
  defp unverified_address(address) do
    !address.verified
  end
end
