import numpy as np
import imageio
import matplotlib.pyplot as plt


def esta_ordenada(lista):
    largo_lista = len(lista)
    flag = True
    for i in range(0, largo_lista):
        if i + 1 < largo_lista:
            if lista[i] > lista[i + 1]:
                flag = False
                break
    return flag


def ordenar_asc(lista):
    largo_lista = len(lista)
    lista_ordenada = np.zeros((1, 9))
    lista_ordenada = lista_ordenada[0]
    while not esta_ordenada(lista):
        for i in range(0, largo_lista):
            if i + 1 < largo_lista:
                if lista[i] > lista[i + 1]:
                    menor = lista[i + 1]
                    mayor = lista[i]
                    lista[i] = menor
                    lista[i + 1] = mayor
    lista_ordenada = lista
    return lista_ordenada


def obtener_pixel(imagen, m, n, i_actual, j_actual, k):
    if 0 <= i_actual < m and 0 <= j_actual < n:
        return imagen[i_actual, j_actual, k]
    else:
        return 0


def mediana(imagen_sucia):
    m = len(imagen_sucia)
    n = len(imagen_sucia[0])
    r = len(imagen_sucia[0][0])
    imagen_limpia = np.zeros((m, n, r), dtype=np.uint8)
    kernel_a_lista = np.zeros((1, 9))
    kernel_a_lista = kernel_a_lista[0]
    elemento_medio = round(9 / 2) + 1
    for k in range(0, r):
        for i in range(0, m):
            for j in range(0, n):
                if imagen_sucia[i, j, k] == 0:
                    kernel_a_lista[0] = obtener_pixel(imagen_sucia, m, n, i - 1, j - 1, k)
                    kernel_a_lista[1] = obtener_pixel(imagen_sucia, m, n, i, j - 1, k)
                    kernel_a_lista[2] = obtener_pixel(imagen_sucia, m, n, i + 1, j - 1, k)
                    kernel_a_lista[3] = obtener_pixel(imagen_sucia, m, n, i - 1, j, k)
                    kernel_a_lista[4] = obtener_pixel(imagen_sucia, m, n, i, j, k)
                    kernel_a_lista[5] = obtener_pixel(imagen_sucia, m, n, i + 1, j, k)
                    kernel_a_lista[6] = obtener_pixel(imagen_sucia, m, n, i - 1, j + 1, k)
                    kernel_a_lista[7] = obtener_pixel(imagen_sucia, m, n, i, j + 1, k)
                    kernel_a_lista[8] = obtener_pixel(imagen_sucia, m, n, i + 1, j + 1, k)
                    kernel_a_lista = ordenar_asc(kernel_a_lista)
                    imagen_limpia[i, j, k] = kernel_a_lista[elemento_medio]
                else:
                    imagen_limpia[i, j, k] = imagen_sucia[i, j, k]
    return imagen_sucia, imagen_limpia



def rotacion(A = imageio.imread("barbara.jpg"), ang = np.pi/4):
    #   Funcion rotacion de una imagen en escala de grises,
    #   el proceso consiste en rotar una imagen hacia la derecha
    #   segun el angulo de rotacion theta.
    #   Entrada:
    #           img = imagen a color 
    #           ang = angulo de rotacion en radianes(default = pi/4)
    
    m = len(A)
    n = len(A[0])
    r = len(A[0][0])
    B = np.zeros((m, n, r), dtype=np.uint8) #Imagen de salida
    
    #Centro de rotacion, parte entera
    x_c = m//2     
    y_c = n//2 

    for x in range(m):
        for y in range(n):
            #Calculo de la nueva posicion x del pixels
            a0 = np.cos(ang)
            a1 = np.sin(ang)
            a2 = x_c - a0*x_c - a1*y_c
            x_t = round(a0*x + a1*y + a2)
            #Calculo de la nueva posicion y del pixels
            b0 = -np.sin(ang)
            b1 = np.cos(ang)
            b2 = y_c - b0*y_c - b1*y_c
            y_t = round(b0*x + b1*y + b2)
            #Solo se coloca el pixels si la posicion 
            # no sobrepasa el tamano de la imagen original.
            if x_t>=0 and y_t>=0 and x_t<m and y_t<n:
                B[x_t, y_t, :] = A[x, y, :]
    return A, B

#Rotacion
imagen_original, imagen_rotada = rotacion(imageio.imread("barbara.jpg"), np.pi/4)

_, imagen_filtrada = mediana(imagen_rotada)

plt.figure(1)
plt.subplot(131)
plt.title("Imagen Original")
plt.imshow(imagen_original)
plt.subplot(132)
plt.title("Rotacion(Sin filtro de la mediana)")
plt.imshow(imagen_rotada)
plt.subplot(133)
plt.title("Rotacion(Con filtro de la mediana)")
plt.imshow(imagen_filtrada)
plt.show()
