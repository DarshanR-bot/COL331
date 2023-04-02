
#include "types.h"
#include "stat.h"
#include "user.h"

#define MSGSIZE sizeof(int)

#define CHILDNUM 8

int main(void)
{
    printf(1, "IPC Test case\n");
    //int cid1=-1, cid2=-1, cid3=-1, cid4=-1;
    int cid[CHILDNUM]={-1, -1, -1, -1, -1, -1, -1, -1};
    for(int i=0; i<8; i++){
        cid[i]=fork();
        if(cid[i]==0)break;
    }
    
    if ( cid[0] == 0 || cid[1] == 0 || cid[2] == 0 || cid[3] == 0 || cid[4] == 0 || cid[5] == 0 ||cid[6] == 0 ||cid[7] == 0 ) {
        // This is child
        float* msg=malloc(2*sizeof(int));
        recv(msg);
        float fnew=*msg;
        printf(1, "CHILD: received message: %d\n", (int)fnew);
        exit();
    } else {
        // This is parent
        ps();
        //int a =1;
        //char* a = "Hello child!";
        float f=3.3;
        float* a= &f;
        //int recids[8]={cid1, cid2, cid3, cid4, -1, -1, -1, -1};
        send_multi(getpid(), cid, a);
        printf(1, "PARENT: sent message: %d", (int)f);
        free(&a);
        for(int i=0; i<8; i++)wait();
    }
    
    exit();
}
