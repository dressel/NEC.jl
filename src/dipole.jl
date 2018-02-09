######################################################################
# dipole.jl
# 
# allows user to easily make dipole antennas
######################################################################

struct Dipole <: AbstractAntenna
    wire::Wire
end

function Dipole(fmhz::Real, rad::Real=0.001; n_lambdas::Real=0.5)
    lambda = get_lambda(fmhz)
    L = n_lambdas * lambda       # length of 

    a = (0,0,-L/2)
    b = (0,0,L/2)
    n_segments = divide(L, fmhz)

    return Dipole(Wire(a, b, rad, n_segments))
end

function VoltageSource(dipole::Dipole; v::Float64=1.0)
    return VoltageSource(dipole.wire, middle(dipole.wire), v)
end

function RadiationPattern(d::Dipole, fmhz::Real)
    return RadiationPattern([d.wire], VoltageSource(d), fmhz)
end
