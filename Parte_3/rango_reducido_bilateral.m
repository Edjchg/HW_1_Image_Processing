function L_t =rango_reducido_bilateral(A, r, p)
  %Paso 1
  n=size(A,2); %Numero de columnas de A, si se quieren filas se pone 1.
  Y2=randn(n,r);
  %Paso 2
  for k=1:p+1
    Y1=A*Y2;
    Y2=A'*Y1;
  endfor
  %Paso 3
  [Q,R]=qr(Y2);%A=QR, Q=ortogonal, R=triangular superior
  %Paso 4
  Qr=Q(:,1:r);
  B=A*Qr;
  C=Qr';
  L_t = B*C;
endfunction