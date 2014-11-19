feature 'Feature: user moves note'

test 'move note when is quant is 0', ->

  press("2, 0, b")
  press("c")
  press("0, x")

  andThen ->
    equal(find("input#quant").val(), "0")

  assertLeft("0%")

  press("right")

  andThen ->
    value = left(".notes li")
    equal(value[0..4], "0.052")
