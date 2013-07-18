require(rCharts)

dt <- dTable(
  iris,
  sPaginationType= "full_numbers"
)
dt

dt <- dTable(
  iris,
  bScrollInfinite = T,
  bScrollCollapse = T,
  sScrollY = "200px",
  width = "500px"
)
dt


#not really a use case but a test to check for errors
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