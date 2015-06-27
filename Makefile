SHELL  := /bin/bash
PATH   := node_modules/.bin:$(PATH)
SRC    := app
DIST   := public
ASSETS := $(SRC)/assets
VIEWS  := $(SRC)/views

partials := $(wildcard $(VIEWS)/**/*.html)
images   := $(shell find $(ASSETS)/images -type f | sed s/$(SRC)/$(DIST)/)
fonts    := $(DIST)/assets/fonts
views    := $(DIST)/index.html $(DIST)/page2.html
styles   := $(DIST)/assets/stylesheets/style.css

all: $(DIST) javascript $(images) $(styles) $(fonts) $(views)
	@browser-sync reload

$(DIST):
	@mkdir -p $(DIST)/assets/{images,stylesheets}

$(DIST)/%.css: app/%.sass
	node-sass $< | postcss --use autoprefixer -c config/postcss.json -o $@

$(DIST)/%.png: $(SRC)/%.png
	imagemin $< > $@

$(DIST)/%.html: $(VIEWS)/%.html $(partials)
	swig render $< > $@

$(DIST)/%/fonts: $(SRC)/%/fonts
	@cp -pr $< $@

javascript:
	@webpack --config config/webpack.js

install:
	@npm install --ignore-scripts
	@npm test

watch: all
	@fswatch -0 $(SRC) | xargs -0 -n1 -I{} make -j8 &\
	browser-sync start --server $(DIST) --reload-delay 200

clean:
	@rm -rf $(DIST)

test:
	karma start config/karma.js --single-run

.PHONY: javascript install watch clean test
