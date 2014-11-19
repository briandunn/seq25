feature 'Feature: user note actions must be constrained'

test 'change beats with keyboard', ->

  assertMeasureWidth("6.25%")
  press("2, 0, b")
  assertMeasureWidth("5%")

test 'change beats with keyboard should change note width', ->

  press("c")
  assertWidth("6.25%")
  press("2, 0, b")
  assertMeasureWidth("5%")

assertMeasureWidth = (w) ->
  andThen ->
    equal(width(".measure"), w)
