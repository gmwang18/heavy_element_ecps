#include "o8para.h"

#define  X  

#include "o8comm.h"
#include "o8fint.h"

#undef X
const DOUBLE zero = 0.e0,one = 1.e0,two = 2.e0,three = 3.e0,four = 4.e0,
five = 5.e0,six = 6.e0,seven = 7.e0,
twom2 = .25e0,twop4 = 16.e0,twop11 = 2048.e0,onep3 = 1.3e0,
onep5 = 1.5e0,p2 = .2e0,p4 = .4e0,p5 = .5e0,p7 = .7e0,p8 = .8e0,p9 = .9e0,
c45 = 45.e0,tm12 = 1.e-12,
tm10 = 1.e-10,tm9 = 1.e-9,tm8 = 1.e-8,tm7 = 1.e-7,tm6 = 1.e-6,tm5 = 1.e-5,
tm4 = 1.e-4,tm3 = 1.e-3,tm2 = 1.e-2,tm1 = 1.e-1,tp1 = 1.e1,tp2 = 1.e2,
tp3 = 1.e3,tp4 = 1.e4 ;

 
static INTEGER *liste;
static  DOUBLE **err,  *yy, *gnorm;



/* ARRAY_BORDER_CHECK: Check array borders for indices writing off
   the end of arrays.  Turn off by commenting out the line
   "#define ARRAY_BORDER_CHECK".  It is recommended that  ARRAY_BORDER_CHECK
   be turned off during regular use and  turned on for debugging
   and testing only.  The function "checkArrayBorders" checks if there has been
   any array border violations up to point where it is called.  It is currently
   called at the beginning and end of donlp2 if border checking is turned on.
   To find the location of the first border violation insert additional 
   calls to the function narrowing the bracketing on the initial border 
   violation occurance.  Additionally, the values of the border counters
   (d_borders_count, i_borders_count, l_borders_count) can be printed
   out at various locations in global_mem_malloc to find out
   which array has been assigned which index. */

#define ARRAY_BORDER_CHECK

  
#ifdef ARRAY_BORDER_CHECK
#define ABC 1
#else
#define ABC 0
#endif

#ifdef ARRAY_BORDER_CHECK

#define ABC_NUM_1DARRAYS 100000
DOUBLE  *d_borders[2*ABC_NUM_1DARRAYS];
INTEGER *i_borders[2*ABC_NUM_1DARRAYS];
LOGICAL *l_borders[2*ABC_NUM_1DARRAYS];
const DOUBLE  d_unique = 1.23413936727;
const INTEGER i_unique = 972897426;
const LOGICAL l_unique = 953712449;
INTEGER d_borders_count = 0;
INTEGER i_borders_count = 0;
INTEGER l_borders_count = 0;
extern void checkArrayBorders(char *str);
#endif


