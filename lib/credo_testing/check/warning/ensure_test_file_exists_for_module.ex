defmodule CredoTesting.Check.Warning.EnsureTestFileExistsForModule do
  @moduledoc false

  use Credo.Check,
    base_priority: :low,
    category: :warning,
    tags: [:testing],
    explanations: [
      check: """
      If an Elixir file is defined inside the "lib" folder, this check
      expects that a corresponding file is written in the "test" folder
      following the same path and a sufix "_test.exs"
      """,
      params: [
        excluded_paths: "A list of paths to exclude from validation"
      ]
    ],
    param_defaults: [
      excluded_paths: []
    ]

  @doc false
  def run(source_file, params \\ []) do
    excluded_paths = Params.get(params, :excluded_paths, __MODULE__)
    issue_meta = IssueMeta.for(source_file, params)
    file_name = source_file.filename

    if String.starts_with?(file_name, excluded_paths) do
      []
    else
      run_validation(file_name, issue_meta)
    end
  end

  defp run_validation(file_name, issue_meta) do
    test_file = test_file_from_filename(file_name)

    if File.exists?(test_file) do
      []
    else
      message =
        "The file doesn't have a corresponding test file at the expected path `#{test_file}`"

      [format_issue(issue_meta, message: message, trigger: file_name)]
    end
  end

  defp test_file_from_filename(filename) do
    parts = String.split(filename, "/")

    parts
    |> List.replace_at(0, "test")
    |> List.update_at(-1, &add_test_sufix/1)
    |> Enum.join("/")
  end

  defp add_test_sufix(file_name) do
    regex = ~r/^(.+).ex$/

    if Regex.match?(regex, file_name) do
      Regex.replace(regex, file_name, "\\1_test.exs")
    end
  end
end
