# Distributed under the terms of the Modified BSD License.
FROM jupyter/datascience-notebook
ARG REPO_DIR=${HOME}
ENV REPO_DIR=${REPO_DIR}

USER root

# XFCE and VNC
RUN apt-get update -qq --yes \
    && apt-get -y -qq install gnupg2 \
       software-properties-common \
       xfce4 \
       tigervnc-standalone-server \
    && rm -rf /var/lib/apt/lists/*

# Use Mozilla Firefox PPA
# https://ubuntuhandbook.org/index.php/2022/04/install-firefox-deb-ubuntu-22-04/
# repo2docker installs the context/repo to ${REPO_DIR}
#RUN install -m 644 ${REPO_DIR}/mozilla-firefox.apt.preferences /etc/apt/preferences.d/mozilla-firefox
RUN add-apt-repository ppa:mozillateam/ppa \
    && apt-get update -qq --yes \
    && apt-get install --yes -qq -t 'o=LP-PPA-mozillateam' --yes firefox \
    && rm -rf /var/lib/apt/lists/*

# jupyter-remote-desktop-proxy
RUN mamba install --yes \
    websockify && \
    pip install jupyter-remote-desktop-proxy  && \
    mamba clean --all -f --yes && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# Reset to jovyan user
USER ${NB_UID}
