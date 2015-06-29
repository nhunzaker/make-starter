SHELL  := /bin/bash
PATH   := node_modules/.bin:$(PATH)
SRC    := app
DIST   := public
ASSETS := $(SRC)/assets
VIEWS  := $(SRC)/views

partials := $(wildcard $(VIEWS)/**/*.html)
images   := $(shell find $(ASSETS)/images -type f | sed s:$(SRC):$(DIST):)
fonts    := $(DIST)/assets/fonts
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
	@sassc $< | postcss --use autoprefixer -o $@

$(DIST)/%.png: $(SRC)/%.png
	@echo $@
	@imagemin $< > $@

$(DIST)/%.html: $(VIEWS)/%.html $(partials)
	@echo $@
	@swig render $< > $@

$(DIST)/%/fonts: $(SRC)/%/fonts
	@echo $@
	@cp -pr $< $@

javascript:
	@webpack --config config/webpack.js

install:
	@npm install --ignore-scripts
	@npm test

reload: all
	@browser-sync reload

watch: all
	@fswatch -0 $(SRC) | xargs -0 -n1 -I{} make -j8 reload &\
	browser-sync start --server $(DIST)

clean:
	@rm -rf $(DIST)

test:
	karma start config/karma.js --single-run

release: all
	git subtree push --prefix $(DIST) origin gh-pages

.PHONY: javascript install watch clean test release
