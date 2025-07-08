let
  users = [
    # homepc
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDXl8P73ghkshgCsqRGphdrEKkkxxEfz4ug+TiqY7uLR"
    # laptop
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINzqqIUmjCCZSh6+5xYBtTMQpK1FSA36IHTaWC6qt+jG"
  ];

in
{
  "git-credentials".publicKeys = users;
}
