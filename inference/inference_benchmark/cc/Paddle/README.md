
rm -rf build
bash compile.sh clas_benchmark ON OFF OFF ${LIB_DIR}
DNNL_VERBOSE=1 bash bin/run_models_benchmark.sh "static" "cpu"

