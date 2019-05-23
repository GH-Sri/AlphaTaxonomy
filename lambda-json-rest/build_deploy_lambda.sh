#!/bin/bash

build_and_deploy () {
  cd lib/
  ln -s ../functions/$1/lambda_function.py .
  zip -r9 $1.zip .
  aws lambda update-function-code \
    --function-name $1 \
    --zip-file fileb://./$1.zip
  rm lambda_function.py
  rm $1.zip
  cd ..
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
