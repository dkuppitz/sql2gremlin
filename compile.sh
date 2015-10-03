#!/bin/bash

preprocessor/preprocess.sh  && \
  asciidoc -b html5 -a data-uri -a icons -a toc2 -a theme=flask sql2gremlin.asciidoc.preprocessed && \
  rm sql2gremlin.asciidoc.preprocessed && \
  sed 's/^div\.content {.*$/\0\n  overflow-x: auto;/' sql2gremlin.asciidoc.html > index.html && \
  rm sql2gremlin.asciidoc.html
