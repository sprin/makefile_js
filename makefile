SHELL = /bin/sh

srcdir = src/
BUILDDIR = build/

# Declare each module explicitly
JS_TARGETS = ${srcdir}1.js\
             ${srcdir}2.js\
             ${srcdir}3.js\

# Prefix of the JS file to be referenced in index.html
INDEX_JS = concat

# Flags to pass to the YUI Compressor for both CSS and JS
YUI_FLAGS = --charset utf-8 --verbose

TIMESTAMP := $(shell date +%s)

## Rules

# Make both concat and min files
all: $(BUILDDIR)\
     $(BUILDDIR)concat.$(TIMESTAMP).js\
     $(BUILDDIR)concat.$(TIMESTAMP).min.js\
     $(BUILDDIR)index.html

$(BUILDDIR):
	mkdir -p $@

# Concatenate all modules into concat.<unix timestamp>.js
$(BUILDDIR)concat.$(TIMESTAMP).js: ${JS_TARGETS}
	@echo '==> Concatenating $^'
	cat $^ > $@

# Compress all of the modules into min.js
$(BUILDDIR)%.$(TIMESTAMP).min.js: $(BUILDDIR)%.$(TIMESTAMP).js
	@echo '==> Minifying $<'
	yui-compressor $(YUI_FLAGS) --type js -o $@ $<

# Re-write the script filename in the html file
$(BUILDDIR)index.html: $(BUILDDIR)$(INDEX_JS).$(TIMESTAMP).min.js\
                        $(srcdir)template.html
	@echo '==> Rendering template.html with new script filenames'
	sed 's/.[0-9]\{10\}./.$(TIMESTAMP)./' $(srcdir)template.html > $@

clean:
	rm -rfv $(BUILDDIR)

