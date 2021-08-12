defmodule Translator do
  defmacro __using__(_opts) do
    quote do
      Module.register_attribute(__MODULE__, :locales, accumulate: true)

      import unquote(__MODULE__), only: [locale: 2]

      @before_compile unquote(__MODULE__)
    end
  end

  defmacro __before_compile__(env) do
    compile(Module.get_attribute(env.module, :locales))
  end

  defmacro locale(name, mappings) do
    quote bind_quoted: [name: name, mappings: mappings] do
      @locales {name, mappings}
    end
  end

  def compile(translations) do
    translations_ast = for {locale, mappings} <- translations do
      deftranslations(locale, "", mappings)
    end

    quote do
      def t(locale, path, bindings \\ [])

      unquote(translations_ast)

      def t(locale, _path, _bindings) do
        {:error, :not_found}
      end
    end
  end

  defp deftranslations(locale, current_path, mappings) do
    # return AST
  end
end

defmodule I18n do
  use Translator

  locale "en",
    flash: [hello: "Hello %{first} %{last}!", bye: "Bye, %{name}!"],
    users: [title: "Users"]

  locale "pt",
    flash: [hello: "Olá %{first} %{last}!", bye: "Tchau, %{name}!"],
    users: [title: "Usuários"]
end
