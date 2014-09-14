
all: $(patsubst %.Rmd, %.md, $(wildcard vignettes/*.Rmd))

%.md: %.Rmd
	cd $(@D) && \
	Rscript -e "library(methods); library(knitr); knit('$(<F)', quiet = TRUE)" || \
	rm "$@"

README.md: vignettes/README.Rmd
	cp $< $@
