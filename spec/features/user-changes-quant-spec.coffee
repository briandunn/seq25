feature 'Feature: User changes quant'

test 'change quant with keyboard', ->

  press("2, x")
  press("c")
  assertLeft("0%")

  press("2, 0, b")

  assertLeft("0%")

  press("right")

  assertLeft("2.5%")
