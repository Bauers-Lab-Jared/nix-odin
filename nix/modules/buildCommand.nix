{lib, ...}: {
  options = {
    cliCmd.build = lib.mkOption {
      type = lib.types.lines;
    };
  };

  config = {
    cliCmd.build = "test";
  };
}
