let
users = [
  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDXl8P73ghkshgCsqRGphdrEKkkxxEfz4ug+TiqY7uLR"
];

  in
{
  "git-credentials".publicKeys = users;
}
