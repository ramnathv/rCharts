# load_all('/Users/bbest/Code/rCharts/'); shiny::runApp('/Users/bbest/Code/rCharts/inst/apps/leaflet_chloropleth/')
require(shiny)
require(rCharts)

vars_rgn = sort(subset(layers$meta, fld_id_num=='rgn_id' & is.na(fld_category)  & is.na(fld_year) & is.na(fld_val_chr), layer, drop=T))
addResourcePath('shapes', path.expand('~/myohi/shapes'))

shinyUI(bootstrapPage( 
  tags$script(src='/shapes/regions_gcs.js'),
  selectInput(inputId='variable', label='Variable', choices=vars_rgn, selected=sort(names(layers))[1]),
  mapOutput('map_container')
))