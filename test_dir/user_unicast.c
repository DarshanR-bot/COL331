// #include "types.h"
// #include "stat.h"
// #include "user.h"

// #define MSGSIZE sizeof(int)

// int main(void)
// {
//     printf(1, "IPC Test case\n");
    
//     int cid = fork();
//     if (cid == 0) {
//         // This is child
//         char* msg;
//         recv(&msg);
//         printf(1, "CHILD: received message: %s\n", (char*)msg);
//         exit();
//     } else {
//         // This is parent
//         ps();
//         //int a =1;
//         char* a = "Hello child!";
//         send(getpid(), cid, &a);
//         printf(1, "PARENT: sent message: %s", (char*)a);
//         free(&a);
//         wait();
//     }
    
//     exit();
// }

#include "types.h"
#include "stat.h"
#include "user.h"

#define MSGSIZE 8

int main(void)
{
	toggle(); 
	printf(1,"%s\n","IPC Test case");
	// char *msg = (char *)malloc(20);
	// int myid;
	// int from;	
	
int cid = fork();
	if(cid==0){
		// This is child
		char *msg = (char *)malloc(MSGSIZE);
		recv(msg);
		//int stat=-1;
		//while(stat==-1){
		//	stat = recv(msg);
		//}
		printf(1,"2 CHILD: msg recv is: %s \n", msg );
		exit();
	}else{
		// This is parent
		char *msg_child = (char *)malloc(MSGSIZE);
		msg_child = "P";
		printf(1,"1 PARENT: msg sent is: %s \n", msg_child );
		send(getpid(),cid,msg_child);	
		
		
		free(msg_child);
	}
	wait();
	
	exit();
}

