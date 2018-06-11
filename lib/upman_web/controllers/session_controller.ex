defmodule UpmanWeb.SessionController do
  use UpmanWeb, :controller

  def new(conn, _params) do
    render conn, "login.html", token: get_csrf_token()
  end

  def create(conn, %{"username" => username, "password" => password}) do
    case auth(username, password) do
      :ok -> conn |> put_session(:logged_in, :true) |> put_session(:user, username) |> put_flash(:info, "Access granted") |> redirect(to: server_path(conn, :index))
      _ -> conn |> put_flash(:error, "Access Denied") |> redirect(to: session_path(conn, :new))
    end
  end

  def auth(username, password) do
    with  {:ok, ldap} <- Exldap.open,
          {:ok, [entry]} <- Exldap.search_field(ldap, "ou=users,dc=hoou,dc=ovh", "uid", username),
          dn <- entry.object_name
    do
      Exldap.verify_credentials(ldap, dn, password)
    else
      _ -> {:error, "authentication failed"}
    end

  end

  def delete(conn, _params) do
    conn
    |> delete_session(:logged_in)
    |> delete_session(:user)
    |> put_flash(:info, "logged out")
    |> redirect(to: server_path(conn, :index))
  end
end
