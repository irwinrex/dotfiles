-- Treesitter configuration
return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "VeryLazy",
    init = function()
      vim.filetype.add({
        extension = {
          -- Terraform / HCL
          tf = "terraform",
          tfvars = "terraform",
          tfstate = "json",
          hcl = "hcl",
          -- Helm
          gotmpl = "gotmpl",
          -- Jsonnet
          jsonnet = "jsonnet",
          libsonnet = "jsonnet",
          -- Starlark / Bazel
          bzl = "starlark",
          bazel = "starlark",
          -- Nix
          nix = "nix",
          -- Just
          justfile = "just",
        },
        filename = {
          ["Dockerfile"] = "dockerfile",
          ["Jenkinsfile"] = "groovy",
          ["Vagrantfile"] = "ruby",
          [".envrc"] = "bash",
          ["Tiltfile"] = "starlark",
          ["BUILD"] = "starlark",
          ["WORKSPACE"] = "starlark",
        },
        pattern = {
          ["docker%-compose.*%.ya?ml"] = "yaml",
          ["%.github/workflows/.*"] = "yaml",
          ["Dockerfile%..*"] = "dockerfile",
        },
      })
    end,
    opts = {
      ensure_installed = {

        -- ── Core Vim ────────────────────────────────────────────────────
        "lua",
        "vim",
        "vimdoc",
        "query",
        "regex",

        -- ── Systems & Low-level ─────────────────────────────────────────
        "c",
        "cpp",
        "rust",
        "go",
        "gomod",
        "gosum",
        "gowork",
        "zig",
        "odin",
        "cuda",
        "arduino",

        -- ── JVM ─────────────────────────────────────────────────────────
        "java",
        "kotlin",
        "scala",
        "groovy", -- Jenkinsfile

        -- ── .NET / Microsoft ────────────────────────────────────────────
        "c_sharp",
        "bicep", -- Azure Bicep IaC

        -- ── Scripting ───────────────────────────────────────────────────
        "python",
        "ruby",
        "perl",
        "lua",
        "r",
        "elixir",
        "erlang",
        "gleam",

        -- ── Functional ──────────────────────────────────────────────────
        "haskell",
        "ocaml",
        "ocaml_interface",
        "elm",
        "clojure",
        "commonlisp",
        "scheme",

        -- ── Web – Frontend ──────────────────────────────────────────────
        "html",
        "css",
        "scss",
        "javascript",
        "typescript",
        "tsx",
        "astro",
        "svelte",
        "vue",
        "angular",
        "jsdoc",
        "graphql",

        -- ── Web – Backend / Templating ──────────────────────────────────
        "php",
        "php_only",
        "twig",
        "gotmpl", -- Go / Helm templates
        "htmldjango",
        "jinja",

        -- ── Mobile ──────────────────────────────────────────────────────
        "swift",
        "dart",

        -- ── Data / Config ────────────────────────────────────────────────
        "json",
        "json5",
        "jsonc",
        "yaml",
        "toml",
        "xml",
        "csv",
        "tsv",
        "ini",
        "properties", -- Java .properties / systemd unit files
        "sql",
        "prisma",

        -- ── DevOps – IaC ─────────────────────────────────────────────────
        "terraform", -- .tf files
        "hcl", -- Terragrunt / Packer raw HCL
        "bicep", -- Azure Bicep (also listed under .NET)

        -- ── DevOps – Containers & Orchestration ──────────────────────────
        "dockerfile",
        "helm", -- Helm chart helpers

        -- ── DevOps – CI/CD ───────────────────────────────────────────────
        "logfmt", -- Loki structured log lines
        "promql", -- Prometheus / Thanos / Cortex queries
        "ql", -- CodeQL (GitHub Advanced Security)

        -- ── DevOps – Build Systems ────────────────────────────────────────
        "make",
        "cmake",
        "ninja",
        "starlark", -- Bazel BUILD / Tiltfile
        "meson",
        "just", -- Justfile task runner

        -- ── DevOps – Scripting & Shell ────────────────────────────────────
        "bash",
        "fish",
        "zsh", -- uses bash parser
        "awk",

        -- ── DevOps – Networking / Security ───────────────────────────────
        "nginx",
        "apache", -- Apache httpd config  (community parser)
        "passwd", -- /etc/passwd
        "hosts", -- /etc/hosts
        "dot", -- Graphviz .dot diagrams (network topologies)
        "ssh_config",

        -- ── Package Managers / Lockfiles ─────────────────────────────────
        "requirements", -- pip requirements.txt
        "pymanifest", -- MANIFEST.in

        -- ── Docs & Markup ─────────────────────────────────────────────────
        "markdown",
        "markdown_inline",
        "latex",
        "rst", -- reStructuredText (Sphinx docs)
        "asciidoc",
        "djot",

        -- ── Serialisation / Wire Formats ──────────────────────────────────
        "proto", -- Protocol Buffers
        "thrift",
        "avro", -- uses JSON parser
        "capnp",

        -- ── Misc ──────────────────────────────────────────────────────────
        "diff",
        "git_config",
        "git_rebase",
        "gitcommit",
        "gitignore",
        "gitattributes",
        "nix",
        "jsonnet",
        "cue", -- CUE lang (k8s config validation)
        "passwd",
        "pem", -- TLS certs
        "comment", -- highlights TODO/FIXME/HACK across all languages
      },

      sync_install = false,
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = "nvim-treesitter/nvim-treesitter",
  },
}
