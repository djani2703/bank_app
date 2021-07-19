defmodule BankAppWeb.Router do
  use BankAppWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BankAppWeb do
    pipe_through :browser

    get "/", PageController, :index

    get "/users", UserController, :index
    get "/users/new", UserController, :new
    get "/users/:id/upd_status", UserController, :new_status?
    get "/users/:id/balance_up", UserController, :balance_up
    get "/users/:id/balance_down", UserController, :balance_down
    get "/users/:id", UserController, :show
    post "/users", UserController, :create?

    put "/users/:id", UserController, :change_status
    put "/users/:id/change_user", UserController, :change_user
    put "/users/:id/up_balance", UserController, :change_balance

    get "/transactions", TransactionController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", BankAppWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: BankAppWeb.Telemetry
    end
  end
end
