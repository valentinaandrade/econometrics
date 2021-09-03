# Codigo Control 1 --------------------------------------------------------
# Caso 1: mean and sd known ------------------------------------------------------
n = 400
x = 0.5375
mu = 0.5
sx = 1
α = 0.05


# 1. Valores criticos -----------------------------------------------------

tx = (x - mu)/(sx/sqrt(n))
tx

# 2. Valores teoricos (qnorm) --------------------------------------------------------
# Usage: Critical Value = qnorm(area to the left)

# – Left-Tailed Tests: zα = qnorm(α)
qnorm(α)

# – Right-Tailed Tests: zα = qnorm(1 −α)
qnorm(1 - α)

# – Two-Tailed Tests: zα/2 = ±qnorm(1 −α/2
qnorm(1 - (α)/2)


# 3. Valores p ---------------------------------------------------------------
# Finding P-values with the pnorm function.
# Usage: P-value = pnorm(z, lower.tail = ).

# – Left-Tailed Tests: P-value = pnorm(z, lower.tail=TRUE)
pnorm(tx, lower.tail=TRUE)

# – Right-Tailed Tests: P-value = pnorm(z, lower.tail=FALSE)
pnorm(tx, lower.tail=F)

# – Two-Tailed Tests: P-value = 2 * pnorm( abs(z), lower.tail=FALSE)
2*pnorm(abs(tx), lower.tail = FALSE)


# Caso 2: mean and unknown sigma2 (T-TEST) -----------------------------------------
## 0. Datos ----------------------------------------------------------
n = 100
x = 0.17
mu = 0.1
sx = 0.6
α = 0.05

# 1. Finding Critical Values: Here we use the qt function.---------------
tx = (x - mu)/(sx/sqrt(n))
tx
# Usage: Critical Value = qt(area to the left)
# – Left-Tailed Tests:tα = qt(α)
tα = qt(α, n-1)
tα
# – Right-Tailed Tests: tα = qt(1 −α)
qt(α, n-1, lower.tail = F)
# – Two-Tailed Tests: tα/2 = ±qt(1 −α/2)
qt(0.05/2, n-1, lower.tail = F)

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
mu = 100
n = 20
x = 84
sx = 25
α = 0.05

# If I hace the data ------------------------------------------------------
var <- c(38, -15, 3, -14, 4, -4, 13, 34)
mean(var)
sd(var)
n = 8
x = mean(var)
mu = 4
#Var
sx = 16
s2 = var(var)
sx=sqrt(s2)
#Sig
α = 0.05


# 2. Obtener Z o t --------------------------------------------------------
# Caso 1 y 3 (z)
# – Left-Tailed Tests: zα = qnorm(α)
qnorm(α)

# – Right-Tailed Tests: zα = qnorm(1 −α)
tz <- qnorm(1 - α)

# – Two-Tailed Tests: zα/2 = ±qnorm(1 −α/2
tz <- qnorm(1 - (α)/2)
tz

# Construct confidence interval -------------------------------------------
(tz * (sx/sqrt(n)))

lower <- x - (tz * (sx/sqrt(n)))
upper <- x + (tz * (sx/sqrt(n)))

print(c(lower,x, upper))


## Reportar
print(c(x, "+/-", (tz * (sx/sqrt(n))) ))


# Caso 2 --------------------------------------------------------------------
# – Left-Tailed Tests:tα = qt(α)
qt(α, n-1)

# – Right-Tailed Tests: tα = qt(1 −α)
tc = qt(α, n-1, lower.tail = F)
tc
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
var <- c(3.8, -15, 3, -14, 4, -4, 13, 34)
mean(var)
sd(var)
n = 12
x = mean(var)
mu = 4
sx = sd(var)
α = 0.05

#test 
qt(α/2, n-1, lower.tail = F)
t.test(var, mu = mu,  alternative = "two.sided", conf.level = 0.99)

t.test(var, mu = mu,  alternative = "greater", conf.level = 0.95)

#ztest 
qt(α/2, n-1, lower.tail = F)
t.test(var, mu = mu,  alternative = "two.sided", conf.level = 0.99)

t.test(var, mu = mu,  alternative = "greater", conf.level = 0.95)
