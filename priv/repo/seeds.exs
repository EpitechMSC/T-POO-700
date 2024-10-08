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
alias TimeManager.Accounts.User
alias TimeManager.Clocks.Clock
alias TimeManager.Work.WorkingTime

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

#insert Clock

Repo.insert!(%Clock{
  time: "2024-09-01 08:00:00",
  status: 1,
  user: 1
})

Repo.insert!(%Clock{
  time: "2024-09-01 12:00:00",
  status: 0,
  user: 1
})

#insert WorkinTime

Repo.insert!(%WorkingTime{
  start: "2024-09-03 08:00:00",
  end: "2024-09-03 12:00:00",
  user: 1
})

Repo.insert!(%WorkingTime{
  start: "2024-09-03 014:00:00",
  end: "2024-09-03 18:00:00",
  user: 1
})
