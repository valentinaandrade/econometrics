//===========================================================================//
// 		Tarea N°1
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
	net install spost13, from("https://jslsoc.sitehost.iu.edu/stata/") replace // Para lincom multiple
	set scheme s2color, permanently 	//Tema de graficos

	
// a. Directorio 		
	global data_row = "C:\Users\Valentina Andrade\Documents\GitHub\master\econometrics"
	global data_prepared "C:\Users\Valentina Andrade\Documents\GitHub\master\econometrics\input"
	global latex = "C:\Users\Valentina Andrade\Documents\GitHub\master\econometrics\ouput"
	cd "C:\Users\Valentina Andrade\Documents\GitHub\master\econometrics"
	

// b. Leer datos
	use "input\base_tarea1",replace

// c. Etiquetar
	* Se hace para las tablas en latex despues
	label var growth "Crecimiento"
	label var country_name "País"
	label var tradeshare "Apertura económica"
	label var yearsschool "Años escolaridad"
	label var rev_coups "Hitos disruptivos"
	label var assasinations "Asesinatos politicos"
	label var rgdp60 "PIB 1960"
	
// Pregunta 1:  Descriptivos

// a. Tabla resumen
	summarize growth tradeshare yearsschool rev_coups assasinations rgdp60

// b. Figuras
	graph twoway histogram growth, density xaxis(1 2) 	subtitle("Distribución de la Tasa de crecimiento") note("Fuente: Elaboración propia en base a datos tarea N°1") ytitle(" ") saving("graph1.png")
	graph export "output/figure01.jpg"
	graph twoway histogram tradeshare, density xaxis(1 2) 	subtitle("Distribución de la apertura económica") note("Fuente: Elaboración propia en base a datos tarea N°1") ytitle(" ")
		graph export "output/figure02.jpg"
	graph twoway histogram growth, density xaxis(1 2) 	subtitle("Distribución de los años de escolaridad") note("Fuente: Elaboración propia en base a datos tarea N°1") ytitle(" ")
		graph export "output/figure03.jpg"

// c. Adicionales
	graph twoway histogram rev_coups, frequency  xaxis(1 2) 	subtitle("Frecuencia de hitos disruptivos") note("Fuente: Elaboración propia en base a datos tarea N°1") ytitle(" ")
		graph export "output/figure04.jpg"
	graph twoway histogram assasinations, frequency  xaxis(1 2) 	subtitle("Frecuencia de asesinatos políticos") note("Fuente: Elaboración propia en base a datos tarea N°1") ytitle(" ")
		graph export "output/figure05.jpg"
	graph twoway histogram rgdp60, density xaxis(1 2) 	subtitle("Distribución PIB en 1960") note("Fuente: Elaboración propia en base a datos tarea N°1") ytitle(" ")
		graph export "output/figure06.jpg"

	
// Pregunta 2: Correlaciones

// a. Tabla de correlaciones
	pwcorr growth tradeshare yearsschool rev_coups assasinations rgdp60, sig
	
	**a.1 Guardar para documento, al final está para latex

	asdoc pwcorr growth tradeshare yearsschool rev_coups assasinations rgdp60, saving("correlation.doc") star(all) replace nonum
	
// Pregunta 3: Scatter plot
	graph twoway (scatter growth tradeshare)(lfitci growth tradeshare) //subtitle("Correlación entre crecimiento y apertura económica") note("Fuente: Elaboración propia en base a datos tarea N°1") ytitle(" ")
		graph export "output/figure1.jpg"
	graph twoway (scatter growth yearsschool)(lfitci growth yearsschool) //subtitle("Correlación entre crecimiento y anos de educacion") note("Fuente: Elaboración propia en base a datos tarea N°1") ytitle(" ")
		graph export "output/figure2.jpg"

// Pregunta 4: Regresiones

** a. Estimacion
	regress growth tradeshare yearsschool rev_coups assasinations rgdp60 //tablas en latex abajo
	estimate store modelo1 //*ocuparlo despues
	estat vce // Para ver su matriz de correlaciones estimada 

