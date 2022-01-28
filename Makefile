#when prerequisite nginx.conf is editted locally, it triggers rebuild of docker-run

.PHONY: clean del-cont del-img login logs inspect

# useful silencer
SILENCE_OUTPUT := > /dev/null 2>&1 || true

CONTAINER_NAME := mynginx_c
IMAGE_NAME := mynginx_i

MNT_DIRS_REL := mnt_dirs
MNT_DIRS_ABS := $$PWD/$(MNT_DIRS_REL)

BUILD_CONTEXT := context


NGINX_HTML_ROOT := /usr/share/nginx/html:ro
UVICORN_APP_ROOT := /docker-work/uvicornn/appdir:ro
READ_ONLY := --read-only -v $(MNT_DIRS_ABS)/nginx-cache:/var/cache/nginx -v $(MNT_DIRS_ABS)/nginx-pid:/var/run

# will always run because  docker-run file is never created. ( intended )
docker-run: DOCKERBUILDTOUCH \
			del-cont \
			$(MNT_DIRS_REL)/appdir/static \
			$(MNT_DIRS_REL)/html \
			$(MNT_DIRS_REL)/nginx-cache \
			$(MNT_DIRS_REL)/nginx-pid

	@echo INFO: spawning $(CONTAINER_NAME)
	docker run \
		$(READ_ONLY) \
		--name $(CONTAINER_NAME) \
		-v $(MNT_DIRS_ABS)/html:$(NGINX_HTML_ROOT) \
		-v $(MNT_DIRS_ABS)/appdir:$(UVICORN_APP_ROOT) \
		-d -p 8080:80 \
		$(IMAGE_NAME)

#rebuild Image to copy over the changed Context Files.
DOCKERBUILDTOUCH: 	$(BUILD_CONTEXT)/nginx.conf \
					$(BUILD_CONTEXT)/Dockerfile \
					$(BUILD_CONTEXT)/start_uvicorn.sh 
	@echo INFO: creating $(IMAGE_NAME) from Dockerfile
	docker build -t $(IMAGE_NAME) context
	touch DOCKERBUILDTOUCH

$(BUILD_CONTEXT)/nginx.conf:
	@echo INFO: grabbing nginx.conf from tmp container...
	docker run --name tmp-nginx -d nginx
	docker cp tmp-nginx:/etc/nginx/nginx.conf $(BUILD_CONTEXT)/nginx.conf
	docker rm -f tmp-nginx
	touch $(BUILD_CONTEXT)/nginx.conf

$(BUILD_CONTEXT)/Dockerfile:
	@echo INFO: Please create or download the dockerfile somehow
	exit 1

$(BUILD_CONTEXT)/start_uvicorn.sh:
	@echo INFO: Pleasle create or download a start_uvicorn.sh script
	exit 1

$(MNT_DIRS_REL)/appdir/static:
	mkdir -p $(MNT_DIRS_REL)/appdir/static $(SILENCE_OUTPUT)

$(MNT_DIRS_REL)/html:
	mkdir $(MNT_DIRS_REL)/html $(SILENCE_OUTPUT)

$(MNT_DIRS_REL)/nginx-cache:
	mkdir $(MNT_DIRS_REL)/nginx-cache $(SILENCE_OUTPUT)

$(MNT_DIRS_REL)/nginx-pid:
	mkdir $(MNT_DIRS_REL)/nginx-pid $(SILENCE_OUTPUT)

clean: del-cont del-img
	@#trigger rebuild of image
	touch $(BUILD_CONTEXT)/nginx.conf

del-cont:
	@echo INFO: stopping $(CONTAINER_NAME)
	docker stop $(CONTAINER_NAME) $(SILENCE_OUTPUT)
	@echo INFO: removing $(CONTAINER_NAME)
	docker rm $(CONTAINER_NAME) $(SILENCE_OUTPUT)
del-img:
	@echo INFO: deleting $(IMAGE_NAME)
	docker image rm $(IMAGE_NAME) $(SILENCE_OUTPUT)
	

login:
	docker exec -it $(CONTAINER_NAME) /bin/bash

logs:
	docker logs $(CONTAINER_NAME)

inspect:
	docker inspect $(CONTAINER_NAME)