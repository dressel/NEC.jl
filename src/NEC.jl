module NEC

abstract type StructuralElement end
const Structure = Vector{StructuralElement}
abstract type AbstractAntenna end

export
    Wire,

    Excitation,
    VoltageSource,
    LinearWave,

    AbstractAntenna,
    Yagi,
    Moxon,
    Dipole,

    RadiationPattern,
    f2b

export
    get_lambda,
    divide

export
    AWG1,
    AWG2,
    AWG3,
    AWG4,
    AWG5,
    AWG6,
    AWG7,
    AWG8,
    AWG9,
    AWG10,
    AWG11,
    AWG12,
    AWG13,
    AWG14,
    AWG15,
    AWG16,
    AWG17,
    AWG18,
    AWG19,
    AWG20


# functions I might need
include("math.jl")

# structural elements
include("wire.jl")

# basic radiation things
include("excitation.jl")
include("radiation_pattern.jl")

# pre-made antenna types
include("yagi.jl")
include("moxon.jl")
include("dipole.jl")

include("backend.jl")

end # module
