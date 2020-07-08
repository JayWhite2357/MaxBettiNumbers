M2
restart
D = 6
--F = {1, 5, 15, 23, 31, 36, 41}
n = 3
R = QQ[x_0..x_n, MonomialOrder=>Lex];


g = {1,4,6,8,8,5,5}
f = {1,4,10,10,9,6,5}
f = append(for d to D-1 list length flatten entries basis(d,R),5)
G = replace(-1,41,accumulate_(plus,0) g)
F = replace(-1,41,accumulate_(plus,0) f)

mR = for d to D list max@@indices\reverse flatten entries basis(d, R);
V = for d to D list 
    for l from g#d to f#d list
      (v->append(v,sum v))\\for q to n list
        sum for k from g#d to l-1 list
          (binomial(n+1,q+1)-binomial(mR#d#k+1,q+1));
          
load "SimplifiedAll.m2"      
load "SimplifiedSome.m2"     
load "SimplifiedNone.m2"    
benchmark "SimplifiedAll(G, F, g, f, V)"
benchmark "SimplifiedSome(G, F, g, f, V)"
benchmark "SimplifiedNone(G, F, g, f, V)"
