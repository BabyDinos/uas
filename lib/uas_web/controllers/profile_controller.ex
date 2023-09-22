defmodule UasWeb.ProfileController do
  use UasWeb, :controller
  alias Uas.Accounts

  def profile(conn, params) do
    username_in_database = Accounts.username_exists(params["username"])
    username = params["username"]
    render(conn, :profile, layout: false, username_in_database: username_in_database, username: username)
  end

end
