SHELL  := /bin/bash
PATH   := node_modules/.bin:$(PATH)
SRC    := app
DIST   := public
ASSETS := $(SRC)/assets
VIEWS  := $(SRC)/views

all    : $(DIST) javascript images css fonts html
images : $(subst $(SRC), $(DIST), $(wildcard $(ASSETS)/images/*.*))
fonts  : $(subst $(SRC), $(DIST), $(ASSETS)/fonts)
html   : $(subst $(VIEWS), $(DIST), $(wildcard $(VIEWS)/*.*))
css    : $(patsubst $(SRC)%.scss, $(DIST)%.css, $(wildcard $(ASSETS)/stylesheets/*.scss))

$(DIST):
	@ mkdir -p $(DIST)/assets/{images,stylesheets}

$(DIST)/%.css: $(SRC)/%.scss $(shell find $(SRC) -name *.scss)
	@ echo "Compiling $@"
	@ node-sass --output $(shell dirname $@) --source-map $@.map $<
	@ postcss --use autoprefixer -o $@ $@

$(DIST)/%.png: $(SRC)/%.png
	@ echo "Copying $^"
	@ mkdir -p $(@D)
	@ cp $^ $@

$(DIST)/%.html: $(VIEWS)/%.html $(VIEWS)/**/*.html
	@ echo $@
	@ mkdir -p $(@D)
	@ swig render $< > $@

$(DIST)/%/fonts: $(SRC)/%/fonts
	@ echo $@
	@ mkdir -p $(@D)
	@ cp -pr $< $@

javascript: $(shell find $(SRC) -name '*.js')
	@ echo $
	@ webpack --config config/webpack.js --progress --quiet

install:
	@ npm install --ignore-scripts

reload: $(DIST) css images fonts html
	@ browser-sync reload

watch: all
	@ chokidar app -c "make -j 8 reload" \
	& browser-sync start --server $(DIST) --no-open --no-ui --no-notify \
	& webpack -w --config config/webpack.js

clean:
	@ rm -rf $(DIST)

test:
	karma start config/karma.js --single-run

.PHONY: install watch clean test
