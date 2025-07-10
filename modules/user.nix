{
  users.users.jjy = {
    isNormalUser = true;
    # change it after installed
    password = "dangerous";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "audio"
      "libvirtd"
      "docker"
    ];
  };
}
