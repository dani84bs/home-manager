
{ pkgs, ... }:

{
  programs.lazygit = {
    enable = true;
    settings = {
      ui.nerdFontsVersion = 3;
      os.editPreset = "nvim";
      git.pagers = [
        {colorArg = "always";}
        {pager = "delta --dark --paging=never";}
      ];
    };

   # 1 │ ui:
   # 2 │   nerdFontsVersion: "3"
   # 3 │ os:
   # 4 │   editPreset: "vscode"
   # 5 │ git:
   # 6 │   pagers:
   # 7 │     - colorArg: always
   # 8 │       pager: delta --dark --paging=never
  };
}
