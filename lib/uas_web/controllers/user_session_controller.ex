defmodule UasWeb.UserSessionController do
  use UasWeb, :controller

  alias Uas.Accounts
  alias UasWeb.UserAuth

  def login(conn, %{"_action" => "registered"} = params) do
    create(conn, params, "Account created successfully!")
  end

  def login(conn, %{"_action" => "password_updated"} = params) do
    conn
    |> put_session(:user_return_to, ~p"/users/settings")
    |> create(params, "Password updated successfully!")
  end

  def login(conn, params) do
    login(conn, params, "Welcome back!")
  end

  defp login(conn, %{"user" => user_params}, info) do
    %{"loginmethod" => loginmethod, "password" => password} = user_params
    cond do
      user = Accounts.get_user_by_email_and_password(loginmethod, password) ->
        conn
        |> put_flash(:info, info)
        |> UserAuth.log_in_user(user, user_params)
      user = Accounts.get_user_by_username_and_password(loginmethod, password) ->
        conn
        |> put_flash(:info, info)
        |> UserAuth.log_in_user(user, user_params)
      true ->
        # In order to prevent user enumeration attacks, don't disclose whether the email is registered.
        conn
        |> put_flash(:error, "Invalid username/email or password")
        |> redirect(to: ~p"/users/log_in")
    end
  end

  defp create(conn, %{"user" => user_params}, info) do
    %{"email" => email, "username" => username, "password" => password} = user_params

    cond do
      user = Accounts.get_user_by_email_and_password(email, password) ->
        conn
        |> put_flash(:info, info)
        |> UserAuth.log_in_user(user, user_params)
      user = Accounts.get_user_by_username_and_password(username, password) ->
        conn
        |> put_flash(:info, info)
        |> UserAuth.log_in_user(user, user_params)
      true ->
        # In order to prevent user enumeration attacks, don't disclose whether the email is registered.
        conn
        |> put_flash(:error, "Invalid username/email or password")
        |> redirect(to: ~p"/users/log_in")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.log_out_user()
  end
end
