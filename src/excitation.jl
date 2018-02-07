abstract type Excitation end

struct VoltageSource <: Excitation
    w::Wire
    m::Int      # segment number
    v::Complex{Float64}
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
