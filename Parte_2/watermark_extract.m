%Funcion para la extraccion de la marca de agua
% Utiliza la transformada discreta de coseno
%Entradas:
%   I_d: imagen original con formato de 8bits
%   U1: valor singular obtenido de la marca de agua en el empotrado
%   V1: valor singular obtenido de la marca de agua en el empotrado
%   S: valor singular obtenido de la imagen original en el empotrado
%   M: largo del bloque en la division para transformacion
%   N: ancho del bloque en la division para transformacion
%   alpha: constante de intensidad para la incrustacion
%Salidas:
%   W_d: imagen de la marca agua extraida con formato de 8bits

function W_d=watermark_extract(I_d,U1,V1,S,M,N,alpha)
  I_d=im2double(I_d); %conversion de los valores de uint8 a double
  
  [m,n]=size(I_d); %tamano de la imagen (512x512)
  
  F_d=zeros([m n]); %creacion de la matriz F_d (transformad de I_d)
  A_d=zeros([m/M n/N]); %creacion de la matrix A_d (valores DC de F_d)
  W_d=zeros([m/M n/N]); %creacion de la matriz de la marca de agua
  
  %Aplicacion de la transformada discreta de coseno en bloques de MxN
  %Transformada de dos dimensiones usando la funcion de Octave dct2
  for block_line=0:(m/M)-1
    for block_col=0:(n/N)-1
      lpos=block_line*M;
      cpos=block_col*N;
      F_d(lpos+1:lpos+M,cpos+1:cpos+N)=dct2(I_d(lpos+1:lpos+M,cpos+1:cpos+N));
    endfor
  endfor

  %Transformada manual (tiene un rendimiento peor que la funcion de octave)
  %definicion de variables para la ubicacion de los bloques
  % M_offset=0;
  % N_offset=0;
  % for block_line=1:(m/M)
  %   for block_col=1:(n/N)
  %     for p=1:M
  %       for q=1:N
  %         Cu=0;Cv=0;
  %         if p==1
  %           Cu=sqrt(1/M);
  %         else
  %           Cu=sqrt(2/M);
  %         endif
  %         if q==1
  %           Cv=sqrt(1/N);
  %         else
  %           Cv=sqrt(2/N);
  %         endif
  %         for i=1:M
  %           for j=1:N
  %             cos_u=cos(pi*(2*(i-1)+1)*(p-1)/(2*M));
  %             cos_v=cos(pi*(2*(j-1)+1)*(q-1)/(2*N));
  %             I_mnd=I_d(i+M_offset,j+N_offset);
  %             F_d(p+M_offset,q+N_offset)+=Cu*Cv*I_mnd*cos_u*cos_v;
  %           endfor
  %         endfor
  %       endfor
  %     endfor
  %     N_offset+=N;
  %   endfor
  %   M_offset+=M;
  %   N_offset=0;
  % endfor

  %Obtencion de la matriz A_d por medio de los primeros valores (valores DC) 
  % de F_d en bloques de MxN. F_d(1,1)(1<=m<=64,1<=n<=64)
  for block_line=0:(m/M)-1
    for block_col=0:(n/N)-1
      %calculo de posiciones de block_line(0,1,2,...,63) * M(8) + ajuste(1 o M)
      A_d(block_line+1,block_col+1)=F_d(block_line*M+1,block_col*N+1);
    endfor
  endfor

  %Descomposicion de valores singulares de A_d usando la funcion 
  % de Octave svd
  [U_d,S_d,V_d]=svd(A_d);

  %Obtencion de D por medio de los valores singulares de A_d
  D=U1*S_d*V1';
  %Obtencion de la marca de agua
  W_d=(D-S).*(1/alpha);
  
  W_d=im2uint8(W_d);
endfunction