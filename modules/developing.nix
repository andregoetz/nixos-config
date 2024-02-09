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
}
