defmodule CoinPortfolio.CurrenciesTest do
  use CoinPortfolio.DataCase

  alias CoinPortfolio.Currencies

  describe "currency_rates" do
    alias CoinPortfolio.Currencies.CurrencyRate

    @valid_attrs %{base_currency: "some base_currency", rate: 120.5, target_currency: "some target_currency"}
    @update_attrs %{base_currency: "some updated base_currency", rate: 456.7, target_currency: "some updated target_currency"}
    @invalid_attrs %{base_currency: nil, rate: nil, target_currency: nil}

    def currency_rate_fixture(attrs \\ %{}) do
      {:ok, currency_rate} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Currencies.create_currency_rate()

      currency_rate
    end

    test "list_currency_rates/0 returns all currency_rates" do
      currency_rate = currency_rate_fixture()
      assert Currencies.list_currency_rates() == [currency_rate]
    end

    test "get_currency_rate!/1 returns the currency_rate with given id" do
      currency_rate = currency_rate_fixture()
      assert Currencies.get_currency_rate!(currency_rate.id) == currency_rate
    end

    test "create_currency_rate/1 with valid data creates a currency_rate" do
      assert {:ok, %CurrencyRate{} = currency_rate} = Currencies.create_currency_rate(@valid_attrs)
      assert currency_rate.base_currency == "some base_currency"
      assert currency_rate.rate == 120.5
      assert currency_rate.target_currency == "some target_currency"
    end

    test "create_currency_rate/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Currencies.create_currency_rate(@invalid_attrs)
    end

    test "update_currency_rate/2 with valid data updates the currency_rate" do
      currency_rate = currency_rate_fixture()
      assert {:ok, %CurrencyRate{} = currency_rate} = Currencies.update_currency_rate(currency_rate, @update_attrs)
      assert currency_rate.base_currency == "some updated base_currency"
      assert currency_rate.rate == 456.7
      assert currency_rate.target_currency == "some updated target_currency"
    end

    test "update_currency_rate/2 with invalid data returns error changeset" do
      currency_rate = currency_rate_fixture()
      assert {:error, %Ecto.Changeset{}} = Currencies.update_currency_rate(currency_rate, @invalid_attrs)
      assert currency_rate == Currencies.get_currency_rate!(currency_rate.id)
    end

    test "delete_currency_rate/1 deletes the currency_rate" do
      currency_rate = currency_rate_fixture()
      assert {:ok, %CurrencyRate{}} = Currencies.delete_currency_rate(currency_rate)
      assert_raise Ecto.NoResultsError, fn -> Currencies.get_currency_rate!(currency_rate.id) end
    end

    test "change_currency_rate/1 returns a currency_rate changeset" do
      currency_rate = currency_rate_fixture()
      assert %Ecto.Changeset{} = Currencies.change_currency_rate(currency_rate)
    end
  end
end
