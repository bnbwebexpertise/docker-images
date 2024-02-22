#!/bin/sh

docker buildx build -f Dockerfile --platform linux/amd64 -t bnbwebexpertise/gitlab-ci-runner-php82-laravel:latest --push .
