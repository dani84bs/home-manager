{ pkgs, ... }:

{
  # Install the lsd package (a modern replacement for 'ls')
  home.packages = [ pkgs.lsd ];

  # Manage the lsd configuration file directly through Home Manager
  xdg.configFile."lsd/config.yaml".text = ''
    # --- General Settings ---
    classic: false # Set to true to disable colors and icons
    blocks:
      - permission
      - user
      - group
      - size
      - date
      - name
    
    # --- Visuals ---
    color:
      when: auto
      theme: default
    date: date
    dereference: false
    
    # --- Icons ---
    icons:
      when: auto
      theme: fancy
      separator: " "
    
    # --- Layout & Sorting ---
    indicators: false
    layout: grid
    recursion:
      enabled: false
    size: default
    sorting:
      column: name
      reverse: false
      dir-grouping: none
    
    # --- File Handling ---
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
