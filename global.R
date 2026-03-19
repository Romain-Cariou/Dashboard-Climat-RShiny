# ==============================================================================
# INSTALLATION AUTOMATIQUE DES PACKAGES MANQUANTS
# ==============================================================================

packages_necessaires <- c(
  "shiny", "plotly", "dplyr", "tidyr", "ggplot2",
  "DT", "leaflet", "sf", "rnaturalearth", "rnaturalearthdata"
)

packages_manquants <- packages_necessaires[!sapply(packages_necessaires, requireNamespace, quietly = TRUE)]

if (length(packages_manquants) > 0) {
  install.packages(packages_manquants)
}

# ==============================================================================
# PACKAGES
# ==============================================================================

library(shiny)
library(plotly)
library(dplyr)
library(tidyr)
library(ggplot2)
library(DT)
library(leaflet)
library(sf)

if (!requireNamespace("rnaturalearthdata", quietly = TRUE)) {
  install.packages("rnaturalearthdata")
} # forcer installation sinon le deploiement marche pas

library(rnaturalearth)


# ==============================================================================
# DONNEES CO2
# ==============================================================================

data_co2 <- read.csv("data/CO2.csv", sep = ";", check.names = FALSE, stringsAsFactors = FALSE)

df_pollution <- read.csv("data/Pollution.csv") %>%
  filter(Year == 2019) %>%
  filter(!grepl("\\(UN\\)|\\(WHO\\)", Entity))
colnames(df_pollution)[4] <- "concentrations_particules_dans_air"

top5_pm25 <- df_pollution %>%
  arrange(desc(concentrations_particules_dans_air)) %>%
  slice_head(n = 5)
top5_pm25 <- top5_pm25[c(1,4)]
top5_pm25 <- top5_pm25 %>% rename("Pollution (ppm)" = "concentrations_particules_dans_air" )
top5_pm25 <- top5_pm25 %>% rename("Pays" = "Entity" )

top5_pm25$`Pollution (ppm)` <- round(top5_pm25$`Pollution (ppm)`, 1)


data_prod_energie <- read.csv("data/Production_energie.csv") %>%
  select(-Entity, -Code) %>%
  pivot_longer(-Year, names_to = "Source", values_to = "Production") %>%
  mutate(Production = replace_na(Production, 0))

# Pré-calcul de l'animation énergie (fait une seule fois au démarrage)
annees <- sort(unique(data_prod_energie$Year))
df_cum <- bind_rows(lapply(annees, function(yr) {
  data_prod_energie %>% filter(Year <= yr) %>% mutate(frame = yr)
}))

data_temp <- read.csv("data/Temperature.csv")
colnames(data_temp)[3] <- "temp_val"
data_temp <- data_temp %>%
  group_by(Year) %>%
  summarise(anomalie = mean(temp_val, na.rm = TRUE))


# ==============================================================================
# DONNEES OCEANS
# ==============================================================================

data_ocean <- read.csv("data/niveau_ocean.csv", sep = ",", check.names = FALSE, stringsAsFactors = FALSE)
data_ocean <- data_ocean[c("Time", "GMSL")]
data_ocean$Time <- as.Date(data_ocean$Time)

data_temp_ocean <- read.csv("data/sea-surface-temperature-anomaly.csv", check.names = FALSE)

data_coraux <- read.csv("data/coral-bleaching-events.csv", check.names = FALSE)

data_glace <- read.csv("data/arctic-sea-ice.csv", check.names = FALSE)


# ==============================================================================
# DONNEES FORETS
# ==============================================================================

data_foret <- read.csv("data/Foret.csv", sep = ";", check.names = FALSE, stringsAsFactors = FALSE)

data_forest_share <- read.csv("data/forest-area-as-share-of-land-area.csv", check.names = FALSE)

data_foret_annuel <- read.csv("data/annual-change-forest-area.csv", check.names = FALSE, stringsAsFactors = FALSE)

data_co2_foret <- read.csv("data/per-capita-co2-food-deforestation.csv", check.names = FALSE, stringsAsFactors = FALSE)

data_deforestation = read.csv("data/Deforestation.csv", sep = ";", check.names = FALSE, stringsAsFactors = FALSE)

data_camembert <- read.csv("data/Cause_deforestation.csv", sep = ";", check.names = FALSE, stringsAsFactors = FALSE)
data_camembert <- data_camembert[order(-data_camembert$Pourcent), ]
data_camembert$Catégorie <- factor(data_camembert$Catégorie,levels = rev(data_camembert$Catégorie))
data_camembert$lab.ypos <- cumsum(data_camembert$Pourcent) - 0.5 * data_camembert$Pourcent



# Fond de carte mondial (frontières des pays)
world <- ne_countries(scale = "medium", returnclass = "sf")