struct RadiationPattern
    gains_db::Matrix{Float64}   # gains in decibels (I think)
    gains::Matrix{Float64}      # gains in real units
    thetas::Vector{Float64}     # azimuth angles (I think)
    phis::Vector{Float64}       # elevation angles (I think)
end

function RadiationPattern(a::AbstractAntenna, fmhz::Real)
    vs = VoltageSource(a)
    return RadiationPattern(a.wires, vs, fmhz)
end


# returns:
#  max_db = maximum gain, in db
#  theta = inclination in degrees (0 along +ve z-axis, to zenith)
#  phi = azimuth in degrees (0 along +ve x-axis, 90 along +ve y-axis)
function Base.max(rp::RadiationPattern)
    max_db = maximum(rp.gains_db)
    max_idx = indmax(rp.gains_db)
    theta_idx, phi_idx = ind2sub( size(rp.gains_db), max_idx )

    theta = rp.thetas[theta_idx]
    phi = mod(rp.phis[phi_idx], 360.0)      # ensure 360.0 treated as zero

    return max_db, theta, phi
end
