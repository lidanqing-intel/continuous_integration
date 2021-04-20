# Paddle-Inference CPU Benchmark

## quick start

### Compile from source codes
```shell
# Since the performance drop happens after merging "Upgade oneDNN to oneDNN v2.2" commit, We have to build from source

# 1.1 Compile PaddlePaddle v2.0.1 (which use oneDNN v1.6)
git clone https://github.com/PaddlePaddle/Paddle.git
git checkout tags/v2.0.1 -b v2.0.1
mkdir build_v2.0.1 && cd build_v2.0.1
cmake -DCMAKE_BUILD_TYPE=Release \
      -DWITH_GPU=OFF \
      -DWITH_AVX=ON \
      -DWITH_DISTRIBUTE=OFF \
      -DWITH_MKLDNN=ON \
      -DON_INFER=ON \
      -DWITH_TESTING=ON \
      -DWITH_INFERENCE_API_TEST=OFF \
      -DWITH_NCCL=OFF \
      -DWITH_PYTHON=ON \
      -DPY_VERSION=3.6 \
      -DWITH_LITE=OFF ..
make -j 12
make -j 12 inference_lib_dist
export LIB_DIR=/Paddle/build_v2.0.1/paddle_inference_install_dir


# 1.2 Compile PaddlePaddle v2.0.1 + upgrading oneDNN v2.2 commit
git cherry-pick 35ed56b54725a5ed9c71cebd7675f17b5b19d27e
git check -b v2.0.1_oneDNN2.2
mkdir build_oneDNN2.2 && cd build_oneDNN2
cmake -DCMAKE_BUILD_TYPE=Release \
      -DWITH_GPU=OFF \
      -DWITH_AVX=ON \
      -DWITH_DISTRIBUTE=OFF \
      -DWITH_MKLDNN=ON \
      -DON_INFER=ON \
      -DWITH_TESTING=ON \
      -DWITH_INFERENCE_API_TEST=OFF \
      -DWITH_NCCL=OFF \
      -DWITH_PYTHON=ON \
      -DPY_VERSION=3.6 \
      -DWITH_LITE=OFF ..
make -j 12
make -j 12 inference_lib_dist
export LIB_DIR=/Paddle/v2.0.1_oneDNN2.2/paddle_inference_install_dir
```

### 2. download test codes
```
git clone https://github.com/PaddlePaddle/continuous_integration.git
git checkout Issue_oneDNN2.2_drop -b Issue_oneDNN2.2_drop
```
### 3. compile test codes
```
cd continuous_integration/inference/inference_benchmark/cc/Paddle
bash compile.sh all ON OFF OFF $LIB_DIR
```
### 4. prepare python third-party lib
```
python3.7 -m pip install py3nvml;  # monitor gpu
python3.7 -m pip install cup;      # monitor cpu
python3.7 -m pip install pandas;   # process data
python3.7 -m pip install openpyxl; # process data to excel
```

### 5. start benchmark tests
```
bash bin/run_models_benchmark.sh "static" "cpu"
```
### 6. Find the performance log
You can find three models performance in log folder
