%Funcion para la incrustacion o empotrado de la marca de agua
% Utiliza la transformada discreta de coseno
%Entradas:
%   I: imagen original con formato de 8bits
%   W: imagen de la marca agua con formato de 8bits
%   M: largo del bloque en la division para transformacion
%   N: ancho del bloque en la division para transformacion
%   alpha: constante de intensidad para la incrustacion
%Salidas:
%   I_d: imagen con la marca de agua con formato de 8bits
%   U1: valor singular obtenido de la marca de agua en el empotrado
%   V1: valor singular obtenido de la marca de agua en el empotrado
%   S: valor singular obtenido de la imagen original en el empotrado

function [I_d,U1,V1,S]=watermark_embedding(I,W,M,N,alpha)
  I=im2double(I); %conversion de los valores de uint8 a double
  W=im2double(W); %conversion de los valores de uint8 a double
  
  [m,n]=size(I); %tamano de la imagen original (512x512)
  
  F=zeros([m n]); %creacion de la matriz F (transformada)
  A=zeros([m/M n/N]); %creacion de la matrix A (valores DC)
  I_d=zeros([m n]); %creacion de la matriz de la imagen de salida

  %Aplicacion de la transformada discreta de coseno en bloques de MxN
  %Transformada de dos dimensiones usando la funcion de Octave dct2
  for block_line=0:(m/M)-1
    for block_col=0:(n/N)-1
      lpos=block_line*M;
      cpos=block_col*N;
      F(lpos+1:lpos+M,cpos+1:cpos+N)=dct2(I(lpos+1:lpos+M,cpos+1:cpos+N));
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
  %             I_mn=I(i+M_offset,j+N_offset);
  %             F(p+M_offset,q+N_offset)+=Cu*Cv*I_mn*cos_u*cos_v;
  %           endfor
  %         endfor
  %       endfor
  %     endfor
  %     N_offset+=N;
  %   endfor
  %   M_offset+=M;
  %   N_offset=0;
  % endfor

  %Obtencion de la matriz A por medio de los primeros valores (valores DC) 
  % de F en bloques de MxN. F(1,1)(1<=m<=64,1<=n<=64)
  for block_line=0:(m/M)-1
    for block_col=0:(n/N)-1
      %calculo de posiciones de block_line(0,1,2,...,63) * M(8) + ajuste(1 o M)
      A(block_line+1,block_col+1)=F(block_line*M+1,block_col*N+1);
    endfor
  endfor

  %Descomposicion de valores singulares de A usando la funcion de octave svd
  [U,S,V]=svd(A);
  %Descomposicion de valores singulares de S + alpha * W [marca de agua]
  % usando la funcion de octave svd
  [U1,S1,V1]=svd(S+alpha*W);
  %Obtencion del nuevo A 
  Ad=U*S1*V';

  %Inclusion de los valores DC de Ad en la matriz F
  for block_line=0:(m/M)-1
    for block_col=0:(n/N)-1
      %calculo de posiciones de block_line(0,1,2,...,63) * M(8) + ajuste(1 o M)
      F(block_line*M+1,block_col*N+1)=Ad(block_line+1,block_col+1);
    endfor
  endfor
  
  %Aplicacion de la transformada inversa discreta de coseno en bloques de MxN
  %Transformada inversa de dos dimensiones usando la funcion de Octave dct2
  for block_line=0:(m/M)-1
    for block_col=0:(n/N)-1
      lpos=block_line*M;
      cpos=block_col*N;
      I_d(lpos+1:lpos+M,cpos+1:cpos+N)=idct2(F(lpos+1:lpos+M,cpos+1:cpos+N));
    endfor
  endfor

  %Transformada inversa manual 
  % (tiene un rendimiento peor que la funcion de octave)
  % M_offset=0;
  % N_offset=0;
  % for block_line=1:(m/M)
  %   for block_col=1:(n/N)
  %     for i=1:M
  %       for j=1:N
  %         for p=1:M
  %           for q=1:N
  %             Cu=0;Cv=0;
  %             if p==1
  %               Cu=sqrt(1/M);
  %             else
  %               Cu=sqrt(2/M);
  %             endif
  %             if q==1
  %               Cv=sqrt(1/N);
  %             else
  %               Cv=sqrt(2/N);
  %             endif
  %             cos_u=cos(pi*(2*(i-1)+1)*(p-1)/(2*M));
  %             cos_v=cos(pi*(2*(j-1)+1)*(q-1)/(2*N));
  %             F_mn=F(p+M_offset,q+N_offset);
  %             I_d(i+M_offset,j+N_offset)+=Cu*Cv*F_mn*cos_u*cos_v;
  %           endfor
  %         endfor
  %       endfor
  %     endfor
  %     N_offset+=N;
  %   endfor
  %   M_offset+=M;
  %   N_offset=0;
  % endfor
  
  I_d=im2uint8(I_d); %conversion de double a uint8 a la imagen con marca
endfunction