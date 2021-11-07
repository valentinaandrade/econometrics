# Tarea 2 -----------------------------------------------------------------
## Codigo: Valentina Andrade

## Determinantes crecimiento economico
# 1. Cargar paquetes ------------------------------------------------------
pacman::p_load(googledrive, performance, tidyverse, ggthemes,
               sjPlot, sjmisc, summarytools, xtable,
               sandwich,lmtest)
theme_set(theme_economist()
          #+ scale_colour_economist(stata=TRUE)
          )

# 2. Load data ------------------------------------------------------------
drive_download("https://drive.google.com/file/d/1mS8bYjgQsZxZMc9Dt_dfsJ_eQhIL3F4a/view?usp=sharing", path = "input/base_tarea2.dta")
data <- haven::read_dta("input/base_tarea2.dta")

# 3. Explore data ---------------------------------------------------------
names(data)

# 4. Preguntas ------------------------------------------------------------
### 1.1. Estime la ecuación por MCO para cada submuestra de países. Puede suponer que g + δ= 0.05 (como hacen MRW) y utilizar como variable dependiente el logaritmo del PIB real por trabajador en 1985.

# 1. Primero calculamos variabls
data <- data %>%
  mutate(ln_yl85 = log(rgdpw85),
         ln_yl60 = log(rgdpw60),
         i_n = i_y/100,
         pop_n = popgrowth/100, 
        ln_sk = log(i_n),
        ln_ngdelta = log(pop_n + 0.05),
        school_n = school/100, # para pregunta2
        ln_sh = log(school_n),
        ln_yl85_60 = ln_yl85 - ln_yl60)



# Etiquetar ---------------------------------------------------------------
data <- sjlabelled::set_label(data, c("Identificador numérico del país",
                                      "País",
                                      "País petrolero",
                                      "País intermedio",
                                      "País OECD",
                                      "PIB per cápita (1960)",
                                      "PIB per cápita (1985)",
                                      "Crecimiento población (1960-1985)",
                                      "Inversión real (prom 1960-1985)",
                                      "Porcentaje escolaridad (prom 1960-1985",
                                      "log PIB per cápita (1985)",
                                      "log PIB per cápita (1960)",
                                      "Inversion capital fisico",
                                      "Población (1960-1985)",
                                      "log capital físico",
                                      "Crecimiento, cambio tecnologico y depreciacion",
                                      "Acumulacion capital humano",
                                      "log Capital humano",
                                      "log PIB por trabajador inicial-final"))

# Modelos -----------------------------------------------------------------




modelo0 <- lm(log(rgdpw85) ~ log(i_n/ rgdpw85) + log(pop_n + 0.05), data = data2)
summary(modelo0)

# Modelo 1 - non oil ------------------------------------------------------
modelo1_n <- lm(ln_yl85 ~ ln_sk + ln_ngdelta, data = data, subset = (n == 1))
summary(modelo1_n)
# Modelo 1 - Intermediate -------------------------------------------------
modelo1_i <- lm(ln_yl85 ~ ln_sk + ln_ngdelta, data = data, subset = (i == 1))
summary(modelo1_i)
# Modelo 1 - OECD ---------------------------------------------------------
modelo1_o <- lm(ln_yl85 ~ ln_sk + ln_ngdelta, data = data, subset = (o == 1))
summary(modelo1_o)

# II. Interpretar ---------------------------------------------------------
## Interprete los coeficientes estimados para las tres submuestras. ¿Son los coeficientes
##individualmente significativos al 5%? ¿Explican la inversión y el crecimiento de la
##población una parte importante de la variación en el producto por trabajador?


# Hipotesis ---------------------------------------------------------------
# Contraste la hipótesis de que los coeficientes son iguales en magnitud pero de distinto
# signo (como predice el modelo) para cada una de las submuestras (H0: β1 + β2 = 0).
# ¿Puede rechazar la hipótesis nula al 5%?

# Pregunta 3 --------------------------------------------------------------
model3_3_n <- lm(ln_yl85_60 ~ ln_yl60 + ln_ngdelta + ln_sk + ln_sh + ln_sk*ln_sh,
               data = data,subset = (n == 1))
model3_3_i <- lm(ln_yl85_60 ~ ln_yl60 + ln_ngdelta + ln_sk + ln_sh + ln_sk*ln_sh,
                 data = data,subset = (n == 1))
model3_3_o <- lm(ln_yl85_60 ~ ln_yl60 + ln_ngdelta + ln_sk + ln_sh + ln_sk*ln_sh,
                 data = data,subset = (o == 1))

model3_3_n_robust <- lmtest::coeftest(model3_3_n, vcov = vcovHC(model3_3_n, type="HC1"))
model3_3_i_robust <- lmtest::coeftest(model3_3_i, vcov = vcovHC(model3_3_i, type="HC1"))
model3_3_o_robust <- lmtest::coeftest(model3_3_o, vcov = vcovHC(model3_3_o, type="HC1"))

plot_residuals(model3_3_n, vcov.type = "HC1")
