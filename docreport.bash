#!/bin/bash

set -e  # exit on a non-zero return code from a command
set -x  # print a trace of commands as they execute

rm -rf .build .scale-graphs .scaleview-graphs
mkdir -p .scale-graphs

$(xcrun --find swift) build --target SwiftVizScale \
    -Xswiftc -emit-symbol-graph \
    -Xswiftc -emit-symbol-graph-dir -Xswiftc .scale-graphs
    
rm -f ./scale-graphs/Collections*.json ./scale-graphs/DequeModule*.json ./scale-graphs/OrderedCollections*.json

$(xcrun --find docc) convert Sources/SwiftVizScale/Documentation.docc \
    --analyze \
    --fallback-display-name SwiftVizScale \
    --fallback-bundle-identifier com.github.swiftviz.SwiftVizScale \
    --fallback-bundle-version 0.1.9 \
    --additional-symbol-graph-dir .scale-graphs \
    --experimental-documentation-coverage \
    --level brief
