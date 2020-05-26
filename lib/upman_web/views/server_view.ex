defmodule UpmanWeb.ServerView do
  use UpmanWeb, :view
  import Upman.Session
  import Upman.Result

  def data_present(server, name) do
    data = Upman.Data.server(server)
    data[name] != nil && data[name] != []
  end

  def result_present(server) do
    result = Upman.Result.result(server)
    result != nil
  end

  def linkserver(name) do
    target =
      cond do
        data_present(name, "updates") -> "#updates"
        result_present(name) -> "#result"
        data_present(name, "locked") -> "#locked"
        data_present(name, "os") -> "#osrelease"
        data_present(name, "customfacts") -> "#customfacts"
        true -> ""
      end

    link(name, to: Routes.server_path(UpmanWeb.Endpoint, :show, name) <> target, id: name)
  end

  def timetag(time) do
    minutes_ago = Integer.to_string(div(DateTime.diff(DateTime.utc_now(), time), 60)) <> "m ago"
    timestr = DateTime.to_string(time)
    content_tag(:time, minutes_ago, datetime: timestr, title: timestr)
  end

  def reboot_authorized(server) do
    Upman.Clearance.clearance(server)
    |> Map.get("reboot", false)
  end

  def update_authorized(server) do
    Upman.Clearance.clearance(server)
    |> Map.get("update", false)
  end

  def upman_locked(server) do
    Upman.Clearance.clearance(server)
    |> Map.get("upman_locked", false)
  end

  def update_result(server) do
    result(server)
  end
end
