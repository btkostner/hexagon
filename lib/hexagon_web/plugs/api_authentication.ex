defmodule HexagonWeb.ApiAuthenticationPlug do
  @moduledoc """
  Attempts to authenticate via a `Hexagon.Authentication.Key` token in the header.
  """

  import Plug.Conn

  alias Hexagon.Authentication

  @behaviour Plug

  @impl true
  def init(opts), do: opts

  @impl true
  def call(conn, _opts) do
    token =
      case get_req_header(conn, "authorization") do
        [token | _] -> token
        [] -> nil
      end

    if key = Authentication.get_key(token) do
      conn
      |> assign(:current_key, key)
      |> assign(:current_user, key.user)
    else
      conn
      |> send_resp(401, "Unauthenticated")
      |> halt()
    end
  end
end
