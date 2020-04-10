getPiles = (f, g, n) -> (
  l := {0};
  for i in 0..#f-1 list (
    m = if i == 0 then
      {(0,0)}
    else
      flatten toList(pairs l / (k -> for j in reverse(k_1..n) list (k_0 - g_(i-1) + 1, j)));
    m = take(m, f_i);
    l = last\m;
    (drop(l, g_i), drop(first\m, g_i))
  )
)
