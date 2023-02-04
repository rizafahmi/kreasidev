defmodule KreasidevWeb.PostView do
  use KreasidevWeb, :view

  def get_user_info(userid) do
    user = Kreasidev.Accounts.get_user!(userid)
    String.split(user.email, "@") |> hd
  end
end
