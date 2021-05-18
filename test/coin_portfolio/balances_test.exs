defmodule CoinPortfolio.BalancesTest do
  use CoinPortfolio.DataCase

  alias CoinPortfolio.Balances

  describe "balances" do
    alias CoinPortfolio.Balances.Balance

    @valid_attrs %{change_percentage: 120.5, holdings: 120.5, spent: 120.5, timestamp: "some timestamp", token: "some token", user: "some user"}
    @update_attrs %{change_percentage: 456.7, holdings: 456.7, spent: 456.7, timestamp: "some updated timestamp", token: "some updated token", user: "some updated user"}
    @invalid_attrs %{change_percentage: nil, holdings: nil, spent: nil, timestamp: nil, token: nil, user: nil}

    def balance_fixture(attrs \\ %{}) do
      {:ok, balance} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Balances.create_balance()

      balance
    end

    test "list_balances/0 returns all balances" do
      balance = balance_fixture()
      assert Balances.list_balances() == [balance]
    end

    test "get_balance!/1 returns the balance with given id" do
      balance = balance_fixture()
      assert Balances.get_balance!(balance.id) == balance
    end

    test "create_balance/1 with valid data creates a balance" do
      assert {:ok, %Balance{} = balance} = Balances.create_balance(@valid_attrs)
      assert balance.change_percentage == 120.5
      assert balance.holdings == 120.5
      assert balance.spent == 120.5
      assert balance.timestamp == "some timestamp"
      assert balance.token == "some token"
      assert balance.user == "some user"
    end

    test "create_balance/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Balances.create_balance(@invalid_attrs)
    end

    test "update_balance/2 with valid data updates the balance" do
      balance = balance_fixture()
      assert {:ok, %Balance{} = balance} = Balances.update_balance(balance, @update_attrs)
      assert balance.change_percentage == 456.7
      assert balance.holdings == 456.7
      assert balance.spent == 456.7
      assert balance.timestamp == "some updated timestamp"
      assert balance.token == "some updated token"
      assert balance.user == "some updated user"
    end

    test "update_balance/2 with invalid data returns error changeset" do
      balance = balance_fixture()
      assert {:error, %Ecto.Changeset{}} = Balances.update_balance(balance, @invalid_attrs)
      assert balance == Balances.get_balance!(balance.id)
    end

    test "delete_balance/1 deletes the balance" do
      balance = balance_fixture()
      assert {:ok, %Balance{}} = Balances.delete_balance(balance)
      assert_raise Ecto.NoResultsError, fn -> Balances.get_balance!(balance.id) end
    end

    test "change_balance/1 returns a balance changeset" do
      balance = balance_fixture()
      assert %Ecto.Changeset{} = Balances.change_balance(balance)
    end
  end
end
