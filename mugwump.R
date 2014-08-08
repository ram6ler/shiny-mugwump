# Setup ########################################################################

box.start <- paste(
  "<div style = \"",
  "border: 2px solid #a1a1a1;",
  "padding: 15px 15px;", 
  "background: #eeeeee;",
  "border-radius: 25px;",
  "text-align: justify;",
  "\">",
  sep = ""
)

box.stop <- "</div>"


mugwump.col <- c("lightblue", "pink", "green", "orange")
mugwump.found <- rep(FALSE, 4)
mugwump.X <- sample(0:10, 4)
mugwump.Y <- sample(0:10, 4)

history <- data.frame(
  X = rep(NA, 6),
  Y = rep(NA, 6)
)

mouse.X <- -1
mouse.Y <- -1

for (m in 1:4) history[mugwump.col[m]] <- rep(NA, 6)

guessNumber <- 0

blurb <- sprintf(
  paste(
    "%sYou have six guesses with which to find four mugwumps!",
    "Make your first guess by clicking some point on the grid!%s",
    sep = " "
  ),
  box.start,
  box.stop
)

for (i in 2:4) {
  repeat {
    mugwump.Y[i] <- sample(0:10, 1)
    should.break <- TRUE
    for (j in 1:(i - 1)) 
      if (mugwump.X[j] == mugwump.X[i] && mugwump.Y[j] == mugwump.Y[i])
        should.break = FALSE
    if (should.break) break
  }
}

# Functions ####################################################################

# adjust the alpha level of a colour
col.alpha <- function(col, alpha) {
  alpha <- min(1, alpha)
  alpha <- max(0, alpha)
  prism <- col2rgb(col) / 255
  rgb(red = prism[1], green = prism[2], blue = prism[3], alpha = alpha)
}

# draw the grid on which the mugwumps are hiding
drawBoard <- function(withColours) {
  plot(
    0, 0,
    xlim <- c(-0.5, 10.5),
    ylim <- c(-0.5, 10.5),
    type = "n",
    xaxt = "n",
    yaxt = "n",
    xlab = "",
    ylab = ""
  )
  for (i in 0:10) {
    lines(c(0, 10), c(i, i), col = "darkgray")
    lines(c(i, i), c(0, 10), col = "darkgray")
  }
  axis(1, at = 0:10, labels = 0:10, tick = FALSE)
  axis(2, at = 0:10, labels = 0:10, tick = FALSE)
  points(
    history$X, 
    history$Y, 
    pch = 4, lwd = 3, 
    col = if (withColours) "red" else "black"
  )
  if (nrow(history) > 0 )
    text(
      history$X, history$Y + 0.5, 
      sprintf("Guess %s", row.names(history)),
      col = "darkgray",
      cex = 1.2
    )
}

# Draw the mugwumps
drawMugwumps <- function(withColours) {
  for (m in 1:4) {
    if (!mugwump.found[m]) next
    x <- mugwump.X[m]
    y <- mugwump.Y[m]
    # head
    polygon(
      c(
        x - 0.4, x - 0.4, x - 0.35, x + 0.35,
        x + 0.4, x + 0.4, x + 0.35, x - 0.35
      ),
      c(
        y - 0.25, y + 0.25, y + 0.3, y + 0.3,
        y + 0.25, y - 0.25, y - 0.3, y - 0.3
      ),
      col = if (withColours) mugwump.col[m] else "lightgray",
      lwd = 2
    )
    
    # eyes
    polygon(
      c(x - 0.35, x - 0.35, x - 0.05, x - 0.05),
      c(y, y + 0.25, y + 0.25, y),
      col = "white"
    )
    
    polygon(
      c(x + 0.05, x + 0.05, x + 0.35, x + 0.35),
      c(y, y + 0.25, y + 0.25, y),
      col = "white"
    )
    
    # pupils
    if (c(TRUE, FALSE)[sample(1:2, 1)]) {
      polygon(
        c(x - 0.2, x - 0.2, x - 0.05, x - 0.05),
        c(y, y + 0.15, y + 0.15, y),
        col = "black",
        border = NA
      )
      
      polygon(
        c(x + 0.2, x + 0.2, x + 0.35, x + 0.35),
        c(y, y + 0.15, y + 0.15, y),
        col = "black",
        border = NA
      )
    } else {
      polygon(
        c(x + 0.2, x + 0.2, x + 0.05, x + 0.05),
        c(y, y + 0.15, y + 0.15, y),
        col = "black",
        border = NA
      )
      
      polygon(
        c(x - 0.2, x - 0.2, x - 0.35, x - 0.35),
        c(y, y + 0.15, y + 0.15, y),
        col = "black",
        border = NA
      )
    }
  }
}

