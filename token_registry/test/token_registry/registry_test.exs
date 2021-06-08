defmodule TokenRegistry.RegistryTest do
  use TokenRegistry.DataCase

  alias TokenRegistry.Registry

  describe "tokens" do
    alias TokenRegistry.Registry.Token

    @valid_attrs %{metadata: %{}, name: "some name", project_uri: "some project_uri", symbol: "some symbol"}
    @update_attrs %{metadata: %{}, name: "some updated name", project_uri: "some updated project_uri", symbol: "some updated symbol"}
    @invalid_attrs %{metadata: nil, name: nil, project_uri: nil, symbol: nil}

    def token_fixture(attrs \\ %{}) do
      {:ok, token} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Registry.create_token()

      token
    end

    test "list_tokens/0 returns all tokens" do
      token = token_fixture()
      assert Registry.list_tokens() == [token]
    end

    test "get_token!/1 returns the token with given id" do
      token = token_fixture()
      assert Registry.get_token!(token.id) == token
    end

    test "create_token/1 with valid data creates a token" do
      assert {:ok, %Token{} = token} = Registry.create_token(@valid_attrs)
      assert token.metadata == %{}
      assert token.name == "some name"
      assert token.project_uri == "some project_uri"
      assert token.symbol == "some symbol"
    end

    test "create_token/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Registry.create_token(@invalid_attrs)
    end

    test "update_token/2 with valid data updates the token" do
      token = token_fixture()
      assert {:ok, %Token{} = token} = Registry.update_token(token, @update_attrs)
      assert token.metadata == %{}
      assert token.name == "some updated name"
      assert token.project_uri == "some updated project_uri"
      assert token.symbol == "some updated symbol"
    end

    test "update_token/2 with invalid data returns error changeset" do
      token = token_fixture()
      assert {:error, %Ecto.Changeset{}} = Registry.update_token(token, @invalid_attrs)
      assert token == Registry.get_token!(token.id)
    end

    test "delete_token/1 deletes the token" do
      token = token_fixture()
      assert {:ok, %Token{}} = Registry.delete_token(token)
      assert_raise Ecto.NoResultsError, fn -> Registry.get_token!(token.id) end
    end

    test "change_token/1 returns a token changeset" do
      token = token_fixture()
      assert %Ecto.Changeset{} = Registry.change_token(token)
    end
  end

  describe "blockchains" do
    alias TokenRegistry.Registry.Blockchain

    @valid_attrs %{name: "some name", symbol: "some symbol"}
    @update_attrs %{name: "some updated name", symbol: "some updated symbol"}
    @invalid_attrs %{name: nil, symbol: nil}

    def blockchain_fixture(attrs \\ %{}) do
      {:ok, blockchain} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Registry.create_blockchain()

      blockchain
    end

    test "list_blockchains/0 returns all blockchains" do
      blockchain = blockchain_fixture()
      assert Registry.list_blockchains() == [blockchain]
    end

    test "get_blockchain!/1 returns the blockchain with given id" do
      blockchain = blockchain_fixture()
      assert Registry.get_blockchain!(blockchain.id) == blockchain
    end

    test "create_blockchain/1 with valid data creates a blockchain" do
      assert {:ok, %Blockchain{} = blockchain} = Registry.create_blockchain(@valid_attrs)
      assert blockchain.name == "some name"
      assert blockchain.symbol == "some symbol"
    end

    test "create_blockchain/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Registry.create_blockchain(@invalid_attrs)
    end

    test "update_blockchain/2 with valid data updates the blockchain" do
      blockchain = blockchain_fixture()
      assert {:ok, %Blockchain{} = blockchain} = Registry.update_blockchain(blockchain, @update_attrs)
      assert blockchain.name == "some updated name"
      assert blockchain.symbol == "some updated symbol"
    end

    test "update_blockchain/2 with invalid data returns error changeset" do
      blockchain = blockchain_fixture()
      assert {:error, %Ecto.Changeset{}} = Registry.update_blockchain(blockchain, @invalid_attrs)
      assert blockchain == Registry.get_blockchain!(blockchain.id)
    end

    test "delete_blockchain/1 deletes the blockchain" do
      blockchain = blockchain_fixture()
      assert {:ok, %Blockchain{}} = Registry.delete_blockchain(blockchain)
      assert_raise Ecto.NoResultsError, fn -> Registry.get_blockchain!(blockchain.id) end
    end

    test "change_blockchain/1 returns a blockchain changeset" do
      blockchain = blockchain_fixture()
      assert %Ecto.Changeset{} = Registry.change_blockchain(blockchain)
    end
  end

  describe "tokens" do
    alias TokenRegistry.Registry.Token

    @valid_attrs %{name: "some name", symbol: "some symbol"}
    @update_attrs %{name: "some updated name", symbol: "some updated symbol"}
    @invalid_attrs %{name: nil, symbol: nil}

    def token_fixture(attrs \\ %{}) do
      {:ok, token} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Registry.create_token()

      token
    end

    test "list_tokens/0 returns all tokens" do
      token = token_fixture()
      assert Registry.list_tokens() == [token]
    end

    test "get_token!/1 returns the token with given id" do
      token = token_fixture()
      assert Registry.get_token!(token.id) == token
    end

    test "create_token/1 with valid data creates a token" do
      assert {:ok, %Token{} = token} = Registry.create_token(@valid_attrs)
      assert token.name == "some name"
      assert token.symbol == "some symbol"
    end

    test "create_token/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Registry.create_token(@invalid_attrs)
    end

    test "update_token/2 with valid data updates the token" do
      token = token_fixture()
      assert {:ok, %Token{} = token} = Registry.update_token(token, @update_attrs)
      assert token.name == "some updated name"
      assert token.symbol == "some updated symbol"
    end

    test "update_token/2 with invalid data returns error changeset" do
      token = token_fixture()
      assert {:error, %Ecto.Changeset{}} = Registry.update_token(token, @invalid_attrs)
      assert token == Registry.get_token!(token.id)
    end

    test "delete_token/1 deletes the token" do
      token = token_fixture()
      assert {:ok, %Token{}} = Registry.delete_token(token)
      assert_raise Ecto.NoResultsError, fn -> Registry.get_token!(token.id) end
    end

    test "change_token/1 returns a token changeset" do
      token = token_fixture()
      assert %Ecto.Changeset{} = Registry.change_token(token)
    end
  end
end
