# Used by "mix format"
locals_without_parens = [
  register: 2,
  import_provider: 1
]

[
  locals_without_parens: locals_without_parens,
  export: [
    locals_without_parens: locals_without_parens
  ],
  inputs: ["{mix,.formatter}.exs", "{config,lib,test}/**/*.{ex,exs}"]
]
