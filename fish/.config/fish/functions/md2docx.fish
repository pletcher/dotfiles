function md2docx
  pandoc --filter pandoc-citeproc --csl /home/pletcher/code/csls/chicago-author-date.csl --reference-docx /home/pletcher/.local/share/pandoc/reference.doc -i $argv[1] -o $argv[1]-pandoc.docx
end
