{
  config,
  lib,
  ...
}: let
  workspaceIndices = ["1" "2" "3" "4" "5" "6" "7" "8" "9"];
  makeWorkspaceBind = indexes:
    map (index: "SUPER,${index},workspace,${index}") indexes;
  makeMoveToWorkspaceBind = indexes:
    map (index: "SUPER_SHIFT,${index},movetoworkspace,${index}") indexes;
in {
  config = let
    cfg = config.xokdvium.home.desktop.hyprland;
  in
    lib.mkIf cfg.enable {
      wayland.windowManager.hyprland = {
        settings = {
          bind =
            (makeWorkspaceBind workspaceIndices)
            ++ (makeMoveToWorkspaceBind workspaceIndices)
            ++ [
              "SUPER,h,movefocus,l"
              "SUPER,l,movefocus,r"
              "SUPER,k,movefocus,u"
              "SUPER,j,movefocus,d"
              "CTRL_ALT,h,movewindow,l"
              "CTRL_ALT,l,movewindow,r"
              "CTRL_ALT,k,movewindow,u"
              "CTRL_ALT,j,movewindow,d"
              "SUPER,f,togglefloating"
              "SUPER,s,fullscreen"
            ];

          bindm = [
            "ALT,mouse:272,movewindow"
          ];
        };
      };
    };
}
