# prepare python third-party lib
#python3.7 -m pip install py3nvml;  # monitor gpu
#python3.7 -m pip install cup;      # monitor cpu
#python3.7 -m pip install pandas;   # process data
#python3.7 -m pip install openpyxl; # process data to excel
rm -rf build
export LIB_DIR=/home/li/repo/Paddle/build_debug_9e54209/paddle_inference_install_dir
#export LIB_DIR=/mnt/disk500/continuous_integration/inference/inference_benchmark/cc/Paddle/paddle_inference
bash compile.sh all ON OFF OFF ${LIB_DIR}
# bash bin/run_models_benchmark.sh "static" "cpu" "1" "1"
#DNNL_VERBOSE=1 bash bin/run_models_benchmark.sh "static" "cpu" "1" "1"
bash bin/run_models_benchmark.sh "static" "cpu" "1" "1"

