server <- function(input, output, session) {
  uploaded_data <- reactiveVal(NULL)
  
  observeEvent(input$file_upload, {
    req(input$file_upload)
    dataset <- read.csv(input$file_upload$datapath)
    uploaded_data(dataset)
    updateSelectInput(session, "pie_col", choices = names(dataset))
    updateSelectInput(session, "hist_col", choices = names(dataset))
    updateSelectInput(session, "x_col", choices = names(dataset))
    updateSelectInput(session, "y_col", choices = names(dataset))
    updateSelectInput(session, "x_3d_col", choices = names(dataset))
    updateSelectInput(session, "y_3d_col", choices = names(dataset))
    updateSelectInput(session, "z_3d_col", choices = names(dataset))
    output$fileUploaded <- reactive({ TRUE })
    outputOptions(output, "fileUploaded", suspendWhenHidden = FALSE)
  })
  
  output$selected_option <- renderUI({
    req(uploaded_data())
    if (input$explore_options == "Visualization") {
      updateTabsetPanel(session, "main_tabs", selected = "Visualization")
    }
    if (input$explore_options == "Data View") {
      tagList(h3("Data View"), DT::dataTableOutput("data_table"))
    }
  })
  
  output$data_table <- DT::renderDataTable({
    req(uploaded_data())
    DT::datatable(uploaded_data())
  })
  
  output$pie_chart <- renderPlotly({
    req(input$pie_col, uploaded_data())
    data <- uploaded_data()
    pie_data <- as.data.frame(table(data[[input$pie_col]]))
    names(pie_data) <- c("Category", "Count")
    plot_ly(
      pie_data,
      labels = ~Category,
      values = ~Count,
      type = "pie",
      textinfo = "none"  # Removes percentage and count values
    ) %>%
      layout(title = paste("Pie Chart for", input$pie_col))
  })
  
  output$histogram <- renderPlotly({
    req(input$hist_col, uploaded_data())
    data <- uploaded_data()
    plot_ly(
      data,
      x = ~data[[input$hist_col]],
      type = "histogram",
      hoverinfo = "none"  # Removes tooltips showing range and frequency
    ) %>%
      layout(title = paste("Histogram for", input$hist_col))
  })
  
  output$line_chart <- renderPlotly({
    req(input$x_col, input$y_col, uploaded_data())
    data <- uploaded_data()
    plot_ly(data, x = ~data[[input$x_col]], y = ~data[[input$y_col]], type = "scatter", mode = "lines") %>%
      layout(title = paste("Line Chart:", input$x_col, "vs", input$y_col))
  })
  
  output$scatter_3d <- renderPlotly({
    req(input$x_3d_col, input$y_3d_col, input$z_3d_col, uploaded_data())
    data <- uploaded_data()
    plot_ly(
      data,
      x = ~data[[input$x_3d_col]],
      y = ~data[[input$y_3d_col]],
      z = ~data[[input$z_3d_col]],
      type = "scatter3d",
      mode = "markers"
    ) %>%
      layout(
        title = paste("3D Scatter Plot:", input$x_3d_col, "vs", input$y_3d_col, "vs", input$z_3d_col),
        scene = list(
          xaxis = list(title = input$x_3d_col),
          yaxis = list(title = input$y_3d_col),
          zaxis = list(title = input$z_3d_col)
        )
      )
  })
  
  observeEvent(input$about_us, {
    showModal(modalDialog(
      title = "About Us",
      "This Weather Analysis App is designed to help users explore weather trends with ease. Whether you're a professional or an enthusiast, our tools empower you with actionable insights.",
      tags$div(
        tags$h3("Meet the Team"),
        tags$p("Laxmikant Sharma"),
        tags$p("Currently a B.tech Student"),
        tags$p("Branch: Data Science"),
        tags$br(),
        tags$p("Hansraj Gurjar"),
        tags$p("Currently a B.tech Student"),
        tags$p("Branch: Data Science")
      ),
      footer = modalButton("Close")
    ))
  })
  
  observeEvent(input$contact, {
    showModal(modalDialog(
      title = "Contact Us",
      tags$div(
        tags$p("For inquiries, please reach out to us via:"),
        tags$p("Email: Laxhans@weather.com"),
        tags$p("Phone: +123-456-7890")
      ),
      footer = modalButton("Close")
    ))
  })
  
  
  observeEvent(input$more_explore, {
    updateTabsetPanel(session, "main_tabs", selected = "Explore")
  })
  
  observeEvent(input$back_home, {
    updateTabsetPanel(session, "main_tabs", selected = "Home")
  })
  
  observeEvent(input$back_visualization, {
    updateTabsetPanel(session, "main_tabs", selected = "Explore")
  })
  
  observeEvent(input$go_to_3d, {
    updateTabsetPanel(session, "main_tabs", selected = "3D Visualization")
  })
  
  observeEvent(input$back_3d, {
    updateTabsetPanel(session, "main_tabs", selected = "Visualization")
  })
  
  observeEvent(input$back_forecast, {
    updateTabsetPanel(session, "main_tabs", selected = "Visualization")
  })
}

shinyApp(ui = ui, server = server)