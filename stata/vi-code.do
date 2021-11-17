//Simulacion Variables instrumentales
// Valentina Andrade 
// Econometria - PUC
clear all

// a.  Crear objetos
set obs 10000
set seed 123

// b. Instrumento ideal (Z)
matrix C = (1,0 \ 0,1)
mat list C

// Generar variable z y u (matriz varianza y covarianza)
corr2data z u, corr(C)
corr z u
sum z u

** Veremos que se cumplen criterios ideales de instrumento (exogeneidad y relevancia)
** cor2data hace medias cero y covarianza 1

// Variable omitida x2
gen x2 = rnormal()

// Instrumento fuerte (x1 pues está 4 veces z)
*** Le agregamos perturbacion normal y correlacion con x2

gen x1 = 4*z + rnormal() + x2 
gen y  = 2*x1 + 3*x2 + u

// d. Regresiones
** d.1 Modelo real
reg y x1 x2

** d.2 Modelo con varible omitida
reg y x1

// e. Instrumento
*** Veremos el cumplimiento de propiedades

** e.1 Exclusion
***(esto no se puede en la realidad pues no tengo u. En este caso si)

reg u z 

** e.2 Relevancia
reg x1 z

// f. Variables instrumentales

ivreg y (x1 = z), first // Relevancia instrumento


// g. MCO vs IV
**MCO 
reg y x1 x2
estimates store mco_true
reg y x1
estimates store mco_endogena

** IV
ivreg y (x1=z), first
estimates store vi

** Tabla
esttab mco_true mco_endogena vi using "output/simulacion_vi.csv", ///
compress nogaps noline pr2 se star(* 0.1 ** 0.05 ***0.01) b(3) se(3) replace  