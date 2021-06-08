defmodule TokenRegistry.Registry do
  @moduledoc """
  The Registry context.
  """

  import Ecto.Query
  alias TokenRegistry.Repo

  alias TokenRegistry.Registry.Token

  @doc """
  Returns the list of tokens.

  ## Examples

      iex> list_tokens()
      [%Token{}, ...]

  """
  def list_tokens do
    Repo.all(Token |> order_by(asc: :symbol))
  end





  def paginate_tokens(params \\ []) do
    IO.inspect({"paginate_tokens", params})
    [field| [direction|_]] = String.split(params["sort"], ".")
    p = { String.to_existing_atom(direction), String.to_existing_atom(field) }
    IO.inspect({"paginate_tokens", p})
    Token
    |> order_by( ^p )
    |> Ecto.Queryable.to_query()
    |> Repo.paginate(params)
  end




  def search_tokens(query) do
    like_q = query<>"%"
    Ecto.Query.from(t in Token, where: ilike(t.name, ^like_q) or ilike(t.symbol, ^like_q))
    |> order_by(asc: :symbol)
    |> Repo.all
  end

  def fuzzysearch_tokens(search_phrase) do
    start_character = String.slice(search_phrase, 0..1)

    from(
      t in Token,
      where: ilike(t.symbol, ^"#{start_character}%"),
      where: ilike(t.name, ^"#{start_character}%"),
      where: fragment("SIMILARITY(?, ?) > 0",  t.symbol, ^search_phrase),
      where: fragment("SIMILARITY(?, ?) > 0",  t.name, ^search_phrase),
      order_by: fragment("LEVENSHTEIN(?, ?)", t.name, ^search_phrase)
    )
    |> Repo.all()
  end


  @doc """
  Gets a single token.

  Raises `Ecto.NoResultsError` if the Token does not exist.

  ## Examples

      iex> get_token!(123)
      %Token{}

      iex> get_token!(456)
      ** (Ecto.NoResultsError)

  """
  def get_token!(id), do: Repo.get!(Token, id)

  @doc """
  Creates a token.

  ## Examples

      iex> create_token(%{field: value})
      {:ok, %Token{}}

      iex> create_token(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_token(attrs \\ %{}) do
    %Token{}
    |> Token.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a token.


  ## Examples

      iex> update_token(token, %{field: new_value})
      {:ok, %Token{}}

      iex> update_token(token, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_token(%Token{} = token, attrs) do
    token
    |> Token.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a token.

  ## Examples

      iex> delete_token(token)
      {:ok, %Token{}}

      iex> delete_token(token)
      {:error, %Ecto.Changeset{}}

  """
  def delete_token(%Token{} = token) do
    Repo.delete(token)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking token changes.

  ## Examples

      iex> change_token(token)
      %Ecto.Changeset{data: %Token{}}

  """
  def change_token(%Token{} = token, attrs \\ %{}) do
    Token.changeset(token, attrs)
  end

  alias TokenRegistry.Registry.Blockchain

  @doc """
  Returns the list of blockchains.

  ## Examples

      iex> list_blockchains()
      [%Blockchain{}, ...]

  """
  def list_blockchains do
    Repo.all(Blockchain)
  end

  @doc """
  Gets a single blockchain.

  Raises `Ecto.NoResultsError` if the Blockchain does not exist.

  ## Examples

      iex> get_blockchain!(123)
      %Blockchain{}

      iex> get_blockchain!(456)
      ** (Ecto.NoResultsError)

  """
  def get_blockchain!(id), do: Repo.get!(Blockchain, id)

  @doc """
  Creates a blockchain.

  ## Examples

      iex> create_blockchain(%{field: value})
      {:ok, %Blockchain{}}

      iex> create_blockchain(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_blockchain(attrs \\ %{}) do
    %Blockchain{}
    |> Blockchain.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a blockchain.

  ## Examples

      iex> update_blockchain(blockchain, %{field: new_value})
      {:ok, %Blockchain{}}

      iex> update_blockchain(blockchain, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_blockchain(%Blockchain{} = blockchain, attrs) do
    blockchain
    |> Blockchain.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a blockchain.

  ## Examples

      iex> delete_blockchain(blockchain)
      {:ok, %Blockchain{}}

      iex> delete_blockchain(blockchain)
      {:error, %Ecto.Changeset{}}

  """
  def delete_blockchain(%Blockchain{} = blockchain) do
    Repo.delete(blockchain)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking blockchain changes.

  ## Examples

      iex> change_blockchain(blockchain)
      %Ecto.Changeset{data: %Blockchain{}}

  """
  def change_blockchain(%Blockchain{} = blockchain, attrs \\ %{}) do
    Blockchain.changeset(blockchain, attrs)
  end
end
