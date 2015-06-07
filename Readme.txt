Explicación de modulos:

1) Bolas.jl: contiene todo lo necesario para utilizar los intervalos de bola, incluyendo Método de Newton.

2) Derivatives.jl:  contiene lo necesario para utilizar derivación automática, el Método de Newton require este módulo pero lo llama dentro del de Bolas.jl

3) Intervals.jl: contiene lo necesario para poder utilizar intervalos normales.

4) BolaIntervalo.jl: contiene funciones para convertir intervalos normales en intervalos de bola y visceversa.

5) BolasTest.jl, IntervalsTest.jl: contiene los tests de los modulos respectivos.

6) Presentacion.ipynb: La presentación del proyecto.

7) EsquemaNewton.jpg: Esquema que explica el flujo de la implementación del método de Newton del módulo.
