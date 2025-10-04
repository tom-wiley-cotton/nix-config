{
  config,
  pkgs,
  lib,
  unstablePkgs,
  inputs,
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
      # ms-vscode.cpptools
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
      justusadam.language-haskell
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "chuck";
        publisher = "forrcaho";
        version = "1.0.1";
        sha256 = "sha256-gqcN7eam0YnBNQ2z7tA7Fo7PbXnJV0lX9TqcEbnMDL8=";
      }
      {
        name = "vscode-tidalcycles";
        publisher = "tidalcycles";
        version = "2.0.2";
        sha256 = "sha256-TfRLJZcMpoBJuXitbRmacbglJABZrMGtSNXAbjSfLaQ=";
      }
      {
        name = "cpptools";
        publisher = "ms-vscode";
        version = "1.27.7";
        sha256 = "sha256-/usZ8oaelNF2jdYWSKLEcFVPAxMk8T/7u3xR4t4NCjM=";
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
        "editor.lineNumbers" = "relative";
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
        "files.associations" = {
          "*.tidal" = "haskell";
        };
        "tidalcycles.bootTidalPath" = "/Users/tomcotton/tidal-cycles/BootFiles/BootTidal.hs";
      };
      keybindings = [
        # See https://code.visualstudio.com/docs/getstarted/keybindings#_advanced-customization
        {
            key = "shift+cmd+j";
            command = "workbench.action.focusActiveEditorGroup";
            when = "terminalFocus";
        }
        {
          key = "ctrl+alt+shift+cmd+[";
          command = "workbench.action.previousEditor";
        }
        {
          key = "ctrl+alt+shift+cmd+]";
          command = "workbench.action.nextEditor";
        }
      ];
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

  programs.nixvim = {
    opts = {
      number = true;         # Show line numbers
      relativenumber = true; # Show relative line numbers
    };
    extraPlugins = with pkgs.vimPlugins; [
      nvim-cmp
      vim-fugitive # :G for git controls, <leader> g
      fzf-lua
      vim-commentary
      nvim-autopairs
      vim-sandwich
      lualine-nvim # requires customization
      which-key-nvim
      nvim-treesitter.withAllGrammars
      markdown-preview-nvim
      markdown-nvim
      vimtex
      nvim-notify
      vim-mundo
      lf-nvim
      lf-vim # works, but doesn't let me change files, fzf is more used
      nvim-tree-lua
      catppuccin-nvim
      vim-pencil
      ];
    extraConfigLua = ''
-- leader key is spacebar
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Enable filetype detection, plugins, and indent
vim.cmd('filetype on')
vim.cmd('filetype plugin on')
vim.cmd('filetype indent on')

-- Enable syntax highlighting
vim.cmd('syntax on')

-- Set line numbers with relative numbering
vim.opt.number = true
vim.opt.relativenumber = true

-- Highlight cursor line underneath the cursor horizontally.
vim.opt.cursorline = true

-- Highlight cursor line underneath the cursor vertically.
vim.opt.cursorcolumn = true

-- Set shift width to 4 spaces.
vim.opt.shiftwidth = 4

-- Set tab width to 4 columns.
vim.opt.tabstop = 4

vim.opt.termguicolors = true
vim.cmd([[
  hi Cursor guibg=white
]])

-- Use space characters instead of tabs.
vim.opt.expandtab = true

-- Do not save backup files.
vim.opt.backup = false

-- Do not let cursor scroll below or above N number of lines when scrolling.
vim.opt.scrolloff = 12

-- Do not wrap lines. Allow long lines to extend as far as the line goes.
vim.opt.wrap = false

-- While searching though a file incrementally highlight matching characters as you type.
vim.opt.incsearch = true

-- Ignore capital letters during search.
vim.opt.ignorecase = true

-- Override the ignorecase option if searching for capital letters.
-- This will allow you to search specifically for capital letters.
vim.opt.smartcase = true

-- Show partial command you type in the last line of the screen.
vim.opt.showcmd = true

-- Show the mode you are on the last line.
vim.opt.showmode = true

-- Show matching words during a search.
vim.opt.showmatch = true

-- Use highlighting when doing a search.
vim.opt.hlsearch = true

-- Set the commands to save in history default number is 20.
vim.opt.history = 1000

-- Enable auto completion menu after pressing TAB.
vim.opt.wildmenu = true

-- Make wildmenu behave like similar to Bash completion.
vim.opt.wildmode = 'list:longest'

-- There are certain files that we would never want to edit with Vim.
-- Wildmenu will ignore files with these extensions.
vim.opt.wildignore = '*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx'

-- Use system clipboard
vim.opt.clipboard:append('unnamedplus')

-- FzfLua mappings under <leader>f
vim.keymap.set('n', '<leader>ff', '<cmd>FzfLua files<CR>', { desc = 'Find files' })
vim.keymap.set("n", "<leader>fr", "<cmd>FzfLua oldfiles<cr>", { desc = "Fuzzy search opened files history" })
vim.keymap.set('n', '<leader>fg', '<cmd>FzfLua live_grep<CR>', { desc = 'Live grep' })
vim.keymap.set('n', '<leader>fb', '<cmd>FzfLua buffers<CR>', { desc = 'Find buffers' })
vim.keymap.set('n', '<leader>fh', '<cmd>FzfLua help_tags<CR>', { desc = 'Help tags' })
vim.keymap.set('n', '<leader>fo', '<cmd>FzfLua oldfiles<CR>', { desc = 'Old files' })
vim.keymap.set('n', '<leader>fc', '<cmd>FzfLua commands<CR>', { desc = 'Commands' })
vim.keymap.set('n', '<leader>fk', '<cmd>FzfLua keymaps<CR>', { desc = 'Keymaps' })
vim.keymap.set('n', '<leader>fs', '<cmd>FzfLua git_status<CR>', { desc = 'Git status' })
vim.keymap.set('n', '<leader>fm', '<cmd>FzfLua marks<CR>', { desc = 'Marks' })

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'gruvbox-material',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    always_show_tabline = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
      refresh_time = 16, -- ~60fps
      events = {
        'WinEnter',
        'BufEnter',
        'BufWritePost',
        'SessionLoadPost',
        'FileChangedShellPost',
        'VimResized',
        'Filetype',
        'CursorMoved',
        'CursorMovedI',
        'ModeChanged',
      },
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = { "fugitive" },
}

