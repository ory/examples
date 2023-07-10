defmodule ExampleWeb.Helpers do

  @doc """
  Helper function to format request cookie map into string
  """
  def cookies(conn) do
    conn.req_cookies
    |> Enum.reduce("", fn {k, v}, acc -> "#{k}=#{v};#{acc}" end)
  end
end
