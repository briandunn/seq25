#!/usr/bin/env zsh
git branch -D heroku
git subtree split --prefix backend -b heroku
git push -f heroku heroku:master
