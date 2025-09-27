{
  config,
  pkgs,
  lib,
  unstablePkgs,
  ...
}: let
  # See https://haseebmajid.dev/posts/2023-07-10-setting-up-tmux-with-nix-home-manager/
  tmux-window-name =
    pkgs.tmuxPlugins.mkTmuxPlugin
    {
      pluginName = "tmux-window-name";
      version = "head";
      src = pkgs.fetchFromGitHub {
        owner = "ofirgall";
        repo = "tmux-window-name";
        rev = "dc97a79ac35a9db67af558bb66b3a7ad41c924e7";
        sha256 = "sha256-o7ZzlXwzvbrZf/Uv0jHM+FiHjmBO0mI63pjeJwVJEhE=";
      };
    };
  tmux-fzf-head =
    pkgs.tmuxPlugins.mkTmuxPlugin
    {
      pluginName = "tmux-fzf";
      version = "head";
      rtpFilePath = "main.tmux";
      src = pkgs.fetchFromGitHub {
        owner = "sainnhe";
        repo = "tmux-fzf";
        rev = "6b31cbe454649736dcd6dc106bb973349560a949";
        sha256 = "sha256-RXoJ5jR3PLiu+iymsAI42PrdvZ8k83lDJGA7MQMpvPY=";
      };
    };
  tmux-nested =
    pkgs.tmuxPlugins.mkTmuxPlugin
    {
      pluginName = "tmux-nested";
      version = "target-style-config";
      src = pkgs.fetchFromGitHub {
        owner = "bcotton";
        repo = "tmux-nested";
        rev = "2878b1d05569a8e41c506e74756ddfac7b0ffebe";
        sha256 = "sha256-w0bKtbxrRZFxs2hekljI27IFzM1pe1HvAg31Z9ccs0U=";
      };
    };
  nixVsCodeServer = fetchTarball {
    url = "https://github.com/msteen/nixos-vscode-server/tarball/master";
    sha256 = "sha256:1rdn70jrg5mxmkkrpy2xk8lydmlc707sk0zb35426v1yxxka10by";
  };

  rose-pine-hyprcursor = pkgs.fetchFromGitHub {
    owner = "ndom91";
    repo = "rose-pine-hyprcursor";
    rev = "4b02963d0baf0bee18725cf7c5762b3b3c1392f1";
    sha256 = "sha256-ouuA8LVBXzrbYwPW2vNjh7fC9H2UBud/1tUiIM5vPvM="; # Replace with the correct SHA256
  };
