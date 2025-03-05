SHELL = /bin/zsh

SRCDIR = Sources
INSTALLDIR = $(HOME)/.bin

PACKAGEDIR = $(shell pwd)
BUILDDIR = $(PACKAGEDIR)/.build
SOURCES = $(wildcard $(SRCDIR)/**/*.swift)

PROGRAMS = $(shell ls $(SRCDIR))
BUILDS = $(shell ls $(SRCDIR) | sed 's|^|$(BUILDDIR)/release/|')
COPIES = $(shell ls $(SRCDIR) | sed 's|^|$(INSTALLDIR)/|')

.PHONY: all
all: $(COPIES)

$(COPIES): $(BUILDS)
	@mkdir -p $(INSTALLDIR)
	@cp $(BUILDS) $(INSTALLDIR)

$(BUILDS): $(SOURCES)
	@swift build \
		-c release \
		--disable-sandbox \
		--build-path "$(BUILDDIR)" \
		-Xswiftc "-target" \
		-Xswiftc "x86_64-apple-macosx10.15.4"

.PHONY: clean
clean:
	@rm -rf $(BUILDDIR) $(COPIES)
