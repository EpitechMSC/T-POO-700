defmodule TimeManager.SignalsTest do
  use TimeManager.DataCase

  alias TimeManager.Signals

  describe "signals" do
    alias TimeManager.Signals.Signal

    import TimeManager.SignalsFixtures

    @invalid_attrs %{name: nil, status: nil}

    test "list_signals/0 returns all signals" do
      signal = signal_fixture()
      assert Signals.list_signals() == [signal]
    end

    test "get_signal!/1 returns the signal with given id" do
      signal = signal_fixture()
      assert Signals.get_signal!(signal.id) == signal
    end

    test "create_signal/1 with valid data creates a signal" do
      valid_attrs = %{name: "some name", status: true}

      assert {:ok, %Signal{} = signal} = Signals.create_signal(valid_attrs)
      assert signal.name == "some name"
      assert signal.status == true
    end

    test "create_signal/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Signals.create_signal(@invalid_attrs)
    end

    test "update_signal/2 with valid data updates the signal" do
      signal = signal_fixture()
      update_attrs = %{name: "some updated name", status: false}

      assert {:ok, %Signal{} = signal} = Signals.update_signal(signal, update_attrs)
      assert signal.name == "some updated name"
      assert signal.status == false
    end

    test "update_signal/2 with invalid data returns error changeset" do
      signal = signal_fixture()
      assert {:error, %Ecto.Changeset{}} = Signals.update_signal(signal, @invalid_attrs)
      assert signal == Signals.get_signal!(signal.id)
    end

    test "delete_signal/1 deletes the signal" do
      signal = signal_fixture()
      assert {:ok, %Signal{}} = Signals.delete_signal(signal)
      assert_raise Ecto.NoResultsError, fn -> Signals.get_signal!(signal.id) end
    end

    test "change_signal/1 returns a signal changeset" do
      signal = signal_fixture()
      assert %Ecto.Changeset{} = Signals.change_signal(signal)
    end
  end
end
