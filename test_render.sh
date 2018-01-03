#!/bin/bash
#
# Test report render.
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

[[ -f "./test/report.tmp" ]] && rm ./test/report.tmp
python render.py \
--baseline_file './test/test.baseline' \
--result_file './test/test.result' \
--template_file './test/report.html' > "./test/report.tmp"
md1=`md5sum "./test/report.tmp" | cut -d" " -f1`
md2=`md5sum "./test/test.report" | cut -d" " -f1`
rm ./test/report.tmp
[[ "${md1}" != "${md2}" ]] && exit 1
exit 0
