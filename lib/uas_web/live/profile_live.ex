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
          background-color: @background_color;
        }
        h1.page-title {
            display: flex;
            justify-content: center;
            color: black;
            font-size: xx-large;
            text-align: center;
        }
        .bio-view {
          min-height: 100vh;
          display: flex;
          justify-content: center;
          color: black;
          font-size: xx-large;
          text-align: center;
          margin-bottom: 50px;
          padding: 20px;
        }
        input[type="bio-input"] {
          font-size: 40px; /* Adjust the font size as needed */
          text-align: center;
        }
        </style>
    </head>

    <body>
      <%= if @edit == true do %>

        <%= if @username_in_database do %>
          <h1 class="page-title"><%= @username %> </h1>
          <.simple_form
            for={@bio_form}
            id="bio_form"
            phx-submit="update_bio"
            style="display: flex; justify-content: center; align-items: center;"
            >
          <.input field={@bio_form[:bio]} type="bio-input" placeholder = {@bio} class = "bio-input"  required />
          <:actions>
            <.button style = "text-align: center; justify-content: center; width: 100%;" phx-disable-with="Changing...">Confirm Changes</.button>
          </:actions>

          </.simple_form>
        <% else %>
          <h1 class="page-title">ERROR: <%= @username %> not found!</h1>
        <% end %>
      <% else %>
        <%= if @username_in_database do %>
            <h1 class="page-title"><%= @username %> </h1>
            <h2 class="bio-view"> <%= @bio %> </h2>
          <% else %>
            <h1 class="page-title">ERROR: <%= @username %> not found!</h1>
          <% end %>
      <% end %>
    </body>

    </html>

    """

end

  def mount(%{"username" => username, "_action" => "edit"}, _session, socket) do
    current_user = socket.assigns.current_user
    user = Accounts.get_user_by_username(username)

    edit_allowed = current_user.id == user.id

    if !edit_allowed do
      # Flash message indicating that editing is not allowed
      socket = socket |> put_flash(:error, "You do not have permission to edit this profile.")
      # Redirect to the :username endpoint
      {:ok, push_navigate(socket, to: ~p"/profiles/#{user.username}")}
    else
      user_profile = Accounts.get_user_profile_by_user_id(user.id)
      bio = user_profile.bio
      background_color = user_profile.background_color
      bio_form = to_form(%{:bio => bio})
      socket =
        socket
        |> put_flash(:info, "You are now in edit mode")
        |> assign(bio_form: bio_form)
        |> assign(username: username)
        |> assign(:username_in_database, user != nil)
        |> assign(:bio, bio)
        |> assign(:background_color, background_color)
        |> assign(:edit, edit_allowed)
      {:ok, socket, temporary_assigns: [bio_form: bio_form]}
    end

  end

  def mount(%{"username" => username}, _session, socket) do
    user = Accounts.get_user_by_username(username)
    user_profile = Accounts.get_user_profile_by_user_id(user.id)
    bio = user_profile.bio
    background_color = user_profile.background_color
    username = user.username

    socket =
      socket
      |> assign(username: username)
      |> assign(:username_in_database, user != nil)
      |> assign(:bio, bio)
      |> assign(:background_color, background_color)
      |> assign(:edit, false)
    {:ok, socket}
  end

  def handle_event("update_bio", params, socket) do
    # %{"bio" => bio} = params
    user_profile = Accounts.get_user_profile_by_user_id(socket.assigns.current_user.id)

    case Accounts.update_bio(user_profile, params) do
      {:ok, user_profile} ->
        bio_form =
          user_profile
          |> Accounts.change_bio(params)
          |> to_form()
          socket =
            socket
            |> assign(trigger_submit: true)
            |> assign(bio_form: bio_form)
            |> put_flash(:info, "You have made a change to your profile")
        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, bio_form: to_form(changeset))}
    end
  end

end
