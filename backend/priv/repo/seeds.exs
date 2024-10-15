#
# This file is used to populate the database with some data.
# It is executed by running the following command:
#     mix run priv/repo/seeds.exs
#

alias Hex.Repo
alias TimeManager.Repo
alias TimeManager.Accounts.User
alias TimeManager.Clocks.Clock
alias TimeManager.Work.WorkingTime

# Delete all records

Repo.delete_all(Clock)
Repo.delete_all(WorkingTime)
Repo.delete_all(User)

# Create users

_user1 =
  Repo.insert!(%User{
    email: "alex@surfhub.eu",
    username: "Alex"
  })

_user2 =
  Repo.insert!(%User{
    email: "manu@surfhub.eu",
    username: "Manu"
  })

_user3 =
  Repo.insert!(%User{
    email: "mimi@surfhub.eu",
    username: "Mimi"
  })

_user4 =
  Repo.insert!(%User{
    email: "jaquie@surfhub.eu",
    username: "Jaquie"
  })

_user5 =
  Repo.insert!(%User{
    email: "michel@surfhub.eu",
    username: "Michel"
  })

_user6 =
  Repo.insert!(%User{
    email: "batman@surfhub.eu",
    username: "Batman"
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
          # Create clock in whit status true
          Repo.insert!(%Clock{
            time: start_date,
            status: true,
            user: user.id
          })

          # put a message in the console to know that the clock was generated correctly
          # IO.puts("Clock generated for user #{user.id} with time: #{start_date}")

          case NaiveDateTime.new(2024, month, day, end_hour, end_minute, seconds) do
            {:ok, end_date} ->
              # Create clock in whit status false
              Repo.insert!(%Clock{
                time: end_date,
                status: false,
                user: user.id
              })

              # put a message in the console to know that the clock was generated correctly
              # IO.puts("Clock generated for user #{user.id} with time: #{end_date}")

              # Create working time for user
              Repo.insert!(%WorkingTime{
                start: start_date,
                end: end_date,
                user: user.id
              })

            # put a message in the console to know that the working time was generated correctly
            # IO.puts("Working time generated for user #{user.id} on #{start_date} to #{end_date}")

            {:error, reason} ->
              IO.puts("Failed to create end_date: #{reason}")
          end

        {:error, reason} ->
          IO.puts("Failed to create start_date: #{reason}")
      end
    end
  end
end
