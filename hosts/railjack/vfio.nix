# VFIO GPU passthrough – GTX 1050 Ti → Windows VM
# Host keeps RTX 3070 on nvidia + COSMIC.
#
# BEFORE FIRST BOOT: run `lspci -nn | grep -i nvidia` and confirm the
# PCI IDs match the ones in system.nix (boot.extraModprobeConfig).
# Typical 1050 Ti IDs: 10de:1c82 (GPU) + 10de:0fb9 (HDMI audio).

{ config, lib, pkgs, ... }:

{
  # ── IOMMU ────────────────────────────────────────────────────────
  boot.kernelParams = [
    "amd_iommu=on"
    "iommu=pt"
    # Force ACS override — the 1050 Ti shares IOMMU Group 15
    # with the chipset USB/SATA/Ethernet controllers on this board.
    # This isolates each PCIe device into its own group without patching.
    "pcie_acs_override=downstream,multifunction"
  ];

  # ── VFIO modules (loaded in initrd so they bind before nvidia) ───
  boot.initrd.kernelModules = [
    "vfio_pci"
    "vfio"
    "vfio_iommu_type1"
  ];

  # ── libvirt + QEMU ───────────────────────────────────────────────
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      swtpm.enable = true;
    };
  };

  programs.virt-manager.enable = true;

  # ── Looking Glass ────────────────────────────────────────────────
  # Ensure the IVSHMEM shared memory file has correct permissions
  systemd.tmpfiles.rules = [
    "d /dev/shm 1777 root root -"
    "m /dev/shm/looking-glass 0666 root root"
  ];

  # Add user to kvm group for looking-glass access
  users.users.rodein.extraGroups = [ "kvm" ];
}