# triangulation plots
drawCircles <- function(withColours) {
  if (guessNumber > 0) {
    drawCircle <- function(m, rad, alpha, row) {
      x <- history$X[row]
      y <- history$Y[row]
      theta <- seq(0, 2 * pi, by = pi / 32)
      x0 <- x + rad * cos(theta)
      y0 <- y + rad * sin(theta)
      lines(
        x0, y0, 
        col = col.alpha(if (withColours) mugwump.col[m] else "black", alpha)
      )
    }
    for (r in 1:guessNumber) {
      alpha <- 0.2 + 0.8 * r / guessNumber
      for (m in 1:4) {
        d <- history[r, mugwump.col[m]]
        if (is.na(d)) next
        drawCircle(m, d, alpha, r)
      }
    }
  }
}

# hit check
checkIfAnyMugwumpsFound <- function() {
  r <- guessNumber
  words <- c("one", "two", "three", "four", "five", "six")
  temp.blurb <- if (r > 3) sprintf(
    "Only %s guess%s remaining!", 
    words[6 - r],
    if (r == 5) "" else "es"
  ) else sprintf(
    "You have %s guesses remaining!", 
    words[6 - r]
  )
  blurb <<- sprintf(
    "%s<b>No mugwumps at (%d, %d)!</b><br>%s%s", 
    box.start,
    history[r, "X"],
    history[r, "Y"],
    temp.blurb,
    box.stop
  )
    
  for (m in 1:4) {
    d <- history[r, mugwump.col[m]]
    if (is.na(d)) next
    if (d == 0) {
      mugwump.found[m] <<- TRUE
      blurb <<- sprintf(
        "%s<b>%s!</b> You found the <b><span style = \"color : %s\">%s mugwump</span></b>! <br>%s%s",
        box.start,
        c("Great job", "Yipee", "Whoohoo", "Yeah")[sample(1:4, 1)],
        mugwump.col[m],
        mugwump.col[m],
        temp.blurb,
        box.stop
      )
      break
    }
  }
  
  if (all(mugwump.found)) blurb <<- sprintf(
    paste(
      box.start,
      "<h4>Congratulations!</h4> You found all the mugwumps in %s guesses!<br>",
      "Thanks for playing! Refresh the page to play again!",
      box.stop,
      sep= ""
    ),
    words[r]
  ) else if (r == 6) blurb <<- sprintf(
    "%s%s<br>%s%s",
    box.start,
    sprintf(
      "<h4>Too bad!</h4> %s!",
      if (sum(mugwump.found) == 0) "You didn't find any of the mugwumps"
      else sprintf(
        "You only found %s of the four mugwumps",
        words[sum(mugwump.found)]
      )
    ),
    "Thanks for playing! Refresh the page to play again!",
    box.stop
  )
}

# record guess data
updateHistory <- function(x, y) {
  dist <- function(i) 
    round(sqrt((x - mugwump.X[i])^2 + (y - mugwump.Y[i])^2), digits = 2)
  
  history[guessNumber, "X"] <<- as.integer(x)
  history[guessNumber, "Y"] <<- as.integer(y)
  
  for (m in 1:4) 
    history[guessNumber, mugwump.col[m]] <<- if (mugwump.found[m]) NA else dist(m)
  
}