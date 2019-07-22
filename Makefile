UID = "$(shell id -u)"
GID = "$(shell id -g $$USER)"
UMASK = "$(shell umask)"

init:
	chmod -R ug+rwX odoo/auto
	touch init

build: init
	export UID=$(UID) GID=$(GID) UMASK=$(UMASK); \
	docker-compose -f $(YML) build --pull; \
	touch build

setup-devel: build
	export UID=$(UID) GID=$(GID) UMASK=$(UMASK); \
	docker-compose -f setup-devel.yaml run --rm odoo; \
	touch setup-devel

initdb: setup-devel
	export UID=$(UID) GID=$(GID) UMASK=$(UMASK); \
	docker-compose -f $(YML) run --rm odoo odoo -i base --stop-after-init; \
	touch initdb

run: setup-devel initdb
	export UID=$(UID) GID=$(GID) UMASK=$(UMASK); \
	docker-compose -f $(YML) up

stop:
	export UID=$(UID) GID=$(GID) UMASK=$(UMASK); \
	docker-compose -f $(YML) down

restart:
	export UID=$(UID) GID=$(GID) UMASK=$(UMASK)
	docker-compose -f $(YML) restart odoo odoo_proxy

update:
	export UID=$(UID) GID=$(GID) UMASK=$(UMASK)
	docker-compose -f $(YML) run --rm odoo addons update -w $(ADDONS)
	docker-compose -f $(YML) restart odoo odoo_proxy`

clean:
	rm init build setup-devel initdb

start-proxy:
	docker-compose -p reverseproxy -f reverseproxy.yaml up
