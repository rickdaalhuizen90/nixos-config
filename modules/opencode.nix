{ inputs, config, pkgs, ... }:

{
  home.packages = with pkgs; [ opencode ];
  # builds are failing atm.
  #home.packages = [
  #  inputs.opencode.packages.${pkgs.system}.default
  #];

  sops.secrets."openrouter/api_key" = {
    key = "openrouter/api_key";
  };

  home.sessionVariables = {
    OPENROUTER_API_KEY = "$(cat ${config.sops.secrets."openrouter/api_key".path})";
  };

  xdg.configFile."opencode/opencode.json".source = ./opencode/opencode.json;
}

