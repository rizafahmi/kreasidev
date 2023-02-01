defmodule KreasidevWeb.PageView do
  use KreasidevWeb, :view

  def truncate_username(email) do
    String.split(email, "@") |> hd
  end
end
