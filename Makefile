SHELL  := /bin/bash
PATH   := ./node_modules/.bin:$(PATH)
IN     := app
OUT    := dist
ASSETS := $(IN)/assets
VIEWS  := $(IN)/views

all    : javascript css static html
static : $(subst $(IN), $(OUT), $(ASSETS)/fonts $(ASSETS)/images)
html   : $(subst $(VIEWS), $(OUT), $(wildcard $(VIEWS)/*.*))
css    : $(patsubst $(IN)%.scss, $(OUT)%.css, $(wildcard $(ASSETS)/stylesheets/*.scss))

$(OUT)/%.css: $(IN)/%.scss $(shell find $(IN) -name *.scss)
	@ node-sass -q --output $(@D) --source-map $@.map $<
	@ postcss --use autoprefixer -o $@ $@
	@ echo $@

$(OUT)/%.html: $(VIEWS)/%.html $(VIEWS)/**/*.html
	@ mkdir -p $(@D)
	@ swig render $< > $@
	@ echo $@

$(OUT)/assets/%/: $(IN)/assets/%
	@ mkdir -p $(@D)
	@ cp -r $< $@
	@ echo $@

javascript: $(shell find $(IN) -name '*.js')
	@ echo "Compiling JavaScript"
	@ NODE_ENV=production webpack -p --config config/webpack.js --progress --quiet

watch: css static html
	@ chokidar app -c "make -j 8 $^; browser-sync reload" --silent -d 200 \
	& webpack -w --config config/webpack.js \
	& browser-sync start --server $(OUT) --no-open --no-ui --no-notify

clean:
	rm -rf $(OUT)

test:
	@ echo "Executing tests..."
	@ karma start config/karma.js --single-run

test-watch:
	@ echo "Starting test server..."
	@ karma start config/karma.js

.PHONY: install watch clean test test-watch javascript
