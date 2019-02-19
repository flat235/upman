defmodule UpmanWeb.SessionController do
  use UpmanWeb, :controller

  def new(conn, _params) do
    render(conn, "login.html", token: get_csrf_token())
  end

  def create(conn, %{"username" => username, "password" => password}) do
    if auth(username, password) do
      conn
      |> put_session(:logged_in, true)
      |> put_session(:user, username)
      |> put_flash(:info, "Access granted")
      |> redirect(to: Routes.server_path(conn, :index))
    else
      conn |> put_flash(:error, "Access Denied") |> redirect(to: Routes.session_path(conn, :new))
    end
  end

  def auth(username, password) do
    with {:ok, ldap} <- Exldap.open(),
         {:ok, [entry]} <-
           Exldap.search_field(ldap, Application.fetch_env!(:exldap, :userAttr), username),
         dn <- entry.object_name do
      try do
        :ok = Exldap.verify_credentials(ldap, dn, password)

        Exldap.search_field(
          ldap,
          Application.fetch_env!(:exldap, :groupAttr),
          Application.fetch_env!(:exldap, :group)
        )
        |> elem(1)
        |> List.first()
        |> Exldap.get_attribute!(Application.fetch_env!(:exldap, :memberAttr))
        |> Enum.member?(username)
      rescue
        _ -> false
      end
    else
      _ -> {:error, "authentication failed"}
    end
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:logged_in)
    |> delete_session(:user)
    |> put_flash(:info, "logged out")
    |> redirect(to: Routes.server_path(conn, :index))
  end
end
