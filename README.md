# NEC.jl

The Numerical Electromagnetics Code (NEC) is antenna modeling software originally produced by Lawrence Livermore National Laboratory.
Various versions were made, with the most popular being NEC-2 because its source code was released to the public.

NEC-2 was originally written in FORTRAN, but it has been re-implemented in C and C++.
[NEC2++](https://github.com/tmolteno/necpp) is an open-source C++ implementation that has C API and a python API ([PyNEC](https://github.com/tmolteno/python-necpp/tree/master/PyNEC)).
You can read more about NEC2++ in the following publication:
> Timothy C.A. Molteno, ''NEC2++: An NEC-2 compatible Numerical Electromagnetics Code'', Electronics Technical Reports No. 2014-3, ISSN 1172-496X, October 2014.

NEC.jl is a high-level Julia interface to NEC's functionality.
Most implementations and interfaces faithfully capture the functionality of NEC-2 but retain the card-based FORTRAN structure, which is not particularly intuitive.
The goal of NEC.jl is to separate the structure from the user and provide an intuitive, high-level interface.
NEC.jl is meant for amateurs with little training in electromagnetics (like myself) who want to simulate and design simple antennas.

Currently, the backend interfaces with PyNEC which interfaces with NEC2++.
I chose this convoluted setup because PyNEC is: (1) easy to install, (2) installs NEC2++ for the user, and (3) is easy to call in Julia via PyCall.
An alternative is to access NEC2++'s C API via `ccall`; another is to access the C++ code directly with [Cxx.jl](https://github.com/Keno/Cxx.jl), but I'm not sure if that package is mainstream yet.
Ultimately, it would be nice to do a complete rewrite of NEC-2 in Julia.
Regardless of backend changes, the interface should remain intuitive and unchanged.

Obviously, NEC.jl is a work in progress. I've favored functionality that I personally need, and I've favored simplicity over capturing the full functionality of NEC-2.
If there's functionality you need, please file an issue.

# Installation

Because this package currently uses PyNEC as a backend, you must install PyNEC on your machine.
I've only tested NEC.jl on Ubuntu, but it should work so long as you can get PyNEC installed.
The installation instructions for PyNEC are [here](https://github.com/tmolteno/python-necpp/tree/master/PyNEC).
If you have successfully installed PyNEC, you should be able to open up Python and run the following line without error:
```python
from PyNEC import *
```

You also need to have [PyCall.jl](https://github.com/JuliaPy/PyCall.jl) installed and properly configured.
To install, run the following in Julia:
```
Pkg.add("PyCall")
```
Sometimes (by deafult?) PyCall.jl stores its own version of Python in the Conda.jl package.
This Python version is private to Julia and will not be able to access PyNEC.
PyNEC is associated with your machine's default Python (the version that opens up when you type "python" into the terminal).
To make Julia use this version of Python (and therefore have access to PyNEC), you must do the following in Julia:
```julia
ENV["PYTHON"]="... path of your machine's default python ..."
Pkg.build("PyCall")
```
If you want to switch back to Julia's private version of Python, you can `ENV["PYTHON"]=""` and then call `Pkg.build("PyCall"). However, NEC.jl will not work until you switch back to the path that PyNEC is associated with.

Once you have PyNEC installed and PyCall properly configured, you can install this package by calling the following in Julia:
```julia
Pkg.clone("https://github.com/dressel/NEC.jl")
```
You should then be able to use the package by typing the following in Julia:
```julia
using NEC
```


# Antennas and Structures

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
* `ns` - If a single number is provided, each element will be broken into `ns` segments. Alternatively, `ns` can be a vector of segment counts. The indexing should match that of `lengths`.
* `z` - The altitude of the antenna.

Note that this command will place the Yagi elements so they are parallel to the y-axis, with the front of the antenna pointing along the positive x-axis.



### Moxon

# Bibliography

# Badges

[![Build Status](https://travis-ci.org/dressel/NEC.jl.svg?branch=master)](https://travis-ci.org/dressel/NEC.jl)
[![Coverage Status](https://coveralls.io/repos/dressel/NEC.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/dressel/NEC.jl?branch=master)
[![codecov.io](http://codecov.io/github/dressel/NEC.jl/coverage.svg?branch=master)](http://codecov.io/github/dressel/NEC.jl?branch=master)
