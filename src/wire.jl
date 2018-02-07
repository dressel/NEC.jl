
# TODO: include rdel, rrad (right now assumed to be 1.0)
struct Wire <: StructuralElement
    a::Tuple{Float64,Float64,Float64}
    b::Tuple{Float64,Float64,Float64}
    rad::Float64        # radius of wire in meters
    n_segments::Int
end
