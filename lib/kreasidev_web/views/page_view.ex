defmodule KreasidevWeb.PageView do
  use KreasidevWeb, :view

  def truncate_username(email) do
    String.split(email, "@") |> hd
  end

  def calc_time(time) do
    Kreasidev.Timeutil.calc_time(time)
  end
end
