#include "o8para.h"              

void user_eval(DOUBLE xvar[],INTEGER mode) {
/* ************************************************************************ */
/* called only if bloc = TRUE                                               */
/* interface to a users evaluation code of functions                        */
/* which define the optimization problem                                    */
/* on input, mode has the meanings                                          */
/* mode = -1 : evaluate function values at xvar only, store them in fu      */
/* mode = 1 : evaluate f , grad(f), con[], grad(con[]) and store            */
/*             them in  fu and fugrad                                       */
/* mode = 2  : evaluate gradients only at xvar and store them in fugrad     */
/*                                                                          */
/* The users evaluation routine                                             */
/*             eval_extern(mode)                                            */
/* is called with two settings of its mode only:                            */
/* mode = 1: set function value                                             */
/* fu using xtr, mode = 2 set function values fu and gradients fugrad using */
/* xtr                                                                      */
/*                                                                          */
/* Since donlp2 uses internally a scaled value of x, the external value xtr */
/* is obtained by multiplying with xsc. In evaluating the gradients,        */
/* the user must not take care of this scaling. Scaling of the gradients    */
/* is done by donlp2 internally.                                            */
/* that means xtr and the function values returned below refer to the       */
/* unscaled original problem                                                         */
/* If the user has set analyt = TRUE, he is responsible for computing       */
/* the gradients himself correctly                                          */
/* otherwise, if analyt = FALSE, then this routine does numerical           */
/* differentiation according to the method defined by difftype:             */
/* difftype = 1   ordinary forward difference quotient, using               */
/*                min(0.1*sqrt(epsfcn),1.e-2) as stepsize                   */
/*                epsfcn is the assumed precision of function values        */
/*                and must be set by the user in user_init                  */
/* difftype = 2   central difference quotient with stepsize                 */
/*                min(0.1*pow(epsfcn,2/3),1.e-2) as stepsize                */
/* difftype = 3   6-th order Richardson extrapolation method using          */
/*                6 function values for each component of grad,             */
/*                with stepsize min(0.1*pow(epsfcn,1/7),0.01)               */
/* This is done by several calls of eval_extern                             */
/* xtr is the current design to be used by the external routine             */
/* Values must be returned in the arrays fu (and fugrad).                   */
/*  The order of information is as follows:                                 */
/* fu[0]  objective function value                                          */
/* fugrad[i][0] : objective function gradient, i = 1,...,n the components   */
/* fu[1],...,fu[nonlin]  the values of c  (if any)                          */
/* fugrad[i][1],.., fugrad[i][nonlin] gradients of  constraint functions c  */
/* i=1,..,n                                                                 */
/* bound constraints and linear constraints must not be evaluated here      */
/* if the current variable xtr does not allow senseful evaluation of the    */
/* objective function or one of the nonlinear constraints, you must signal  */
/* this by setting ffuerr = TRUE respectively confuerr[i]=TRUE              */
/* In this case the method tries a reduction of the correction size         */
/* however, if this occurs during numerical differentiation, the code       */
/* terminates immediately unsuccessful                                      */
/* your initial guess must of course allow all evaluations, otherwise you   */
/* get immediate unsuccessful termination                                   */
/* The method uses the parameters                                           */
/*      epsfcn  =  relative accuracy of function values                     */
/*                 during finite differencing                               */
/*      difftype   (see above)                                              */
/*      analyt     (see above)                                              */
/* These must be set prior in user_init                                     */
/* ************************************************************************ */
    
    #define  X extern
    #include "o8comm.h"
    #include "o8fint.h"
    #undef   X
    #include "o8cons.h"
    
    void    eval_extern(INTEGER mode);


    static DOUBLE   xhelp,xincr,sd1,sd2,sd3,d1,d2,d3,span,sum;
    static INTEGER  i,j,k;
    static LOGICAL  changed, evalerr;
    static DOUBLE dcoef[7] = {-12348.0,30240.0,-37800.0,
                               33600.0,-18900.0,6048.0,-840.0};
    /*  coefficients for numerical differentiation                 */
    /*  denominator is 5040*stepsize . this is order 6 left handed */

	
    
    if ( mode < -1 || mode  > 2 || mode == 0 ) { 
        fprintf(stderr,"donlp2: call of user_eval with undefined mode\n");
        exit(1);
    }
    if ( mode == -1 ) {
        /* only function values required: */
        changed = FALSE;
        for (i = 1 ; i <= n ; i++) {
            if ( xtr[i] != xsc[i]*xvar[i] ) changed = TRUE;
        }
        if ( changed || ! valid ) {
            for (i = 1 ; i <= n ; i++) {
                xtr[i] = xsc[i]*xvar[i];
            }
            eval_extern(1);
            
            valid = TRUE;
        }
        return;
    }
    if ( mode >= 1 ) {
    
        /* evaluate functions and its gradients */
        
        for (i = 1 ; i <= n ; i++) {
            xtr[i] = xsc[i]*xvar[i];
        }
        /* even if xtr did not change we must evaluate externally, since now */
        /* gradients are required                                            */
        
        ffuerr = FALSE ;
        for ( i=0; i<=nonlin; i++)
        {
          confuerr[i] = FALSE ;
        }
        if ( analyt ) {
        
            eval_extern(2); 
             /* this now must set  fugrad[1:n][0:nonlin] */
            
            valid = TRUE;
            
            return;
            
        }
 
        /* continue with computing the gradients : mode = 1 or mode = 2 */
        /* require gradients                                            */
          if ( difftype == 1 ) 
          {
            deldif = min(tm1*sqrt(epsfcn),tm2);
            eval_extern(1);  /* must compute the full set of function values*/
            confuerr[0] = ffuerr ;
            evalerr = FALSE ;
            for ( j = 0 ; j <= nonlin; j++ )
            {
               fud[0][j] = fu[j] ;    /* at the current point */
               evalerr = evalerr || confuerr[j] ;
            }
            if ( evalerr )
            {
               fprintf(stderr,"error signal from extern during numdiff 1 \n");
               exit(1);
            }
            
            for (j = 1 ; j <= n ; j++) 
            {
              if ( low[j] == up[j] ) 
              {
                 for ( i=0; i <= nonlin ; i++ )
                 {
                   fugrad[j][i] = 0.0 ;
                 }
              }
              else
              {
                xhelp = xtr[j];
                span = up[j] - low[j] ;
                xincr = min(min(tm2,deldif*(fabs(xhelp)+1.0)),span/2.0);
                if ( xhelp <= low[j] + xincr )
                {
                  xtr[j] = xhelp+xincr ;
                  eval_extern(1);  /* must compute the full set of function values*/
                  confuerr[0] = ffuerr ;
                  evalerr = FALSE ;
                  for ( i = 0 ; i <= nonlin; i++ )
                  {
                    fud[1][i] = fu[i] ;
                    evalerr = evalerr || confuerr[i] ;
                  }
                  if ( evalerr  )
                  {
                    fprintf(stderr,"error signal from extern during numdiff 2  \n");
                    exit(1);
                  }

                  for ( i = 0 ; i <= nonlin; i++ )
                  {
                    fugrad[j][i] = 
                    (fud[1][i]-fud[0][i])/(xincr);
                  }
                  xtr[j] = xhelp ;
                }
                else
                { /* xtr[j] in the upper part of its interval */
                  xtr[j] = xhelp-xincr ;
                  eval_extern(1);  /* must compute the full set of function values*/
                  confuerr[0] = ffuerr ;
                  evalerr = FALSE ;
                  for ( i = 0 ; i <= nonlin; i++ )
                  { 
                     fud[1][i] = fu[i] ;
                     evalerr = evalerr || confuerr[i] ;
                  }
                  if ( evalerr   )
                  {
                     fprintf(stderr,"error signal from extern during numdiff 3  \n");
                     exit(1);
                  }

                  for ( i=0 ; i <= nonlin ; i++ )
                  {
                    fugrad[j][i] = 
                    -(fud[1][i] - fud[0][i])/(xincr);
                  }
                  xtr[j] = xhelp ;
                }/* end xtr[j] in the upper part of its interval*/
              }/* end low[j]!= up[j] */
            }/* end for j */
          }/* end difftype =1 */
          else if ( difftype == 2 )
          {
            deldif = min(tm1*pow(epsfcn,one/three),tm2);
            eval_extern(1);  /* must compute the full set of function values*/
            confuerr[0] = ffuerr ;
            evalerr = FALSE ;
            for ( i = 0 ; i <= nonlin; i++ )
            {
               fud[0][i]  = fu[i] ;
               evalerr = evalerr || confuerr[i] ;
            }
            if ( evalerr   )
            {
               fprintf(stderr,"error signal from extern during numdiff 4  \n");
               exit(1);
            }
            for (j = 1 ; j <= n ; j++) 
            {
              if ( low[j] == up[j] )
              {
                 for ( i=0; i <= nonlin ; i++ )
                 {
                   fugrad[j][i] = 0.0 ;
                 }
              }   
              else
              {
                xhelp = xtr[j];
                span = up[j] - low[j] ;
                xincr  = min(min(tm2,deldif*fabs(xhelp)+deldif),span/4.0);
                if ( xhelp - xincr >= low[j] && xhelp + xincr <= up[j] )
                {  /* take the symmetric difference quotient */
                  xtr[j] = xhelp+xincr;
                  eval_extern(1);  /* must compute the full set of function values*/
                  confuerr[0] = ffuerr ;
                  evalerr = FALSE ;
                  for ( i = 0 ; i <= nonlin; i++ )
                  {
                    fud[2][i] = fu[i] ;
                    evalerr = evalerr || confuerr[i] ;
                  }
                  if ( evalerr   )
                  {
                    fprintf(stderr,"error signal from extern during numdiff 5 \n");
                    exit(1);
                  }
                  xtr[j] = xhelp-xincr;
                  eval_extern(1);  /* must compute the full set of function values*/
                  confuerr[0] = ffuerr ;
                  evalerr = FALSE ;
                  for ( i = 0 ; i <= nonlin; i++ )
                  {
                    fud[1][i] = fu[i] ;
                    evalerr = evalerr || confuerr[i] ;
                  }
                  if ( evalerr   )
                  {
                    fprintf(stderr,"error signal from extern during numdiff 6 \n");
                    exit(1);
                  }

                  for ( i = 0 ; i <= nonlin; i++ ) 
                  {      
                    fugrad[j][i] = 
                     (fud[2][i]-fud[1][i])/(xincr+xincr);
                  }
                  xtr[j]    = xhelp;
                } /* end xtr[j] in the center of its interval */
                else if ( xhelp <= low[j]+xincr )
                { /* one sided difference quotient order 2, left*/
                  xtr[j] = xhelp+xincr;
                  eval_extern(1);  /* must compute the full set of function values*/
                  confuerr[0] = ffuerr ;
                  evalerr = FALSE ;
                  for ( i = 0 ; i <= nonlin; i++ )
                  {
                    fud[1][i]  = fu[i] ;
                    evalerr = evalerr || confuerr[i] ;
                  }
                  if ( evalerr   )
                  {
                    fprintf(stderr,"error signal from extern during numdiff 7 \n");
                    exit(1);
                  }
                  xtr[j] = xhelp+2.0*xincr;
                  eval_extern(1);  /* must compute the full set of function values*/
                  confuerr[0] = ffuerr ;
                  evalerr = FALSE ;
                  for ( i = 0 ; i <= nonlin; i++ )
                  {
                    fud[2][i]  = fu[i] ;
                    evalerr = evalerr || confuerr[i] ;
                  }
                  if ( evalerr   )
                  {
                    fprintf(stderr,"error signal from extern during numdiff 8 \n");
                    exit(1);
                  }
                  for ( i = 0 ; i <= nonlin ; i++)
                  {
                    fugrad[j][i] =
                     (-3.0*fud[0][i]+4.0*fud[1][i]
                       -fud[2][i])/(xincr+xincr);
                  }
                  xtr[j]    = xhelp;
                }/* end xhelp near the left border of its interval*/
                else
                { /* one sided difference quotient order 2, right*/
                  xtr[j] = xhelp-xincr;
                  eval_extern(1);  /* must compute the full set of function values*/
                  confuerr[0] = ffuerr ;
                  evalerr = FALSE ;
                  for ( i = 0 ; i <= nonlin; i++ )
                  {
                    fud[1][i]  = fu[i] ;
                    evalerr = evalerr || confuerr[i] ;
                  }
                  if ( evalerr   )
                  {
                    fprintf(stderr,"error signal from extern during numdiff 9 \n");
                    exit(1);
                  }
                  xtr[j] = xhelp-2.0*xincr;
                  eval_extern(1);  /* must compute the full set of function values*/
                  confuerr[0] = ffuerr ;
                  evalerr = FALSE ;
                  for ( i = 0 ; i <= nonlin; i++ )
                  {
                    fud[2][i]  = fu[i] ;
                    evalerr = evalerr || confuerr[i] ;
                  }
                  if ( evalerr  )
                  {
                    fprintf(stderr,"error signal from extern during numdiff 10 \n");
                    exit(1);
                  }
                  for ( i = 0 ; i <= nonlin ; i++)
                  {
                    fugrad[j][i] = -(-3.0*fud[0][i]+4.0*fud[1][i]
                                   -fud[2][i])/(xincr+xincr);
                  }
                  xtr[j]    = xhelp;
                }/* end xhelp near the right border of its interval*/
              } /* and span >0 */
            }/*end j*/
          } /* end difftype=2 */
          else
          { /* difftype=3 */
            deldif = min(tm1*pow(epsfcn,one/seven),tm2);
            eval_extern(1);  /* must compute the full set of function values*/
            confuerr[0] = ffuerr ;
            evalerr = FALSE ;
            for ( i = 0 ; i <= nonlin; i++ )
            {
               fud[0][i] = fu[i] ;
               evalerr = evalerr || confuerr[i] ;
            }
            if ( evalerr  )
            {
               fprintf(stderr,"error signal from extern during numdiff 11 \n");
               exit(1);
            }

            for ( j = 1 ; j <= n ; j++ )
            {
              if ( low[j] == up[j] )
              {
                 for ( i=0; i <= nonlin ; i++ )
                 {
                   fugrad[j][i] = 0.0 ;
                 }
              }
              else
              {
                span=up[j] - low[j] ;
                xhelp  = xtr[j];
                xincr  = min(min(tm2,deldif*(fabs(xhelp)+1.0)),span/8.0);
                if ( xhelp >= low[j]+4.0*xincr && xhelp <= up[j]-4.0*xincr )
                { /* use central differences */
                  xtr[j] = xhelp-xincr;
                  eval_extern(1);  /* must compute the full set of function values*/
                  confuerr[0] = ffuerr ;
                  evalerr = FALSE ;
                  for ( i = 0 ; i <= nonlin; i++ )
                  {
                    fud[1][i]  = fu[i] ;
                    evalerr = evalerr || confuerr[i] ;
                  }
                  if ( evalerr  )
                  {
                    fprintf(stderr,"error signal from extern during numdiff 12 \n");
                    exit(1);
                  }
                  xtr[j] = xhelp+xincr;
                  eval_extern(1);  /* must compute the full set of function values*/
                  confuerr[0] = ffuerr ;
                  evalerr = FALSE ;
                  for ( i = 0 ; i <= nonlin; i++ )
                  {
                    fud[2][i] = fu[i] ;
                    evalerr = evalerr || confuerr[i] ;
                  }
                  if ( evalerr  )
                  {
                    fprintf(stderr,"error signal from extern during numdiff 13 \n");
                    exit(1);
                  }
                  xincr  = xincr+xincr;
                  d1     = xincr;
                  xtr[j] = xhelp-xincr;
                  eval_extern(1);  /* must compute the full set of function values*/
                  confuerr[0] = ffuerr ;
                  evalerr = FALSE ;
                  for ( i = 0 ; i <= nonlin; i++ )
                  {
                    fud[3][i] = fu[i] ;
                    evalerr = evalerr || confuerr[i] ;
                  }
                  if ( evalerr  )
                  {
                    fprintf(stderr,"error signal from extern during numdiff 14 \n");
                    exit(1);
                  }

                  xtr[j] = xhelp+xincr;
                  eval_extern(1);  /* must compute the full set of function values*/
                  confuerr[0] = ffuerr ;
                  evalerr = FALSE ;
                  for ( i = 0 ; i <= nonlin; i++ )
                  {
                    fud[4][i] = fu[i] ;
                    evalerr = evalerr || confuerr[i] ;
                  }
                  if ( evalerr  )
                  {
                    fprintf(stderr,"error signal from extern during numdiff 15 \n");
                    exit(1);
                  }

                  xincr  = xincr+xincr;
                  d2     = xincr;
                  xtr[j] = xhelp-xincr;
                  eval_extern(1);  /* must compute the full set of function values*/
                  confuerr[0] = ffuerr ;
                  evalerr = FALSE ;
                  for ( i = 0 ; i <= nonlin; i++ )
                  {
                    fud[5][i]  = fu[i] ;
                    evalerr = evalerr || confuerr[i] ;
                  }
                  if ( evalerr  )
                  {
                    fprintf(stderr,"error signal from extern during numdiff 16 \n");
                    exit(1);
                  }
                  xtr[j] = xhelp+xincr;
                  eval_extern(1);  /* must compute the full set of function values*/
                  confuerr[0] = ffuerr ;
                  evalerr = FALSE ;
                  for ( i = 0 ; i <= nonlin; i++ )
                  {
                    fud[6][i] = fu[i] ;
                    evalerr = evalerr || confuerr[i] ;
                  }
                  if ( evalerr  )
                  {
                    fprintf(stderr,"error signal from extern during numdiff 17 \n");
                    exit(1);
                  }
                  xtr[j]    = xhelp;
                  d3        = xincr+xincr;
                  for ( i = 0 ; i <= nonlin ; i++ )
                  {
                     sd1 = (fud[2][i]
                            -fud[1][i])/d1;
                     sd2 = (fud[4][i]
                            -fud[3][i])/d2;
                     sd3 = (fud[6][i]
                           -fud[5][i])/d3;
                     sd3 = sd2-sd3;
                     sd2 = sd1-sd2;
                     sd3 = sd2-sd3; 
                     fugrad[j][i] =
                     (sd1+p4*sd2+sd3/c45);
                  }  /* end for i */
                } /* end central difference formula */
                else  if ( xhelp <= low[j]+4.0*xincr )
                { /* xtr[j] near the left end of its interval */
                   for ( k=0; k<= 6; k++ )
                   {
                     xtr[j] = xhelp +  k*xincr;
                     if ( k >= 1 )
                     {
                       eval_extern(1);  /* must compute the full set of function values*/
                       confuerr[0] = ffuerr ;
                       evalerr = FALSE ;
                       for ( i = 0 ; i <= nonlin; i++ )
                       {
                         fud[k][i] = fu[i] ;
                         evalerr = evalerr || confuerr[i] ;
                       }
                       if ( evalerr  )
                       {
                         fprintf(stderr,"error signal from extern during numdiff 18 \n");
                         exit(1);
                       }
                     }  
                   }/* end for k */
                   for ( i = 0 ; i <= nonlin ; i++)
                   {
                     sum=0.0 ;
                     for ( k=0; k<=6; k++)
                     {
                       sum += dcoef[k]*fud[k][i];
                     }
                     fugrad[j][i] = sum/(5040.0*xincr);
                   }
                   xtr[j]    = xhelp;
                }
                else 
                { /* xtr[j] near the right end of its interval */
                   for ( k=0; k<= 6; k++ )
                   {
                     xtr[j] = xhelp - k*xincr;
                     if ( k >= 1 )
                     {
                       eval_extern(1);  /* must compute the full set of function values*/
                       confuerr[0] = ffuerr ;
                       evalerr = FALSE ;
                       for ( i = 0 ; i <= nonlin; i++ )
                       {
                         fud[k][i]  = fu[i] ;
                         evalerr = evalerr || confuerr[i] ;
                       }
                       if ( evalerr  )
                       {
                         fprintf(stderr,"error signal from extern during numdiff 19 \n");
                         exit(1);
                       }
                     }  
                   }/* end for k */
                   for ( i = 0 ; i <= nonlin ; i++)
                   {
                     sum=0.0 ;
                     for ( k=0; k<=6; k++)
                     {
                       sum -= dcoef[k]*fud[k][i];
                     }
                     fugrad[j][i] = sum/(5040.0*xincr);
                   }
                   xtr[j]    = xhelp;
                }
              }/* end span > 0 */
            } /* end for j */
          } /* end difftype =3 */
    } /* end mode =1 */
    for ( i=0; i<= nonlin ; i++ )
    {
      fu[i] = fud[0][i] ;
    }
    valid = TRUE ;
    return;
}
