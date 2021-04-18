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

# Constructing market shares (#students in a certain school j in market t/tota students living in t):
# We must consider the students that decide for the outside option

choice <- datos %>% filter(choice == 1) %>% add_count(market) %>% rename(M_t = n) %>%
     add_count(schoolid) %>% rename(n_schools = n) %>% mutate(s_t = n_schools/M_t)

# We obtain the market share for students that prefer the outside option

outsiders <- choice %>% filter(outside == 1) %>% distinct(market, .keep_all = T)
s_01 <- outsiders[1,"s_t"]
s_02 <- outsiders[2,"s_t"]
s_03 <- outsiders[3,"s_t"]
s_04 <- outsiders[4,"s_t"]
s_05 <- outsiders[5,"s_t"]

choice <- choice %>% mutate(s_0 = case_when(market == 1 ~ s_01, market == 2 ~ s_02, 
                                      market == 3 ~ s_03, market == 4 ~ s_04,
                                      market == 5 ~ s_05)) %>% 
     mutate(y_inv = log(s_t) - log(s_0))

# Aggregating data:

datos_agg <- choice %>% distinct(schoolid, .keep_all = T) %>% 
     select(market, schoolid, outside, price, quality, rural, laica, pub, v_u, porc_zona,
            share_prio, s_t, s_0, y_inv) %>% filter(outside == 0)



# 1.2 MultiLinear Logit OLS estimation:

reg_ols <- glm(data = datos_agg, y_inv ~ price + quality + rural + laica + pub, 
                    family = multinomial(link = "logit"))


summary(reg_ols)
stargazer(reg_ols)

# 2SLS:


