#ifndef PROG
#define PROG

#define MAPSTRINGSSIZE 5
#define SIZETEXT 10
#define MAXC 26 // Maximum number of characters in input alphabet
#define MAXSTATES MAPSTRINGSSIZE*SIZETEXT+1
#define TRUE 1
#define FALSE 0

struct data {
    char text[SIZETEXT];
    int number;
};

struct aho_c_automata {
    int out[MAXSTATES];
    int failure[MAXSTATES];
    int go[MAXSTATES][MAXC];
    int states;
};

struct state {
	__u32 payload_index;
    __u32 ac_state;
    __u32 matches;
};

struct goto_result {
    unsigned int next_state;
    unsigned int match;
};

#endif