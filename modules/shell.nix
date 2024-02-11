{ pkgs, ... }:

let
  andiru-zsh-theme = pkgs.callPackage ../derivations/andiru-zsh-theme.nix { };
in
{
  # shell
  users.defaultUserShell = pkgs.zsh;
  environment.shellAliases = {
    disex = "disown & exit";
    dur = "duration";
    nrbs = "sudo nixos-rebuild switch";
    nrbt = "sudo nixos-rebuild test";
    init_encrypt = "decrypt";
    reencrypt = "encrypt";
    ghrvw = "gh repo view --web";
  };
  environment.interactiveShellInit = ''
    duration() {
      for i in $*; do
        echo -n "$(basename $i): "
    ffmpeg -i "$i" 2>&1 | grep Duration | cut -d ' ' -f 4 | sed s/,//
      done
    }
    dursum() {
      sum=0
      for i in $*; do
        sum=$(($sum + $(ffmpeg -i "$i" 2>&1 | grep Duration | cut -d ' ' -f 4 | sed s/,// | sed 's@\..*@@g' | awk '{ split($1, A, ":"); split(A[3], B, "."); print 3600*A[1] + 60*A[2] + B[1] }')))
      done
      tmp=$(($sum / 60))
      s=$(($sum % 60))
      min=$(($tmp % 60))
      h=$(($tmp / 60))
      echo "total duration: $h:$min:$s"
    }
    rn() {
      dir="$(dirname $1)"
      nf="$dir/$2"
      mv "$1" "$nf"
    }
    lns() {
      dir="$(pwd)"
      ln -s "$dir/$1" "$2"
    }
    rgg () {
      git rev-list --all | xargs git grep "$*"
    }
    encrypt() {
      dir="$(readlink -f $1)"
      fusermount -u "$dir" && rm -r "$dir"
    }
    decrypt() {
      en="$(readlink -f $1)"
      ori="$(readlink -f $2)"
      mkdir "$ori"
      encfs "$en" "$ori"
    }
    dec_pdf() {
      if [[ $1 == *.pdf ]]; then
        echo -n "Enter password: "
        read -s pw; echo
        file="$1"
        mv "$file" "enc_$file"
        qpdf --password=$pw --decrypt "enc_$file" "$file"
        rm "enc_$file"
      fi
    }
  '';

  # zsh
  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    autosuggestions.enable = true;
    ohMyZsh = {
      enable = true;
      theme = "andiru";
      plugins = [
        "git"
        "sudo"
        "colorize"
        "zoxide"
        "python"
        "common-aliases"
        "mvn"
        "copyfile"
        "copypath"
        "cp"
        "dirhistory"
        "vi-mode"
      ];
      customPkgs = [
        andiru-zsh-theme
      ];
    };
  };
}
