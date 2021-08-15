# OnePiece.Commanded

Extend `Commanded` package. A swiss army knife for applications following
Domain-Driven Design (DDD), Event Sourcing (ES), and  Command and Query
Responsibility Segregation (CQRS).

## What is next?

Check the following modules, if you are familiar with DDD, ES, and CQRS they
should be familiar to you.

- Defining an `OnePiece.Commanded.Entity`
- Defining a `OnePiece.Commanded.ValueObject`
- Converting your entity into a `OnePiece.Commanded.Aggregate`
- Defining a `OnePiece.Commanded.Command`
- Handling a command in a `OnePiece.Commanded.CommandHandler`
- Handling a query in a `OnePiece.Commanded.QueryHandler`

## Testing

> We publish some `ExUnit.CaseTemplate` as part of the package, we don't have
> that code to be compiled to production, or maintain a different package we
> must do some workaround the limitations problems, for now.

The test files are under `test/test_support/command_handler_case.ex`, since the
modules is not under `lib` directory, Elixir will not load this module without
importing the file manually:

In your `test_helper.exs`, add the following code-snippet:
      
```elixir
one_piece_commanded_path = Mix.Project.deps_paths()[:one_piece_commanded]
Code.require_file "#{one_piece_commanded_path}/test/test_support/command_handler_case.exs", __DIR__

# ...

ExUnit.start()
```

- `OnePiece.Commanded.TestSupport.CommandHandlerCase`: helps with test cases for
  testing aggregate states, and command handlers.

