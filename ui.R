fluidPage(
  
  # ===========================================================================
  # HEAD
  # ===========================================================================
  
  tags$head(
    tags$style(HTML("

      /* ── Variables de thème ─────────────────────────────────────────────── */
      :root {
        --bg:         #f4f6f4;
        --bg-card:    #ffffff;
        --text:       #1a2e1a;
        --text-muted: #6b7c6b;
        --border:     rgba(0,0,0,0.07);
        --shadow:     0 1px 8px rgba(0,0,0,0.07);
        --accent:     #1a2e1a;
        --transition: 0.25s ease;
      }

      /* ── Mode sombre ────────────────────────────────────────────────────── */
      body.dark-mode {
        --bg:         #111a11;
        --bg-card:    #1c2b1c;
        --text:       #e8f0e8;
        --text-muted: #8aaa8a;
        --border:     rgba(255,255,255,0.06);
        --shadow:     0 1px 12px rgba(0,0,0,0.35);
        --accent:     #4caf50;
      }

      /* ── Global ─────────────────────────────────────────────────────────── */
      body {
        font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
        background:  var(--bg);
        color:       var(--text);
        transition:  background var(--transition), color var(--transition);
      }

      /* ── Scrollbar ──────────────────────────────────────────────────────── */
      ::-webkit-scrollbar       { width: 6px; }
      ::-webkit-scrollbar-track { background: transparent; }
      ::-webkit-scrollbar-thumb { background: var(--text-muted); border-radius: 3px; }

      /* ── Navbar ─────────────────────────────────────────────────────────── */
      .navbar {
        background: #1a2e1a !important;
        border: none !important;
        box-shadow: 0 2px 12px rgba(0,0,0,0.25);
      }
      .navbar-brand                { color: #fff !important; font-weight: 700 !important; letter-spacing: 0.3px; }
      .navbar-nav > li > a         { color: rgba(255,255,255,0.65) !important; transition: color 0.2s; }
      .navbar-nav > li.active > a,
      .navbar-nav > li > a:hover   { color: #fff !important; background: rgba(255,255,255,0.1) !important; }

      /* ── Bouton dark mode ───────────────────────────────────────────────── */
      #dark_toggle {
        margin-top: 8px;
        margin-right: 8px;
        background: rgba(255,255,255,0.12);
        border: 1px solid rgba(255,255,255,0.2);
        color: #fff;
        border-radius: 20px;
        padding: 4px 14px;
        font-size: 13px;
        cursor: pointer;
        transition: background 0.2s;
      }
      #dark_toggle:hover { background: rgba(255,255,255,0.22); }

      /* ── Hero ───────────────────────────────────────────────────────────── */
      .hero {
        height: 88vh;
        background: linear-gradient(135deg, #1a2e1a 0%, #2d5a2d 55%, #1a3a2a 100%);
        display: flex;
        justify-content: center;
        align-items: center;
        text-align: center;
      }
      .hero-content { color: white; max-width: 700px; padding: 20px; }
      .hero h1      { font-size: 2.5rem; font-weight: 700; margin-bottom: 16px; letter-spacing: -0.5px; }
      .hero p       { font-size: 1rem; line-height: 1.75; opacity: 0.82; }

      /* ── Contenu principal ──────────────────────────────────────────────── */
      .main-content { padding: 20px 30px; }
      .page-title {
        font-size: 1.4rem; font-weight: 700;
        margin-bottom: 18px; padding-bottom: 12px;
        border-bottom: 2px solid var(--accent);
        color: var(--text);
      }

      /* ── Cards ──────────────────────────────────────────────────────────── */
      .card {
        background:    var(--bg-card);
        border-radius: 12px;
        padding:       16px;
        margin-bottom: 16px;
        box-shadow:    var(--shadow);
        border:        1px solid var(--border);
        transition:    background var(--transition), box-shadow var(--transition);
      }

      /* ── KPI cards ──────────────────────────────────────────────────────── */
      .kpi-card {
        background:    var(--bg-card);
        border-radius: 12px;
        padding:       12px 16px;
        margin-bottom: 10px;
        box-shadow:    var(--shadow);
        border:        1px solid var(--border);
        display:       flex;
        align-items:   center;
        gap:           12px;
        transition:    background var(--transition), transform 0.15s;
      }
      .kpi-card:hover { transform: translateY(-2px); box-shadow: 0 4px 16px rgba(0,0,0,0.1); }
      .kpi-icon  { font-size: 20px; width: 32px; text-align: center; flex-shrink: 0; }
      .kpi-body  { display: flex; flex-direction: column; }
      .kpi-label { font-size: 10px; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.6px; margin-bottom: 1px; }
      .kpi-value { font-size: 20px; font-weight: 700; line-height: 1.1; }
      .kpi-sub   { font-size: 10px; color: var(--text-muted); margin-top: 1px; }

      /* ── DataTables dark mode ───────────────────────────────────────────── */
      body.dark-mode table.dataTable tbody tr  { background: var(--bg-card) !important; color: var(--text); }
      body.dark-mode table.dataTable thead th  { background: #253825 !important; color: var(--text); }
      body.dark-mode .dataTables_wrapper       { color: var(--text); }
      body.dark-mode .dataTables_wrapper select,
      body.dark-mode .dataTables_wrapper input { background: #253825; color: var(--text); border-color: var(--border); }

    ")),
    
    tags$script(HTML("
      document.addEventListener('DOMContentLoaded', function() {
        var btn = document.getElementById('dark_toggle');
        if (!btn) return;
        btn.addEventListener('click', function() {
          document.body.classList.toggle('dark-mode');
          btn.textContent = document.body.classList.contains('dark-mode') ? '☀️ Clair' : '🌙 Sombre';
        });
      });
    "))
  ),
  
  # ===========================================================================
  # NAVBAR
  # ===========================================================================
  
  navbarPage(
    title  = "🌍 Réchauffement Climatique",
    header = tags$button(id = "dark_toggle", "🌙 Sombre"),
    
    # =========================================================================
    # ACCUEIL
    # =========================================================================
    
    tabPanel("Accueil",
             div(class = "hero",
                 div(class = "hero-content",
                     h1("Les impacts du réchauffement climatique"),
                     p("Ce dashboard présente les causes et conséquences du réchauffement climatique
             à travers trois thématiques : les émissions de CO₂, l'évolution des océans et la déforestation.")
                 )
             )
    ),
    
    # =========================================================================
    # CO2
    # =========================================================================
    
    tabPanel("CO₂",
             div(class = "main-content",
                 div(class = "page-title", "🌫️ Émissions de CO₂"),
                 fluidRow(
                   column(6, div(class = "card",
                                 sliderInput("annee_choisie", "Année :",
                                             min = 1991, max = 2024, value = 2024,
                                             sep = "", width = "100%"),
                                 plotlyOutput("co2Map", height = "280px")
                   )),
                   column(4,
                          div(class = "kpi-card",
                              style = "height: 105px; justify-content: center; flex-direction: column; align-items: center; text-align: center;",
                              
                              div(class = "kpi-icon", "🌡️"),
                              div(class = "kpi-body",
                                  div(class = "kpi-label", "Température mondiale"),
                                  div(class = "kpi-value", style = "color:#e74c3c;", textOutput("temp_kpi")),
                                  div(class = "kpi-sub", "anomalie / référence 1951-1980")
                              )
                          ),
                          div(class = "card", DT::dataTableOutput("data_pollution"))
                   ),
                   column(2,
                          div(class = "card",
                              style = "min-height:410px; display:flex; flex-direction:column;
                                       justify-content:center; align-items:center; text-align:center;",
                              uiOutput("temp_kpi2")
                          )
                   )
                 ),
                 fluidRow(
                   column(5, div(class = "card", plotOutput("temp",          height = "320px"))),
                   column(7, div(class = "card", plotlyOutput("energy_plot", height = "320px")))
                 )
             )
    ),
    
    # =========================================================================
    # OCEANS
    # =========================================================================
    
    tabPanel("Océans",
             div(class = "main-content",
                 div(class = "page-title", "🌊 Évolution des océans"),
                 
                 fluidRow(
                   column(3, div(class = "kpi-card",
                                 div(class = "kpi-icon", "📏"),
                                 div(class = "kpi-body",
                                     div(class = "kpi-label", "Niveau des mers"),
                                     div(class = "kpi-value", style = "color:#3498db;", "+10 cm"),
                                     div(class = "kpi-sub", "depuis 1990")
                                 )
                   )),
                   column(3, div(class = "kpi-card",
                                 div(class = "kpi-icon", "🪸"),
                                 div(class = "kpi-body",
                                     div(class = "kpi-label", "Coraux"),
                                     div(class = "kpi-value", style = "color:#e74c3c;", "-50 %"),
                                     div(class = "kpi-sub", "en 60 ans")
                                 )
                   )),
                   column(3, div(class = "kpi-card",
                                 div(class = "kpi-icon", "⚗️"),
                                 div(class = "kpi-body",
                                     div(class = "kpi-label", "Acidité de l'eau"),
                                     div(class = "kpi-value", style = "color:#e67e22;", "+30 %"),
                                     div(class = "kpi-sub", "depuis 1750")
                                 )
                   )),
                   column(3, div(class = "kpi-card",
                                 div(class = "kpi-icon", "🐟"),
                                 div(class = "kpi-body",
                                     div(class = "kpi-label", "Biomasse marine"),
                                     div(class = "kpi-value", style = "color:#8e44ad;", "-17 %"),
                                     div(class = "kpi-sub", "prévu pour 2100")
                                 )
                   ))
                 ),
                 
                 fluidRow(
                   column(6, div(class = "card", plotlyOutput("ocean_plot",    height = "280px"))),
                   column(6, div(class = "card", plotOutput("temp_ocean_plot", height = "280px")))
                 ),
                 fluidRow(
                   column(6, div(class = "card", plotOutput("coraux_plot", height = "280px"))),
                   column(6, div(class = "card", plotOutput("glace_plot",  height = "280px")))
                 )
             )
    ),
    
    # =========================================================================
    # FORETS
    # =========================================================================
    
    tabPanel("Forêts",
             div(class = "main-content",
                 div(class = "page-title", "🌳 Déforestation mondiale"),
                 fluidRow(
                   column(6, div(class = "card", plotOutput("foret_plot",         height = "280px"))),
                   column(6, div(class = "card", leafletOutput("foret_top_share", height = "280px")))
                 ),
                 fluidRow(
                   column(3, div(class = "card", plotOutput("deforestation_decades_plot", height = "440px"))),
                   column(3,
                          div(class = "kpi-card",
                              style = "height: 110px; justify-content: center; flex-direction: column; align-items: center; text-align: center;",
                              
                              div(class = "kpi-icon", "🌲"),
                              div(class = "kpi-body",
                                  div(class = "kpi-label", "Forêt perdue"),
                                  div(class = "kpi-value", style = "color:#e74c3c;", "-443 Mha"),
                                  div(class = "kpi-sub", "depuis 1990")
                              )
                          ),
                          div(class = "kpi-card",
                              style = "height: 110px; justify-content: center; flex-direction: column; align-items: center; text-align: center;",
                              div(class = "kpi-icon", "🔥"),
                              div(class = "kpi-body",
                                  div(class = "kpi-label", "Forêts brûlées"),
                                  div(class = "kpi-value", style = "color:#e67e22;", "×2"),
                                  div(class = "kpi-sub", "vs période préindustrielle")
                              )
                          ),
                          div(class = "kpi-card",
                              style = "height: 110px; justify-content: center; flex-direction: column; align-items: center; text-align: center;",
                              div(class = "kpi-icon", "🦎"),
                              div(class = "kpi-body",
                                  div(class = "kpi-label", "Vertébrés"),
                                  div(class = "kpi-value", style = "color:#8e44ad;", "-69 %"),
                                  div(class = "kpi-sub", "depuis 1970")
                              )
                          ),
                          div(class = "kpi-card",
                              style = "height: 110px; justify-content: center; flex-direction: column; align-items: center; text-align: center;",
                              div(class = "kpi-icon", "☁️"),
                              div(class = "kpi-body",
                                  div(class = "kpi-label", "CO₂ Amazonie"),
                                  div(class = "kpi-value", style = "color:#c0392b;", "+15 %"),
                                  div(class = "kpi-sub", "émissions nettes")
                              )
                          )
                   ),
                   column(6, div(class = "card", plotOutput("foret_alimentation_table", height = "435px")))
                 )
             )
    ),
    
    # =========================================================================
    # SYNTHESE
    # =========================================================================
    
    tabPanel("Synthèse des Impacts",
             div(class = "main-content",
                 div(class = "page-title", "📊 Conséquences observées et projections"),
                 
                 fluidRow(
                   column(4, div(class = "card",
                                 h3("🌡️ Atmosphère"),
                                 p("L'augmentation des émissions de CO₂ entraîne une hausse directe des températures."),
                                 tags$ul(
                                   tags$li("Anomalies thermiques de plus en plus fréquentes."),
                                   tags$li("Prévisions d'une hausse continue d'ici 2035 selon nos modèles.")
                                 )
                   )),
                   column(4, div(class = "card",
                                 h3("🌊 Océans"),
                                 p("Le réchauffement ne se limite pas à l'air, il transforme nos mers :"),
                                 tags$ul(
                                   tags$li("Montée du niveau moyen (GMSL) menaçant les zones côtières."),
                                   tags$li("Blanchissement massif des coraux dû à l'acidification et la chaleur."),
                                   tags$li("Fonte critique de la banquise arctique (minimums historiques).")
                                 )
                   )),
                   column(4, div(class = "card",
                                 h3("🌿 Biodiversité"),
                                 p("La déforestation agit comme un double multiplicateur :"),
                                 tags$ul(
                                   tags$li("Perte de puits de carbone naturels."),
                                   tags$li("Émissions massives de CO₂ liées au changement d'usage des terres."),
                                   tags$li("Fragmentation des habitats naturels.")
                                 )
                   ))
                 ),
                 div(class = "card",
                     h4("Analyse globale"),
                     p("Les données visualisées dans les onglets précédents montrent une corrélation claire entre 
                       l'activité industrielle (production d'énergie, pollution PM2.5) et la dégradation des 
                       indicateurs planétaires. La transition vers des énergies décarbonées et la protection 
                       des forêts primaires restent les leviers principaux pour infléchir les courbes présentées ici.")
                 )
             )
    ),
    
    # =========================================================================
    # DONNÉES
    # =========================================================================
    
    tabPanel("Données",
             div(class = "main-content",
                 div(class = "page-title", "🗂️ Exploration des sources par thématique"),
                 div(class = "card",
                     tabsetPanel(
                       tabPanel("Page CO₂",
                                h4("Données utilisées pour la carte et l'énergie"),
                                DT::dataTableOutput("table_co2_page"),
                                hr(),
                                h4("Données de production d'énergie"),
                                DT::dataTableOutput("table_energie_page"),
                                hr(),
                                h4("Anomalies de température"),
                                DT::dataTableOutput("table_temp_co2_page")),
                       tabPanel("Page Océans",
                                h4("Niveau moyen de la mer (GMSL)"),
                                DT::dataTableOutput("table_ocean_page"),
                                hr(),
                                h4("Température de surface des océans"),
                                DT::dataTableOutput("table_temp_ocean_page"),
                                hr(),
                                h4("Blanchissement des coraux"),
                                DT::dataTableOutput("table_coraux_page"),
                                hr(),
                                h4("Étendue de la banquise"),
                                DT::dataTableOutput("table_glace_page")),
                       tabPanel("Page Forêts",
                                h4("Variation du couvert forestier (1990-2020)"),
                                DT::dataTableOutput("table_foret_page"),
                                hr(),
                                h4("Part de la forêt sur le territoire"),
                                DT::dataTableOutput("table_foret_share_page"),
                                hr(),
                                h4("Changement annuel de surface forestière"),
                                DT::dataTableOutput("table_foret_annuel_page"),
                                hr(),
                                h4("CO₂ et déforestation alimentaire"),
                                DT::dataTableOutput("table_co2_foret_page"))
                     )
                 )
             )
    )
  )
)
