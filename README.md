# NEC

# Installation

# Structures

### Wire

```julia
struct Wire <: StructuralElement
    a::NTuple{3,Float64}    # (x,y,z) of first end of wire (in meters)
    b::NTuple{3,Float64}    # (x,y,z) of second end of wire (in meters)
    rad::Float64            # radius of first wire segment (in meters)
    n_segments::Int         # number of segments

    # Advanced fields
    rdel::Float64   # ratio of length of segment to length of previous
    rrad::Float64   # ratio of radii of adjacent segments
end
```

The constructors for the `Wire` type are
```julia
Wire(a, b, rad, n_segments, rdel, rrad)     # fully specified

Wire(a, b, rad, n_segments)     # assumes rdel = 1.0, rrad = 1.0
```

Suppose we want a 2-meter antenna with a constant radius of one millimeter.
The start point of the wire is the origin and the end point is two meters above the origin.
Further, we want the wire to be split into 33 equal segments.
```julia
a = (0,0,0)
b = (0,0,2)
Wire(a, b, 0.001, 33)
```

### Yagi

### Moxon

# Badges

[![Build Status](https://travis-ci.org/dressel/NEC.jl.svg?branch=master)](https://travis-ci.org/dressel/NEC.jl)

[![Coverage Status](https://coveralls.io/repos/dressel/NEC.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/dressel/NEC.jl?branch=master)

[![codecov.io](http://codecov.io/github/dressel/NEC.jl/coverage.svg?branch=master)](http://codecov.io/github/dressel/NEC.jl?branch=master)
