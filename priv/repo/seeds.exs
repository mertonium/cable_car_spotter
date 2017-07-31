# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     CableCarSpotter.Repo.insert!(%CableCarSpotter.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias CableCarSpotter.Repo
alias CableCarSpotter.Line
alias CableCarSpotter.CableCar

for line <- ["Powell Street", "California Street"] do
  Repo.get_by(Line, title: line) ||
    Repo.insert!(%Line{title: line})
end

csv_cars =
  File.stream!("priv/repo/cable_cars.csv")
  |> CSV.decode(separator: ?|, headers: ["line_id","car_number","description"])

for car <- csv_cars do
  case car do
    {:ok, cc_data} ->
      Repo.get_by(CableCar, car_number: cc_data["car_number"]) ||
        Repo.insert!(CableCar.changeset(%CableCar{}, cc_data))
    {:error, error_msg} -> IO.puts "ERROR: #{error_msg}"
  end
end


