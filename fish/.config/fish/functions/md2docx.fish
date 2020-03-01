function md2docx
  pandoc --filter pandoc-citeproc --csl /home/pletcher/code/csls/chicago-author-date.csl -i $argv[1] -o $argv[1]-pandoc.docx
end
