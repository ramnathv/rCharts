..p. <- function() invisible(readline("\nPress <return> to continue: "))
library(rCharts)

dt <- dTable(
  iris,
  sPaginationType= "full_numbers"
)
dt

..p.() # ================================

dt <- dTable(
  iris,
  bScrollInfinite = T,
  bScrollCollapse = T,
  sScrollY = "200px",
  width = "500px"
)
dt

..p.() # ================================

data(Orange)
dt <- dTable(
  Orange,
  sScrollY = "200px",
  bScrollCollapse = T,
  bPaginate = F,
  bJQueryUI = T,
  aoColumnDefs = list(
    sWidth = "5%", aTargets =  list(-1)
  )
)
dt

..p.() # ================================