/* ************************************************************************* */
/*                      testprogram for egradf,econgrad of donlp2_intv       */
/* ************************************************************************* */
main(void) {
    void global_mem_malloc();
    void global_mem_free();
    void    setup0 (void);
    void    user_init_size(void);
    void    user_init(void);
    void    setup (void);
    void    ef    (DOUBLE x[],DOUBLE *fx);
    void    egradf(DOUBLE x[],DOUBLE gradf[]);
    void    econ   (INTEGER type ,INTEGER liste[] , DOUBLE x[],DOUBLE con[],
            LOGICAL error[]);
    void    econgrad(INTEGER liste[],INTEGER shift, 
              DOUBLE x[],DOUBLE **grad);
    DOUBLE  vecnor(INTEGER n,DOUBLE x[]);
    void matdr2(DOUBLE **a,INTEGER ma,
                INTEGER shift, INTEGER na,
                char head[],FILE *lognum,LOGICAL fix,INTEGER nd1,INTEGER nd2);
    
    static INTEGER  i,j,k,countc;
    
    static DOUBLE   errtol,term,fx,fx0;
    static DOUBLE   one = 1.;
    static LOGICAL  ffuerr,errfnd,inx;
    static char     head[41];
    static FILE     *buf;

/*  set dimensions of the problem */
    user_init_size();
    global_mem_malloc();

#ifdef ARRAY_BORDER_CHECK
    checkArrayBorders("testgrad_dyn: after global_mem_malloc");
#endif
  epsmac=2.2e-16;
/* define other variables for initialization */    
  user_init();
  liste[0]=nonlin;
  for ( i = 1 ; i <= nonlin ; i++) 
  {
      liste[i] = i ;
  }
  setup();
  
  countc = 0;
   
  printf("testprogram for egradf,econgrad\n");
  printf("required input in standard format\n");
  printf("output in file testgrad.res\n");
  printf("input: stepsize for num. diff. = ");
  scanf ("%le", &epsx);
  printf("we check precision relative to the norm of \n");
  printf("the presumably correct analytic gradient\n");
  printf("input feasible error tolerance = ");
  scanf ("%le", &errtol);
  printf("output of true gradients desired? (1/0) ");
  scanf ("%i", &te1);
   
  buf = fopen("testgrad.res","w");
    
  inx = TRUE ;

  while (inx) {

    printf("input of x desired (1/0)(otherwise taken from setup)\n ");
    scanf ("%i", &inx);
    
    if ( inx ) {
        for (i = 1 ; i <= n ; i++) {
            printf("x[%3i] = ? ", i);
            scanf ("%le", &x[i]);
        }
    } else {
     if ( countc > 0 ) 
       { break;
       }
       inx = TRUE ;
    }
    ffuerr = FALSE;
    for ( i = 1; i <= nonlin ; i++ )
    {
      confuerr[i] = FALSE ;
    }
    ef(x,&fx);

    egradf(x,gradf);

    gnorm[0] = max(one,vecnor(n,gradf));

    econ ( 1, liste , x , res , confuerr );

    for ( i = 1 ;  i<=nonlin ; i++ ) { ffuerr = ffuerr || confuerr[i] ;}
    if ( ffuerr )
    {
   printf(" one of the problem functions returns error=TRUE for this x \n");
      break;
    }
    econgrad(liste,nlin,x,gres);

    for (i = 1 ; i <= nonlin; i++) {
       for ( j = 1 ; j <= n; j++ ) {
         yy[j]=gres[j][i+nlin];
       }
       gnorm[i]=max(one,vecnor(n,yy));
    }    
    if ( te1 ) {
        strcpy(head,"your analytic  gradients of constraints");
        fprintf(buf,"analytic gradient of f\n");
        for (i = 1 ; i <= n ; i+= 4) {
            fprintf(buf,"    %4i   ", i);
            for (j = 0 ; j <= min(n-i,3) ; j++) {
                fprintf(buf,"  %13.6e", gradf[i+j]);
            }
            fprintf(buf,"\n");
        }

        matdr2(gres,n,nlin,nonlin,head,buf,FALSE,0,7);
    }

    for (i = 1 ; i <= n ; i++) {
        for (j = 1 ; j <= n ; j++) {
            x0[j] = x[j];
        }
        term  = epsx*max(one,fabs(x0[i]));
        x0[i] = x0[i]+term;
         
        ef(x0,&fx0);
         
        err[i][0] = ((fx0-fx)/term-gradf[i])/gnorm[0];
        econ(1,liste,x0,res0,confuerr);
        for ( j = 1 ; j<=nonlin ; j++ ){    
            err[i][j] = ((res0[j]-res[j])/term-gres[i][nlin+j])/gnorm[j];
        }
    }
    fprintf(buf,"protocol of errors\n");
    for (i = 0 ; i <= nonlin ; i++) {
        errfnd = FALSE;
        for (j = 1 ; j <= n ; j++) {
            if ( fabs(err[j][i]) > errtol ) {
                errfnd = TRUE;
            }
        }
        if ( errfnd ) {
            fprintf(buf,"gradient nr. %i\n", i);
            for (k = 1 ; k <= n ; k+= 4) {
                fprintf(buf,"    %4i   ", k);
                for (j = 0 ; j <= min(n-k,3) ; j++) {
                    fprintf(buf,"  %13.6e", err[k+j][i]);
                }
                fprintf(buf,"\n");
            }
            fprintf(buf,"norm of analytic gradient  %10.4e\n\n", gnorm[i]);
        } else {
            fprintf(buf,"grad. nr. %4i : no errors found\n", i);
        }
    }
    countc = countc+1;
 }


    if ( countc >= 1 ) {
            printf("results written in testgrad.res\n");
            fclose(buf);
#ifdef ARRAY_BORDER_CHECK
    checkArrayBorders("testgrad_dyn: on exit ");
#endif
            global_mem_free();

            exit(0);
        }

}

