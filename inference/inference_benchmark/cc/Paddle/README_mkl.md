# Paddle-Inference CPU Benchmark

## quick start

### whole process
```shell
# 1. download inference-lib or compile from source codes

# 2. download test codes
git clone https://github.com/PaddlePaddle/continuous_integration.git

# 3. compile test codes
cd continuous_integration/inference/inference_benchmark/cc/Paddle
bash compile.sh all ON OFF OFF /path/of/inference-lib

# 4. prepare python third-party lib
python3.7 -m pip install py3nvml;  # monitor gpu
python3.7 -m pip install cup;      # monitor cpu
python3.7 -m pip install pandas;   # process data
python3.7 -m pip install openpyxl; # process data to excel


# 5. start benchmark tests
bash bin/run_models_benchmark.sh "static" "cpu"

You can find three models performance in log folder
