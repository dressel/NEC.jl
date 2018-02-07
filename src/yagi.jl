######################################################################
# yagi.jl
#
# Makes it easy for the user to define a Yagi-Uda antenna
######################################################################

struct Yagi
    wires::Vector{Wire}
end

# TODO: don't make lengths as restrictive as Float64
# TODO: radius of each wire could be different
# TODO: number of segments for each wire could differ
# TODO: don't make default altitude 2 meters... what a random number
# TODO: check that lengths, ns_vec, xvals are the right length
"""
`Yagi(lengths, xvals, rad, ns; z=2.0)`
"""
function Yagi(lengths::Vector{Float64},
              xvals::Vector{Float64},
              rad::Float64,                 # radius of wires, in meters
              ns_vec::Vector{Int};          # number of segments per wire
              z::Float64=2.0                # altitude of yagi in meters
             )

    # create vector of wires
    num_wires = length(lengths)
    wires = Vector{Wire}(num_wires)

    # add reflector
    half_len = lengths[1] / 2.0
    a = (xvals[1], half_len, z)
    b = (xvals[1], -half_len, z)
    wires[1] = Wire(a, b, rad, ns_vec[1])

    # add driven element
    half_len = lengths[2] / 2.0
    a = (0, half_len, z)
    b = (0, -half_len, z)
    wires[2] = Wire(a, b, rad, ns_vec[2])

    # add director elements
    for i = 3:num_wires
        half_len = lengths[i] / 2.0
        a = (xvals[i-1], half_len, z)
        b = (xvals[i-1], -half_len, z)
        wires[i] = Wire(a, b, rad, ns_vec[3])
    end

    return Yagi(wires)
end
function Yagi(lengths, xvals, rad, n_segments::Int; z::Float64=2.0)
    ns_vec = n_segments * ones(Int, length(lengths))
    return Yagi(lengths, xvals, rad, ns_vec; z = z)
end
