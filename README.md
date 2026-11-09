# Caikit-TGIS-Serving

caikit-tgis-serving is the container image and deployment assets for serving
Caikit NLP models through KServe with the Text Generation Inference Server
(TGIS) backend.

## Repository layout

| Path | Contents |
|---|---|
| `Dockerfile`, `Dockerfile.konflux` | Image builds |
| `caikit.yml` | Caikit runtime configuration |
| `pyproject.toml`, `poetry.lock` | Python dependency manifest and lock |
| `test/` | Smoke tests and the KServe manifests used by CI |
| `demo/` | Example KServe deployments |
| `docs/` | Architecture and installation documentation |

## Documentation

Architecture, components and installation procedures are in
[docs/README.md](docs/README.md).

## Build and test

```bash
make                    # build the image as caikit-tgis-serving:dev
make shell              # open a shell in the built image
make refresh-poetry-lock-files   # regenerate poetry.lock in a container
```

The weekly dependency-update workflow regenerates `poetry.lock` and opens a
pull request when locked versions change.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).
