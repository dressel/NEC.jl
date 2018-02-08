module NEC

abstract type StructuralElement end
const Structure = Vector{StructuralElement}

export
    Wire,

    Excitation,
    VoltageSource,
    LinearWave,

    Yagi,
    Moxon,

    RadiationPattern


# structural elements
include("wire.jl")

# basic radiation things
include("excitation.jl")
include("radiation_pattern.jl")

# pre-made antenna types
abstract type AbstractAntenna end
include("yagi.jl")
include("moxon.jl")

include("backend.jl")

end # module
