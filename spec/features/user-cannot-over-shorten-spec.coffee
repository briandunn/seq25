feature 'Feature: user note actions must be constrained'

test 'cannot shorten note to 0', ->
  press("c")
  assertWidth("6.25%")
  press("shift+left")
  assertWidth("6.25%")

test 'cannot move note to < 0', ->
  press("c")
  assertLeft("0%")
  press("left")
  assertLeft("0%")
