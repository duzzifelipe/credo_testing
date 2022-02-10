# CredoTesting

CredoTesting gives you a Credo check to ensure all your modules have a corresponding test file.

## Usage

Append the check into your `.credo.exs` file:

```elixir
[
  # ... other checks
  # ...
  {CredoTesting.Check.Warning.EnsureTestFileExistsForModule, []}
]
```

You can specify a list of paths to ignore the validation:

```elixir
[
  # ...
  {CredoTesting.Check.Warning.EnsureTestFileExistsForModule, excluded_paths: ["lib/my_app/application.ex", "lib/my_app_web/openapi_specs"]}
]
```

## Installation

The package can be installed by adding `credo_testing` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:credo_testing, "~> 1.0.0"}
  ]
end
```
