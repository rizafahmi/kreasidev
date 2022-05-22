defmodule KreasidevWeb.PageController do
  use KreasidevWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
