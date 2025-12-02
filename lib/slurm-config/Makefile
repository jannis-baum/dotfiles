DESTINATION := hpc:/sc/home/jannis.baum
# everything but Makefile
FILES := $(filter-out Makefile . ..,$(wildcard * .*))

.PHONY: upload

upload:
	scp -r $(FILES) "$(DESTINATION)"
