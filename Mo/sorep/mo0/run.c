#include "o8para.h"

main() {
    void donlp2(void);
    
    donlp2();
    
    exit(0);
}

static INTEGER D=2;
static INTEGER N=6;
static INTEGER DIM=13;
void user_init_size(void) {
    #define  X extern
    #include "o8comm.h"
    #include "o8fint.h"
    #include "o8cons.h"
    #undef   X


    /* problem dimension n = dim(x), nlin=number of linear constraints
       nonlin = number of nonlinear constraints  */
    
    n      = DIM;
    nlin   =  0;
    nonlin =  N+N*(N+1)/2;
    iterma = 4000;
    nstep = 20;
}

void user_init(void) {
#define  X extern
#include "o8comm.h"
    
#include "o8fint.h"
    
#undef   X
    
    static INTEGER i,j,k;
    
    del0=big;
    tau0=big;
    tau=0.1;
    analyt=FALSE;
    difftype=2;  /* quadratics only*/
    epsfcn=1.0e-16;
    strcpy(name,"kissings");
    j=1;
    for (k=0; k<=N-1; k++){
      
      for (i=1; i<=D; i++){
        x[D*k+i]=4.0/sqrt(D);
      }
      x[D*k+j]=-x[D*k+j];
      j+=1; 
      if ( j > D ) { j=1;}
    }
    x[n]=-20.0; /*alpha*/
    for ( i=1; i<=n; i++){
        low[i]=-big; up[i]=big;
    }
    for ( i=1; i<=N; i++ )
    {
        low[i+n]=up[i+n]=4.0;
    } 
    for ( i=1; i<=N*(N+1)/2; i++){
       low[i+n+N]=-big; up[i+n+N]=4.0;
    }
    return;
}

void setup(void) {
    #define  X extern
    #include "o8comm.h"
    #undef   X
    te0=TRUE;
    epsx=1.0e-8;
    delmin=1.0e-8;
    rho=1.0;
    rho1=1.0e-10;
    return;
}

void solchk(void) {
    #define  X extern
    #include "o8comm.h"
    #undef   X
    #include "o8cons.h"

    return;
}
void ef(DOUBLE x[],DOUBLE *fx) {
    #define  X extern
    #include "o8fuco.h"
    #undef   X

  
    *fx = -x[n];
    
    return;
}

void egradf(DOUBLE x[],DOUBLE gradf[]) {
    #define  X extern
    #include "o8fuco.h"
    #undef   X

    return;
}


void econ(INTEGER type ,INTEGER liste[], DOUBLE x[],DOUBLE con[], 
              LOGICAL err[]) {
    #define  X extern
    #include "o8fuco.h"
    #undef   X
    
    /* we compute them all , irrespective of type */
    static INTEGER i,j,k,l;
    static DOUBLE sum;
    /* N equality constraints: length of partial vector ^2 (is 4) */
    for ( i=0; i<=N-1; i++)
    { sum=0.0;
        for ( j=1; j<=D; j++)
        { 
          sum +=pow(x[D*i+j],2);
        }
      con[i+1]=sum;
    }
    k=N;
    for ( i=0; i<=N-1; i++)
    {
       for ( j=i+1; j<=N-1; j++ )
       {
         sum=2.0*x[n];
         for ( l=1; l<=D; l++)
         {
           sum+= x[i*D+l]*x[j*D+l] ;
         }
         k+=1;
         con[k]=sum;
       }
    }
    return;
}

void econgrad(INTEGER liste[] ,INTEGER shift ,  DOUBLE x[],
               DOUBLE **grad) {

    #define  X extern
    #include "o8fuco.h"
    #undef   X

    return;
}
void eval_extern(INTEGER mode) {
    #define  X extern
    #include "o8comm.h"
    #include "o8fint.h"
    #undef   X
    #include "o8cons.h"

    return;
}

