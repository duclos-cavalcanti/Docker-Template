#!/bin/bash

## Set ENV variables

## Set Git Config
# git config --global
# git config --global
# git config --global

## Exec shell
set +xe
echo "## Running Docker Entrypoint ##"
cd test/build && cmake .. && make \
                          && make report \
                          && make coverage \
                          && make specs
# uncomment this to make docker run bash shell after execution, (debugging)
# bash
