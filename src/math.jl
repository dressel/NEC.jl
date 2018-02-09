export get_lambda

function get_lambda(fmhz::Real)
    c = 299792458.0       # m/s
    return c / (fmhz * 1e6)
end

# if delta is the length of a segment, and lambda is the wavelength
# note that lambda / delta is segments per wavelength
# we want delta < 0.05 * lambda (according to NEC-2 guide)
# Or, we want lambda / delta > 20 => at least 20 segments per wavelength
# we'll call it 25 to be safe
# 
# length is L meters
# wavelength is lambda meters/wave
# then L / lambda is how many wavelengths long this is 
# So...
#  25 * L / lambda is minimum number of segments.
# Obviously, round this up; then make sure it's odd (easier to split)
#
# other things I want to do:
#  add a minimum number of segments but ensure they aren't too small
export divide
function divide(L::Real, fmhz::Real)
    lambda = get_lambda(fmhz)
    n_segments = round(Int, 25.0 * L / lambda, RoundUp)

    # make sure this is an odd number
    if iseven(n_segments)
        n_segments += 1
    end

    # TODO:
    # make sure we have some minimum number of segments but not too many

    return n_segments
end

# These constants store the diameters (in meters) of different AWG gauges
export
    AWG12,
    AWG13,
    AWG14,
    AWG15,
    AWG16,
    AWG17

const AWG12 = 0.0020525
const AWG13 = 0.0018278
const AWG14 = 0.0016277
const AWG15 = 0.0014495
const AWG16 = 0.0012908
const AWG17 = 0.0011495

export awg2diam
function awg2diam(awg::Int)
    if awg == 14
        return AWG14
    elseif awg == 15
        return AWG15
    elseif awg == 16
        return AWG16
    elseif awg == 17
        return AWG17
    else
        error("Are you sure $(awg) AWG exists?")
    end
end

export awg2rad
function awg2rad(awg::Int)
    return awg2diam(awg) / 2.0
end
