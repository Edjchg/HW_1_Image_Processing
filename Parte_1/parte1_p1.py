import numpy as np
import imageio
import matplotlib.pyplot as plt

# pip install opencv-python

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


def mediana(imagen_str):
    imagen_sucia = imageio.imread(imagen_str)
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
            
    return imagen_sucia, imagen_limpia

#Procesamiento secuencial:
imagen_sucia, imagen_limpia = mediana("imagen1.jpg")

plt.figure(1)
plt.subplot(121)
plt.title("Imagen sucia")
plt.imshow(imagen_sucia)
plt.subplot(122)
plt.title("Imagen limpia")
plt.imshow(imagen_limpia)
plt.show()
