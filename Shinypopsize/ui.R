library("shiny")
library("shinythemes")

shinyUI(fluidPage(theme = shinytheme("flatly"),
      #            
      tags$head(tags$style(HTML(".shiny-text-output {
                         background-color:#fff; }"))),
  
                  
        h1(span("Estimation de Population", style = "font-weight: 200"), 
        style = "font-family: 'Source Sans Pro';
        color: #000000; text-align: center;
        background-image: url('imag1.png');
        padding: 20px"),
                  
        br(),
                  
        fluidRow(
        column(6, offset = 3,
        p("Cette session vous permet d'estimer la taille de population dans un rayon de 100 metre
        autour d'un lieudit.",br(),  
        style = "font-family: 'Lobster', cursive; text-align: center; color: #0099CC")
        )),
                  
        h4("Burkina Faso --- Bobo-dioulasso", 
        style = "font-family: 'Lobster', cursive; text-align: center; color: #0000"),  
        tabsetPanel(
          tabPanel("Estimation",
                      fluidRow(
                      column(6,
                      wellPanel(
                      selectInput("choix", label = h3("Région"), 
                      choices = list("Ouagadougou" = "ouga", 
                                     "Bobo-dioulasso" = "bobo"),
                                      selected = "bobo"),
                      textOutput("message1"),
                                      hr())),
                               
                    column(6,
                    wellPanel(
                    radioButtons("checkGroup", 
                    label = h3("Type de cordonnées"), 
                    choices = c("Utm"= "Utm",
                                "Longlat"="Longlat" )),
                    textOutput("message2"),
                                hr()))),
                   
                             
                      fluidRow(
                      column(6,
                      wellPanel( 
                      column(6,textInput("long", "Longitude du lieudit:",361394.976076)),
                      column(6,textInput("lat", "L'altitude du lieudit:",1233962.47651)),
                                        
                      # text de note ----
                      helpText("Note: Les coordonnées doivent être en Utm",
                               "Vous disposez des coordonnées en longlat, veuillez",
                               "Les convertire à droite",
                      style = "font-family: 'Lobster', cursive; text-align: center; 
                                color:#000000"),
                      actionButton("estime", "Estimer",class = "btn-primary"),
                      helpText("RESULTAS",
                      style = "font-family: 'Lobster', cursive; text-align: center; 
                            color: #000000"),
                      helpText("La taille de la population estimée cent (100) mêtre",
                               "autour de ce lieudit renseigné est:",
                      style = "font-family: 'Lobster', cursive; text-align: center; 
                              color: #ff0000"),
                      textOutput("text"))),
                               
                      column(6,
                      wellPanel(
                      # Entrée es coordonnée ----
                      column(6,textInput("long2", "Longitude du lieudit:",-4.26936)),
                      column(6,textInput("lat2", "L'altitude du lieudit:",11.15995)),
                      helpText("Note: Vous dispossez des coordonnées en longlat : Coordonnées decimales",
                               "Vous desirez les convertire en utm",
                               "Veillez les saisir",
                       style = "font-family: 'Lobster', cursive; text-align: center; 
                                color: #000000"),
                      actionButton("conv", "Convertire",class = "btn-primary"),
                      helpText("RESULTAS",
                      style = "font-family: 'Lobster', cursive; text-align: center; 
                               color: #000000"),
                      tableOutput("table"))))),
          
tabPanel("Cartographie",
        fluidRow(
        column(6,wellPanel(
        helpText("Veillez entrée les coordonnées du lieudit",
        style = "font-family: 'Lobster', cursive; text-align: center; 
                color:#000000"),
        textInput("long3", "Longitude du lieudit:",361394.976076),
                       
        textInput("lat3", "L'altitude du lieudit:",1233962.47651))),
        column(6,wellPanel(
        sliderInput("n", label = h4("Répére de visualisation"), 
                                   min = 100, max = 10000,value = 500),
        br(),
        helpText("Cliquez sur visualise",
        style = "font-family: 'Lobster', cursive; text-align: center; 
                                color:#000000"),
        actionButton("view", "Visualisation",class = "btn-primary"))),
        plotOutput("carto"))),
 
tabPanel("Statistique", 
         navbarPage(inverse=TRUE,
           tags$style(type =                       
                      '.navbar-dropdown { background-color: #242424;
                                                    font-family: Arial;
                                                    font-size: 13px;
                                                    color:#FF0000; }',
                      '.navbar-default .navbar-brand {
                             color: #cc3f3f;}'),
         tabsetPanel(
           tabPanel("Données",                    
                    fluidRow(              
                      column(4,
                             wellPanel(
                               
                               checkboxGroupInput("Variables", "Visualisation des variable d'étude",
                                                  c("DATE","Longitude","Laltitude","Type_ZONE",
                                                    "Precision","Noms","pop")))),
                      column(6,
                      tableOutput("data")))),
           tabPanel("Descriptive",
                    fluidRow(
                      column(4,
                             wellPanel(
                               helpText("Etude de la variable d'interret : Densité de population"),
                               actionButton("view2", "summary"),
                               br(),br(),br(),br(),
                               actionButton("view3", "histogramme",class = "btn-primary"),
                               br(),br(),br(),br(),
                               actionButton("view4", "Boxplot"),
                               br(),br(),br(),br(),
                               actionButton("view5", "Qqplot",class = "btn-primary"),
                               br(),br(),br(),br(),
                               actionButton("view6", "Test Normalité"),
                               br(),br(),br(),br(),
                               actionButton("view7", "Dispersion",class = "btn-primary"))),
                      column(8,
                             tableOutput("summary1"),
                             plotOutput("histogramme1"),
                             plotOutput("Boxplot"),
                             plotOutput("Qqplot"),
                             textOutput("test"),
                             plotOutput("nuage")))),
           
           tabPanel("Variogramme",
                    fluidRow(
                      column(4,
                             wellPanel(
                               helpText("Etude Variographique ou étude spatiale")
                               
                             )),
                      column(8,
                             plotOutput("Nue1"),
                             plotOutput("Nue2"),
                             plotOutput("Nue3"))))
           
           
           
           ))),
tabPanel("Aide",
         titlePanel("Tout sur l'application"),
         p("L'application est divisée en trois onglés."),
         br(),
         column(6,wellPanel(
           p("Estimation",
             style = "font-family: 'Lobster';color: #0099CC"),
           helpText("Cette partie vous permet:",br(),br(),
                    "1.  choisir la region dans laquelle vous desiré faire l'estimation",br(),
                    "- La capitale du Burkina Faso: Ouagadougou",br(),
                    "- La deusiéme capitale du Burkina Faso: Bobo-Dioulasso",br(),br(),
                    "2. Choisir le type de coordonnés dont vous dispossé:", br(),
                    "- longlat : Longitude en degrés décimaux, mesuré par rapport au méridien d’origine (Greenwich) et la  Latitude en degrés décimaux, mesuré par rapport à l’équateur",br(),
                    "- UTM :les coordonnées en degrés décimaux, projetées en zone NORD 30 pour obtenir des coordonnées métriques afin de pouvoir effectuer les calculs de distances.",br(),br(),
                    "3. Convertir vos coordonnées longlat en UTM",br(),
                    "UTM : projection Transverse Universelle de Mercator (en anglais Universal Transverse Mercator) est un type de projection conforme de la surface de la Terre.",br(),
                    "Système de référence : le Burkina Faso est situé dans le système World Geodetic System
                    WGS84.",br(),br(),
                    "4. Estimation: en effet, cette méthode consistait, pour chaque lieudit renseigné d'estimer le nombre d’habitants situés dans un rayon de cent mètres (100 m), c’est-à-dire sur une superficie de 3 ha 14 a, soit 31 415 km² (31 415 000m²) et sur une circonférence
                    de 628 km autour de ce lieu.",
                    style = "font-family: 'Lobster', cursive; text-align: center; 
                    color: #000000")
           )),
         
         column(6,wellPanel(
           p("Cartographie",
             style = "font-family: 'Lobster';color: #0099CC"),
           helpText("Cette partie vous permet:",br(),br(),
                    "1.  Visualisez le lieudit dans la zone d'étude",br(),
                    "- Entrez la longitude",br(),
                    "- Entrez la latitude",br(),br(),
                    "2. Ajustez votre visualisation", br(),
                    style = "font-family: 'Lobster', cursive; text-align: center; 
                    color: #000000"))),
           column(6,wellPanel(
             p("Statistique",
               style = "font-family: 'Lobster';color: #0099CC"),
             helpText("Cette partie est constitué de trois (3) sous ongles:",br(),br(),
                      "1. La visualisation des données ",br(),
                      "2. La statistique descriptive de la variable d'intêrret", br(),
                      "3. L'analyse spatiale des données", br(),
                      style = "font-family: 'Lobster', cursive; text-align: center; 
                      color: #000000")
           )))

)))