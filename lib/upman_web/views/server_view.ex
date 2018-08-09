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
    timestr = DateTime.to_string(time)
    human_time = (timestr |> String.split(":") |> Enum.take(2) |> Enum.join(":")) <> " UTC"
    content_tag :time, human_time, datetime: timestr
  end
end
