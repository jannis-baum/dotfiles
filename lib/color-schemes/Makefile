.DEFAULT_GOAL := all

.PHONY: all
all: link generate load

.PHONY: generate
generate:
	@zsh -c '\
		cd chameleon; \
		test -d .venv || { echo "set up .venv to continue"; exit 1 }; \
		source .venv/bin/activate; ./generate ../jellyfish.yaml'

.PHONY: link
link:
	@rm -rf ~/.local/bin/parse-colors
	@ln -s $(CURDIR)/chameleon/parse-colors ~/.local/bin/parse-colors

.PHONY: load
load: generate
	@bat cache --build 1>/dev/null
ifneq ($(origin KITTY_PID),undefined)
	@kill -SIGUSR1 $(KITTY_PID)
endif
