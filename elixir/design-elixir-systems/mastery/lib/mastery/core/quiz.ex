defmodule Mastery.Core.Quiz do
  @moduledoc false

  alias Mastery.Core.{Quiz, Template, Question, Response}

  defstruct title: nil,
            mastery: 3,
            templates: %{},
            used: [],
            current_question: nil,
            last_response: nil,
            record: %{},
            mastered: []

  @type t() :: %__MODULE__{
    title: String.t(),
    mastery: integer(),
    templates: any(),
    used: list(),
    current_question: %Question{} | nil,
    last_response: %Response{} | nil,
    record: map(),
    mastered: list()
  }

  @spec new(any()) :: struct
  def new(fields) do
    struct!(__MODULE__, fields)
  end

  @spec select_question(Quiz.t()) :: nil | Quiz.t()
  def select_question(%__MODULE__{templates: t}) when map_size(t) == 0, do: nil
  def select_question(%Quiz{} = quiz) do
    quiz
    |> pick_current_question()
    |> move_template(:used)
    |> reset_template_cycle()
  end

  @spec add_template(%Quiz{}, any()) :: %Quiz{}
  def add_template(%Quiz{} = quiz, fields) do
    template = Template.new(fields)

    templates =
      update_in(
        quiz.templates,
        [template.category],
        &add_to_list_or_nil(&1, template)
      )

    %{quiz | templates: templates}
  end

  @spec answer_question(Quiz.t(), Response.t()) :: Quiz.t()
  def answer_question(%Quiz{} = quiz, %Response{correct: true} = response) do
    new_quiz =
      quiz
      |> inc_record()
      |> save_response(response)

    maybe_advance(new_quiz, mastered?(new_quiz))
  end

  def answer_question(%Quiz{} = quiz, %Response{correct: false} = response) do
    quiz
    |> reset_record()
    |> save_response(response)
  end

  @spec save_response(Quiz.t(), Response.t()) :: Quiz.t()
  def save_response(%Quiz{} = quiz, %Response{} = response) do
    Map.put(quiz, :last_response, response)
  end

  defp inc_record(%Quiz{current_question: question} = quiz) do
    new_record = Map.update(quiz.record, question.template.name, 1, &(&1 + 1))
    Map.put(quiz, :record, new_record)
  end

  defp maybe_advance(%Quiz{} = quiz, false = _mastered), do: quiz
  defp maybe_advance(%Quiz{} = quiz, true = _mastered), do: advance(quiz)

  defp advance(%Quiz{} = quiz) do
    quiz
    |> move_template(:mastered)
    |> reset_record()
    |> reset_used()
  end

  defp reset_record(%Quiz{current_question: %Question{} = question} = quiz) do
    Map.put(quiz, :record, Map.delete(quiz.record, question.template.name))
  end

  defp reset_used(%Quiz{current_question: %Question{} = question} = quiz) do
    Map.put(quiz, :used, List.delete(quiz.used, question.template))
  end

  defp mastered?(%Quiz{} = quiz) do
    score = Map.get(quiz.record, template(quiz).name, 0)
    score == quiz.mastery
  end

  defp pick_current_question(%Quiz{} = quiz) do
    Map.put(
      quiz,
      :current_question,
      select_a_random_question(quiz)
    )
  end

  defp select_a_random_question(%Quiz{} = quiz) do
    quiz.templates
    |> Enum.random()
    |> elem(1)
    |> Enum.random()
    |> Question.new
  end

  defp move_template(%Quiz{} = quiz, field) do
    quiz
    |> remove_template_from_category()
    |> add_template_to_field(field)
  end

  defp remove_template_from_category(%Quiz{} = quiz) do
    template = template(quiz)
    new_category_templates =
      quiz.templates
      |> Map.fetch!(template.category)
      |> List.delete(template)

    new_templates =
      if new_category_templates == [] do
        Map.delete(quiz.templates, template.category)
      else
        Map.put(quiz.templates, template.category, new_category_templates)
      end

    Map.put(quiz, :templates, new_templates)
  end

  defp add_template_to_field(%Quiz{} = quiz, field) do
    template = template(quiz)
    list = Map.get(quiz, field)

    Map.put(quiz, field, [template | list])
  end

  defp reset_template_cycle(%Quiz{templates: templates, used: used} = quiz) when map_size(templates) == 0 do
    %__MODULE__{
      quiz |
      templates: Enum.group_by(used, fn template -> template.category end),
      used: []
    }
  end

  defp reset_template_cycle(%Quiz{} = quiz), do: quiz

  defp template(%Quiz{} = quiz), do: quiz.current_question.template

  defp add_to_list_or_nil(nil, template), do: [template]
  defp add_to_list_or_nil(templates, template), do: [template | templates]
end
