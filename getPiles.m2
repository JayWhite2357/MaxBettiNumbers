getPiles = (f, g, n) -> (
  l := {0};
  for i to #f-1 list (
    m = if i == 0 then
      {(0,0)}
    else
      flatten toList(pairs l / (k -> for j in reverse(k_1..n) list (k_0 - g_(i-1) + 1, j)));
    m = take(m, f_i);
    l = last\m;
    (drop(l, g_i), drop(first\m, g_i))
  )
)


getPilesAndBounds = (F, G, f, g, n, v) -> (
  Gp := accumulate(plus, 0, g);
  Fs = F - Gp;
  Gs = G - Gp;
  piles = getPiles(f, g, n);
  for i to #f-1 list (
    pile = piles_i;
    vectorPile = pile_0 / (k->v_k);
    cardMins = {0} | pile_1;
    (vectorPile, Gs_i, Fs_i, cardMins)
  )
)
