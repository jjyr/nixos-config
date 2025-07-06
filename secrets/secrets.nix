let
users = [
  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMZjVzHrolOLYkmwg7vEA5/0HplKX4UNZ2yDfkilmh/q"
  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHfZXzSnXJU2fa5nSTZBeNpwZCddauV/+Jo9GrAbzvZg"
  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAqYLdVRbSVFhNGEsq1agdhxMzwQpAmc0lZuoY9hEuf8"];

  in
{
  "git-credentials".publicKeys = users;
}
