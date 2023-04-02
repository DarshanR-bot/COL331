// // #include "types.h"
// // #include "stat.h"
// // #include "user.h"

// // int main(int argc, char *argv[]) {
// //     int pid = fork();

// //     if (pid == 0) {
// //         printf(1, "Child process\n");
// //         sleep(100);
// //         exit();
// //     } else if (pid > 0) {
// //         printf(1, "Parent process\n");

// //         int policy = 0; // EDF policy
// //         int temp = sched_policy(pid, policy);
// //         printf(1, "%d\n", temp);
// //         if (temp == 0) {
// //             printf(1, "Scheduling policy set successfully\n");
// //         } else {
// //             printf(1, "Failed to set scheduling policy\n");
// //         }

// //         wait();

// //         exit();
// //     } else {
// //         printf(1, "Failed to create child process\n");
// //         exit();
// //     }
// // }

// #include "types.h"
// #include "stat.h"
// #include "user.h"

// int main(int argc, char *argv[]) {
//   int pid = fork();
//   if (pid < 0) {
//     printf(1, "fork failed\n");
//     exit();
//   } else if (pid == 0) {
//     // Child process
//     printf(1, "Child process: pid=%d\n", getpid());

//     // Test sys_exec_time()
//     int exec_time0 = 10;
//     if (exec_time(getpid(), exec_time0) < 0) {
//       printf(1, "sys_exec_time failed\n");
//       exit();
//     }
//     printf(1, "sys_exec_time succeeded: exec_time=%d\n", exec_time0);

//     // Test sys_deadline()
//     int deadline0 = 100;
//     if (deadline(getpid(), deadline0) < 0) {
//       printf(1, "sys_deadline failed\n");
//       exit();
//     }
//     printf(1, "sys_deadline succeeded: deadline=%d\n", deadline0);

//     // Test sys_rate()
//     int rate0 = 2;
//     if (rate(getpid(), rate0) < 0) {
//       printf(1, "sys_rate failed\n");
//       exit();
//     }
//     printf(1, "sys_rate succeeded: rate=%d\n", rate0);

//     exit();
//   } else {
//     // Parent process
//     wait();
//     printf(1, "Parent process: child exited\n");
//   }

//   exit();
// }

#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[])
{   
    int num_procs = 3;
    int deadlines[3] = {7, 24, 15};
    int exectime[3] = {5, 6, 4};

    int parent_pid = getpid();

    // Set the scheduling policy to EDF
    deadline(parent_pid, 11);
    exec_time(parent_pid, 4);
    sched_policy(parent_pid, 0);

    for(int i = 0; i < num_procs; i++)
    {
        int cid = fork();
        if (cid != 0)
        {
            // Set the scheduling policy to EDF
            deadline(cid, deadlines[i]);
            exec_time(cid, exectime[i]);
            sched_policy(cid, 0);
        }
        else
        {
            /*The XV6 kills the process if th exec time is completed*/
            while(1) {
                
            }
        }
    }

    while(1) {

    }
}