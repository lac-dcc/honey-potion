with (import <nixos> {});
pkgs.mkShell rec {
  nativeBuildInputs = with pkgs; [
    clang libbpf
  ];

  buildInputs = with pkgs; [
    clang libbpf
  ];

  NIX_ENFORCE_PURITY = 0;
}

