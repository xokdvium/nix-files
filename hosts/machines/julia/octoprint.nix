{...}: {
  services.octoprint = {
    enable = true;
    plugins = plugins:
      with plugins; [
        themeify
        titlestatus
        dashboard
        abl-expert
        bedlevelvisualizer
        costestimation
        displayprogress
        marlingcodedocumentation
        telegram
      ];
  };
}
