defmodule HexagonWeb.LayoutView do
  use HexagonWeb, :view

  # Phoenix LiveDashboard is available only in development by default,
  # so we instruct Elixir to not warn if the dashboard route is missing.
  @compile {:no_warn_undefined, {Routes, :live_dashboard_path, 2}}

  @gravatar_domain "gravatar.com"

  @doc """
  Generates a gravatar url for a user's email address.
  """
  def gravatar(user, opts \\ []) do
    {secure, opts} =
      opts
      |> Keyword.merge(default: :retro, rating: :x)
      |> Keyword.pop(:secure, true)

    %URI{}
    |> gravatar_host(secure)
    |> gravatar_hash_email(user.email)
    |> gravatar_options(opts)
    |> to_string
  end

  defp gravatar_options(uri, []), do: %URI{uri | query: nil}
  defp gravatar_options(uri, opts), do: %URI{uri | query: URI.encode_query(opts)}

  defp gravatar_host(uri, true),
    do: %URI{uri | scheme: "https", host: "secure.#{@gravatar_domain}"}

  defp gravatar_host(uri, false), do: %URI{uri | scheme: "http", host: @gravatar_domain}

  defp gravatar_hash_email(uri, email) do
    hash = :crypto.hash(:md5, String.downcase(email)) |> Base.encode16(case: :lower)
    %URI{uri | path: "/avatar/#{hash}"}
  end
end
