GENERATING CORRELATION CONSISTENT BASIS SETS FOR TRANSITION-METAL (TM) ECPs
============================================================================

Generation of basis set for TMs is similar to main-group elements except
for some changes. Specifically, in main-groups we added `(n-1)` additional
correlation-consistent terms which we optimized via CCSD(T). It turns
out that this method does not work well for TMs. Instead we get natural
orbitals from CISD and use those to expand our basis.

1. We again start from `hf_exponents`. This is almost the same as in
Bi, however we have increased the number of terms in contractions.
This makes sense because, for instance there are two different `s`
orbitals here: 5s and 6s, so we need a lot more to decribe both using
the same set of exponents.

2. We again go to `coefficients` and run HF to get the coefficients
corresponding to `basis.molpro`. These are again taken from the last
SCF step and we take two `s` orbitals and one for `p` and `d`.
However, as you see we also run CISD with semi-core frozen.
At the end we have printed natural orbitals. These are the orbitals
we will use to expand `s, p, d` part of the basis set.
Now we take natural orbitals from final CISD step.
Since we have already taken some HF contractions, we need to skip
that many orbitals and take what comes next (HF and natural orbitals
will be similar so we don't want a large overlap, namely our basis
set should be orthogonal). For instance for `p`, I look
at symmetry 1.2 and skip the first one and take the next three for TZ. 
Similarly for `d`, I look at symmetry 1.6 and skip the first one and take
the next two for TZ. When looking at `s` (symmetry 1) we have to be careful 
because there will be `d` mixing. Essentially we should skip all orbitals 
that have major `d` contributions (the same thing appears in 1.6).
For instance, in `atom.out` the `s`-like orbitals are
`1,4,5,10,13,16,19`. We skip `1,4` and take `5,10` for TZ.
QZ will be `5,10,13`, 5Z will be `5,10,13,16`, etc. 

3. Now go to `check_contractions`. Here I have edited `basis.molpro`
to include all mentioned contractions. These are contractions taken 
from the SCF and CISD step. You should see that HF energy here also 
agrees with large uncontracted AE basis set. For uncontracted the energy
is `-103.66505684` and contracted is `-103.66494468`, close enough.
Also now rerunning the CISD should give natural orbitals with coefficients
close to 1.0.

4. Next we go to `cc_tz` and we add the missing polarization terms similar
to Bi case.

5. We uncontract the smallest exponent in each channel and add it to our basis.

6. Finally, go to `core_tz` to add core terms by turning on all excitations. 
Here the number of core terms added to each symmetry channel
is scaled differently than what we had in main group elements.
Specifically, the added core terms will be as such for different basis sets:
DZ: [1s, 1p, 1d, 1f].
TZ: [2s, 2p, 2d, 1f, 1g].
QZ: [2s, 2p, 2d, 1f, 1g, 1h].
5Z: [2s, 2p, 2d, 1f, 1g, 1h, 1i].
etc.
In this case, if you look at the output `atom.out`, the optimized values
for `s` are very close to each other (`1.348406, 1.359006`). To avoid linear dependency issues,
I will be adding only one of these.

7. For clarity all finalized basis sets are located at `basis` folder.

Note: steps 4 and 6 can be taken from other ECPs, say STU.
This is usually safe since these terms don't change much from one
ECP to another ECP.
