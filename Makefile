
all: README.md $(patsubst %.Rmd, %.md, $(wildcard vignettes/*.Rmd))

%.md: %.Rmd
	cd $(@D) && \
	Rscript -e "library(methods); library(knitr); knit('$(<F)', quiet = TRUE)" || \
	rm "$@"

