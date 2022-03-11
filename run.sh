#!/bin/sh
# set -x or set -o xtrace expands variables and prints a little + sign before the line.
# set -v or set -o verbose does not expand the variables before printing.
# Use set +x and set +v to turn off the above settings.
# set -x

LIMIT=-1
INPUT_PATH=""
OUTPUT_PATH=""
CORPUS_NAME="esg_report"
FILE_PATTERN="."
OVERWRITE="false"
FORCE_DOWNLOAD="false"
BACKEND="joblib"
PREPROCESS="true"
TASK="default"
CONFIG_PATH="/workspace/data/ekorpkit-config/config"
PROJECT="esgml"
CPU_N=230

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
    -i | --input)
        shift
        INPUT_PATH=$1
        ;;
    -o | --output)
        shift
        OUTPUT_PATH=$1
        ;;
    -c | --corpus)
        shift
        CORPUS_NAME=$1
        ;;
    -n | --cpu_n)
        shift
        CPU_N=$1
        ;;
    -t | --task)
        shift
        TASK=$1
        ;;
    --config)
        shift
        CONFIG_PATH=$1
        ;;
    --project)
        shift
        PROJECT=$1
        ;;
    --backend)
        shift
        BACKEND=$1
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

# echo "command: $COMMAND"
# echo "limit: $LIMIT"
if [[ "$CPU_N" == "" ]]; then
    CPU_N=230
fi

case $COMMAND in
listup)
    ekorpkit \
        --config-dir $CONFIG_PATH \
        project=$PROJECT \
        cmd=listup

    ;;
info)

    ekorpkit \
        --config-dir $CONFIG_PATH \
        project=$PROJECT \
        +info=${TASK}

    ;;
finetune)

    ekorpkit \
        --config-dir $CONFIG_PATH \
        project=$PROJECT \
        +run/finetune=${TASK}

    ;;
topic)

    ekorpkit \
        --config-dir $CONFIG_PATH \
        project=$PROJECT \
        +run/topic=${TASK} \
        num_workers=${CPU_N}

    ;;
corpus)

    ekorpkit \
        --config-dir $CONFIG_PATH \
        project=$PROJECT \
        +run=corpus_task \
        corpus.name=${CORPUS_NAME} \
        num_workers=${CPU_N}

    ;;
dataframe)

    ekorpkit \
        --config-dir $CONFIG_PATH \
        env.distributed_framework.backend=$BACKEND \
        project=$PROJECT \
        +run=dataframe_task \
        corpus.name=${CORPUS_NAME} \
        num_workers=${CPU_N}

    ;;
build_corpus)

    ekorpkit \
        --config-dir $CONFIG_PATH \
        project=$PROJECT \
        env.distributed_framework.backend=$BACKEND \
        +corpus/builtin=${CORPUS_NAME} \
        num_workers=${CPU_N} \
        corpus.builtin.fetch.calculate_stats=true \
        corpus.builtin.fetch.preprocess_text=${PREPROCESS} \
        corpus.builtin.fetch.overwrite=${OVERWRITE} \
        corpus.builtin.fetch.force_download=${FORCE_DOWNLOAD}

    ;;
build_simple)

    ekorpkit \
        --config-dir $CONFIG_PATH \
        project=$PROJECT \
        env.distributed_framework.backend=$BACKEND \
        +dataset/simple=${CORPUS_NAME} \
        num_workers=${CPU_N} \
        dataset.simple.fetch.calculate_stats=true \
        dataset.simple.fetch.preprocess_text=${PREPROCESS} \
        dataset.simple.fetch.overwrite=${OVERWRITE} \
        dataset.simple.fetch.force_download=${FORCE_DOWNLOAD}

    ;;
build_t5)

    ekorpkit \
        --config-dir $CONFIG_PATH \
        project=$PROJECT \
        env.distributed_framework.backend=$BACKEND \
        +dataset/t5=${CORPUS_NAME} \
        num_workers=${CPU_N} \
        dataset.t5.fetch.calculate_stats=true \
        dataset.t5.fetch.preprocess_text=${PREPROCESS} \
        dataset.t5.fetch.overwrite=${OVERWRITE} \
        dataset.t5.fetch.force_download=${FORCE_DOWNLOAD}

    ;;
build_t5_all)
    declare -a NAMES=("NCBI-disease"
        "BC4CHEMD"
        "BC2GM"
        "BC5CDR-disease"
        "BC5CDR-chem"
        "JNLPBA"
        "s800"
        "linnaeus"
    )
    for i in "${NAMES[@]}"; do
        echo "$i"
        ekorpkit \
            --config-dir $CONFIG_PATH \
            project=$PROJECT \
            env.distributed_framework.backend=$BACKEND \
            +dataset/t5=${i} \
            num_workers=${CPU_N} \
            dataset.t5.fetch.calculate_stats=true \
            dataset.t5.fetch.preprocess_text=${PREPROCESS} \
            dataset.t5.fetch.overwrite=${OVERWRITE} \
            dataset.t5.fetch.force_download=${FORCE_DOWNLOAD}
    done

    ;;
*)
    echo "not existing command\n"
    usage
    exit
    ;;
esac
