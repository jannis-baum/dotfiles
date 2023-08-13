.DEFAULT_GOAL := generate

.PHONY: generate

generate:
	@rm -rf ~/.bin/parse-colors
	@ln -s $(CURDIR)/generator/parse-colors ~/.bin/parse-colors
	@generator/generate jellyfish.yaml
	@bat cache --build 1>/dev/null
