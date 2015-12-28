$latex='platex -kanji=utf8 -guess-input-enc -synctex=1 -interaction=nonstopmode %S';
$dvipdf='dvipdfmx -f ipaex.map %S';
$bibtex='pbibtex -kanji=utf8 %B';
$pdf_mode = 3; # dvipdf
$pdf_update_method = 2;
$pdf_previewer = "";

