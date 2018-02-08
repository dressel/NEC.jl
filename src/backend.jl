######################################################################
# backend.jl
#
# Currently uses PyCall and PyNEC as the backend
######################################################################

using PyCall
@pyimport PyNEC as pn

function geo_card(geo::PyObject, w::Wire, tag_id::Int)
    geo[:wire](tag_id, w.n_segments, w.a..., w.b..., w.rad, w.rdel, w.rrad)
end

function ex_card(context::PyObject, vs::VoltageSource, s)

    # loop over wires to find matching segment
    tag_id = 0
    for (sei, se) in enumerate(s)
        se == vs.w && (tag_id = sei)
    end

    context[:ex_card](0,            # 0 for voltage source
                      tag_id,       # I2 - tag number of source segment
                      vs.m,         # I3 - m
                      0,            # I4 - 
                      real(vs.v),   # F1 - Real part of voltage in volts
                      imag(vs.v),   # F2 - Imaginary part of voltage
                      0,            # F3 - 
                      0,            # F4 - 
                      0,            # F5 - 
                      0             # F6 - 
                     )
end

function ex_card(context::PyObject, lw::LinearWave, s)
    context[:ex_card](1,            # I1 - 1 for linear wave
                      lw.n_thetas,  # I2 - number of theta angles
                      lw.n_phis,    # I3 - number of phi angles
                      0,            # I4 - not sure what this is
                      lw.theta,     # F1
                      lw.phi,       # F2
                      lw.eta,       # F3
                      lw.d_theta,   # F4
                      lw.d_phi,     # F5
                      0             # F6 - min/maj axis
                     )
end

function RadiationPattern(s, ex::Excitation, fmhz::Real)
    # create context
    context = pn.nec_context()

    # put structure in
    geo = context[:get_geometry]()
    for (sei, se) in enumerate(s)
        geo_card(geo, se, sei)
    end
    context[:geometry_complete](0)

    # ground 
    # TODO: obviously, don't just do it this way
    # nullifies previous parameters and sets free-space condition
    context[:gn_card](-1, 0, 0, 0, 0, 0, 0, 0)

    # excitation
    ex_card(context, ex, s)

    # frequency
    #context[:fr_card](0, 2, 2400, 100.0e6)
    context[:fr_card](0, 1, fmhz, 0)

    # rp_card
    context[:rp_card](0,        # I1 - 0 = normal mode
                      181,       # I2 - num theta values
                      361,        # I3 - num phi values
                      0,        # I4-X - output format 
                      #5,        # I4-N - normalization
                      0,        # I4-N - normalization
                      0,        # I4-D - powergain or directive gain
                      0,        # I4-A - Averaging?
                      0.0,      # F1 - initial theta angle
                      #45.0,     # F2 - initial phi angle
                      0.0,     # F2 - initial phi angle
                      1.0,      # F3 - theta increment
                      1.0,      # F4 - phi increment
                      0.0,      # F5 - Radial distance
                      0.0       # F6 - Gain normalization factor
                     )

    # get radiation pattern
    rp = context[:get_radiation_pattern](0)
    return RadiationPattern(rp)
end

function RadiationPattern(rp::PyObject)
    gains_db = rp[:get_gain]()
    gains = 10.0 .^ (gains_db / 10.0)
    thetas = rp[:get_theta_angles]()
    phis = rp[:get_phi_angles]()
    return RadiationPattern(gains_db, gains, thetas, phis)
end
