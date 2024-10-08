# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     TimeManager.Repo.insert!(%TimeManager.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias TimeManager.Repo
alias TimeManager.TimeTracker.User
alias TimeManager.TimeTracker.Clock
alias TimeManager.TimeTracker.WorkinTime

#delete all records

# Repo.delete_all(User)
# Repo.delete_all(Clock)
# Repo.delete_all(WorkinTime)

#insert User

Repo.insert!(%User{
  email: "test@test.com",
  username: "test"
})

Repo.insert!(%User{
  email: "test_2@test.fr",
  username: "test2"
})
