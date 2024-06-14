FROM nodered/node-red:3.0.2-18-minimal

WORKDIR /usr/src/node-red
COPY --chown=node-red:node-red ./settings/settings_template.js /node-red/settings/
COPY --chown=node-red:node-red ./*.tgz ./
COPY --chown=node-red:node-red ./scripts/install_packages.sh ./
COPY --chown=node-red:node-red ./scripts/startup.sh /node-red/shells/
COPY --chown=node-red:node-red ./scripts/startup_preprocess.sh /node-red/shells/
COPY --chown=node-red:node-red ./scripts/backup_userdata.sh /node-red/shells/
COPY --chown=node-red:node-red ./scripts/restore_userdata.sh /node-red/shells/
COPY --chown=node-red:node-red ./scripts/outputlog.sh /node-red/shells/
COPY ./scripts/install_tools.sh ./install_tools.sh
COPY ./scripts/install_python_packages.sh ./install_python_packages.sh
COPY ./scripts/install_custom_nodes.sh ./
COPY ./.npmrc ./

USER root
ENV NODE_PATH=/usr/src/node-red/node_modules/@project-gaudi/
COPY my-cert.pem /usr/local/share/ca-certificates/my-cert.crt
RUN cat /usr/local/share/ca-certificates/my-cert.crt >> /etc/ssl/certs/ca-certificates.crt
RUN chmod +x ./install_tools.sh && \
    ./install_tools.sh && \
    rm ./install_tools.sh
RUN chmod +x ./install_python_packages.sh && \
    ./install_python_packages.sh && \
    rm ./install_python_packages.sh
RUN chmod +x /node-red/shells/startup.sh
RUN chmod +x /node-red/shells/startup_preprocess.sh
RUN chmod +x /node-red/shells/backup_userdata.sh
RUN chmod +x /node-red/shells/restore_userdata.sh
RUN chmod +x /node-red/shells/outputlog.sh
RUN chmod +x ./install_custom_nodes.sh
RUN chmod +x ./install_packages.sh
RUN chown node-red:node-red /node-red/settings

RUN npm config set cafile /etc/ssl/certs/ca-certificates.crt
RUN ./install_packages.sh && \
    rm ./install_packages.sh
RUN ./install_custom_nodes.sh && \
    rm ./install_custom_nodes.sh
RUN rm .npmrc

USER node-red

# LABEL org.opencontainers.image.source=https://github.com/Project-GAUDI/GAUDINodeRED
LABEL org.opencontainers.image.description="GAUDINodeRED is a Node-RED with custom nodes available."
# LABEL org.opencontainers.image.licenses=MIT

ENTRYPOINT ["/node-red/shells/startup.sh"]
CMD ["--settings","/node-red/settings/settings.js"]