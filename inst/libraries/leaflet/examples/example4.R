map4 = Leaflet$new()
map4$setView(29.6779, -95.4379, 10)
map4$tileLayer("http://{s}.tile.cloudmade.com/BC9A493B41014CAABB98F0471D759707/997/256/{z}/{x}/{y}.png")


data(crime, package = 'ggmap')
dat <- head(crime)[,c('lat', 'lon', 'offense')]
names(dat) <- c('lat', 'lng', 'offense')
map4$geocsv(dat)
map4