/* **************************************************************************** */
/*                      euclidean norm of x , avoid overflow                    */
/* **************************************************************************** */
DOUBLE vecnor(INTEGER n,DOUBLE x[]) {
    
    static INTEGER  i;
    static DOUBLE   xm,h;
    
    if ( n <= 0 ) {

        return 0.e0;
    }
    xm = fabs(x[1]);
    for (i = 2 ; i <= n ; i++) {
        xm = max(xm,fabs(x[i]));
    }
    if ( xm == 0.e0 ) {

        return 0.e0;
        
    } else {
        h = 0.e0;
        for (i = 1 ; i <= n ; i++) {
            h = h+pow(x[i]/xm,2);
        }
        return xm*sqrt(h);
    }
}

/* **************************************************************************** */
/* subprogram for structured output of a matrix                                 */
/* uses a run time computed  format string                                      */
/* **************************************************************************** */
void matdr2(DOUBLE **a,INTEGER ma,
            INTEGER shift,INTEGER na,
            char head[],FILE *lognum,LOGICAL fix,INTEGER nd1,INTEGER nd2) {
            
    /* prints the matrix a on unit lognum using f-format if fix = TRUE          */
    /* and e-format otherwise with nd2 digits behind the point                  */
    /* if fix = FALSE nd1 is not used and treated as nd1 = 0                    */
    /* ma <= number of rows, number of columns must be>shift+na       */
    /* in the calling program unit and ma , na the dimensions actually used     */
    /*                                                                         */
    /* output is for 80-column-devices. otherwise the parameter pwid below      */
    /* may be changed                                                           */

    static INTEGER       anz,i,j,ju,jo,width,spacl,spacr;
    static const INTEGER pwid = 80;
    
    static char form1[22];
    static char form2[10];
    
    if (  nd1 < 0 || nd2 <= 0 ) {
        fprintf(lognum,"%s\n",head);
        fprintf(lognum,"erroneous call of matdr2\n");
        
        return;
    }
    if ( ma > 999 || na > 999 ) {
        fprintf(lognum,"%s\n",head);
        fprintf(lognum,"called matdru with dim too large\n");
         
        return;
    }
    if ( fix ) {
        width = nd1+nd2+3;
    } else {
        width = nd2+7;
    }
    fprintf(lognum,"\n %s\n", head);
    
    anz   = (pwid-11)/(width+1);
    spacl = (width+1-3)/2;
    spacr = width+1-3-spacl;
    
    form1[0] = '\0';
    for (i = 1 ; i <= spacl ; i++) strcat(form1," ");
    strcat(form1,"%3i");
    for (i = 1 ; i <= spacr ; i++) strcat(form1," ");
    
    if ( fix ) {
        if ( width < 10 && nd2 < 10 )
        {
           sprintf(form2,"%%%1i.%1if " , width  ,nd2);
        }
        else if ( width >= 10 && nd2 < 10 )
        {
          sprintf(form2,"%%%2i.%1if " , width  ,nd2);
        }
        else 
        {
          sprintf(form2,"%%%2i.%2if " , width  ,nd2);
        }
    } else {
        if ( width < 10 && nd2 < 10 )
        {
           sprintf(form2,"%%%1i.%1ie " , width  ,nd2);
        }
        else if ( width >= 10 && nd2 < 10 )
        {
          sprintf(form2,"%%%2i.%1ie " , width  ,nd2);
        }
        else
        {   
          sprintf(form2,"%%%2i.%2ie " , width  ,nd2);
        }

    }
     
    jo = 0;
    while  ( jo < na ) {
        ju = jo+1;
        jo = min(ju+anz-1,na);
        fprintf(lognum," row/column");
        for (j = ju ; j <= jo ; j++) {
            fprintf(lognum,form1,j);
            if ((j-ju+1) % anz == 0 || j == jo) fprintf(lognum,"\n");
        }
        for (i = 1 ; i <= ma ; i++) {
            fprintf(lognum,"    %4i    ", i);
            for (j = ju ; j <= jo ; j++) {
                fprintf(lognum,form2, a[i][j+shift]);
                if ((j-ju+1) % anz == 0 || j == jo) fprintf(lognum,"\n");
            }
        }
    }
    return;
}


