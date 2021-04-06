function S_t = P_c0(matriz, c)
  matriz_copia = abs(matriz)
  matriz_copia = sortrows(matriz_copia)
  matriz_copia = sort(matriz_copia)
  valores_mayores = zeros(1,c);
  [m,n] = size(matriz);
  i = m;j = n;contador = 1;
  while i >= 1
    while j >= 1
      if contador <= c 
        valores_mayores(contador) = matriz_copia(i, j);
        contador = contador + 1;
      %else
        %break
      endif
      j = j - 1;
    endwhile
    j = n;
    i = i - 1;
  endwhile
  S_t = zeros(m,n);
  valores_mayores
  for i = 1: c
    [i_actual, j_actual] = encontrar(matriz, valores_mayores(i)); 
    S_t(i_actual, j_actual) = matriz(i_actual, j_actual);
  endfor
  
endfunction
