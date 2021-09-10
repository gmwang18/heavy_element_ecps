GENERATING CORRELATION CONSISTENT BASIS SETS FOR MAIN-GROUP ELEMENT ECPs
=========================================================================

The basis structure of basis sets in main-group elements is as follows.
For each occupied orbital, we will need a contraction using HF orbitals.
For instance in Bi, we have 6s2 and 6p3 so we need one contracted s 
basis and one contracted p basis. Now to form a DZ quality basis set
we need to add one extra basis to each occupied orbital and one extra
polarization basis. So Bi/cc-pVDZ will have [2s, 2p, 1d] number
of basis terms (where one of 2s and 2p are contracted). For TZ, we
need to add one more to each type of basis and add a new polarization
term. So Bi/cc-pVTZ will have [3s, 3p, 2d, 1f] number of terms.
QZ, 5Z, 6Z will keep growing accordingly. In general, a Bi/cc-pVnZ
will have [ns, np, (n-1)d, (n-2)f, (n-3)g, (n-4)h, ...].
Also, we use the so-called even-tempered scheme which means that the
ratio between exponents are constant and one needs to optimize
only the smallest/highest exponent and the ratio of exponents.
This prevents linear-dependencies (exponents becoming too close)
and also makes it easier to optimize.
First let's get the mentioned contractions and later we will add
the "correlation-consistent" terms.

1. Go to folder `hf_exponents`. Here we will optimize the exponents
that appear in the contractions. These contractions are meant to
reproduce HF energies so we will minimize the HF energy.
The `hf_basis.py` script is self explanatory and has many comments.
However, the main point is that this script will give optimal
exponents for lowest HF energy within given boundaries (see `log.out`).
Here, a reasonable guess for the ratio between exponents is ~2.4 
and for the smallest exponent is ~0.07. Small exponents (<0.1)
are fine for molecular calculations, but for solid systems these
can cause problems. Usually for regularized ECPs, exponents > 100 
are not needed so adjust the number of terms `N` in a contraction 
accordingly. Here, usually `N=9` is enough. One can check other ECP 
basis sets to get a more accurate idea about these parameters.

2. 
