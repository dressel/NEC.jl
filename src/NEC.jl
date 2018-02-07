module NEC

abstract type StructuralElement end
const Structure = Vector{StructuralElement}

export
    Wire,

    Excitation,
    VoltageSource,
    LinearWave,

    RadiationPattern


include("wire.jl")

include("excitation.jl")

include("radiation_pattern.jl")

include("backend.jl")

end # module
