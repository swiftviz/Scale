# ``SwiftVizScale``

A collection of components to provide structures that support data visualization.

## Overview

SwiftViz includes components useful to creating visualizations of data.
Many such visualizations require mapping from an abstract set of input values to another output value.
The ``SwiftVizScale/Scale`` protocol defines the common set of functions required. 
Concrete scales that map linearly and logrithmicly are provided, with convenience methods to create them on the enumerations that host the collections mapping to different underlying types.

Loosely based on the APIs and the visualization constructs created by Mike Bostock and contributors to [D3.js](https://d3js.org)

## Topics

### Scales

- ``SwiftVizScale/LinearScale``
- ``SwiftVizScale/LogScale``
- ``SwiftVizScale/PowerScale``
- ``SwiftVizScale/Scale``
- ``SwiftVizScale/NiceValue``
- ``SwiftVizScale/ConvertibleWithDouble``

### Ticks

- ``SwiftVizScale/Tick``
- ``SwiftVizScale/TickScale``