local keymap = vim.keymap

keymap.set("n", "<leader>gs", "<cmd>Git<cr>", { desc = "Git: show status" })
keymap.set("n", "<leader>gw", "<cmd>Gwrite<cr>", { desc = "Git: add file" })
keymap.set("n", "<leader>gc", "<cmd>Git commit<cr>", { desc = "Git: commit changes" })
keymap.set("n", "<leader>gpl", "<cmd>Git pull<cr>", { desc = "Git: pull changes" })
keymap.set("n", "<leader>gpu", "<cmd>15 split|term git push<cr>", { desc = "Git: push changes" })
keymap.set("v", "<leader>gb", ":Git blame<cr>", { desc = "Git: blame selected line" })

-- convert git to Git in command line mode
-- vim.fn["utils#Cabbrev"]("git", "Git")

-- require('mini.diff').setup()

require('gitsigns').setup()

-- fugative
keymap.set("n", "<leader>gbn", function()
  vim.ui.input({ prompt = "Enter a new branch name" }, function(user_input)
    if user_input == nil or user_input == "" then
      return
    end

    local cmd_str = string.format("G checkout -b %s", user_input)
    vim.cmd(cmd_str)
  end)
end, {
  desc = "Git: create new branch",
})

keymap.set("n", "<leader>gf", ":Git fetch ", { desc = "Git: prune branches" })
keymap.set("n", "<leader>gbd", ":Git branch -D ", { desc = "Git: delete branch" })

-- barbar controls
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Move to previous/next
map('n', '<A-,>', '<Cmd>BufferPrevious<CR>', opts)
map('n', '<A-.>', '<Cmd>BufferNext<CR>', opts)

