# Econometría I

Profesor: Juan Urquiza

## Clase 1

¿Qué es la econometría? Una disciplina que emplea la teoría económica y los métodos estadísticos para estudiar relaciones  económicas, contrastar distintas teorías, pronosticar variables, y evaluar políticas en forma cuantitativa, utilizando bases de datos.

1. Estudia relaciones económicas
2. Contrastar distintas teorías
3. Pronosticar variables
4. Evaluar políticas en forma cuantitativa

Combinar estadística para dar respuesta a la teoría económica. Es una aplicación del método científico a la economía. La observación dara paso a la formulación de hipótesis y pruebas empíricas.

En el curso vamos a buscar

1. Estimar cómo la esperanza condicional de una variable depende de otra
  - Modelos de regresión y con parcialización.
  - Modelos de crecimiento sugieren convergencia de PIB
2. Estimar el efecto causal de una variable sobre otras
  - Análisis de causalidad
  - Desafíos de los análisis,dado que no podemos controlar todos los factores realmente.
3.  Predicción sobre el comportamiento de variables
  - Banco Central en tasa de inflación
  - Series de tiempo

**Datos**

- Datos experimentales
- Datos observacionales

Q: ¿Preguntas causales con datos observacionales?

**Datos**

1.  Datos de sección cruzada o corte transversal

- Mediciones de distintas entidades en un momento de tiempo
- Unidades de observaciones: personas, hogares, firmas, industrias
- Ejemplo: CASEN

2. Datos de series de tiempo
- Secuencia de observaciones en un intervalo de tiempo determinado
- Ejemplo: la distribución de un país de inflación, desempleo y crecimiento económico.

3. Combinados transversales
- No hay seguimiento de las mismas unidades. Pero se pegan los data frames
- Combinación de datos transversal

4. Datos panel
- Seguimiento de las mismas unidades en el tiempo.
- Q: Datas mundiales, ENE o EPS ¿empalmes?


## Clase 2

**Función de esperanza condicional**

La esperanza condicional nos permitirá relacionar las variables. Dado que $X_i$ es una variable aleatoria, entonces la FEC también lo es.

Por ejemplo, la relación entre salario y años de ecuación. Hay diferencias en los salarios según los años de educación, y para cada grupo si bien hay una distribución podemos hablar de la media.


**Ley de esperanzas iteradas**

Nos permitirá descomponer el $Y_i$ en un término que es $E (Y_i | X_i) + e_i$, junto a su vez que $E (e_i | X_i) = 0$.

Esto nos garantiza que existe una representación que está descompuesto como una variable aleatoria Y que es condicional a X, más algo que no está relacionado a Xi

En síntesis, permite descomponer variables aleatorias. Si uno quiere relacionar dos variables **FEC**.

**Función de Regresión Poblacional**

Si queremos llegar a la FEC es partir por FRP.

- La FRP es el mejor predictor lineal de $Y_i$
- Va a ser la mejor predicción lineal.

![](img/01clase1.jpg)

**Modelo de Regresión Lineal Simple**

- El termino error o perturbación inobservable. Refiere a factores (o variable no observada, incluida), y esto produce la distancia entre los valores esperados en la FEC y FRP.
- Esto permite hacer análisis ceteris paribus de cada predictor.

- Como se soluciona la endogeneidad.
- Niveles de confirmación y exploración.

- Especificación: lo fundamental es la relación lineal. La relación lineal se ve como una **combinación lineal** entre variables.

- Ceteris paribus: también se calcula con la variación de la esperanza.

- Causalidad: no hay una relación de causalidad (¿mirar formulas 2.19 en JW?). ¿Diferencia corr por lo de parcialización, varianza/variabilidad?

- Control estadístico: relevante pues si no se hacen estimaciones sesgadas.

![](img/02clase1.jpg)

## Clase 3

 Utilizamos MCO para reducir los residuos, entonces minimizamos la suma cuadrada de los residuos.

## Clase 4

### Propiedades alegbraicas de MCO

