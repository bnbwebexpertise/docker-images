#!/bin/sh

docker buildx build -f Dockerfile --platform linux/amd64 -t bnbwebexpertise/gitlab-ci-runner-php84-laravel:latest --push .
