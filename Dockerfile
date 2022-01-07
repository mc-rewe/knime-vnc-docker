FROM openkbs/jdk-mvn-py3-vnc

MAINTAINER DrSnowbird "DrSnowbird@openkbs.org"

## ---- USER_NAME is defined in parent image: openkbs/jdk-mvn-py3-x11 already ----
ENV USER_NAME=${USER_NAME:-developer}
ENV HOME=/home/${USER_NAME}

##########################################
#### ---- Build ARG and RUN ENV ---- #####
##########################################
ARG PRODUCT=${PRODUCT:-knime}
ENV PRODUCT=${PRODUCT}

ENV PRODUCT_WORKSPACE=${PRODUCT_WORKSPACE:-"${HOME}/${PRODUCT}-workspace"}
ENV WORKSPACE=${WORKSPACE:-"${HOME}/workspace"}
ENV DATA=${DATA:-"${HOME}/data"}

ARG PRODUCT_VERSION=${PRODUCT_VERSION:-4.4.0}
ENV PRODUCT_VERSION=${PRODUCT_VERSION}
ARG PRODUCT_DIR=${PRODUCT_DIR:-knime_${PRODUCT_VERSION}}
ENV PRODUCT_DIR=${PRODUCT_DIR}
ARG INSTALL_BASE=${INSTALL_BASE:-/opt}
ENV INSTALL_BASE=${INSTALL_BASE}
ENV PRODUCT_EXE=${PRODUCT_EXE:-${INSTALL_BASE}/${PRODUCT_DIR}/${PRODUCT}}
ARG PRODUCT_URL=${PRODUCT_URL:-https://download.knime.org}
ARG DOWNLOAD_URL=${PRODUCT_URL}/analytics-platform/linux/${PRODUCT}_${PRODUCT_VERSION}.linux.gtk.x86_64.tar.gz

####################################
#### ---- Install product: ---- ####
####################################
WORKDIR ${INSTALL_BASE}

# Set bash as default shell for CMDs
SHELL ["/bin/bash", "-c"]

#### ---- Install for application ----
RUN sudo wget -q -c ${DOWNLOAD_URL} && \
    sudo tar xvf $(basename ${DOWNLOAD_URL}) && \
    sudo rm -f $(basename ${DOWNLOAD_URL} )

COPY ./Desktop/KNIME.desktop ${HOME}/Desktop/KNIME.desktop

RUN sudo mkdir -p ${DATA} ${WORKSPACE} ${PRODUCT_WORKSPACE} 

# Python packages
RUN pip3 install --upgrade teradatasql paramiko pandas

# Get the stuff we'll need to run knime workflows via script
COPY ./knime-workspace/ ${WORKSPACE}
COPY ./drivers/* ${DATA}/
COPY ./scripts/* ${HOME}/scripts/

# Owner and Permissions 
RUN sudo chown -R ${USER_NAME}:${USER_NAME} ${DATA} ${WORKSPACE} ${PRODUCT_WORKSPACE} ${HOME}/Desktop && \
    sudo chmod 755 ${HOME}/scripts/*.sh
#sudo chmod 755 ${DATA}/*.sh

#########################################
#### ---- Addition Libs/Plugins ---- ####
#########################################
## -- hub.docker build having issue; temporarily remove these two lines --
#RUN sudo apt-get update -y && \
#    sudo apt-get install -y libwebkitgtk-3.0-0

##################################
#### VNC ####
##################################
WORKDIR ${HOME}
USER ${USER_NAME}
ENTRYPOINT ["/dockerstartup/vnc_startup.sh"]

########################
#### ---- KNIME ----####
########################
VOLUME ${PRODUCT_WORKSPACE}
VOLUME ${WORKSPACE}
VOLUME ${DATA}

# run script 
CMD [ "sh", "-c", "${DATA}/run_knime.sh", "${PRODUCT_EXE}", "${WORKSPACE}"]
