SHELL = /bin/bash

srcdir = Sources

REPODIR = $(shell pwd)
BUILDDIR = $(REPODIR)/.build
SOURCES = $(wildcard $(srcdir)/**/*.swift)

PROGRAMS = $(shell ls $(srcdir))
BUILDS = $(shell ls $(srcdir) | sed 's|^|$(BUILDDIR)/release/|g')
COPYDIR = $(REPODIR)/..
COPYIGNOREFILE = $(COPYDIR)/.gitignore
COPIES = $(shell ls $(srcdir) | sed 's|^|$(COPYDIR)/|g')

.DEFAULT_GOAL = copy

.PHONY: copy
copy: compile
	@touch $(COPYIGNOREFILE)
	@for p in $(PROGRAMS); do \
		if [[ -z $$(cat $(COPYIGNOREFILE) | grep $$p) ]]; then \
			echo "/$$p" >> $(COPYIGNOREFILE); \
		fi; done
	@cp $(BUILDS) $(COPYDIR)

.PHONY: compile
compile: $(SOURCES)
	@swift build \
		-c release \
		--disable-sandbox \
		--build-path "$(BUILDDIR)" \
		-Xswiftc "-target" \
		-Xswiftc "x86_64-apple-macosx10.15.4"

.PHONY: clean
clean:
	@rm -rf $(BUILDDIR) $(COPIES)

