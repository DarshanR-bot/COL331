#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "syscall_trace.h"
#include "spinlock.h"


#define INT_MAX 1e7
#define EDF 0
#define RM 1 
#define buffercount 1000
#define message_size 8
struct spinlock lock;
typedef struct{
  struct spinlock lock;
  char buffers[buffercount][8];
  int srcpid[buffercount];
  int destpid[buffercount];
  int iswaiting[NPROC];
} buffer_share;

buffer_share shared = {
  .buffers = { "        " },
  .srcpid = { 0 },
  .destpid = { 0 },
  .iswaiting = { 0 }
};

extern struct {
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;


int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

int
sys_print_count(void)
{
  for(int i = 0; i < numsyscalls; i++){
    if(countsyscalls[indexing[i]] > 0 && indexing[i]+1!=22 && indexing[i]+1!=23)
      cprintf("%s %d\n", namesyscalls[indexing[i]], countsyscalls[indexing[i]]);
  }
  return 0;
}

int
sys_toggle(void)
{
  if(trace == TRACE_ON)trace = TRACE_OFF;
  else{
    trace = TRACE_ON;
    for(int i=0; i < numsyscalls; i++)countsyscalls[i] = 0; 
  }
  return 0;
}

int
sys_add(int a, int b)
{
  if(argint(0, &a)!=0 || argint(1, &b) !=0){
    return -1;
  }
  return a+b;
}

void process_status(void);
int
sys_ps(void)
{
  process_status();
  return 0;
}


int
sys_send(int sender_pid, int rec_pid, void *msg)
{
  char* c;
  if(argint(0, &sender_pid) < 0)return -1;

  if(argint(1, &rec_pid) < 0)
    return -1;

  if(argptr(2, &c, message_size) < 0)
    return -1;

  acquire(&shared.lock);
  acquire(&lock);

  for(int i = 0; i < buffercount; i++){
    if(shared.destpid[i] < 1){       
     
      shared.srcpid[i] = sender_pid;
      shared.destpid[i] = rec_pid;
      memmove(shared.buffers[i], c, message_size);
      if(shared.iswaiting[rec_pid] == 1){

        shared.iswaiting[rec_pid] = 0;
        // Wake up the reciever
        wakeup((void*)rec_pid);
      }
      release(&lock);
      release(&shared.lock);
      return 0;
    }
  }
  release(&shared.lock);
  release(&lock);
  return -1;
}

int
sys_recv(void *msg)
{ 
  int id = myproc()->pid;
  int i = 0;
  char* c;
  if(argptr(0, &c, message_size)!=0)return -1;
  while(1){
    acquire(&shared.lock);
    acquire(&lock);
    for(i =0; i<buffercount; i=i+1){
      if(shared.destpid[i] == id){
        memmove(c, shared.buffers[i], message_size);
        shared.destpid[i] = -1; //this means that
        release(&lock);
        release(&shared.lock);
        return 0;//message was found so return
      }
    }
    release(&lock);
    // Wait and sleep if msg not found yet
    shared.iswaiting[id] = 1;
    sleep((void*)id, &shared.lock);
    release(&shared.lock);
  }
  return 0;
}



int
sys_send_multi(int sender_pid, int rec_pids[], void *msg) {
  char* c;
  int* recv_pids;
  if(argint(0, &sender_pid)!=0){
    cprintf("sender_pid error\n");
  }
  if(argptr(1, (char**)&recv_pids, 8)!=0){
    for(int i=0;i<8; i++){
      cprintf("reciever_pid error\n");
    }
  }
  if(argptr(2, &c, message_size)!=0){
    cprintf("message error\n");
  }

  acquire(&shared.lock);
  acquire(&lock);
  //cprintf("locks acquired for sending...\n");
  for (int j = 0; j < 8; j++) {
    if(recv_pids[j]==-1)continue;
    for(int i = 0; i < buffercount; i++){
      if(shared.destpid[i] <= 0){
        memmove(shared.buffers[i], c, message_size);
        shared.srcpid[i] = sender_pid;
        shared.destpid[i] = recv_pids[j];
        if(shared.iswaiting[recv_pids[j]] == 1){
          //cprintf("recvid %d was waiting\n", recv_pids[j]);
          shared.iswaiting[recv_pids[j]] = 0;
          // Wake up the reciever
          wakeup((void*)recv_pids[j]);
          //cprintf("recvid %d was woken up\n", recv_pids[j]);
        }
        break;
      }
    }
    //cprintf("messsage sent to rec %d  \n", j);
  }
  release(&lock);
  release(&shared.lock);
  return 0;
}
/*
int
is_schedulable()
{
  return 1;
  int i, j, rt_cnt, min_period;
  uint bmask;

  for (i = 0; i < NPROC; i++) {
    if (ptable[i].state == UNUSED)
      continue;

    if (ptable[i].policy == 0) { // EDF policy
      rt_cnt = 0;
      min_period = INT_MAX;
      bmask = 0;

      for (j = 0; j < NPROC; j++) {
        if (ptable[j].state == UNUSED)
          continue;

        if (ptable[j].policy == 0) { // EDF policy
          rt_cnt++;
          bmask |= 1 << j;
          if (ptable[j].period < min_period)
            min_period = ptable[j].period;
        }
      }

      if (rt_cnt == 0)
        continue;

      if (!edf_test(bmask, min_period))
        return 0;

    } else if (ptable[i].policy == 1) { // RM policy
      rt_cnt = 0;
      min_period = INT_MAX;
      bmask = 0;

      for (j = 0; j < NPROC; j++) {
        if (ptable[j].state == UNUSED)
          continue;

        if (ptable[j].policy == 1) { // RM policy
          rt_cnt++;
          bmask |= 1 << j;
          if (ptable[j].period < min_period)
            min_period = ptable[j].period;
        }
      }

      if (rt_cnt == 0)
        continue;

      if (!rm_test(bmask, min_period))
        return 0;
    }
  }

  return 1;
  
}
*/


int is_schedulable() {
    if(myproc()->policy==1)return 1;
    struct proc *p;
    int num_procs = 0;
    int deadlines[NPROC];
    int exec_times[NPROC];

    // Collect the deadlines and execution times of all the runnable and running processes in ptable
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
        if(p->state == RUNNABLE || p->state == RUNNING) {
            deadlines[num_procs] = p->deadline+p->start_time-ticks;
            exec_times[num_procs] = p->exec_time-p->elapsed_time;
            num_procs++;
        }
    }

    // Sort the deadlines and execution times arrays in increasing order of deadlines
    for(int i = 0; i < num_procs; i++) {
        for(int j = i + 1; j < num_procs; j++) {
            if(deadlines[i] > deadlines[j]) {
                int temp = deadlines[i];
                deadlines[i] = deadlines[j];
                deadlines[j] = temp;

                temp = exec_times[i];
                exec_times[i] = exec_times[j];
                exec_times[j] = temp;
            }
        }
    }

    // Check if any process misses its deadline
    int completion_time = 0;
    for(int i = 0; i < num_procs; i++) {
        completion_time += exec_times[i];
        if(completion_time > deadlines[i]) {
            // Deadline is missed, so the set is not schedulable
            return 0;
        }
    }
    cprintf("Augmented task set is schedulable ^_^ !\n");
    // All processes meet their deadlines, so the set is schedulable
    return 1;
}


