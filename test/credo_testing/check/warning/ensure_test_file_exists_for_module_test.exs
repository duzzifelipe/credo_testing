defmodule CredoTesting.Check.Warning.EnsureTestFileExistsForModuleTest do
  use Credo.Test.Case

  @described_check CredoTesting.Check.Warning.EnsureTestFileExistsForModule

  test "should issue when test file doesn't exist" do
    message =
      "The file doesn't have a corresponding test file at the expected path `test/app_test.exs`"

    assert [issue] =
             """
             defmodule App do
             end
             """
             |> to_source_file("lib/app.ex")
             |> run_check(@described_check)

    assert %Credo.Issue{check: @described_check, message: ^message} = issue
  end

  test "should issue when existent test file doesn't match the expected" do
    test_path = "test/fake_test.exs"

    on_exit(fn ->
      File.rm!(test_path)
    end)

    file =
      to_source_file(
        """
        defmodule SampleApp do
        end
        """,
        "lib/sample_app.ex"
      )

    File.write!(test_path, "")

    assert [%Credo.Issue{}] = run_check(file, @described_check)
  end

  test "should NOT issue when test file exists" do
    test_path = "test/sample_app_test.exs"

    on_exit(fn ->
      File.rm!(test_path)
    end)

    file =
      to_source_file(
        """
        defmodule SampleApp do
        end
        """,
        "lib/sample_app.ex"
      )

    File.write!(test_path, "")

    assert [] = run_check(file, @described_check)
  end

  test "should NOT issue for a file present in excluded_paths" do
    assert [] =
             """
             defmodule App do
             end
             """
             |> to_source_file("lib/app.ex")
             |> run_check(@described_check, excluded_paths: ["lib/"])
  end
end
