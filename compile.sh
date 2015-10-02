#!/bin/bash

preprocessor/preprocess.sh
asciidoc -b html5 -a data-uri -a icons -a toc2 -a theme=flask sql2gremlin.asciidoc.preprocessed
rm sql2gremlin.asciidoc.preprocessed
mv sql2gremlin.asciidoc.html index.html
sed -i 's/^div\.content {.*$/\0\n  overflow-x: auto;/' index.html
