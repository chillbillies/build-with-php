#!/bin/bash

if [ "$1" = "init" ]; then
  git config --global user.name "$2" && \
  git config --global user.email "$3" && \
  git config --global init.defaultBranch main && \
  symfony new /home/chill/dev --webapp
else
  mkdir /home/chill/dev
fi
