defmodule UpmanWeb.ClearanceController do
  use UpmanWeb, :controller
  import Upman.Session

  def set(conn, %{"name" => server} = params) do
    if logged_in(conn) do
      if params["forget"] == "true" do
        Upman.Clearance.forget(server)
        Upman.Data.forget(server)
        conn
        |> put_flash(:info, "forgot " <> server)
        |> redirect(to: Routes.server_path(conn, :index))
      else
        data = Map.drop(params, ["_utf8", "_csrf_token"])
        Upman.Clearance.upsert(server, data)

        conn
        |> put_flash(:info, "clearance set")
        |> redirect(to: Routes.server_path(conn, :index) <> "#" <> server)
      end
    else
      conn
      |> put_flash(:error, "Access Denied")
      |> redirect(to: Routes.server_path(conn, :index) <> "#" <> server)
    end
  end

  def panic(conn, _params) do
    if logged_in(conn) do
      res = Upman.Clearance.panic()
      if res == :ok do
        conn
        |> put_flash(:info, "all clearances deleted")
        |> redirect(to: Routes.server_path(conn, :index))
      else
        conn
        |> put_flash(:error, "could not delete clearances")
        |> redirect(to: Routes.server_path(conn, :index))
      end
    else
      conn
      |> put_flash(:error, "not logged in")
      |> redirect(to: Routes.server_path(conn, :index))
    end
  end
end
