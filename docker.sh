#!/bin/bash

function build_and_up() {
    docker-compose up -d --build
    sleep 90
    docker-compose logs
}

function rm() {
    docker-compose rm --stop -f
}

function rm_and_up() {
    rm
    up
}

if [ "$1" == "" ]; then
    build_and_up
elif [ "$1" == "rm" ]; then
    rm
elif [ "$1" == "rm_and_up" ]; then
    rm_and_up
fi