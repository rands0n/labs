good_fn = fn ->
  Process.sleep(60_000)
  {:ok, []}
end

error_fn = fn ->
  Process.sleep(2_000)
  :error
end

doomed_fn = fn ->
  Process.sleep(2_000)
  raise "Boom!"
end
