{ pkgs, ... }:
let
  keys = [
    "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBE46isgoTwjR6iYkfU3v7PWBmnOtNgNZaha8qMYCNOhU4j3sFLoTuXnkpURFGiEv+0b8d9s2C/RjoHPqnyaZOFo= dave@vega"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJABs2z1jnyU9cblEJ6XlrGavGQ0LbUsOTxEWfXUe1NJ dave@vega"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDwW/ZZptPnuI8qD9SxYENxMffxLGVoc9pWRMwFyD+RvxJSfV4iTQO1BVT6XITI4e121P+XP3vraHB+midwR9WDGzl6E0vE087WkdhdHgwoNDxPdoKo4IBewt/erTZP+yaNUL6cO/EzcwB9rOFbNLbGcJqovZLWmv7MhJRCp/bvZ5UIgLEyAvlOV9+MC9l84J6Xx5w+iuf7I7stnmsFyjx0fGDZRH+OhGsCO75kVzEBjLrqcztHmcmAao/3pu95t6ijM76DCRJXfWJwK5fyeLt5rtc4nTnFcVunc6VhkhY1o6V+e8xgWRf7CEQGzfQPc+Ai8xOLR2RDO9RBxV1uCPhTPX8YeNfY6Tt8vZvqtIX+hoUjr7E0v8rYyU1NO7PeSQLwqHoA/Uz1PKb1F2BHoeGEdhfmku1VwcQVS21SKUunEvx+5sf366ZEaqwbZoAgxO2DXg+Ki8qSNJQ1bMdHoxFtwjyq+WkuO3ZRl9XXEitBpm2PcrxS+XRSDzMJgWsEx7fRIxNroUXz8hiVsFTukdFg8Fzd7YZcsVcTI3Sj9xcDOck5KVn0MzbHGmh/BmLFM7B/ZOlvBaiYRFWnt/vs/og2HF92Ku57nd6RqDB+65kbs6O9A0unomRgR+Ih9ZcPDFUrxDTgguruncAUMCfJaaGHDJmky9P4E68f+CTP6h6/2w== dave@vega"
    "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBB1OtsJJSL8i4aoWZUkBx5JxPF8MJmjUSI/TUtjJCFWjk7aUT8HwHXSsRcMA9VgJfsI6GpqKlnFdxtYcwTEPly0= dave@eranin"
  ];
  private = import ./private.nix;
in
{
  users = {
    mutableUsers = false;
    users = {
      dave = {
        isNormalUser = true;
        uid = 1000;
        extraGroups = ["wheel"];
        shell = pkgs.zsh;
        openssh.authorizedKeys.keys = keys;
        hashedPassword = private.dave_password;
      };

      root = {
        openssh.authorizedKeys.keys = keys;
        hashedPassword = private.root_password;
      };
    };
  };
}
