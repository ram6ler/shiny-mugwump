# Mugwump
shinyServer(
  func = function(input, output) {
    source("mugwump.R")
    output$board <- renderPlot(
      expr = {
        if (guessNumber < 6) {
          if (!is.null(input$mouseClick$x)) {
            as.integer(round(input$mouseClick$x))
            dummy.mouse.X <- as.integer(round(input$mouseClick$x))
            dummy.mouse.Y <- as.integer(round(input$mouseClick$y))
            if (
              dummy.mouse.X >= 0
              && dummy.mouse.X <= 10
              && dummy.mouse.Y >= 0
              && dummy.mouse.Y <= 10
              && !all(mugwump.found)
            ) {
              if (dummy.mouse.X != mouse.X || dummy.mouse.Y != mouse.Y) {
                guessNumber <<- guessNumber + 1
                mouse.X <<- dummy.mouse.X
                mouse.Y <<- dummy.mouse.Y
                updateHistory(mouse.X, mouse.Y)
                checkIfAnyMugwumpsFound()
              }
            }
          }
        }
        output$history <- renderTable(expr = history)
        output$blurb <- renderText(blurb)
        drawBoard(!input$blackWhite)
        #print(input$blackWhite)
        drawCircles(!input$blackWhite)
        drawMugwumps(!input$blackWhite)
      }
    )
  }
)