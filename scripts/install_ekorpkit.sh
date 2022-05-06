#!/bin/bash
set -x
set -o allexport
source .env
set +o allexport

pip install -e $EKORPKIT_SRC_DIR$EKORPKIT_PIP_EXTRA
