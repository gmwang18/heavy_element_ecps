/* **************************************************************************** */
/*                                 user functions                               */
/* **************************************************************************** */
#include "o8para.h"
main() {
    void donlp2(void);
    
    donlp2();
    
    exit(0);
}

/* **************************************************************************** */
/*                              donlp2-intv size initialization                           */
/* **************************************************************************** */
void user_init_size(void) {
    #define  X extern
    #include "o8comm.h"
    #include "o8fint.h"
    #include "o8cons.h"
    #undef   X


    /* problem dimension n = dim(x), nlin=number of linear constraints
       nonlin = number of nonlinear constraints  */
    
    n      = 16;
    nlin   =  0;
    nonlin =  0;
    iterma = 40;
    nstep = 20;
}

/* **************************************************************************** */
/*                            donlp2-intv standard setup                           */
/* **************************************************************************** */
void user_init(void) {
    #define  X extern
    #include "o8comm.h"
    #include "o8fint.h"
    #include "o8cons.h"
    #undef   X
    
    static INTEGER  i,j;

    /* loc_expt_1, loc_expt_3, loc_expt_2,loc_coeff_2, s_expt_1, s_coeff_1 */
    static DOUBLE   xst0[17] = {0.,/* not used : index 0 */
9.126564, 8.863223, 4.044948, 3.866657, 7.535754, 7.278926, 2.763205, 2.772085, -82.455357, 82.452670, -12.690183, 12.458423, -19.308744, 19.318449, -3.189516, 3.133446};
    static DOUBLE ugloc[17] = {0.,/* not used : index 0 */
                             0.50, 0.50, 0.50, 0.50, 0.50, 0.50, 0.5, 0.5, -500.0, -500.0 -500.0, -500.0, -500.0, -500.0, -500.0, -500.0};
     static DOUBLE ogloc[17] = {0.,/* not used : index 0 */
                             500.0, 500.0, 500.0, 500.0, 500.0, 500.0, 500.0, 500.0, 500.0, 500.0, 500.0, 500.0, 500.0, 500.0, 500.0, 500.0};
    

    /* name is ident of the example/user and can be set at users will       */
    /* the first static character must be alphabetic. 40 characters maximum */
    /* xst violates bounds : checks for automatic correction */
    strcpy(name,"statmatc");
     
    /* x is initial guess and also holds the current solution */

    silent = FALSE;
    analyt = FALSE;
    epsdif = 1.e-8;   /* gradients exact to machine precision */
    /* if you want numerical differentiation being done by donlp2 then:*/
    epsfcn   = 1.e-10; /* function values exact to machine precision */
    taubnd   = 10.0;
    /* bounds may be violated at most by taubnd in finite differencing */
    /*  bloc    = TRUE; */
    /* if one wants to evaluate all functions  in an independent process */
    difftype = 2; 
    
    nreset = n;
    
    
    del0 = 1.0e0;
    tau0 = 1.0e1;
    tau  = 0.1e0;
    for (i = 1 ; i <= n ; i++) {
        x[i] = xst0[i];
    }
    

    /*  set lower and upper bounds */
    big = 1.e20;
    for ( i = 1 ; i <= n ; i++ ) { low[i]=ugloc[i]; up[i]=ogloc[i];}

    /*low[3] = up[3] = 1.0;*/
    /* 1 linear equality constraint*/

    /*
    low[n+1] = 0.0;
    up[n+1] = big;
    low[n+2] = 0.0;
    up[n+2] = big;
    low[n+3] = 0.0;
    up[n+3] = big;
    */

    /* 1 nonlinear equality constraint*/

    /* store coefficients of linear constraints directly in gres */

    /* gres[1][1] = 1.0; */
    /* gres[2][1] = 1.0; */
    /* gres[3][1] = 1.0; */
    /* gres[4][1] = 1.0; */
    /* gres[5][1] = 1.0; */
    /* gres[6][1] = 1.0; */
    
    return;
}

/* **************************************************************************** */
/*                                 special setup                                */
/* **************************************************************************** */
void setup(void) {
    #define  X extern
    #include "o8comm.h"
    #undef   X
    te0=TRUE;
    te2=TRUE;
    te3=TRUE;
    return;
}

/* **************************************************************************** */
/*  the user may add additional computations using the computed solution here   */
/* **************************************************************************** */
void solchk(void) {
    #define  X extern
    #include "o8comm.h"
    #undef   X
    #include "o8cons.h"

    return;
}

/* **************************************************************************** */
/*                               objective function                             */
/* **************************************************************************** */
void ef(DOUBLE x[],DOUBLE *fx) {
    #define  X extern
    #include "o8fuco.h"
    #include <stdio.h>
    #include <stdlib.h>
    #undef   X

    static int i; 
    static double soq;
    double num;
    double mad;
    int nn;

    FILE *fp;
    FILE *fq;  
 
    fp = fopen("params.in", "w");
    if (fp == NULL) 
    {
      printf("I couldn't open params.in for writing.\n");
      exit(0);
    }

    for (i=1; i<=8; ++i)
    {
      fprintf(fp, "%.8f e%u  \n", x[i], i);
    }
    
    for (i=9; i<=n; ++i)
    {
      fprintf(fp, "%.8f c%u  \n", x[i], i-8);
    }

    fclose(fp);
    system("./script");

    fq = fopen("results.out", "r");
    if (fq == NULL) 
    {
      printf("I couldn't open results.out for reading.\n");
      exit(0);
    }

    num=0.0;
    mad=0.0;
    soq=0.0;
    nn=0;
    while ( fscanf(fq, "%lf", &num ) == 1 )  
    {
       mad+=fabs(num);
       soq+=num*num;
       nn+=1;
    } 
    fclose(fq);
    printf("SOQ: %f\n",soq);
    printf("MAD: %f\n",mad/(double)nn);

    *fx = soq;

    return;
}

