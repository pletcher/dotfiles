function md2docx
  pandoc --filter pandoc-citeproc --csl /home/pletcher/Documents/writing/chicago-author-date.csl --reference-doc /home/pletcher/.local/share/pandoc/reference.docx -i $argv[1] -o $argv[1]-pandoc.docx
end
