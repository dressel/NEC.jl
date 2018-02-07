abstract type Excitation end

struct VoltageSource <: Excitation
    w::Wire
    m::Int      # segment number
    v::Complex{Float64}
end
# TODO: shouldn't we allow V to be complex?
function VoltageSource(yagi::Yagi; v::Float64=1.0)

    # find midpoint...
    # TODO: should I add one here?
    #  div(21,2) = 10, which is correct if NEC zero-indexes
    # Fortran 1-indexes, but C/C++ 0-indexes
    m = div(yagi.wires[2].n_segments, 2) + 1 # ? not sure if should add one

    return VoltageSource(yagi.wires[2], m, v)
end

struct LinearWave <: Excitation
    n_thetas::Int       # num theta angles for incident plane wave
    n_phis::Int         # num phi angles for incident plane wave

    theta::Float64      # theta in degrees
    phi::Float64        # phi in degrees
    eta::Float64        # eta in degrees

    d_theta::Float64    # theta angle stepping increment in degrees
    d_phi::Float64      # phi angle stepping increment in degrees
end
