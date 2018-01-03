#!/bin/bash
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
. ./utils.sh

###############################
# Send mail in html format
# Globals:
#   None
# Arguments:
#   mail_attr: Send mail content to list of users.
#   mail_subject: Subject of this mail.
#   html_file: Mail content file in html format.
# Return:
#   None
###############################
function send_mail() {

  local MESSAGE_FILE='./msg.tmp'
  local MAIL_BIN='/usr/sbin/sendmail'
  local num_args=3
  [[ $# -ne ${num_args} ]] && err "Arguments error!" && return ${E_ARG_NUM}

  local mail_addr=$1
  local mail_subject=$2
  local html_file=$3
  [[ -f ${MESSAGE_FILE} ]] && rm ${MESSAGE_FILE}
  echo "To: ${mail_addr}" > ${MESSAGE_FILE}
  echo "Subject: ${mail_subject}" >> ${MESSAGE_FILE}
  echo "Content-Type: text/html" >> ${MESSAGE_FILE}
  echo >> ${MESSAGE_FILE}
  cat ${html_file} >> ${MESSAGE_FILE}

  cat ${MESSAGE_FILE} | ${MAIL_BIN} -t

#  rm ${MESSAGE_FILE}
}

send_mail "${@}"
