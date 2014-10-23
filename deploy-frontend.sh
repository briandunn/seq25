#!/usr/bin/env zsh
lineman build && rsync -r dist/* seq25:seq25.com
