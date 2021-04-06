function [L, S] = godec_fast(A, k, c_0, epsilon)
  t = 0;
  L_t = A;
  [m,n] = size(A);
  S_t = zeros(m,n);
  E_t = 0;
  contador = 0;
  while (1)
    t = t + 1;
    %[U, E, V] = svd(A - S_t);
    %L_t = U(:,1:k)*E(1:k,1:k)*V(:,1:k)'; 
    L_t = rango_reducido_bilateral(A-S_t, k, 3);
    S_t = P_c02(A - L_t, c_0);
    if abs(obtener_error(A, L_t, S_t) - E_t) < epsilon
    %if contador == 0
      break
    endif
    E_t = obtener_error(A, L_t, S_t);
    %contador = contador + 1;
  endwhile
  L = L_t;
  S = S_t;
  error = E_t;
endfunction
