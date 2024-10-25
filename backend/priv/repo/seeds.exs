#########
# to run seeds: mix run priv/repo/seeds.exs
#########

alias TimeManager.Repo
alias TimeManager.Accounts.{User, Role}
alias TimeManager.Clocks.Clock
alias TimeManager.Work.WorkingTime
alias TimeManager.Signals.Signal
alias TimeManager.Teams.{Team, TeamMembership}
alias Bcrypt
alias TimeManager.Contrats.Contrat

# Delete all records
Repo.delete_all(Clock)
Repo.delete_all(WorkingTime)
Repo.delete_all(TeamMembership)
Repo.delete_all(Team)
Repo.delete_all(User)
Repo.delete_all(Contrat)
Repo.delete_all(Signal)
Repo.delete_all(Role)

# Create roles
supervisor_role = Repo.insert!(%Role{name: "Supervisor"})
manager_role = Repo.insert!(%Role{name: "Manager"})
user_role = Repo.insert!(%Role{name: "User"})

# Create Bat Signal
_batSignal =
  Repo.insert!(%Signal{
    name: "BatSignal",
    status: false
  })

# Create Contrats

_35h =
  Repo.insert!(%Contrat{
    temps: 35
  })

_39h =
  Repo.insert!(%Contrat{
    temps: 39
  })

_42h =
  Repo.insert!(%Contrat{
    temps: 42
  })

# Create users
# Create users with roles and hashed passwords

# Create hashed passwords

hashed_passwords = for i <- 1..10, do: Bcrypt.hash_pwd_salt("password#{i}")

# Create users with roles
_user1 =
  Repo.insert!(%User{
    email: "alex@surfhub.eu",
    username: "Alex",
    contrat: _42h.id,
    password_hash: Enum.at(hashed_passwords, 0),
    role: supervisor_role.id
  })

_user2 =
  Repo.insert!(%User{
    email: "edward@surfhub.eu",
    username: "Edward",
    contrat: _35h.id,
    password_hash: Enum.at(hashed_passwords, 1),
    role: user_role.id
  })

_user3 =
  Repo.insert!(%User{
    email: "manu@surfhub.eu",
    username: "Manu",
    contrat: _35h.id,
    password_hash: Enum.at(hashed_passwords, 2),
    role: user_role.id
  })

_user4 =
  Repo.insert!(%User{
    email: "selina@surfhub.eu",
    username: "Selina",
    contrat: _35h.id,
    password_hash: Enum.at(hashed_passwords, 3),
    role: user_role.id
  })

_user5 =
  Repo.insert!(%User{
    email: "jerome@surfhub.eu",
    username: "Jerome",
    contrat: _35h.id,
    password_hash: Enum.at(hashed_passwords, 4),
    role: user_role.id
  })

_user6 =
  Repo.insert!(%User{
    email: "jonathan@surfhub.com",
    username: "Jonathan",
    contrat: 3,
    password_hash: Enum.at(hashed_passwords, 5),
    role: user_role.id
  })

# créer des managers
_manager1 =
  Repo.insert!(%User{
    email: "jaquie@surfhub.eu",
    username: "Jaquie",
    contrat: _39h.id,
    password_hash: Enum.at(hashed_passwords, 6),
    role: manager_role.id
  })

_manager2 =
  Repo.insert!(%User{
    email: "michel@surfhub.eu",
    username: "Michel",
    contrat: _39h.id,
    password_hash: Enum.at(hashed_passwords, 7),
    role: manager_role.id
  })

# créer un administrateur
_user9 =
  Repo.insert!(%User{
    email: "gordon@surfhub.com",
    username: "Gordon",
    contrat: _42h.id,
    password_hash: Enum.at(hashed_passwords, 8),
    role: supervisor_role.id
  })

# créer dieu
_user10 =
  Repo.insert!(%User{
    email: "batman@surfhub.eu",
    username: "Batman",
    contrat: _42h.id,
    password_hash: Enum.at(hashed_passwords, 9),
    role: supervisor_role.id
  })

time_slots_1 = [
  {Enum.random(2..4), Enum.random(4..6)},
  {Enum.random(18..20), Enum.random(21..23)}
]

time_slots_2 = [
  {Enum.random(8..9), Enum.random(10..12)},
  {Enum.random(13..15), Enum.random(16..17)}
]

time_slots_3 = [
  {Enum.random(8..10), Enum.random(11..14)},
  {Enum.random(14..16), Enum.random(18..20)}
]

# Create teams for managers and add 2 users to each team
managers = [_manager1, _manager2]
users_without_team = [_user2, _user3, _user4, _user5, _user6]

for manager <- managers do
  team = Repo.insert!(%Team{manager_id: manager.id})

  # Ajouter 2 utilisateurs à l'équipe
  Enum.take_random(users_without_team, 2)
  |> Enum.each(fn user ->
    Repo.insert!(%TeamMembership{team_id: team.id, user_id: user.id})
    IO.puts("Added #{user.username} to #{team.id}")
  end)

  # Mise à jour de la liste des utilisateurs sans équipe
  users_without_team = users_without_team -- Enum.take_random(users_without_team, 2)
end

# Remaining users_without_team are left without a team
IO.puts("Users without a team: #{Enum.map(users_without_team, & &1.username)}")

# Générer les utilisateurs
users = [_user1, _user2, _user3, _user4, _user5, _user6, _manager1, _manager2, _user9, _user10]

# Mois et jours à générer
max_day_for_month = %{
  1 => 31,
  2 => 28,
  3 => 31,
  4 => 30,
  5 => 31,
  6 => 30,
  7 => 31,
  8 => 31,
  9 => 30,
  10 => 31,
  11 => 30,
  12 => 31
}

# Générer les horloges et les temps de travail
for user <- users do
  for month <- 1..10 do
    for day <- 1..max_day_for_month[month] do
      for {start_hour, end_hour} <- time_slots_2 do
        start_minute = Enum.random(0..59)
        end_minute = Enum.random(0..59)
        seconds = Enum.random(0..59)

        case NaiveDateTime.new(2024, month, day, start_hour, start_minute, seconds) do
          {:ok, start_date} ->
            existing_clock_in = Repo.get_by(Clock, time: start_date, user: user.id, status: true)

            if existing_clock_in == nil do
              Repo.insert!(%Clock{time: start_date, status: true, user: user.id})
            end

            case NaiveDateTime.new(2024, month, day, end_hour, end_minute, seconds) do
              {:ok, end_date} ->
                existing_clock_out =
                  Repo.get_by(Clock, time: end_date, user: user.id, status: false)

                if existing_clock_out == nil do
                  Repo.insert!(%Clock{
                    time: end_date,
                    status: false,
                    user: user.id
                  })
                end

                Repo.insert!(%WorkingTime{
                  start: start_date,
                  end: end_date,
                  user: user.id
                })

                IO.puts(
                  "Working time generated for #{user.username} from #{start_date} to #{end_date}"
                )

              {:error, reason} ->
                IO.puts("Failed to create end_date: #{reason}")
            end

          {:error, reason} ->
            IO.puts("Failed to create start_date: #{reason}")
        end
      end
    end
  end
  Repo.delete_all(Clock)
end
