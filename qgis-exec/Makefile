VIRTUALENV ?= virtualenv
REPLICAS ?= 1
QGIS_SERVER_PARALLEL_RENDERING ?= FALSE

.PHONY: install
install: .venv/bin/docker-compose

.PHONY: build
build: deb/.copy.ts
	docker build -t qgis-exec .

.PHONY: stack-up
stack-up: .venv/bin/docker-compose docker-compose.yml nginx.conf
	.venv/bin/docker-compose up

.PHONY: stack-down
stack-down: .venv/bin/docker-compose
	.venv/bin/docker-compose rm -sf

.PHONY: rm-dangling-images
rm-dangling-images:
	@docker images -f "dangling=true" -q | xargs --no-run-if-empty docker rmi

.PHONY: apache
apache:
	docker run -it --rm -v $(shell pwd)/apache.conf:/etc/apache2/sites-available/000-default.conf -v $(shell pwd)/data:/data -p 8080:80 --name qgis-exec-apache qgis-exec-apache

.PHONY: clean
clean:
	rm -rf .venv

.venv/bin/docker-compose .venv/bin/jinja2: .venv/bin/python3
	.venv/bin/pip install -r requirements.txt

.venv/bin/python3:
	$(VIRTUALENV) .venv

deb/.copy.ts:
ifndef DEBSRCDIR
	$(error DEBSRCDIR not defined)
else
	@mkdir -p $(dir $@)
	@cp $(shell find $(DEBSRCDIR) -name *.deb) deb/
	@touch $@
endif

%.yml: %.yml.j2 .variables .venv/bin/jinja2
	.venv/bin/jinja2 -D REPLICAS=$(REPLICAS) -D QGIS_SERVER_PARALLEL_RENDERING=$(QGIS_SERVER_PARALLEL_RENDERING) $< > $@

%.conf: %.conf.j2 .variables .venv/bin/jinja2
	.venv/bin/jinja2 -D REPLICAS=$(REPLICAS) -D QGIS_SERVER_PARALLEL_RENDERING=$(QGIS_SERVER_PARALLEL_RENDERING) $< > $@

.variables: FORCE
ifneq ($(file <.variables),$(REPLICAS) $(QGIS_SERVER_PARALLEL_RENDERING))
	$(file >.variables,$(REPLICAS) $(QGIS_SERVER_PARALLEL_RENDERING))
endif

FORCE:
