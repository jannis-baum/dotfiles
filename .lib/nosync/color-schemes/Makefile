.DEFAULT_GOAL := generate

.PHONY: generate

generate:
	@generator/generate translucent.yaml
	@bat cache --build 1>/dev/null
