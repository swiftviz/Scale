#!/bin/bash

set -x

$(xcrun --find swift) package --disable-sandbox \
     preview-documentation --target SwiftVizScale
