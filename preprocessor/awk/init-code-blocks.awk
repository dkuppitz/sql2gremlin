# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

#
# @author Daniel Kuppitz (http://gremlin.guru)
#

BEGIN {
  delimiter = 0
}

/^pb\([0-9]*\); '\[gremlin-/ {
  delimiter = 1
  split($0, a, "-")
  b = gensub(/]'/, "", "1", a[2])
  split(b, c, ",")
  split(a[1], d, ";")
  lang = c[1]
  #print d[1] "; '[source," lang "]'"
  print d[1] "; '[source,txt]'"
  print "'+EVALUATED'"
  print "'+IGNORE'"
  print "graph = TinkerGraph.open()"
  print "graph.io(IoCore.gryo()).readGraph('" wd "/assets/northwind.kryo')"
  print "g = graph.traversal()"
  print ":set max-iteration 10"
  print "'-IGNORE'"
}

!/^pb\([0-9]*\); '\[gremlin-/ { print }

/^pb\([0-9]*\); '----'/ {
  if (delimiter == 1) delimiter = 2
  else if (delimiter == 2) {
    print "'-EVALUATED'"
    delimiter = 0
  }
}
