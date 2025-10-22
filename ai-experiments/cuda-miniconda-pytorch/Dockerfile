# デフォルト CUDA + cuDNN ランタイム（Ubuntu 22.04）
ARG BASE_IMAGE=nvidia/cuda:12.9.1-cudnn-runtime-ubuntu22.04

FROM ${BASE_IMAGE}

ARG PYTHON_ENV_SCRIPT
ENV PYTHON_ENV_SCRIPT=${PYTHON_ENV_SCRIPT}

# 基本ツール
RUN apt-get update && apt-get install -y \
        wget curl git bzip2 ca-certificates \
        screen tmux \
    && rm -rf /var/lib/apt/lists/*

# Miniconda
RUN wget -q -O /tmp/miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
 && bash /tmp/miniconda.sh -b -p /opt/conda \
 && rm /tmp/miniconda.sh
ENV PATH="/opt/conda/bin:${PATH}"
RUN conda -y tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main    \
    && conda -y tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r    \
    && conda init

# SSH サーバー設定
RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config  \
    && echo 'PasswordAuthentication no' >> /etc/ssh/sshd_config

#########################################################################################################
ENV WORKSPACE=/workspace
ENV CONDA_DIR=/opt/conda
ENV HF_HOME=${WORKSPACE}/.cache/huggingface
ENV TRANSFORMERS_CACHE=${WORKSPACE}/.cache/huggingface/transformers

WORKDIR ${WORKSPACE}
SHELL ["/bin/bash", "-i", "-c"]

COPY ${PYTHON_ENV_SCRIPT} ${WORKSPACE}/environment_setup.sh
RUN bash -vxe ${WORKSPACE}/environment_setup.sh

# SSH 設定
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
