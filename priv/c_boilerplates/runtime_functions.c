static int to_bool(Generic *var)
{
  if (var->type == ATOM)
  {
    int zero = 0;
    unsigned start = var->value.string.start;
    unsigned end = var->value.string.end;
    char(*string_pool)[STRING_POOL_SIZE] = bpf_map_lookup_elem(&string_pool_map, &zero);
    if (!string_pool)
    {
      bpf_printk("(UnexpectedBehavior) something wrong happened inside the Elixir runtime for eBPF. (can't access string pool, to_bool function).");
      return 0;
    }

    /*
      nil = {start: 0, end: 2}
      false = {start: 3, end: 7}
      true = {start: 8, end: 11}
    */

    int str_size = end - start + 1;
    if (str_size == 3)
    {
      if (start + 3 >= STRING_POOL_SIZE)
      {
        return 0;
      }

      if ((*string_pool)[start] == 'n' &&
          (*string_pool)[start + 1] == 'i' &&
          (*string_pool)[start + 2] == 'l')
      {
        return 0;
      }
    }

    else if (str_size == 5)
    {
      if (start + 5 >= STRING_POOL_SIZE)
      {
        return 0;
      }

      if ((*string_pool)[start] == 'f' &&
          (*string_pool)[start + 1] == 'a' &&
          (*string_pool)[start + 2] == 'l' &&
          (*string_pool)[start + 3] == 's' &&
          (*string_pool)[start + 4] == 'e')
      {
        return 0;
      }
    }
  }

  return 1;
}

static int values_are_equal(Generic *var1, Generic *var2)
{
  if (var1->type == INTEGER)
  {
    if (var2->type == INTEGER)
    {
      if (var1->value.integer == var2->value.integer)
      {
        return 1;
      }
      else
      {
        return 0;
      }
    }
  }

  return 0;
}

// Unary operations
static void negate(Generic *var, Generic *result)
{
  // TODO
}

// Binary operations
static void Subtract(OpResult *result, Generic *var1, Generic *var2)
{
  result->exception = 0;

  if (var1->type == DOUBLE || var2->type == DOUBLE)
  {
    *result = (OpResult){.exception = 1, .exception_msg = "(ArithmeticError) bad argument in arithmetic expression (subtraction with floats)."};
    return;
  }

  if (var1->type == INTEGER)
  {
    if (var2->type == INTEGER)
    {
      // Overflow:
      if ((var1->value.integer < 0) && (var2->value.integer > INT_MAX + var1->value.integer))
      {
        *result = (OpResult){.exception = 1, .exception_msg = "(ArithmeticError) bad argument in arithmetic expression (Subtraction of two values is greater than " QUOTE(INT_MAX) ")."};
        return;
      }
      // Underflow:
      if ((var1->value.integer > 0) && (var2->value.integer < INT_MIN + var1->value.integer))
      {
        *result = (OpResult){.exception = 1, .exception_msg = "(ArithmeticError) bad argument in arithmetic expression (Subtraction of two values is smaller than " QUOTE(INT_MIN) ")."};
        return;
      }

      result->result_var.type = INTEGER;
      result->result_var.value.integer = var1->value.integer + var2->value.integer;
      return;
    }
  }

  *result = (OpResult){.exception = 1, .exception_msg = "(UnexpectedBehavior) something wrong happened inside the Elixir runtime for eBPF. (function Sum)."};
}

static void Sum(OpResult *result, Generic *var1, Generic *var2)
{
  result->exception = 0;

  if (var1->type == DOUBLE || var2->type == DOUBLE)
  {
    *result = (OpResult){.exception = 1, .exception_msg = "(ArithmeticError) bad argument in arithmetic expression (sum with floats)."};
    return;
  }

  if (var1->type == INTEGER)
  {
    if (var2->type == INTEGER)
    {
      // Overflow:
      if ((var1->value.integer > 0) && (var2->value.integer > INT_MAX - var1->value.integer))
      {
        *result = (OpResult){.exception = 1, .exception_msg = "(ArithmeticError) bad argument in arithmetic expression (Sum of two values is greater than " QUOTE(INT_MAX) ")."};
        return;
      }
      // Underflow:
      if ((var1->value.integer < 0) && (var2->value.integer < INT_MIN - var1->value.integer))
      {
        *result = (OpResult){.exception = 1, .exception_msg = "(ArithmeticError) bad argument in arithmetic expression (Sum of two values is smaller than " QUOTE(INT_MIN) ")."};
        return;
      }

      result->result_var.type = INTEGER;
      result->result_var.value.integer = var1->value.integer + var2->value.integer;
      return;
    }
  }

  *result = (OpResult){.exception = 1, .exception_msg = "(UnexpectedBehavior) something wrong happened inside the Elixir runtime for eBPF. (function Sum)."};
}

