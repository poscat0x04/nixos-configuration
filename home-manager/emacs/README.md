# Emacs configuration

heavily inspired by condy's config  
uses company for autocomplete

| Language   | Major Mode Package | Autocomplete   |
|------------|--------------------|----------------|
| Haskell    | haskell-mode       | lsp-haskell    |
| Rust       | rust-mode          | lsp-mode       |
| Agda       | agda2-mode         | nil            |
| Coq        | proof-general      | company-coq    |
| Idris      | idris-mode         | idris-mode     |
| Purescript | purescript-mode    | psc-ide-emacs  |
| LaTeX      | auctex             | company-auctex |
| ATS        | bundled            | nil            |

## installation

clone into `~/.emacs.d` open emacs and run `M-x all-the-icons-install-font`

## System requirement

| Package     | Reason                                    |
|-------------|-------------------------------------------|
| gcc, cmake  | compiling libvterm                        |
| ats2        | syntax checking for ATS                   |
| hie         | lsp support for Haskell                   |
| stack       | build tool for Haskell                    |
| rust        | lsp support and build tool for Rust       |
| purescript  | completion backend for psc-ide            |
| spago       | build tool for PureScript. Not mandatory. |
| coq         | backend of proofgeneral                   |
| idris       | completion backend for idris              |
| agda        | agda2-mode and its backend                |
| texlive     | latex previewing and compilation          |
| aspell      | spelling checking                         |
| python-grip | markdown and org previewing               |
