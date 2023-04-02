#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[]) {
  int pid = fork();
  if (pid < 0) {
    printf(1, "fork failed\n");
    exit();
  } else if (pid == 0) {
    // Child process
    printf(1, "Child process: pid=%d\n", getpid());

    // Test sys_exec_time()
    int exec_time0 = 10;
    if (exec_time(getpid(), exec_time0) < 0) {
      printf(1, "sys_exec_time failed\n");
      exit();
    }
    printf(1, "sys_exec_time succeeded: exec_time=%d\n", exec_time);

    // Test sys_deadline()
    int deadline0 = 100;
    if (deadline(getpid(), deadline0) < 0) {
      printf(1, "sys_deadline failed\n");
      exit();
    }
    printf(1, "sys_deadline succeeded: deadline=%d\n", deadline);

    // Test sys_rate()
    int rate0 = 2;
    if (rate(getpid(), rate0) < 0) {
      printf(1, "sys_rate failed\n");
      exit();
    }
    printf(1, "sys_rate succeeded: rate=%d\n", rate);

    exit();
  } else {
    // Parent process
    wait();
    printf(1, "Parent process: child exited\n");
  }

  exit();
}
