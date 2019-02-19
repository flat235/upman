defmodule UpmanWeb.ClearanceController do
  use UpmanWeb, :controller
  import Upman.Session

  def set(conn, %{"name" => server} = params) do
    if logged_in(conn) do
      data = Map.drop(params, ["_utf8", "_csrf_token"])
      Upman.Clearance.upsert(server, data)

      conn
      |> put_flash(:info, "clearance set")
      |> redirect(to: server_path(conn, :index) <> "#" <> server)
    else
      conn
      |> put_flash(:error, "Access Denied")
      |> redirect(to: server_path(conn, :index) <> "#" <> server)
    end
  end
end
