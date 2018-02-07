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

```julia
struct Yagi
    wires::Vector{Wire}     # driven element must be second element
end
```

You can construct a Yagi by just passing in a vector of wires, so long as the driven element is the second element in the vector.
Alternatively, you can use the following constructor:

```julia
Yagi(lengths, xvals, rad, ns; z=2.0)
```

where the arguments are:

* `lengths` - A vector of floats, with as many elements as the Yagi antenna. The first element is the length of the reflector, the second is the length of the driven element, and the remaining elements are the lengths of the directors. All lengths are in meters.
* `xvals` - A vector with one fewer element than the Yagi. The first element is the x-location of the reflector, which should be a negative value. The rest of the elements are the x-location of the directors, which should be positive values. The order must match the director order in `lengths`. All distances are in meters.
* `rad` - The radius of all segments (in meters).
* `ns` - If a single number is provided, all elements will be broken into the same number of segments. Alternatively, `ns` can be a vector of segment numbers. The indexing should match that of `lengths`.
* `z` The altitude of the antenna.

Note that this command will place the Yagi elements so they are parallel to the y-axis, with the front of the antenna pointing along the positive x-axis.



### Moxon

# Badges

[![Build Status](https://travis-ci.org/dressel/NEC.jl.svg?branch=master)](https://travis-ci.org/dressel/NEC.jl)

[![Coverage Status](https://coveralls.io/repos/dressel/NEC.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/dressel/NEC.jl?branch=master)

[![codecov.io](http://codecov.io/github/dressel/NEC.jl/coverage.svg?branch=master)](http://codecov.io/github/dressel/NEC.jl?branch=master)
