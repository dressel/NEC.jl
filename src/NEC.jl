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

    RadiationPattern


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

include("backend.jl")

end # module
