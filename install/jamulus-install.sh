#!/bin/ash

# Set Jamulus release to download, build and install.
JAMULUS_VERSION=3_8_1

# Get Installed Version
INSTALLED_VERSION=$(/usr/local/bin/Jamulus --version 2>&1 |  grep -o '[0-9].[0-9].[0-9]' | tr '.' '_')

if [ "$JAMULUS_VERSION" == "$INSTALLED_VERSION" ]
then
    echo "Jamulus Version $JAMULUS_VERSION already installed"
else
    echo "**** updating system packages ****"
    apk update

    echo "**** Install build packages ****"
    apk add --no-cache --virtual .build-dependencies \
            build-base \
            wget \
            qt5-qtbase-dev \
            qt5-qttools-dev \
            qtchooser

    cd /tmp

    echo "**** getting source code ****"
    wget "https://github.com/jamulussoftware/jamulus/archive/r${JAMULUS_VERSION}.tar.gz" && \
    tar xzf r${JAMULUS_VERSION}.tar.gz

    cd /tmp/jamulus-r${JAMULUS_VERSION}

    echo "**** compiling source code ****"
    qmake "CONFIG+=nosound headless" Jamulus.pro && \
    make clean
    make
    cp Jamulus /usr/local/bin/
    rm -rf /tmp/*


    echo "**** Remove Build Packages ****"
    apk del .build-dependencies

    echo "**** Add additional Packages ****"
    apk add --update --no-cache \
        qt5-qtbase-x11 icu-libs tzdata busybox-extras

    rc-update add httpd

    echo "Jamulus Version $JAMULUS_VERSION Installed at: /usr/local/bin/Jamulus"

    echo "**** Creating Jamulus Environment ****"

    echo " - Creating web and recording directories"
    mkdir -p /jamulus/www
    mkdir -p /jamulus/rec

    if [ -r /jamulus/directoryserver ] && [ -s /jamulus/directoryserver ]
    then
        echo " - /jamulus/directoryserver already exists - keeping"
    else
        echo " - Creating default directoryserver file"
        printf "anygenre2.jamulus.io:22224" > /jamulus/directoryserver
    fi

    if [ -r /jamulus/serverinfo ] && [ -s /jamulus/serverinfo ]
    then
        echo " - /jamulus/serverinfo already exists - keeping"
    else
        echo " - Creating default serverinfo file"
        printf "[name];[city];[locale value]" > /jamulus/serverinfo
    fi

    if [ -r /jamulus/welcome.html ]
    then
        echo " - /jamulus/welcome.html already exists - keeping"
    else
        echo " - creating default welcome file"
        printf "<html>\n<body>\n</body>\n</html>" > /jamulus/welcome.html
    fi

    if [ -r /etc/init.d/jamulus-headless ]
    then
        echo " - jamulus service already exists - keeping"
    else
        echo " - Setting up jamulus service"
        wget -P /etc/init.d https://raw.githubusercontent.com/ExtelligenceIT/jamulus-headless-alpine/main/etc/init.d/jamulus-headless
        chmod 755 /etc/init.d/jamulus-headless
        echo " - enabling service jamulus-headless to run on startup"
        rc-update add jamulus-headless
    fi

    if [ -r /etc/httpd.conf ]
    then
        echo " - httpd.conf already exists - confirm it contains /jamulus/www"
    else
        echo " - creating /etc/httpd.conf"
        printf "H:/jamulus/www" > /etc/httpd.conf
    fi
fi