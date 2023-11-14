############################
#          body            # 
############################


body <- dashboardBody( 
  tabItems(    
    
    #################################################################################
    #################################################################################
    #                                Introducción                                   #
    #################################################################################
    #################################################################################
    
    tabItem(tabName = "p1",
            
            h1("Guía de Usuario para la Aplicación Shiny de Análisis de Muestras para Unidades Financieras.", align = "center"),
            br(),
            h2("Introducción", align = "left", style = "font-weight: bold; text-decoration: underline;"),
            br(),
            h4("Bienvenido a la aplicación Shiny especializada en el análisis de muestras para unidades financieras.",align = "left"),
            h4("Esta herramienta interactiva ha sido diseñada para facilitar el proceso de descripción, muestreo de auditoria y la evaluación de un conjunto de datos financieros." ,align = "left"),
            br(),
            h2("¡Inicie utilizando la App!", align = "left", style = "font-weight: bold; text-decoration: underline;"),
            br(),
            h4("Para comenzar con la aplicación, en cada sección deberá:",align = "left"),
            br(),
            h4("Navegación",align = "left", style = "font-weight: bold"),
            h4("Mueva entre los diferentes módulos utilizando las pestañas dispuestas en la interfaz de usuario."),
            h4("Cargar Datos", align = "left", style = "font-weight: bold"), 
            h4("Utilice el botón de carga de archivos para subir su conjunto de datos en el formato adecuado." ,align = "left"),
            h4("Análisis: ",align = "left", style = "font-weight: bold"),
            h4("Siga las instrucciones específicas en cada módulo para realizar el análisis deseado."),
            br(),
            h2("Estructura de la Aplicación", align = "left", style = "font-weight: bold; text-decoration: underline;"),
            br(),
            h4("La aplicación se divide en tres módulos, cada uno enfocado en un aspecto crítico:",align = "left"),
            br(),
            tags$ul(
              style = "list-style-type: disc; padding-left: 20px;",  # Estilo para la lista: disc es una viñeta redonda
              tags$li(h4("Análisis Descriptivo", align = "left")),
              tags$li(h4("Proceso de Muestreo", align = "left")),
              tags$li(h4("Evaluación de la Muestra", align = "left"))
            ),
            br(),
            h4("A continuación, exploramos en detalle cada uno de estos módulos.",align = "left"),
            br(),
            h2("Análisis Descriptivo", align = "left", style = "font-weight: bold; text-decoration: underline;"),
            br(),
            h4("Antes de abordar el proceso de muestreo (tamaño de muestra y selección de las unidades), es esencial comprender el conjunto de datos con el que se trabajará. En el módulo de Análisis Descriptivo, los usuarios podrán:",align = "left"),
            br(),
            tags$ul(
              style = "list-style-type: disc; padding-left: 20px;",  # Estilo para la lista: disc es una viñeta redonda
              tags$li(h4("Análisar las principalres estadísticas descriptivas de la variable de interés.", align = "left")),
              tags$li(h4("Analisar la distribución de la variable de interés.", align = "left")),
              tags$li(h4("Según el análisis de la distribución de la variable de interés, tener una mejor idea del ajuste de la función de distribución.", align = "left"))
            ),
            br(),
            h2("Proceso de Muestreo", align = "left", style = "font-weight: bold; text-decoration: underline;"),
            br(),
            h4("Tras un entendimiento  del conjunto de datos, se procede con la etapa del Muestreo. Esta etapa consta de:",align = "left"),
            br(),
            tags$ul(
              style = "list-style-type: disc; padding-left: 20px;",  # Estilo para la lista: disc es una viñeta redonda
              tags$li(h4("Determinar el tamaño de muestra.", align = "left")),
              tags$li(h4("Visualizar la selección de los montos según el tamaño de muestra anterior.", align = "left")),
              tags$li(h4("Comprar distribuciones entre los datos orginales y los obtenidos por la muestra.", align = "left")),
              tags$li(h4("Descargar los datos seleccionados en el proceso de muestreo.", align = "left"))
            ),
            br(),
            h2("Evaluación de la Muestra", align = "left", style = "font-weight: bold; text-decoration: underline;"),
            br(),
            h4("El último módulo, Evaluación de la Muestra, es para obtener un contraste empírico referente al proceso de la auditoria. En esta sección:",align = "left"),
            br(),
            tags$ul(
              style = "list-style-type: disc; padding-left: 20px;",  # Estilo para la lista: disc es una viñeta redonda
              tags$li(h4("Se comparan los resultados de una muestra antes seleccionados a nivel visual y los valores que presentan diferencias.", align = "left")),
              tags$li(h4("Se realiza un cuadro con datos de interés del proceso de muestreo", align = "left")),
              tags$li(h4("Se brinda un resultado empírico sobre el proceso de Auditoría.", align = "left"))
            ),
            
            br(),
            h2("Sobre la carga de datos", align = "left", style = "font-weight: bold; text-decoration: underline;"),
            br(),
            h4("Para cada uno de los módulos anteriores, deberá cargar un archivo de datos. La aplicación admite múltiples formatos incluyendo .xlsx, .txt y .csv. Tenga en cuenta que:",align = "left"),
            br(),
            tags$ul(
              style = "list-style-type: disc; padding-left: 20px;",  # Estilo para la lista: disc es una viñeta redonda
              tags$li(h4("Cada archivo cargado debe contener una sola tabla.", align = "left", style = "font-weight: bold")),
              tags$li(h4("Los datos deben estar limpios, listo para ser analizados.", align = "left", style = "font-weight: bold")),
              tags$li(h4("El peso máximo permitido por archivo es de 100 megabytes, asegurando así la fluidez y eficiencia de la aplicación.", align = "left", style = "font-weight: bold"))
            )
    ),
            
    
    #################################################################################
    #################################################################################
    #                                 Análisis descriptivo                          #
    #################################################################################
    #################################################################################
    
    tabItem(tabName = "p2",
            
            h1("Análisis Descriptivos", align = "center"),
            br(),
            h2("En este sección:", align = "left"),
            br(),
            h4("Se analiza de forma descriptiva el conjunto de datos.", align ="left"),
            br(),
            h4("Cargado los datos, usted podrá:"),
            br(),
            tags$ul(
              style = "list-style-type: disc; padding-left: 20px;",  # Estilo para la lista: disc es una viñeta redonda
              tags$li(h4("Conocer las principales estadísticas descriptivas de la variable seleccionada.", align = "left")),
              tags$li(h4("Visualizar la distribución de la variable seleccionada (densidad).", align = "left",)),
              tags$li(h4("Comprar la distribución de la variable seleccionada con respecto a una distribución de poisson o binomial.", align = "left"))
            ),
            br(),
            h4("Este último punto lo guirará en el proceso de la siguiente sección, en donde deberá seleccionar la distribución que aproximada más al conjunto de datos em la determinación del tamaño de muestra"),
            br(),
            
            h3("Cargar datos", align = "left"),
            
            # Input para cargar archivos
            # Input para cargar archivos
            fileInput("file1", "Importar datos",
                      accept = c(
                        ".csv",
                        ".txt",
                        ".xlsx",
                        "text/csv",
                        "text/plain",
                        "text/tab-separated-values",
                        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
                      )),
            uiOutput("variable_select_1"),
            br(),
            actionButton("start_analysis", "Iniciar Análisis Descriptivos", class = "btn-primary"),
            uiOutput("analysis_output"),
            br(),
            h3("Estadíticas descriptivas", align = "left"),
            reactableOutput("stats"), # Salida para la tabla de estadísticas   ---->  reactableOutput()
            br(),
            h3("Análisis de distribuciones", align = "left"),
            br(),                                                  # histogram1
            
            highchartOutput("histogram1"),
            # highchartOutput("histogramX"),
            
            # highchartOutput("histogram1"),

            h3("Comparación de Ajuste de Distribuciones", align = "left"),
            br(),
            h4("Por favor, guiarse según las siguientes gráficas de distrubución."),
            fluidRow(
              box(
                title = "Comparación de distribuciones",
                status = "primary",
                solidHeader = TRUE,
                collapsible = TRUE,
                width = 12,
                fluidRow(
                  column(
                    width = 6,
                    plotOutput("binomialPlot")
                  ),
                  column(
                    width = 6,
                    plotOutput("poissonPlot")
                  )
                )
              )
            ),
            h4("Si posee datos aglomerados o consistentes en todo el rango de posibles valores, es mejor que opte por un ajuste Binomial. Caso contrario,
               datos que están muy alejados de la aglomeración y presentan uno o varios valores extremos, es mejor que opte por un ajuste dedistrubición
               de poisson.", align = "left")
            

    ),
    
    
    #################################################################################
    #################################################################################
    #                                  Muestreo                                     #
    #################################################################################
    #################################################################################
    
    tabItem(tabName = "p3",
                       
                       
                       h1("Muestreo ", align = "center"),
            br(),
            h2("En este sección:", align = "left"),
            br(),
            h4("Se lleva a cabo el proceso de muestreo: tamaño y selección de la unidaddes", align ="left"),
            br(),
            h4("Cargado los datos, usted podrá:"),
            br(),
            tags$ul(
              style = "list-style-type: disc; padding-left: 20px;",  # Estilo para la lista: disc es una viñeta redonda
              tags$li(h4("Calcular el tamaño de muestra.", align = "left")),
              tags$li(h4("Visualizar las unidades selecciondas.", align = "left",)),
              tags$li(h4("Comprar la los datos cargados vs los datos obtenidos por la muestra.", align = "left")),
              tags$li(h4("Descargar los datos de la muestra en formato, ya sea .csv, .txt y .xlsx", align = "left"))
            ),
            br(), 
            
            h3("Cargar datos", align = "left"),
                       br(),
                       fileInput("file2", "Importar datos del muestreo",
                                 accept =  c(
                                   ".csv",
                                   ".txt",
                                   ".xlsx",
                                   "text/csv",
                                   "text/plain",
                                   "text/tab-separated-values",
                                   "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
                                 )),
                       br(),
                       uiOutput("variable_select"),
                       br(),
            #           plotOutput("histogram2"),
                       h2("Muestreo: tamaño y selección", align = "left"),
                       br(),
                       h4("El proceso de muestreo consta de dos etapas: selección del tamaño de la muestra y la selección de las unidades",align = "left"),
                       h4("Se aborda primeramente la determinación del tamaño de la muestra. Se deberán seleccionar el tamaño según la elección de los parámetros de erores tolarebles, esperados u nivel de confianza."),  
                       h4("La selección de las unidades para completar el tamaño de muestra, se visualiza en términos de una tabla. Se aplicó el método de selección Proporcional Por Tamaño, la cual brinda mayor probabilidad de ser seleccinadas a las unidades con montos mayores."),
                       br(),
                       h3("Cálculo de tamaño de muestra"),
                       br(),
                       h4("Cuando estás determinando el tamaño de una muestra para tu estudio, hay varios factores clave a considerar
                          que influyen directamente en la cantidad de datos que necesitas recolectar:",align = "left"),
                       br(),
                       h4("Margen de Tolerancia (Tolerable): Este valor representa el máximo error de estimación que estás dispuesto a aceptar
                          en tus resultados. Un margen mayor sugiere que estás tolerando una mayor incertidumbre, lo que puede resultar en una
                          muestra más pequeña. En contraste, un margen más ajustado requiere una muestra más grande para garantizar que tus estimaciones
                          estén dentro de ese rango estrecho.",align = "left"),
                       h4("Error Esperado (Esperado): Este es el error que anticipas podría existir en tu población. Un valor más alto implica que esperas
                          más variabilidad en los datos, lo que se traduce en necesitar una muestra más grande para obtener estimaciones precisas.",align = "left"),
                       h4("Nivel de Confianza: Cuanto mayor sea el nivel de confianza que desees tener en los resultados de tu muestra, mayor deberá
                          ser el tamaño de la misma. Esto se debe a que un nivel de confianza más alto indica que quieres estar más seguro de que tu 
                          muestra representa correctamente a toda la población.",align = "left"),
                       
                       br(),
                       h3("Tabla de Referencia para Tamaño de Muestra",align = "left"),
            
            fluidRow(
              box(
                title = "Tabla de Datos",
                status = "primary",
                solidHeader = TRUE,
                collapsible = TRUE,
                width = 8,  # Ocupará todo el ancho disponible
                div(style = "height: 180px;",  # Establece el alto de la tabla
                    reactableOutput("SugerenciasTamaño")
              )
              )
            ),
            
                       br(),
                       h4("Utilizando los controles deslizantes de tu aplicación, los usuarios pueden ajustar estos parámetros para determinar un tamaño 
                          de muestra que sea adecuado para sus necesidades específicas. A continuación, se muestra una tabla de referencia actualizada que
                          podría ayudar a los usuarios a entender cómo estos ajustes podrían influir en el tamaño de la muestra requerido:",align = "left"),
                       br(),
                        
                       h4("Nota:",align = "left"),
            
                       sliderInput("freq1",
                                   "Tolerable:",
                                   min = 0.01,  max = 0.99, value = 0.05),
                       sliderInput("freq2",
                                   "Esperado:",
                                   min = 0.01,  max = 0.99, value = 0.01), 
                       selectInput("distri", "Seleccione el nivel:",  
                                   list(`Tipo` = list("poisson",
                                                      "binomial"
                                                      
                                   )
                                   )
                       ),
                       sliderInput("freq3",
                                   "Nivel de confianza:",
                                   min = 0.01,  max = 0.99, value = 0.95),
                       br(),
                       actionButton("update", "Análsis del muestreo.", class = "btn-primary"),
                       hr(),
                       fluidRow(
                         box(
                           solidHeader = TRUE, 
                           width = 12,
                           reactableOutput("SampleSize")  
                         )
                       ),
                       br(),
                       br(),
                       fluidRow(
                         box(
                           solidHeader = TRUE, 
                           width = 12,
                           reactableOutput("sample")  
                         )
                       ),
                       br(),
            #################################################
            #    Comparación de datos originales y muestra  #
            #################################################
                       
                  h3("Comprarción de datos cargados vs muestra seleccionada"),
                  br(),
            fluidRow(
              box(
                title = "Comparación de distribuciones entre datos cargados y las unidaddes seleccionadas a partir de la muestra de datos",
                status = "primary",
                solidHeader = TRUE,
                collapsible = TRUE,
                width = 8,
                highchartOutput("comp_dist")  
              )
            ),
            
                       #################################
                       #         Descargar muestra     #
                       #################################
                       
                       h3("Descargar la muestra seleccionada"),
                       br(),
                       actionButton("show1", "Descargar archivo")
  ),
  
  #################################################################################
  #################################################################################
  #                                  Evaluación                                   #
  #################################################################################
  #################################################################################
  
  tabItem(tabName = "p4",
          
          
          h1("Evalución de la auditoría.", align = "center"),
          br(),
          h2("En este sección:", align = "left"),
          br(),
          h4("Cargado los datos, usted podrá:"),
          br(),
          tags$ul(
            style = "list-style-type: disc; padding-left: 20px;",  # Estilo para la lista: disc es una viñeta redonda
            tags$li(h4("Comparar la información de los datos observados vs los datos auditados.", align = "left")),
            tags$li(h4("Indicadores de riesgo en le proceso de comparación entre la información de los datos observados vs los datos auditados.", align = "left",)),
            tags$li(h4("Criterio empírico sobre el proceso de evaluación de la muestra por unidades monetarias.", align = "left"))
          ),
          br(), 
          
          h3("Cargar datos", align = "left"),
          br(),
          h3("Seleccionar el archivo a evaluar."),
          fileInput("file3", "Importar datos para la evaluación del muestreo.",
                    accept =  c(
                      ".csv",
                      ".txt",
                      ".xlsx",
                      "text/csv",
                      "text/plain",
                      "text/tab-separated-values",
                      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
                    )),
          h3("Seleccionar los parametros para la evaluación de los valores observados y auditados."),
          br(),
          #      sliderInput("freq20",
          #            "Tolerable:",
          #            min = 0.01,  max = 0.99, value = 0.05),
     #     selectInput("method", "Seleccione el método de evaluación:",  
     #                 list(`Tipo` = list( "poisson", 
     #                                      "binomial"
     #                  )
     #                  )
     #      ),
     #      sliderInput("freq21",
     #                  "Nivel de confianza:",
     #                  min = 0.01,  max = 0.99, value = 0.95),
          
          uiOutput("var1"),
          uiOutput("var2"),
          br(),
          actionButton("analizar", "Evaluación", class = "btn-primary"),
          br(),
          h2("Comparar la información de los datos observados vs los datos auditados."),
          br(),
          fluidRow(
            box(
              title = "Tabla de Datos",
              status = "primary",
              solidHeader = TRUE,
              collapsible = TRUE,
              width = 8,  # Ocupará todo el ancho disponible
              div(style = "height: 400px;",  # Establece el alto de la tabla
                  reactableOutput("Tabla2"))
            ),
            div(style = "height: 30px;"),  # Espacio entre los boxes
            box(
              title = "Gráfico de Dispersión",
              status = "primary",
              solidHeader = TRUE,
              collapsible = TRUE,
              width = 8,  # Ocupará todo el ancho disponible
              highchartOutput("ScatterPlot", height = "400px")  # Establece el alto del gráfico Highcharter
            ),
            box(
              title = "Diferencias",
              status = "primary",
              solidHeader = TRUE,
              collapsible = TRUE,
              width = 8,  # Ocupará todo el ancho disponible
              div(style = "height: 400px;",  # Establece el alto de la tabla
                  reactableOutput("Tabla3"))
            )
            
          )
          
          
          ,
          br(),
          h2("Indicadores de riesgo en la comparación de la información de los datos observados vs los datos auditados."),
          br(),
          fluidRow(
             box(
                title = "Indicados de riesgo de evaluación",
                status = "primary",
             solidHeader = TRUE,
         collapsible = TRUE,
         width = 8,  # Ocupará todo el ancho disponible
         div(style = "height: 400px;",  # Establece el alto de la tabla
             reactableOutput("Riesgo"))
                ),
         box(
           title = "Indicados de riesgo de evaluación",
           status = "primary",
           solidHeader = TRUE,
           collapsible = TRUE,
           width = 8,  # Ocupará todo el ancho disponible
           div(style = "height: 400px;",  # Establece el alto de la tabla
               reactableOutput("Audit"))
         )
         
             ),
          br(),
          h2("Criterio empírico de evaluación de la muestra auditada."),
          br()
          
  )
  )
  
  
)