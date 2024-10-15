defmodule TimeManager.AccountsTest do
  use TimeManager.DataCase

  alias TimeManager.Accounts
  alias TimeManager.Accounts.User

  import TimeManager.AccountsFixtures

  @valid_attrs %{username: "some username", email: "some_email@example.com"}
  @invalid_attrs %{username: nil, email: nil}

  describe "users" do
    test "list_users/0 returns all users" do
      user = user_fixture()
      assert {:ok, %TimeManagerWeb.Response{data: [^user], pagination: _}} = Accounts.list_users()
    end

    test "get_user/1 returns the user with given id" do
      user = user_fixture()
      assert {:ok, ^user} = Accounts.get_user(user.id)
    end

    test "find_users_by_email_or_username/2 returns error when both email and username are nil" do
      assert Accounts.find_users_by_email_or_username(nil, nil) == {:error, :bad_request}
    end

    test "find_users_by_email_or_username/2 returns users when searching by email" do
      user = user_fixture(email: "test@example.com")
      assert Accounts.find_users_by_email_or_username("test", nil) == {:ok, [user]}
    end

    test "find_users_by_email_or_username/2 returns error when no users match email" do
      user_fixture(email: "test@example.com")
      assert Accounts.find_users_by_email_or_username("nonexistent", nil) == {:error, :not_found}
    end

    test "find_users_by_email_or_username/2 returns users when searching by username" do
      user = user_fixture(username: "testuser")
      assert Accounts.find_users_by_email_or_username(nil, "test") == {:ok, [user]}
    end

    test "find_users_by_email_or_username/2 returns error when no users match username" do
      user_fixture(username: "testuser")
      assert Accounts.find_users_by_email_or_username(nil, "nonexistent") == {:error, :not_found}
    end

    test "find_users_by_email_or_username/2 returns users when searching by both email and username" do
      user1 = user_fixture(email: "user1@example.com", username: "user1")
      user2 = user_fixture(email: "user2@example.com", username: "user2")
      assert Accounts.find_users_by_email_or_username("user", "user") == {:ok, [user1, user2]}
    end

    test "find_users_by_email_or_username/2 returns error when no users match both email and username" do
      user_fixture(email: "user1@example.com", username: "user1")

      assert Accounts.find_users_by_email_or_username("nonexistent", "nonexistent") ==
               {:error, :not_found}
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.username == "some username"
      assert user.email == "some_email@example.com"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "create_user/1 returns error changeset when email is invalid" do
      invalid_email_attrs = %{username: "valid_username", email: "invalid_email"}
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(invalid_email_attrs)
    end

    test "create_user/1 returns error changeset when username is nil" do
      invalid_attrs = %{username: nil, email: "valid_email@example.com"}
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(invalid_attrs)
    end

    test "create_user/1 returns error changeset when email is nil" do
      invalid_attrs = %{username: "valid_username", email: nil}
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(invalid_attrs)
    end

    test "create_user/1 returns error changeset when username is not unique" do
      user_fixture(username: "duplicate_username")

      duplicate_username_attrs = %{
        username: "duplicate_username",
        email: "unique_email@example.com"
      }

      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(duplicate_username_attrs)
    end

    test "create_user/1 returns error changeset when email is not unique" do
      user_fixture(email: "duplicate_email@example.com")
      duplicate_email_attrs = %{username: "unique_username", email: "duplicate_email@example.com"}
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(duplicate_email_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{username: "some updated username", email: "some_updated_email@example.com"}

      assert {:ok, %User{} = updated_user} = Accounts.update_user(user, update_attrs)
      assert updated_user.username == "some updated username"
      assert updated_user.email == "some_updated_email@example.com"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert {:ok, ^user} = Accounts.get_user(user.id)
    end

    test "update_user/2 returns error changeset when email is invalid" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, %{email: "invalid_email"})
      # Assurez-vous que l'utilisateur n'a pas changé
      assert {:ok, ^user} = Accounts.get_user(user.id)
    end

    test "update_user/2 returns error changeset when username is not unique" do
      existing_user = user_fixture(username: "existing_username")

      user_to_update =
        user_fixture(username: "unique_username", email: "unique_email@example.com")

      assert {:error, %Ecto.Changeset{}} =
               Accounts.update_user(user_to_update, %{username: existing_user.username})

      # L'utilisateur n'a pas changé
      assert {:ok, ^user_to_update} = Accounts.get_user(user_to_update.id)
    end

    test "update_user/2 returns error changeset when email is not unique" do
      existing_user = user_fixture(email: "existing_email@example.com")

      user_to_update =
        user_fixture(username: "unique_username", email: "unique_email@example.com")

      assert {:error, %Ecto.Changeset{}} =
               Accounts.update_user(user_to_update, %{email: existing_user.email})

      # L'utilisateur n'a pas changé
      assert {:ok, ^user_to_update} = Accounts.get_user(user_to_update.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert {:error, :not_found} = Accounts.get_user(user.id)
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
