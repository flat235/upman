defmodule UpmanWeb.ServerController do
  use UpmanWeb, :controller
  #plug Guardian.Plug.EnsureAuthenticated

  def index(conn, _params) do
    render conn, "index.html", servers: Upman.Data.servers(), token: get_csrf_token()
  end

  def show(conn, %{"id" => server}) do
    render conn, "show.html", server: Upman.Data.server(server)
  end
end
