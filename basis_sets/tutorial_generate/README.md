TUTORIAL ON HOW TO GENERATE CORRELATION CONSISTENT BASIS SETS FOR ECPS
========================================================================

Correlation consistent basis sets (cc-pVnZ) are type of basis sets which 
result in nicely converging correlation energies when extrapolated by 
increasing the cardinal number n=(D,T,Q,5,6,...). In genereal, the 
nomenclature is aug-cc-pCVnZ. Here "aug" stands for augmentations which 
indicates there are small, diffuse terms present which are needed in 
anionic and molecular systems. "cc" stands for correlation-consistent, 
"p" is polarization,  "V" is valence, "Z" is zeta, and "n" is cardinal 
number, namely, the quality of the basis set.

This tutorial shows one reasonable way of generating these basis sets.
There are two examples shown, one for main-group element Bi, the other 
is for a transition-metal Ir. The reason for this is that the 
optimization of cc basis sets slightly differ for main-group and
transition-metal elements. For Bi (valence: 6s2 6p3) we will generate 
aug-cc-pVTZ, and for Ir (valence: 5s2 5p6 5d7 6s2) we will do 
aug-cc-pCVTZ, namely, the most accurate basis sets for a given 
cardinal number n=T.

To continue, start with Bi folder then go to Ir.
You will need `PySCF` and `Molpro` in this tutorial.

