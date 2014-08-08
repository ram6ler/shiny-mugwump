# Mugwump
library(shiny)
shinyUI(
  fluidPage(
    fluidRow(
      column(
        width = 12,
        #h1("Mugwump!")
        img(
          src = "banner.png", 
          style = "display: block;margin-left: auto;margin-right: auto"
        )
      )  
    ),
    fluidRow(
      column(
        width = 4,
        h3("Instructions", style = "color: gray"),
        HTML(
          paste(
            "<div style = \"",
            "border: 2px solid #a1a1a1;",
            "padding: 15px 15px;", 
            "background: #eeeeee;",
            "border-radius: 25px;",
            "text-align: justify;",
            "\">",
            "<p>Four mugwumps are hiding on a 10 x 10 grid. Try to find them all",
            "by guessing their <em>x</em> and <em>y</em> coordinates!",
            "After each guess, the distance between your guess and each",
            "mugwump will be recorded and triangulation plots will be added",
            "to help you find all the mugwumps!</p><p>For a slightly more",
            "involved game, try playing with plot colours hidden.</p><p>",
            "You only get six guesses, so make them count!</p>",
            "</div>",
            sep = " "
          )
        ),
        br(),
        h3("Message", style = "color: gray"),
        htmlOutput(
          outputId = "blurb"
        ),
        h3("Guesses", style = "color: gray"),
        tableOutput(
          outputId = "history"
        ),
        HTML(
          paste(
            "<div style = \"",
            "border: 2px solid #a1a1a1;",
            "padding: 15px 15px;", 
            "background: #eeeeee;",
            "border-radius: 25px;",
            "text-align: justify;",
            "\">",
            "<em>Shiny Mugwump</em> by Richard Ambler, August 2014;",
            "based on <em>Mugwump</em> by Bob Albrecht and Bud Valenti as it",
            "appeared in <a href = 'http://atariarchives.org/basicgames/'>",
            "BASIC Computer Games</a> (edited by David Ahl, 1978; now hosted at",
            "<a href = 'http://atariarchives.org'>atariarchives.org</a>).",
            "</div>",
            sep = " "
          )
        )
      ),
      column(
        width = 8,
        plotOutput(
          outputId = "board",
          width = "800px",
          height = "800px",
          clickId = "mouseClick"
        ),
        checkboxInput(
          inputId = "blackWhite",
          label = "Hide Plot Colours!",
          value = FALSE
        )
      )
    )
  )  
)