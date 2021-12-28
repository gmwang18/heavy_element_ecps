/* **************************************************************************** */
/*                                  o8fuco.h                                    */
/* **************************************************************************** */
    
X LOGICAL   *val,*llow,*lup;

X INTEGER   n,nr,nres,nlin,nonlin, nstep, ndualm, mdualm;

X DOUBLE    epsmac,tolmac,deldif;

X char      name[41];

X DOUBLE    epsdif;

X LOGICAL   intakt,te0,te1,te2,te3,singul;
X LOGICAL   ident,eqres,silent,analyt,cold;

X INTEGER   icf,icgf,cfincr,*cres,*cgres;

X LOGICAL   ffuerr,*confuerr;

/*  special variables for the interface to old fashioned function */
/*  specification                                                 */
/*  can be removed is only problems in the new formulation are to be used */
X INTEGER nh,ng;

X INTEGER *nonlinlist;



X LOGICAL *gconst; 

X LOGICAL *cfuerr; 
/* this is necessary because of the different index positions used */
/*  in the old and new versions   */
