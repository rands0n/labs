defmodule Setter do
  defmacro bind_name(str) do
    quote do
      name = unquote(str)
    end
  end
end

# require Setter

# name = "Chris"

# Setter.bind_name("Max")

# name
