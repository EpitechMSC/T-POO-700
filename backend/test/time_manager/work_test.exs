defmodule TimeManager.WorkTest do
  use TimeManager.DataCase

  alias TimeManager.Work
  alias TimeManager.Work.WorkingTime
  import TimeManager.WorkFixtures
  import TimeManager.AccountsFixtures

  @invalid_attrs %{start: nil, end: nil}

  describe "workingtimes" do
    test "list_workingtimes/0 returns all workingtimes" do
      working_time = working_time_fixture()

      assert {:ok, %TimeManagerWeb.Response{data: [^working_time], pagination: _}} =
               Work.list_workingtimes()
    end

    test "get_working_time!/1 returns the working_time with given id" do
      working_time = working_time_fixture()
      assert Work.get_working_time!(working_time.id) == working_time
    end

    test "create_working_time/1 with valid data creates a working_time" do
      valid_attrs = %{start: ~N[2024-10-07 07:47:00], end: ~N[2024-10-07 07:47:00]}

      assert {:ok, %WorkingTime{} = working_time} = Work.create_working_time(valid_attrs)
      assert working_time.start == ~N[2024-10-07 07:47:00]
      assert working_time.end == ~N[2024-10-07 07:47:00]
    end

    test "create_working_time/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Work.create_working_time(@invalid_attrs)
    end

    test "update_working_time/2 with valid data updates the working_time" do
      working_time = working_time_fixture()
      update_attrs = %{start: ~N[2024-10-08 07:47:00], end: ~N[2024-10-08 07:47:00]}

      assert {:ok, %WorkingTime{} = working_time} =
               Work.update_working_time(working_time, update_attrs)

      assert working_time.start == ~N[2024-10-08 07:47:00]
      assert working_time.end == ~N[2024-10-08 07:47:00]
    end

    test "update_working_time/2 with invalid data returns error changeset" do
      working_time = working_time_fixture()
      assert {:error, %Ecto.Changeset{}} = Work.update_working_time(working_time, @invalid_attrs)
      assert working_time == Work.get_working_time!(working_time.id)
    end

    test "delete_working_time/1 deletes the working_time" do
      working_time = working_time_fixture()
      assert {:ok, %WorkingTime{}} = Work.delete_working_time(working_time)
      assert_raise Ecto.NoResultsError, fn -> Work.get_working_time!(working_time.id) end
    end

    test "change_working_time/1 returns a working_time changeset" do
      working_time = working_time_fixture()
      assert %Ecto.Changeset{} = Work.change_working_time(working_time)
    end

    test "returns error when user is nil" do
      assert Work.find_working_time_for_user_and_date_range(nil, ~N[2024-09-01 08:00:00], nil) ==
               {:error, :bad_request}
    end

    test "returns error when start_date is nil" do
      assert Work.find_working_time_for_user_and_date_range(1, nil, ~N[2024-09-01 08:00:00]) ==
               {:error, :bad_request}
    end

    test "returns works when only start date is provided and user has matching working times" do
      start_date = ~N[2024-09-01 08:00:00]
      user = user_fixture(username: "testUser", email: "test@example.com")

      %WorkingTime{user: user.id, start: ~N[2024-08-31 09:00:00]}
      |> Repo.insert!()

      result = Work.find_working_time_for_user_and_date_range(user.id, start_date, nil)

      assert {:ok, response} = result
      assert length(response.data) > 0
    end
  end
end
