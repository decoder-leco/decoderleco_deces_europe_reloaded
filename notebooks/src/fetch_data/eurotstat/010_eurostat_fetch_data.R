# Attacher les Packages contenus dans les Library pour définir les namespaces
# >>> JB # library(maptools)
# >>> JB # library(rgdal)
# >>> JB # library(tidyr)
# >>> JB # library(maps)
# library(eurostat)
library(dplyr)
# >>> JB # library(stringr)
# >>> JB # library(leaflet)
# >>> JB # library(questionr)
# >>> JB # library(ggplot2)
# >>> JB # library(lubridate)
# >>> JB # library(sf)
# >>> JB # library(rnaturalearth)
# >>> JB # library(rgeos)
# >>> JB # library(rnaturalearthdata)
# >>> JB # library(readr)
# >>> JB # library(lsr)
# >>> JB # library(reshape2)
# >>> JB # library(purrr)

##-----------------------------------
# 
##---------------------------------
source("../libs/files/files.R")

##----------------------------------------------------------------------------##
#
##### Preparer les espaces de generation de donnees ####
#
##----------------------------------------------------------------------------##

# Créer les repertoires
if (!dir.exists("gen/csv")) dir.create("gen/csv")

if (!dir.exists("gen/images")) dir.create("gen/images")

if (!dir.exists("gen/rds")) dir.create("gen/rds")

##
# 
##>>>>>>>>>>>>>>>>>>
#>>>>>>
# - Fonctions: 
#    [a__f_downloadEuroStatIfNeeded] -> [./src/files/files.R]
#    [a__f_downloadEuroStatIfNeeded] -> [./src/files/files.R]
#    [a__f_downloadEuroStatIfNeeded] -> [./src/files/files.R]
#    [a__f_downloadEuroStatIfNeeded] -> [./src/files/files.R] 
##--------------------------------------------
##----------------------------------------------------------------------------##
#
#### recuperer les tables qui nous interessent chez EuroStat ####
#
##----------------------------------------------------------------------------##

# Demographie recensée au 1er janvier de chaque année (jusqu'en 2020 inclus)
# time = année du recensement, 
# age = tranche d'âge, 
# values = population dans cette tranche d'âge à la date time
a__original_es_pjan_le2020 <- a__f_downloadEuroStatIfNeeded(var = a__original_es_pjan_le2020, 
                                                            euroStatFileName = "demo_pjan")


# Décès recensés au 1er janvier de chaque année (jusqu'en 2020 inclus)
# time = année du recensement, 
# age = tranche d'âge des décès, 
# values = population dans cette tranche d'âge à être décédée
a__original_es_deces_annuel_le2020 <- a__f_downloadEuroStatIfNeeded(var = a__original_es_deces_annuel_le2020, 

                                                             euroStatFileName = "demo_magec")
# >>> JB: [everything], [arrange] and [select] functions are from the [dplyr] package https://cran.r-project.org/web/packages/dplyr/dplyr.pdf
# Décès par semaine (jusqu'en 2021 inclus)
# time = année du recensement, 
# age = tranche d'âge des décès, 
# sex
# values = population dans cette tranche d'âge à être décédée
a__original_es_deces_week <- a__f_downloadEuroStatIfNeeded(var = a__original_es_deces_week, 
                                                           euroStatFileName = "demo_r_mwk_05") %>%
  # Trier les lignes
  arrange(geo, sex, time, age) %>%
  # Reorganiser les colonnes
  select(geo, sex, time, age, everything())

# Projections de population depuis 2019
# à télécharger manuellement car l'API ne fonctionne pas
# sert à récupérer les populations 2022 et 2023

# >>> JB: [read.csv] is a native R function, see https://www.learn-r.org/r-tutorial/read-csv.php
# >>> JB: [rename], [mutate], [filter] and [select] functions are from the [dplyr] package https://cran.r-project.org/web/packages/dplyr/dplyr.pdf
# >>> JB: [as.Date] is a native R function https://www.rdocumentation.org/packages/base/versions/3.6.2/topics/as.Date
# >>> JB: [paste0] is a native R function https://rc2e.com/stringsanddates
a__original_es_proj <- read.csv("data/csv/proj_19np__custom_2224172_linear.csv") %>% 
  select(-DATAFLOW,-LAST.UPDATE,-freq,-unit,-OBS_FLAG) %>% 
  filter(sex != "T", 
         age != "TOTAL",
         projection =="BSL") %>%
  dplyr::rename(time = TIME_PERIOD,
                population_proj = OBS_VALUE) %>% 
  mutate(time = as.Date(paste0(time,"-01-01")),
         age = ifelse(age=="Y_GE100","Y_OPEN",age))
