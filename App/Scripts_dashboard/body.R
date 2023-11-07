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
            br(),
            h2("Introducción", align = "left"),
            br(),
            h4("Bienvenido a nuestra aplicación Shiny especializada en el análisis de muestras para unidades financieras. Esta herramienta interactiva
               ha sido meticulosamente diseñada para facilitar la evaluación y el manejo de datos financieros, optimizando así el proceso de toma de 
               decisiones y el análisis de auditoría." ,align = "left"),
            br(),
            br(),
            h2("Estructura de la Aplicación", align = "left"),
            br(),
            h4("La aplicación se divide en tres módulos principales, cada uno enfocado en un aspecto crítico del análisis de datos:",align = "left"),
            br(),
            h4("1. Análisis Descriptivo",align = "left"),
            h4("2. Proceso de Muestreo",align = "left"),
            h4("3. Evaluación de la Muestra",align = "left"),
            h4("A continuación, exploramos en detalle cada uno de estos módulos.",align = "left"),
            br(),
            br(),
            h2("Análisis Descriptivo", align = "left"),
            br(),
            h4("Antes de embarcarnos en el muestreo, es esencial comprender el conjunto de datos con el que trabajaremos. En el módulo de Análisis Descriptivo, los usuarios pueden:",align = "left"),
            br(),
            h4("Inspeccionar las características fundamentales del conjunto de datos a través de estadísticas descriptivas.",align = "left"),
            h4("Detectar y abordar anomalías como datos faltantes o valores atípicos que podrían comprometer la calidad del análisis.",align = "left"),
            h4("Detectar y abordar anomalías como datos faltantes o valores atípicos que podrían comprometer la calidad del análisis.",align = "left"),
            br(),
            br(),
            h2("Proceso de Muestreo", align = "left"),
            br(),
            h4("Tras un entendimiento completo del conjunto de datos, procedemos al Proceso de Muestreo. Esta etapa consta de:",align = "left"),
            br(),
            h4("La determinación del tamaño de la muestra, utilizando técnicas estadísticas que garanticen la representatividad.", align = "left"),
            h4("La selección aleatoria de las unidades de muestreo que serán analizadas, siguiendo el tamaño de muestra definido.", align = "left"),
            br(),
            br(),
            h2("Evaluación de la Muestra", align = "left"),
            br(),
            h4("El último módulo, Evaluación de la Muestra, es para obtener un contraste empírico sobre el resultado de la auditoria. Aquí:",align = "left"),
            br(),
            h4("Comparamos los resultados muestrales con los datos originales para evaluar su consistencia.", align = "left"),
            h4("Ofrecemos visualizaciones y tablas detalladas que facilitan la interpretación de los resultados.", align = "left"),
            h4("mplementamos pruebas empíricas que ayudan a detectar discrepancias o hallazgos relevantes para la auditoría.", align = "left"),
            br(),
            br(),
            h2("Sobre la carga de datos", align = "left"),
            br(),
            h4("Para cada uno de los módulos anteriores, deberá cargar un archivo de datos. La aplicación admite múltiples formatos incluyendo .xlsx, .txt y .csv. Tenga en cuenta que:",align = "left"),
            br(),
            h4("Cada archivo cargado debe contener una sola tabla.",align = "left" ),
            h4("Los datos deben estar limpios, listo para ser analizados.",align = "left" ),
            h4("El peso máximo permitido por archivo es de 100 megabytes, asegurando así la fluidez y eficiencia de la aplicación.",align = "left" ),
            br(),
            br(),
            h2("Inicie utilizando la App!", align = "left"),
            br(),
            h4("Para comenzar con la aplicación:",align = "left"),
            br(),
            h4("Cargar Datos: Utilice el botón de carga de archivos para subir su conjunto de datos en el formato adecuado.",align = "left"),
            h4("Navegación: Mueva entre los diferentes módulos utilizando las pestañas dispuestas en la interfaz de usuario.",align = "left"),
            h4("Análisis: Siga las instrucciones específicas en cada módulo para realizar el análisis deseado.",align = "left"),
            br(),
            br(),
            br(),
            br()
            
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
            h4("Poner una descipción del apartado", align ="left"),
            
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
            h3("Estadíticas descriptivas", align = "left"),
            reactableOutput("stats"), # Salida para la tabla de estadísticas   ---->  reactableOutput()
            br(),
            h3("Análisis de distribuciones", align = "left"),
            br(),                                                  # histogram1
            
            highchartOutput("histogram1"),
            # highchartOutput("histogramX"),
            
            # highchartOutput("histogram1"),

            h3("Comparación de Ajuste de Distribuciones", align = "left"),
            h4("Si posee datos aglomerados o consistentes en todo el rango de posibles valores, es mejor que opte por un ajuste Binomial. Caso contrario,
               datos que están muy alejados de la aglomeración y presentan uno o varios valores extremos, es mejor que opte por un ajuste dedistrubición
               de poisson. Por favor, guiarse según las siguientes gráficas de distrubución.", align = "left"),
            br(),
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
            )
            

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
            h4("Poner una descipción del apartado", align ="left"),
            
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
            #           plotOutput("histogram2"),
                       h2("Muestreo: tamaño y selección", align = "left"),
                       br(),
                       h4("Poner acá texto",align = "left"),
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
                width = 12,  # Ocupará todo el ancho disponible
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
                       actionButton("update", "Calcular"),
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
            
            #################################################
            #    Comparación de datos originales y muestra  #
            #################################################
                       
                  h3("Comprarción de datos vs muestra seleccionada"),
            
            
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
          h4("Poner una descipción del apartado", align ="left"),
          
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
          sliderInput("freq20",
                      "Tolerable:",
                      min = 0.01,  max = 0.99, value = 0.05),
          selectInput("method", "Seleccione el método de evaluación:",  
                      list(`Tipo` = list( "poisson", 
                                          "binomial",
                                          "hypergeometric",
                                          "stringer.poisson",
                                          "stringer.binomial", 
                                          "stringer.hypergeometric",
                                          "stringer.meikle",
                                          "stringer.lta", 
                                          "stringer.pvz",
                                          "rohrbach", 
                                          "moment", 
                                          "coxsnell", 
                                          "mpu",
                                          "direct",
                                          "difference", 
                                          "quotient", 
                                          "regression"
                      )
                      )
          ),
          sliderInput("freq21",
                      "Nivel de confianza:",
                      min = 0.01,  max = 0.99, value = 0.95),
          
          uiOutput("var1"),
          uiOutput("var2"),
          br(),
          actionButton("analizar", "Analizar Correlación"),
          br(),
          br(),

          fluidRow(
            box(
              title = "Tabla de Datos",
              status = "primary",
              solidHeader = TRUE,
              collapsible = TRUE,
              width = 12,  # Ocupará todo el ancho disponible
              div(style = "height: 400px;",  # Establece el alto de la tabla
                  reactableOutput("Tabla2"))
            ),
            box(
              title = "Gráfico de Dispersión",
              status = "primary",
              solidHeader = TRUE,
              collapsible = TRUE,
              width = 12,  # Ocupará todo el ancho disponible
              highchartOutput("ScatterPlot", height = "400px")  # Establece el alto del gráfico Highcharter
            )
          ),
          br(),
          h3("Evaluación en la comparación del valor observador vs valor auditado"),
          br(),
          br(),
          h3("Resumen de evaluación de muestras de auditoría "),
          verbatimTextOutput("eval"),
          br()
          
  )
  )
  
  
)