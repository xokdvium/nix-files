{ ... }:
let
  workspaceIndices = [
    "1"
    "2"
    "3"
    "4"
    "5"
    "6"
    "7"
    "8"
    "9"
  ];
  makeWorkspaceBind = indexes: map (index: "SUPER,${index},workspace,${index}") indexes;
  makeMoveToWorkspaceBind =
    indexes: map (index: "SUPER_SHIFT,${index},movetoworkspace,${index}") indexes;
in
{
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
          "SUPER_ALT,h,movewindow,l"
          "SUPER_ALT,l,movewindow,r"
          "SUPER_ALT,k,movewindow,u"
          "SUPER_ALT,j,movewindow,d"
        ];

      bindm = [ "SUPER_CTRL,mouse:272,resizewindow" ];
    };
  };
}