/* **************************************************************************** */
/*                          gradient of objective function                      */
/* **************************************************************************** */
void egradf(DOUBLE x[],DOUBLE gradf[]) {
    #define  X extern
    #include "o8fuco.h"
    #undef   X

    static int i;
    static int j;
/*    static double sum; */
/*    sum=0.0; */
/*    for ( i=1; i<=2; i++) */
/*    { */
/*      sum+= pow( x[i] ,2); */
/*    } */
/*    *fx = sum; */
    static double soq;
    static double grad_soq;
    double num;
    double h;

    FILE *fp1;
    FILE *fp2;
    FILE *fq1;
    FILE *fq2;

    h=0.0001;

    printf("There shouldn't be an analytic gradient call.\n");

    for (i=1; i<=6; ++i)
    {
   
      grad_soq=0.0; 
      fp1 = fopen("params.in", "w");
      if (fp1 == NULL)
      {
        printf("I couldn't open params.in for writing.\n");
        exit(0);
      }

      for (j=1; j<=6; ++j)
      { 
        if (j == i)
        {
          fprintf(fp1, "%f x%u\n", x[j]+h, j);
        }
        else
        {
          fprintf(fp1, "%f x%u\n", x[j], j);
        }
      }

      fclose(fp1);
      printf("Calculating x[%d]+h.\n",i);
      /* system("./molpro_sim.sh");  */
   
      fq1 = fopen("results.out", "r");
      soq=0.0;
      while ( fscanf(fq1, "%lf", &num ) == 1 )
      {
        soq+=num;
      }
      fclose(fq1);

      grad_soq=soq/(2.0*h);


      fp2 = fopen("params.in", "w");
      if (fp2 == NULL)
      {
        printf("I couldn't open params.in for writing.\n");
        exit(0);
      }

      for (j=1; j<=6; ++j)
      {
        if (j == i)
        {
          fprintf(fp2, "%f x%u\n", x[j]-h, j);
        }
        else
        {
          fprintf(fp2, "%f x%u\n", x[j], j);
        }
      }

      fclose(fp2);
      printf("Calculating x[%d]-h.\n",i);
      /* system("./molpro_sim.sh"); */

      fq2 = fopen("results.out", "r");
      soq=0.0;
      while ( fscanf(fq2, "%lf", &num ) == 1 )
      {
        soq+=num;
      }
      fclose(fq2);

      grad_soq=grad_soq-(soq/(2.0*h));

      gradf[i]=grad_soq;

    }

    return;
}

/* **************************************************************************** */
/*  two nonlinear constraint */
/* **************************************************************************** */

void econ(INTEGER type ,INTEGER liste[], DOUBLE x[],DOUBLE con[],
              LOGICAL err[]) {
    #define  X extern
    #include "o8fuco.h"
    #undef   X

    static INTEGER i,j;
    static INTEGER liste_loc[3];
    /* the two nonlinear constraints are evaluated and stored in con[1],con[2] */
    /* if type != 1 only a selection is evaluated the indices being taken from */
    /* liste. since we have no evaluation errors here err is never touched */
    if ( type == 1 )
    {
       liste_loc[0] = 2 ;
       for ( i = 1 ; i<=2 ; i++ ) { liste_loc[i] = i ; }
    }
    else
    {
       liste_loc[0] = liste[0] ;
       for ( i = 1 ; i<=liste[0] ; i++ ) { liste_loc[i] = liste[i];}
    }

    /*
    for ( j = 1 ; j <= liste_loc[0] ; j++ )
    {
       i = liste_loc[j] ;
       switch (i) {
       case 1:
          con[1] = x[1]*x[11]+x[2]*x[12]+x[9]*x[17]+x[10]*x[18];  
          continue;
       case 2:
          con[2] = x[3]*x[13]+x[4]*x[14]+x[9]*x[17]+x[10]*x[18];  
          continue;
       case 3:
          con[3] = x[5]*x[15]+x[6]*x[16]+x[9]*x[17]+x[10]*x[18];  
       continue;
       }
    }
     */

    return;
}

/* **************************************************************************** */
/* **************************************************************************** */
void econgrad(INTEGER liste[] ,INTEGER shift ,  DOUBLE x[],
               DOUBLE **grad) {
    #define  X extern
    #include "o8fuco.h"
    #undef   X

    printf("There shouldn't be an analytic gradient call.\n");

    return;
}


/* **************************************************************************** */
/*                        user functions (if bloc == TRUE)                      */
/* **************************************************************************** */
void eval_extern(INTEGER mode) {
    #define  X extern
    #include "o8comm.h"
    #include "o8fint.h"
    #undef   X
    #include "o8cons.h"

    return;
}

