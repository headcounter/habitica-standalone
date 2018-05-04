{ nixpkgs ? <nixpkgs>, pkgs ? import nixpkgs {} }:

let
  args = {
    inherit nixpkgs pkgs;
    inherit (pkgs) lib;
  };

  callTest = path: let
    common = {
      imports = [ ../. ];
      networking.firewall.enable = false;
      habitica.hostName = "habitica";
      virtualisation.diskSize = 16384;
      virtualisation.memorySize = 1024;
    };
    testFun = import path (args // { inherit common; });
  in import "${nixpkgs}/nixos/tests/make-test.nix" testFun;

in {
  upstream = import ./upstream.nix args;

  allow-register-first = callTest ./allow-register-first.nix;
}