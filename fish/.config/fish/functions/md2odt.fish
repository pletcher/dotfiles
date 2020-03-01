function md2odt
  pandoc --filter pandoc-citeproc --csl /home/pletcher/code/csls/chicago-author-date.csl --data-dir=$HOME/.local/share/pandoc --reference-doc=$HOME/.local/share/pandoc/reference.odt -i $argv[1] -o $argv[1]-pandoc.odt
end