Las propiedades agebraicas se derivan de las llamadas ecuaciones normales para MCO.

1. La suma de residuos da cero pues el MCO está optimizado para ello.


**R cuadrado**
Corresponde a la proporcion de la variación muestral de y que es explicada por la regresión de MCO.


Implicitamente con MCO **maximizamos** R cudradado, al intentar minimizar *SCT* en relación a los *SCE*. Entre más parecidos sea SCE y SCT, mayor va a ser el ajuste o el R cuadrado.

## Clase 5

### Supuestos de la Regresión Lineal

#### Linealidad

La relación poblacional entre las variables sigue un modelo lineal

Se puede escribir como la suma entre una variable y un escalar. El modelo es lineal entre los parámetros, pero eso no significa que las relaciones sean lineales.


Diferencia entre relación lineal de parámetros y efectos lineales

¿Cómo mantener una estructura de relación entre variables si las variables no tienen una relación lineal con el predictor?

Si no está lineal, hay que linealizarlo. Por ejemplo Cobb Douglas que está en exponentes, la forma de linealizarlo sería con un logaritmo.

Por ello, se pueden hacer cambios.

#### Muestreo aleatorio

la observaciónes provienen de una muestra aleatoria de la población.

Esto significa que las observaciones son independientes:
$$cov (u_i, u_j | X) = 0, para todo i distinto j$$

En una serie de tiempo podríamos encontrar un problema de autocorrelación serial.

Q: ¿Se podrá estimar la regresión o no, si hay muestreo por cuotas?

#### Colinealidad imperfecta

No hay relaciones lineales exactas entre variables independientes

En la realidad están correlacionadas las variables, pero no perfectamente correlacionadas. Ejemplo del gasto en profesor y gasto en no profesores (pero no el gasto total).

En otras palabras, **X tiene rango completo**, por eso es invertible y definida positiva. Si X'X no fuera invertible, no sería estimable (recordar clase 3).

Esto permite la identificación de los parámetros para poder estimar el modelo.

Si hay algún grado de correlación alta hará que se haga difícil la identificación de parámetros.

En síntesis: dice que no pueden estar correlacionadas de manera perfecta. Eso si, si están correlacionadas, dificulta la **identificación** y podría producir un problema de **especificidad**.

MCO va a intentar hacer esta combinación lo más **precisa** posible.

#### Media condicional

$E(u|x)=0$

También se puede escribir como E(u|x1,...,xk) = 0

Significa que ninguno de los factores en el término de error correlaciona con las variables explicativas.

Esto implica que la media de los errores es 0.

Imaginemos que tenemos un modelo de regresión, y alguno de los factores que queríamos incorporar no las observamos. Por ejemplo, el ingreso salarial en base a variables observadas pero no tenemos las no observadas (habilidad del trabajador) que se irán al error. Si la habilidad estuviese correlacionada con nivel de escolaridad.

Fuentes:

- Omisión de variables relevantes.
- Especificación incorrecta de forma funcional, omisión de variables relevantes, más de una **variable endógena** ecuaciones simultáneas, **errores de medición**.

Con ML.1, ML2, ML3 y ML4 buscamos que sea insesgado.

#### Homocedastecidad

$V(u|X) = \sigma{^2}I$

- Tenemos que ver que la dispersión dentro de los grupos no fuera la misma (las medias condicionales).

- Buscamos que la varianza del error sea constante.

- Es decir, la varianza del error no depende de haber pbservado una realización particular de X. Cuando este supuesto no se cumple, se dice que el modelo presenta heterocedasticdad.

Un ejemplo:
En la regresión del salario sobre el salario sobre años de educación, probablemente la varianza por cada año de educación sea distinta. Podría ser por el tipo de empleos son similares en personas con menos años de educación.

- Gracias a esto se puede ver de que son de mínima varianza entre los estimandores insesgados

- Teorema Gauss Markow


## Clase 5 - parte  2

**Propiedades estadística - varianza**

Cuando estemos mirando al vector de betas cuadrados
