defmodule TimeManager.ContratsTest do
  use TimeManager.DataCase

  alias TimeManager.Contrats

  describe "contrats" do
    alias TimeManager.Contrats.Contrat

    import TimeManager.ContratsFixtures

    @invalid_attrs %{temps: nil}

    test "list_contrats/0 returns all contrats" do
      contrat = contrat_fixture()
      assert Contrats.list_contrats() == [contrat]
    end

    test "get_contrat!/1 returns the contrat with given id" do
      contrat = contrat_fixture()
      assert Contrats.get_contrat!(contrat.id) == contrat
    end

    test "create_contrat/1 with valid data creates a contrat" do
      valid_attrs = %{temps: 42}

      assert {:ok, %Contrat{} = contrat} = Contrats.create_contrat(valid_attrs)
      assert contrat.temps == 42
    end

    test "create_contrat/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Contrats.create_contrat(@invalid_attrs)
    end

    test "update_contrat/2 with valid data updates the contrat" do
      contrat = contrat_fixture()
      update_attrs = %{temps: 43}

      assert {:ok, %Contrat{} = contrat} = Contrats.update_contrat(contrat, update_attrs)
      assert contrat.temps == 43
    end

    test "update_contrat/2 with invalid data returns error changeset" do
      contrat = contrat_fixture()
      assert {:error, %Ecto.Changeset{}} = Contrats.update_contrat(contrat, @invalid_attrs)
      assert contrat == Contrats.get_contrat!(contrat.id)
    end

    test "delete_contrat/1 deletes the contrat" do
      contrat = contrat_fixture()
      assert {:ok, %Contrat{}} = Contrats.delete_contrat(contrat)
      assert_raise Ecto.NoResultsError, fn -> Contrats.get_contrat!(contrat.id) end
    end

    test "change_contrat/1 returns a contrat changeset" do
      contrat = contrat_fixture()
      assert %Ecto.Changeset{} = Contrats.change_contrat(contrat)
    end
  end
end
