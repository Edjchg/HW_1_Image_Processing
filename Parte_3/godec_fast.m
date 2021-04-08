function [L, S, error] = godec_fast(A, k, c_0, epsilon)
  t = 0;
  
  [m,n] = size(A);
  if m<n
    L_t = A';
    A = A';
  else
    L_t = A;
  endif
  S_t = zeros(size(A));
  E_t = 0;
  contador = 0;
  while (1)
    t = t + 1;
    L_t = rango_reducido_bilateral(A - S_t, k, 0);
    S_t = P_c03(A - L_t, c_0);
    if abs(obtener_error(A, L_t, S_t) - E_t) < epsilon
    %if contador == 0
      break
    endif
    E_t = obtener_error(A, L_t, S_t);
    %contador = contador + 1;
  endwhile
  if m<n
    L = L_t';
    S = S_t';
  else
    L = L_t;
    S = S_t;
  endif
  error = E_t;
endfunction
