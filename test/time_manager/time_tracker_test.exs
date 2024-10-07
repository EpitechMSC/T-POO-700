defmodule TimeManager.TimeTrackerTest do
  use TimeManager.DataCase

  alias TimeManager.TimeTracker

  describe "users" do
    alias TimeManager.TimeTracker.User

    import TimeManager.TimeTrackerFixtures

    @invalid_attrs %{email: nil, username: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert TimeTracker.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert TimeTracker.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{email: "some email", username: "some username"}

      assert {:ok, %User{} = user} = TimeTracker.create_user(valid_attrs)
      assert user.email == "some email"
      assert user.username == "some username"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = TimeTracker.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{email: "some updated email", username: "some updated username"}

      assert {:ok, %User{} = user} = TimeTracker.update_user(user, update_attrs)
      assert user.email == "some updated email"
      assert user.username == "some updated username"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = TimeTracker.update_user(user, @invalid_attrs)
      assert user == TimeTracker.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = TimeTracker.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> TimeTracker.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = TimeTracker.change_user(user)
    end
  end

  describe "clocks" do
    alias TimeManager.TimeTracker.Clock

    import TimeManager.TimeTrackerFixtures

    @invalid_attrs %{status: nil, time: nil}

    test "list_clocks/0 returns all clocks" do
      clock = clock_fixture()
      assert TimeTracker.list_clocks() == [clock]
    end

    test "get_clock!/1 returns the clock with given id" do
      clock = clock_fixture()
      assert TimeTracker.get_clock!(clock.id) == clock
    end

    test "create_clock/1 with valid data creates a clock" do
      valid_attrs = %{status: true, time: ~N[2024-10-06 11:57:00]}

      assert {:ok, %Clock{} = clock} = TimeTracker.create_clock(valid_attrs)
      assert clock.status == true
      assert clock.time == ~N[2024-10-06 11:57:00]
    end

    test "create_clock/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = TimeTracker.create_clock(@invalid_attrs)
    end

    test "update_clock/2 with valid data updates the clock" do
      clock = clock_fixture()
      update_attrs = %{status: false, time: ~N[2024-10-07 11:57:00]}

      assert {:ok, %Clock{} = clock} = TimeTracker.update_clock(clock, update_attrs)
      assert clock.status == false
      assert clock.time == ~N[2024-10-07 11:57:00]
    end

    test "update_clock/2 with invalid data returns error changeset" do
      clock = clock_fixture()
      assert {:error, %Ecto.Changeset{}} = TimeTracker.update_clock(clock, @invalid_attrs)
      assert clock == TimeTracker.get_clock!(clock.id)
    end

    test "delete_clock/1 deletes the clock" do
      clock = clock_fixture()
      assert {:ok, %Clock{}} = TimeTracker.delete_clock(clock)
      assert_raise Ecto.NoResultsError, fn -> TimeTracker.get_clock!(clock.id) end
    end

    test "change_clock/1 returns a clock changeset" do
      clock = clock_fixture()
      assert %Ecto.Changeset{} = TimeTracker.change_clock(clock)
    end
  end

  describe "workingtime" do
    alias TimeManager.TimeTracker.WorkinTime

    import TimeManager.TimeTrackerFixtures

    @invalid_attrs %{end: nil, start: nil}

    test "list_workingtime/0 returns all workingtime" do
      workin_time = workin_time_fixture()
      assert TimeTracker.list_workingtime() == [workin_time]
    end

    test "get_workin_time!/1 returns the workin_time with given id" do
      workin_time = workin_time_fixture()
      assert TimeTracker.get_workin_time!(workin_time.id) == workin_time
    end

    test "create_workin_time/1 with valid data creates a workin_time" do
      valid_attrs = %{end: ~N[2024-10-06 11:58:00], start: ~N[2024-10-06 11:58:00]}

      assert {:ok, %WorkinTime{} = workin_time} = TimeTracker.create_workin_time(valid_attrs)
      assert workin_time.end == ~N[2024-10-06 11:58:00]
      assert workin_time.start == ~N[2024-10-06 11:58:00]
    end

    test "create_workin_time/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = TimeTracker.create_workin_time(@invalid_attrs)
    end

    test "update_workin_time/2 with valid data updates the workin_time" do
      workin_time = workin_time_fixture()
      update_attrs = %{end: ~N[2024-10-07 11:58:00], start: ~N[2024-10-07 11:58:00]}

      assert {:ok, %WorkinTime{} = workin_time} = TimeTracker.update_workin_time(workin_time, update_attrs)
      assert workin_time.end == ~N[2024-10-07 11:58:00]
      assert workin_time.start == ~N[2024-10-07 11:58:00]
    end

    test "update_workin_time/2 with invalid data returns error changeset" do
      workin_time = workin_time_fixture()
      assert {:error, %Ecto.Changeset{}} = TimeTracker.update_workin_time(workin_time, @invalid_attrs)
      assert workin_time == TimeTracker.get_workin_time!(workin_time.id)
    end

    test "delete_workin_time/1 deletes the workin_time" do
      workin_time = workin_time_fixture()
      assert {:ok, %WorkinTime{}} = TimeTracker.delete_workin_time(workin_time)
      assert_raise Ecto.NoResultsError, fn -> TimeTracker.get_workin_time!(workin_time.id) end
    end

    test "change_workin_time/1 returns a workin_time changeset" do
      workin_time = workin_time_fixture()
      assert %Ecto.Changeset{} = TimeTracker.change_workin_time(workin_time)
    end
  end
end
