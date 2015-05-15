# Useful stuff:
# http://www.gnu.org/software/make/manual/make.html#Automatic-Variables
# https://news.ycombinator.com/item?id=7622296

BIN				= $$(npm bin)
DIST			= public
SASS			= $(BIN)/node-sass
PREFIX		= $(BIN)/autoprefixer
KARMA			= $(BIN)/karma
SWIG			= $(BIN)/swig
IMAGEMIN	= $(BIN)/imagemin
WEBPACK 	= $(BIN)/webpack

.PHONY: build clean $(DIST)

build: clean
	make app/views/*.html
	make app/assets/stylesheets/global.sass
	make javascript
	make app/assets/fonts
	make app/assets/images/**

clean:
	rm -rf public/*

$(DIST):
	@mkdir -p $(DIST)
	@mkdir -p $(DIST)/assets
	@mkdir -p $(DIST)/assets/images
	@mkdir -p $(DIST)/assets/stylesheets

app/%.sass: $(DIST)
	$(SASS) $@ | $(PREFIX) > $(DIST)/$*.css

app/%.png: $(DIST)
	$(IMAGEMIN) $@ $(DIST)/$*.png

app/%.html: $(DIST)
	$(SWIG) render $@ -o $(DIST)/

javascript:
	@$(WEBPACK) -d --dev-tool sourcemap --config config/webpack.js

app/assets/fonts: $(DIST)
	cp -pr $@ $(DIST)/assets

test:
	@$(karma) start config/karma.js --single-run
