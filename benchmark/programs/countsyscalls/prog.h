#define NSYS 3
struct syscallNames { long id; char name[15]; };

struct syscallNames SYSCALLSNAMES[NSYS] = {
    {62, "enter_kill"}, 
    {83, "enter_mkdir"},
    {318, "enter_getrandom"}
};