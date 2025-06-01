{ pkgs, lib, config, inputs, ... }:

{

  languages.ruby.enable = true;
  packages = with pkgs; [
    libffi
  ];

  enterTest = ''
    echo "Running tests"
    git --version | grep --color=auto "${pkgs.git.version}"
  '';

}
