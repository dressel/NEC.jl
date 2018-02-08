######################################################################
# moxon.jl
#
# models Moxon antennas
######################################################################

struct Moxon
    wires::Vector{Wire}
end
function Moxon(a::Real, b::Real, c::Real, d::Real, rad::Real, ns; z=2)
    wires = Vector{Wire}(6)

    ns_vec = Ones(Int, 6) * ns

    # driven element
    p1 = (0, -a/2, z)
    p2 = (0, a/2, z)
    wires[1] = Wire( (0,-a/2,z), (0,a/2,z), rad, ns_vec[1])

    # reflector
    wires[2] = Wire( (-b-c-d, -a/2, z), (-b-c-d, a/2, z), rad, ns_vec[2])

    # sides
    wires[3] = Wire( (0,-a/2,z), (-b,-a/2,z), rad, ns_vec[3])
    wires[4] = Wire( (0,a/2,z), (-b,a/2,z), rad, ns_vec[4])

    wires[5] = Wire( (-b-c, -a/2, z), (-b-c-d, -a/2, z), rad, ns_vec[5])
    wires[6] = Wire( (-b-c, a/2, z), (-b-c-d, a/2, z), rad, ns, ns_vec[6])

    return Moxon(wires)
end


function VoltageSource(moxon::Moxon; v::Float64=1.0)
    return VoltageSource(moxon.wires[1], middle(moxon.wires[1]), v)
end
