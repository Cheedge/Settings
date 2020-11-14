#include<stdio.h>
#include<math.h>
#include<stdlib.h>
#include<time.h>

#define BUFFSIZE 500

int main(int argc, char* argv[])
{
	int i, j, k, N;
	double x, y, z, ti;
	double *Ax, *Ay, *Az, *Ex, *Ey, *Ez, *t, *delta;
	double C, sumE;
	char buffer[BUFFSIZE], bu[5];
	char* in_file;
	FILE* fpt_in;
	FILE* fpt_out;

	clock_t start_time, end_time;
	double cpu_time_used;
	start_time = clock();
	
	C = -137.035999074;

	if(argc < 2)
	{
		printf("problem input, the 2nd input should as <file_input> %s", argv[1]);
		return 1;
	}
	//fpt_in = argv[1];
	if((fpt_in = fopen(argv[1], "r"))==NULL)
	{
		printf("problem input files");
		return 1;
	}
	//N = fgetc(fpt_in);
	fgets(buffer, 50, fpt_in);
	sscanf(buffer, "%d %s %s %s %s", &N, &bu[0], &bu[1], &bu[2], &bu[3]);
	i = 0;
	fpt_out = fopen("EFIELD.DAT", "w");

	Ax = (double *)malloc(sizeof(double)*N);
	Ay = (double *)malloc(sizeof(double)*N);
	Az = (double *)malloc(sizeof(double)*N);
	t = (double *)malloc(sizeof(double)*N);
	Ex = (double *)malloc(sizeof(double)*(N-1));
	Ey = (double *)malloc(sizeof(double)*(N-1));
	Ez = (double *)malloc(sizeof(double)*(N-1));
	delta = (double *)malloc(sizeof(double)*(N-1));

	while(fgets(buffer, BUFFSIZE-1, fpt_in)!=NULL)
	{
		sscanf(buffer, "%d %lf %lf %lf %lf", &k, &ti, &x, &y, &z);
		t[i] = ti;
		Ax[i] = x;
		Ay[i] = y;
		Az[i] = z;
		i++;
	}
	Ex[0]=0.0;
	Ey[0]=0.0;
	Ez[0]=0.0;
	delta[0]=0.0;

	for (i = 0; i < N-2; i++)
	{
		delta[i+1] = t[i+2] - t[i];
		Ex[i+1] = (Ax[i+2]-Ax[i])/(C * delta[i+1]);
		Ey[i+1] = (Ay[i+2]-Ay[i])/(C * delta[i+1]);
		Ez[i+1] = (Az[i+2]-Az[i])/(C * delta[i+1]);
		/* convert Hartree to V/angstrom */
		fprintf(fpt_out, "%lf %16.10f %16.10f %16.10f\n", t[i], 51.4220674763*Ex[i], 51.4220674763*Ey[i], 51.4220674763*Ez[i]);
		//fprintf(fpt_out, "%lf %16.10f %16.10f %16.10f\n", t[i], Ex[i], Ey[i], Ez[i]);
		/* here E still in Hartree*/
		sumE += (pow(Ex[i+1], 2)+pow(Ey[i+1], 2)+pow(Ez[i+1], 2)) * delta[i+1]/2.0;

	}

	printf("Fluence %3.8f mJ/cm^2\n",sumE * 848.89650302);
	fclose(fpt_in);
	fclose(fpt_out);
	free(Ax);
	free(Ay);
	free(Az);
	free(Ex);
	free(Ey);
	free(Ez);

	end_time = clock();
	cpu_time_used = ((double) (end_time - start_time)) / CLOCKS_PER_SEC;
	printf("routine takes %lf s to run\n", cpu_time_used);
	return 0;
}
