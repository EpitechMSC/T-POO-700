defmodule TimeManager.TeamsTest do
  use TimeManager.DataCase

  alias TimeManager.Teams
  alias TimeManager.Teams.Team
  alias TimeManager.Teams.TeamMembership
  import TimeManager.TeamsFixtures
  import TimeManager.AccountsFixtures

  describe "teams" do
    @invalid_attrs %{manager_id: nil}

    test "list_teams/0 returns all teams" do
      supervisor_role = role_fixture(%{name: "Supervisor"})
      supervisor = user_fixture(%{role_id: supervisor_role.id})
      team = team_fixture(%{manager_id: supervisor.id})

      assert {:ok, %TimeManagerWeb.Response{data: [team]}} = Teams.list_teams()
    end

    test "get_team!/1 returns the team with given id" do
      supervisor_role = role_fixture(%{name: "Supervisor"})
      supervisor = user_fixture(%{role_id: supervisor_role.id})
      team = team_fixture(%{manager_id: supervisor.id})

      assert Teams.get_team!(team.id) == team
    end

    test "create_team/1 with valid data creates a team" do
      supervisor_role = role_fixture(%{name: "Supervisor"})
      supervisor = user_fixture(%{role_id: supervisor_role.id})
      valid_attrs = %{manager_id: supervisor.id}

      assert {:ok, %Team{} = team} = Teams.create_team(valid_attrs)
      assert team.manager_id == supervisor.id
    end

    test "create_team/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Teams.create_team(@invalid_attrs)
    end

    test "update_team/2 with valid data updates the team" do
      supervisor_role = role_fixture(%{name: "Supervisor"})
      supervisor = user_fixture(%{role_id: supervisor_role.id})

      user_role = role_fixture(%{name: "Employee"})
      user = user_fixture(%{role_id: user_role.id})

      team = team_fixture(%{manager_id: supervisor.id})

      update_attrs = %{manager_id: user.id}

      assert {:ok, %Team{} = team} = Teams.update_team(team, update_attrs)
      assert team.manager_id == user.id
    end

    test "update_team/2 with invalid data returns error changeset" do
      supervisor_role = role_fixture(%{name: "Supervisor"})
      supervisor = user_fixture(%{role_id: supervisor_role.id})

      team = team_fixture(%{manager_id: supervisor.id})
      assert {:error, %Ecto.Changeset{}} = Teams.update_team(team, @invalid_attrs)
      assert team == Teams.get_team!(team.id)
    end

    test "delete_team/1 deletes the team" do
      supervisor_role = role_fixture(%{name: "Supervisor"})
      supervisor = user_fixture(%{role_id: supervisor_role.id})

      team = team_fixture(%{manager_id: supervisor.id})
      assert {:ok, %Team{}} = Teams.delete_team(team)
      assert_raise Ecto.NoResultsError, fn -> Teams.get_team!(team.id) end
    end

    test "change_team/1 returns a team changeset" do
      supervisor_role = role_fixture(%{name: "Supervisor"})
      supervisor = user_fixture(%{role_id: supervisor_role.id})

      team = team_fixture(%{manager_id: supervisor.id})
      assert %Ecto.Changeset{} = Teams.change_team(team)
    end
  end

  describe "team memberships" do
    alias TimeManager.Teams.TeamMembership

    test "list_team_members/1 returns all team members for a given team" do
      supervisor_role = role_fixture(%{name: "Supervisor"})
      supervisor = user_fixture(%{role_id: supervisor_role.id})

      user_role = role_fixture(%{name: "Employee"})
      user = user_fixture(%{role_id: user_role.id})

      team = team_fixture(%{manager_id: supervisor.id})

      team_membership_fixture(%{team_id: team.id, user_id: user.id})

      assert {:ok, [member]} = Teams.list_team_members(team.id)
      assert member.id == user.id
    end

    test "get_team_membership!/1 returns the team_membership with given id" do
      supervisor_role = role_fixture(%{name: "Supervisor"})
      supervisor = user_fixture(%{role_id: supervisor_role.id})

      user_role = role_fixture(%{name: "Employee"})
      user = user_fixture(%{role_id: user_role.id})

      team = team_fixture(%{manager_id: supervisor.id})

      team_membership = team_membership_fixture(%{team_id: team.id, user_id: user.id})

      assert Teams.get_team_membership!(team_membership.id) == team_membership
    end

    test "create_team_membership/1 with valid data creates a team_membership" do
      supervisor_role = role_fixture(%{name: "Supervisor"})
      supervisor = user_fixture(%{role_id: supervisor_role.id})

      user_role = role_fixture(%{name: "Employee"})
      user = user_fixture(%{role_id: user_role.id})

      team = team_fixture(%{manager_id: supervisor.id})

      valid_attrs = %{team_id: team.id, user_id: user.id}

      assert {:ok, %TeamMembership{} = team_membership} =
               Teams.create_team_membership(valid_attrs)

      assert team_membership.team_id == team.id
      assert team_membership.user_id == user.id
    end

    test "create_team_membership/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Teams.create_team_membership(@invalid_attrs)
    end

    test "update_team_membership/2 with valid data updates the team_membership" do
      supervisor_role = role_fixture(%{name: "Supervisor"})
      supervisor = user_fixture(%{role_id: supervisor_role.id})

      user_role = role_fixture(%{name: "Employee"})
      user = user_fixture(%{role_id: user_role.id})

      team = team_fixture(%{manager_id: supervisor.id})
      team2 = team_fixture(%{manager_id: supervisor.id})

      team_membership = team_membership_fixture(%{team_id: team.id, user_id: user.id})

      valid_attrs = %{team_id: team2.id, user_id: user.id}

      assert {:ok, %TeamMembership{} = updated_team_membership} =
               Teams.update_team_membership(team_membership, valid_attrs)

      assert updated_team_membership.team_id == team2.id
      assert updated_team_membership.user_id == user.id
    end

    test "update_team_membership/2 with invalid data returns error changeset" do
      supervisor_role = role_fixture(%{name: "Supervisor"})
      supervisor = user_fixture(%{role_id: supervisor_role.id})

      user_role = role_fixture(%{name: "Employee"})
      user = user_fixture(%{role_id: user_role.id})

      team = team_fixture(%{manager_id: supervisor.id})

      team_membership = team_membership_fixture(%{team_id: team.id, user_id: user.id})

      assert {:error, %Ecto.Changeset{}} =
               Teams.update_team_membership(team_membership, %{team_id: nil})

      assert team_membership == Teams.get_team_membership!(team_membership.id)
    end

    test "delete_team_membership/1 deletes the team_membership" do
      supervisor_role = role_fixture(%{name: "Supervisor"})
      supervisor = user_fixture(%{role_id: supervisor_role.id})

      user_role = role_fixture(%{name: "Employee"})
      user = user_fixture(%{role_id: user_role.id})

      team = team_fixture(%{manager_id: supervisor.id})
      team_membership = team_membership_fixture(%{team_id: team.id, user_id: user.id})

      assert {:ok, %TeamMembership{}} = Teams.delete_team_membership(team_membership)
      assert_raise Ecto.NoResultsError, fn -> Teams.get_team_membership!(team_membership.id) end
    end

    test "change_team_membership/1 returns a team_membership changeset" do
      supervisor_role = role_fixture(%{name: "Supervisor"})
      supervisor = user_fixture(%{role_id: supervisor_role.id})

      user_role = role_fixture(%{name: "Employee"})
      user = user_fixture(%{role_id: user_role.id})

      team = team_fixture(%{manager_id: supervisor.id})
      team_membership = team_membership_fixture(%{team_id: team.id, user_id: user.id})
      assert %Ecto.Changeset{} = Teams.change_team_membership(team_membership)
    end
  end
end
