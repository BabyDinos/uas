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
        h1 {
          text-align: center;
          padding: 0px;
          font: larger;
          font-size: 36px;
        }
        .centered-container {
          display: flex;
          flex-direction: column;
          justify-content: center; /* Center horizontally */
          align-items: center; /* Center vertically */
          min-height: 10vh; /* Set height to viewport height for vertical centering */
          margin: 0;
        }

        .search-container, .result-container {
          display: flex;
          flex-direction: column; /* Stack containers vertically */
          align-items: flex-start; /* Center content horizontally */
          max-width: 1000px;
          width: 100%;
          margin-bottom: 10px; /* Adjust the margin as needed for spacing between containers */
        }

        p {
          padding-left: 30px;
        }
        #search_form {
          width: 100%; /* Set the width to fill the available space */
          padding: 10px; /* Add padding */
          font-size: 16px; /* Set font size */
        }
        </style>
    </head>

    <body>
    <h1>Profile Searcher</h1>
      <div class="centered-container">
        <div class="search-container">
          <.simple_form
            for={@search_form}
            id="search_form"
            phx-change="validate_search"
          >
            <.input field={@search_form[:search_query]} type="search" label="Search" placeholder = "Search..." required />
          </.simple_form>
        </div>
        <div class = "result-container">
          <%= for profile <- @search_result do %>
            <div>
              <!-- Render profile data here -->
              <p>Name: <%= profile.username %></p>
              <p>Email: <%= profile.email %></p>
              <!-- Add more profile fields as needed -->
            </div>
          <% end %>
        </div>
      </div>

    </body>

    </html>
    """
  end

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(search_query: nil)
      |> assign(search_form: to_form%{})
      |> assign(search_result: [])
    {:ok, socket}
  end

  def handle_event("validate_search", params, socket) do
    IO.inspect(params, label: "Params")
    %{"search_query" => search_query} = params

    search_result = Accounts.get_users(search_query)

    {:noreply, assign(socket, search_result: search_result)}
  end
end