static void Divide(OpResult *result, Generic *var1, Generic *var2)
{
  result->exception = 0;
  if (var1->type == DOUBLE || var2->type == DOUBLE)
  {
    *result = (OpResult){.exception = 1, .exception_msg = "(ArithmeticError) bad argument in arithmetic expression (division with float)."};
    return;
  }

  if (var1->type == INTEGER)
  {
    if (var2->type == INTEGER)
    {
      if (var2->value.integer == 0)
      {
        *result = (OpResult){.exception = 1, .exception_msg = "(ArithmeticError) bad argument in arithmetic expression (division by zero)."};
        return;
      }

      // Overflow
      if (var1->value.integer == INT_MIN && var2->value.integer == -1)
      {
        *result = (OpResult){.exception = 1, .exception_msg = "(ArithmeticError) bad argument in arithmetic expression (division of " QUOTE(INT_MIN) " by -1 exceeded the limit of " QUOTE(INT_MAX) ")"};
        return;
      }

      unsigned u_var1 = var1->value.integer < 0 ? var1->value.integer * -1 : var1->value.integer;
      unsigned u_var2 = var2->value.integer < 0 ? var2->value.integer * -1 : var2->value.integer;
      if ((var1->value.integer <= 0 && var2->value.integer < 0) || (var1->value.integer >= 0 && var2->value.integer > 0))
      {
        result->result_var.type = INTEGER;
        result->result_var.value.integer = u_var1 / u_var2;
        return;
      }
      else
      {
        result->result_var.type = INTEGER;
        result->result_var.value.integer = (u_var1 / u_var2) * -1;
        return;
      }
    }
  }

  *result = (OpResult){.exception = 1, .exception_msg = "(UnexpectedBehavior) something wrong happened inside the Elixir runtime for eBPF. (function Divide)."};
}

static void Multiply(OpResult *result, Generic *var1, Generic *var2)
{
  result->exception = 0;
  if (var1->type == DOUBLE || var2->type == DOUBLE)
  {
    *result = (OpResult){.exception = 1, .exception_msg = "(ArithmeticError) bad argument in arithmetic expression (multiplication with float)."};
    return;
  }

  if (var1->type == INTEGER)
  {
    if (var2->type == INTEGER)
    {
      if (var1->value.integer == 0 || var2->value.integer == 0)
      {
        result->result_var.type = INTEGER;
        result->result_var.value.integer = 0;
        return;
      }

      if ((var1->value.integer == INT_MIN && var2->value.integer != 1) || (var2->value.integer == INT_MIN && var1->value.integer != 1))
      {
        *result = (OpResult){.exception = 1, .exception_msg = "(ArithmeticError) bad argument in arithmetic expression (multiplication of two numbers exceeded integer boundaries.)"};
        return;
      }

      unsigned u_var1 = var1->value.integer < 0 ? var1->value.integer * -1 : var1->value.integer;
      unsigned u_var2 = var2->value.integer < 0 ? var2->value.integer * -1 : var2->value.integer;
      // Overflow
      if ((var1->value.integer > 0 && var2->value.integer > 0) || (var1->value.integer < 0 && var2->value.integer < 0))
      {
        if (u_var1 > INT_MAX / u_var2)
        {
          *result = (OpResult){.exception = 1, .exception_msg = "(ArithmeticError) bad argument in arithmetic expression (multiplication of two values exceeded " QUOTE(INT_MAX) ")."};
          return;
        }
      }
      else
      {
        // Underflow
        unsigned int_min_positive = INT_MIN * -1;
        if (u_var1 > int_min_positive / u_var2)
        {
          *result = (OpResult){.exception = 1, .exception_msg = "(ArithmeticError) bad argument in arithmetic expression (multiplication of two values receded " QUOTE(INT_MIN) ")."};
          return;
        }
      }

      result->result_var.type = INTEGER;
      result->result_var.value.integer = var1->value.integer * var2->value.integer;
      return;
    }
  }

  *result = (OpResult){.exception = 1, .exception_msg = "(UnexpectedBehavior) something wrong happened inside the Elixir runtime for eBPF. (function Multiply)."};
}

static void Copy(OpResult *result, Generic *to, Generic *from)
{
  if (from->type == STRING)
  {
    to->type = STRING;

    int zero = 0;
    int *string_pool_index = bpf_map_lookup_elem(&string_pool_index_map, &zero);
    if (!string_pool_index)
    {
      *result = (OpResult){.exception = 1, .exception_msg = "(UnexpectedBehavior) something wrong happened inside the Elixir runtime for eBPF. (can't access string pool index, function Copy)."};
      return;
    }

    int str_len = from->value.string.end - from->value.string.start + 1;
    to->value.string.start = *string_pool_index;
    to->value.string.end = to->value.string.start + str_len - 1;

    if (to->value.string.end > STRING_POOL_SIZE - 1)
    {
      *result = (OpResult){.exception = 1, .exception_msg = "(StringPoolSizeError) The program reached the maximum size of " QUOTE(STRING_POOL_SIZE) " characters stored in all bitstrings."};
    }

    char(*string_pool)[STRING_POOL_SIZE] = bpf_map_lookup_elem(&string_pool_map, &zero);
    if (!string_pool)
    {
      *result = (OpResult){.exception = 1, .exception_msg = "(UnexpectedBehavior) something wrong happened inside the Elixir runtime for eBPF. (can't access string pool, function Copy)."};
      return;
    }

    __builtin_memcpy(*string_pool[to->value.string.start], *string_pool[from->value.string.start], str_len);
  }
}

static int pattern_match(Generic *var1, Generic *var2)
{
  // TODO
  return 0;
}

static void Equals(OpResult *result, Generic *var1, Generic *var2) {
  result->exception = 0;

  if(var1->type != var2->type) {
    result->result_var = ATOM_FALSE;
    return;
  }

  if(var1->type == INTEGER) {
    if(var1->value.integer == var2->value.integer) {
      result->result_var = ATOM_TRUE;
    } else {
      result->result_var = ATOM_FALSE;
    }

    return;
  }

  *result = (OpResult){
      .exception = 1,
      .exception_msg =
          "(AplhaVersion) Currently, we can only compare integers with the '==' operator."};
  return;  
}