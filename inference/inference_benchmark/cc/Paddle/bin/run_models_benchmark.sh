#!/usr/bin/env bash

set -eo pipefail

ROOT=`dirname "$0"`
ROOT=`cd "$ROOT/.."; pwd`
export OUTPUT=$ROOT/output
export OUTPUT_BIN=$ROOT/build
export DATA_ROOT=$ROOT/Data
export CASE_ROOT=$ROOT/bin
export LOG_ROOT=$ROOT/log
export gpu_type=`nvidia-smi -q | grep "Product Name" | head -n 1 | awk '{print $NF}'`

# test model type
model_type="static"
if [ $# -ge 1 ]; then
    model_type=$1
fi
export MODEL_TYPE=${model_type}

# test run-time device
device_type="gpu"
if [ $# -ge 2 ]; then
    device_type=$2
fi

mkdir -p $DATA_ROOT
cd $DATA_ROOT
if [ ! -f PaddleClas/infer_static/AlexNet/__model__ ]; then
    echo "==== Download PaddleClas data and models ===="
    wget --no-proxy -q https://sys-p0.bj.bcebos.com/Paddle-UnitTest-Model/PaddleClas.tgz --no-check-certificate
    tar -zxf PaddleClas.tgz
fi

if [ ! -f PaddleDetection/infer_static/yolov3_darknet/__model__ ]; then
    echo "==== Download PaddleDetection data and models ===="
    wget --no-proxy -q https://sys-p0.bj.bcebos.com/Paddle-UnitTest-Model/PaddleDetection.tgz --no-check-certificate
    tar -zxf PaddleDetection.tgz
fi

if [ ! -f PaddleOCR/ch_ppocr_mobile_v1.1_cls_infer/model ]; then
    echo "==== Download PaddleOCR data and models ===="
    wget --no-proxy -q https://sys-p0.bj.bcebos.com/Paddle-UnitTest-Model/PaddleOCR.tgz --no-check-certificate
    tar -zxf PaddleOCR.tgz
fi

if [ ! -f PaddleSeg/infer_static/deeplabv3p/__model__ ]; then
    echo "==== Download PaddleSeg data and models ===="
    wget --no-proxy -q https://sys-p0.bj.bcebos.com/Paddle-UnitTest-Model/PaddleSeg.tgz --no-check-certificate
    tar -zxf PaddleSeg.tgz
fi

cd -

mkdir -p $LOG_ROOT

echo "==== run ${MODEL_TYPE} model benchmark ===="

if [ "${MODEL_TYPE}" == "static" ]; then
    if [ "${device_type}" == "gpu" ]; then
        bash $CASE_ROOT/run_clas_gpu_trt_benchmark.sh "${DATA_ROOT}/PaddleClas/infer_static"
        bash $CASE_ROOT/run_det_gpu_trt_benchmark.sh "${DATA_ROOT}/PaddleDetection/infer_static"
        bash $CASE_ROOT/run_clas_int8_benchmark.sh "${DATA_ROOT}/PaddleClas/infer_static"
        bash $CASE_ROOT/run_det_int8_benchmark.sh "${DATA_ROOT}/PaddleDetection/infer_static"
    elif [ "${device_type}" == "cpu" ]; then 
        # Bind threads to cores
        export KMP_AFFINITY=granularity=fine,compact,1,0
        export KMP_BLOCKTIME=1
        # no_turbo 1 means turning off turbo, it was set to save power. no_turbo 0 means turning on turbo which will improve some performance
        # echo 1 | sudo tee /sys/devices/system/cpu/intel_pstate/no_turbo

        bash $CASE_ROOT/run_clas_mkl_benchmark.sh "${DATA_ROOT}/PaddleClas/infer_static"
        # bash $CASE_ROOT/run_det_mkl_benchmark.sh "${DATA_ROOT}/PaddleDetection/infer_static"  # very slow
    fi
elif [ "${MODEL_TYPE}" == "dy2static" ]; then
    bash $CASE_ROOT/run_clas_gpu_trt_benchmark.sh "${DATA_ROOT}/PaddleClas/infer_dygraph"
    # bash $CASE_ROOT/run_dy2staic_det_gpu_trt_benchmark.sh
fi


