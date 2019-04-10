defmodule UpmanWeb.ApiController do
  use UpmanWeb, :controller

  def update(conn, %{"name" => server} = params) do
    json(conn, Upman.Data.upsert(server, params))
  end

  def show(conn, %{"name" => server}) do
    json(conn, Upman.Data.server(server))
  end

  def index(conn, _params) do
    json(conn, Upman.Data.servers())
  end

  def clearance(conn, %{"name" => server}) do
    json(conn, Upman.Clearance.clearance(server))
  end
end
