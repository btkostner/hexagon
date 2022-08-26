defmodule Hexagon.Extensions.Plug.LocalStore do
  @moduledoc """
  An easy local store.

  It serves files at `http://localhost:4002` and stores
  them at `priv/data/packages` (both configurable). This is
  an easy implementation for development or a simple
  production deployment.
  """

  use Plug.Router

  @enabled? Application.compile_env(:hexagon, :package_store)[:module] ==
              Hexagon.Packages.Store.Local
  @directory Application.compile_env(:hexagon, :package_store)[:directory]
  @port Application.compile_env(:hexagon, :packages_store)[:port]

  def child_spec(_) do
    if @enabled? do
      Plug.Cowboy.child_spec(scheme: :http, plug: __MODULE__, port: @port)
    else
      %{id: __MODULE__, start: {Function, :identity, [:ignore]}}
    end
  end

  def enabled?, do: @enabled?
  def directory, do: @directory
  def port, do: @port
  def base_url, do: "http://localhost:#{@port}/"

  plug(Plug.Static, at: "/", from: @directory)
  plug(:match)
  plug(:dispatch)

  put "*path" do
    path = Path.join([@directory | path])

    if path =~ "error" do
      raise "triggered store error"
    else
      File.mkdir_p!(Path.dirname(path))
      pid = File.open!(path, [:write])
      {:ok, conn} = with_req_body(conn, fn {:data, data} -> IO.binwrite(pid, data) end)
      :ok = File.close(pid)
      send_resp(conn, 200, "ok")
    end
  end

  delete "*path" do
    File.rm!(Path.join([@directory | path]))
    send_resp(conn, 200, "ok")
  end

  match _ do
    send_resp(conn, 404, "not found")
  end

  defp with_req_body(conn, fun) do
    case Plug.Conn.read_body(conn) do
      {:more, partial, conn} ->
        fun.({:data, partial})
        read_body(conn, fun)

      {:ok, body, conn} ->
        fun.({:data, body})
        {:ok, conn}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
