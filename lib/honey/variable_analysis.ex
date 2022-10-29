defmodule Honey.Analyze do
  import Honey.Utils, only: [is_var: 1]

  def run(ast) do

    #Does a right to left traverse to check what variables have uses from a point on. Considers case/cond branches
    #as separate with unique acumulators.
    #uv == set of variables that still have uses
    {ast,uv} = backwards_traverse(ast, MapSet.new() , fn segment, uv -> {segment, uv} end, fn segment, uv ->
      if is_var(segment) do

        #Get info from segment
        {var, meta, context} = segment
        ver = Keyword.get(meta, :version)

        #Transform info to unique key
        keystring = to_string(var) <> "_" <> to_string(ver) <> "_" <> to_string(context)
        keyatom = String.to_atom(keystring)

        #Check if variable is in set
        if not MapSet.member?(uv, keyatom) do
          #If its not, this is the last use of that variable
          segment = {var, Keyword.put(meta, :last, true), context}
          uv = MapSet.put(uv, keyatom)
          {segment, uv}
        else
          #If it is, it was already used before this
          segment = {var, Keyword.put(meta, :last, false), context}
          {segment, uv}
        end

      else
        #If you are a method that can keep meta data
        if(match?({_form, _meta, _args}, segment)) do
          {form, meta, args} = segment
          #Keep the used variables from here on out
          segment = {form, Keyword.put(meta, :uv, uv), args}
          {segment, uv}
        else
          #Segment can't keep meta data so it's returned as is
          {segment, uv}
        end
      end
    end)

    #Does a left to right traverse to check variables in scope. After that checks which variables are dead.
    #A variable is consided dead if it is in scope and isn't used anymore.
    #sv == set of in scope variables and dv == set of dead variables.
    {ast, _sv} = cond_notup_forwards_traverse(ast, MapSet.new(), fn segment, sv -> {segment, sv} end, fn segment, sv ->
      if is_var(segment) do

        #Get info from segment
        {var, meta, context} = segment
        ver = Keyword.get(meta, :version)

        #Transform info to unique key
        keystring = to_string(var) <> "_" <> to_string(ver) <> "_" <> to_string(context)
        keyatom = String.to_atom(keystring)

        #Add the variable to it's own scope
        sv = MapSet.put(sv, keyatom)
        {segment, sv}

      else

        if(match?({_form, _meta, _args}, segment)) do
          #Get info from segment
          {form, meta, args} = segment
          #luv == local used variables
          luv = Keyword.get(meta, :uv)
          #Adds variables in your scope to you meta data.
          meta = Keyword.put(meta, :sv, sv)
          #Calculates dead variables with the intersection of the non-used variables and those in scope
          dv = MapSet.intersection(MapSet.difference(uv ,luv), sv)
          #Adds that to the segment
          segment = {form, Keyword.put(meta, :dv, dv), args}
          {segment, sv}
        else
          #Segment can't keep meta data so it's returned as is
          {segment, sv}
        end
      end
    end)

    ast

  end

  #Traverses from left to right. If inside a case or cond block the accumulator is unique per branch and not returned upwards.
  defp cond_notup_forwards_traverse(ast, acc, pre, post) when is_function(pre, 2) and is_function(post, 2) do
    {ast, acc} = pre.(ast, acc)
    do_cond_notup_traverse_l(ast, acc, pre, post, false)
  end

  #Do conditional traverse (as in case or cond as father creates unique accumulator for each child) not propagating accumulator upwards from left to right
  defp do_cond_notup_traverse_l({form, meta, args}, acc, pre, post, _casecondFather) when is_atom(form) and (form == :case or form == :cond) do
    {args, acc} = do_cond_notup_traverse_args_l(args, acc, pre, post, true)
    post.({form, meta, args}, acc)
  end

  defp do_cond_notup_traverse_l({form, meta, args}, acc, pre, post, _casecondFather) when is_atom(form) do
    {args, acc} = do_cond_notup_traverse_args_l(args, acc, pre, post, false)
    post.({form, meta, args}, acc)
  end

  defp do_cond_notup_traverse_l({form, meta, args}, acc, pre, post, _casecondFather) do
    {form, acc} = pre.(form, acc)
    {form, acc} = do_cond_notup_traverse_l(form, acc, pre, post, false)
    {args, acc} = do_cond_notup_traverse_args_l(args, acc, pre, post, false)
    post.({form, meta, args}, acc)
  end

  defp do_cond_notup_traverse_l({left, right}, acc, pre, post, casecondFather) do
    {left, acc} = pre.(left, acc)
    {left, acc} = do_cond_notup_traverse_l(left, acc, pre, post, casecondFather)
    {right, acc} = pre.(right, acc)
    {right, acc} = do_cond_notup_traverse_l(right, acc, pre, post, casecondFather)
    post.({left, right}, acc)
  end

  defp do_cond_notup_traverse_l(list, acc, pre, post, casecondFather) when is_list(list) do
    {list, acc} = do_cond_notup_traverse_args_l(list, acc, pre, post, casecondFather)
    post.(list, acc)
  end

  defp do_cond_notup_traverse_l(x, acc, _pre, post, _casecondFather) do
    post.(x, acc)
  end

  defp do_cond_notup_traverse_args_l(args, acc, _pre, _post, _casecondFather) when is_atom(args) do
    {args, acc}
  end

  defp do_cond_notup_traverse_args_l(args, acc, pre, post, casecondFather) when is_list(args) do
    if casecondFather do
      return = :lists.mapfoldr(
        fn x, return ->
          {x, _} = pre.(x, acc)
          back = do_cond_notup_traverse_l(x, acc, pre, post, casecondFather)

          return = MapSet.union(return, elem(back, 1))

          {elem(back, 0), return}
        end,
        acc,
        args
      )

      {elem(return, 0), acc}

    else
      :lists.mapfoldl(
        fn x, acc ->
          {x, acc} = pre.(x, acc)
          do_cond_notup_traverse_l(x, acc, pre, post, casecondFather)
        end,
        acc,
        args
      )
    end
  end


  #Does a right to left traverse. If in a case or cond block creates unique acumulators per block. All return the union upwards.
  defp backwards_traverse(ast, acc, pre, post) when is_function(pre, 2) and is_function(post, 2) do
    {ast, acc} = pre.(ast, acc)
    do_cond_traverse_r(ast, acc, pre, post, false)
  end

  #Do conditional traverse from right to left
  defp do_cond_traverse_r({form, meta, args}, acc, pre, post, _casecondFather) when is_atom(form) and (form == :case or form == :cond) do
    {args, acc} = do_cond_traverse_args_r(args, acc, pre, post, true, true)
    post.({form, meta, args}, acc)
  end

  defp do_cond_traverse_r({form, meta, args}, acc, pre, post, _casecondFather) when is_atom(form) do
    {args, acc} = do_cond_traverse_args_r(args, acc, pre, post, false, true)
    post.({form, meta, args}, acc)
  end

  defp do_cond_traverse_r({form, meta, args}, acc, pre, post, _casecondFather) do
    {form, acc} = pre.(form, acc)
    {args, acc} = do_cond_traverse_args_r(args, acc, pre, post, false, true)
    {form, acc} = do_cond_traverse_r(form, acc, pre, post, false)
    post.({form, meta, args}, acc)
  end

  defp do_cond_traverse_r({left, right}, acc, pre, post, casecondFather) do
    {right, acc} = pre.(right, acc)
    {right, acc} = do_cond_traverse_r(right, acc, pre, post, casecondFather)
    {left, acc} = pre.(left, acc)
    {left, acc} = do_cond_traverse_r(left, acc, pre, post, casecondFather) #possibly change false to casecondFather
    post.({left, right}, acc)
  end

  defp do_cond_traverse_r(list, acc, pre, post, casecondFather) when is_list(list) do
    {list, acc} = do_cond_traverse_args_r(list, acc, pre, post, casecondFather, not casecondFather)
    post.(list, acc)
  end

  defp do_cond_traverse_r(x, acc, _pre, post, _casecondFather) do
    post.(x, acc)
  end

  defp do_cond_traverse_args_r(args, acc, _pre, _post, _casecondFather, _sharedAccumulator) when is_atom(args) do
    {args, acc}
  end

  defp do_cond_traverse_args_r(args, acc, pre, post, casecondFather, sharedAccumulator) when is_list(args) do

    traverse = &do_cond_traverse_r/5

    if sharedAccumulator do
      :lists.mapfoldr(
        fn x, acc ->
          {x, acc} = pre.(x, acc)
          traverse.(x, acc, pre, post, casecondFather)
        end,
        acc,
        args
      )
    else
      :lists.mapfoldr(
        fn x, return ->
          {x, _} = pre.(x, acc)
          back = traverse.(x, acc, pre, post, casecondFather)

          return = MapSet.union(return, elem(back, 1))

          {elem(back, 0), return}
        end,
        acc,
        args
      )
    end

  end

end
