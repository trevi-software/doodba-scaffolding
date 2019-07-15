UID = "$(shell echo $$UID)"
GID = "$(shell id -g $$USER)"
UMASK = "$(shell umask)"

init:
	chmod -R ug+rwX odoo/auto \

build: init
	export UID=$(UID) GID=$(GID) UMASK=$(UMASK); \
	docker-compose -f devel.yaml build --pull

setup-devel: build
	export UID=$(UID) GID=$(GID) UMASK=$(UMASK); \
	docker-compose -f setup-devel.yaml run --rm odoo

run-devel: setup-devel
	export UID=$(UID) GID=$(GID) UMASK=$(UMASK); \
	docker-compose -f devel.yaml up

down-devel:
	export UID=$(UID) GID=$(GID) UMASK=$(UMASK); \
	docker-compose -f devel.yaml down
