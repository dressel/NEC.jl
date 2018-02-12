"""
`get_lambda(fmhz)`

Returns wavelength in meters at frequency `fmhz`.
Argument `fmhz` is in mega-hertz.
"""
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

"""
`awg(n::Int)`

Returns radius in meters of No. `n` AWG wire.
"""
awg(n::Int) = 0.5 * 0.001 * 0.127 * 92.0 ^ ((36.0-n) / 39.0)

""" Radius in meters of size 1 AWG (American Wire Gauge) """
const AWG1 = awg(1)
""" Radius in meters of size 2 AWG (American Wire Gauge) """
const AWG2 = awg(2)
""" Radius in meters of size 3 AWG (American Wire Gauge) """
const AWG3 = awg(3)
""" Radius in meters of size 4 AWG (American Wire Gauge) """
const AWG4 = awg(4)
""" Radius in meters of size 5 AWG (American Wire Gauge) """
const AWG5 = awg(5)
""" Radius in meters of size 6 AWG (American Wire Gauge) """
const AWG6 = awg(6)
""" Radius in meters of size 7 AWG (American Wire Gauge) """
const AWG7 = awg(7)
""" Radius in meters of size 8 AWG (American Wire Gauge) """
const AWG8 = awg(8)
""" Radius in meters of size 9 AWG (American Wire Gauge) """
const AWG9 = awg(9)
""" Radius in meters of size 10 AWG (American Wire Gauge) """
const AWG10 = awg(10)
""" Radius in meters of size 11 AWG (American Wire Gauge) """
const AWG11 = awg(11)
""" Radius in meters of size 12 AWG (American Wire Gauge) """
const AWG12 = awg(12)
""" Radius in meters of size 13 AWG (American Wire Gauge) """
const AWG13 = awg(13)
""" Radius in meters of size 14 AWG (American Wire Gauge) """
const AWG14 = awg(14)
""" Radius in meters of size 15 AWG (American Wire Gauge) """
const AWG15 = awg(15)
""" Radius in meters of size 16 AWG (American Wire Gauge) """
const AWG16 = awg(16)
""" Radius in meters of size 17 AWG (American Wire Gauge) """
const AWG17 = awg(17)
""" Radius in meters of size 18 AWG (American Wire Gauge) """
const AWG18 = awg(18)
""" Radius in meters of size 19 AWG (American Wire Gauge) """
const AWG19 = awg(19)
""" Radius in meters of size 20 AWG (American Wire Gauge) """
const AWG20 = awg(20)
