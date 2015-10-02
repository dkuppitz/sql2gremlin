#!/bin/bash
#
#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#

pushd `dirname $0`/.. > /dev/null

WORKING_DIR=`pwd`
GREMLIN_CONSOLE_HOME=${GREMLIN_CONSOLE_HOME:-"/projects/apache/incubator-tinkerpop/gremlin-console/target/apache-gremlin-console-3.0.2-SNAPSHOT-standalone"}

popd > /dev/null
pushd ${GREMLIN_CONSOLE_HOME} > /dev/null

function cleanup() {
  echo -ne "\r\n\n"
  popd &> /dev/null
}

trap cleanup EXIT

if [ ! -f bin/gremlin.sh ]; then
  echo "Gremlin REPL is not available. Cannot preprocess AsciiDoc files."
  popd > /dev/null
  exit 1
fi

# process *.asciidoc files
COLS=$(tput cols)
[[ ${COLUMNS} -lt 240 ]] && stty cols 240

tput rmam

echo
echo "============================"
echo "+   Processing AsciiDocs   +"
echo "============================"
find "${WORKING_DIR}" -name "*.asciidoc" |
     xargs -n1 ${WORKING_DIR}/preprocessor/preprocess-file.sh "${WORKING_DIR}" "${GREMLIN_CONSOLE_HOME}"

ps=(${PIPESTATUS[@]})
for i in {0..1}; do
  ec=${ps[i]}
  [ ${ec} -eq 0 ] || break
done

tput smam
stty cols ${COLS}

if [ ${ec} -ne 0 ]; then
  exit 1
else
  echo
fi
