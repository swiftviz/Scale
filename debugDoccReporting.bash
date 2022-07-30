#!/bin/bash

set -e  # exit on a non-zero return code from a command
set -x  # print a trace of commands as they execute

DOCC_HTML_DIR=/Applications/Xcode-beta4.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/share/docc/render
# version is hardened, so I can't attach with the debugger to see what's happened
# DOCC=/Applications/Xcode-beta4.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/docc

# built from source: d56e5a991991528c8396c0c6175ec8ee97e2bd6e (main branch)
DOCC=/Users/heckj/src/swift-project/swift-docc/.build/debug/docc

lldb $DOCC -- convert Sources/SwiftVizScale/Documentation.docc \
    --analyze \
    --fallback-display-name SwiftVizScale \
    --fallback-bundle-identifier com.github.swiftviz.SwiftVizScale \
    --fallback-bundle-version 0.1.9 \
    --additional-symbol-graph-dir .build/symbol-graphs \
    --experimental-documentation-coverage \
    --level brief


