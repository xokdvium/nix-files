{pkgs, ...}: {
  programs.helix.languages = {
    language-server.cmake-language-server = {
      command = "${pkgs.cmake-language-server}/bin/cmake-language-server";
    };

    language = [
      {
        name = "cmake";
        auto-format = true;
        language-servers = ["cmake-language-server"];
        formatter = {
          command = "${pkgs.cmake-format}/bin/cmake-format";
          args = ["-"];
        };
      }
    ];
  };
}
