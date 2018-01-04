#!/bin/bash
# Run once test
# 1. Pull paddle and install paddle
# 2. Pull models
# 3. Run models one by one
# 4. Generate analysis report
# 5. Send report email

set -ex
readonly MODELS_PATH=`pwd`'/models'
readonly CONFIG_FILE='baseline/configs'
readonly LOG_PATH='baseline'
readonly MODEL_REPORT='report'
readonly FINAL_REPORT='reports'

mail_addr="wanghaoshuang@baidu.com"
mail_subject="paddle_models_test_"`date +%Y%m%d`

# install paddle
./build_install_paddle.sh 'WITH_GPU=OFF WITH_AVX=ON WITH_TESTING=OFF RUN_TEST=OFF PYTHON_ABI=cp27-cp27mu'

# pull models
./pull_models.sh './models'

echo ${mail_subject} > ${MODELS_PATH}/${FINAL_REPORT}
for dir in `ls ${MODELS_PATH}`; do
  model_path=${MODELS_PATH}/${dir}
  if [ -d ${model_path} -a -f ${model_path}/${CONFIG_FILE} ]; then
    # run model
    ./run_model.sh ${model_path} ${model_path}/${CONFIG_FILE} ${model_path}/${LOG_PATH}
    # collect report from each model
    cat ${model_path}/${LOG_PATH}/${MODEL_REPORT} >> ${MODELS_PATH}/${FINAL_REPORT}
  fi
done

./sendmail.sh ${mail_addr} ${mail_subject} ${MODELS_PATH}/${FINAL_REPORT}
