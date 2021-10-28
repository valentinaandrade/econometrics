# Tarea 2 -----------------------------------------------------------------
## Codigo: Valentina Andrade

## Determinantes crecimiento economico
# 1. Cargar paquetes ------------------------------------------------------
pacman::p_load(googledrive, performance, tidyverse, ggthemes,
               sjPlot, sjmisc, summarytools, xtable)
theme_set(theme_economist()
          #+ scale_colour_economist(stata=TRUE)
          )

# 2. Load data ------------------------------------------------------------
drive_download("https://drive.google.com/file/d/1mS8bYjgQsZxZMc9Dt_dfsJ_eQhIL3F4a/view?usp=sharing", path = "input/base_tarea2.dta")
data <- haven::read_dta("input/base_tarea2.dta")

# 3. Explore data ---------------------------------------------------------
names(data)
## growth: tasa promedio de crecimiento anual del PIB real
## country_name: 64 paises
## year: 1960 y 1995
## tradeshare: grado de apertura promedio (exportaciones e importaciones sobre PIB)
## yearsschol: años de escolaridad promedio de la pobacion adulta en 1960
## rev_coups: promedio anual de revoluciones, insurrecciones y golpes de Estado (1960 -1995)
## assesinations: promedio anual de asesinatos politicos entre 1960-1995 (por millón de habitanes)
## rgpp60: pib per cápita 1960 (en dolares)
data <- sjlabelled::set_label(data, c("Identificador numérico del país",
                                      "País",
                                      "País no petrolero",
                                      "País intermedio",
                                      "País OECD",
                                      "PIB per cápita (base 1960)",
                                      "PIB per cápita (base 1985)",
                                      "Crecimiento población (1960-1985)",
                                      "Inversión real (prom 1960-1985)",
                                      "Porcentaje escolaridad (prom 1960-1985"))

# - $\frac{Y}{L}$:  el producto por trabajador
# - $s$: $\frac{I}{Y}$ tasa de inversión en capital físico
# - $n$: tasa de crecimiento de la población en edad de trabajar
# - $g$: tasa de cambio tecnológico
# - $\delta$: tasa de depreciación.

# 4. Preguntas ------------------------------------------------------------
## 1. Distribución de growth, tradeshare, yearscchol
### 1.1. Estime la ecuación por MCO para cada submuestra de países. Puede suponer que g + δ= 0.05 (como hacen MRW) y utilizar como variable dependiente el logaritmo del PIB real por trabajador en 1985.

#### no olvide dividir las variables i_y y popgrowth entre 100 antes de estimar.
### Compruebe que es capaz de replicar las estimaciones de la tabla 1 en MRW (1992).


# 1. Primero calculamos variabls
## ln (y/l)_85 = ln(rgdpw85)
## ln (y/l)_60 = ln(rgdpw60)
## i = i_y/100
## pop = pop_growth/100
## ln(s) = ln(I/Y) = ln(i/rgdpw85)
## ln(n+g+ delta) = ln(pop + 0.05)

data2 <- data %>%
  mutate(ln_yl85 = log(rgdpw85),
         ln_yl60 = log(rgdpw60),
         i_n = i_y/100,
         pop_n = popgrowth/100) %>% 
  mutate(ln_sk = log(i_n/ rgdpw85),
    ln_ngdelta = log(pop_n + 0.05),
    school_n = school/100, # para pregunta2
    ln_sh = log(i/school_n))





modelo0 <- lm(ln_yl85 ~ ln_sk + ln_ngdelta, data = data2)
summary(modelo0)

# Modelo 1 - non oil ------------------------------------------------------
modelo1_n <- lm(ln_yl85 ~ ln_sk + ln_ngdelta, data = data, subset = (n == 1))
summary(modelo1_n)
# Modelo 1 - Intermediate -------------------------------------------------
modelo1_i <- lm(ln_yl85 ~ ln_sk + ln_ngdelta, data = data, subset = (i == 1))
summary(modelo1_i)
# Modelo 1 - OECD ---------------------------------------------------------
modelo1_o <- lm(ln_yl85 ~ ln_sk + ln_ngdelta, data = data)
summary(modelo1_o)
