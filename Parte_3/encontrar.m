function [x,y] = encontrar(matriz, elemento)
  %La funcion encontrar toma una matriz y un elemento y retorna
  %el i y j en donde se encuentra dicho elemento.
  %-Entrada: Matriz de tamaño mxn, elemento entero a encontrar.
  %-Salida: el x y y en el que se encuentra dicho elemento
  %dentro de la matriz.
  [m,n] = size(matriz);
  i = 0; j = 0;
  for i = 1:m
    for j = 1:n
      if(abs(matriz(i, j)) == elemento)
        x = i;
        y = j;
      else
      endif
    endfor
  endfor
endfunction
