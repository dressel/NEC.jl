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

    # make sure we aren't too small

    return n_segments
end
