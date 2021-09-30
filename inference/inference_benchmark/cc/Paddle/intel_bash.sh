set -xe
rm -rf build
export LIB_DIR=/mnt/disk500/continuous_integration/inference/inference_benchmark/cc/Paddle/paddle_inference
# export LIB_DIR=/home/li/repo/Paddle/build/paddle_inference_install_dir
bash compile.sh all ON OFF OFF ${LIB_DIR}
bash bin/run_models_benchmark.sh "static" "cpu" "1" "1"
#DNNL_VERBOSE=1 bash bin/run_models_benchmark.sh "static" "cpu" "1" "1"

