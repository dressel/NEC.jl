
struct Wire <: StructuralElement
    a::NTuple{3,Float64}    # (x,y,z) of first end of wire (in meters)
    b::NTuple{3,Float64}    # (x,y,z) of second end of wire (in meters)
    rad::Float64            # radius of first wire segment (in meters)
    n_segments::Int         # number of segments

    # Advanced fields
    rdel::Float64   # ratio of length of segment to length of previous
    rrad::Float64   # ratio of radii of adjacent segments
end
Wire(a, b, rad, n_segments) = Wire(a, b, rad, n_segments, 1, 1)

# If there are 21 segments, they are indexed 1-21 (not 0-20).
#  So we'd want to return 11, and div(21,2) returns 10.
Base.middle(wire::Wire) = div(wire.n_segments, 2) + 1

function Base.length(w::Wire)
    dx = w.a[1] - w.b[1]
    dy = w.a[2] - w.b[2]
    dz = w.a[3] - w.b[3]

    return sqrt(dx*dx + dy*dy + dz*dz)
end
