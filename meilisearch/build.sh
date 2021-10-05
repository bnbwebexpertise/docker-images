#!/bin/sh

cp Dockerfile.arm Dockerfile
docker buildx build --platform linux/arm64 --tag bnbwebexpertise/meilisearch:armv8 --push .

cp Dockerfile.amd Dockerfile
docker buildx build --platform linux/amd64 --tag bnbwebexpertise/meilisearch:amd64 --push .

docker manifest create bnbwebexpertise/meilisearch:latest amouat/arch-test:amd64 amouat/arch-test:armv7
docker manifest push bnbwebexpertise/meilisearch:latest

rm Dockerfile
