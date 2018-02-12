######################################################################
# moxon.jl
#
# models Moxon antennas
######################################################################

struct Moxon <: AbstractAntenna
    wires::Vector{Wire}
end
function Moxon(a::Real, b::Real, c::Real, d::Real, rad::Real, fmhz::Real; z::Real=0)
    seg_vec = Vector{Int}(4)
    seg_vec[1] = seg_vec[2] = divide(a, fmhz)
    seg_vec[3] = divide(b, fmhz)
    seg_vec[4] = divide(d, fmhz)
    return Moxon(a, b, c, d, rad, seg_vec)
end
function Moxon(a::Real, b::Real, c::Real, d::Real, rad::Real, seg_vec::Vector{Int}; z::Real=0)
    wires = Vector{Wire}(6)

    # driven element
    wires[1] = Wire( (0,-a/2,z), (0,a/2,z), rad, seg_vec[1])

    # reflector
    wires[2] = Wire( (-b-c-d, -a/2, z), (-b-c-d, a/2, z), rad, seg_vec[2])

    # sides
    wires[3] = Wire( (0,-a/2,z), (-b,-a/2,z), rad, seg_vec[3])
    wires[4] = Wire( (0,a/2,z), (-b,a/2,z), rad, seg_vec[3])

    wires[5] = Wire( (-b-c, -a/2, z), (-b-c-d, -a/2, z), rad, seg_vec[4])
    wires[6] = Wire( (-b-c, a/2, z), (-b-c-d, a/2, z), rad, seg_vec[4])

    return Moxon(wires)
end

function VoltageSource(moxon::Moxon; v::Float64=1.0)
    return VoltageSource(moxon.wires[1], middle(moxon.wires[1]), v)
end
