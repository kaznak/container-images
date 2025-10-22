# デフォルト CUDA + cuDNN ランタイム（Ubuntu 22.04）
ARG BASE_IMAGE=nvidia/cuda:12.9.1-cudnn-runtime-ubuntu22.04
ARG USER_ID=1000
ARG USER_NAME=user
ARG GROUP_NAME=${USER_NAME}
ARG PYTHON_ENV_SCRIPT

FROM ${BASE_IMAGE}

# 基本ツール
RUN apt-get update && apt-get install -y \
        wget curl git bzip2 ca-certificates \
        screen tmux \
    && rm -rf /var/lib/apt/lists/*

# Miniconda
RUN wget -O /tmp/miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
 && bash /tmp/miniconda.sh -b -p /opt/conda \
 && rm /tmp/miniconda.sh
ENV PATH="/opt/conda/bin:${PATH}"

#########################################################################################################
ENV WORKSPACE=/workspace
ENV CONDA_DIR=/opt/conda

VOLUME ${WORKSPACE}

RUN useradd -m -u ${USER_ID} ${USER_NAME} && mkdir -p ${WORKSPACE} ${CONDA_DIR} && \
    chown -R ${USER_NAME}:${GROUP_NAME} ${WORKSPACE} ${CONDA_DIR}

ENV HF_HOME=${WORKSPACE}/.cache/huggingface
ENV TRANSFORMERS_CACHE=${WORKSPACE}/.cache/huggingface/transformers

WORKDIR ${WORKSPACE}
USER ${USER_NAME}

COPY ${PYTHON_ENV_SCRIPT} ${WORKSPACE}
RUN bash -vxe ${WORKSPACE}/${PYTHON_ENV_SCRIPT}

CMD ["/bin/bash"]
