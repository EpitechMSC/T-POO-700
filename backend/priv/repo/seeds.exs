alias TimeManager.Repo
alias TimeManager.Accounts.{User, Role}
alias TimeManager.Clocks.Clock
alias TimeManager.Work.WorkingTime
alias TimeManager.Signals.Signal

# Delete all records
Repo.delete_all(Clock)
Repo.delete_all(WorkingTime)
Repo.delete_all(User)
Repo.delete_all(Signal)
Repo.delete_all(Role)

# Create roles
admin_role = Repo.insert!(%Role{name: "Admin"})
user_role = Repo.insert!(%Role{name: "User"})

# Create Bat Signal
_batSignal =
  Repo.insert!(%Signal{
    name: "BatSignal",
    status: false
  })

# Create users with roles

_user1 =
  Repo.insert!(%User{
    email: "alex@surfhub.eu",
    username: "Alex",
    password: "password1",
    role_id: admin_role.id
  })

_user2 =
  Repo.insert!(%User{
    email: "manu@surfhub.eu",
    username: "Manu",
    password: "password2",
    role_id: user_role.id
  })

_user3 =
  Repo.insert!(%User{
    email: "mimi@surfhub.eu",
    username: "Mimi",
    password: "password3",
    role_id: user_role.id
  })

_user4 =
  Repo.insert!(%User{
    email: "jaquie@surfhub.eu",
    username: "Jaquie",
    password: "password4",
    role_id: user_role.id
  })

_user5 =
  Repo.insert!(%User{
    email: "michel@surfhub.eu",
    username: "Michel",
    password: "password5",
    role_id: user_role.id
  })

_user6 =
  Repo.insert!(%User{
    email: "batman@surfhub.eu",
    username: "Batman",
    password: "password6",
    role_id: admin_role.id
  })

# Generate working times and clocks
users = [_user1, _user2, _user3, _user4, _user5, _user6]

for user <- users do
  # Generate data for each month
  for month <- 8..10 do
    # Generate data for each day
    for day <- 1..20 do
      # Generate random start and end hours / minutes / seconds for the clock and working time
      start_hour = Enum.random(8..10)
      end_hour = Enum.random(18..20)
      start_minute = Enum.random(0..59)
      end_minute = Enum.random(0..59)
      seconds = Enum.random(0..59)

      case NaiveDateTime.new(2024, month, day, start_hour, start_minute, seconds) do
        {:ok, start_date} ->
          # Create clock in with status true
          Repo.insert!(%Clock{
            time: start_date,
            status: true,
            user: user.id
          })

          case NaiveDateTime.new(2024, month, day, end_hour, end_minute, seconds) do
            {:ok, end_date} ->
              # Create clock in with status false
              Repo.insert!(%Clock{
                time: end_date,
                status: false,
                user: user.id
              })

              # Create working time for user
              Repo.insert!(%WorkingTime{
                start: start_date,
                end: end_date,
                user: user.id
              })

            {:error, reason} ->
              IO.puts("Failed to create end_date: #{reason}")
          end

        {:error, reason} ->
          IO.puts("Failed to create start_date: #{reason}")
      end
    end
  end
end
