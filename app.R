library(shiny)
library(learnPopGen)

ui<-fluidPage(
  h3("Ishihara Colorblindness Test",align="center"),
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId="plate",label="Choose plate to show",
        choices=c("Plate 1 (demo plate)","Plate 2","Plate 9"),selected="Plate 9"),
      sliderInput(inputId="transparency",label="Percent transparency (100% to reveal hidden pattern)",
        min=0,max=100,value=0,ticks=FALSE),
      textInput(inputId="value",label="What value do you see?",
        value=""),
      h4("Instructions:\n"),
      p("Change transparency level to reveal the pattern 
        that should be visible if you have normal color vision.\n\n"),
      strong("For best usage, reset transparency level before changing plates.\n\n"),
      h4("Details:\n"),
      p("Prototype web application for the ishihara R package 
        (Revell & Revell, 2019)."),
      width=3
    ),
    mainPanel(
      plotOutput("plot",width="650px",height="650px")
    ),
  position="left")
)

server <- function(input, output, session) {
  observeEvent(input$plate, {
    updateSliderInput(session,"transparency",value=0)
  })
  output$plot<-renderPlot({
    input$newplot
    require(ishihara)
    if(input$plate=="Plate 1 (demo plate)"){
        data(plate1)
        plate<-plate1

    } else if(input$plate=="Plate 2"){
        data(plate2)
        plate<-plate2

    } else if(input$plate=="Plate 9"){
        data(plate9)
        plate<-plate9
    }
    plot(plate,alpha=1-input$transparency/100,
         mar=rep(0.1,4))
  })
}

shinyApp(ui = ui, server = server)
