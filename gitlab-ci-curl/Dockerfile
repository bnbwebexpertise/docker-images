FROM alpine:latest
RUN apk add --no-cache --update curl bash gawk sed grep bc coreutils
COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
CMD ["curl"]
