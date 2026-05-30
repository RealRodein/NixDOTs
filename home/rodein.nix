{ config, pkgs, ... }:

{
  home.username = "rodein";
  home.homeDirectory = "/home/rodein";

  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    settings = {
      user.name = "RealRodein";
      user.email = "rodein.personal@gmail.com";
    };
  };

  xdg.configFile = {
    "niri/config.kdl".source = ./dotfiles/niri/config.kdl;
    "niri/config.d/autostart.kdl" = {
      source = ./dotfiles/niri/config.d/autostart.kdl;
      force = true;
    };
    "niri/config.d/decorations.kdl".source = ./dotfiles/niri/config.d/decorations.kdl;
    "niri/config.d/devices.kdl".source = ./dotfiles/niri/config.d/devices.kdl;
    "niri/config.d/keybinds.kdl".source = ./dotfiles/niri/config.d/keybinds.kdl;
    "niri/config.d/outputs.kdl".source = ./dotfiles/niri/config.d/outputs.kdl;
    "niri/config.d/rules.kdl".source = ./dotfiles/niri/config.d/rules.kdl;
    "niri/config.d/focus-or-spawn.sh".source = ./dotfiles/niri/config.d/focus-or-spawn.sh;

    "rog/rog-control-center.cfg".source = ./dotfiles/rog/rog-control-center.cfg;

    "autostart/vesktop.desktop".source = ./dotfiles/autostart/vesktop.desktop;

    "my-scripts/startapps.sh" = {
      source = ./dotfiles/my-scripts/startapps.sh;
      force = true;
    };
    "my-scripts/toggles-power.sh".source = ./dotfiles/my-scripts/toggles-power.sh;
    "my-scripts/toggles-save.sh".source = ./dotfiles/my-scripts/toggles-save.sh;
    "my-scripts/yazi-portal.sh".source = ./dotfiles/my-scripts/yazi-portal.sh;
    "my-scripts/sync-flatpak-steam-icons.sh".source = ./dotfiles/my-scripts/sync-flatpak-steam-icons.sh;

    "yazi/yazi.toml".source = ./dotfiles/yazi/yazi.toml;
    "yazi/keymap.toml".source = ./dotfiles/yazi/keymap.toml;
    "yazi/init.lua".source = ./dotfiles/yazi/init.lua;
    "yazi/open-pdf-in-terminal.sh".source = ./dotfiles/yazi/open-pdf-in-terminal.sh;
    "yazi/plugins/context-menu.yazi/main.lua".source = ./dotfiles/yazi/plugins/context-menu.yazi/main.lua;
  };

  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = [ "graphical-session-pre.target" ];
    };
  };

}
