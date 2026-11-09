FROM registry.access.redhat.com/ubi9/ubi-minimal:9.8@sha256:f26ef64172ea61f5ac5ba4be8c5c738bf8760b22b3e5148ce7b40f7308ab32db as poetry-builder

RUN microdnf -y update && \
    microdnf -y install \
        git shadow-utils python3.11-pip python-wheel \
        gcc python3.11-devel && \
    pip3.11 install --no-cache-dir --upgrade pip wheel && \
    microdnf clean all

ENV POETRY_VIRTUALENVS_IN_PROJECT=1

WORKDIR /caikit
COPY pyproject.toml .
COPY poetry.lock .
RUN pip3.11 install poetry && poetry install --no-root


FROM registry.access.redhat.com/ubi9/ubi-minimal:9.8@sha256:f26ef64172ea61f5ac5ba4be8c5c738bf8760b22b3e5148ce7b40f7308ab32db as deploy
RUN microdnf -y update && \
    microdnf -y install \
        shadow-utils python3.11 && \
    microdnf clean all

WORKDIR /caikit

COPY --from=poetry-builder /caikit/.venv /caikit/.venv
COPY caikit.yml /caikit/config/caikit.yml

ENV VIRTUAL_ENV=/caikit/.venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

RUN groupadd --gid 1001 caikit && \
    adduser --uid 1001 --gid 0 --groups caikit \
    --create-home --home-dir /caikit --shell /sbin/nologin \
    --comment "Caikit User" caikit

USER caikit

ENV CONFIG_FILES=/caikit/config/caikit.yml
VOLUME ["/caikit/config/"]

CMD ["python",  "-m", "caikit.runtime"]
