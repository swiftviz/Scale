# SwiftVizScale

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fswiftviz%2FScale%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/swiftviz/Scale)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fswiftviz%2FScale%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/swiftviz/Scale)

[![codecov](https://codecov.io/gh/swiftviz/Scale/branch/main/graph/badge.svg?token=fbjd3ei11P)](https://codecov.io/gh/swiftviz/Scale)

![@heckj](https://img.shields.io/badge/twitter-@heckj-blue.svg?style=flat "Twitter: @heckj")

Scale and related types to support creating visualizations.
Loosely based on the APIs and mechanisms created by Mike Bostock and contributors to [D3.js](https://d3js.org)

## Build and test

    git clone https://github.com/swiftviz/scale
    cd scale
    swift test -v

## Generate documentation images for the included color scales

    swift build
    .build/debug/GenerateDocImages

then optionally move the files into the DocC resources directory:

    mv *.png Sources/SwiftVizScale/Documentation.docc/Resources/


