#!/bin/bash

## Set ENV variables

## Set Git Config
# git config --global
# git config --global
# git config --global

## Exec shell
set +xe
echo "## Building Project ##"
cd test/build && cmake .. && make \
                          && make report \
                          && make coverage \
                          && make specs