/* **************************************************************************** */
/* suite of functions to allocate and free memory for dynamic memory allocation */
/* **************************************************************************** */

#ifdef ARRAY_BORDER_CHECK
/**********************************************************************/
/***           check 1D array borders for any violations        *******/
/**********************************************************************/
void checkArrayBorders(char *str) 
{
    INTEGER i, violations;
    violations = 0;

    /* Check integer borders */
    for (i=0; i<i_borders_count; i++) {
        if (**(i_borders+2*i) != i_unique) {
            printf("checkArrayBorders: Integer 1D array index %4d:  start border violated\n", i);  
            fflush(stdout);
            violations++;
        }
        if (**(i_borders+2*i+1) != i_unique) {
            printf(" checkArrayBorders: Integer 1D array index %4d:  end border violated\n", i);  
            fflush(stdout);
            violations++;
        }
    }
    
    /* Check double borders */
    for (i=0; i<d_borders_count; i++) {
        if (**(d_borders+2*i) != d_unique) {
            printf("checkArrayBorders: Double  1D array index %4d:  start border violated\n", i);  
            fflush(stdout);
            violations++;
        }
        if (**(d_borders+2*i+1) != d_unique) {
            printf("checkArrayBorders: Double  1D array index %4d:  end border violated\n", i);  
            fflush(stdout);
            violations++;
        }
    }
    
    /* Check logical borders */
    for (i=0; i<l_borders_count; i++) {
        if (**(l_borders+2*i) != l_unique) {
            printf(" checkArrayBorders: Logical 1D array index %4d:  start border violated\n", i);  
            fflush(stdout);
            violations++;
        }
        if (**(l_borders+2*i+1) != l_unique) {
            printf(" checkArrayBorders: Logical 1D array index %4d:  end border violated\n", i);  
            fflush(stdout);
            violations++;
        }
    }

    if (violations == 0) 
        printf("checkArrayBorders: no violations: %s\n", str);
    else
        printf("checkArrayBorders: ************** violations %4d:  %s\n", violations, str);
    fflush(stdout);
}
#endif


/**********************************************************************/
/***              allocate memory for integer 1D array          *******/
/**********************************************************************/

INTEGER* i1_malloc(INTEGER size1, INTEGER init)
{

    /* Allocate INTEGER precision array with length "size1"          */
    /* assuming zero origin.  If initialize is non zero             */
    /* then initize the allocated array to zero.                    */   

    INTEGER* array;
    INTEGER i,j;
    
    array = (INTEGER*) malloc((size_t) (size1+2*ABC)*sizeof(INTEGER));
    if (!array) {
        fprintf(stderr, "ERROR: i1_malloc: memory error: malloc failed");  
        exit(-1);
    }

#ifdef ARRAY_BORDER_CHECK
    /* setup array borders */
    if (i_borders_count > 2*ABC_NUM_1DARRAYS-4) {
        printf("ERROR: ARRAYBORDERS: ABC_NUM_1DARRAYS is too small\n");
	exit(-1);
    }	
    array[0] = i_unique;
    i_borders[2*i_borders_count] = &(array[0]);
    array[size1+1] = i_unique;
    i_borders[2*i_borders_count+1] = &(array[size1+1]);
    i_borders_count++;
    array++;
#endif    

    /* initialize the array to 0 */
    if (init) {
        for (i=0; i<size1; i++) 
            array[i] = 0;
    }

    return array;
}


/**********************************************************************/
/***                free memory for INTEGER 1D array             *******/
/**********************************************************************/
void i1_free(INTEGER* array) 
{
    INTEGER i;

    /* Check for null pointer */
    if (!array) {
        fprintf(stderr, "ERROR: i1_free: memory error: pointer is null");  
        exit(-1);
    }

    /* Free the memory for the INTEGER 1D array */
    free(array-ABC);
}

