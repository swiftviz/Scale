#!/bin/bash

set -e  # exit on a non-zero return code from a command
set -x  # print a trace of commands as they execute

rm -rf .build .scale-graphs
mkdir -p .scale-graphs

$(xcrun --find swift) build --target SwiftVizScale \
    -Xswiftc -emit-symbol-graph \
    -Xswiftc -emit-symbol-graph-dir -Xswiftc .scale-graphs

# remove the dependency symbol graphs, unsupported for processing together within DocC today (8Aug2022)
rm -f .scale-graphs/Collections*.json .scale-graphs/DequeModule*.json .scale-graphs/OrderedCollections*.json
# remove the symbol graph for the modules which are extended by SwiftVizScale
rm -f .scale-graphs/SwiftVizScale@Swift.symbols.json

DOCC_HTML_DIR=/Applications/Xcode-beta5.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/share/docc/render

# version is hardened, so I can't attach with the debugger to see what's happened
# DOCC=/Applications/Xcode-beta4.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/docc

# built from source: c5d7a37 (main branch)
DOCC=/Users/heckj/src/swift-project/swift-docc/.build/debug/docc

lldb $DOCC -- convert Sources/SwiftVizScale/Documentation.docc \
    --analyze \
    --fallback-display-name SwiftVizScale \
    --fallback-bundle-identifier com.github.swiftviz.SwiftVizScale \
    --fallback-bundle-version 0.1.9 \
    --additional-symbol-graph-dir .scale-graphs \
    --experimental-documentation-coverage \
    --level brief


