//===========================================================================//
// 		Tarea N°2
//      Econometria I - PUC
// 		Author: Valentina Andrade
//		Last update: 13-09-2021
//===========================================================================//
//  0. Preliminars
	clear all
	* Crear el log file
//	log using "output\log_assignament1.smcl", replace  
	*Instalar asdoc
	net install asdoc, from("http://fintechprofessor.com") replace // Para exportar tablas
	ssc install outreg2 // Tablas a latex
	net install spost13, from("https://jslsoc.sitehost.iu.edu/stata/") replace // Para lincom multiple
	set scheme s2color, permanently 	//Tema de graficos

	
// a. Directorio 		
	global data_row = "C:\Users\Valentina Andrade\Documents\GitHub\master\econometrics"
	global data_prepared "C:\Users\Valentina Andrade\Documents\GitHub\master\econometrics\input"
	global latex = "C:\Users\Valentina Andrade\Documents\GitHub\master\econometrics\ouput"
	cd "C:\Users\Valentina Andrade\Documents\GitHub\master\econometrics"
	

// b. Leer datos
	use "input\base_tarea2",replace

	
// 0. Procesamiento
// a. Tabla resumen de toda la base
	summarize 
	
// b. Crear variables
	gen ln_yl85 = log(rgdpw85)
	gen ln_yl60 = log(rgdpw60)
	gen i_n = i_y/100
    gen pop_n = popgrowth/100
	gen ln_sk = log(i_n/rgdpw85)
	gen ln_ngdelta = log(pop_n + 0.05)
// Para pregunta N°2
	gen school_n = school/100 
	gen ln_sh = log(school_n)
	
// Para pregunta N°3
	gen ln_yl85_60 = ln_yl85 - ln_yl60

// c. Etiquetar
	* Se hace para las tablas en latex despues
	label var number "Identificador numérico del país"
	label var country "País"
	label var n "Apertura económica"
	label var i  "País no petrolero"
	label var o "País intermedio"
	label var rgdpw60  "País OECD"
	label var rgdpw85  "PIB 1960"
	label var popgrowth  "PIB 1985"
	label var i_y   "Inversión real (prom 1960-1985)"
	label var school  "Porcentaje escolaridad (prom 1960-1985)"
** Nuevas **
	label var ln_yl85 "log PIB por trabajador 1985"
	label var ln_yl60 "log PIB por trabajador 1960"
	label var ln_sk "tasa de inversion capital fisico"
	label var ln_sh "tasa de acumulacion capital humano"
	label var ln_ngdelta "tasa crecimiento, cambio tecnologico y depreciacion"
	label var ln_yl85_60  "log PIB por trabajador inicial-final"
		
	
// Pregunta 1 ------------------------------------------------------------------

** 1.1 Estimacion modelos

*** Modelo 1 non oil
	regress ln_yl85 ln_sk ln_ngdelta if n == 1 //tablas en latex abajo
	estimate store modelo1_n //*ocuparlo despues
	estat vce // Para ver su matriz de correlaciones estimada 

*** Modelo 1 intermediate
	regress ln_yl85 ln_sk ln_ngdelta if i == 1 //tablas en latex abajo
	estimate store modelo1_i //*ocuparlo despues
	estat vce // Para ver su matriz de correlaciones estimada 

*** Modelo 1 OECD
	regress ln_yl85 ln_sk ln_ngdelta if o == 1 //tablas en latex abajo
	estimate store modelo1_o //*ocuparlo despues
	estat vce // Para ver su matriz de correlaciones estimada 

*** Forma corta: para pregunta 2 se aplica
**foreach var in n i o {
**	regress ln_yl85 ln_sk ln_ngdelta if `var' == 1
**	estimates store modelo1_`var'
**	}
	
	
** 1.2 Interpretacion
// Poner tablas y graficos adicionales


** 1.3 Hipotesis
foreach var in n i o {
	estimates restore modelo1_`var'
	. test (_b[ln_sk] = - _b[ln_ngdelta]) (_b[ln_sk] + _b[ln_ngdelta] = 0)
	}

*Nota*: La forma de poner la combinacion es análoga. Tambien se puede hacer este test con margins. Ver ultimas preguntas tarea anterior	

** 1.4 Agregar grafico adicional
** Graficos adicionales	
** a.1 Coeficientes parcializados 
foreach var in n i o {
	estimates restore modelo1_`var'
	estat summarize, labels
	avplot  ln_sk 
	graph export "output/figureln_sk-anexos-modelo1`var'.jpg"
	avplot  ln_ngdelta
	graph export "output/figureln_ngdelta-anexos-modelo1`var'.jpg"

}
**a.2 Forestplot

*** En base a guia de https://www.stata.com/meeting/germany14/abstracts/materials/de14_jann.pdf
foreach var in n i o {
	estimates restore modelo1_`var'
	coefplot, drop(_cons) xline(0) xtitle("Coeficientes de regresión")
	graph export "output/figure-plot-modelo1_`var'.jpg"
}

// Pregunta 2 ------------------------------------------------------------------

** 2.1 Estime modelos para cada submuestra

foreach var in n i o {
	regress ln_yl85 ln_ngdelta ln_sk ln_sh if `var' == 1
	estimates store modelo2_`var'
	}

// 2.2 Coeficiente ln(school)
	
** Graficos adicionales	
** a.1 Coeficientes parcializados 
foreach var in n i o {
	estimates restore modelo2_`var'
	estat summarize, labels
	avplot  ln_sh
	graph export "output/figure-anexos-modelo2`var'.jpg"	
}
**a.2 Forestplot

