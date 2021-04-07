
function S_t = P_c02(matriz, c)
  matriz_copia = abs(matriz);
  [m,n] = size(matriz);
  i = m;j = n; contador = 1;
  S_t = zeros(m,n);
  for i = 1: c
    [max_valor x] = max(matriz_copia);
    [max_valor y] = max(max_valor);
    S_t(x, y) = matriz(x, y);
    matriz_copia(x, y) = 0;
  endfor  
endfunction
