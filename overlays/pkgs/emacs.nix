self: super:

{
  customized-emacs =
    let
      emacsPackages = self.emacsPackagesFor self.emacsGcc;
      inherit (emacsPackages) emacsWithPackages;
      extraPackages = epkgs: with epkgs.melpaPackages; [
        # init
        use-package
        # init-ui
        doom-themes
        doom-modeline
        dashboard
        projectile
        page-break-lines
        # init-base
        no-littering
        # init-evil
        evil
        evil-collection
        evil-surround
        # init-tools
        which-key
        rg
        fzf
        ivy
        ivy-hydra
        ivy-rich
        counsel
        all-the-icons-ivy-rich
        amx
        projectile
        flycheck
        ace-window
        markdown-mode
        vterm
        vterm-toggle
        gcmh
        hl-todo
        # init-snippet
        yasnippet
        yasnippet-snippets
        # init-git
        magit
        diff-hl
        # init-dev
        rainbow-delimiters
        toml-mode
        yaml-mode
        direnv
        # init-nix
        nix-mode
        # init-latex
        epkgs.elpaPackages.auctex
        company-auctex
        auctex-latexmk
        cdlatex
        # others
        hierarchy
      ];
    in
    emacsWithPackages extraPackages;
}