/**********************************************************************/
/***              allocate memory for INTEGER 2D array           *******/
/**********************************************************************/
INTEGER** i2_malloc(INTEGER size1, INTEGER size2, INTEGER init) 
{

    /* Allocate INTEGER precision array with lengths "size1" and     */
    /* size2 assuming zero origin.  If initialize is non zero       */
    /* then initize the allocated array to zero.                    */   

    INTEGER** array;
    INTEGER* arraytemp;
    INTEGER i,j;
    
    array = (INTEGER**) malloc((size_t) size1*sizeof(INTEGER*));
    if (!array) {
        fprintf(stderr, "ERROR: d2_malloc: memory error: malloc failed");  
        exit(-1);
    }
    for (i=0; i<size1; i++) {
        arraytemp = (INTEGER*) malloc((size_t) (size2+2*ABC)*sizeof(INTEGER));
        if (!arraytemp) {  
            fprintf(stderr, "ERROR: d2_malloc: memory error: malloc failed");  
            exit(-1);
        }
	
#ifdef ARRAY_BORDER_CHECK
        /* setup array borders */
        if (i_borders_count > 2*ABC_NUM_1DARRAYS-4) {
            printf("ERROR: ARRAY_BORDERS_CHECK: ABC_NUM_1DARRAYS is too small\n");
	    exit(-1);
        }	
        arraytemp[0] = i_unique;
        i_borders[2*i_borders_count] = &(arraytemp[0]);
        arraytemp[size2+1] = i_unique;
        i_borders[2*i_borders_count+1] = &(arraytemp[size2+1]);
        i_borders_count++;
#endif
        array[i] = arraytemp + ABC;
    }

    if (init) {
       for (i=0; i<size1; i++) 
           for (j=0; j<size2; j++) 
               array[i][j] = 0.0;
    }

    return array;
}

/**********************************************************************/
/***                free memory for INTEGER 2D array             *******/
/**********************************************************************/
void i2_free(INTEGER** array, INTEGER size1) 
{
    INTEGER i;

    /* Check for null pointer */
    if (!array) {
        fprintf(stderr, "ERROR: d2_free: memory error: pointer is null");  
        exit(-1);
    }

    /* Free the memory for the INTEGER 2D array piece by piece */
    for (i=0; i<size1; i++) 
        free(array[i]-ABC);
    free(array);
}


/**********************************************************************/
/***              allocate memory for double 1D array           *******/
/**********************************************************************/
DOUBLE* d1_malloc(INTEGER size1, INTEGER init) 
{

    /* Allocate DOUBLE precision array with length "size1"          */
    /* assuming zero origin.  If initialize is non zero             */
    /* then initize the allocated array to zero.                    */   

    DOUBLE* array;
    INTEGER i,j;
    
    array = (DOUBLE*) malloc((size_t) (size1+2*ABC)*sizeof(DOUBLE));
    if (!array) {
        fprintf(stderr, "ERROR: d1_malloc: memory error: malloc failed");  
        exit(-1);
    }

#ifdef ARRAY_BORDER_CHECK
    /* setup array borders */
    if (d_borders_count > 2*ABC_NUM_1DARRAYS-4) {
        printf("ERROR: ARRAYBORDERS: ABC_NUM_1DARRAYS is too small\n");
	exit(-1);
    }	
    array[0] = d_unique;
    d_borders[2*d_borders_count] = &(array[0]);
    array[size1+1] = d_unique;
    d_borders[2*d_borders_count+1] = &(array[size1+1]);
    d_borders_count++;
    array++;
#endif

    if (init) {
        for (i=0; i<size1; i++) 
            array[i] = 0.0;
    }

    return array;
}

/**********************************************************************/
/***                free memory for DOUBLE 1D array             *******/
/**********************************************************************/
void d1_free(DOUBLE* array) 
{
    INTEGER i;

    /* Check for null pointer */
    if (!array) {
        fprintf(stderr, "ERROR: d1_free: memory error: pointer is null");  
        exit(-1);
    }

    /* Free the memory for the DOUBLE 1D array */
    free(array-ABC); 
}

