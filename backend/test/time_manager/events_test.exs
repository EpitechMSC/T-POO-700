defmodule TimeManager.EventsTest do
  use TimeManager.DataCase

  alias TimeManager.Events

  describe "events" do
    alias TimeManager.Events.Event

    import TimeManager.EventsFixtures
    import TimeManager.AccountsFixtures
    import TimeManager.TeamsFixtures

    @invalid_attrs %{start: nil, title: nil, end: nil, all_day: nil, team_id: nil}

    test "list_events/0 returns all events" do
      manager_role = role_fixture(%{name: "Manager"})
      manager = user_fixture(%{role: manager_role.id})
      team = team_fixture(%{manager_id: manager.id})
      event = event_fixture(%{team_id: team.id})

      {:ok, response} = Events.list_events()
      assert response.data == [event]
    end


    test "get_event!/1 returns the event with given id" do
      manager_role = role_fixture(%{name: "Manager"})
      manager = user_fixture(%{role: manager_role.id})
      team = team_fixture(%{manager_id: manager.id})
      event = event_fixture(%{team_id: team.id})

      assert {:ok, found_event} = Events.get_event(event.id)
      assert found_event == event
    end


    test "create_event/1 with valid data creates an event" do
      manager_role = role_fixture(%{name: "Manager"})
      manager = user_fixture(%{role: manager_role.id})  # Crée un Manager
      team = team_fixture(%{manager_id: manager.id})    # Associe une équipe au Manager

      valid_attrs = %{
        start: ~U[2024-10-23 09:08:00Z],
        title: "some title",
        end: ~U[2024-10-23 09:08:00Z],
        all_day: true,
        team_id: team.id
      }

      assert {:ok, %Event{} = event} = Events.create_event(valid_attrs)
      assert event.start == ~U[2024-10-23 09:08:00Z]
      assert event.title == "some title"
      assert event.end == ~U[2024-10-23 09:08:00Z]
      assert event.all_day == true
      assert event.team_id == team.id
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      manager_role = role_fixture(%{name: "Manager"})
      manager = user_fixture(%{role: manager_role.id})
      team = team_fixture(%{manager_id: manager.id})
      event = event_fixture(%{team_id: team.id})

      update_attrs = %{
        start: ~U[2024-10-24 09:08:00Z],
        title: "some updated title",
        end: ~U[2024-10-24 09:08:00Z],
        all_day: false
      }

      assert {:ok, %Event{} = event} = Events.update_event(event, update_attrs)
      assert event.start == ~U[2024-10-24 09:08:00Z]
      assert event.title == "some updated title"
      assert event.end == ~U[2024-10-24 09:08:00Z]
      assert event.all_day == false
    end

    test "update_event/2 with invalid data returns error changeset" do
      manager_role = role_fixture(%{name: "Manager"})
      manager = user_fixture(%{role: manager_role.id})
      team = team_fixture(%{manager_id: manager.id})
      event = event_fixture(%{team_id: team.id})

      assert {:error, %Ecto.Changeset{}} = Events.update_event(event, @invalid_attrs)
      assert {:ok, unchanged_event} = Events.get_event(event.id)
      assert unchanged_event == event
    end


    test "delete_event/1 deletes the event" do
      manager_role = role_fixture(%{name: "Manager"})
      manager = user_fixture(%{role: manager_role.id})
      team = team_fixture(%{manager_id: manager.id})
      event = event_fixture(%{team_id: team.id})

      assert {:ok, %Event{}} = Events.delete_event(event)
      assert {:error, :not_found} = Events.get_event(event.id)
    end


    test "change_event/1 returns an event changeset" do
      manager_role = role_fixture(%{name: "Manager"})
      manager = user_fixture(%{role: manager_role.id})
      team = team_fixture(%{manager_id: manager.id})
      event = event_fixture(%{team_id: team.id})

      assert %Ecto.Changeset{} = Events.change_event(event)
    end
  end
end
