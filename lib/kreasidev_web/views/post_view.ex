defmodule KreasidevWeb.PostView do
  use KreasidevWeb, :view

  def get_user_info(userid) do
    user = Kreasidev.Repo.get!(Kreasidev.Users.User, userid)
    String.split(user.email, "@") |> hd
  end

  def calc_time(time) do
    Kreasidev.Timeutil.calc_time(time)
  end
end
