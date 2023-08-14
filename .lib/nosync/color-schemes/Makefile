.DEFAULT_GOAL := static

.PHONY: static
static: link generate

.PHONY: generate
generate:
	@generator/generate jellyfish.yaml

.PHONY: link
link:
	@rm -rf ~/.bin/parse-colors
	@ln -s $(CURDIR)/generator/parse-colors ~/.bin/parse-colors

.PHONY: load
load: generate
	@bat cache --build 1>/dev/null
ifneq ($(origin KITTY_PID),undefined)
	@kill -SIGUSR1 $(KITTY_PID)
endif
