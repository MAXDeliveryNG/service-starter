# ACR variables
USERNAME	:=${REGISTRY_USER}
PASSWORD	:=${REGISTRY_PASSWORD}
BRANCH		:=${DEPLOY_BRANCH}
LOGIN_SERVER :=${REGISTRY_HOST}
# Image variables
NAME   := max/service
TAG    := $$(git log -1 --pretty=%h)
VERSION := $$(npm run version:no --silent)
IMG    := ${NAME}:${TAG}
LATEST := ${NAME}:${BRANCH}

login:
	@docker login --username ${USERNAME} --password ${PASSWORD} ${LOGIN_SERVER}

build:
	@docker build -t ${IMG} .

push:
	@docker tag ${IMG} ${LOGIN_SERVER}/${LATEST}
	@docker push ${LOGIN_SERVER}/${NAME}

version:
	@echo ${VERSION}