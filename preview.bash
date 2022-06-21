 $(xcrun --find swift) package \
     --disable-sandbox \
     --allow-writing-to-directory ./docs \
     preview-documentation \
     --fallback-bundle-identifier com.github.swiftviz.SwiftVizScale \
     --target SwiftVizScale \
     --output-path ./docs \
     --emit-digest \
     --disable-indexing \
     --transform-for-static-hosting \
     --hosting-base-path 'Scale'


