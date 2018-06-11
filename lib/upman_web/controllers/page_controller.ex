defmodule UpmanWeb.PageController do
  use UpmanWeb, :controller

  def index(conn, _params) do
    redirect conn, to: "/servers"
  end
end
