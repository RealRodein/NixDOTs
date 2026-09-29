{ config, pkgs, lib, machineName, ... }:

{
  home.username = "rodein";
  home.homeDirectory = "/home/rodein";

  home.stateVersion = "26.05";

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
    enable = true;
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

  xdg.configFile = lib.mkMerge [
    {
      "my-scripts/startapps.sh" = {
        source = ./shared/my-scripts/startapps.sh;
        force = true;
      };

      "my-scripts/toggles-power.sh" = {
        source = ./shared/my-scripts/toggles-power.sh;
        force = true;
      };
      "my-scripts/toggles-save.sh" = {
        source = ./shared/my-scripts/toggles-save.sh;
        force = true;
      };
      "my-scripts/yazi-portal.sh".source = ./shared/my-scripts/yazi-portal.sh;
      "my-scripts/sandbox.sh" = {
        source = ./shared/my-scripts/sandbox.sh;
        force = true;
      };
      "my-scripts/sync-flatpak-steam-icons.sh".source = ./shared/my-scripts/sync-flatpak-steam-icons.sh;

      "yazi/yazi.toml".source = ./shared/yazi/yazi.toml;
      "yazi/keymap.toml".source = ./shared/yazi/keymap.toml;
      "yazi/init.lua".source = ./shared/yazi/init.lua;
      "yazi/open-pdf-in-terminal.sh".source = ./shared/yazi/open-pdf-in-terminal.sh;
      "yazi/plugins/context-menu.yazi/main.lua".source = ./shared/yazi/plugins/context-menu.yazi/main.lua;

      "ghostty/config".source = ./shared/ghostty/config;
      "ghostty/titlebar-sync.sh".source = ./shared/ghostty/titlebar-sync.sh;

      "btop/btop.conf".source = ./shared/btop/btop.conf;

      "zed/settings.json" = {
        source = ./shared/zed/settings.json;
        force = true;
      };

      "MangoHud/MangoHud.conf".source = ./shared/mangohud/MangoHud.conf;

      # Firefox-family browsers (Zen) and Vesktop register themselves in
      # ~/.config/mimeapps.list as soon as they start, which replaces the managed
      # symlink and aborts the next activation. force = true keeps the managed
      # copy authoritative; the generated file itself comes from xdg.mimeApps.
      "mimeapps.list" = {
        force = true;
      };
    }
    (lib.mkIf (machineName == "orbiter") {
      "niri/config.kdl" = {
        source = ./shared/niri/config.kdl;
        force = true;
      };
      "niri/config.d/autostart.kdl" = {
        source = ./shared/niri/config.d/autostart.kdl;
        force = true;
      };
      "niri/config.d/decorations.kdl" = {
        source = ./shared/niri/config.d/decorations.kdl;
        force = true;
      };
      "niri/config.d/devices.kdl" = {
        source = ./shared/niri/config.d/devices.kdl;
        force = true;
      };
      "niri/config.d/keybinds.kdl" = {
        source = ./shared/niri/config.d/keybinds.kdl;
        force = true;
      };

      "niri/config.d/rules.kdl" = {
        source = ./shared/niri/config.d/rules.kdl;
        force = true;
      };
      "niri/config.d/focus-or-spawn.sh" = {
        source = ./shared/niri/config.d/focus-or-spawn.sh;
        force = true;
      };
      "niri/config.d/close-or-tab.sh" = {
        source = ./shared/niri/config.d/close-or-tab.sh;
        force = true;
      };

      # Extend the package-provided niri.service (which has ExecStart etc.) with a
      # drop-in that exports libstdc++.so.6 / libz.so.1 to the niri session. Pip-built
      # wheels (numpy/onnxruntime) in plugin venvs (e.g. wallpaper_depth) need these to
      # resolve their native libs on NixOS; all noctalia/plugin processes niri spawns
      # inherit this env (autostart + keybinds). Scoped to the session, not global.
      "systemd/user/niri.service.d/ld-library-path.conf" = {
        text = ''
          [Service]
          Environment=LD_LIBRARY_PATH=${pkgs.gcc.cc.lib}/lib:${pkgs.zlib}/lib
        '';
        force = true;
      };
    })
    (lib.mkIf (machineName == "railjack") {
      # Plasma / KDE. All of these are rewritten by Plasma, KDE or the app
      # itself (GTK, fontconfig, kglobalaccel, ...), so they need force = true:
      # without it Home Manager's collision check aborts the whole activation and
      # nothing at all gets applied.
      "kglobalshortcutsrc" = {
        source = ./shared/kde/kglobalshortcutsrc;
        force = true;
      };
      "kdeglobals" = {
        source = ./shared/kde/kdeglobals;
        force = true;
      };
      "plasmanotifyrc" = {
        source = ./shared/kde/plasmanotifyrc;
        force = true;
      };
      "plasma-org.kde.plasma.desktop-appletsrc" = {
        source = ./railjack/dotfiles/plasma/desktop-appletsrc;
        force = true;
      };
      "fontconfig/conf.d/10-hm-fonts.conf" = {
        force = true;
      };
      "systemd/user/drkonqi-coredump-launcher.socket".source =
        config.lib.file.mkOutOfStoreSymlink /dev/null;
      "systemd/user/drkonqi-coredump-launcher@.service".source =
        config.lib.file.mkOutOfStoreSymlink /dev/null;
      "systemd/user/drkonqi-coredump-pickup.service".source =
        config.lib.file.mkOutOfStoreSymlink /dev/null;
      "systemd/user/drkonqi-sentry-postman.path".source =
        config.lib.file.mkOutOfStoreSymlink /dev/null;
      "systemd/user/drkonqi-sentry-postman.service".source =
        config.lib.file.mkOutOfStoreSymlink /dev/null;
      "systemd/user/drkonqi-sentry-postman.timer".source =
        config.lib.file.mkOutOfStoreSymlink /dev/null;
    })
  ];

  # GTK2 apps (and anything going through the GTK2 theme engine) read
  # ~/.gtkrc-2.0, which the GTK libraries rewrite whenever a theme is picked in
  # their own settings dialog. That clobbered the symlink and made the Home
  # Manager activation fail, so the file has to be force-overwritten.
  gtk.gtk2.force = lib.mkIf (machineName == "railjack") true;

  home.file = lib.mkIf (machineName == "railjack") {
    # Hidden service entries (NoDisplay) for the Spectacle screenshot bindings in
    # kglobalshortcutsrc. Application launches themselves use the real .desktop
    # ids, so they need no shims at all.
    ".local/share/applications/kde-screenshot-region.desktop" = {
      source = ./shared/kde/applications/kde-screenshot-region.desktop;
      force = true;
    };
    ".local/share/applications/kde-screenshot-screen.desktop" = {
      source = ./shared/kde/applications/kde-screenshot-screen.desktop;
      force = true;
    };
    ".local/share/applications/kde-screenshot-window.desktop" = {
      source = ./shared/kde/applications/kde-screenshot-window.desktop;
      force = true;
    };
  };

  # Ghostty is the terminal of this machine, so it has to answer the
  # XDG Terminal Execution spec for anything that asks for "the default terminal"
  # (file managers, portals, Flatpak apps).
  xdg.terminal-exec = lib.mkIf (machineName == "railjack") {
    enable = true;
    settings.default = [ "com.mitchellh.ghostty.desktop" ];
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-enable-primary-paste = true;
    };
  };

  # Directory default: Thunar on orbiter, Nemo on the Plasma host.
  xdg.mimeApps = {
    enable = true;
    defaultApplications."inode/directory" =
      if machineName == "orbiter" then "thunar.desktop" else "nemo.desktop";
    associations.added = {
      "inode/directory" =
        if machineName == "orbiter" then "thunar.desktop" else "nemo.desktop";

      # Zen and Vesktop register these themselves the first time they run, which
      # is what wrote the previous live mimeapps.list. Declaring them keeps the
      # associations in place right after an activation instead of waiting for the
      # next browser start.
      "x-scheme-handler/http" = "zen-beta.desktop";
      "x-scheme-handler/https" = "zen-beta.desktop";
      "x-scheme-handler/chrome" = "zen-beta.desktop";
      "x-scheme-handler/discord" = "vesktop.desktop";
      "text/html" = "zen-beta.desktop";
      "application/x-extension-htm" = "zen-beta.desktop";
      "application/x-extension-html" = "zen-beta.desktop";
      "application/x-extension-shtml" = "zen-beta.desktop";
      "application/xhtml+xml" = "zen-beta.desktop";
      "application/x-extension-xhtml" = "zen-beta.desktop";
      "application/x-extension-xht" = "zen-beta.desktop";
    };
  };

  # KGlobalAccel reads ~/.config/kglobalshortcutsrc once, when
  # plasma-kglobalaccel starts. Home Manager now activates at login, which can
  # happen after that daemon has already read the file, so give it a nudge to
  # re-read the managed version. The nudge is skipped unless the file's content
  # actually changed since the last successful activation, so an unrelated
  # rebuild no longer interrupts shortcut handling for nothing.
  home.activation.reloadKGlobalAccel = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    if [ "${machineName}" = "railjack" ]; then
      shortcuts="$HOME/.config/kglobalshortcutsrc"
      stamp="$HOME/.local/state/nixdots/kglobalshortcutsrc.sum"
      if [ -f "$shortcuts" ]; then
        current=$(sha256sum < "$shortcuts" | cut -d" " -f1)
        if [ "$current" != "$(cat "$stamp" 2>/dev/null)" ]; then
          mkdir -p "$(dirname "$stamp")"
          printf '%s\n' "$current" > "$stamp"
          systemctl --user try-restart plasma-kglobalaccel.service 2>/dev/null || true
        fi
      fi
    fi
  '';

  home.activation.ensureNoctaliaSymlinks = config.lib.dag.entryAfter ["writeBoundary"] ''
    if [ "${machineName}" = "orbiter" ]; then
      DOTS="$HOME/nixdots/home/${machineName}/dotfiles/noctalia"
      mkdir -p "$HOME/.local/state/noctalia"

      link() {
        local src="$1" dst="$2"
        if [ -L "$dst" ] && [ "$(readlink "$dst")" != "$src" ]; then
          rm -f "$dst"
        fi
        if [ ! -e "$dst" ] && [ ! -L "$dst" ]; then
          ln -s "$src" "$dst"
        fi
      }

      link "$DOTS/settings.toml" "$HOME/.local/state/noctalia/settings.toml"
      link "$DOTS/logos" "$HOME/.local/state/noctalia/logos"
    fi
  '';

  home.activation.copyOutputsConfig = config.lib.dag.entryAfter ["writeBoundary"] ''
    if [ "${machineName}" = "orbiter" ]; then
      HOST="${machineName}"
      SRC="$HOME/nixdots/home/shared/niri/config.d/outputs-$HOST.kdl"
      DST="$HOME/.config/niri/config.d/outputs.kdl"
      mkdir -p "$(dirname "$DST")"
      if [ -f "$SRC" ]; then
        cp -f "$SRC" "$DST"
      fi
    fi
  '';

  home.activation.copyRogConfig = config.lib.dag.entryAfter ["writeBoundary"] ''
    if [ "${machineName}" = "orbiter" ]; then
      if [ ! -f "$HOME/.config/rog/rog-control-center.cfg" ] || [ -L "$HOME/.config/rog/rog-control-center.cfg" ]; then
        mkdir -p "$HOME/.config/rog"
        cp -f "${./shared/rog/rog-control-center.cfg}" "$HOME/.config/rog/rog-control-center.cfg"
        chmod 644 "$HOME/.config/rog/rog-control-center.cfg"
      fi
    fi
  '';

  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = [ "graphical-session-pre.target" ];
    };
  };
}