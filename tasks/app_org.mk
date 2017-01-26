## App tasks ##################################################################
app_id = org
app_image = $(call image_tag,$(app_id),$(VERSION))
app_name = $(project_name)_$(app_id)
app_dockerfile = Dockerfile.$(app_id)

.PHONY: \
  org-rm \
  org-create \
  org-log \
  org-sh \
  org-build \
  org-pull \
  org-push

ifeq ("$(LOCAL_FS)", "true")
  app_volumes = \
    -v $(BASE_PATH)/package.org.json:/home/ustwo/package.json \
    -v $(BASE_PATH)/src_org:/home/ustwo/src
endif

org-build:
	$(DOCKER) build -t $(app_image) -f $(app_dockerfile) .

org-pull:
	$(DOCKER) pull $(app_image)

org-push:
	$(DOCKER) push $(app_image)

org-rm:
	@echo "Removing $(app_name)"
	@$(DOCKER_RM) $(app_name)

org-create:
	@echo "Creating $(app_name)"
	@$(DOCKER_PROC) \
		--name $(app_name) \
		$(app_volumes) \
		--restart always \
		$(project_labels) \
		--net=$(network_name) \
		-e DOCKER_PROXY_HOST=$(proxy_name) \
		$(verbose_flag) \
		$(app_image)

org-log:
	$(DOCKER) logs -f $(app_name)

org-sh:
	$(DOCKER_EXEC) $(app_name) /bin/sh
