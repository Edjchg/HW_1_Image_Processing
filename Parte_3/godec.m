function[L, S, error] = godec(A, k, c_0, epsilon)
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
  %while (1)
  while(1)
    t = t + 1;
    L_t = rango_reducido(A-S_t, k);
    S_t = P_c03(A-L_t, c_0);
    if abs(obtener_error(A, L_t, S_t) - E_t) < epsilon
      break
    endif
    E_t = obtener_error(A, L_t, S_t);
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


