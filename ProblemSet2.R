# Problem Set 2
# GitHub collaboration: Armando Apellaniz, Eduardo Zago, Fernando Stein


# 0.0 Load packages

if("dplyr" %in% rownames(installed.packages()) == FALSE) {install.packages("dplyr",repos="http://cran.r-project.org")}
try(suppressPackageStartupMessages(library(dplyr,quietly = TRUE,warn.conflicts = FALSE)),silent = TRUE)
if("tidyr" %in% rownames(installed.packages()) == FALSE) {install.packages("tidyr",repos="http://cran.r-project.org")}
try(suppressPackageStartupMessages(library(tidyr,quietly = TRUE,warn.conflicts = FALSE)),silent = TRUE)
if("tidyverse" %in% rownames(installed.packages()) == FALSE) {install.packages("tidyverse",repos="http://cran.r-project.org")}
try(suppressPackageStartupMessages(library(tidyverse,quietly = TRUE,warn.conflicts = FALSE)),silent = TRUE)
if("stargazer" %in% rownames(installed.packages()) == FALSE) {install.packages("stargazer",repos="http://cran.r-project.org")}
try(suppressPackageStartupMessages(library(stargazer,quietly = TRUE,warn.conflicts = FALSE)),silent = TRUE)
if("hrbrthemes" %in% rownames(installed.packages()) == FALSE) {install.packages("hrbrthemes",repos="http://cran.r-project.org")}
try(suppressPackageStartupMessages(library(hrbrthemes,quietly = TRUE,warn.conflicts = FALSE)),silent = TRUE)
if("car" %in% rownames(installed.packages()) == FALSE) {install.packages("car",repos="http://cran.r-project.org")}
try(suppressPackageStartupMessages(library(car,quietly = TRUE,warn.conflicts = FALSE)),silent = TRUE)
if("sandwich" %in% rownames(installed.packages()) == FALSE) {install.packages("sandwich",repos="http://cran.r-project.org")}
try(suppressPackageStartupMessages(library(sandwich,quietly = TRUE,warn.conflicts = FALSE)),silent = TRUE)
install.packages("ivreg")
library(ivreg)
# 0.2 Define paths

# Path Zago
path <- "C:/Users/lalo-/OneDrive/Documentos/Semestre 10/Microeconometria Avanzada/Tarea 2/Datos/data_ps2.csv"

# Path Armando 
# path <- ""

# Path Fernando
# path <- ""

# 0.3 Importamos la base de datos

datos <- as.data.frame(read.csv(path, header = T, stringsAsFactors = F))


# 1.0 Aggregate the data at school level. Construct Market Shares

# Constructing market shares (#students in a certain school j in market t/#students total living in T):
# We must consider the students that decide for the outside option
# And since we are not considering the characteristics of the outside option, 
# we can eliminate them. However we must count them for Mt

# We obtain the market share for students that prefer the outside option

outsiders <- datos %>% filter(outside == 1) %>% add_count(market) %>% 
     rename(M_0 = n)

datos <- datos %>% add_count(market) %>% rename(M_t = n) %>% 
     filter(outside == 0)

# Now each student goes to a school inside her market, so

datos <- datos %>% add_count(schoolid) %>% rename(n_students = n) %>% 
     mutate(mktshare = n_students/M_t) %>% mutate(M_0 = case_when(market == 1 ~ 1504,
                                                                  market == 2 ~ 2610,
                                                                  market == 3 ~ 1509,
                                                                  market == 4 ~ 1098,
                                                                  market == 5 ~ 3117)) %>%
     mutate(mktshare_0 = M_0/M_t) %>% mutate(y_inv = log(mktshare) - log(mktshare_0))

# Aggregating data:

datos_agg <- datos %>% distinct(schoolid, .keep_all = T) %>% 
     select(market, schoolid, price, quality, rural, laica, pub, v_u, porc_zona,
            share_prio, mktshare, y_inv)



# 1.2 MultiLinear Logit OLS estimation:

reg_ols <- glm(data = datos, y_inv ~ price + quality + rural + laica + pub, 
                    family = binomial(link = "logit"))


summary(reg_ols)
stargazer(reg_ols)

# 2SLS:


