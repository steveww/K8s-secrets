FROM instana/agent

# need md5 util
RUN apk add --update-cache --update outils-md5

# tracking script
COPY updater.sh /opt/

# override the entrypoint
ENTRYPOINT ["/opt/updater.sh"]

