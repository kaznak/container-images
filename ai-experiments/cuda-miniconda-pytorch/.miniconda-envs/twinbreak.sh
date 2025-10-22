#!/usr/bin/env bash
set -e

conda create --name twinbreak python=3.10
conda activate twinbreak

# CUDA はベースイメージから 12.9
pip install torch --index-url https://download.pytorch.org/whl/cu129

pip install transformers==4.44.2
pip install lm_eval==0.4.7
pip install git+https://github.com/dsbowen/strong_reject.git@e286f0da86d92c929a6fda20a9992f28c5969044
pip install dotenv==0.9.9
pip install pyyaml==6.0.2

# git clone https://github.com/tkr-research/twinbreak.git
