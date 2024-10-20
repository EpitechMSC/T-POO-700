defmodule TimeManager.AccountsTest do
  use TimeManager.DataCase

  alias TimeManager.Accounts
  alias TimeManager.Accounts.User

  import TimeManager.AccountsFixtures

  describe "users" do
    setup do
      {:ok, user: user_fixture()}
    end

    test "list_users/0 returns all users", %{user: user} do
      assert {:ok, %TimeManagerWeb.Response{data: [returned_user], pagination: _}} =
               Accounts.list_users()

      assert returned_user.id == user.id
      assert returned_user.username == user.username
      assert returned_user.email == user.email
    end

    test "get_user/1 returns the user with given id", %{user: user} do
      assert {:ok, returned_user} = Accounts.get_user(user.id)
      assert returned_user.id == user.id
      assert returned_user.username == user.username
      assert returned_user.email == user.email
    end

    test "find_users_by_email_or_username/2 returns error when both email and username are nil" do
      assert Accounts.find_users_by_email_or_username(nil, nil) == {:error, :bad_request}
    end

    test "find_users_by_email_or_username/2 returns users when searching by email" do
      user = user_fixture(email: "test@example.com")

      assert {:ok, [returned_user]} =
               Accounts.find_users_by_email_or_username("test@example.com", nil)

      assert returned_user.id == user.id
      assert returned_user.username == user.username
      assert returned_user.email == user.email
    end

    test "find_users_by_email_or_username/2 returns error when no users match email" do
      user_fixture(email: "test@example.com")

      assert Accounts.find_users_by_email_or_username("nonexistent@example.com", nil) ==
               {:error, :not_found}
    end

    test "find_users_by_email_or_username/2 returns users when searching by username" do
      user = user_fixture(username: "testuser")
      assert {:ok, [returned_user]} = Accounts.find_users_by_email_or_username(nil, "testuser")

      assert returned_user.id == user.id
      assert returned_user.username == user.username
      assert returned_user.email == user.email
    end

    test "find_users_by_email_or_username/2 returns error when no users match username" do
      user_fixture(username: "testuser")
      assert Accounts.find_users_by_email_or_username(nil, "nonexistent") == {:error, :not_found}
    end

    test "create_user/1 with valid data creates a user" do
      role = role_fixture()

      valid_attrs = %{
        username: "some_username",
        email: "some_email@example.com",
        password: "password1",
        role: role.id
      }

      assert {:ok, %User{} = user} = Accounts.create_user(valid_attrs)
      assert user.username == valid_attrs.username
      assert user.email == valid_attrs.email
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Accounts.create_user(%{username: nil, email: "email@example.com"})
    end

    test "update_user/2 with valid data updates the user", %{user: user} do
      update_attrs = %{username: "updated_username", email: "updated_email@example.com"}
      assert {:ok, %User{} = updated_user} = Accounts.update_user(user, update_attrs)
      assert updated_user.username == update_attrs.username
      assert updated_user.email == update_attrs.email
    end

    test "delete_user/1 deletes the user", %{user: user} do
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert {:error, :not_found} = Accounts.get_user(user.id)
    end

    test "change_user/1 returns a user changeset", %{user: user} do
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end

  describe "roles" do
    alias TimeManager.Accounts.Role

    import TimeManager.AccountsFixtures

    @invalid_attrs %{name: nil}

    setup do
      {:ok, role: role_fixture()}
    end

    test "list_roles/0 returns all roles", %{role: role} do
      assert {:ok, %TimeManagerWeb.Response{data: [returned_role], pagination: _}} =
               Accounts.list_roles()

      assert returned_role.id == role.id
      assert returned_role.name == role.name
    end

    test "get_role!/1 returns the role with given id" do
      role = role_fixture()
      assert Accounts.get_role!(role.id) == role
    end

    test "create_role/1 with valid data creates a role" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Role{} = role} = Accounts.create_role(valid_attrs)
      assert role.name == "some name"
    end

    test "create_role/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_role(@invalid_attrs)
    end

    test "update_role/2 with valid data updates the role" do
      role = role_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Role{} = role} = Accounts.update_role(role, update_attrs)
      assert role.name == "some updated name"
    end

    test "update_role/2 with invalid data returns error changeset" do
      role = role_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_role(role, @invalid_attrs)
      assert role == Accounts.get_role!(role.id)
    end

    test "delete_role/1 deletes the role" do
      role = role_fixture()
      assert {:ok, %Role{}} = Accounts.delete_role(role)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_role!(role.id) end
    end

    test "change_role/1 returns a role changeset" do
      role = role_fixture()
      assert %Ecto.Changeset{} = Accounts.change_role(role)
    end
  end
end
