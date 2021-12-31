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

    apk add --update --no-cache \
        qt5-qtbase-x11 icu-libs tzdata

    echo "Jamulus Version $JAMULUS_VERSION Installed at: /usr/local/bin/Jamulus"
fi