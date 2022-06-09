defmodule KreasidevWeb.PageController do
  use KreasidevWeb, :controller

  def index(conn, _params) do
    posts = Kreasidev.Entries.list_posts()
    posts = Kreasidev.Repo.preload(posts, :comments)
    render(conn, "index.html", posts: posts)
  end

  def process(conn, %{"number" => number}) do
    result = calculate_sum(String.to_integer(number))
    text(conn, "Result: #{result}")
  end

  defp calculate_sum(n), do: calculate_sum(1, n, 0)
  defp calculate_sum(from, from, sum), do: sum + from
  defp calculate_sum(from, to, acc), do: calculate_sum(from + 1, to, acc + from)
end
