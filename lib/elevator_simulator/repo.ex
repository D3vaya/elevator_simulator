defmodule ElevatorSimulator.Repo do
  use Ecto.Repo,
    otp_app: :elevator_simulator,
    adapter: Ecto.Adapters.Postgres
end
