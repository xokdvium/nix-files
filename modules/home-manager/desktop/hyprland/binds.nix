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
          "ALT,h,movefocus,l"
          "ALT,l,movefocus,r"
          "ALT,k,movefocus,u"
          "ALT,j,movefocus,d"
          "CTRL_ALT,h,movewindow,l"
          "CTRL_ALT,l,movewindow,r"
          "CTRL_ALT,k,movewindow,u"
          "CTRL_ALT,j,movewindow,d"
        ];

      bindm = [ "CTRL,mouse:272,resizewindow" ];
    };
  };
}
