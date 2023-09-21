defmodule UasWeb.UserLoginLive do
  use UasWeb, :live_view

  def render(assigns) do
    ~H"""
    <style>
    input[type = "loginmethod"] {
      width: 100%;
      padding: 10px;
      border: 1px solid #ccc;
      border-radius: .5rem;
      margin-bottom: 5px;
    }
    </style>
    <div class="mx-auto max-w-sm">
      <.header class="text-center">
        Sign in to account
        <:subtitle>
          Don't have an account?
          <.link navigate={~p"/users/register"} class="font-semibold text-brand hover:underline">
            Sign up
          </.link>
          for an account now.
        </:subtitle>
      </.header>

      <.simple_form for={@form} id="login_form" action={~p"/users/log_in"} phx-update="ignore">
        <.input field={@form[:loginmethod]} type="loginmethod" label="Username or Email" required />
        <.input field={@form[:password]} type="password" label="Password" required />

        <:actions>
          <.input field={@form[:remember_me]} type="checkbox" label="Keep me logged in" />
          <.link href={~p"/users/reset_password"} class="text-sm font-semibold">
            Forgot your password?
          </.link>
        </:actions>
        <:actions>
          <.button phx-disable-with="Signing in..." class="w-full">
            Sign in <span aria-hidden="true">→</span>
          </.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    loginmethod = live_flash(socket.assigns.flash, :loginmethod)
    form = to_form(%{"loginmethod" => loginmethod}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: form]}
  end
end
