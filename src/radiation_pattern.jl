struct RadiationPattern
    gains_db::Matrix{Float64}   # gains in decibels (I think)
    gains::Matrix{Float64}      # gains in real units
    thetas::Vector{Float64}     # azimuth angles (I think)
    phis::Vector{Float64}       # elevation angles (I think)
end
