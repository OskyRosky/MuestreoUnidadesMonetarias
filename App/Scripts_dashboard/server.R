############################
#   Contenido del server   # 
############################


###################################################################################
# El server se estructura como sigue                                              #
#                                                                                 #
# 1. Importación de los datos                                                     #
# 2. Análisis descriptivos de las variables de interés                            #
# 3. Cálculo del tamaño de muestra según la selección hecha en el body            #
# 4. Visualización de la selección de los elementos                               #
# 5. Descarga de las unidades de la muestra                                       #
# 6. Evaluación de la muestra según datos observados y auditados                  #
#                                                                                 #
###################################################################################

server <- function(input, output, session) {
  
  #################################################################################
  #################################################################################
  #                           Análisis descriptivo                                #
  #################################################################################
  #################################################################################
  
  ################################################
  #          Importar Datos: data                #
  ################################################
  
  
  # Leer los datos basados en el tipo de archivo
  
  data1 <- reactive({
    inFile <- input$file1
    
    if (is.null(inFile)) return(NULL)
    
    ext <- tools::file_ext(inFile$name)
    
    if (ext == "xlsx") {
      openxlsx::read.xlsx(inFile$datapath)
    } else if (ext == "csv") {  # Corregido aquí
      read.csv(inFile$datapath, stringsAsFactors = FALSE)
    } else if (ext == "txt") {  # Y aquí
      read.table(inFile$datapath, stringsAsFactors = FALSE, header = TRUE)
    } else {
      stop("Archivo no soportado.")
    }
  })
  
  # Selección de la variable
  
  output$variable_select_1 <- renderUI({
    if (is.null(data1())) {
      return(NULL)
    } else {
      selectInput("variable1", "Elija una variable:", names(data1()))
    }
  })
  

  # Genera datos binomiales
  n_binom <- 10000  # Número de observaciones
  size <- 100       # Número de ensayos
  prob <- 0.5       # Probabilidad de éxito
  datos_binom <- rbinom(n_binom, size, prob)
  
  # Genera datos de Poisson
  n_pois <- 10000  # Número de observaciones
  lambda <- 40     # Tasa promedio de éxito
  set.seed(123)    # Para reproducibilidad
  outliers <- c(sample(80:100, size = 10, replace = TRUE)) # Genera algunos valores extremos
  datos_pois_extremos <- c(rpois(n_pois, lambda), outliers)
  

    observeEvent(input$start_analysis, {
        # Tabla de estadísticas descriptivas
      
      
      
        output$stats <- renderReactable({
            req(data1())
          
          
          Datos <- as.data.frame(data1()[[input$variable1]])  %>% 
            dplyr::rename(
              Monto = `data1()[[input$variable1]]`
              
            )
          
          
          Stats <- Datos %>%
            
            summarise(  ValoresNegativos = sum(Monto < 0, na.rm = TRUE),
                        ValoresFaltantes = sum(is.na(Monto)),
                        Minimo = min(Monto, na.rm = TRUE),
                        Maximo = max(Monto, na.rm = TRUE),
                        Promedio = mean(Monto, na.rm = TRUE),
                        Mediana = median(Monto, na.rm = TRUE),
                        Moda = as.numeric(names(sort(table(Monto), decreasing = TRUE)[1])),
                        DesviacionEstandar = sd(Monto, na.rm = TRUE),
                        Percentil10 = quantile(Monto, 0.1, na.rm = TRUE),
                        Percentil25 = quantile(Monto, 0.25, na.rm = TRUE),
                        Percentil50 = quantile(Monto, 0.50, na.rm = TRUE),
                        Percentil75 = quantile(Monto, 0.75, na.rm = TRUE),
                        Percentil90 = quantile(Monto, 0.90, na.rm = TRUE)
                        
                        
                        
            ) %>% pivot_longer(
              cols = everything(),
              names_to = "Medida",
              values_to = "Valor"
            )  %>%
            mutate(Valor = round(Valor, 1))
          
          
          
          reactable(Stats, defaultPageSize = 15)
        })

        
        
        # Histograma de una variable
        output$histogram1 <- renderHighchart({
          
            req(data1(), input$variable1)
          
          
          req(input$variable1)
          
          datos <- as.data.frame(data1()[[input$variable1]])  %>% 
            dplyr::rename(
              Monto = `data1()[[input$variable1]]`
              
            )
          
          x = datos$Monto
          
          hist <-  hchart(density(x), type = "area", color = "skyblue", name = "Monto")  %>%
            
            hc_tooltip(crosshairs = T,valueDecimals = 1, shared = TRUE, borderWidth = 5) %>%
            hc_chart(
              zoomType = "xy"
            )
          
          hist 
        })

        
        
        # Gráfico binomial
        output$binomialPlot <- renderPlot({
          
          ggplot(data.frame(Valor = datos_binom), aes(x = Valor)) +
            geom_histogram(binwidth = 1, fill = 'skyblue', color = 'black') +
            labs(title = "Distribución Binomial", x = "", y = "Frecuencia")
          
        })
        
        

        # Gráfico de Poisson
        output$poissonPlot <- renderPlot({
          
          ggplot(data.frame(Valor = datos_pois_extremos), aes(x = Valor)) +
            geom_histogram(bins = 120, fill = 'skyblue', color = 'black') +
            labs(title = "Distribución de Poisson con valores extremos",
                 x = "", y = "Frecuencia")
          
        })
    })

    # ... (cualquier otro código que necesites)



  
  #################################################################################
  #################################################################################
  #                                  Muestreo                                     #
  #################################################################################
  #################################################################################
  
  
  ##############################
  #          Importar Datos    #
  ##############################
  
  # Data la volvemos un objeto reactivo 
  #  data ---> data()
  
  data2 <- reactive({
    inFile <- input$file2
    if (is.null(inFile)) {
      return(NULL)
    }
    read.csv(inFile$datapath)
  })
  
  
  # Histograma de una variable #
  
  output$variable_select <- renderUI({
    if (is.null(data2())) {
      return(NULL)
    } else {
      selectInput("variable2", "Elija una variable:", names(data2()))
    }
  })
  
  # Datos para la tabla de sugerencias de tamaño de muestra
  sugerencias_tamaño <- data.frame(
    `Tamaño de Muestra` = c("Pequeño (<=40)", "Mediano (50-100)", "Grande (100-400)"),
    `Margen de Tolerancia (Tolerable)` = c("0.2 - 0.3", "0.03 - 0.05", "0.01 - 0.03"),
    `Error Esperado` = c("0.05 - 0.10", "0.02 - 0.05", "0.01 - 0.02"),
    `Nivel de Confianza` = c("0.90 - 0.95", "0.95 - 0.99", "> 0.99")
  )
  
  # Genera la tabla reactiva
  output$SugerenciasTamaño <- renderReactable({
    reactable(sugerencias_tamaño, bordered = TRUE, highlight = TRUE)
    
    
  })
  
  
  # output$histogram2 <- renderPlot({
  #  if (is.null(input$variable)) {
  #    return(NULL)
  #  }
  #  ggplot(data(), aes_string(input$variable)) + geom_histogram(binwidth = 10) + labs(title = paste("Distribución de", input$variable), x = input$variable, y = "Frecuencia")
  # })
  
  
  #################################
  #    Cálculo tamaño muestra     #
  #################################
  
  # Objeto reactivo para el tamaño de muestra
  sample_size <- reactiveVal()  # Inicializa como un valor reactivo
  
  observeEvent(input$update, {  # Cuando 'update' se presiona, se ejecuta el código dentro de observeEvent
    stage1 <- planning(materiality = input$freq1, 
                       expected = input$freq2,
                       likelihood = input$distri, 
                       conf.level = input$freq3
    )
    
    sample_size(data.frame(`Muestra` = stage1$n))  # Asigna el valor al reactivo
  })
  
  # Renderizar la tabla de tamaño de muestra
  output$SampleSize <- renderReactable({
    req(sample_size())  # Asegúrate de que el valor reactivo no sea NULL
    reactable(sample_size())  # Renderiza el valor reactivo en una tabla
  })
  
  
  
  #################################
  #    Visualización de la tabla  #
  #################################
  
  # Objeto reactivo para la selección de las unidades
  Muestra <- reactive({
    req(input$update)  # Asegúrate de que el botón de actualizar se ha pulsado
    req(sample_size())  # Asegúrate de que el valor reactivo no sea NULL
    
    n_muestra <- sample_size()$Muestra
    datos <- data2()
    
    # Asegúrate de que hay datos para procesar
    if (is.null(datos) || is.null(n_muestra)) {
      return(NULL)
    }
    
    # Calcula las probabilidades de selección
    total_valor <- sum(datos[[input$variable2]], na.rm = TRUE)
    if (total_valor == 0) return(NULL)  # Evita división por cero
    
    prob_seleccion <- datos[[input$variable2]] / total_valor
    
    # Selecciona las unidades de la muestra según sus probabilidades
    set.seed(123)  # Establece una semilla para reproducibilidad
    muestra_ids <- sample(
      x = seq_len(nrow(datos)), 
      size = n_muestra, 
      replace = FALSE, 
      prob = prob_seleccion
    )
    
    # Devuelve las filas seleccionadas para la muestra
    datos[muestra_ids, ]
  })
  
  
  output$sample  <- renderReactable({
    
    req(Muestra())  # Asegúrate de que el objeto reactivo no sea NULL
    reactable(Muestra())  # Renderiza el objeto reactivo en una tabla
  })

  
  #################################################
  #    Comparación de datos originales y muestra  #
  #################################################
  

  
  

  #################################
  #         Descargar muestra     #
  #################################
  
  observeEvent(input$show1, {
    
    showModal(modalDialog(
      title = "Descargar los datos ", br(),
      br(),
      downloadButton("download2.1",".csv file"),
      br(),
      br(),
      downloadButton("download2.2",".txt file"),
      br(),
      br(),
      downloadButton("download2.3",".xlsx file"),
      
      footer = modalButton("Close"),
      easyClose = TRUE)
    )
    
  })
  
  output$download2.1 <- downloadHandler(
    
    
    filename = function() {
      paste("Muestra-", Sys.Date(), ".csv", sep="")
    },
    
    content = function(file) {
      write.csv(Muestra(), file)
    }
  )
  
  output$download2.2 <- downloadHandler(
    
    filename = function() {
      paste("Muestra-", Sys.Date(), ".txt", sep="")
    },
    content = function(file) {
      write.table(Muestra(), file)
    }
  )
  
  output$download2.3 <- downloadHandler(
    filename = function() {
      paste("Muestra-", Sys.Date(), ".xlsx", sep="")
    },
    content = function(file) {
      # Suponiendo que Muestra() es una función que retorna el dataframe que quieres descargar
      write.xlsx(Muestra(), file)
    }
  )
  
  
  #################################################################################
  #################################################################################
  #                                  Evaluación                                   #
  #################################################################################
  #################################################################################
  
  ###### Datos a reactive 
  
  data3 <- reactive({
    inFile <- input$file3
    if (is.null(inFile)) {
      return(NULL)
    }
    read.csv(inFile$datapath)
  })
  
  
  ###### Variables
  
  output$var1 <- renderUI({
    selectInput("select_var1", "Seleccione Variable 1:", names(data3()))
  })
  
  output$var2 <- renderUI({
    selectInput("select_var2", "Seleccione Variable 2:", names(data3()))
  })
  
  
  
  ###### Aplicar el boton activar 
  
  

  observeEvent(input$analizar, {
  
    
    
    # Para la tabla reactable
    output$Tabla2 <- renderReactable({
      req(input$select_var1, input$select_var2)  # Asegurarse de que las entradas estén disponibles
      # Asegúrate de que los nombres de las columnas existan en data2()
      Datos <- data3() %>%
        dplyr::rename(
          Observado = input$select_var1,
          Auditado = input$select_var2
        )
      reactable(Datos)
    })
    
    
    output$ScatterPlot <- renderHighchart({
      # Asegúrate de que las entradas estén disponibles
      req(input$select_var1, input$select_var2)
      
      # Asegúrate de que los nombres de las columnas existan en data2()
      Datos <- data3() %>%
        dplyr::rename(
          Observado = input$select_var1,
          Auditado = input$select_var2
        )
      
      # Crear el gráfico de dispersión con Highcharter
      
      hc <- Datos %>% 
                hchart('scatter', hcaes(x = Observado, y = Auditado))
      
      
      hc
      
      
    })
    
    
    
  })
  
  
  # Structura #
  
  
  observeEvent(input$analizar, {
    output$eval <- renderPrint({
      
      stage4 <- evaluation(
        materiality = 0.03, 
        method = "stringer",
        conf.level = 0.95, 
        data = data2(),
        values = input$select_var1,
        values.audit = input$select_var2
      )
      
      summary(stage4)
      
    })
  })
  
}