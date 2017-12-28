#!/bin/bash
#
# Test analysis script.
#
# Copyright (c) 2016 PaddlePaddle Authors. All Rights Reserved
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -ex

readonly TMP_INPUT='test.input'
readonly TMP_OUTPUT='test.output'
readonly VALUE_1=0.9224290251731873
readonly VALUE_2=0.009999999776482582
readonly VALUE_3=727.45

echo "[INFO 2017-12-27 11:24:18,099 train.py:134] Pass 8, Batch 200, Cost 0.083624, {'__auc_evaluator_0__': 0.9979991912841797, 'classification_error_evaluator': 0.05000000074505806}" >> ${TMP_INPUT}
echo "[INFO 2017-12-27 11:25:03,177 train.py:140] Test at Pass 8, {'__auc_evaluator_0__': 0.9241431355476379, 'classification_error_evaluator': 0.15136000514030457}" >> ${TMP_INPUT}
echo "[INFO 2017-12-27 11:25:30,909 train.py:134] Pass 9, Batch 200, Cost 0.057055, {'__auc_evaluator_0__': 0.9995999932289124, 'classification_error_evaluator': 0.009999999776482582}" >> ${TMP_INPUT}
echo "[INFO 2017-12-27 11:26:16,845 train.py:140] Test at Pass 9, {'__auc_evaluator_0__': "${VALUE_1}", 'classification_error_evaluator': "${VALUE_2}"}" >> ${TMP_INPUT}
echo "[INFO 2017-12-27 11:26:17,005 train.py:152] Training has finished." >> ${TMP_INPUT}
echo "time=123" >> ${TMP_INPUT}
echo "metric:time="${VALUE_3} >> ${TMP_INPUT}
echo "time=123" >> ${TMP_INPUT}

cat ${TMP_INPUT} | python analysis.py > ${TMP_OUTPUT}
source ${TMP_OUTPUT}
rm ${TMP_INPUT} ${TMP_OUTPUT}
[[ ${__auc_evaluator_0__} == ${VALUE_1} ]] \
&& [[ ${classification_error_evaluator} == ${VALUE_2} ]] \
&& [[ ${time} == ${VALUE_3} ]] \
|| exit 1
