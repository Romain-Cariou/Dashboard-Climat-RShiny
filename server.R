server <- function(input, output, session) {
  
  
  # ==========================================================================
  # REACTIVES GLOBAUX 
  # ==========================================================================
  
  modele_temp <- reactive({
    df <- data_temp %>% filter(Year <= 2024)
    lm(anomalie ~ Year, data = tail(df, 20))
  })
  
  world_data_foret <- reactive({
    annee <- max(data_forest_share$year)
    df    <- data_forest_share[data_forest_share$year == annee &
                                 !is.na(data_forest_share$code), ]
    left_join(world, df, by = c("iso_a3" = "code"))
  })

  
  # Valeur KPI température — partagée entre les deux outputs
  temp_kpi_value <- reactive({
    paste0("+1.2°C")
    # Remplacez par : paste0("+", round(data_temp %>% filter(Year == max(Year)) %>% pull(anomalie), 2), "°C")
  })
  
  
  # ==========================================================================
  # ONGLET CO2
  # ==========================================================================
  
  output$co2Map <- renderPlotly({
    annee_nom <- as.character(input$annee_choisie)
    if (!(annee_nom %in% colnames(data_co2))) return(NULL)
    
    df <- data_co2[c("Country Code", annee_nom)]
    colnames(df) <- c("Code", "Valeur")
    df <- drop_na(df)
    df$Valeur <- ifelse(df$Valeur > 500, 500, df$Valeur)
    
    plot_geo(df) %>%
      add_trace(
        locations  = ~Code,
        z          = ~Valeur,
        text       = ~paste("Pays :", Code, "<br>Variation:", Valeur, "%"),
        colorscale = list(
          c(0,     "green"),
          c(0.166, "yellow"),
          c(1,     "red")
        ),
        zmin     = -100,
        zmax     = 500,
        colorbar = list(title = "Variation CO2 %")
      ) %>%
      layout(
        title = paste("Variation CO2 par pays", annee_nom),
        geo   = list(
          showframe      = FALSE,
          showcoastlines = TRUE,
          projection     = list(type = "equirectangular")
        )
      )
  })
  
  output$energy_plot <- renderPlotly({
    plot_ly(df_cum,
            x     = ~Year,
            y     = ~Production,
            color = ~Source,
            frame = ~frame,
            type  = "scatter",
            mode  = "lines",
            line  = list(width = 2)) %>%
      layout(
        title = "Production mondiale d'énergie (TWh)",
        xaxis = list(title = "Année",
                     range = c(min(data_prod_energie$Year),
                               max(data_prod_energie$Year))),
        yaxis = list(title = "TWh")
      ) %>%
      animation_opts(frame = 150, transition = 0, redraw = FALSE) %>%
      animation_button(label = "▶ Play") %>%
      animation_slider(currentvalue = list(prefix = "Année : "))
  })
  
  output$data_pollution <- DT::renderDataTable({
    datatable(top5_pm25, options = list(dom = 't', paging = FALSE), rownames = FALSE)
  })
  
  output$temp <- renderPlot({
    df    <- data_temp %>% filter(Year <= 2024)
    futur <- data.frame(Year = 2025:2035)
    futur$anomalie <- predict(modele_temp(), futur)
    
    ggplot() +
      geom_col(data = df,    aes(x = Year, y = anomalie, fill = anomalie > 0)) +
      geom_col(data = futur, aes(x = Year, y = anomalie), fill = "yellow", alpha = 0.7) +
      scale_fill_manual(values = c("TRUE" = "tomato", "FALSE" = "steelblue"), guide = "none") +
      geom_hline(yintercept = 0, color = "black") +
      labs(title    = "Anomalie de température mondiale par année",
           subtitle = "Positif = rouge, Négatif = bleu | Prédiction 2025-2035 en jaune",
           x = "Année", y = "Anomalie (°C)") +
      theme_minimal()
  })
  
  # KPI température — petit affichage
  output$temp_kpi <- renderText({ temp_kpi_value() })
  
  # KPI gaz — affichage multi-lignes stylisé
  output$temp_kpi2 <- renderUI({
    
    kpi_ligne <- function(icone, label, valeur, couleur) {
      div(style = "margin-bottom: 14px; text-align: center;",
          div(style = "font-size: 11px; color: #8aaa8a; text-transform: uppercase; letter-spacing: 0.6px;",
              paste(icone, label)),
          div(style = paste0("font-size: 22px; font-weight: 700; color: ", couleur, "; line-height: 1.1;"),
              valeur)
      )
    }
    
    div(
      kpi_ligne("💨", "CO₂",     "+44 %",  "#e67e22"),
      kpi_ligne("🐄", "Méthane", "+119 %", "#e74c3c"),
      kpi_ligne("🌾", "Azote",   "+22 %",  "#8e44ad")
    )
  })
  
  
  # ==========================================================================
  # ONGLET OCEANS
  # ==========================================================================
  
  output$ocean_plot <- renderPlotly({
    plot_ly(data_ocean,
            x         = ~Time,
            y         = ~GMSL,
            type      = "scatter",
            mode      = "lines+markers",
            line      = list(color = "blue"),
            marker    = list(size = 4),
            hoverinfo = "text",
            text      = ~paste("Date:", Time, "<br>GMSL:", GMSL, "cm")) %>%
      layout(
        title     = "Évolution du niveau moyen global des océans",
        xaxis     = list(title = "Date"),
        yaxis     = list(title = "Niveau moyen de la mer (cm)"),
        hovermode = "closest"
      )
  })
  
  output$temp_ocean_plot <- renderPlot({
    df <- data_temp_ocean %>% filter(Entity == "World")
    ggplot(df, aes(x = Year, y = Average, fill = Average > 0)) +
      geom_col() +
      scale_fill_manual(values = c("TRUE" = "tomato", "FALSE" = "steelblue"), guide = "none") +
      geom_hline(yintercept = 0, color = "black") +
      labs(title    = "Anomalie de température de surface des océans (monde)",
           subtitle = "Positif = rouge, Négatif = bleu",
           x = "Année", y = "Anomalie (°C)") +
      theme_minimal()
  })
  
  output$coraux_plot <- renderPlot({
    df <- data_coraux %>%
      filter(Entity == "World") %>%
      pivot_longer(cols      = c("Moderate (<30%)", "Severe (>30%)"),
                   names_to  = "Type",
                   values_to = "Evenements") %>%
      mutate(Type = recode(Type,
                           "Moderate (<30%)" = "Modéré (<30%)",
                           "Severe (>30%)"   = "Sévère (>30%)"))
    ggplot(df, aes(x = Year, y = Evenements, fill = Type)) +
      geom_col() +
      scale_fill_manual(values = c("Modéré (<30%)" = "orange", "Sévère (>30%)" = "darkred")) +
      labs(title    = "Événements de blanchissement des coraux (monde)",
           subtitle = "Nombre d'événements par année selon leur intensité",
           x = "Année", y = "Nombre d'événements", fill = "Intensité") +
      theme_minimal()
  })
  
  output$glace_plot <- renderPlot({
    df <- data_glace %>%
      pivot_longer(cols      = c("Minimum (September)", "Maximum (February)"),
                   names_to  = "Periode",
                   values_to = "Surface")
    ggplot(df, aes(x = Year, y = Surface, color = Periode)) +
      geom_line(size = 1) +
      geom_smooth(method = "lm", se = FALSE, linetype = "dashed", size = 0.7) +
      scale_color_manual(values = c("Minimum (September)" = "tomato",
                                    "Maximum (February)"  = "steelblue")) +
      labs(title    = "Évolution de l'étendue de la banquise arctique",
           subtitle = "Minimum en septembre et maximum en février (1979-2025)",
           x = "Année", y = "Surface (millions de km²)", color = "") +
      theme_minimal()
  })
  
  
  # ==========================================================================
  # ONGLET FORETS
  # ==========================================================================
  
  output$foret_plot <- renderPlot({
    data_foret$Perte <- data_foret$`2020` - data_foret$`1990`
    df <- data_foret[order(data_foret$Perte), ][1:10, ]
    ggplot(df, aes(x = reorder(`Country Name`, Perte), y = Perte)) +
      geom_col(fill = "darkred") +
      coord_flip() +
      labs(title = "10 pays qui ont perdu le plus de forêt (1990-2020)",
           x = "", y = "Variation en %")
  })
  
  output$foret_top_share <- renderLeaflet({
    world_data <- world_data_foret()
    pal <- colorNumeric(palette = "Greens", domain = world_data$forest_share, na.color = "lightgrey")
    leaflet() %>%
      addTiles() %>%
      addPolygons(
        data             = world_data,
        fillColor        = ~pal(forest_share),
        fillOpacity      = 0.7,
        color            = "white",
        stroke           = TRUE,
        weight           = 1,
        popup            = ~paste(name, ":", round(forest_share, 1), "%"),
        highlightOptions = highlightOptions(color = "black", weight = 3, bringToFront = TRUE)
      ) %>%
      addLegend(pal = pal, values = world_data$forest_share, title = "% forêt", position = "bottomright") %>%
      addControl(html = paste0("<b>Couvert forestier mondial en ", max(data_forest_share$year), "</b>"),
                 position = "bottomleft")
  })
  
  output$deforestation_decades_plot <- renderPlot({
    ggplot(data = data_deforestation, aes(x = Temps, y = Deforestation, fill = Temps)) +
      geom_col(width = 0.6) +
      geom_text(aes(label = Deforestation), vjust = -1, color = "white", size = 3) +
      theme_minimal() +
      scale_fill_manual(values = c("1990s" = "#8B3A3A", "2000s" = "orange", "2010s" = "#8B3A3A"),
                        guide = "none") +
      labs(title = "Taux de déforestation mondial par décennie",
           x = "", y = "Déforestation en Mha") +
      geom_curve(
        x = 2.75, y = -125, xend = 2, yend = -100,
        curvature = 0.3,
        arrow = arrow(type = "closed", length = unit(0.4, "cm"))
      ) +
      annotate("text", x = 2.75, y = -128,
               label = "Pendant les années \n2000, une zone de \nla taille de 3 fois \nla France a été \ndéforestée.",
               hjust = 0, vjust = 1, size = 3, color = "grey30")
  })
  
  output$foret_alimentation_table <- renderPlot({
   
    ggplot(data_camembert, aes(x = 2, y = Pourcent, fill = Catégorie)) +
      geom_bar(stat = "identity", color = "white") +
      coord_polar(theta = "y", start = 0) +
      geom_text(aes(y = lab.ypos, label = paste0(round(Pourcent * 100, 0), "%")),
                color = "white", fontface = "bold", size = 4) +
      scale_fill_brewer(palette = "Greens") +
      theme_void() +
      guides(fill = guide_legend(reverse = TRUE)) +
      xlim(0.5, 2.5) +
      labs(title = "Principales causes de la déforestation", fill = "")
  })
  
  
  # ==========================================================================
  # ONGLET DONNEES
  # ==========================================================================
  
  dt_opt <- list(
    pageLength = 5,
    scrollX    = TRUE,
    language   = list(url = "//cdn.datatables.net/plug-ins/1.10.11/i18n/French.json")
  )
  
  output$table_co2_page      <- DT::renderDataTable({ datatable(data_co2,         options = dt_opt) })
  output$table_energie_page  <- DT::renderDataTable({ datatable(data_prod_energie, options = dt_opt) })
  output$table_temp_co2_page <- DT::renderDataTable({ datatable(data_temp,         options = dt_opt) })
  output$table_ocean_page      <- DT::renderDataTable({ datatable(data_ocean,      options = dt_opt) })
  output$table_temp_ocean_page <- DT::renderDataTable({ datatable(data_temp_ocean, options = dt_opt) })
  output$table_coraux_page     <- DT::renderDataTable({ datatable(data_coraux,     options = dt_opt) })
  output$table_glace_page      <- DT::renderDataTable({ datatable(data_glace,      options = dt_opt) })
  output$table_foret_page        <- DT::renderDataTable({ datatable(data_foret,        options = dt_opt) })
  output$table_foret_share_page  <- DT::renderDataTable({ datatable(data_forest_share, options = dt_opt) })
  output$table_foret_annuel_page <- DT::renderDataTable({ datatable(data_foret_annuel, options = dt_opt) })
  output$table_co2_foret_page    <- DT::renderDataTable({ datatable(data_co2_foret,    options = dt_opt) })
  
  
  # ==========================================================================
  # suspendWhenHidden — tables chargées uniquement à l'ouverture de l'onglet
  # ==========================================================================
  
  outputOptions(output, "table_co2_page",          suspendWhenHidden = TRUE)
  outputOptions(output, "table_energie_page",      suspendWhenHidden = TRUE)
  outputOptions(output, "table_temp_co2_page",     suspendWhenHidden = TRUE)
  outputOptions(output, "table_ocean_page",        suspendWhenHidden = TRUE)
  outputOptions(output, "table_temp_ocean_page",   suspendWhenHidden = TRUE)
  outputOptions(output, "table_coraux_page",       suspendWhenHidden = TRUE)
  outputOptions(output, "table_glace_page",        suspendWhenHidden = TRUE)
  outputOptions(output, "table_foret_page",        suspendWhenHidden = TRUE)
  outputOptions(output, "table_foret_share_page",  suspendWhenHidden = TRUE)
  outputOptions(output, "table_foret_annuel_page", suspendWhenHidden = TRUE)
  outputOptions(output, "table_co2_foret_page",    suspendWhenHidden = TRUE)
  
}
