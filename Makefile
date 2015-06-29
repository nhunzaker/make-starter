SHELL  := /bin/bash
PATH   := node_modules/.bin:$(PATH)
SRC    := app
DIST   := public
ASSETS := $(SRC)/assets
VIEWS  := $(SRC)/views
IMAGES := $(ASSETS)/images

partials := $(wildcard $(VIEWS)/*/*.html)
fonts    := $(DIST)/assets/fonts
images   := $(shell find $(IMAGES) -type f | sed s:$(SRC):$(DIST):)
views    := $(shell find $(VIEWS)/*.html | sed s:$(VIEWS):$(DIST):)
styles   := $(shell find $(ASSETS)/stylesheets/*.sass | sed "s:$(SRC):$(DIST):; s:sass:css:")

all    : $(DIST) javascript images css fonts html
images : $(DIST) $(images)
fonts  : $(DIST) $(fonts)
html   : $(DIST) $(views)
css    : $(DIST) $(styles)

$(DIST):
	@mkdir -p $(DIST)/assets/{images,stylesheets}

$(DIST)/%.css: app/%.sass
	@echo $@
	@node-sass $< | postcss --use autoprefixer -o $@

$(DIST)/%.png: $(SRC)/%.png
	@echo $@
	@imagemin $< > $@

$(DIST)/%.html: $(VIEWS)/%.html $(partials)
	@echo $@
	@swig render $< > $@

$(DIST)/%/fonts: $(SRC)/%/fonts
	@echo $@
	@cp -pr $< $@I

javascript:
	@webpack --config config/webpack.js

install:
	@npm install --ignore-scripts
	@npm test

reload: $(DIST) images css fonts html
	@browser-sync reload

watch: all
	@fswatch -0 $(SRC) | xargs -0 -n1 -I{} make -j8 reload &\
	browser-sync start --server $(DIST) &\
	webpack -w --config config/webpack.js

clean:
	@rm -rf $(DIST)

test:
	karma start config/karma.js --single-run

.PHONY: install watch clean test release