** Graficos adicionales	
** a.1 Coeficientes parcializados 
	estimates restore modelo1
	estat summarize //,labels
	avplot  tradeshare
    avplot  yearsschool
	avplot rev_coups
	avplot assasinations
	graph export "output/figure-anexos.jpg"
**a.2 Forestplot
	margins, dydx(*) post
	marginsplot, horizontal xline(0) yscale(reverse) recast(scatter)
*** En base a guia de https://www.stata.com/meeting/germany14/abstracts/materials/de14_jann.pdf
	estimates restore modelo1
	coefplot, drop(_cons) xline(0) xtitle("Coeficientes de regresion")
	graph export "output/figure-plot.jpg"

			
* b. Test ajuste
	test tradeshare yearsschool rev_coups assasinations rgdp60 //  Con esto se compara F y R cuadrado.

** b.1 Graficos diagnostico (en apendice B en informe)
	rvfplot, yline(0)
	qnorm growth
	pnorm tradeshare
	pnorm yearsschool
// No tienen distribucion normal
	pnorm rev_coups 
	pnorm assasinations

//  Pregunta  5: Propiedades
// 5.1 Suma de residuos
	predict e, r

// 5.2 Ortogonalidad
/// Calculamos la suma de residuos condicional a cada predictor

** Residuos tradeshare
	reg tradeshare growth
	predict u_tradeshare, r

** Residuos yearsschool
	reg yearsschool growth
	predict u_yearsschool, r

** Residuos rev_coups
	reg rev_coups growth
	predict u_rev_coups, r

<** Residuos assasinations
	reg assasinations growth
	predict u_assasinations, r
	
** Residuos rgp60
	reg rgdp60 growth
	predict u_rgdp60, r

** Suma de residuos: es cero
	sum u_assasinations
	sum u_rev_coups
	sum u_rgdp60
	sum u_tradeshare
	sum u_yearsschool

** Esperanza condicional residuos y variables explicativas
	egen mean_residuos = mean(u_tradeshare)
	display mean_residuos

** Otra forma: correlacion residuos y predictores (vemos que var y e tienen correlacion 0)
estimates restore modelo1
foreach var in tradeshare yearsschool rev_coups assasinations rgdp60{
	correlate u_`var' `var' e
	}
	
	
**5.3 Coincidencia var dependiente predicha y observada**
predict mean_hatgrowth, xb
display mean_hatgrowth //1.869
** Tambien se puede con margins, asbalanced (asbalanced se ocupa encuestas sobre todo)


egen mean_growth= mean(growth)
display mean_growth // iguales

	
**5.4  R cuadrado es igual al coeficiente de correlacion \hat{y} e y 
// Sabemos por la tabla de regresion que R^2 es 0.2911
estimates restore modelo1
predict yhat
correlate yhat growth
display 0.5396^2 


/// Adicionales
** Heterocedasticidad**
	estat hettest

// Pregunta 6: Predicciones - graphs
**a. Graficos
	estimates restore modelo1
	predict pred
	twoway lfitci growth tradeshare
	graph export "output/figure5.jpg"
	twoway lfitci growth yearsschool
	graph export "output/figure6.jpg"


// Pregunta 7: F a partir de R^2 
//F= \frac{rsq/5}{1-rsq/(64-5-1)} = 4.763
// e(r2) nos da el r cuadrado

display (e(r2)/5)/((1-e(r2))/(64-5-1))
	
// Pregunta 8: Predicciones
	
**b. Intervalo predicciones
	estat summarize //** Para mirar media de variables

// Existen distintas formas de calcular intervalos. Mostraremos las tres, pero finalmente nos quedaremos con margins al ser mas parsimonioso
	
** b.1 Con las medias de variables
	summarize
	adjust tradeshare = 0.5423919 yearsschool =  3.959219 rev_coups = .1700666 assasinations = .281901 rgdp60 =  3.130813

	**Forma opcional que da estimador puntual e intervalo**
	margins
	predict pred1, xb
 	
*** b.2 Medias variables y tradeshare +2sd
	summarize // me permite saber mean y sd de tradeshare
	gen mean_2sd_tradeshare = .5423919 + 2*.2283326
	display mean_2sd_tradeshare
	adjust tradeshare = .99905711 yearsschool =  3.959219 rev_coups = .1700666 assasinations = .281901 rgdp60 =  3.130813

	**Forma opcional que da estimador puntual e intervalo**
	margins, at(tradeshare=(.99905711))
	
