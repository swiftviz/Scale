# ``SwiftVizScale``

A collection of components to provide structures that support data visualization.

## Overview

SwiftViz includes components useful to creating visualizations of data.
Many such visualizations require mapping from an abstract set of input values to another output value.
Continuous scales map from one continuous range to another, such as `0...10` to `5.0...36.0`. 
The continuous scales include scales that support linear, logarithmic, and exponential visualization transforms.
Discrete scales map from a discrete range, defined by a collection, to a continuous range, as a point or as a band, with spacing considered in the scale's range.

Loosely based on the APIs and the visualization constructs created by Mike Bostock and contributors to [D3.js](https://d3js.org)

## Topics

### Continuous Scales

- <doc:MakingAndUsingScales>
- ``SwiftVizScale/ContinuousScale``
- ``SwiftVizScale/ContinuousScaleType``
- ``SwiftVizScale/DomainDataTransform``

### Discrete Scales

- ``SwiftVizScale/BandScale``
- ``SwiftVizScale/Band``
- ``SwiftVizScale/PointScale``
- ``SwiftVizScale/DiscreteScale``
- ``SwiftVizScale/DiscreteScaleType``

### Sequential Scales

- ``SwiftVizScale/SequentialScale``
- ``SwiftVizScale/ColorInterpolator``
- ``SwiftVizScale/LCH``

### Ticks

- ``SwiftVizScale/Tick``

### Supporting Types

- ``SwiftVizScale/Scale``
- ``SwiftVizScale/ReversibleScale``
- ``SwiftVizScale/NiceValue``
- ``SwiftVizScale/ConvertibleWithDouble``