-- Re-order to previous/next
map('n', '<A-<>', '<Cmd>BufferMovePrevious<CR>', opts)
map('n', '<A->>', '<Cmd>BufferMoveNext<CR>', opts)

-- Goto buffer in position...
map('n', '<leader>t1', '<Cmd>BufferGoto 1<CR>', opts)
map('n', '<leader>t2', '<Cmd>BufferGoto 2<CR>', opts)
map('n', '<leader>t3', '<Cmd>BufferGoto 3<CR>', opts)
map('n', '<leader>t4', '<Cmd>BufferGoto 4<CR>', opts)
map('n', '<leader>t5', '<Cmd>BufferGoto 5<CR>', opts)
map('n', '<leader>t6', '<Cmd>BufferGoto 6<CR>', opts)
map('n', '<leader>t7', '<Cmd>BufferGoto 7<CR>', opts)
map('n', '<leader>t8', '<Cmd>BufferGoto 8<CR>', opts)
map('n', '<leader>t9', '<Cmd>BufferGoto 9<CR>', opts)
map('n', '<leader>t0', '<Cmd>BufferLast<CR>', opts)

-- Pin/unpin buffer
map('n', '<A-p>', '<Cmd>BufferPin<CR>', opts)

-- Goto pinned/unpinned buffer
--                 :BufferGotoPinned
--                 :BufferGotoUnpinned

-- Close buffer
map('n', '<A-c>', '<Cmd>BufferClose<CR>', opts)

-- Wipeout buffer
--                 :BufferWipeout

-- Close commands
--                 :BufferCloseAllButCurrent
--                 :BufferCloseAllButPinned
--                 :BufferCloseAllButCurrentOrPinned
--                 :BufferCloseBuffersLeft
--                 :BufferCloseBuffersRight

-- Magic buffer-picking mode
map('n', '<leader>ts', '<Cmd>BufferPick<CR>', opts)
map('n', '<leader>tc', '<Cmd>BufferPickDelete<CR>', opts)

-- Sort automatically by...
map('n', '<leader>bb', '<Cmd>BufferOrderByBufferNumber<CR>', opts)
map('n', '<leader>bn', '<Cmd>BufferOrderByName<CR>', opts)
map('n', '<leader>bd', '<Cmd>BufferOrderByDirectory<CR>', opts)
map('n', '<leader>bl', '<Cmd>BufferOrderByLanguage<CR>', opts)
map('n', '<leader>bw', '<Cmd>BufferOrderByWindowNumber<CR>', opts)

-- Other:
-- :BarbarEnable - enables barbar (enabled by default)
-- :BarbarDisable - very bad command, should never be used

require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
    --  If you are experiencing weird indenting issues, add the language to
    --  the list of additional_vim_regex_highlighting and disabled languages for indent.
    additional_vim_regex_highlighting = { 'ruby', 'markdown' },
  }
}
    '';
  };

#   programs.neovim = {
#     plugins = with pkgs; [
#       vimPlugins.nvim-cmp
#       vimPlugins.vim-fugitive # :G for git controls, <leader> g
#       vimPlugins.fzf-lua
#       vimPlugins.vim-commentary
#       vimPlugins.nvim-autopairs
#       vimPlugins.vim-sandwich
#       vimPlugins.lualine-nvim # requires customization
#       vimPlugins.which-key-nvim
#       vimPlugins.nvim-treesitter.withAllGrammars
#       vimPlugins.markdown-preview-nvim
#       vimPlugins.markdown-nvim
#       vimPlugins.vimtex
#       vimPlugins.nvim-notify
#       vimPlugins.vim-mundo
#       # vimPlugins.lf-nvim
#       # vimPlugins.lf-vim # works, but doesn't let me change files, fzf is more used
#       # vimPlugins.nvim-tree-lua
#       vimPlugins.catppuccin-nvim
#       vimPlugins.vim-pencil
#    ];
#   };

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
