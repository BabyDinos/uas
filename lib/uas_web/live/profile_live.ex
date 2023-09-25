defmodule UasWeb.ProfileLive do
  use UasWeb, :live_view
  alias Uas.Accounts

  def render(assigns) do
    ~H"""
    <.flash_group flash={@flash} />
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <style>
        body {
            /* background-image: url("/images/snorlax.jpg"); */
            background-size: cover;
            background-position: center center;
            background-repeat: no-repeat;
        }
        h1.page-title {
            min-height: 100vh;
            display: flex;
            justify-content: center;
            color: black;
            font-size: xx-large;
            text-align: center;
        }
        </style>
    </head>

    <body>
      <%= if @username_in_database do %>
        <h1 class="page-title"><%= @username %> </h1>
      <% else %>
        <h1 class="page-title">ERROR: <%= @username %> not found!</h1>
      <% end %>
    </body>

    </html>

    """

end

  def mount(%{"username" => username}, _session, socket) do
    user = Accounts.get_user_by_username(username)
    user_profile = Accounts.get_user_profile_by_user_id(user.id)
    bio = user_profile.bio
    username = user.username

    socket =
      socket
      |> assign(username: username)
      |> assign(:username_in_database, user != nil)
      |> assign(:bio, bio)
    {:ok, socket}
  end

end
