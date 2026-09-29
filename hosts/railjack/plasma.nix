{ config, lib, pkgs, ... }:

{
  # --- Home Manager activation ---
  # With the default (system) service, Home Manager activates rodein's
  # environment from a boot-time system unit that runs *before* the session
  # exists. Any file that an application rewrites in the meantime (GTK's
  # .gtkrc-2.0, fontconfig's 10-hm-fonts.conf, mimeapps.list, the Plasma
  # config files) then trips Home Manager's collision check, the activation
  # aborts, and the whole generation is silently left unapplied.
  #
  # As a user service it is started by nixos-activation.service at every login,
  # i.e. together with - and after - the session that is going to use it.
  home-manager.startAsUserService = true;

  # --- Crash handling ---
  # DrKonqi's crash handler is started through the coredump chain: the system
  # unit hands each dump to the user's drkonqi-coredump-launcher socket, which
  # pops up the DrKonqi window. Detach it from systemd-coredump@ so no window is
  # ever shown (crashes stay in the journal / coredumpctl). The matching user
  # units are masked from the Home Manager config.
  #
  # enable = false makes NixOS emit a real unit mask, not just "not enabled":
  # systemd-lib.nix turns a disabled service into a /dev/null symlink, so
  # /etc/systemd/system/drkonqi-coredump-processor@.service becomes -> /dev/null
  # and systemd-coredump@.service.wants can no longer start it. The user-side
  # /dev/null symlinks in home/rodein.nix mask the same way.
  systemd.services."drkonqi-coredump-processor@" = {
    enable = false;
    wantedBy = [ ];
  };

  # Verified after a rebuild, and worth re-checking after a Plasma upgrade:
  #   systemctl list-unit-files '*drkonqi*'   # drkonqi-coredump-processor@ masked
  #   systemctl --user list-unit-files '*drkonqi*'
  #   pgrep -a drkonqi                        # no output
  #   coredumpctl list                        # still records crashes
}