/**********************************************************************/
/***              allocate memory for DOUBLE 2D array           *******/
/**********************************************************************/
DOUBLE** d2_malloc(INTEGER size1, INTEGER size2, INTEGER init) 
{

    /* Allocate DOUBLE precision array with lengths "size1" and     */
    /* size2 assuming zero origin.  If initialize is non zero       */
    /* then initize the allocated array to zero.                    */   

    DOUBLE** array;
    DOUBLE* arraytemp;
    INTEGER i,j;
    
    array = (DOUBLE**) malloc((size_t) size1*sizeof(DOUBLE*));
    if (!array) {
        fprintf(stderr, "ERROR: d2_malloc: memory error: malloc failed");  
        exit(-1);
    }
    for (i=0; i<size1; i++) {

        /* Allocate memory */
        arraytemp = (DOUBLE*) malloc((size_t) (size2+2*ABC)*sizeof(DOUBLE));
        if (!arraytemp) {  
            fprintf(stderr, "ERROR: d2_malloc: memory error: malloc failed");  
            exit(-1);
        }

#ifdef ARRAY_BORDER_CHECK
        /* setup array borders */
        if (d_borders_count > 2*ABC_NUM_1DARRAYS-4) {
            printf("ERROR: ARRAY_BORDERS_CHECK: ABC_NUM_1DARRAYS is too small\n");
	    exit(-1);
        }	
        arraytemp[0] = d_unique;
        d_borders[2*d_borders_count] = &(arraytemp[0]);
        arraytemp[size2+1] = d_unique;
        d_borders[2*d_borders_count+1] = &(arraytemp[size2+1]);
        d_borders_count++;
#endif
        array[i] = arraytemp + ABC;
    }

    if (init) {
       for (i=0; i<size1; i++) 
           for (j=0; j<size2; j++) 
               array[i][j] = 0.0;
    }

    return array;
}

/**********************************************************************/
/***                free memory for DOUBLE 2D array             *******/
/**********************************************************************/
void d2_free(DOUBLE** array, INTEGER size1) 
{
    INTEGER i;

    /* Check for null pointer */
    if (!array) {
        fprintf(stderr, "ERROR: d2_free: memory error: pointer is null");  
        exit(-1);
    }

    /* Free the memory for the DOUBLE 2D array piece by piece */
    for (i=0; i<size1; i++) 
        free(array[i]-ABC);
    free(array);
}

/**********************************************************************/
/***              allocate memory for LOGICAL 1D array           *******/
/**********************************************************************/
LOGICAL* l1_malloc(INTEGER size1, INTEGER init) 
{

    /* Allocate LOGICAL precision array with length "size1"          */
    /* assuming zero origin.  If initialize is non zero             */
    /* then initize the allocated array to zero.                    */   

    LOGICAL* array;
    INTEGER i,j;
    
    array = (LOGICAL*) malloc((size_t) (size1+2*ABC)*sizeof(LOGICAL));
    if (!array) {
        fprintf(stderr, "ERROR: l1_malloc: memory error: malloc failed");  
        exit(-1);
    }

#ifdef ARRAY_BORDER_CHECK
    /* setup array borders */
    if (i_borders_count > 2*ABC_NUM_1DARRAYS-4) {
        printf("ERROR: ARRAYBORDERS: ABC_NUM_1DARRAYS is too small\n");
	exit(-1);
    }	
    array[0] = i_unique;
    i_borders[2*i_borders_count] = &(array[0]);
    array[size1+1] = i_unique;
    i_borders[2*i_borders_count+1] = &(array[size1+1]);
    i_borders_count++;
    array++;
#endif

    if (init) {
        for (i=0; i<size1; i++) 
            array[i] = 0.0;
    }

    return array;
}

/**********************************************************************/
/***                free memory for LOGICAL 1D array             *******/
/**********************************************************************/
void l1_free(LOGICAL* array) 
{
    INTEGER i;

    /* Check for null pointer */
    if (!array) {
        fprintf(stderr, "ERROR: l1_free: memory error: pointer is null");  
        exit(-1);
    }

    /* Free the memory for the LOGICAL 1D array */
    free(array-ABC);
}

