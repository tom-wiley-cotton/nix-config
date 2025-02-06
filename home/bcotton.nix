{
  config,
  pkgs,
  lib,
  unstablePkgs,
  ...
}: let
  nixVsCodeServer = fetchTarball {
    url = "https://github.com/zeyugao/nixos-vscode-server/tarball/master";
    sha256 = "sha256:0p0dz0q1rbccncjgw4na680a5i40w59nbk5ip34zcac8rg8qx381";
  };
in {
  home.stateVersion = "23.05";

  imports = [
    "${nixVsCodeServer}/modules/vscode-server/home.nix"
    ./modules/atuin.nix
    ./modules/tmux-plugins.nix
  ];

  programs.tmux-plugins.enable = true;

  programs.atuin-config = {
    enable-daemon = true;
    nixosKeyPath = "/run/agenix/bcotton-atuin-key";
    darwinKeyPath = "~/.local/share/atuin/key";
    filter_mode = "session";
  };

  # list of programs
  # https://mipmip.github.io/home-manager-option-search

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    tmux.enableShellIntegration = true;
  };

  programs.git = {
    enable = true;
    userEmail = "bob.cotton@gmail.com";
    userName = "Bob Cotton";
    extraConfig = {
      alias = {
        br = "branch";
        co = "checkout";
        ci = "commit";
        d = "diff";
        dc = "diff --cached";
        st = "status";
        la = "config --get-regexp alias";
        lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%C(bold blue)<%an>%Creset' --abbrev-commit";
        lga = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%C(bold blue)<%an>%Creset' --abbrev-commit --all";
      };
      url = {
        "ssh://git@github.com/" = {
          insteadOf = "https://github.com/";
        };
      };
      init.defaultBranch = "main";
      pager.difftool = true;

      core = {
        whitespace = "trailing-space,space-before-tab";
        # pager = "difftastic";
      };
      # interactive.diffFilter = "difft";
      merge.conflictstyle = "diff3";
      diff = {
        # tool = "difftastic";
        colorMoved = "default";
      };
      # difftool."difftastic".cmd = "difft $LOCAL $REMOTE";
    };
    difftastic = {
      enable = false;
      background = "dark";
      display = "side-by-side";
    };
    includes = [
      {path = "${pkgs.delta}/share/themes.gitconfig";}
    ];
    delta = {
      enable = true;
      options = {
        # decorations = {
        #   commit-decoration-style = "bold yellow box ul";
        #   file-decoration-style = "none";
        #   file-style = "bold yellow ul";
        # };
        # features = "mellow-barbet";
        features = "collared-trogon";
        # whitespace-error-style = "22 reverse";
        navigate = true;
        light = false;
        side-by-side = true;
      };
    };
  };

  programs.htop = {
    enable = true;
    settings.show_program_path = true;
  };

  programs.tmux = {
    enable = true;
    keyMode = "vi";
    clock24 = true;
    mouse = true;
    prefix = "C-Space";
    historyLimit = 20000;
    baseIndex = 1;
    aggressiveResize = true;
    # escapeTime = 0;
    terminal = "screen-256color";
    extraConfig = ''
      if-shell "uname | grep -q Darwin" {
        set-option -g default-command "reattach-to-user-namespace -l zsh"
      }

      new-session -s main
      # Vim style pane selection
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # Need to decide if these are the commands I want to use
      bind "C-h" select-pane -L
      bind "C-j" select-pane -D
      bind "C-k" select-pane -U
      bind "C-l" select-pane -R


      # set-option -g status-position top
      set -g renumber-windows on
      set -g set-clipboard on

      set-option -g status-left "#[bg=colour241,fg=colour248] #h #[bg=colour237,fg=colour241,nobold,noitalics,nounderscore]"
      set-option -g status-right "#[bg=colour237,fg=colour239 nobold, nounderscore, noitalics]#[bg=colour239,fg=colour246] %Y-%m-%d  %H:%M #[bg=colour239,fg=colour248,nobold,noitalics,nounderscore]#[bg=colour248,fg=colour237] #S "


      # https://github.com/samoshkin/tmux-config/blob/master/tmux/tmux.conf
      set -g buffer-limit 20
      set -g display-time 1500
      set -g remain-on-exit off
      set -g repeat-time 300
      # setw -g allow-rename off
      # setw -g automatic-rename off

      # Turn off the prefix key when nesting tmux sessions, led to this
      # https://gist.github.com/samoshkin/05e65f7f1c9b55d3fc7690b59d678734?permalink_comment_id=4616322#gistcomment-4616322
      # Whcih led to the tmux-nested plugin

      # keybind to disable outer-most active tmux
      set -g @nested_down_keybind 'M-o'
      # keybind to enable inner-most inactive tmux
      set -g @nested_up_keybind 'M-O'
      # keybind to recursively enable all tmux instances
      set -g @nested_up_recursive_keybind 'M-U'
      # status style of inactive tmux
      set -g @nested_inactive_status_style '#[fg=black,bg=red] #h #[bg=colour237,fg=colour241,nobold,noitalics,nounderscore]'
      set -g @nested_inactive_status_style_target 'status-left'

      # tmux-fzf stuff

      # git-popup: (<prefix> + ctrl-g)
      bind-key C-g display-popup -E -d "#{pane_current_path}" -xC -yC -w 80% -h 75% "lazygit"
      # k9s popup: (<prefix> + ctrl-k)
      bind-key C-k display-popup -E -d "#{pane_current_path}" -xC -yC -w 80% -h 75% "k9s"
      # jq as a popup, from the clipboard
      bind-key C-j display-popup -E -d "#{pane_current_path}" -xC -yC -w 80% -h 75% "pbpaste | jq -C '.' | less -R"
      # btop as a popup
      bind-key C-b display-popup -E -d "#{pane_current_path}" -xC -yC -w 80% -h 75% "btop"
    '';
  };

  services.vscode-server.enable = true;
  services.vscode-server.installPath = [
    "$HOME/.vscode-server"
    "$HOME/.cursor-server"
  ];

  # TODO: add ~/bin
  # code --remote ssh-remote+<remoteHost> <remotePath>

  home.file."oh-my-zsh-custom" = {
    enable = true;
    source = ./oh-my-zsh-custom;
    target = ".oh-my-zsh-custom";
  };

  xdg = {
    enable = true;
    configFile."containers/registries.conf" = {
      source = ./dot.config/containers/registries.conf;
    };
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    defaultKeymap = "emacs";
    autocd = true;

    cdpath = [
      "."
      ".."
      "../.."
      "~"
      "~/projects"
    ];

    dirHashes = {
      docs = "$HOME/Documents";
      proj = "$HOME/projects";
      dl = "$HOME/Downloads";
    };

    # atuin register -u bcotton -e bob.cotton@gmail.com
    envExtra = ''
      #export DOCKER_HOST="unix://$HOME/.docker/run/docker.sock"
      export BAT_THEME="Visual Studio Dark+"
      export DFT_DISPLAY=side-by-side
      export EDITOR=vim
      export EMAIL=bob.cotton@gmail.com
      export EXA_COLORS="da=1;35"
      export FULLNAME='Bob Cotton'
      export GOPATH=$HOME/go
      export GOPRIVATE="github.com/grafana/*"
      export LESS="-iMSx4 -FXR"
      export OKTA_MFA_OPTION=1
      export PAGER=less
      export PATH=$GOPATH/bin:/opt/homebrew/share/google-cloud-sdk/bin:~/projects/deployment_tools/scripts/gcom:~/projects/grafana-app-sdk/target:$PATH
      export QMK_HOME=~/projects/qmk_firmware
      export TMPDIR=/tmp/
      export XDG_CONFIG_HOME="$HOME/.config"

      export FZF_CTRL_R_OPTS="--reverse"
      export FZF_TMUX_OPTS="-p"

      export ZSH_AUTOSUGGEST_STRATEGY=(history completion)

      export NVM_DIR="$HOME/.nvm"
      [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
      [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

      if [ -e "/var/run/user/1000/podman/podman.sock" ]; then
         export DOCKER_HOST=unix:///run/user/1000/podman/podman.sock
         export DOCKER_BUILDKIT=0
      fi

      [ -e ~/.config/sensitive/.zshenv ] && \. ~/.config/sensitive/.zshenv
    '';

    oh-my-zsh = {
      enable = true;
      custom = "$HOME/.oh-my-zsh-custom";

      theme = "git-taculous";
      # theme = "agnoster-nix";

      extraConfig = ''
        zstyle :omz:plugins:ssh-agent identities id_ed25519
        if [[ `uname` == "Darwin" ]]; then
          zstyle :omz:plugins:ssh-agent ssh-add-args --apple-load-keychain
        fi
        source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
      '';
      plugins = [
        "brew"
        "bundler"
        "colorize"
        "dotenv"
        "fzf"
        "git"
        "git-reflog-fzf"
        "gh"
        "kubectl"
        "kube-ps1"
        "ssh-agent"
        "tmux"
      ];
    };

    shellAliases = {
      # Automatically run `go test` for a package when files change.
      autotest = "watchexec -c clear -o do-nothing --delay-run 100ms --exts go 'pkg=\".\${WATCHEXEC_COMMON_PATH/\$PWD/}/...\"; echo \"running tests for \$pkg\"; go test \"\$pkg\"'";
      batj = "bat -l json";
      batly = "bat -l yaml";
      batmd = "bat -l md";
      dir = "exa -l --icons --no-user --group-directories-first  --time-style long-iso --color=always";
      gdn = "git diff | gitnav";
      k = "kubectl";
      kctx = "kubectx";
      kns = "kubens";
      ltr = "ll -snew";
      tf = "terraform";
      tree = "exa -Tl --color=always";
      # watch = "watch --color "; # Note the trailing space for alias expansion https://unix.stackexchange.com/questions/25327/watch-command-alias-expansion
      watch = "viddy ";
      # z = "zoxide";
    };

    initExtra = ''
      source <(kubectl completion zsh)
      eval "$(tv init zsh)"
      eval "$(atuin init zsh --disable-up-arrow)"
      eval "$(zoxide init zsh)"

      bindkey -e
      bindkey '^[[A' up-history
      bindkey '^[[B' down-history
      #bindkey -M
      bindkey '\M-\b' backward-delete-word
      bindkey -s "^Z" "^[Qls ^D^U^[G"
      bindkey -s "^X^F" "e "

      setopt autocd autopushd autoresume cdablevars correct correctall extendedglob globdots histignoredups longlistjobs mailwarning  notify pushdminus pushdsilent pushdtohome rcquotes recexact sunkeyboardhack menucomplete always_to_end hist_allow_clobber no_share_history
      unsetopt bgnice


    '';

    #initExtra = (builtins.readFile ../mac-dot-zshrc);
  };

  programs.eza.enable = true;
  programs.home-manager.enable = true;
  #  programs.neovim.enable = true;
  programs.nix-index.enable = true;
  #  programs.zoxide.enable = true;

  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host *
        StrictHostKeyChecking no
        ForwardAgent yes

      Host github.com
        Hostname ssh.github.com
        Port 443
    '';
    matchBlocks = {
    };
  };

  home.packages = with pkgs; [
    kubernetes-helm
    kubectx
    kubectl
    unstablePkgs.aider-chat
    tldr
    zoxide
    #   ## unstable
    #   unstablePkgs.yt-dlp
    #   unstablePkgs.terraform

    #   ## stable
    #   ansible
    #   asciinema
    #   bitwarden-cli
    #   coreutils
    #   # direnv # programs.direnv
    #   #docker
    #   drill
    #   du-dust
    #   dua
    #   duf
    #   esptool
    #   ffmpeg
    #   fd
    #   #fzf # programs.fzf
    #   #git # programs.git
    #   gh
    #   go
    #   gnused
    #   #htop # programs.htop
    #   hub
    #   hugo
    #   ipmitool
    #   jetbrains-mono # font
    #   just
    #   jq
    #   mas # mac app store cli
    #   mc
    #   mosh
    #   neofetch
    #    nmap
    #      (python311.withPackages(ps: with ps; [ libtmux ]))
    #   ripgrep
    #   skopeo
    #   smartmontools
    #   tree
    #   unzip
    #   watch
    #   wget
    #   wireguard-tools
  ];
}
