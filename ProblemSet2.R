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
if("fixest" %in% rownames(installed.packages()) == FALSE) {install.packages("fixest",repos="http://cran.r-project.org")}
try(suppressPackageStartupMessages(library(fixest,quietly = TRUE,warn.conflicts = FALSE)),silent = TRUE)
if("maxLik" %in% rownames(installed.packages()) == FALSE) {install.packages("maxLik",repos="http://cran.r-project.org")}
try(suppressPackageStartupMessages(library(maxLik,quietly = TRUE,warn.conflicts = FALSE)),silent = TRUE)
install.packages("lfe")
library(lfe)

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
     select(market, schoolid, outside, price, quality, rural, laica, pub, jec, v_u, porc_zona,
            share_prio, s_t, s_0, y_inv) %>% filter(outside == 0)

#

# 1.2 MultiLinear Logit OLS estimation:

reg_ols <- lm(y_inv ~ price + quality + rural + laica + pub + jec, data = datos_agg)


summary(reg_ols)

# 2SLS:

# a)
reg_iv_1 <- feols(y_inv ~ rural + pub + jec + laica | price + quality ~ v_u + porc_zona + share_prio,
                  datos_agg, se = "hetero")

summary(reg_iv_1)

summary(reg_iv_1, stage = 1)

# b)
datos_iv <- datos_agg %>% group_by(market) %>% mutate(agg_rural = sum(rural), agg_pub = sum(pub),
                                                       agg_laica = sum(laica), agg_jec = sum(jec)) %>%
     ungroup() %>% mutate(sum_rural = agg_rural - rural, sum_pub = agg_pub - pub, sum_laica = agg_laica - laica,
                          sum_jec = agg_jec - jec)

reg_iv_2 <- feols(y_inv ~ rural + pub + jec + laica | price + quality ~ sum_rural + sum_pub 
                  + sum_laica + sum_jec, datos_iv, se = "hetero")

summary(reg_iv_2)

summary(reg_iv_2, stage = 1)

# c)
datos_iv <- datos_iv %>% group_by(market) %>% mutate(n_comp = n()-1) %>% ungroup() %>% 
     mutate(avg_rural = sum_rural/n_comp, avg_laica = sum_laica/n_comp, avg_pub = sum_pub/n_comp,
            avg_jec = sum_jec/n_comp)

reg_iv_3 <- feols(y_inv ~ rural + pub + jec + laica | price + quality ~ avg_rural + avg_pub 
                  + avg_laica + avg_jec, datos_iv, se = "hetero")

summary(reg_iv_3)

summary(reg_iv_3, stage = 1)

# d)
reg_iv_4 <- feols(y_inv ~ rural + pub + jec + laica | price + quality ~ sum_rural + sum_pub 
                  + sum_laica + sum_jec + v_u + porc_zona + share_prio, datos_iv, se = "hetero")

summary(reg_iv_4)

summary(reg_iv_4, stage = 1)

# e)
reg_iv_5 <- feols(y_inv ~ rural + pub + jec + laica | price + quality ~ avg_rural + avg_pub 
                  + avg_laica + avg_jec + v_u + porc_zona + share_prio, datos_iv, se = "hetero")

summary(reg_iv_5)

summary(reg_iv_5, stage = 1)

# Stargazer table for LaTeX

stargazer(reg_ols, title = "OLS Estimation",
          dep.var.labels=c("log(st) - log(s0)"), 
          out="tabla1reg.tex")

etable(reg_iv_1, reg_iv_2, reg_iv_3, reg_iv_4, reg_iv_5, tex = T)



# 10: IF OUR MATLAB CODE DOESN´T RUN


