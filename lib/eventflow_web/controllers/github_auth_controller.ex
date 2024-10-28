defmodule EventflowWeb.GithubAuthController do
  use EventflowWeb, :controller
  alias EventflowWeb.GithubAuth

  def request(conn, _params) do
    GithubAuth.request(conn)
  end

  def callback(conn, _params) do
    GithubAuth.callback(conn)
  end
end
