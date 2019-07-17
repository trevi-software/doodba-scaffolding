UID = "$(shell id -u)"
GID = "$(shell id -g $$USER)"
UMASK = "$(shell umask)"

init:
	chmod -R ug+rwX odoo/auto
	touch init

build: init
	export UID=$(UID) GID=$(GID) UMASK=$(UMASK); \
	docker-compose -f devel.yaml build --pull; \
	touch build

setup-devel: build
	export UID=$(UID) GID=$(GID) UMASK=$(UMASK); \
	docker-compose -f setup-devel.yaml run --rm odoo; \
	touch setup-devel

initdb-devel: setup-devel
	export UID=$(UID) GID=$(GID) UMASK=$(UMASK); \
	docker-compose -f devel.yaml run --rm odoo odoo -i base --stop-after-init; \
	touch initdb-devel

run-devel: setup-devel initdb-devel
	export UID=$(UID) GID=$(GID) UMASK=$(UMASK); \
	docker-compose -f devel.yaml up

down-devel:
	export UID=$(UID) GID=$(GID) UMASK=$(UMASK); \
	docker-compose -f devel.yaml down

restart-devel:
	export UID=$(UID) GID=$(GID) UMASK=$(UMASK)
	docker-compose -f devel.yaml restart odoo odoo_proxy

update-devel:
	export UID=$(UID) GID=$(GID) UMASK=$(UMASK)
	docker-compose -f devel.yaml run --rm odoo addons update -w $(ADDONS)
	docker-compose -f devel.yaml restart odoo odoo_proxy`

clean:
	rm init build setup-devel initdb-devel

start-proxy:
	docker-compose -p reverseproxy -f reverseproxy.yaml up
