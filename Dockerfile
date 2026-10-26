FROM node:24.22.0-slim

# USER root
RUN set -ex

# install tools
RUN apt-get update && apt-get install -y --no-install-recommends \
        bash \
        tzdata \
        curl \
        nano \
        git \
        wget \
        openssl \
        openssh-client \
        ca-certificates \
        iputils-ping \
        vim \
    && apt-get install -y --only-upgrade openssl libssl3 git libc6 curl libcurl4 expat pcre2-utils \
    && rm -rf /var/lib/apt/lists/*

# NodeRED build
WORKDIR /usr/src
RUN git clone --branch 5.0.8 --depth 1 https://github.com/node-red/node-red.git

WORKDIR /usr/src/node-red

# npm overrides でdependency tree全体の脆弱性パッケージバージョンを強制固定
# (transitive dependency含む / install_packages.sh完了後まで維持)
RUN node -e "\
  const fs = require('fs'); \
  const pkg = JSON.parse(fs.readFileSync('./package.json', 'utf8')); \
  pkg.overrides = { \
    'axios': '1.20.0', \
    'ip-address': '10.7.1', \
    'brace-expansion': '5.0.12', \
    'undici': '6.28.1', \
    'fast-uri': '3.1.8', \
    'qs': '6.16.0', \
    'uuid': '11.1.1', \
    'proxy-addr': '2.0.8' \
  }; \
  pkg.dependencies.moment='2.31.0'; \
  fs.writeFileSync('./package.json', JSON.stringify(pkg, null, 2)); \
"

RUN npm install
RUN npm run build
RUN npm prune --omit=dev

RUN npm install -g --unsafe-perm node-red-admin@4.1.6

# create Node-RED app and data dir, add user and set rights
RUN mkdir -p /data && \
    deluser --remove-home node && \
    useradd --home-dir /usr/src/node-red --uid 1000 node-red && \
    chown -R node-red:root /data && chmod -R g+rwX /data && \
    chown -R node-red:root /usr/src/node-red && chmod -R g+rwX /usr/src/node-red

# shell Settings
COPY ./scripts/install_tools.sh ./install_tools.sh
COPY --chown=node-red:node-red ./.npmrc /usr/src/node-red/
COPY --chown=node-red:node-red ./scripts/install_packages.sh ./
COPY --chown=node-red:node-red ./scripts/entrypoint.sh /node-red/shells/
COPY --chown=node-red:node-red ./scripts/entrypoint_preprocess.sh /node-red/shells/
COPY --chown=node-red:node-red ./scripts/backup_userdata.sh /node-red/shells/
COPY --chown=node-red:node-red ./scripts/restore_userdata.sh /node-red/shells/
COPY --chown=node-red:node-red ./scripts/outputlog.sh /node-red/shells/
COPY --chown=node-red:node-red ./settings/settings_template.js /node-red/settings/
COPY --chown=node-red:node-red ./healthcheck.js /node-red/
COPY --chown=node-red:node-red ./scripts/install_custom_nodes.sh ./

USER root
RUN chmod +x /node-red/shells/entrypoint.sh
RUN chmod +x /node-red/shells/entrypoint_preprocess.sh
RUN chmod +x /node-red/shells/backup_userdata.sh
RUN chmod +x /node-red/shells/restore_userdata.sh
RUN chmod +x /node-red/shells/outputlog.sh
RUN chown node-red:node-red /node-red/shells
RUN chown node-red:node-red /node-red/settings

# tools install
RUN chmod +x ./install_tools.sh && \
    ./install_tools.sh && \
    rm ./install_tools.sh

# output info
ARG TAGS='7.0.2'
RUN { \
echo "module name    : GAUDINodeRED"; \
echo "module version : ${TAGS}"; \
} > ./application.info

USER node-red

# node install
RUN chmod +x ./install_packages.sh && \
    ./install_packages.sh && \
    rm ./install_packages.sh

ARG GITHUB_TOKEN
RUN echo "@project-gaudi:registry=https://npm.pkg.github.com/" > /usr/src/node-red/.npmrc && \
    echo "//npm.pkg.github.com/:_authToken=${GITHUB_TOKEN}" >> /usr/src/node-red/.npmrc

RUN chmod +x ./install_custom_nodes.sh
RUN ./install_custom_nodes.sh && \
    rm ./install_custom_nodes.sh
RUN rm .npmrc

# env variables
ENV NODE_PATH=/usr/src/node-red/node_modules:/data/node_modules \
    PATH=/usr/src/node-red/node_modules/.bin:${PATH} \
    FLOWS=flows.json

# expose the listening port of node-red
EXPOSE 1880

# add a healthcheck (default every 30 secs)
HEALTHCHECK CMD node /node-red/healthcheck.js

ENTRYPOINT ["/node-red/shells/entrypoint.sh"]
