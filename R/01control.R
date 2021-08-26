# Codigo Control 1 --------------------------------------------------------
# Caso 1: mean and sd known ------------------------------------------------------

# 1. Valores criticos (qnorm) --------------------------------------------------------
# Usage: Critical Value = qnorm(area to the left)

# – Left-Tailed Tests: zα = qnorm(α)
qnorm(0.05)

# – Right-Tailed Tests: zα = qnorm(1 −α)
qnorm(1 - 0.05)

# – Two-Tailed Tests: zα/2 = ±qnorm(1 −α/2
qnorm(1 - (0.01)/2)


# 2. Parameters -----------------------------------------------------------

tx <- (x - mu)/((sigma)^2/n^(1/2))
tx


# Caso 1: distribucion y desviacion conocida -------------------------------


# Caso 3: Fdp no conocida -------------------------------------------------


# 3. Valores p ---------------------------------------------------------------
# Finding P-values with the pnorm function.
# Usage: P-value = pnorm(z, lower.tail = ).

# – Left-Tailed Tests: P-value = pnorm(z, lower.tail=TRUE)
pnorm(tx, lower.tail=TRUE)

# – Right-Tailed Tests: P-value = pnorm(z, lower.tail=FALSE)

# – Two-Tailed Tests: P-value = 2 * pnorm( abs(z), lower.tail=FALSE)
2*pnorm(abs(tx), lower.tail = FALSE)




# Caso 2: mean and unknown sigma2 (T-TEST) -----------------------------------------
### Info ####
n = 8
x = mean(var)
mu = 83
sx = sd(var)
α = 0.1

# 1. Finding Critical Values: Here we use the qt function.
tx = (x - mu)/(sx/sqrt(n))
tx
# Usage: Critical Value = qt(area to the left)
# – Left-Tailed Tests:tα = qt(α)
tα = qt(α, n-1)
tα
# – Right-Tailed Tests: tα = qt(1 −α)
qt(α, n-1, lower.tail = F)
# – Two-Tailed Tests: tα/2 = ±qt(1 −α/2)
qt(α/2, n-1, lower.tail = F)

# Finding P-Values Here we use the pt function.
# Usage: P-value = pt(t ̄x, df = , lower.tail = ).
# – Left-Tailed Tests: P-value = pt(t ̄x, df = n-1, lower.tail=TRUE)
pt(tx, df = n-1, lower.tail=TRUE)
# – Right-Tailed Tests: P-value = pt(t ̄x, df = n-1, lower.tail=FALSE)
pt(tx, df = n-1, lower.tail=F)
# – Two-Tailed Tests: P-value = 2 * pt( abs(t ̄x), df = n-1, lower.tail=FALSE)
2*pt(tx, df = n-1, lower.tail=F)


# Intervals ---------------------------------------------------------------
# 0. Datos
mu = 90
n = 8
x = mean(var)
sx = sd(var)
α = 0.01


# 2. Obtener Z o t --------------------------------------------------------

# Caso 1 y 3 (z)
# – Left-Tailed Tests: zα = qnorm(α)
qnorm(α)

# – Right-Tailed Tests: zα = qnorm(1 −α)
qnorm(1 - α)

# – Two-Tailed Tests: zα/2 = ±qnorm(1 −α/2
tz <- qnorm(1 - (α)/2)


# Caso 2 --------------------------------------------------------------------
# – Left-Tailed Tests:tα = qt(α)
qt(α, n-1)

# – Right-Tailed Tests: tα = qt(1 −α)
qt(α, n-1, lower.tail = F)

# – Two-Tailed Tests: tα/2 = ±qt(1 −α/2)
tc = qt(α/2, n-1, lower.tail = F)
tc

# Construct confidence interval -------------------------------------------
(tc * (sx/sqrt(n)))

lower <- x - (tc * (sx/sqrt(n)))
upper <- x + (tc * (sx/sqrt(n)))

print(c(lower,x, upper))


## Reportar
print(c(x, "+/-", (tc * (sx/sqrt(n))) ))
# y ver mu

# If I hace the data ------------------------------------------------------
var <- c(78,54,37,86,74,75,68,81)
mean(var)
sd(var)
n = 8
x = mean(var)
mu = 90
sx = sd(var)
α = 0.01

#test 
qt(α/2, n-1, lower.tail = F)
t.test(var, mu = mu,  alternative = "two.sided", conf.level = 0.99)
