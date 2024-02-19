{
  # git
  programs.git = {
    enable = true;
    config = {
      push = {
        autoSetupRemote = true;
      };
      init = {
        defaultBranch = "main";
      };
      commit = {
        gpgsign = true;
      };
    };
  };

  # docker
  virtualisation.docker = {
    enable = true;
    # doesnt work for plantuml so not using (at least till exam)
    # rootless = {
    #   enable = true;
    #   setSocketVariable = true;
    # };
  };
}
