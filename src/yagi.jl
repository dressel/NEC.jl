######################################################################
# yagi.jl
#
# Makes it easy for the user to define a Yagi-Uda antenna
######################################################################

struct Yagi <: AbstractAntenna
    wires::Vector{Wire}
end

# TODO: radius of each wire could be different
# TODO: check that lengths, ns_vec, distances are the right length
"""
Creates a Yagi antenna pointing in the +x direction, with the driven element lying along the y-axis.

`Yagi(lengths, distances, rad, ns; z=0.0)`

where
* `lengths` is lengths of elements in meters. Element order is reflector, driven, then 1st director, etc).
* `distances` is distances between Yagi elements.
* `rad` is the wire radius in meters (assumed same for all wires).
* `ns` is number of segments per wire
* `z` is the altitude of the antenna (position along z-axis).

An alternative constructor concatenates `lengths` and `distances` into one vector `params `:

`Yagi(params, rad, ns; z=0.0)`
"""
function Yagi(lengths::Vector{T1},
              distances::Vector{T2},
              rad::Float64,             # radius of wires, in meters
              ns_vec::Vector{Int};      # number of segments per wire
              z::Real=0                 # altitude of yagi in meters
             ) where {T1<:Real, T2<:Real}

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
    d_offset = 0.0
    for i = 3:num_wires
        half_len = lengths[i] / 2.0
        a = (d_offset + distances[i-1], half_len, z)
        b = (d_offset + distances[i-1], -half_len, z)
        wires[i] = Wire(a, b, rad, ns_vec[i])
        d_offset += distances[i-1]
    end

    return Yagi(wires)
end
function Yagi(lengths, distances, rad, n_segments::Int; z::Real=0)
    ns_vec = n_segments * ones(Int, length(lengths))
    return Yagi(lengths, distances, rad, ns_vec; z = z)
end
function Yagi(params, rad::Real, n_segments; z::Real=0)
    n_elements = div(length(params), 2) + 1
    lengths = params[1:n_elements]
    distances = params[(n_elements+1):end]
    return Yagi(lengths, distances, rad, n_segments, z=z)
end


# TODO: shouldn't we allow V to be complex?
function VoltageSource(yagi::Yagi; v::Float64=1.0)
    return VoltageSource(yagi.wires[2], middle(yagi.wires[2]), v)
end
