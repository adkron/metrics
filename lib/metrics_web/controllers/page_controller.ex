defmodule MetricsWeb.PageController do
  use MetricsWeb, :controller
  plug Plug.Telemetry, event_prefix: [:woot]

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
