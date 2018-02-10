struct RadiationPattern
    gains_db::Matrix{Float64}   # gains in decibels (I think)
    gains::Matrix{Float64}      # gains in real units
    thetas::Vector{Float64}     # azimuth angles (I think)
    phis::Vector{Float64}       # elevation angles (I think)
end

# the following is just so we can pass in reals or ranges
RealOrRange = Union{Real,Range}
istart(r::Real) = r
istart(r::Range) = start(r)
Base.step(r::Real) = 1       # doesn't matter, could be any number

function RadiationPattern(a::AbstractAntenna, fmhz::Real;
                          thetas::RealOrRange=0:180,
                          phis::RealOrRange=0:360
                         )
    vs = VoltageSource(a)
    return RadiationPattern(a.wires, vs, fmhz; thetas=thetas, phis=phis)
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

# TODO: find the horizontal plane, don't just assume it is at index 91
function hpat(rp::RadiationPattern)
    return rp.thetas, vec(rp.gains_db[91,:])
end

# TODO: dont just assume it is at index 91
# TODO: this is a train wreck
function f2b(rp::RadiationPattern)
    thetas, gains_db = hpat(rp)
    return gains_db[1] , gains_db[181]
end
