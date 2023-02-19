defmodule KreasidevWeb.Pow.Messages do
  use Pow.Phoenix.Messages
  use Pow.Extension.Phoenix.Messages, extensions: [PowAssent]

  import KreasidevWeb.Gettext

  def pow_assent_signed_in(_conn) do
    "Selamat datang"
  end
end
