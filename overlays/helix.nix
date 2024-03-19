{ inputs, ... }: (final: _prev: { helix = inputs.helix.packages.${final.system}.helix; })
