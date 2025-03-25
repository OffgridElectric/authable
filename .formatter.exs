[
  import_deps: [:ecto_sql, :ecto],
  inputs: ["*.{ex,exs}", "{config,lib,web,test,priv}/**/*.{ex,exs}"],
  subdirectories: ["priv/*/migrations"]
]
