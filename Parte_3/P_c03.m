function S_t = P_c03(matriz, c_0)
  %Creando una matriz del mismo tamanno que 'matriz'.
  P = zeros(size(matriz));
  %Haciendo un split de la matriz a un arreglo unidimensional.
  x = matriz(:);
  %Encontrando el indice de los valores mayores a traves de ordenar la matriz:
  [~, index] = sort(abs(x), 'descend');
  P(index(1:c_0))= matriz(index(1:c_0));
  S_t = P;
endfunction
