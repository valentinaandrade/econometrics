# Lecturas Econometría

## Métodos de econometría

### Capítulo 1

#### Estimaciones

**Estimador**: es una fórmula, método o receta para etimar un parámetro desconocido en una población.

**Estimación**: es el valor numérico obtenido cuando en la fórmula se sustituyen los datos de la muestra.

En los modelos de regresión lineal de la forma $\hat{Y_i} = \alpha + bX_i$. El valor observado de $Y_i$ será $\hat{Y_i}$. Del par $\alpha$ y $b$ se pueden obtener múltiples estimadores.

Utilizaremos el *método de mínimos cuadrados* (en español MCO y en inglés OLS), que es el principio de inferencia de mayor uso y potencial (más en Stingler (1986) en *The History of Statistics* ).

Los residuos de cualquier línea recta ajustada es:

$e_i = Y_i - \hat{Y_i} = Y_i - \alpha - bX$ para cada i = 1,2, ...n

Como vemos, la *suma de los cuadrados de los residuos es, __función de a y b__*. El principio mínimo cuadrático de los resdios es

$$ SCR = \sum{{e^2}_i} = f(\alpha,b)$$
