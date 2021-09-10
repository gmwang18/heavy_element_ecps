GENERATING CORRELATION CONSISTENT BASIS SETS FOR MAIN-GROUP ELEMENT ECPs
=========================================================================

The basis structure of basis sets in main-group elements is as follows.
For each occupied orbital, we will need a contraction using HF orbitals.
For instance in Bi, we have 6s2 and 6p3 so we need one contracted `s` 
basis and one contracted `p` basis. Now to form a DZ quality basis set
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
Here, a reasonable guess for the ratio between exponents is ~2.1 
and for the smallest exponent is ~0.06. Small exponents (<0.1)
are fine for molecular calculations, but for solid systems these
can cause problems. Usually for regularized ECPs, exponents > 100 
are not needed so adjust the number of terms `N` in a contraction 
accordingly. Here, usually `N=10` is enough. One can check other ECP 
basis sets to get a more accurate idea about these parameters.
Exponents will be written to `basis.molpro`.

2. Copy `basis.molpro` to `coefficients` folder and run Molpro
for the state-averaged ground state. You should see that in the 
final SCF step, the coefficients are pure, namely, there no mixings
of different type of bases.

3. Copy `basis.molpro` to `check_hf` folder and edit `basis.molpro` by
copying the coefficients from previous step and contracting them.
You should see that this energy agrees well with a large uncontracted
basis set energy. In this case the uncontracted AE TZ basis yields
`-5.32783955` and my contracted energy is `-5.32788760`. This concludes
the HF contraction and this contraction will be used for all `n` values.

4. Next go to `cc_tz` folder. Here you will see a Molpro input that will
optimize additional primitives as descrived above using CCSD(T).
Once these parameters are optimized, copy the optimal values to `write_cc.py`
which will output the additional terms we need to add to our basis 
(see the `cc.molpro` and `aug-cc.molpro` files).

5. The above additional terms are added and stored in `basis` folder.
This concludes `cc-pVTZ` and `aug-cc-pVTZ` basis sets. 

Note: To optimize higher quality basis sets, these scripts require
minor changes which should be clear. Also note that if we had used a
small-core rather than large-core, we would need to add core excitation terms
to form aug-cc-pCVTZ. Addition of these `C` terms is very similar.
First, above steps are done by only correlating corresponding valence space.
Then all the excitations are turned on and we add one extra (large)
exponents to each basis type at every `n` increment to optimize via CCSD(T). 
For instance,  cc-pCVTZ will now have [4s, 4p, 3d, 2f] and aug-cc-pCVTZ 
will have [5s, 5p, 4d, 3f] terms.

