
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
