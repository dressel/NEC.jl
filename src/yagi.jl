######################################################################
# yagi.jl
#
# Makes it easy for the user to define a Yagi-Uda antenna
######################################################################

struct Yagi <: AbstractAntenna
    wires::Vector{Wire}
end

# TODO: don't make lengths as restrictive as Float64
# TODO: radius of each wire could be different
# TODO: number of segments for each wire could differ
# TODO: don't make default altitude 2 meters... what a random number
# TODO: check that lengths, ns_vec, distances are the right length
"""
`Yagi(lengths, distances, rad, ns; z=0.0)`
"""
function Yagi(lengths::Vector{Float64},
              distances::Vector{Float64},
              rad::Float64,                 # radius of wires, in meters
              ns_vec::Vector{Int};          # number of segments per wire
              z::Real=0.0                # altitude of yagi in meters
             )

    # create vector of wires
    num_wires = length(lengths)
    wires = Vector{Wire}(num_wires)

    # add reflector
    half_len = lengths[1] / 2.0
    a = (-distances[1], half_len, z)
    b = (-distances[1], -half_len, z)
    wires[1] = Wire(a, b, rad, ns_vec[1])

    # add driven element
    half_len = lengths[2] / 2.0
    a = (0, half_len, z)
    b = (0, -half_len, z)
    wires[2] = Wire(a, b, rad, ns_vec[2])

    # add director elements
    for i = 3:num_wires
        half_len = lengths[i] / 2.0
        a = (distances[i-1], half_len, z)
        b = (distances[i-1], -half_len, z)
        wires[i] = Wire(a, b, rad, ns_vec[i])
    end

    return Yagi(wires)
end
function Yagi(lengths, distances, rad, n_segments::Int; z::Float64=0.0)
    ns_vec = n_segments * ones(Int, length(lengths))
    return Yagi(lengths, distances, rad, ns_vec; z = z)
end
function Yagi(params, rad::Real, n_segments; z::Float64=0.0)
    n_elements = div(length(params), 2) + 1
    lengths = params[1:n_elements]
    distances = params[(n_elements+1):end]
    return Yagi(lengths, distances, rad, n_segments, z=z)
end


# TODO: shouldn't we allow V to be complex?
function VoltageSource(yagi::Yagi; v::Float64=1.0)
    return VoltageSource(yagi.wires[2], middle(yagi.wires[2]), v)
end
