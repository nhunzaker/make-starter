SHELL  := /bin/bash
PATH   := node_modules/.bin:$(PATH)
SRC    := app
DIST   := public
ASSETS := $(SRC)/assets
VIEWS  := $(SRC)/views

all    : javascript images css fonts html
images : $(subst $(SRC), $(DIST), $(wildcard $(ASSETS)/images/*.*))
fonts  : $(subst $(SRC), $(DIST), $(ASSETS)/fonts)
html   : $(subst $(VIEWS), $(DIST), $(wildcard $(VIEWS)/*.*))
css    : $(patsubst $(SRC)%.scss, $(DIST)%.css, $(wildcard $(ASSETS)/stylesheets/*.scss))

$(DIST)/%.css: $(shell find $(SRC) -name *.scss)
	node-sass --output $(@D) --source-map $@.map $(SRC)/$*.scss
	postcss --use autoprefixer -o $@ $@

$(DIST)/%.html: $(VIEWS)/%.html $(VIEWS)/**/*.html
	@ mkdir -p $(@D)
	swig render $< > $@

$(DIST)/assets/%: $(SRC)/assets/%
	@mkdir -p $(@D)
	cp -r $< $@

javascript: $(shell find $(SRC) -name '*.js')
	webpack --config config/webpack.js --progress --quiet

install:
	@ npm install --ignore-scripts

reload: $(DIST) css images fonts html
	browser-sync reload

watch: all
	@ chokidar app -c "make -j 8 reload" \
	& browser-sync start --server $(DIST) --no-open --no-ui --no-notify \
	& webpack -w --config config/webpack.js

clean:
	@ rm -rf $(DIST)

test:
	karma start config/karma.js --single-run

.PHONY: install watch clean test
