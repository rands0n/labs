defmodule Mastery.Core.Template do
  @moduledoc false

  defstruct ~w(name category instructions raw compiled generators checker)a

  @type t() :: %__MODULE__{
          name: String.t() | nil,
          category: any(),
          instructions: any(),
          raw: any(),
          compiled: any(),
          generators: any(),
          checker: function()
        }

  @spec new(any()) :: %__MODULE__{}
  @doc """
  Creates a new Template.
  """
  def new(fields) do
    raw = Keyword.fetch!(fields, :raw)

    struct!(
      __MODULE__,
      Keyword.put(fields, :compiled, EEx.compile_string(raw))
    )
  end
end
