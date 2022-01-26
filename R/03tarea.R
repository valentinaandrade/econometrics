# Tarea 3 -----------------------------------------------------------------
## Codigo: Valentina Andrade

## Efecto de instituciones en crecimiento economico (colonial)
# 1. Cargar paquetes ------------------------------------------------------
pacman::p_load(googledrive, performance, tidyverse, ggthemes,
               sjPlot, sjmisc, summarytools, xtable,
               sandwich,lmtest)
theme_set(theme_economist()
          #+ scale_colour_economist(stata=TRUE)
)

# 2. Load data ------------------------------------------------------------
drive_download("https://drive.google.com/file/d/1zhgYEFyxJNqBFEoXyMRNRpp3WacYt7r-/view?usp=sharing", path = "input/base_tarea3_colonial.dta")
data <- haven::read_dta("input/base_tarea3_colonial.dta")

# 3. Explore data ---------------------------------------------------------
names(data)

country <- as.data.frame(countrycode::codelist_panel)
country <- country %>% filter(year == 1995) %>% 
  select(countryname = country.name.en, continent, country = iso3c) %>% 
  mutate_at(vars(countryname, continent,country),funs(as.character(.)))

haven::write_dta(country, "countrycodes.dta")

data_country <- merge(data, country, by = "country", all.x = T)

data_country %>%
  mutate(continent = if_else(is.na(continent)& country== "ROM", "Europe",
                             if_else(is.na(continent)& country == "ZAR", "Africa", continent)))

haven::write_dta(data_country, "report3/input/country-codes.dta")

# Labels ------------------------------------------------------------------
drive_download("https://drive.google.com/file/d/1Z-V4D6t6Qnd3wJanap0wWPApHpFKaKxM/view?usp=sharing", path = "input/base_tarea3_labels.dta")
data2 <- haven::read_dta("input/base_tarea3_labels.dta")

data2 <- data2 %>% 
  mutate(post = if_else(year > 2016, "Despues", "Antes"),
         trat = if_else(azucar > 22.5, "Con sello", "Sin sello"))

# Descriptivos ------------------------------------------------------------
summarytools::dfSummary((data2 %>% group_by(trat,post) %>% dplyr::select(.,starts_with("ln"), azucar)), 
                        varnumbers = F, valid.col =  F, na.col = F, freqs.pct.valid = F, headings = F,
                        graph.magnif = 1.5, style = "grid", 
                        silent = T,
                        plain.ascii = F)

summarytools::dfSummary((data2 %>% dplyr::select(.,trat, post, starts_with("ln"), azucar)), 
                        varnumbers = F, valid.col =  F, na.col = F, freqs.pct.valid = F, headings = F,
                        graph.magnif = 1.5, style = "grid", 
                        silent = T,
                        plain.ascii = F)

## Calculos




data2 %>% 
  group_by(trat, post) %>% 
  summarise(promedio = mean(lnconsumo),
            n = n()) %>% 
  arrange(trat)
