defmodule CoinPortfolio.TokensTest do
  use CoinPortfolio.DataCase

  alias CoinPortfolio.Tokens

  describe "rates" do
    alias CoinPortfolio.Tokens.Rates

    @valid_attrs %{currency: "some currency", rate: 120.5, timestamp: "some timestamp", token: "some token", token_name: "some token_name"}
    @update_attrs %{currency: "some updated currency", rate: 456.7, timestamp: "some updated timestamp", token: "some updated token", token_name: "some updated token_name"}
    @invalid_attrs %{currency: nil, rate: nil, timestamp: nil, token: nil, token_name: nil}

    def rates_fixture(attrs \\ %{}) do
      {:ok, rates} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Tokens.create_rates()

      rates
    end

    test "list_rates/0 returns all rates" do
      rates = rates_fixture()
      assert Tokens.list_rates() == [rates]
    end

    test "get_rates!/1 returns the rates with given id" do
      rates = rates_fixture()
      assert Tokens.get_rates!(rates.id) == rates
    end

    test "create_rates/1 with valid data creates a rates" do
      assert {:ok, %Rates{} = rates} = Tokens.create_rates(@valid_attrs)
      assert rates.currency == "some currency"
      assert rates.rate == 120.5
      assert rates.timestamp == "some timestamp"
      assert rates.token == "some token"
      assert rates.token_name == "some token_name"
    end

    test "create_rates/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tokens.create_rates(@invalid_attrs)
    end

    test "update_rates/2 with valid data updates the rates" do
      rates = rates_fixture()
      assert {:ok, %Rates{} = rates} = Tokens.update_rates(rates, @update_attrs)
      assert rates.currency == "some updated currency"
      assert rates.rate == 456.7
      assert rates.timestamp == "some updated timestamp"
      assert rates.token == "some updated token"
      assert rates.token_name == "some updated token_name"
    end

    test "update_rates/2 with invalid data returns error changeset" do
      rates = rates_fixture()
      assert {:error, %Ecto.Changeset{}} = Tokens.update_rates(rates, @invalid_attrs)
      assert rates == Tokens.get_rates!(rates.id)
    end

    test "delete_rates/1 deletes the rates" do
      rates = rates_fixture()
      assert {:ok, %Rates{}} = Tokens.delete_rates(rates)
      assert_raise Ecto.NoResultsError, fn -> Tokens.get_rates!(rates.id) end
    end

    test "change_rates/1 returns a rates changeset" do
      rates = rates_fixture()
      assert %Ecto.Changeset{} = Tokens.change_rates(rates)
    end
  end
end
