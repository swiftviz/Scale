# GenDocImages

A utility CLI to generate images in support of the SwiftVizScale library. 
It generates PNG images in the local directory, which you can then move into Scale's documentation resources directory.

Usage:

    cd utils
    swift run GenerateDocImages
    mv *.png ../Sources/SwiftVizScale/Documentation.docc/Resources/
