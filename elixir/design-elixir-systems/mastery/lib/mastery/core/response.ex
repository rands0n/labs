defmodule Mastery.Core.Response do
  @moduledoc false

  defstruct ~w(quiz_title template_name to email answer correct timestamp)a

  @type t() :: %__MODULE__{
          quiz_title: String.t() | nil,
          template_name: String.t() | nil,
          to: String.t() | nil,
          email: String.t() | nil,
          answer: any() | nil,
          correct: any() | nil,
          timestamp: DateTime.t() | nil | any()
        }

  @spec new(any(), any(), any()) :: %__MODULE__{}
  @doc """
  Creates a new Response.
  """
  def new(quiz, email, answer) do
    question = quiz.current_question
    template = question.template

    %__MODULE__{
      quiz_title: quiz.title,
      template_name: template.name,
      to: question.asked,
      email: email,
      answer: answer,
      correct: template.checker.(question.substitutions, answer),
      timestamp: DateTime.utc_now()
    }
  end
end
