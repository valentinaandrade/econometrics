# Tarea 1 -----------------------------------------------------------------
## Codigo: Valentina Andrade

## Determinantes crecimiento economico
# 1. Cargar paquetes ------------------------------------------------------
pacman::p_load(googledrive, performance, tidyverse, ggthemes,
               sjPlot, sjmisc, summarytools, xtable)
theme_set(theme_economist()
          #+ scale_colour_economist(stata=TRUE)
          )

# 2. Load data ------------------------------------------------------------
drive_download("https://drive.google.com/file/d/1mXM-tODPoPS_-QbVM4F9x7QV07rNkyGf/view?usp=sharing", path = "input/base_tarea1.dta")
data <- haven::read_dta("input/base_tarea1.dta")

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
data <- sjlabelled::set_label(data, c("País", "Tasa crecimiento anual (PIB real)",
                                      "Grado de apertura comercio (promedio, En PIB)", "Escolaridad adultos (años promedio)",
                              "Hitos disruptivos (promedio anual)","Asesinatos políticos (promedio anual)",
                              "PIB per cápita (base 1960)"))
# 4. Preguntas ------------------------------------------------------------
## 1. Distribución de growth, tradeshare, yearscchol
### 1.1. Describe (media, desviación estándar, mínimo y máximo)

view_df(data)

tab1 <- summarytools::dfSummary((data %>%  select(-country_name)),
                             varnumbers = F, valid.col =  F, na.col = F, freqs.pct.valid = F, headings = F,
                             graph.magnif = 1.5, style = "grid", 
                             silent = T,
                             plain.ascii = F)

tab1$`Freqs (% of Valid)` <- NULL
view(tab1 , style = "rmarkdown", lang ="es",  footnote = "<b>Fuente</b>: Elaboración propia en base a datos de tarea N°1 (n = 64)" )                   
## 2. Matriz de correlaciones de todas las variables y luego discutir significancia estadística 

# x is a matrix containing the data
# method : correlation method. "pearson"" or "spearman"" is supported
# removeTriangle : remove upper or lower triangle
# results :  if "html" or "latex"
# the results will be displayed in html or latex format

corstars <-function(x, method=c("pearson", "spearman"), removeTriangle=c("upper", "lower"),
                    result=c("none", "html", "latex")){
  #Compute correlation matrix
  require(Hmisc)
  x <- as.matrix(x)
  correlation_matrix<-rcorr(x, type=method[1])
  R <- correlation_matrix$r # Matrix of correlation coeficients
  p <- correlation_matrix$P # Matrix of p-value 
  
  ## Define notions for significance levels; spacing is important.
  mystars <- ifelse(p < .0001, "****", ifelse(p < .001, "*** ", ifelse(p < .01, "**  ", ifelse(p < .05, "*   ", "    "))))
  
  ## trunctuate the correlation matrix to two decimal
  R <- format(round(cbind(rep(-1.11, ncol(x)), R), 2))[,-1]
  
  ## build a new matrix that includes the correlations with their apropriate stars
  Rnew <- matrix(paste(R, mystars, sep=""), ncol=ncol(x))
  diag(Rnew) <- paste(diag(R), " ", sep="")
  rownames(Rnew) <- colnames(x)
  colnames(Rnew) <- paste(colnames(x), "", sep="")
  
  ## remove upper triangle of correlation matrix
  if(removeTriangle[1]=="upper"){
    Rnew <- as.matrix(Rnew)
    Rnew[upper.tri(Rnew, diag = TRUE)] <- ""
    Rnew <- as.data.frame(Rnew)
  }
  
  ## remove lower triangle of correlation matrix
  else if(removeTriangle[1]=="lower"){
    Rnew <- as.matrix(Rnew)
    Rnew[lower.tri(Rnew, diag = TRUE)] <- ""
    Rnew <- as.data.frame(Rnew)
  }
  
  ## remove last column and return the correlation matrix
  Rnew <- cbind(Rnew[1:length(Rnew)-1])
  if (result[1]=="none") return(Rnew)
  else{
    if(result[1]=="html") print(xtable(Rnew), type="html")
    else print(xtable(Rnew), type="latex") 
  }
} 

corstars(data[,2:7], result = "latex")

## 3. Scatter 

### (i) tradeshare y growth
### (ii) yearsschool y growth

## 4. Model
lm(growth ~ tradeshare + yearschool + rev_coups + assasinations + rgdp60, data = data)

## 5. Propiedades

### 5.1 Suma de residuos 0

### 5.2 Ortoganlidad a variables explicativas

### 5.3 Promedio variable dependiente  es igual a promedio variable dependiente estimada

### 5.4 Compruebe que el R es igual al cuadrado del coeficiente de correlacion entre variable dependiente
# y dependiente estimada

## 6. Predictions model 1
### ¿Significativas?

## 7. Prueba de significancia global del modelo 1, y luego, comrpuebe que el estadístico F reportado
### Por STATA puede obtenerse a partir del R cuadrado de regresion
### Conclusiones

## 8. Estime la tasa de crecimiento que predice modelo 1 para que:
### (i) tiene valores promedio para todos los regresores
### (ii) tiene valores promedios para todos los regresiones menos tradeshare, que toma un valor igual a dos desviaciones estandar por cencima de la media
### (iii) prueba formal para determinar sii preddciones son estadisiticamente distintas


## 9. Estimar cambio de tasa de crecimiento que predice modelo 1 para un pais queen 1960 implemento
## politica educativa que permitio aumentar escolaridas promedio de 4 a 6 años
## luego refierase  a significancia

## 10. Evaluar significancia conjunta de variables tradeshare, rev_coups y assasinations, y luego comprobar
### estadistico F reportado por STATA puede obtenerse a partir de diferencia en suma de cuadrados residuales
## de modelo restringido y no resteinguido 