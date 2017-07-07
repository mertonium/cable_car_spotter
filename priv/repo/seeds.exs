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

for line <- ["Powell Street", "California Street"] do
  Repo.get_by(Line, title: line) ||
    Repo.insert!(%Line{title: line})
end

