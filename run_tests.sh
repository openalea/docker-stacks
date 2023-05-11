#!/bin/bash

# Usage: docker run -w /opt/test -v $PWD:/opt/test openalea/notebook-openalea:latest ./run_tests.sh notebook-openalea
echo "Testing docker image {$1}..."

# Install pytest on top of existing environment
pip install pytest 

pytest -v tests/test_all.py tests/test_$1.py

#EOF
