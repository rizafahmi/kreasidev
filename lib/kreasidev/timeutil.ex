defmodule Kreasidev.Timeutil do
  def from_date(from, to \\ DateTime.utc_now()) do
    %{days: days, hours: hours, minutes: minutes, seconds: seconds} = calc_diff(from, to)

    cond do
      days > 7 -> {:date, from}
      days > 0 -> {:days, days}
      hours > 0 -> {:hours, hours}
      minutes > 0 -> {:minutes, minutes}
      seconds > 0 -> {:seconds, seconds}
      true -> {:seconds, 0}
    end
  end

  defp calc_diff(from, to) do
    diff_days = to.day - from.day
    diff_hours = to.hour - from.hour
    diff_minutes = to.minute - from.minute
    diff_seconds = to.second - from.second

    %{days: diff_days, hours: diff_hours, minutes: diff_minutes, seconds: diff_seconds}
  end

  def calc_time(time) do
    case Kreasidev.Timeutil.from_date(time) do
      {:days, day} -> "#{day} hari yang lalu."
      {:hours, hour} -> "#{hour} jam yang lalu."
      {:minutes, minute} -> "#{minute} menit yang lalu."
      {:seconds, 0} -> "Baru saja."
      {:seconds, second} -> "#{second} detik yang lalu."
      _ -> "Baru saja"
    end
  end
end
