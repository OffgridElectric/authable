{:ok, _} = Application.ensure_all_started(:ex_machina)
{:ok, _} = Authable.Repo.start_link()

ExUnit.start()
