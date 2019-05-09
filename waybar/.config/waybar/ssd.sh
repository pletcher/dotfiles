#!/usr/bin/env sh

df --output=pcent -h $1 | tail -n 1
