{ pkgs, ... }:

{
  home.packages = [ pkgs.lsd ];

  # Home Manager can manage the config file directly
  xdg.configFile."lsd/config.yaml".text = ''
    classic: false
    blocks:
      - permission
      - user
      - group
      - size
      - date
      - name
    color:
      when: auto
      theme: default
    date: date
    dereference: false
    icons:
      when: auto
      theme: fancy
      separator: " "
    indicators: false
    layout: grid
    recursion:
      enabled: false
    size: default
    sorting:
      column: name
      reverse: false
      dir-grouping: none
    no-symlink: false
    total-size: false
    hyperlink: never
    symlink-arrow: ⇒
    header: false
    literal: true
    truncate-owner:
      after:
      marker: ""
  '';
}
