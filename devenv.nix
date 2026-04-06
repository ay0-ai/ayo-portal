{ pkgs, ... }:

{
  # System packages available in the dev shell
  packages = with pkgs; [
    # Node
    nodejs_20
    yarn

    # Database & cache
    postgresql_16
    redis

    # PDF generation
    wkhtmltopdf
    cairo
    pango
    gdk-pixbuf

    # mysqlclient build dependency (Frappe requires it even when using PostgreSQL)
    libmysqlclient

    # Build dependencies for Python packages
    pkg-config
    libffi
    openssl
    zlib
    freetype
    lcms2
    libwebp
    libxml2
    libxslt

    # Frappe needs these at runtime
    git
    curl
  ];

  # Python via devenv's language module — creates a venv automatically
  languages.python = {
    enable = true;
    package = pkgs.python312;
    venv.enable = true;
    venv.requirements = ''
      frappe-bench
    '';
  };

  # Environment variables
  env = {
    # Tells bench not to prompt for confirmation
    CI = "1";
  };

  # Services managed by devenv (start with `devenv up`)
  services.postgres = {
    enable = true;
    package = pkgs.postgresql_16;
    listen_addresses = "127.0.0.1";
    initialDatabases = [{ name = "ayo"; }];
  };

  services.redis = {
    enable = true;
  };

  enterShell = ''
    echo "Ay0ne Portal dev environment"
    echo "  Python:  $(python3 --version)"
    echo "  Node:    $(node --version)"
    echo "  Postgres: $(psql --version 2>/dev/null || echo 'managed by devenv')"
    echo ""
    echo "Run 'devenv up' to start PostgreSQL and Redis services."
    echo "Run 'bench start' to start the Frappe dev server."
  '';
}
