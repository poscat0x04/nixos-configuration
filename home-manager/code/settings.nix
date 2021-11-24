{
  "cmake.configureOnOpen" = true;
  "editor.fontFamily" = "'monospace', monospace, 'Droid Sans Fallback'";
  "editor.fontSize" = 16;
  "editor.formatOnSave" = true;
  "editor.minimap.enabled" = false;
  "editor.smoothScrolling" = true;
  "editor.snippetSuggestions" = "top";
  "editor.tabSize" = 2;
  "files.exclude" = {
    "**/*.olean" = true;
    "**/.DS_Store" = true;
    "**/.git" = true;
    "**/.hg" = true;
    "**/.svn" = true;
    "**/CVS" = true;
    "**/Thumbs.db" = true;
  };
  "files.insertFinalNewline" = true;
  "files.trimTrailingWhitespace" = true;
  "latex-workshop.chktex.args.active" =
    [ "-wall" "-n22" "-n30" "-e16" "-q" "-n3" ];
  "latex-workshop.chktex.enabled" = true;
  "latex-workshop.chktex.run" = "onType";
  "latex-workshop.intellisense.unimathsymbols.enabled" = true;
  "latex-workshop.latex.clean.fileTypes" = [
    "*.aux"
    "*.bbl"
    "*.blg"
    "*.idx"
    "*.ind"
    "*.lof"
    "*.lot"
    "*.out"
    "*.toc"
    "*.acn"
    "*.acr"
    "*.alg"
    "*.glg"
    "*.glo"
    "*.gls"
    "*.fls"
    "*.log"
    "*.fdb_latexmk"
    "*.snm"
    "*.synctex(busy)"
    "*.synctex.gz(busy)"
    "*.nav"
    "*.vrb"
    "*.pygtex"
    "*.pygstyle"
  ];
  "latex-workshop.latex.clean.subfolder.enabled" = true;
  "latex-workshop.latex.outDir" = "%DIR%/output";
  "latex-workshop.latex.recipes" = [
    {
      name = "latexmk (xelatex) 🔃";
      tools = [ "xelatexmk" ];
    }
    {
      name = "latexmk (latexmkrc)";
      tools = [ "latexmk_rconly" ];
    }
    {
      name = "latexmk (lualatex)";
      tools = [ "lualatexmk" ];
    }
    {
      name = "xelatex ➞ bibtex ➞ xelatex × 2";
      tools = [ "xelatex" "bibtex" "xelatex" "xelatex" ];
    }
    {
      name = "pdflatex ➞ bibtex ➞ pdflatex × 2";
      tools = [ "pdflatex" "bibtex" "pdflatex" "pdflatex" ];
    }
    {
      name = "Compile Rnw files";
      tools = [ "rnw2tex" "latexmk" ];
    }
    {
      name = "Compile Jnw files";
      tools = [ "jnw2tex" "latexmk" ];
    }
    {
      name = "tectonic";
      tools = [ "tectonic" ];
    }
  ];
  "latex-workshop.latex.tools" = [
    {
      args = [
        "-shell-escape"
        "-synctex=1"
        "-pdf"
        "-interaction=nonstopmode"
        "-file-line-error"
        "-outdir=%OUTDIR%"
        "%DOC%"
      ];
      command = "latexmk";
      env = { };
      name = "latexmk";
    }
    {
      args = [
        "-shell-escape"
        "-synctex=1"
        "-xelatex"
        "-interaction=nonstopmode"
        "-file-line-error"
        "-outdir=%OUTDIR%"
        "%DOC%"
      ];
      command = "latexmk";
      env = { };
      name = "xelatexmk";
    }
    {
      args = [
        "-synctex=1"
        "-interaction=nonstopmode"
        "-file-line-error"
        "-lualatex"
        "-outdir=%OUTDIR%"
        "%DOC%"
      ];
      command = "latexmk";
      env = { };
      name = "lualatexmk";
    }
    {
      args = [ "%DOC%" ];
      command = "latexmk";
      env = { };
      name = "latexmk_rconly";
    }
    {
      args = [
        "-synctex=1"
        "-interaction=nonstopmode"
        "-file-line-error"
        "-output-directory=%OUTDIR%"
        "%DOC%"
      ];
      command = "xelatex";
      name = "xelatex";
    }
    {
      args =
        [ "-synctex=1" "-interaction=nonstopmode" "-file-line-error" "%DOC%" ];
      command = "pdflatex";
      env = { };
      name = "pdflatex";
    }
    {
      args = [ "%DOCFILE%" ];
      command = "bibtex";
      env = { };
      name = "bibtex";
    }
    {
      args = [
        "-e"
        "knitr::opts_knit$set(concordance = TRUE); knitr::knit('%DOCFILE_EXT%')"
      ];
      command = "Rscript";
      env = { };
      name = "rnw2tex";
    }
    {
      args = [ "-e" ''using Weave; weave("%DOC_EXT%", doctype="tex")'' ];
      command = "julia";
      env = { };
      name = "jnw2tex";
    }
    {
      args = [ "-e" ''using Weave; weave("%DOC_EXT%", doctype="texminted")'' ];
      command = "julia";
      env = { };
      name = "jnw2texmintex";
    }
    {
      args = [ "--synctex" "--keep-logs" "%DOC%.tex" ];
      command = "tectonic";
      env = { };
      name = "tectonic";
    }
  ];
  "latex-workshop.synctex.afterBuild.enabled" = true;
  "latex-workshop.view.pdf.external.synctex.args" =
    [ "--synctex-forward=%LINE%:0:%TEX%" "%PDF%" ];
  "latex-workshop.view.pdf.external.synctex.command" = "zathura";
  "latex-workshop.view.pdf.external.viewer.args" = [
    "--synctex-editor-command"
    ''code --reuse-window -g "%{input}:%{line}"''
    "%PDF%"
  ];
  "latex-workshop.view.pdf.external.viewer.command" = "zathura";
  "latex-workshop.view.pdf.viewer" = "tab";
  "python.linting.mypyEnabled" = true;
  "redhat.telemetry.enabled" = false;
  "rust.all_features" = true;
  "terminal.integrated.defaultProfile.linux" = "zsh";
  "terminal.integrated.profiles.linux" = { zsh = { path = "zsh"; }; };
  "vim.enableNeovim" = true;
  "vim.useSystemClipboard" = true;
  "workbench.colorTheme" = "Nord";
  "workbench.iconTheme" = "material-icon-theme";
  "workbench.list.smoothScrolling" = true;
}
