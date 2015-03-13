#!/usr/bin/env zsh
ember build --environment production && rsync -r dist/* seq25:seq25.com
