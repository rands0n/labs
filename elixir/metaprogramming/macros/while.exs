defmodule Loop do
  defmacro while(expr, do: block) do
    quote do
      try do
        for _ <- Stream.cycle([:ok]) do
          if unquote(expr) do
            unquote(block)
          else
            Loop.break()
          end
        end
      catch
        :break ->
          :ok
      end
    end
  end

  def break, do: throw(:break)
end

# import Loop

# run_loop = fn ->
#   pid = spawn(fn -> :timer.sleep(4000) end)

#   while Process.alive?(pid) do
#     IO.puts("#{inspect(:erlang.time())} Stayin'g alive!")
#     :timer.sleep(1000)
#   end
# end

# import Loop

# pid = spawn(fn ->
#   while true do
#     receive do
#       :stop ->
#         IO.puts("Stopping...")
#       message ->
#         IO.puts("Got #{inspect(message)}")
#         break
#     end
#   end
# end)

# send(pid, :hello)
# send(pid, :ping)
# send(pid, :stop)
