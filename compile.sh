#!/bin/bash

curl -v -X POST -d name=SQL2Gremlin -d repo=skuppitz%2Fsql2gremlin -d travis=false -d issues=false -d twitter=dkuppitz --data-urlencode content@README.md http://documentup.com/compiled > /tmp/index.html
(head -n9 /tmp/index.html && tail -n+27 /tmp/index.html) > index.html
