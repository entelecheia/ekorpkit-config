#!/bin/sh
set -o allexport
source .env
set +o allexport
# set -x or set -o xtrace expands variables and prints a little + sign before the line.
# set -v or set -o verbose does not expand the variables before printing.
# Use set +x and set +v to turn off the above settings.
# set -x

LIMIT=-1
CORPUS_NAME=""
DATASET_NAME=""
FILENAME=""
EXPRESSION=""
OVERWRITE="false"
FORCE_DOWNLOAD="false"
PREPROCESS="true"
TASK="default"
GROUP="_default"

pyclean() {
    find . -regex '^.*\(__pycache__\|\.py[co]\)$' -delete
}

function usage() {
    echo "usage: sh [[--option value ] | [-h]] command"
    echo "           --limit : Number of documents to process"
    echo "example:"
    echo "       sh run.sh cmd"
}

while [ "$1" != "" ]; do
    case $1 in
    -l | --limit)
        shift
        LIMIT=$1
        ;;
    -c | --corpus)
        shift
        CORPUS_NAME=$1
        ;;
    -d | --dataset)
        shift
        DATASET_NAME=$1
        ;;
    -n | --num_workers)
        shift
        NUM_WORKERS=$1
        ;;
    -t | --task)
        shift
        TASK=$1
        ;;
    -f | --filename)
        shift
        FILENAME=$1
        ;;
    -g | --group)
        shift
        GROUP=$1
        ;;
    -e | --expression)
        shift
        EXPRESSION=$1
        ;;
    --config)
        shift
        CONFIG_DIR=$1
        ;;
    --workspace)
        shift
        WORKSPACE_DIR=$1
        ;;
    --project)
        shift
        PROJECT=$1
        ;;
    --backend)
        shift
        DF_BACKEND=$1
        ;;
    --data_dir)
        shift
        DATA_DIR=$1
        ;;
    --ow)
        OVERWRITE="true"
        ;;
    --fd)
        FORCE_DOWNLOAD="true"
        ;;
    --np)
        PREPROCESS="false"
        ;;
    -h | --help)
        usage
        exit
        ;;
    *) COMMAND=$1 ;;
    esac
    shift
done

if [[ "$NUM_WORKERS" == "" ]]; then
    NUM_WORKERS=1
fi
if [[ "$CONFIG_DIR" == "" ]]; then
    CONFIG_DIR="/workspace/data/ekorpkit-config/config"
fi
if [[ "$WORKSPACE_DIR" == "" ]]; then
    WORKSPACE_DIR="/workspace"
fi

if [[ "$DF_BACKEND" == "" ]]; then
    DF_BACKEND="joblib"
fi

CONFIG_ARG="--config-dir ${CONFIG_DIR} 
    project=${PROJECT} 
    dir.workspace=${WORKSPACE_DIR} 
    num_workers=${NUM_WORKERS} 
    env.os.WANDB_API_KEY=${WANDB_API_KEY}
    env.distributed_framework.backend=${DF_BACKEND}"

RSRC_DIR="$(dirname "$CONFIG_DIR")/resource/"

case $COMMAND in
listup)

    ekorpkit ${CONFIG_ARG} \
        cmd=listup

    ;;
info)

    ekorpkit ${CONFIG_ARG} \
        +info=${TASK}

    ;;
finetune)

    if [[ "$DATASET_NAME" == "" ]]; then
        DSET=" "
    else
        DSET="dataset.name=$DATASET_NAME "
    fi
    if [[ "$DATA_DIR" == "" ]]; then
        DIR_ARG=" "
    else
        DIR_ARG="model.transformer.finetune.prediction.data_dir=$DATA_DIR "
    fi

    ekorpkit ${CONFIG_ARG} \
        +run/${GROUP}=${TASK} \
        ${DSET} \
        ${DIR_ARG}

    ;;

task)

    if [[ "$DATASET_NAME" == "" ]]; then
        DSET_ARG=" "
    else
        DSET_ARG="dataset=$DATASET_NAME "
    fi
    if [[ "$CORPUS_NAME" == "" ]]; then
        CORPUS_ARG=" "
    else
        CORPUS_ARG="dataset=$CORPUS_NAME "
    fi

    ekorpkit ${CONFIG_ARG} \
        +run/${GROUP}=${TASK} \
        ${DSET_ARG} \
        ${CORPUS_ARG} \

    ;;
corpus | dataframe)

    ekorpkit ${CONFIG_ARG} \
        +run/${GROUP}=${TASK} \
        corpus.name=${CORPUS_NAME}

    ;;
build_corpus | build_simple | build_t5 | build_t5_all | build_simple_all)
    #~ ex) bash data/ekorpkit-config/run.sh build_t5_all -f bio.yaml -e 'ner.*'
    arrCMD=(${COMMAND//_/ })
    echo "sub command: ${arrCMD[1]}"
    if [[ "${arrCMD[1]}" == "corpus" ]]; then
        CAT="corpus"
        SUBCAT="builtin"
    else
        CAT="dataset"
        SUBCAT="${arrCMD[1]}"
    fi
    if [[ "${arrCMD[2]}" == "all" ]]; then
        filename="${RSRC_DIR}${FILENAME}"
        declare -a NAMES
        NAMES=($(yq r "$filename" "$EXPRESSION"))
    else
        declare -a NAMES=(${CORPUS_NAME})
    fi
    if [[ "$DATA_DIR" == "" ]]; then
        DIR_ARG=" "
    else
        DIR_ARG="${CAT}.${SUBCAT}.fetch.data_dir=$DATA_DIR "
    fi

    for i in "${NAMES[@]}"; do
        echo "$i"
        ekorpkit ${CONFIG_ARG} \
            +${CAT}/${SUBCAT}=${i} \
            cmd=fetch_${SUBCAT}_${CAT} \
            ${CAT}.${SUBCAT}.fetch.calculate_stats=true \
            ${CAT}.${SUBCAT}.fetch.preprocess_text=${PREPROCESS} \
            ${CAT}.${SUBCAT}.fetch.overwrite=${OVERWRITE} \
            ${CAT}.${SUBCAT}.fetch.force_download=${FORCE_DOWNLOAD} \
            ${DIR_ARG}
    done

    ;;
yaml | yml | yaml_file)
    #~ ex) bash data/ekorpkit-config/run.sh yaml -f bio.yaml -e 'ner.*'
    declare -a VALUES
    filename="${RSRC_DIR}${FILENAME}"
    VALUES=($(yq r "$filename" "$EXPRESSION"))
    for i in "${VALUES[@]}"; do
        echo "value: $i"
    done

    ;;
*)
    echo "not existing command!"
    usage
    exit
    ;;
esac
