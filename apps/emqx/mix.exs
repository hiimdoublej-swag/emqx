defmodule EMQX.MixProject do
  use Mix.Project

  def project do
    [
      app: :emqx,
      version: "5.0.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.12",
      # start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "EMQ X"
    ]
  end

  def application do
    [
      mod: {:emqx_app, []},
      extra_applications: [:logger, :os_mon, :syntax_tools]
    ]
  end

  defp deps do
    [
      # {:gproc, "0.9.0"},
      # {:recon, "2.5.2"},
      {:cowboy, github: "emqx/cowboy", tag: "2.8.3"},
      {:esockd, github: "emqx/esockd", tag: "5.9.0"},
      {:gproc, github: "uwiger", tag: "0.8.0"},
      {:ekka, github: "emqx/ekka", tag: "0.11.1"},
      # {:gen_rpc, github: "emqx/gen_rpc", tag: "2.5.1"},
      # {:cuttlefish, github: "emqx/cuttlefish", tag: "v4.0.1"},
      {:hocon, github: "emqx/hocon", tag: "0.22.0"},
      # {:pbkdf2, github: "emqx/erlang-pbkdf2", tag: "2.0.4"},
      # {:snabbkaffe, github: "kafka4beam/snabbkaffe", tag: "0.14.0"},
      # {:jiffy, github: "emqx/jiffy", tag: "1.0.5"},
      {:lc, github: "qzhuyan/lc", tag: "0.1.2"},
    ]
  end
end
