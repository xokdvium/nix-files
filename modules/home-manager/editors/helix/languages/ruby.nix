{ pkgs, ... }:
{
  programs.helix.languages = {
    language-server.solargraph = {
      command = "${pkgs.rubyPackages_3_3.solargraph}/bin/solargraph";
      args = [ "stdio" ];
    };

    language = [
      {
        name = "ruby";
        language-servers = [
          "solargraph"
          "typos-lsp"
        ];
        auto-format = true;
        # FIXME: Fails to build
        # formatter = {
        # command = "${pkgs.rubyfmt}/bin/rubyfmt";
        # };
      }
    ];
  };
}
