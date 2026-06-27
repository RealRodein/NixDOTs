{ config, pkgs, lib, ... }:

{
  home.username = "rodein";
  home.homeDirectory = "/home/rodein";

  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  programs.bash = {
    enable = true;
    initExtra = ''
      if [ -f "$(command -v fish)" ]; then
        exec fish
      fi
    '';
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
    '';
  };

  home.pointerCursor = {
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 24;
  };

  gtk = {
    enable = true;

    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 24;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };

    gtk4.extraConfig = {
      gtk-color-scheme = "prefer-dark";
    };
  };

  home.sessionVariables = {
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "24";
  };

  programs.git = {
    enable = true;
    settings = {
      user.name = "RealRodein";
      user.email = "rodein.personal@gmail.com";
    };
  };

  xdg.configFile = {
    "niri/config.kdl" = {
      source = ./dotfiles/niri/config.kdl;
      force = true;
    };
    "niri/config.d/autostart.kdl" = {
      source = ./dotfiles/niri/config.d/autostart.kdl;
      force = true;
    };
    "niri/config.d/decorations.kdl" = {
      source = ./dotfiles/niri/config.d/decorations.kdl;
      force = true;
    };
    "niri/config.d/devices.kdl" = {
      source = ./dotfiles/niri/config.d/devices.kdl;
      force = true;
    };
    "niri/config.d/keybinds.kdl" = {
      source = ./dotfiles/niri/config.d/keybinds.kdl;
      force = true;
    };
    "niri/config.d/outputs.kdl" = {
      source = ./dotfiles/niri/config.d/outputs.kdl;
      force = true;
    };
    "niri/config.d/rules.kdl" = {
      source = ./dotfiles/niri/config.d/rules.kdl;
      force = true;
    };
    "niri/config.d/focus-or-spawn.sh" = {
      source = ./dotfiles/niri/config.d/focus-or-spawn.sh;
      force = true;
    };
    "niri/config.d/close-or-tab.sh" = {
      source = ./dotfiles/niri/config.d/close-or-tab.sh;
      force = true;
    };
    "my-scripts/startapps.sh" = {
      source = ./dotfiles/my-scripts/startapps.sh;
      force = true;
    };

    "my-scripts/toggles-power.sh" = {
      source = ./dotfiles/my-scripts/toggles-power.sh;
      force = true;
    };
    "my-scripts/toggles-save.sh" = {
      source = ./dotfiles/my-scripts/toggles-save.sh;
      force = true;
    };
    "my-scripts/yazi-portal.sh".source = ./dotfiles/my-scripts/yazi-portal.sh;
    "my-scripts/sync-flatpak-steam-icons.sh".source = ./dotfiles/my-scripts/sync-flatpak-steam-icons.sh;

    "yazi/yazi.toml".source = ./dotfiles/yazi/yazi.toml;
    "yazi/keymap.toml".source = ./dotfiles/yazi/keymap.toml;
    "yazi/init.lua".source = ./dotfiles/yazi/init.lua;
    "yazi/open-pdf-in-terminal.sh".source = ./dotfiles/yazi/open-pdf-in-terminal.sh;
    "yazi/plugins/context-menu.yazi/main.lua".source = ./dotfiles/yazi/plugins/context-menu.yazi/main.lua;

    "ghostty/config.ghostty".source = ./dotfiles/ghostty/config.ghostty;

    "MangoHud/MangoHud.conf".source = ./dotfiles/mangohud/MangoHud.conf;
  };

  home.activation.ensureNoctaliaSymlinks = config.lib.dag.entryAfter ["writeBoundary"] ''
    mkdir -p "$HOME/.local/state/noctalia"
    if [ ! -L "$HOME/.local/state/noctalia/settings.toml" ] && [ ! -e "$HOME/.local/state/noctalia/settings.toml" ]; then
      ln -s "$HOME/NixDOTs/home/dotfiles/noctalia/settings.toml" "$HOME/.local/state/noctalia/settings.toml"
    fi
    if [ ! -L "$HOME/.local/state/noctalia/logos" ] && [ ! -d "$HOME/.local/state/noctalia/logos" ]; then
      ln -s "$HOME/NixDOTs/home/dotfiles/noctalia/logos" "$HOME/.local/state/noctalia/logos"
    fi
  '';

  home.activation.copyRogConfig = config.lib.dag.entryAfter ["writeBoundary"] ''
    if [ ! -f "$HOME/.config/rog/rog-control-center.cfg" ] || [ -L "$HOME/.config/rog/rog-control-center.cfg" ]; then
      mkdir -p "$HOME/.config/rog"
      cp -f "${./dotfiles/rog/rog-control-center.cfg}" "$HOME/.config/rog/rog-control-center.cfg"
      chmod 644 "$HOME/.config/rog/rog-control-center.cfg"
    fi
  '';

  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = [ "graphical-session-pre.target" ];
    };
  };
}
