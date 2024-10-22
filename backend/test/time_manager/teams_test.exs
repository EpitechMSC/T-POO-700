defmodule TimeManager.TeamsTest do
  use TimeManager.DataCase

  alias TimeManager.Teams

  describe "teams" do
    alias TimeManager.Teams.Team

    import TimeManager.TeamsFixtures

    @invalid_attrs %{name: nil}

    test "list_teams/0 returns all teams" do
      team = team_fixture()
      assert Teams.list_teams() == [team]
    end

    test "get_team!/1 returns the team with given id" do
      team = team_fixture()
      assert Teams.get_team!(team.id) == team
    end

    test "create_team/1 with valid data creates a team" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Team{} = team} = Teams.create_team(valid_attrs)
      assert team.name == "some name"
    end

    test "create_team/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Teams.create_team(@invalid_attrs)
    end

    test "update_team/2 with valid data updates the team" do
      team = team_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Team{} = team} = Teams.update_team(team, update_attrs)
      assert team.name == "some updated name"
    end

    test "update_team/2 with invalid data returns error changeset" do
      team = team_fixture()
      assert {:error, %Ecto.Changeset{}} = Teams.update_team(team, @invalid_attrs)
      assert team == Teams.get_team!(team.id)
    end

    test "delete_team/1 deletes the team" do
      team = team_fixture()
      assert {:ok, %Team{}} = Teams.delete_team(team)
      assert_raise Ecto.NoResultsError, fn -> Teams.get_team!(team.id) end
    end

    test "change_team/1 returns a team changeset" do
      team = team_fixture()
      assert %Ecto.Changeset{} = Teams.change_team(team)
    end
  end

  describe "team_memberships" do
    alias TimeManager.Teams.TeamMembership

    import TimeManager.TeamsFixtures

    @invalid_attrs %{}

    test "list_team_memberships/0 returns all team_memberships" do
      team_membership = team_membership_fixture()
      assert Teams.list_team_memberships() == [team_membership]
    end

    test "get_team_membership!/1 returns the team_membership with given id" do
      team_membership = team_membership_fixture()
      assert Teams.get_team_membership!(team_membership.id) == team_membership
    end

    test "create_team_membership/1 with valid data creates a team_membership" do
      valid_attrs = %{}

      assert {:ok, %TeamMembership{} = team_membership} = Teams.create_team_membership(valid_attrs)
    end

    test "create_team_membership/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Teams.create_team_membership(@invalid_attrs)
    end

    test "update_team_membership/2 with valid data updates the team_membership" do
      team_membership = team_membership_fixture()
      update_attrs = %{}

      assert {:ok, %TeamMembership{} = team_membership} = Teams.update_team_membership(team_membership, update_attrs)
    end

    test "update_team_membership/2 with invalid data returns error changeset" do
      team_membership = team_membership_fixture()
      assert {:error, %Ecto.Changeset{}} = Teams.update_team_membership(team_membership, @invalid_attrs)
      assert team_membership == Teams.get_team_membership!(team_membership.id)
    end

    test "delete_team_membership/1 deletes the team_membership" do
      team_membership = team_membership_fixture()
      assert {:ok, %TeamMembership{}} = Teams.delete_team_membership(team_membership)
      assert_raise Ecto.NoResultsError, fn -> Teams.get_team_membership!(team_membership.id) end
    end

    test "change_team_membership/1 returns a team_membership changeset" do
      team_membership = team_membership_fixture()
      assert %Ecto.Changeset{} = Teams.change_team_membership(team_membership)
    end
  end
end