/**********************************************************************/
/***              allocate memory for LOGICAL 2D array           *******/
/**********************************************************************/
LOGICAL** l2_malloc(INTEGER size1, INTEGER size2, INTEGER init)
{

    /* Allocate LOGICAL precision array with lengths "size1" and     */
    /* size2 assuming zero origin.  If initialize is non zero       */
    /* then initize the allocated array to zero.                    */   

    LOGICAL** array;
    LOGICAL* arraytemp;
    INTEGER i,j;
    
    array = (LOGICAL**) malloc((size_t) size1*sizeof(LOGICAL*));
    if (!array) {
        fprintf(stderr, "ERROR: l2_malloc: memory error: malloc failed");  
        exit(-1);
    }
    for (i=0; i<size1; i++) {
        arraytemp = (LOGICAL*) malloc((size_t) (size2+2*ABC)*sizeof(LOGICAL));
        if (!arraytemp) {  
            fprintf(stderr, "ERROR: l2_malloc: memory error: malloc failed");  
            exit(-1);
        }
	
#ifdef ARRAY_BORDER_CHECK
        /* setup array borders */
        if (i_borders_count > 2*ABC_NUM_1DARRAYS-4) {
            printf("ERROR: ARRAY_BORDERS_CHECK: ABC_NUM_1DARRAYS is too small\n");
	    exit(-1);
        }	
        arraytemp[0] = i_unique;
        i_borders[2*i_borders_count] = &(arraytemp[0]);
        arraytemp[size2+1] = i_unique;
        i_borders[2*i_borders_count+1] = &(arraytemp[size2+1]);
        i_borders_count++;
#endif
        array[i] = arraytemp + ABC;
    }

    if (init) {
       for (i=0; i<size1; i++) 
           for (j=0; j<size2; j++) 
               array[i][j] = 0.0;
    }

    return array;
}

/**********************************************************************/
/***                free memory for LOGICAL 2D array             *******/
/**********************************************************************/
void l2_free(LOGICAL** array, INTEGER size1) 
{
    INTEGER i;

    /* Check for null pointer */
    if (!array) {
        fprintf(stderr, "ERROR: l2_free: memory error: pointer is null");  
        exit(-1);
    }

    /* Free the memory for the LOGICAL 2D array piece by piece */
    for (i=0; i<size1; i++) 
        free(array[i]-ABC);
    free(array);
}


/**********************************************************************/
/***              allocate memory for global arrays            *******/
/**********************************************************************/
void global_mem_malloc() {

    x          = d1_malloc(n+1, 1);
    x0         = d1_malloc(n+1, 1);
    gradf      = d1_malloc(n+1, 1);
    gres       = d2_malloc(n+1, nlin+nonlin+1, 1);
    err        = d2_malloc(n+1, nlin+nonlin+1, 1);
    gnorm      = d1_malloc(nlin+nonlin+1, 1);
    liste      = i1_malloc(2*(n+nlin+nonlin)+1, 1);
    res        = d1_malloc(2*(n+nlin+nonlin)+1, 1);
    res0       = d1_malloc(2*(n+nlin+nonlin)+1, 1);
    res1       = d1_malloc(2*(n+nlin+nonlin)+1, 1);
    low        = d1_malloc(n+nlin+nonlin+1,  1);
    up         = d1_malloc(n+nlin+nonlin+1,  1);
    xsc        = d1_malloc(n+1, 1);
    fu         = d1_malloc(nlin+nonlin+1, 1);
    fugrad     = d2_malloc(n+1, nlin+nonlin+1, 1);
    fud        = d2_malloc(nlin+nonlin+1, 7, 1);
    yy         = d1_malloc(n+1, 1);
    confuerr   = l1_malloc(nlin+nonlin+1, 1);

}

/**********************************************************************/
/***                free memory from global arrays              *******/
/**********************************************************************/
void global_mem_free() {

    /* GLOBAL VARIABLES USED GLOBALLY */

    d1_free(x);
    d1_free(x0);
    d1_free(gradf);
    d2_free(gres, n+1);
    d2_free(err, n+1); 
    d1_free(gnorm); 
    i1_free(liste); 
    d1_free(low);
    d1_free(up);
    d1_free(res);    
    d1_free(res0);   
    d1_free(res1);
    d1_free(xsc);
    d1_free(fu);
    d2_free(fugrad, n+1);
    d2_free(fud, nlin+nonlin+1);
    d1_free(yy); 
    l1_free(confuerr);
}


   
