#!/usr/bin/env bash
set -e

source /opt/conda/etc/profile.d/conda.sh

conda create --name twinbreak python=3.10
conda activate twinbreak

# CUDA はベースイメージから 12.9
pip install -q torch --index-url https://download.pytorch.org/whl/cu129

pip install -q transformers==4.44.2
pip install -q lm_eval==0.4.7
pip install -q git+https://github.com/dsbowen/strong_reject.git@e286f0da86d92c929a6fda20a9992f28c5969044
pip install -q dotenv==0.9.9
pip install -q pyyaml==6.0.2

# git clone https://github.com/tkr-research/twinbreak.git