*** b.3 Combinacion lineal
//mlincom	- nueva forma de comparar margins multiples

	**Primero, estimamos las dos predicciones
	margins, at(tradeshare=(.99905711)) at(tradeshare=.5423919) atmeans post
	** Segundo con mlincom indicamos cuales predicciones son las que deben ser comparadas (en este caso solo tenemos dos)
	mlincom 2-1 // El valor p nos indica si estas son estadisticamente distintas

// Pregunta 9. Estimación del cambio en el crecimiento en base a cambio educativo
	estimate restore modelo1
	margins, at(yearsschool=4) at(yearsschool = 6) atmeans post
	
// Pregunta 10. Significancia conjunta
**a. Estimar F con test
	estimate restore modelo1
	test tradeshare rev_coups assasinations

**b. Comprobar con la suma de residuos
	** Primero, creamos un modelo2
	regress growth yearsschool rgdp60
	estimate store modelo2 //*ocuparlo despues
	estimates replay modelo1 //volver a ver resultados modelo1

// Apendice	
//I ----Tablas

	*TABLA 1:
	outreg2 [ modelo1 ]  ///
	using "$latex\tabla1.tex" ///
	,label /*Las variables del modelo aparecen con etiquetas*/   ///
	tex(frag) /*Permite ingresar direstamente el archivo generado al tex*/  ///
	dec(3) /*Agrega 3 decimales*/ ///
	 adj  /*agrega el r2 ajustado*/  ///
	replace  ///


	*TABLA 2:
	outreg2 [ modelo1]  ///
	using "$latex\tabla2.tex" ///
	,label /*Las variables del modelo aparecen con etiquetas*/   ///
	tex(frag) /*Permite ingresar direstamente el archivo generado al tex*/  ///
	dec(3) /*Agrega 3 decimales*/ ///
	 adj  /*agrega el r2 ajustado*/  ///
	bracket  /*Genera paréntesis de corchetes*/  ///
	stats(coef tstat ) /*Nos muestra los betas y los estadígrafos t*/   ///
	  replace  ///
	drop(growth) 


	*TABLA 3:
	outreg2 [ modelo1]  ///
	using "$latex\tabla3.tex" ///
	,label /*Las variables del modelo aparecen con etiquetas*/   ///
	tex(frag) /*Permite ingresar direstamente el archivo generado al tex*/  ///
	dec(3) /*Agrega 3 decimales*/ ///
	adj  /*agrega el r2 ajustado*/  ///
	bracket  /*Genera paréntesis de corchetes*/  ///
	stats(coef tstat ) /*Nos muestra los betas y los estadígrafos t*/   ///
	replace  ///
	drop(growth extro_z agree_z cons_z neuro_z open_z  ) ///
	addtext(Personality Traits, YES)



	*TABLA 4:
	outreg2 [ modelo1]  ///
	using "$latex\tabla4.tex" ///
	,label /*Las variables del modelo aparecen con etiquetas*/   ///
	tex(frag) /*Permite ingresar direstamente el archivo generado al tex*/  ///
	dec(3) /*Agrega 3 decimales*/ ///
	adj  /*agrega el r2 ajustado*/  ///
	bracket  /*Genera paréntesis de corchetes*/  ///
	stats(coef tstat ) /*Nos muestra los betas y los estadígrafos t*/   ///
	replace  ///
	drop(s_vida extro_z agree_z cons_z neuro_z open_z  ) ///
	addtext(Personality Traits, YES) /*Produce el texto en la tabla*/  ///
	groupvar(  "\textbf{Individuo}"  ing09 edad09 edad09x2  esc09 esc09x2 naver09 /// 
	"\textbf{Hogar}" hijosh jhogar09 ) 

	
// Figuras adicionales

**Figuras residuos y predictores
	rvpplot tradeshare, recast(scatter)
	rvpplot yearsschool, recast(scatter)
	rvpplot rev_coups, recast(scatter)
	rvpplot assasinations, recast(scatter)
	rvpplot rgdp60, recast(scatter)
log close