in {
  home.stateVersion = "25.05";

  imports = [
    "${nixVsCodeServer}/modules/vscode-server/home.nix"
    ./modules/atuin.nix
  ];

  programs.atuin-config = {
    # Create this in agenix
    # nixosKeyPath = "/run/agenix/tomcotton-atuin-key";
    darwinKeyPath = "~/.local/share/atuin/key";
  };

  # list of programs
  # https://mipmip.github.io/home-manager-option-search

  home.file."dotfiles" = {
    enable = true;
    recursive = true;
    source = ./tomcotton.config;
    target = "tmp/..";
  };
  home.file."dummy" = {
    enable = true;
    source = ./tomcotton.config/tmp/dummy;
    target = "tmp/dummy";
  };

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
    userEmail = "thomaswileycotton@gmail.com";
    userName = "wileycotton";
    extraConfig = {
      alias = {
        # br = "branch";
        # co = "checkout";
        # ci = "commit";
        # d = "diff";
        # dc = "diff --cached";
        # la = "config --get-regexp alias";
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
    # difftastic = {
    #   enable = false;
    #   background = "dark";
    #   display = "side-by-side";
    # };
    includes = [
      {path = "${pkgs.delta}/share/themes.gitconfig";}
    ];
    # delta = {
    #   enable = true;
    #   options = {
    #     # decorations = {
    #     #   commit-decoration-style = "bold yellow box ul";
    #     #   file-decoration-style = "none";
    #     #   file-style = "bold yellow ul";
    #     # };
    #     # features = "mellow-barbet";
    #     features = "collared-trogon";
    #     # whitespace-error-style = "22 reverse";
    #     navigate = true;
    #     light = false;
    #     side-by-side = true;
    #   };
    # };
  };

  programs.htop = {
    enable = true;
    settings.show_program_path = true;
  };

  programs.tmux = {
    enable = true;
    keyMode = "vi"; # Seems fine? May mess with keybindings
    clock24 = true;
    mouse = true;
    prefix = "C-b";
    historyLimit = 20000;
    baseIndex = 1;
    aggressiveResize = true;
    # escapeTime = 0;
    terminal = "screen-256color";
    plugins = with pkgs.tmuxPlugins; [
      gruvbox
      tmux-colors-solarized

      # Default: <prefix> + u - show and open urls
      fzf-tmux-url

      # Run the latest tmux-fzf
      tmux-fzf-head

      # Default <prefix> + space - show a list of things to copy
      tmux-thumbs
      {
        plugin = tmux-window-name;
      }
    ];
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


      bind-key "C-f" run-shell -b "${tmux-fzf-head}/share/tmux-plugins/tmux-fzf/scripts/session.sh switch"

      # set-option -g status-position top
      set -g renumber-windows on
      set -g set-clipboard on

      set-option -g status-left "#[bg=colour241,fg=colour248] #h #[bg=colour237,fg=colour241,nobold,noitalics,nounderscore]"
      set-option -g status-right "#[bg=colour237,fg=colour239 nobold, nounderscore, noitalics]#[bg=colour239,fg=colour246] %Y-%m-%d  %H:%M #[bg=colour239,fg=colour248,nobold,noitalics,nounderscore]#[bg=colour248,fg=colour237] #S "


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
      set -g @nested_inactive_status_style '#[fg=black,bg=red] #h #[bg=colour237,fg=colour241,nobold,noitalics,nounderscore]'
      set -g @nested_inactive_status_style_target 'status-left'

      # The above setting need to be set before running the nested.tmux script
      run-shell ${tmux-nested}/share/tmux-plugins/tmux-nested/nested.tmux

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
  services.vscode-server.installPath = "$HOME/.vscode-server";

  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false;
    extensions = with pkgs.vscode-extensions; [
      asvetliakov.vscode-neovim
      ms-vscode.cpptools
      bbenoist.nix
      ms-vscode.cpptools-extension-pack
      xaver.clang-format
      twxs.cmake
      ms-vscode.cmake-tools
      james-yu.latex-workshop
      ms-dotnettools.csharp
      ms-dotnettools.csdevkit
      saoudrizwan.claude-dev
      ms-dotnettools.vscode-dotnet-runtime
      mechatroner.rainbow-csv
      ms-python.vscode-pylance
      ms-python.python
      ms-python.debugpy
      antyos.openscad
      ms-vscode.makefile-tools
      valentjn.vscode-ltex
      vadimcn.vscode-lldb
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "chuck";
        publisher = "forrcaho";
        version = "1.0.1";
        sha256 = "sha256-gqcN7eam0YnBNQ2z7tA7Fo7PbXnJV0lX9TqcEbnMDL8=";
      }
    ];
  profiles.default = {
      userSettings = {
          # This property will be used to generate settings.json:
          # https://code.visualstudio.com/docs/getstarted/settings#_settingsjson
          "editor.formatOnSave" = true;
          "files.autoSave" = "onFocusChange";
          # "extensions.autoCheckUpdates" = false;
          "extensions.autoUpdate" = false;
          "files.trimFinalNewlines" = true;
          "files.trimTrailingWhitespace" = true;
          "[latex]" = {
            "editor.wordWrap" = "on";
          };
          "[markdown]" = {
            "editor.quickSuggestions" = {
              "other" = true;
              "comments" = true;
              "strings" = true;
            };
          };
      keybindings = [
          # See https://code.visualstudio.com/docs/getstarted/keybindings#_advanced-customization
          {
              key = "shift+cmd+j";
              command = "workbench.action.focusActiveEditorGroup";
              when = "terminalFocus";
          }
      ];
      # WARNING! Adding a new extension appears to uninstall all previous YOLO extensions
      # Changing this config may result in extensions dissapearing
      # Issue: https://github.com/nix-community/home-manager/issues/7719
      # Removing ~/.vscode or ~/'Library/Application Support/Code' will help
      # Removing ~/.vscode/extensions/extensions.json may help
      # https://search.nixos.org/packages?channel=25.05&query=vscode-extensions

      # `vscode-marketplace` is one of the properties that the `nix-vscode-extensions`
      # overlay added to nixpkgs. Any VSCode extension in the marketplace should be
      # accessible from `pkgs.vscode-marketplace.$AUTHOR.$EXTENSION`, where
      # `$AUTHOR.$EXTENSION` is the same as the `itemName` property in the extension’s
      # URL on the [extension marketplace
      # website](https://marketplace.visualstudio.com/vscode).
      # extensions = with pkgs.nix-vscode-extensions.vscode-marketplace; [
      #   ms-dotnettools.vscode-dotnet-runtime
      #   ms-vscode.cpptools
      #   ms-vscode.cpptools-extension-pack
      #   ms-vscode.cpptools-themes
      #   ms-dotnettools.csharp
      #   ms-dotnettools.csdevkit
      #   forrcaho.chuck
      #   xaver.clang-format
      #   xaver.clang-format
      #   Anthropic.claude-code
      #   saoudrizwan.claude-dev
      #   CmajorSoftware.cmajor-tools
      #   twxs.cmake
      #   ms-vscode.cmake-tools
      #   vadimcn.vscode-lldb
      #   ms-azuretools.vscode-containers
      #   Continue.continue
      #   ms-vscode-remote.remote-containers
      #   ms-azuretools.vscode-docker
      #   docker.docker
      #   DavidSchuldenfrei.gtest-adapter
      #   justusadam.language-haskell
      #   James-Yu.latex-workshop
      #   valentjn.vscode-ltex
      #   ms-vscode.makefile-tools
      #   bbenoist.Nix
      #   Antyos.openscad
      #   ms-python.vscode-pylance
      #   ms-python.python
      #   ms-python.debugpy
      #   ms-python.vscode-python-envs
      #   mechatroner.rainbow-csv
      #   ms-vscode-remote.remote-ssh
      #   ms-vscode-remote.remote-ssh-edit
      #   ms-vscode.remote-server
      #   ms-vscode-remote.vscode-remote-extensionpack
      #   ms-vscode.remote-explorer
      #   tidalcycles.vscode-tidalcycles
      #   visualstudiotoolsforunity.vstuc
      #   asvetliakov.vscode-neovim
      #   canadaduane.vscode-kmonad
      #   OliverKovacs.word-count
      # ];
      };
    };
  };

  xdg = {
    enable = true;
    configFile."containers/registries.conf" = {
      source = ./dot.config/containers/registries.conf;
    };
    configFile."atuin/config.toml" = {
      source = ./tomcotton.config/.config/atuin/config.toml;
    };
    configFile."ghostty/config" = {
      source = ./tomcotton.config/.config/ghostty/config;
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
      vdocs = "/Volumes/Files_Tom/Documents";
      dl = "$HOME/Downloads";
    };

    # Environment variables
    envExtra = ''
      export DFT_DISPLAY=side-by-side
      export XDG_CONFIG_HOME="$HOME/.config"
      export LESS="-iMSx4 -FXR"
      export PAGER=less
      export FULLNAME='Thomas Wiley Cotton'
      export EDITOR=nvim
      export EMAIL=thomaswileycotton@gmail.com
      export GOPATH=$HOME/go
      export PATH=$GOPATH/bin:$PATH
      export PATH=$HOME/.local/bin:$PATH

      export EXA_COLORS="da=1;35"
      export BAT_THEME="Visual Studio Dark+"
      export TMPDIR=/tmp/

      export FZF_CTRL_R_OPTS="--reverse"
      export FZF_TMUX_OPTS="-p"

      export ZSH_AUTOSUGGEST_STRATEGY=(history completion)

      [ -e ~/.config/sensitive/.zshenv ] && \. ~/.config/sensitive/.zshenv   # Manual env variables not to be checked in
    '';

    oh-my-zsh = {
      enable = true;
      custom = "$HOME/.oh-my-zsh-custom";

      theme = "headline";
      # theme = "git-taculous";
      # theme = "agnoster-nix";

      extraConfig = ''
        zstyle :omz:plugins:ssh-agent identities id_ed25519
        if [[ `uname` == "Darwin" ]]; then
          zstyle :omz:plugins:ssh-agent ssh-add-args --apple-load-keychain
        fi
        source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

        # Change working dir in shell to last dir in lf on exit (adapted from ranger).
        #
        # You need to either copy the content of this file to your shell rc file
        # (e.g. ~/.bashrc) or source this file directly:
        #
        #     LFCD="/path/to/lfcd.sh"
        #     if [ -f "$LFCD" ]; then
        #         source "$LFCD"
        #     fi
        #
        # You may also like to assign a key (Ctrl-O) to this command:
        #
        #     bind '"\C-o":"lfcd\C-m"'  # bash
        bindkey -s '^o' 'lfcd\n'  # zsh
        #

        lfcd () {
            # `command` is needed in case `lfcd` is aliased to `lf`
            cd "$(command lf -print-last-dir "$@")"
        }

        # For some reason this was aliased to vi, seems regresive
        unalias nvim
      '';
      plugins = [
        "brew"
        "bundler"
        "colorize"
        "dotenv"
        "fzf"
        "git"
        "gh"
        "kubectl"
        "kube-ps1"
        "ssh-agent"
        "tmux"
        "z"
      ];
    };

    shellAliases = {
      batj = "bat -l json";
      batly = "bat -l yaml";
      batmd = "bat -l md";
      dir = "exa -l --icons --no-user --group-directories-first  --time-style long-iso --color=always";
      ltr = "ll -snew";
      tree = "exa -Tl --color=always";
      # watch = "watch --color "; # Note the trailing space for alias expansion https://unix.stackexchange.com/questions/25327/watch-command-alias-expansion
      watch = "viddy ";
      # Automatically run `go test` for a package when files change.
      py3 = "python3";
      vi = "nvim";
    };

    initContent = ''
      tmux-window-name() {
        (${builtins.toString tmux-window-name}/share/tmux-plugins/tmux-window-name/scripts/rename_session_windows.py &)
      }
      if [[ $TERM_PROGRAM == "tmux" && `uname` == "Darwin" ]]; then
        add-zsh-hook chpwd tmux-window-name
      fi

      bindkey -e
      bindkey '^[[A' up-history
      bindkey '^[[B' down-history
      #bindkey -m
      bindkey '\M-\b' backward-delete-word
      bindkey -s "^Z" "^[Qls ^D^U^[G"
      bindkey -s "^X^F" "e "

      # Atun stuff
      # eval "$(atuin init zsh)"


      setopt autocd autopushd autoresume cdablevars correct correctall extendedglob globdots histignoredups longlistjobs mailwarning  notify pushdminus pushdsilent pushdtohome rcquotes recexact sunkeyboardhack menucomplete always_to_end hist_allow_clobber no_share_history
      unsetopt bgnice


      export PATH=$PATH:/Library/TeX/texbin


    '';

    #initContent = (builtins.readFile ../mac-dot-zshrc);
  };

  programs.eza.enable = true;
  programs.home-manager.enable = true;
  programs.neovim.enable = true;
  programs.nix-index.enable = true;
  #  programs.zoxide.enable = true;

  programs.neovim = {
    plugins = [
    ];
    extraConfig = ''
      filetype on
      filetype plugin on
      filetype indent on
      syntax on
      set number relativenumber
      " Highlight cursor line underneath the cursor horizontally.
      set cursorline

      " Highlight cursor line underneath the cursor vertically.
      set cursorcolumn

      " Set shift width to 4 spaces.
      set shiftwidth=4

      " Set tab width to 4 columns.
      set tabstop=4

      " Use space characters instead of tabs.
      set expandtab

      " Do not save backup files.
      set nobackup

      " Do not let cursor scroll below or above N number of lines when scrolling.
      set scrolloff=10

      " Do not wrap lines. Allow long lines to extend as far as the line goes.
      set nowrap

      " While searching though a file incrementally highlight matching characters as you type.
      set incsearch

      " Ignore capital letters during search.
      set ignorecase

      " Override the ignorecase option if searching for capital letters.
      " This will allow you to search specifically for capital letters.
      set smartcase

      " Show partial command you type in the last line of the screen.
      set showcmd

      " Show the mode you are on the last line.
      set showmode

      " Show matching words during a search.
      set showmatch

      " Use highlighting when doing a search.
      set hlsearch

      " Set the commands to save in history default number is 20.
      set history=1000

      " Enable auto completion menu after pressing TAB.
      set wildmenu

      " Make wildmenu behave like similar to Bash completion.
      set wildmode=list:longest

      " There are certain files that we would never want to edit with Vim.
      " Wildmenu will ignore files with these extensions.
      set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx

      set clipboard+=unnamedplus
    '';
  };

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
    # unstablePkgs.ghostty
    (pkgs.python311.withPackages (ppkgs: [
      ppkgs.numpy
      ppkgs.libtmux
    ]))
    ffmpeg
    rsync
    rhash
    restic
    lf
    vimv
    # claude-code
    # python3Packages.libtmux
    # kubernetes-helm
    # kubectx
    # kubectl
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
    gh
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
    # (python311.withPackages(ps: with ps; [ libtmux ]))
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
