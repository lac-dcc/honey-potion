#ifndef RUNTIME_BPF_STRUCTS_HONEY
#define RUNTIME_BPF_STRUCTS_HONEY
#include <linux/bpf.h>
#include <bpf/bpf_helpers.h>
#include "runtime_generic.bpf.h"

#ifndef __inline
#define __inline \
  inline __attribute__((always_inline))
#endif
// Generated at /run/media/kaelsa/1tera/KaelMedia/KPrograms/GitHub/honey-potion/lib/honey/boilerplates.ex:204
// String pool
struct
{
  __uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
  __uint(max_entries, 1);
  __uint(key_size, sizeof(int));
  __uint(value_size, sizeof(char[STRING_POOL_SIZE]));
} string_pool_map SEC(".maps");

struct
{
  __uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
  __uint(max_entries, 1);
  __uint(key_size, sizeof(int));
  __uint(value_size, sizeof(int));
} string_pool_index_map SEC(".maps");

// Tuple
struct
{
  __uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
  __uint(max_entries, 1);
  __uint(key_size, sizeof(int));
  __uint(value_size, sizeof(unsigned[TUPLE_POOL_SIZE]));
} tuple_pool_map SEC(".maps");

struct
{
  __uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
  __uint(max_entries, 1);
  __uint(key_size, sizeof(int));
  __uint(value_size, sizeof(unsigned));
} tuple_pool_index_map SEC(".maps");

// Heap
struct
{
  __uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
  __uint(max_entries, 1);
  __uint(key_size, sizeof(int));
  __uint(value_size, sizeof(Generic[HEAP_SIZE]));
} heap_map SEC(".maps");

struct
{
  __uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
  __uint(max_entries, 1);
  __uint(key_size, sizeof(int));
  __uint(value_size, sizeof(int));
} heap_index_map SEC(".maps");


#endif


