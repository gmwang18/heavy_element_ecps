/* **************************************************************************** */
/*                                  o8comm.h                                    */
/* **************************************************************************** */
                                      
#include "o8fuco.h"
    
X REAL      runtim;
X REAL      optite;
X DOUBLE    **accinf;
X INTEGER   itstep,phase;

X DOUBLE    upsi,upsi0,upsi1,upsist,psi,psi0,
            psi1,psist,psimin,
            phi,phi0,phi1,phimin,fx,fx0,fx1,
            fxst,fxsmin,b2n,b2n0,xnorm,x0norm,sig0,dscal,dnorm,d0norm;
X DOUBLE    sig,sigmin,dirder,cosphi,upsim;
X DOUBLE    *x,*x0,*x1,*xmin,*d,*d0,
            *dd,*difx,*resmin,*xsc;

X DOUBLE    *gradf,gfn,*qgf,*gphi0,*gphi1,
            **gres,*gresn;

X INTEGER   *perm,*perm1,*colno,rank;
X DOUBLE    **qr,*betaq,*diag,
            *cscal,
            *colle;

/* colno also used o8qpso with double length ! */

X DOUBLE    **a,scalm,scalm2,*diag0,matsc;

X INTEGER   *violis,*alist,*o8bind,
            *o8bind0, *aalist,*clist;
                        
X DOUBLE    *u,*u0,
            *w,*w1,*res,
            *res0,*res1,
            *resst,scf,scf0,
            *yu,*slack,infeas,*work;

X INTEGER   iterma;
X DOUBLE    del,del0,del01,delmin,tau0,tau,ny;
X DOUBLE    smalld,smallw,rho,rho1,eta,epsx,c1d,
            scfmax,updmy0,tauqp,taufac,taumax;

X DOUBLE    alpha,beta,theta,sigsm,sigla,delta,stptrm;
X DOUBLE    delta1,stmaxl;

X DOUBLE    level;
X INTEGER   clow,lastdw,lastup,lastch;

X FILE      *prou,*meu;

X DOUBLE    *ug,*og;

X DOUBLE    *low,*up,big;

X INTEGER   nreset;

X DOUBLE    *xst;
