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