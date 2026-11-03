CAIKIT_IMAGE=caikit-tgis-serving
ENGINE ?= podman
export DOCKER_DEFAULT_PLATFORM=linux/amd64
.PHONY: default refresh-poetry-lock-files

default:
	$(ENGINE) build \
		-t $(CAIKIT_IMAGE):dev \
		-t $(CAIKIT_IMAGE):$$(git rev-parse --short HEAD) \
		.


shell: default
	$(ENGINE) run -it --rm \
		--name caikit-tgis-serving-test-$$(git rev-parse --short HEAD) \
		$(CAIKIT_IMAGE):dev \
		/bin/bash

# Regenerate poetry.lock in a container, so contributors don't need a
# local poetry install (CONTRIBUTING.md documents this target).
# Version-preserving: it repairs/rewrites the lockfile without changing
# any locked package version. Use `poetry update <pkg>` inside the
# container to move specific packages.
refresh-poetry-lock-files:
	$(ENGINE) run --rm \
		-v $$(pwd):/workspace -w /workspace \
		python:3.11-slim \
		bash -c "pip install --quiet poetry==2.5.1 && poetry lock"
