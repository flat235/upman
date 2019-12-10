defmodule UpmanWeb.ResultController do
  use UpmanWeb, :controller

  def show(conn, %{"server" => server} = _params) do
    json(conn, Upman.Result.result(server))
  end

  def update(conn, %{"server" => server}= params) do
    json(conn, Upman.Result.upsert(server, params))
  end
end
