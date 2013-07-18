require(rCharts)

dTable <- Datatables()
dTable$addTable(
  iris,
  sPaginationType= "full_numbers"
)
dTable

dTable <- Datatables()
dTable$addTable(
  iris,
  bScrollInfinite = T,
  bScrollCollapse = T,
  sScrollY = "200px"
)
dTable


#not really a use case but a test to check for errors
data(Orange)
dTable <- Datatables()
dTable$addTable(
  Orange,
  sScrollY = "200px",
  bScrollCollapse = T,
  bPaginate = F,
  bJQueryUI = T,
  aoColumnDefs = list(
    sWidth = "5%", aTargets =  list(-1)
  )
)
dTable