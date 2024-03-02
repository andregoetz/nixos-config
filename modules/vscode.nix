{ unstable, ... }:

let
  system = builtins.currentSystem;
  extensions = (import (builtins.fetchGit {
    url = "https://github.com/nix-community/nix-vscode-extensions";
    ref = "refs/heads/master";
  })).extensions.${system};

  marketplace-extensions = with extensions.vscode-marketplace; [
    bierner.markdown-preview-github-styles
    cardinal90.multi-cursor-case-preserve
    christian-kohler.npm-intellisense
    dhruv.maven-dependency-explorer
    donjayamanne.python-environment-manager
    ecmel.vscode-html-css
    github.remotehub
    hbenl.vscode-test-explorer
    janisdd.vscode-edit-csv
    jasonnutter.search-node-modules
    kevinrose.vsc-python-indent
    littlefoxteam.vscode-python-test-adapter
    maptz.camelcasenavigation
    ms-vscode-remote.remote-ssh-edit
    ms-vscode.remote-explorer
    ms-vscode.remote-repositories
    ms-vscode.test-adapter-converter
    nico-castell.linux-desktop-file
    p1c2u.docker-compose
    pflannery.vscode-versionlens
    pixl-garden.bongocat
    poletaev-d.java-string-literal-tools
    pranaygp.vscode-css-peek
    redhat.ansible
    remisa.shellman
    rogalmic.bash-debug
    rokoroku.vscode-theme-darcula
    rpinski.shebang-snippets
    shengchen.vscode-checkstyle
    slhsxcmy.vscode-double-line-numbers
    streetsidesoftware.code-spell-checker-german
    visualstudioexptteam.intellicode-api-usage-examples
    visualstudioexptteam.vscodeintellicode
    vmware.vscode-spring-boot
    vscjava.vscode-spring-boot-dashboard
    xabikos.javascriptsnippets
    zignd.html-css-class-completion
    zokugun.cron-tasks
    zokugun.sync-settings
  ];

  nixpkgs-extensions = with unstable.vscode-extensions; [
    alefragnani.bookmarks
    alefragnani.project-manager
    arrterian.nix-env-selector
    batisteo.vscode-django
    bierner.markdown-checkbox
    christian-kohler.path-intellisense
    codezombiech.gitignore
    dbaeumer.vscode-eslint
    eamodio.gitlens
    formulahendry.auto-rename-tag
    github.codespaces
    github.copilot
    github.copilot-chat
    github.vscode-pull-request-github
    golang.go
    grapecity.gc-excelviewer
    gruntfuggly.todo-tree
    jnoortheen.nix-ide
    johnpapa.vscode-peacock
    mads-hartmann.bash-ide-vscode
    mechatroner.rainbow-csv
    mhutchie.git-graph
    ms-azuretools.vscode-docker
    ms-python.python
    ms-python.vscode-pylance
    ms-toolsai.jupyter
    ms-toolsai.jupyter-keymap
    ms-toolsai.jupyter-renderers
    ms-toolsai.vscode-jupyter-cell-tags
    ms-toolsai.vscode-jupyter-slideshow
    ms-vscode-remote.remote-containers
    ms-vscode-remote.remote-ssh
    ms-vscode.live-server
    ms-vscode.makefile-tools
    njpwerner.autodocstring
    pkief.material-icon-theme
    redhat.java
    redhat.vscode-xml
    redhat.vscode-yaml
    shardulm94.trailing-spaces
    skellock.just
    sonarsource.sonarlint-vscode
    streetsidesoftware.code-spell-checker
    tamasfe.even-better-toml
    usernamehw.errorlens
    vscjava.vscode-java-debug
    vscjava.vscode-java-dependency
    vscjava.vscode-java-test
    vscjava.vscode-maven
    vscjava.vscode-spring-initializr
    vscodevim.vim
    wholroyd.jinja
    wmaurer.change-case
    yzhang.markdown-all-in-one
  ];
in
{
  # unfree predicate
  unfree-predicate = [
    "vscode"
    "vscode-with-extensions"
    "vscode-extension-github-codespaces"
    "vscode-extension-github-copilot"
    "vscode-extension-github-copilot-chat"
    "vscode-extension-MS-python-vscode-pylance"
    "vscode-extension-ms-vscode-remote-remote-containers"
    "vscode-extension-ms-vscode-remote-remote-ssh"
  ];

  # overlay for extensions and what vscode version
  overlay = final: prev: {
    vscode = unstable.vscode;
    vscodeExtensions = nixpkgs-extensions ++ marketplace-extensions;
  };
}
