# include "o8para.h"
int main(void){
 static time_t   tim;
time(&tim);
printf("%s",ctime(&tim));
exit(0);
}

