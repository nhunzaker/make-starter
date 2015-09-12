################################################################################
# Makefile
#
# Add any build tasks here and abstract complex build scripts into `bin`
# that can be run in a Makefile task.
#
# Remember that Makefiles use tabs! Set your text editor to use 4 size
# non-soft tabs.
################################################################################

SHELL := /bin/bash
PATH  := ./node_modules/.bin:$(PATH)

IN     := app
OUT    := tmp
ASSETS := $(IN)/assets
STYLE  := $(ASSETS)/style
VIEWS  := $(IN)/views
STATIC := $(ASSETS)/fonts $(ASSETS)/images

all    : javascript style static html
html   : $(subst $(VIEWS), $(OUT), $(wildcard $(VIEWS)/*.html))
style  : $(patsubst $(STYLE)/%.scss, $(OUT)/style/%.css, $(wildcard $(STYLE)/*.scss))
static : $(subst $(ASSETS), $(OUT), $(STATIC))

javascript:
	@ echo "Compiling JavaScript"
	@ webpack -p --config config/webpack.js --progress --quiet

$(OUT)/style/%.css: $(STYLE)/%.scss $(shell find $(STYLE) -name *.scss)
	@ node-sass -q --output $(@D) --source-map $@.map $<
	@ postcss --use autoprefixer -o $@ $@
	@ echo "✓ wrote $@"

$(OUT)/%.html: $(VIEWS)/%.html $(shell find $(VIEWS) -name *.html) package.json
	@ rm -rf $@
	@ mkdir -p $(@D)
	@ swig render --json package.json $< > $@
ifeq ($(NODE_ENV), production)
	@ html-minifier --collapse-whitespace --minify-css -o $@  $@
	@ echo "✓ minified $@"
endif
	@ echo "✓ wrote $@"

$(OUT)/%/: $(ASSETS)/%/
	@ mkdir -p $(@D)
	@ cp -r $< $@
	@ echo "✓ wrote $@"

reload: style static html
	@ : # noop to silence reload

watch:
	@ make html -B
	@ make reload
	@ ./bin/watch

install:
	@ ./bin/install

audit:
	@ ./bin/audit $(OUT)

clean:
	@ rm -rf $(OUT)
	@ echo "✓ clean"

test:
	karma start config/karma.js --single-run

test-watch:
	karma start config/karma.js

.PHONY: install watch reload clean test test-watch javascript
