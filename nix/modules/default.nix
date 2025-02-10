{lib, ...}: {
  imports = [
    ./buildCommand.nix
  ];
  options = {
    scripts.output = lib.mkOption {
      type = lib.types.lines;
    };
  };

  config = {
    scripts.output = "test";
  };
}
