{ pkgs, ... }:
{
  programs.helix.languages = {
    language-server.verible-verilog-ls = {
      command = "${pkgs.verible}/bin/verible-verilog-ls";
    };

    language = [
      {
        name = "verilog";
        auto-format = true;
        language-servers = [ "verible-verilog-ls" ];
        formatter = {
          command = "${pkgs.verible}/bin/verible-verilog-format";
          args = [ "-" ];
        };
      }
    ];
  };
}