*** En base a guia de https://www.stata.com/meeting/germany14/abstracts/materials/de14_jann.pdf
foreach var in n i o {
	estimates restore modelo2_`var'
	coefplot, drop(_cons) xline(0) xtitle("Coeficientes de regresión")
	graph export "output/figure-plot-modelo2_`var'.jpg"
}


** 2.3 Hipotesis
foreach var in n i o {
	estimates restore modelo2_`var'
	. test (_b[ln_ngdelta] + _b[ln_sk] + _b[ln_sh] = 0)
	}

	
// Pregunta 3 ------------------------------------------------------------------

** 3.1  Convergencia incondicional
foreach var in n i o {
	regress ln_yl85_60 ln_yl60 if `var' == 1
	estimates store modelo3_1_`var'
	}

*** Grafico: se puede hacer avplot, scatter pero optamos por forest plot pues nos permite ver tamaño efecto y signifcancia
foreach var in n i o {
	estimates restore modelo3_1_`var'
	coefplot, drop(_cons) xline(0) xtitle("Coeficientes de regresión")
	graph export "output/figure-plot-modelo3_`var'.jpg"
}
	
			
** 3.2 Convergencia condicional
foreach var in n i o {
	regress ln_yl85_60 ln_yl60 ln_ngdelta ln_sk ln_sh if `var' == 1
	estimates store modelo3_2_`var'
	}
			
** 3.3  Convergencia condicional con interaccion ln_sk y ln_sh
foreach var in n i o {
	regress ln_yl85_60 ln_yl60 ln_ngdelta ln_sk ln_sh c.ln_sk##c.ln_sh if `var' == 1
	estimates store modelo3_3_`var'
	}

** Recordar que en interacciones hay que poner la c. para continuas (en categoricas no)
	
***Interpretacion: ver si coeficiente es positivo y estadisticamente significativo	

**3.4 Heterocedasticidad

*** 3.4.1 Test White
* Si quiero Breush Pagan: estat hettest
foreach var in n i o {
	estimates restore modelo3_3_`var'
	estat imtest, white
	}

**Version LM
* Paso 1: Estimar regresion (ya realizado en punto 3.3)
* Paso 2: Guardar u_hat (residuos) 
* Paso 3: Generar residuos al cuadrado
* Paso 4: Predecir y_hat (valores predichos)
* Paso 5: Generar y_hat^2  (valores predichos al cuadrado)
* Paso 6: regresar u_hat^2 ~ y_hat + y_hat^2
* Paso 7: Store regresiones
* Paso 8: tabla	
foreach var in n i o {
	estimates restore modelo3_3_`var'
	predict u_hat`var', residuals
	gen u_hat_sq`var' = u_hat`var'*u_hat`var'
	predict y_hat`var'
	gen y_hat_sq`var' = y_hat`var'*y_hat`var'
	regress u_hat_sq`var' y_hat`var' y_hat_sq`var'
	estimates store modelo3_3lm_`var'
	}

*** 3.4.2 Pasos estimacion robusta
foreach var in n i o {
	regress ln_yl85_60 ln_yl60 ln_ngdelta ln_sk ln_sh c.ln_sk##c.ln_sh if `var' == 1, robust
	estimates store modelo3_3robust_`var'
	}

** 3.5 Grafico con regresion robusta
*** Especificacion - variable x es la de interaccion
foreach var in n i o {
	estimates restore modelo3_3robust_`var'
	avplot c.ln_sk##c.ln_sh
	graph export "output/figure-plot-modelo3_3robust_`var'.jpg"
}

*Nota: seguro que avplot??*

*Adicionales ?
foreach var in n i o {
	estimates restore modelo3_3robust_`var'
	rvpplot c.ln_sk##c.ln_sh, recast(scatter)
	graph export "output/figure-plot-modelo3_3robust_residual_`var'.jpg"
}

** Interactions not allowed


// Apendice	
//I ----Tablas

	*Tablas:
foreach var in 1 2 3_1 3_2 3_3 3_3robust {
	outreg2 [ modelo`var'_n modelo`var'_i modelo`var'_o ]  ///
	using "output/tab/tabla1_`var'.tex", ///
	label /*Las variables del modelo aparecen con etiquetas*/   ///
	tex(frag) /*Permite ingresar directamente el archivo generado al tex*/  ///
	dec(3) /*Agrega 3 decimales*/ ///
	adj  /*agrega el r2 ajustado*/  ///
	bracket /*Genera paréntesis de corchetes*/  ///
	stats(coef tstat ) /*Nos muestra los betas y los estadígrafos t*/   ///
	addtext("Note: Run on $S_DATE, using data from $S_FN") /*Produce el texto en la tabla*/  ///
	replace
	}

	*Tablas excel
foreach var in 1 2 3_1 3_2 3_3 3_3robust {
	outreg2 [ modelo`var'_n modelo`var'_i modelo`var'_o ]  ///
	using "output/tab/tabla1_`var'.xls", ///
	label /*Las variables del modelo aparecen con etiquetas*/   ///
	tex(frag) /*Permite ingresar directamente el archivo generado al tex*/  ///
	dec(3) /*Agrega 3 decimales*/ ///
	adj  /*agrega el r2 ajustado*/  ///
	bracket /*Genera paréntesis de corchetes*/  ///
	stats(coef tstat ) /*Nos muestra los betas y los estadígrafos t*/   ///
	addtext("Note: Run on $S_DATE using data from $S_FN") /*Produce el texto en la tabla*/  ///
	replace
	}

	

log close







