defmodule UpmanWeb.ServerView do
  use UpmanWeb, :view
  import Upman.Session

  def data_present(server, name) do
    data = Upman.Data.server(server)
    data[name] != nil && data[name] != []
  end

  def linkserver(name) do
    target = cond do
      data_present(name, "updates") -> "#updates"
      data_present(name, "locked") -> "#locked"
      data_present(name, "os") -> "#osrelease"
      data_present(name, "customfacts") -> "#customfacts"
      true -> ""
    end
    link name, to: "/servers/" <> name <> target
  end

  def timetag(time) do
    minutes_ago = Integer.to_string(div(DateTime.diff(DateTime.utc_now(), time), 60)) <> "m ago"
    timestr = DateTime.to_string(time)
    content_tag :time, minutes_ago, [datetime: timestr, title: timestr]
  end

  def reboot_authorized(server) do
    Upman.Clearance.clearance(server)
    |> Map.get("reboot", false)
  end

  def update_authorized(server) do
    Upman.Clearance.clearance(server)
    |> Map.get("update", false)
  end
end
