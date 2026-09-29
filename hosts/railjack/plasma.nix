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
  systemd.services."drkonqi-coredump-processor@" = {
    enable = false;
    wantedBy = [ ];
  };

  # --- Debugging ---
  # Crash logs for the suspend/resume investigation. Temporary: drop this once
  # the resume crash is understood.
  environment.sessionVariables.KDE_DEBUG = "1";
}
