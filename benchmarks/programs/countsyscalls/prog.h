#define NSYS 3
struct syscallNames { long id; char name[15]; };

/**
 * @brief If you want, you can list all the syscalls
 * using the following command line:
 * `ausyscall --dump`
 * You can add a new syscall in this struct if you want
 */
struct syscallNames SYSCALLSNAMES[NSYS] = {
    {62, "enter_kill"}, 
    {83, "enter_mkdir"},
    {318, "enter_getrandom"}
};