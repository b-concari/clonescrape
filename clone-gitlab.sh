#!/bin/sh

if [ -z $1 ]
then
    echo "Usage: $0 gitlab-username"
    exit
fi

USER=$1

if [ -d $USER ]
then
    echo "Directory \"$USER\" already exists, not overwriting."
    exit 1
fi

mkdir $USER

curl -s https://gitlab.com/users/$USER/projects.json \
    | jq .html | sed -nE 's/^"(.*)"/\1/; s/\\n/\n/g; s/\\//g; p' \
    | sed -nE 's/^<a class="project" href="\/(.+)"><span class="project-full-name">$/\1/p' \
    | xargs -P10 -I% git clone git@gitlab.com:%.git $USER/%
