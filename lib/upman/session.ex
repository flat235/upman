defmodule Upman.Session do
  @spec logged_in(Plug.Conn.t()) :: boolean()
  def logged_in(conn) do
    !!Plug.Conn.get_session(conn, :logged_in)
  end

  def user(conn) do
    Plug.Conn.get_session(conn, :user)
  end
end
