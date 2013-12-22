# see global.R

# get list of variables for input
vars = sort(as.character(unique(variable_data$layer)))

# add url for preloading geojson data
#addResourcePath('data', system.file('apps/leaflet_chloropleth/data', package='rCharts'))
addResourcePath('data', system.file('inst/apps/leaflet_chloropleth/data', package='rCharts'))

shinyUI(bootstrapPage( 
  tags$script(src='data/regions_gcs.js'),      # preload regions geojson variable
  selectInput(inputId='variable', label='',
              choices=vars, selected=vars[1]),
  mapOutput('map_container')
))