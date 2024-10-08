# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias TimeManager.Repo
alias TimeManager.Accounts.User
alias TimeManager.Clocks.Clock
alias TimeManager.Work.WorkingTime

#delete all records

Repo.delete_all(Clock)
Repo.delete_all(WorkingTime)
Repo.delete_all(User)

#insert User

_user1 = Repo.insert!(%User{
  email: "test@test.com",
  username: "Alex"
})

_user2 = Repo.insert!(%User{
  email: "test_2@test.fr",
  username: "Manu"
})

_user3 = Repo.insert!(%User{
  email: "test_3@test.fr",
  username: "Mimi"
})

#insert Clock

Repo.insert!(%Clock{
  time: ~N[2024-09-01 08:00:00],
  status: true,
  user: _user1.id
})

Repo.insert!(%Clock{
  time: ~N[2024-09-01 12:00:00],
  status: false,
  user: _user1.id
})

Repo.insert!(%Clock{
  time: ~N[2024-09-01 08:02:00],
  status: true,
  user: _user2.id
})

Repo.insert!(%Clock{
  time: ~N[2024-09-01 12:02:00],
  status: false,
  user: _user2.id
})

#insert WorkinTime

Repo.insert!(%WorkingTime{
  start: ~N[2024-09-01 08:00:00],
  end: ~N[2024-09-01 12:00:00],
  user: _user1.id
})

Repo.insert!(%WorkingTime{
  start: ~N[2024-09-01 14:00:00],
  end: ~N[2024-09-01 18:00:00],
  user: _user1.id
})

Repo.insert!(%WorkingTime{
  start: ~N[2024-09-01 08:02:00],
  end: ~N[2024-09-01 12:02:00],
  user: _user2.id
})
