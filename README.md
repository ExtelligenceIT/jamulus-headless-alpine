# jamulus-headless-alpine
Scripts to install and run a headless Jamulus server on Alpine Linux

# Getting Started
1. Install Alpine Linux
2. Download and execute installation script:

        > wget https://raw.githubusercontent.com/ExtelligenceIT/jamulus-headless-alpine/main/install/jamulus-install.sh
        > chmod +x jamulus-install.sh
        > ./jamulus-install

3. **Required:**
    - Update `/jamulus/serverinfo` with relevent information
    
        See the --serverinfo option https://jamulus.io/wiki/Running-a-Server
4. *Optional:*
    - Update `/jamulus/directoryserver` with preferred directory server

        See: https://jamulus.io/wiki/Server-Linux for the available public directory servers
   - Update `/jamulus/welcome.html` with Jamulus welcome message. HTML & CSS is supported

## Control the service

### Basic Service Control
Start, stop, restart and service status:
`service jamulus-headless [ start | stop | restart | service ]`

### Control Recording
 - Toggle recording on/off: `service jamulus-headless togglerec`
 - Switch to new recording: `service jamulus-headless newrec`

## Logging and Status
 - Normal Jamulus server logs are written to `/jamulus/jamulus.log`
 - HTML status page is written to `/jamulus/www/status.html` and can be accessed via `http://<servername or ip>/status.html`