#include <stdio.h>
#include <stddef.h>
#include <math.h>
#include <stdlib.h>
#include<time.h>

#define CHARMAX 100

int main(int argc,char **argv)
{
 int i,t,NT;
 double T,dt,tt,*A,*E,E0,c,sum;
 char *filein_p,buffer[CHARMAX];
 FILE *input_p,*output_p;

 clock_t start_time, end_time;
 double cpu_time_used = ((double) (end_time - start_time)) / CLOCKS_PER_SEC;
 start_time = clock();


// Set constants
 
 c=137.035999074;
 
// Read in variables 
 
 if( argc !=5 )
  {
   printf("ERROR: should be %s T NT E0 <AFIELD> \n",argv[0]);
   exit(1);
  }
 
 if ( sscanf(argv[1],"%lf",&T) != 1 )
  {
   printf("Problem getting T from %s\n",argv[1]);
   exit(1);
  }  
 if ( sscanf(argv[2],"%d",&NT) != 1 )
  {
   printf("Problem getting NT from %s\n",argv[2]);
   exit(1);
  }
 if ( sscanf(argv[3],"%lf",&E0) != 1 )
  {
   printf("Problem getting E0 from %s\n",argv[2]);
   exit(1);
  }
    
 filein_p = argv[4];


 if( filein_p == NULL )
  {
   printf("Couldn't read input potential from %s\n",argv[4]);
   exit(1);
  }


// Calculate variables
 
 dt=T/(NT-1);
 

// Allocate memory 
 
 A = (double *)malloc(sizeof(double)*3*NT);
 E = (double *)malloc(sizeof(double)*3*NT);	

// Read in A field	
	
 input_p=fopen(filein_p,"r");	
 for(i=0;i<1;i++)
  {
   fgets(buffer,CHARMAX-1,input_p);
  } 	
 for(t=0;t<NT;t++)
  {
   fscanf(input_p,"%d %lf %lf %lf %lf",&i,&tt,&A[3*t],&A[3*t+1],&A[3*t+2]);
   //printf("%e %e %e\n",A[3*t],A[3*t+1],A[3*t+2]);  
  }
 fclose(input_p);
 	
// Make E field


 for(i=0;i<3;i++)
  {
   E[i]=0.0;
   E[3*(NT-1)+i]=0.0;
  }
  
 for(t=1;t<(NT-1);t++)
  {
   for(i=0;i<3;i++)
    {
     E[3*t+i]=-(1.0/c)*(A[3*(t+1)+i]-A[3*(t-1)+i])/(2.0*dt); 
    }
  }


 output_p=fopen("efield.dat","w");

 sum=0.0;

 for(t=0;t<NT;t++)
  {
   tt=t*dt;
   fprintf(output_p,"%lf %3.16f %3.16f %3.16f\n",tt,E[3*t],E[3*t+1],E[3*t+2]);	
   
   for(i=0;i<3;i++)
    {
     sum+= pow(E[3*t+i],2.0);	
    }   
  }
 
 sum*=dt;
 
 fclose(output_p); 

 printf("# Fluence %3.8f au\n",sum);
 printf("# Fluence %3.8f mJ/cm2\n",sum*848.89650302);
  
// Free memory 	
 free(A);
 free(E);	


 end_time = clock();
 printf("this routine takes %lf s to run\n", cpu_time_used);
// Exit	
 exit(0);	
}
