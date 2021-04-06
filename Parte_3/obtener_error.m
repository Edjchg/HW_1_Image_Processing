function error = obtener_error(A, L_t, S_t)
  %La funcion obtener_error toma, 3 matrices y calcula
  %con ellas el error entre ellas, mediante la norma de 
  %Frobenius.
  %Entradas: matrices de tamanno mxn A, L_t, S_t del algoritmo godec.
  %Salida: el error obtenido.
  error = (norm(A - L_t - S_t, 'fro')**2)/(norm(A, 'fro')**2);
endfunction
