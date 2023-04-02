#include "types.h"
#include "stat.h"
#include "user.h"
#define NUMPROCS 8


int
main(int argc, char *argv[])
{
	if(argc< 2){
		printf(1,"Need type and input filename\n");
		exit();
	}
	char *filename;
	filename=argv[2];
	int type = atoi(argv[1]);
	//printf(1,"Type is %d and filename is %s\n",type, filename);

	int tot_sum = 0;	

	int size=1000;
	short arr[size];
	char c;
	int fd = open(filename, 0);
	for(int i=0; i<size; i++){
		read(fd, &c, 1);
		arr[i]=c-'0';
		read(fd, &c, 1);
	}	
  	close(fd);
  	// this is to supress warning
  	//printf(1,"first elem %d\n", arr[0]);
  
  	//----FILL THE CODE HERE for unicast sum
	int cid[NUMPROCS];
	int cnum;
	int coordinator=getpid();
	int ischild=0;

	for(int i=0; i<NUMPROCS; i++){
		cnum=i;
		cid[i]=fork();
		if(cid[i]!=0);//printf(1, "Init %d\n", cid[i]);
		else {
			ischild=1;
			break;
		}
	}
	//
	//ps();
	//float variance;
	if(ischild==1){
		//printf(1, "Child proc %d\n", getpid());
		int partial=0;
		for(int i=cnum*size/NUMPROCS; i<(cnum+1)*size/NUMPROCS; i=i+1)partial+=arr[i];
		//printf(1, "Child proc %d prtial sum is %d\n", getpid(), partial);
		send(getpid(), coordinator, &partial);
		
		//add the blocking and unblocking here


		// float* meanrec= malloc(sizeof(int)*2);
		
		// recv(meanrec);
		// float recmean=*meanrec;

		// float partial_var=0;
		// for(int i=cnum*size/NUMPROCS; i<(cnum+1)*size/NUMPROCS; i=i+1)partial_var+=(arr[i]-recmean)*( arr[i]-recmean);

		// send(getpid(), coordinator, &partial_var);

		exit();
	}
	else{
		//printf(1, "Coordinator proc %d", getpid());
		int sum=0;
		int rec_partial;
		for(int i=0;i<NUMPROCS; i++){
			recv(&rec_partial);
			sum+=rec_partial;
			//printf(1, "Received %dth partial sum %d, current sum = %d\n", i, rec_partial, sum);
			tot_sum=sum;
			//float mean=(1.0*tot_sum)/size;
			//printf(1, "Mean = %d\n", (int)mean);
			
			// float* meanmsg=&mean;

			// send_multi(coordinator, cid, meanmsg);
			
			// variance=0;
			// float* partial_variance_rec=malloc(sizeof(int)*2);
			// float rec_partial_variance;

			// for(int i=0; i<NUMPROCS; i++){
			// 	while(recv(partial_variance_rec)==-1);
			// 	rec_partial_variance=*partial_variance_rec;

			// 	variance+=rec_partial_variance;

			// }

			// variance/=size;

			for(int i = 0; i <NUMPROCS; i++)wait();

		}
	}

  	//------------------

  	if(type==0){ //unicast sum
		printf(1,"Sum of array for file %s is %d\n", filename,tot_sum);
	}
	// else{ //mulicast variance
	// 	printf(1,"Variance of array for file %s is %d\n", filename,(int)variance);
	// }
	exit();
	

}
