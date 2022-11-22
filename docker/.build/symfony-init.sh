#!/bin/bash

if [ "$1" = "init" ]; then
  git config --global user.name "$2" && \
  git config --global user.email "$3" && \
  symfony new /home/zing/dev --webapp
else
  mkdir /home/zing/dev
fi
