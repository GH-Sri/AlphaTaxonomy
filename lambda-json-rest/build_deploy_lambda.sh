#!/bin/bash

build_and_deploy () {
  pushd ./functions/$1
  zip -r9 $1.zip .
  aws lambda update-function-code \
    --function-name $1 \
    --zip-file fileb://./$1.zip
  rm $1.zip
  popd
}

if [[ $# -gt 0 ]]; then

  for file in $@; do
     build_and_deploy $file
  done

else

  for file in ./functions/*/; do
    build_and_deploy "$(basename "${file}")"
  done

fi
