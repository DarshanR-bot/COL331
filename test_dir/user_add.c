#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[])
{
  int a = 2, b = 3;
  int result = add(a, b);
  printf(1, "%d + %d = %d\n", a, b, result);

  exit();
}
