dotfiles
========

Symlinks courtesy of [GNU stow](https://www.gnu.org/software/stow/)

## Usage

Clone the repository

```sh
$ git clone --recurse-submodules https://github.com/pletcher/dotfiles ~/dotfiles
```

and grab the configuration file(s) you need, e.g.:

```sh
$ cd dotfiles
$ stow zsh
```

`stow` will create symlinks (with `$HOME` as root) according to the directory structure of the module in `dotfiles/`. The above command, for example, finds

```
dotfiles/zsh
└── .zshrc
```

and creates a symbolic link to `~/dotfiles/zsh/.zshrc` at `~/.zshrc`.

![Easy-peasy](https://thumbs.gfycat.com/HonestThinAsianconstablebutterfly-max-1mb.gif)

## LICENSE

### Fair License (Fair) 

Copyright (c) 2018 Charles Pletcher 

Usage of the works is permitted provided that this instrument is retained with the works, so that any entity that uses the works is notified of this instrument. 

DISCLAIMER: THE WORKS ARE WITHOUT WARRANTY.
