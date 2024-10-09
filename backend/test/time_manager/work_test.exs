defmodule TimeManager.WorkTest do
  use TimeManager.DataCase

  alias TimeManager.Work
  alias TimeManager.Work.WorkingTime
  alias TimeManager.AccountsFixtures

  import TimeManager.WorkFixtures

  @invalid_attrs %{start: nil, end: nil}

  describe "workingtimes" do
    setup do
      user = AccountsFixtures.user_fixture()
      %{user: user}
    end

    test "list_workingtimes/0 returns all workingtimes" do
      working_time = working_time_fixture()
      assert Work.list_workingtimes() == [working_time]
    end

    test "get_working_time!/1 returns the working_time with given id" do
      working_time = working_time_fixture()
      assert Work.get_working_time!(working_time.id) == working_time
    end

    test "returns the working_time for the user when it exists", %{user: user} do
      working_time = working_time_fixture(%{user: user.id})  # Assurez-vous que c'est %{user: user.id}
      assert Work.get_working_time_for_user(user.id, working_time.id) == working_time
    end

    test "returns nil when the working_time does not exist for the user", %{user: user} do
      non_existent_working_time_id = 99999
      assert Work.get_working_time_for_user(user.id, non_existent_working_time_id) == nil
    end

    test "returns nil when the user does not own the working_time", %{user: user} do
      other_user = AccountsFixtures.user_fixture()
      working_time = working_time_fixture(%{user: other_user.id})
      assert Work.get_working_time_for_user(user.id, working_time.id) == nil
    end

    test "returns the user for the given user_id" do
      user = AccountsFixtures.user_fixture()
      assert Work.get_user(user.id) == user
    end

    test "returns nil for non-existent user_id" do
      non_existent_user_id = 99999
      assert Work.get_user(non_existent_user_id) == nil
    end

    test "create_working_time/1 with valid data creates a working_time", %{user: user} do
      valid_attrs = %{start: ~N[2024-10-07 07:47:00], end: ~N[2024-10-07 07:47:00], user: user.id}

      assert {:ok, %WorkingTime{} = working_time} = Work.create_working_time(valid_attrs)
      assert working_time.start == ~N[2024-10-07 07:47:00]
      assert working_time.end == ~N[2024-10-07 07:47:00]
      assert working_time.user == user.id
    end


    test "create_working_time/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Work.create_working_time(@invalid_attrs)
    end

    test "update_working_time/2 with valid data updates the working_time", %{user: user} do
      working_time = working_time_fixture(%{user: user.id})
      update_attrs = %{start: ~N[2024-10-08 07:47:00], end: ~N[2024-10-08 07:47:00]}

      assert {:ok, %WorkingTime{} = updated_working_time} = Work.update_working_time(working_time, update_attrs)
      assert updated_working_time.start == ~N[2024-10-08 07:47:00]
      assert updated_working_time.end == ~N[2024-10-08 07:47:00]
    end

    test "update_working_time/2 with invalid data returns error changeset", %{user: user} do
      working_time = working_time_fixture(%{user: user.id})
      assert {:error, %Ecto.Changeset{}} = Work.update_working_time(working_time, @invalid_attrs)
      assert working_time == Work.get_working_time!(working_time.id)
    end

    test "delete_working_time/1 deletes the working_time", %{user: user} do
      working_time = working_time_fixture(%{user: user.id})
      assert {:ok, %WorkingTime{}} = Work.delete_working_time(working_time)
      assert_raise Ecto.NoResultsError, fn -> Work.get_working_time!(working_time.id) end
    end

    test "change_working_time/1 returns a working_time changeset", %{user: user} do
      working_time = working_time_fixture(%{user: user.id})
      assert %Ecto.Changeset{} = Work.change_working_time(working_time)
    end
  end
end
