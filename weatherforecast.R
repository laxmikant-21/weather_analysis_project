library(shiny)
library(DT)
library(plotly)

ui <- fluidPage(
  tags$head(
    tags$style(HTML(
      "body {
        background: linear-gradient(135deg, #66b3ff, #f0f8ff);
        font-family: 'Arial, sans-serif';
        color: #333333;
        margin: 0;
        padding: 0;
      }
      .top-right-buttons {
        position: absolute;
        top: 20px;
        right: 20px;
        display: flex;
        gap: 15px;
      }
      .action-button {
        background: #4caf50;
        color: white;
        border: none;
        padding: 10px 20px;
        font-size: 1em;
        border-radius: 20px;
        cursor: pointer;
      }
      .action-button:hover {
        background: #388e3c;
      }
      .welcome-container {
        display: flex;
        justify-content: space-between;
        align-items: center;
        height: calc(100vh - 100px);
        padding: 40px;
      }
      .text-container {
        width: 100%;
        max-width: 600px;
        padding: 20px;
        background: rgba(255, 255, 255, 0.7);
        border-radius: 10px;
        box-shadow: 0px 4px 15px rgba(0, 0, 0, 0.2);
      }
      .welcome-header {
        font-size: 2.5em;
        color: #007acc;
        font-weight: bold;
        margin-bottom: 20px;
      }
      .welcome-text {
        font-size: 1.2em;
        color: #555555;
        margin-bottom: 20px;
        line-height: 1.6;
      }
      .more-explore-button {
        background: #ff9800;
        color: white;
        border: none;
        padding: 12px 25px;
        font-size: 1.2em;
        border-radius: 25px;
        cursor: pointer;
        transition: transform 0.2s ease;
      }
      .more-explore-button:hover {
        transform: scale(1.05);
      }
      .bottom-button-container {
        position: absolute;
        bottom: 30px;
        left: 30px;
        display: flex;
      }
      @media (max-width: 768px) {
        .welcome-container {
          flex-direction: column;
          align-items: center;
        }
        .text-container {
          margin-bottom: 30px;
        }
      }"
    ))
  ),
  
  tabsetPanel(
    id = "main_tabs",
    tabPanel(
      "Home",
      div(
        class = "welcome-container",
        div(
          class = "text-container",
          h1(class = "welcome-header", "Welcome to the Weather Analysis App!"),
          p(class = "welcome-text", "This application helps users explore and understand weather data with ease. 
              You can upload your own CSV file and dive into trends, create clear visualizations, and even forecast future weather. 
              It offers simple tools to create charts, graphs, and other visuals to highlight key details like temperature, humidity, and air quality. 
              The forecasting feature uses smart models to predict what’s coming, helping you plan ahead. 
              Whether you’re a weather enthusiast, student, or professional, this tool makes analyzing and understanding weather data simple and intuitive."),
          actionButton("more_explore", "More Explore", class = "more-explore-button")
        )
      ),
      
      conditionalPanel(
        condition = "input.main_tabs === 'Home'",
        div(
          class = "top-right-buttons",
          actionButton("about_us", "About Us", class = "action-button"),
          actionButton("contact", "Contact", class = "action-button")
        )
      )
    ),
    
    tabPanel(
      "Explore",
      fluidPage(
        h2("Explore Weather Data"),
        p("Here you can dive deeper into weather patterns, trends, and forecasts."),
        div(
          class = "top-right-buttons",
          actionButton("back_home", "Back to Home", class = "action-button")
        ),
        fileInput("file_upload", "Upload CSV File", accept = c(".csv")),
        conditionalPanel(
          condition = "output.fileUploaded",
          selectInput("explore_options", "What Would You Like to Explore?", 
                      choices = c("Select", "Data View", "Visualization", "Forecast")),
          uiOutput("selected_option")
        )
      )
    ),
    
    tabPanel(
      "Visualization",
      fluidPage(
        h2("Visualization Options"),
        p("Here you can create and view various weather visualizations."),
        sidebarLayout(
          sidebarPanel(
            selectInput("pie_col", "Select Column for Pie Chart:", choices = NULL),
            selectInput("hist_col", "Select Numeric Column for Histogram:", choices = NULL),
            selectInput("x_col", "Select X-axis Column for Line Chart:", choices = NULL),
            selectInput("y_col", "Select Y-axis Column for Line Chart:", choices = NULL),
            actionButton("go_to_3d", "Go to 3D Visualization", class = "action-button")
          ),
          mainPanel(
            tabsetPanel(
              tabPanel("Pie Chart", plotlyOutput("pie_chart")),
              tabPanel("Histogram", plotlyOutput("histogram")),
              tabPanel("Line Chart", plotlyOutput("line_chart"))
            )
          )
        ),
        div(
          class = "top-right-buttons",
          actionButton("back_visualization", "Back", class = "action-button")
        )
      )
    ),
    
    tabPanel(
      "3D Visualization",
      fluidPage(
        h2("3D Visualization"),
        p("Here you can view the 3D scatter plot of your data."),
        sidebarLayout(
          sidebarPanel(
            selectInput("x_3d_col", "Select X-axis Column for 3D Chart:", choices = NULL),
            selectInput("y_3d_col", "Select Y-axis Column for 3D Chart:", choices = NULL),
            selectInput("z_3d_col", "Select Z-axis Column for 3D Chart:", choices = NULL)
          ),
          mainPanel(
            plotlyOutput("scatter_3d")
          )
        ),
        div(
          class = "top-right-buttons",
          actionButton("back_3d", "Back", class = "action-button")
        )
      )
    ),
    
    tabPanel(
      "Forecast",
      fluidPage(
        h2("Forecasting Options"),
        p("Here you can forecast future weather trends."),
        p("Forecasting tools will be displayed here."),
        div(
          class = "top-right-buttons",
          actionButton("back_forecast", "Back", class = "action-button")
        )
      )
    )
  )
)

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