# 🌍 Dashboard : Impacts du Réchauffement Climatique
**Projet Académique - Master 1 Mathématiques Appliquées & Statistique**

Ce dashboard interactif développé avec **R Shiny** permet de visualiser et d'analyser les indicateurs critiques du changement climatique (CO2, Océans, Déforestation).

🔗 **Application en ligne :** [https://rechauffemnt-climatique.shinyapps.io/Projet_Visualisation/](https://rechauffemnt-climatique.shinyapps.io/Projet_Visualisation/)

## 📊 Fonctionnalités clés
* **Data Prep :** Nettoyage et restructuration de données hétérogènes (CSV, Open Data) via `dplyr` et `tidyr`.
* **Modélisation :** Intégration d'une régression linéaire pour la projection des anomalies de température à l'horizon 2035.
* **Dataviz :** Cartographie mondiale dynamique (`Leaflet`) et graphiques interactifs (`Plotly`).
* **Interface :** UI personnalisée avec gestion d'un mode sombre (CSS/JS).

## 🛠 Stack Technique
* **Langage :** R
* **Framework :** Shiny (Architecture ui/server/global)
* **Packages :** plotly, leaflet, sf, ggplot2, DT
