# Useful stuff:
# http://www.gnu.org/software/make/manual/make.html#Automatic-Variables
# https://news.ycombinator.com/item?id=7622296

BIN      = $$(npm bin)
ASSETS   = app/assets
VIEWS    = app/views
DIST     = public
SASS     = $(BIN)/node-sass
PREFIX   = $(BIN)/autoprefixer
KARMA    = $(BIN)/karma
SWIG     = $(BIN)/swig
IMAGEMIN = $(BIN)/imagemin
WEBPACK  = $(BIN)/webpack

.PHONY: build clean $(DIST)

build: clean $(VIEWS)/*.html $(ASSETS)/stylesheets/global.sass $(ASSETS)/fonts $(ASSETS)/images/** javascript

clean:
	@rm -rf public/*

$(DIST):
	@mkdir -p $(DIST)/assets/{images,stylesheets}

app/%.sass: $(DIST)
	@$(SASS) $@ | $(PREFIX) > $(DIST)/$*.css

app/%.png: $(DIST)
	@$(IMAGEMIN) $@ > $(DIST)/$*.png

app/%.html: $(DIST)
	@$(SWIG) render $@ -o $(DIST)/

javascript:
	@$(WEBPACK)

app/assets/fonts: $(DIST)
	@cp -pr $@ $(DIST)/assets

test:
	@$(karma) start --single-run
