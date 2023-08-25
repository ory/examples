defmodule ExampleWeb.Router do
  use ExampleWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, html: {ExampleWeb.Layouts, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)

    plug(ExampleWeb.Authentication)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", ExampleWeb do
    pipe_through(:browser)

    get("/", PageController, :home)
  end

  scope "/auth", ExampleWeb do
    pipe_through(:browser)

    get "/login", AuthController, :login
    get "/register", AuthController, :registration
  end

  scope "/account", ExampleWeb do
    pipe_through [:browser]

    get "/settings", AccountController, :settings
  end

  # Other scopes may use custom stacks.
  # scope "/api", ExampleWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard in development
  if Application.compile_env(:example, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through(:browser)

      live_dashboard("/dashboard", metrics: ExampleWeb.Telemetry)
    end
  end
end
