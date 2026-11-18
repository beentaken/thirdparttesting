FROM nodered/node-red:latest

USER root

# Install additional packages if required
RUN npm install -g node-red-dashboard

# Set working directory
WORKDIR /usr/src/node-red

# Copy custom settings
COPY settings.js /data/settings.js

# Set correct permissions
RUN chown -R node-red:node-red /data

USER node-red

EXPOSE 1880

CMD ["npm", "start", "--", "--userDir", "/data"]