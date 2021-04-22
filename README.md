# Tarea2MicroAv

Algunos comentarios sobre el proyecto:

1) Los códigos presentados fueron escritos por Fernando Stein y por mí, Eduardo Zago. Sin embargo, trabajamos muy de cerca con Miguel Lerdo de Tejada y Adrián Martinez,
por lo que tenemos códigos similares

2) Los códigos de MatLab fueron ejecutados en la computadora de Fernando, por lo que el tiempo estimado, así como los resultados, provienen de ahí. Por ejemplo, en mi compu
correr el Nelder Mead tardaba 3 veces más que en la de Fernando.

3) A continuación presentamos una breve descripción de los archivos.

- ProblemSet2.R:

Tiene todo el trabajo de la parte de datos agregados, el único insumo son los datos que se nos fueron dados para realizar los ejercicios.

- log_like:

Nuestra función de ML para los primeros 9 incisos de la parte 2, la cual utiliza a "denominador" para realizar el calculo del denominador de la probabilidad.

- log_lik_fs:

Función de ML para el inciso 10, la cual al ser maximizada por Newton-BFGS tardó demasiado en entregar resultado, por lo que decidimos pararla.
Sobre esta vale la pena enfatizar más la intuición. Realizamos en R una base con dummies de escuela, esta la usamos de insumo para poder calcular las 365 deltas 
del modelo, el cual puede ser visto como una estimación de efectos fijos. Esta función utliza a "denominador2" para lo mismo que la pasada y puede ser llamada desde
"Prueba10"

- log_lik_fs_2:

Función de ML para el inciso 12. Misma que el pasado pero agregamos las variables de educación de la madre. Esta igual puede ser llamada desde "Prueba10" y utiliza a denominador3.