int
sys_sched_policy(int pid, int policy)
{
  if (argint(0, &pid) < 0 || argint(1, &policy) < 0) {
    return -1;
  }

  // Check that pid is valid
  if (pid < 0 || pid >= NPROC)
    return -1;

  // Check that policy is valid
  if (policy != 0 && policy != 1)
    return -1;

  // Acquire the process table lock
  acquire(&ptable.lock);

  // Find the process with the given pid
  struct proc *p;
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
    if (p->pid == pid)
      break;
  }

  // If the process was found, set its scheduling policy
  if (p != &ptable.proc[NPROC]) {
    if (policy == EDF) {
      p->policy = EDF;
    } else if (policy == RM) {
      p->policy = RM;
    }
    p->start_time=ticks;
    // check if the augmented set of processes is schedulable
    if (!is_schedulable()) {
      p->policy = 0; // revert to default scheduling policy
      release(&ptable.lock);
      return -22;
    }
    release(&ptable.lock);
    return 0;
  }

  // If the process was not found, release the lock and return an error
  release(&ptable.lock);
  return -1;
}

int exec_time_helper(int pid, int exec_time);
int
sys_exec_time(void)
{
  int pid, exec_time;
  
  // Get the process id and execution time from the stack
  if (argint(0, &pid) < 0 || argint(1, &exec_time) < 0)
    return -1;

  return exec_time_helper(pid, exec_time);
}

int deadline_helper(int, int);
int
sys_deadline(void)
{
  int pid, deadline;
  // Read the arguments from the stack
  if (argint(0, &pid) < 0 || argint(1, &deadline) < 0)
    return -1;
  return deadline_helper(pid, deadline);
}

int rate_helper(int, int);
int
sys_rate(int pid, int rate)
{

  if (argint(0, &pid) < 0 || argint(1, &rate) < 0)
    return -1;

  return rate_helper(pid, rate);
}
