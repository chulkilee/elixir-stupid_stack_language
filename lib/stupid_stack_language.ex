defmodule StupidStackLanguage do
  def run(program) when is_binary(program), do: execute({to_charlist(program), []}, [])

  defp execute({[], _prev}, _stack), do: :ok

  defp execute({[h | t] = current, prev}, stack) do
    case handle_op(h, stack) do
      :exit ->
        :ok

      {:cont, new_stack} ->
        {t, [h | prev]}
        |> execute(new_stack)

      :jump_to_u ->
        {current, prev}
        |> jump_to_u()
        |> execute(stack)

      :jump_back_to_t ->
        {current, prev}
        |> jump_back_to_t()
        |> execute(stack)

      :skip_next ->
        {current, prev}
        |> skip_next()
        |> execute(stack)
    end
  end

  defp jump_to_u({[h | t], prev}), do: jump_to_u(t, [h | prev], 0)

  defp jump_to_u([?u | t], prev, 0), do: {t, [?u | prev]}
  defp jump_to_u([?u | t], prev, depth), do: jump_to_u(t, [?u | prev], depth - 1)
  defp jump_to_u([?t | t], prev, depth), do: jump_to_u(t, [?t | prev], depth + 1)
  defp jump_to_u([h | t], prev, depth), do: jump_to_u(t, [h | prev], depth)

  defp jump_back_to_t({current, [ph | pt]}), do: jump_back_to_t([ph | current], pt, 0)

  defp jump_back_to_t(current, [?t | t], 0), do: {[?t | current], t}
  defp jump_back_to_t(current, [?t | t], depth), do: jump_back_to_t([?t | current], t, depth - 1)
  defp jump_back_to_t(current, [?u | t], depth), do: jump_back_to_t([?u | current], t, depth + 1)
  defp jump_back_to_t(current, [h | t], depth), do: jump_back_to_t([h | current], t, depth)

  defp skip_next({[h | [nh | nt]], prev}), do: {nt, [nh | [h | prev]]}

  # Pushes 0 to the top of the stack
  defp handle_op(?a, stack), do: {:cont, [0 | stack]}

  # Pops the 1st item from the stack
  defp handle_op(?b, [_h | t]), do: {:cont, t}

  # Subtracts the 2nd item on the stack from the 1st item and pushes the result to the stack
  defp handle_op(?c, [h1 | [h2 | t]]), do: {:cont, [h1 - h2 | t]}

  # Decrements the 1st item of the stack by 1
  defp handle_op(?d, [h | t]), do: {:cont, [h - 1 | t]}

  # Pushes the 1st item mod the 2nd item onto the stack
  defp handle_op(?e, [h1 | [h2 | _t]] = stack), do: {:cont, [rem(h1, h2) | stack]}

  # Prints the 1st item on the stack as an ASCII character
  defp handle_op(?f, [h | _t] = stack) do
    IO.write(<<h>>)

    {:cont, stack}
  end

  # Adds the first 2 stack items together and pushes the result to the stack
  defp handle_op(?g, [h1 | [h2 | _t]] = stack), do: {:cont, [h1 + h2 | stack]}

  # Gets input from the user as a number and pushes to the stack
  defp handle_op(?h, stack) do
    with line when is_binary(line) <- IO.gets("enter number: "),
         {int_val, ""} <- line |> String.trim_trailing() |> Integer.parse() do
      {:cont, [int_val | stack]}
    else
      val -> raise "invalid: #{inspect(val)}"
    end
  end

  # Increments the 1st item of the stack by 1
  defp handle_op(?i, [h | t]), do: {:cont, [h + 1 | t]}

  # Gets input from the user as a character and pushes that characters ASCII code onto the stack
  defp handle_op(?j, stack) do
    <<val>> = IO.getn("press one char and then enter: ")

    {:cont, [val | stack]}
  end

  # Skips the next command if the 1st item on the stack is 0
  defp handle_op(?k, [0 | _]), do: :skip_next
  defp handle_op(?k, stack), do: {:cont, stack}

  # Swaps the 1st and 2nd items on the stack
  defp handle_op(?l, [h1 | [h2 | t]]), do: {:cont, [h2 | [h1 | t]]}

  # Multiplies the first two stack items together and pushes the result onto the stack
  defp handle_op(?m, [h1 | [h2 | _t]] = stack), do: {:cont, [h1 * h2 | stack]}

  # If the 1st item on the stack is equal to the 2nd item, push a 1 to the stack, else push a 0
  defp handle_op(?n, [h | [h | _t]] = stack), do: {:cont, [1 | stack]}
  defp handle_op(?n, stack), do: {:cont, [0 | stack]}

  # Pops the (first item on the stack)th item on the stack
  defp handle_op(?o, [h | _] = stack), do: {:cont, List.delete_at(stack, h)}

  # Divides the 1st item on the stack by the 2nd item and pushes the result onto the stack
  defp handle_op(?p, [h1 | [h2 | _t]] = stack), do: {:cont, [div(h1, h2) | stack]}

  # Duplicates the 1st item on the stack
  defp handle_op(?q, [h | _t] = stack), do: {:cont, [h | stack]}

  # Pushes the total length of the stack onto the stack
  defp handle_op(?r, stack), do: {:cont, [length(stack) | stack]}

  # Swaps the 1st and (first item on the stack)th items on the stack
  defp handle_op(?s, [h | t] = stack),
    do: {:cont, [Enum.fetch!(stack, h) | List.replace_at(t, h - 1, h)]}

  # If the 1st item on the stack is 0, jumps to the corresponding 'u' in the program, otherwise does nothing
  defp handle_op(?t, [0 | _]), do: :jump_to_u
  defp handle_op(?t, stack), do: {:cont, stack}

  # If the 1st item on the stack is not 0, jumps back to the corresponding 't' in the program, otherwise does nothing
  defp handle_op(?u, [h | _]) when h != 0, do: :jump_back_to_t
  defp handle_op(?u, stack), do: {:cont, stack}

  # Increments the top item on the stack by 5
  defp handle_op(?v, [h | t]), do: {:cont, [h + 5 | t]}

  # Decrements the top item on the stack by 5
  defp handle_op(?w, [h | t]), do: {:cont, [h - 5 | t]}

  # Prints the 1st item on the stack
  defp handle_op(?x, [h | _t] = stack) do
    IO.write(to_string(h))

    {:cont, stack}
  end

  # Deletes the entire stack
  defp handle_op(?y, _stack), do: {:cont, []}

  # Exits the script
  defp handle_op(?z, _stack), do: :exit
end
