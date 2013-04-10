push:
	git push git@github.com:ramnathv/rCharts master:master
	
docs:
	cd inst/docs && \
	git add . && \
	git commit -am "update documentations" && \
	git push git@github.com:ramnathv/rCharts master:gh-pages && \
	
shinyApp:
	rsync -avz --delete inst/rChartApp ramnathv@glimmer.rstudio.com:~/ShinyApps/