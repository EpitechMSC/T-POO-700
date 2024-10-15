#
# This file is used to populate the database with some data.
# It is executed by running the following command:
#     mix run priv/repo/seeds.exs
#
alias TimeManager.Repo
alias TimeManager.Accounts.User
alias TimeManager.Clocks.Clock
alias TimeManager.Work.WorkingTime

# Supprimer tous les enregistrements
Repo.delete_all(Clock)
Repo.delete_all(WorkingTime)
Repo.delete_all(User)

# Créer les utilisateurs
_user1 = Repo.insert!(%User{email: "alex@surfhub.eu", username: "Alex"})
_user2 = Repo.insert!(%User{email: "edward@surfhub.eu", username: "Edward"})
_user3 = Repo.insert!(%User{email: "manu@surfhub.eu", username: "Manu"})
_user4 = Repo.insert!(%User{email: "selina@surfhub.eu", username: "Selina"})
_user5 = Repo.insert!(%User{email: "jerome@surfhub.eu", username: "Jerome"})
_user6 = Repo.insert!(%User{email: "jonathan@surfhub.com", username: "Jonathan"})
# créer des superviseurs
_user7 = Repo.insert!(%User{email: "jaquie@surfhub.eu", username: "Jaquie"})
_user8 = Repo.insert!(%User{email: "michel@surfhub.eu", username: "Michel"})
# créer un administrateur
_user9 = Repo.insert!(%User{email: "gordon@surfhub.com", username: "Gordon"})
# créer dieu
_user10 = Repo.insert!(%User{email: "batman@surfhub.eu", username: "Batman"})

# Générer les utilisateurs
users = [_user1, _user2, _user3, _user4, _user5, _user6, _user7, _user8, _user9, _user10]

# Plages horaires à générer
time_slots = [
  {Enum.random(2..4), Enum.random(4..6)},
  {Enum.random(8..10), Enum.random(10..12)},
  {Enum.random(13..15), Enum.random(15..17)},
  {Enum.random(18..20), Enum.random(21..23)}
]

# Mois et jours à générer
months_slots = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
max_day_for_month = %{1 => 31, 2 => 28, 3 => 31, 4 => 30, 5 => 31, 6 => 30, 7 => 31, 8 => 31, 9 => 30, 10 => 31, 11 => 30, 12 => 31}
# Pour générer les jours d'un mois donné

# Générer les horloges et les temps de travail
for user <- users do
  for month <- 1..9 do
    for day <- 1..max_day_for_month[month] do
      start_minute = Enum.random(0..59)
      end_minute = Enum.random(0..59)
      seconds = Enum.random(0..59)

      # Générer les différentes plages horaires avec un index
      for {start_hour, end_hour} <- time_slots do
        index = Enum.find_index(time_slots, fn {sh, _} -> sh == start_hour end)

      # Générer les différentes plages horaires avec un index
      for {start_hour, end_hour} <- time_slots do
        index = Enum.find_index(time_slots, fn {sh, _} -> sh == start_hour end)

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
                Repo.insert!(%Clock{time: end_date, status: false, user: user.id})
                working_time = Repo.insert!(%WorkingTime{start: start_date, end: end_date, user: user.id})

                IO.puts("Working time #{index} generated for #{user.username}-##{user.id} from #{start_date} to #{end_date}")
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
end
